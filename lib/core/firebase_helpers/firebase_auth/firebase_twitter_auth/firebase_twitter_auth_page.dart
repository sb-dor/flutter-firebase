import 'package:flutter/material.dart';
import 'package:flutter_firebase/core/firebase_helpers/firebase_auth/firebase_twitter_auth/firebase_twitter_auth_helper.dart';
import 'package:flutter_firebase/core/getit/getit_init.dart';

class FirebaseTwitterAuthPage extends StatefulWidget {
  const FirebaseTwitterAuthPage({super.key});

  @override
  State<FirebaseTwitterAuthPage> createState() => _FirebaseTwitterAuthPageState();
}

class _FirebaseTwitterAuthPageState extends State<FirebaseTwitterAuthPage> {
  late FirebaseTwitterAuthHelper _firebaseTwitterAuthHelper;

  @override
  void initState() {
    super.initState();
    _firebaseTwitterAuthHelper = getit<FirebaseTwitterAuthHelper>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}
