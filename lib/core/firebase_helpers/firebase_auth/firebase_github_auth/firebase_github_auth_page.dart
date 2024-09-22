import 'package:flutter/material.dart';
import 'package:flutter_firebase/core/firebase_helpers/firebase_auth/firebase_github_auth/firebase_github_auth_helper.dart';
import 'package:flutter_firebase/core/getit/getit_init.dart';

class FirebaseGithubAuthPage extends StatefulWidget {
  const FirebaseGithubAuthPage({super.key});

  @override
  State<FirebaseGithubAuthPage> createState() => _FirebaseGithubAuthPageState();
}

class _FirebaseGithubAuthPageState extends State<FirebaseGithubAuthPage> {
  late FirebaseGithubAuthHelper _firebaseGithubAuthHelper;

  @override
  void initState() {
    super.initState();
    _firebaseGithubAuthHelper = getit<FirebaseGithubAuthHelper>();
    _firebaseGithubAuthHelper.checkAuth();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "GitHub auth",
        ),
      ),
      body: ListView(
        children: [
          StreamBuilder(
            stream: _firebaseGithubAuthHelper.userChanges(),
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
              await _firebaseGithubAuthHelper.signIn(context);
            },
            child: const Text("Sign in"),
          ),
          ElevatedButton(
            onPressed: () async {
              await _firebaseGithubAuthHelper.signOut();
            },
            child: const Text("Sign out"),
          ),
        ],
      ),
    );
  }
}
