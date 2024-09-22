import 'package:flutter/material.dart';
import 'package:flutter_firebase/core/firebase_helpers/firebase_auth/firebase_phone_auth/firebase_phone_auth_helper.dart';
import 'package:flutter_firebase/core/getit/getit_init.dart';

class FirebasePhoneAuthPage extends StatefulWidget {
  const FirebasePhoneAuthPage({super.key});

  @override
  State<FirebasePhoneAuthPage> createState() => _FirebasePhoneAuthPageState();
}

class _FirebasePhoneAuthPageState extends State<FirebasePhoneAuthPage> {
  final TextEditingController _phoneNumberController = TextEditingController();
  late final FirebasePhoneAuthHelper _firebasePhoneAuthHelper;

  @override
  void initState() {
    super.initState();
    _firebasePhoneAuthHelper = getit<FirebasePhoneAuthHelper>();
  }

  @override
  void dispose() {
    _phoneNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Firebase phone auth page"),
      ),
      body: ListView(
        padding: const EdgeInsets.all(10),
        children: [
          TextField(
            controller: _phoneNumberController,
            keyboardType: TextInputType.phone,
            decoration: const InputDecoration(hintText: "Phone number"),
          ),
          const SizedBox(height: 10),
          TextButton(
            onPressed: () async {
              await _firebasePhoneAuthHelper.verifyPhoneNumber(
                _phoneNumberController.text.trim(),
                context,
              );
            },
            child: const Text("Verify"),
          ),
        ],
      ),
    );
  }
}
