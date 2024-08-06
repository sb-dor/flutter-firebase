import 'package:flutter/material.dart';
import 'package:flutter_firebase/core/firebase_helpers/firebase_auth/firebase_default_auth/firebase_default_auth_helper.dart';
import 'package:flutter_firebase/core/getit/getit_init.dart';

class FirebaseAuthDefaultAuthPage extends StatefulWidget {
  const FirebaseAuthDefaultAuthPage({super.key});

  @override
  State<FirebaseAuthDefaultAuthPage> createState() => _FirebaseAuthDefaultAuthPageState();
}

class _FirebaseAuthDefaultAuthPageState extends State<FirebaseAuthDefaultAuthPage> {
  final FirebaseDefaultAuthHelper _firebaseDefaultAuthHelper = getit<FirebaseDefaultAuthHelper>();

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
