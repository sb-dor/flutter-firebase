import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_firebase/core/getit/getit_init.dart';
import 'package:flutter_firebase/core/shared_pref/shared_pref.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FirebaseGoogleAuthHelper {
  // Google sign-in instance
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  // Firebase Auth instance
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  // Shared preferences instance
  final SharedPref _sharedPref = getit<SharedPref>();

  // Stream for user changes
  // https://firebase.flutter.dev/docs/auth/start#userchanges
  Stream<User?> userChanges() async* {
    yield* _firebaseAuth.userChanges();
  }

  // Sign in with Google
  Future<void> signInWithGoogle() async {
    // Try to sign in with Google
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      // If the user cancels the sign-in process, return
      if (googleUser == null) return;

      // Get Google authentication object
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      // Save access token to shared preferences
      if (googleAuth.accessToken != null) {
        await _sharedPref.saveString(
          key: "google_auth_access_token",
          value: googleAuth.accessToken!,
        );
      }

      // Save ID token to shared preferences
      if (googleAuth.idToken != null) {
        await _sharedPref.saveString(
          key: "google_auth_id_token",
          value: googleAuth.idToken!,
        );
      }

      // Create a new credential using the tokens
      final OAuthCredential googleAuthCredential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase with the new credential
      await _firebaseAuth.signInWithCredential(googleAuthCredential);
    } catch (e) {
      // Print any errors that occur
      debugPrint("error is $e");
    }
  }

  // Check authentication status
  Future<void> checkAuth() async {
    try {
      // Get access token from shared preferences
      String? accessToken = _sharedPref.getStringByKey(
        key: 'google_auth_access_token',
      );

      // Get ID token from shared preferences
      String? idToken = _sharedPref.getStringByKey(
        key: "google_auth_id_token",
      );

      // Create a new credential using the tokens
      OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: accessToken,
        idToken: idToken,
      );

      // Sign in to Firebase with the new credential
      await _firebaseAuth.signInWithCredential(credential);
    } catch (e) {
      // Print any errors that occur and refresh the token
      debugPrint("checkAuth error is : $e");
      await refreshToken();
    }
  }

  // Refresh authentication token
  Future<void> refreshToken() async {
    // If the user is currently signed in
    if (_firebaseAuth.currentUser != null) {
      try {
        // Try to silently sign in with Google
        final GoogleSignInAccount? googleUser = await _googleSignIn.signInSilently();

        // If the user cancels the sign-in process, return
        if (googleUser == null) return;

        // Get Google authentication object
        final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

        // Save access token to shared preferences
        await _sharedPref.saveString(
          key: "google_access_token",
          value: googleAuth.accessToken!,
        );

        // Save ID token to shared preferences
        await _sharedPref.saveString(
          key: "google_id_token",
          value: googleAuth.idToken!,
        );
      } catch (e) {
        // Print any errors that occur
        debugPrint("error is $e");
      }
    }
  }

  Future<void> logOut() async {
    await _googleSignIn.signOut();
  }
}
