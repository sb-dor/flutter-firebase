import 'package:flutter/material.dart';
import 'package:flutter_firebase/core/firebase_helpers/firebase_messaging/firebase_messaging_helper.dart';

class FirebaseMessagingPage extends StatefulWidget {
  const FirebaseMessagingPage({super.key});

  @override
  State<FirebaseMessagingPage> createState() => _FirebaseMessagingPageState();
}

class _FirebaseMessagingPageState extends State<FirebaseMessagingPage> {
  @override
  void initState() {
    super.initState();
    FirebaseMessagingHelper.initBackgroundNotification();
    FirebaseMessagingHelper.initForeGroundNotification();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Firebase messaing"),
      ),
      body: ListView(
        padding: const EdgeInsets.all(8),
        children: const [],
      ),
    );
  }
}
