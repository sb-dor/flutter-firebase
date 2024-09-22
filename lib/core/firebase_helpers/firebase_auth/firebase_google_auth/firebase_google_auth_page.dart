import 'package:flutter/material.dart';
import 'package:flutter_firebase/core/firebase_helpers/firebase_auth/firebase_google_auth/firebase_google_auth_helper.dart';
import 'package:flutter_firebase/core/getit/getit_init.dart';

class FirebaseGoogleAuthPage extends StatefulWidget {
  const FirebaseGoogleAuthPage({super.key});

  @override
  State<FirebaseGoogleAuthPage> createState() => _FirebaseGoogleAuthPageState();
}

class _FirebaseGoogleAuthPageState extends State<FirebaseGoogleAuthPage> {
  late final FirebaseGoogleAuthHelper _firebaseGoogleAuthHelper;

  @override
  void initState() {
    super.initState();
    _firebaseGoogleAuthHelper = getit<FirebaseGoogleAuthHelper>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Google auth helper",
        ),
      ),
      body: ListView(
        children: [
          StreamBuilder(
            stream: _firebaseGoogleAuthHelper.userChanges(),
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
          TextButton(
            onPressed: () async {
              await _firebaseGoogleAuthHelper.signInWithGoogle();
            },
            child: const Text(
              "Sign in",
            ),
          ),
        ],
      ),
    );
  }
}
