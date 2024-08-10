import 'dart:convert'; // Import for encoding and decoding UTF-8 strings
import 'dart:math'; // Import for random number generation
import 'package:crypto/crypto.dart'; // Import for hashing operations
import 'package:firebase_auth/firebase_auth.dart'; // Import for Firebase authentication
import 'package:flutter/foundation.dart'; // Import for determining platform type
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart'; // Import for Facebook authentication
import 'package:flutter_firebase/core/getit/getit_init.dart'; // Import for dependency injection
import 'package:flutter_firebase/core/shared_pref/shared_pref.dart'; // Import for shared preferences utility

class FirebaseFacebookAuthHelper {
  // Initialize FacebookAuth instance
  final FacebookAuth _faceBookAuth = FacebookAuth.instance;

  // Initialize FirebaseAuth instance
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  // Initialize SharedPref instance using dependency injection
  final SharedPref _sharedPref = getit<SharedPref>();

  // Stream to track changes in the authentication state of the user
  Stream<User?> userChanges() async* {
    yield* _firebaseAuth.userChanges();
  }

  // Generate SHA-256 hash of a given input string
  String sha256ofString(String input) {
    final bytes = utf8.encode(input); // Convert the input to UTF-8 bytes
    final digest = sha256.convert(bytes); // Generate SHA-256 hash
    return digest.toString(); // Convert hash to string and return
  }

  // Generate a cryptographically secure nonce with a given length
  String generateNonce([int length = 32]) {
    const charset =
        '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-.'; // Character set for the nonce
    final random = Random.secure(); // Secure random number generator

    // Generate a random string of specified length using characters from charset
    return String.fromCharCodes(
      List.generate(
        length,
        (index) => charset.codeUnitAt(
          random.nextInt(charset.length),
        ),
      ),
    );
  }

  // Handle Facebook sign-in based on platform (iOS or other)
  Future<void> facebookPlatformSignIn() async {
    if (defaultTargetPlatform == TargetPlatform.iOS) {
      await _facebookIOSSignIn(); // Sign-in for iOS platform
    } else {
      await _facebookSignIn(); // Sign-in for other platforms
    }
  }

  // Check Facebook authentication status
  Future<void> facebookPlatformCheckAuth() async {
    await _checkAuth();
  }

  // Handle Facebook sign-in for iOS platform
  Future<void> _facebookIOSSignIn() async {
    final rawNonce = generateNonce(); // Generate a secure nonce
    final nonce = sha256ofString(rawNonce); // Hash the nonce using SHA-256

    // Trigger the Facebook login flow with limited login tracking and nonce
    final LoginResult loginResult = await _faceBookAuth.login(
      loginTracking: LoginTracking.limited,
      nonce: nonce,
    );

    // Fetch user data after successful login
    final userData = await FacebookAuth.instance.getUserData();

    if (loginResult.status == LoginStatus.failed || loginResult.status == LoginStatus.cancelled) {
      return; // Exit if login fails or is cancelled
    }

    if (loginResult.accessToken?.tokenString == null) return; // Exit if access token is null

    final token = loginResult.accessToken; // Extract the access token

    if (token == null) return;

    // Create OAuthCredential using the access token and raw nonce
    OAuthCredential credential = OAuthCredential(
      providerId: 'facebook.com',
      signInMethod: 'oauth',
      idToken: token.tokenString,
      rawNonce: rawNonce,
    );

    // Save Facebook token to shared preferences
    await _sharedPref.saveString(
      key: "facebook_token",
      value: token.tokenString,
    );

    // Sign in to Firebase with the Facebook credential
    await _firebaseAuth.signInWithCredential(credential);
  }

  // Handle Facebook sign-in for non-iOS platforms
  Future<void> _facebookSignIn() async {
    final LoginResult loginResult =
        await FacebookAuth.instance.login(); // Trigger the Facebook login flow

    // Fetch user data after successful login
    final userData = await FacebookAuth.instance.getUserData();

    if (loginResult.accessToken == null) return; // Exit if access token is null

    // Save Facebook access token to shared preferences
    await _sharedPref.saveString(
      key: "facebook_access_token",
      value: loginResult.accessToken!.tokenString,
    );

    // Create OAuthCredential using the access token
    final OAuthCredential facebookAuthCredential = FacebookAuthProvider.credential(
      loginResult.accessToken!.tokenString,
    );

    // Sign in to Firebase with the Facebook credential
    await _firebaseAuth.signInWithCredential(facebookAuthCredential);
  }

  // Check if the user is authenticated with Facebook
  Future<void> _checkAuth() async {
    try {
      if (_firebaseAuth.currentUser != null) return; // Exit if user is already signed in

      final token =
          _sharedPref.getStringByKey(key: 'facebook_token'); // Retrieve saved Facebook token

      if (token == null) return; // Exit if no token is found

      final credential = FacebookAuthProvider.credential(token); // Create credential from token

      await _firebaseAuth.signInWithCredential(credential); // Sign in to Firebase with credential

      debugPrint("User authenticated successfully");
    } catch (e) {
      debugPrint("Authentication error: $e"); // Log authentication error
    }
  }

  // Sign out from both Firebase and Facebook
  Future<void> signOut() async {
    await _firebaseAuth.signOut(); // Sign out from Firebase
    await _faceBookAuth.logOut(); // Log out from Facebook
    await _sharedPref.deleteByKey(
        key: "facebook_token"); // Remove saved Facebook token from shared preferences
  }
}
