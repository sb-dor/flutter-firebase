import 'package:flutter/material.dart';
import 'package:flutter_firebase/core/firebase_helpers/firebase_messaging/firebase_messaging_helper.dart';
import 'package:flutter_firebase/core/getit/getit_init.dart';

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
        title: Text("Firebase messaing"),
      ),
      body: ListView(
        padding: EdgeInsets.all(8),
        children: [],
      ),
    );
  }
}
