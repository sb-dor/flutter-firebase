import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FirebasePhoneAuthHelper {
  //
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<void> verifyPhoneNumber(
    String phoneNumber,
    BuildContext context,
  ) async {
    await _firebaseAuth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) async {
        debugPrint("credential smsCode: ${credential.smsCode}");
        debugPrint("credential accessToken: ${credential.accessToken}");
      },
      verificationFailed: (FirebaseAuthException exception) {},
      codeSent: (String verificationId, int? resendToken) async {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text("Verify code"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    decoration: const InputDecoration(hintText: "Code here"),
                    onSubmitted: (v) {
                      if (v.trim().isEmpty) return;
                      Navigator.pop(context);
                      final phoneCred = PhoneAuthProvider.credential(
                        verificationId: verificationId,
                        smsCode: v.trim(),
                      );
                      _firebaseAuth.signInWithCredential(phoneCred);
                    },
                  )
                ],
              ),
            );
          },
        );
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        debugPrint('codeAutoRetrievalTimeout: $verificationId');
      },
    );
  }
//
}
