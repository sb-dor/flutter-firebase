import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class FirebasePhoneAuthHelper {
  //
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<void> verifyPhoneNumber(String phoneNumber, {String? code}) async {
    _firebaseAuth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) async {
        debugPrint("credential smsCode: ${credential.smsCode}");
        debugPrint("credential accessToken: ${credential.accessToken}");
      },
      verificationFailed: (FirebaseAuthException exception) {},
      codeSent: (String verificationId, int? resendToken) async {
        if (code == null) return;
        // Update the UI - wait for the user to enter the SMS code

        // Create a PhoneAuthCredential with the code
        PhoneAuthCredential credential = PhoneAuthProvider.credential(
          verificationId: verificationId,
          smsCode: code,
        );

        // Sign the user in (or link) with the credential
        await _firebaseAuth.signInWithCredential(credential);
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }
//
}
