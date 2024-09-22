import 'package:flutter/material.dart';
import 'package:flutter_firebase/core/firebase_helpers/firebase_auth/firebase_apple_auth/firebase_apple_auth_helper.dart';
import 'package:flutter_firebase/core/getit/getit_init.dart';

class FirebaseAppleAuthPage extends StatefulWidget {
  const FirebaseAppleAuthPage({super.key});

  @override
  State<FirebaseAppleAuthPage> createState() => _FirebaseAppleAuthPageState();
}

class _FirebaseAppleAuthPageState extends State<FirebaseAppleAuthPage> {
  late FirebaseAppleAuthHelper _firebaseAppleAuthHelper;

  @override
  void initState() {
    super.initState();
    _firebaseAppleAuthHelper = getit<FirebaseAppleAuthHelper>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Apple auth",
        ),
      ),
      body: ListView(
        children: [
          StreamBuilder(
            stream: _firebaseAppleAuthHelper.userChanges(),
            builder: (context, snap) {
              switch (snap.connectionState) {
                case ConnectionState.none:
                  return const SizedBox();
                case ConnectionState.waiting:
                  return const CircularProgressIndicator();
                case ConnectionState.active:
                case ConnectionState.done:
                  if (snap.hasData) {
                    final data = snap.requireData;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        IntrinsicHeight(
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("email: ${data?.email}"),
                                    Text("displayname: ${data?.displayName}"),
                                    Text("id: ${data?.uid}"),
                                  ],
                                ),
                              ),
                              SizedBox(
                                width: 100,
                                height: 100,
                                child: Image.network(data?.photoURL ??
                                    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQa5Hfgzc60D5cgiQQX-nj-j7_eFHxqpwQmVw&s'),
                              )
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
                    );
                  } else {
                    return const SizedBox();
                  }
              }
            },
          ),
          ElevatedButton(
            onPressed: () async {
              await _firebaseAppleAuthHelper.signInWithApple();
            },
            child: const Text("Sign in"),
          ),
          ElevatedButton(
            onPressed: () async {
              await _firebaseAppleAuthHelper.signOut();
            },
            child: const Text("Sign out"),
          ),
        ],
      ),
    );
  }
}
