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
    _firebaseTwitterAuthHelper.checkAuth();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Twitter auth",
        ),
      ),
      body: ListView(
        children: [
          StreamBuilder(
            stream: _firebaseTwitterAuthHelper.userChanges(),
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
              await _firebaseTwitterAuthHelper.signIn();
            },
            child: Text("Sign in"),
          ),
          ElevatedButton(
            onPressed: () async {
              await _firebaseTwitterAuthHelper.signOut();
            },
            child: Text("Sign out"),
          ),
        ],
      ),
    );
  }
}
