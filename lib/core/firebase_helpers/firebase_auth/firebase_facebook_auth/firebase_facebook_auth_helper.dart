import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_firebase/core/getit/getit_init.dart';
import 'package:flutter_firebase/core/shared_pref/shared_pref.dart';

class FirebaseFacebookAuthHelper {
  final FacebookAuth _faceBookAuth = FacebookAuth.instance;

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  final SharedPref _sharedPref = getit<SharedPref>();

  Stream<User?> userChanges() async* {
    yield* _firebaseAuth.userChanges();
  }

  Future<void> facebookSignIn() async {
    // Trigger the sign-in flow
    final LoginResult loginResult = await _faceBookAuth.login();

    if (loginResult.status == LoginStatus.failed || loginResult.status == LoginStatus.cancelled) {
      return;
    }

    if (loginResult.accessToken?.tokenString == null) return;

    await _sharedPref.saveString(
      key: "facebook_token",
      value: loginResult.accessToken!.tokenString,
    );
    // Create a credential from the access token
    final OAuthCredential facebookOAuthCredential = FacebookAuthProvider.credential(
      loginResult.accessToken!.tokenString,
    );

    await _firebaseAuth.signInWithCredential(facebookOAuthCredential);
  }

  Future<void> checkAuth() async {
    try {
      final token = _sharedPref.getStringByKey(key: 'facebook_token');

      if (token == null) return;

      final OAuthCredential facebookOAuthCredential = FacebookAuthProvider.credential(
        token,
      );

      await _firebaseAuth.signInWithCredential(facebookOAuthCredential);
    } catch (e) {
      debugPrint("error is $e");
    }
  }
}
