import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
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

  String sha256ofString(String input) {
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  String generateNonce([int length = 32]) {
    // Define the character set to be used in the nonce
    const charset = '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-.';

    // Create a secure random number generator
    final random = Random.secure();

    // Generate a string of the specified length using random characters from the charset
    return String.fromCharCodes(
      List.generate(
        length,
        (index) => charset.codeUnitAt(
          random.nextInt(charset.length),
        ),
      ),
    );
  }

  Future<void> facebookPlatformSignIn() async {
    // if (defaultTargetPlatform == TargetPlatform.iOS) {
    // await _facebookIOSSignIn();
    // } else {
    await _facebookSignIn();
    // }
  }

  Future<void> facebookPlatformCheckAuth() async {}

  Future<void> _facebookIOSSignIn() async {
    // Trigger the sign-in flow

    final rawNonce = generateNonce();

    final nonce = sha256ofString(rawNonce);

    final LoginResult loginResult = await _faceBookAuth.login(
      loginTracking: LoginTracking.limited,
      nonce: nonce,
    );

    if (loginResult.status == LoginStatus.failed || loginResult.status == LoginStatus.cancelled) {
      return;
    }

    if (loginResult.accessToken?.tokenString == null) return;

    // Create a credential from the access token

    final token = loginResult.accessToken;

    if (token == null) return;
    // Create a credential from the access token
    OAuthCredential credential = OAuthCredential(
      providerId: 'facebook.com',
      signInMethod: 'oauth',
      idToken: token.tokenString,
      rawNonce: rawNonce,
    );

    await _sharedPref.saveString(
      key: "facebook_token",
      value: token.tokenString,
    );

    await _firebaseAuth.signInWithCredential(credential);
  }

  Future<void> _facebookSignIn() async {
    // Trigger the sign-in flow
    final LoginResult loginResult = await FacebookAuth.instance.login();

    if (loginResult.accessToken == null) return;
    // Create a credential from the access token
    final OAuthCredential facebookAuthCredential = FacebookAuthProvider.credential(
      loginResult.accessToken!.tokenString,
    );

    // Once signed in, return the UserCredential
    await _firebaseAuth.signInWithCredential(facebookAuthCredential);
  }

  // don't check auth like
  // however it's not a good code for checking auth
  // use the code above
  // because if you will sign in with the same credential
  // it will throw an error
  Future<void> _iosCheckAuth() async {
    try {
      if (_firebaseAuth.currentUser != null) return;

      final token = _sharedPref.getStringByKey(key: 'facebook_token');

      if (token == null) return;

      final rawNonce = generateNonce();

      OAuthCredential credential = OAuthCredential(
        providerId: 'facebook.com',
        signInMethod: 'oauth',
        idToken: token,
        rawNonce: rawNonce,
      );

      await _firebaseAuth.signInWithCredential(credential);

      debugPrint("getting inside");
    } catch (e) {
      debugPrint("error is $e");
    }
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
    await _faceBookAuth.logOut();
  }
}
