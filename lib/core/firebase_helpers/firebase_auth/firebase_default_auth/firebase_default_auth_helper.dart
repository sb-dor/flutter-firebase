import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_firebase/core/getit/getit_init.dart';
import 'package:flutter_firebase/core/shared_pref/shared_pref.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FirebaseDefaultAuthHelper {
  final FirebaseAuth _firebaseDefaultAuth = FirebaseAuth.instance;

  final SharedPref _sharedPref = getit<SharedPref>();

  // Firebase Auth provides many methods and utilities for enabling you to integrate secure
  // authentication into your new or existing Flutter application. In many cases, you will need
  // to know about the authentication state of your user, such as whether they're logged in or logged out.

  // There are three methods for listening to authentication state changes:

  // authStateChanges()
  // https://firebase.flutter.dev/docs/auth/start#authstatechanges
  Stream<User?> authStateChanges() async* {
    yield* _firebaseDefaultAuth.authStateChanges();
  }

  // idTokenChanges()
  // https://firebase.flutter.dev/docs/auth/start#idtokenchanges
  Stream<User?> idTokenChanges() async* {
    yield* _firebaseDefaultAuth.idTokenChanges();
  }

  // userChanges()
  // https://firebase.flutter.dev/docs/auth/start#userchanges
  Stream<User?> userChanges() async* {
    yield* _firebaseDefaultAuth.userChanges();
  }

  // get user information
  User? getCurrentUser() {
    final currentUser = _firebaseDefaultAuth.currentUser;
    // temp variables
    final name = currentUser?.displayName;
    final email = currentUser?.email;
    final photoUrl = currentUser?.photoURL;

    // check whether user email is verified or not
    final emailVerified = currentUser?.emailVerified;

    // user's uid
    final uid = currentUser?.uid;

    return currentUser;
  }

  // USER REGISTRATION

  // REGISTRATION WITH EMAIL AND PASSWORD
  Future<void> registrationWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    // if the new account was created successfully, the user is also signed in. If you are listening
    // to changes in authentication state, a new event will be sent to your listeners.
    try {
      final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (credential.credential == null) return;

      await _sharedPref.saveString(
        key: "cred_sign_in_method",
        value: credential.credential!.signInMethod,
      );

      await _sharedPref.saveString(
        key: "cred_provider_id",
        value: credential.credential!.providerId,
      );

      //
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        debugPrint('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        debugPrint('The account already exists for that email.');
      }
    } catch (e) {
      debugPrint("$e");
    }
  }

  // SIGN IN WITH EMAIL AND PASSWORD
  Future<void> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (credential.credential == null) return;

      await getit<SharedPref>().saveString(
        key: "cred_sign_in_method",
        value: credential.credential!.signInMethod,
      );

      await getit<SharedPref>().saveString(
        key: "cred_provider_id",
        value: credential.credential!.providerId,
      );

      //
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        debugPrint('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        debugPrint('Wrong password provided for that user.');
      }
    } catch (e) {
      debugPrint("$e");
    }
  }

  // CHECK AUTH WITH LATEST LOCAL SAVED CREDENTIALS DATA IN ORDER TO
  // BE 100% SURE THAT USER SIGNED UP
  Future<void> checkAuth() async {
    try {
      final signInMethod = _sharedPref.getStringByKey(key: "cred_sign_in_method");
      final providerId = _sharedPref.getStringByKey(key: "cred_provider_id");

      if (signInMethod == null || providerId == null) return;

      await _firebaseDefaultAuth.signInWithCredential(
        AuthCredential(
          providerId: providerId,
          signInMethod: signInMethod,
        ),
      );

      //
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        debugPrint('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        debugPrint('Wrong password provided for that user.');
      }
    } catch (e) {
      debugPrint("$e");
    }
  }

  // IF YOU WANT TO USER EMAIL VERIFICATION AFTER SIGN IN
  // CHECK WHETHER USER PASSED VERIFICATION FIRST
  bool checkVerification() {
    return _firebaseDefaultAuth.currentUser?.emailVerified ?? false;
  }

  // SEND EMAIL VERIFICATION TO USER
  Future<void> sendEmailVerification() async {
    await _firebaseDefaultAuth.currentUser?.sendEmailVerification();
  }

  // SIGN OUT
  Future<void> signOut() async {
    await _firebaseDefaultAuth.signOut();
  }

  //
  //
  //
  //
  //
  //
  // UPDATING USER DATA

  // UPDATING USER's NAME
  Future<void> updateUserName(String name) async {
    // get user
    await _firebaseDefaultAuth.currentUser?.updateDisplayName(name);
  }

  // UPDATING USER's PHOTO
  Future<void> updateUserPhoto(String url) async {
    await _firebaseDefaultAuth.currentUser?.updatePhotoURL(url);
  }

  // UPDATING USER's EMAIL
  Future<void> updateUserEmail(String email) async {
    // before changing user's email this function will send code to a new email of user
    // you have to verify and login again after verification
    await _firebaseDefaultAuth.currentUser?.verifyBeforeUpdateEmail(email);
  }

  // UPDATE USER's password
  Future<void> updateUserPassword(String password) async {
    await _firebaseDefaultAuth.currentUser?.updatePassword(password);
  }

  // DELETE USER
  Future<void> deleteUser() async {
    await _firebaseDefaultAuth.currentUser?.delete();
  }
}
