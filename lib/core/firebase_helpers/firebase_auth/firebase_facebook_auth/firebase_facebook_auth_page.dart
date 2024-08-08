import 'package:flutter/material.dart';
import 'package:flutter_firebase/core/firebase_helpers/firebase_auth/firebase_facebook_auth/firebase_facebook_auth_helper.dart';
import 'package:flutter_firebase/core/getit/getit_init.dart';

class FirebaseFacebookAuthPage extends StatefulWidget {
  const FirebaseFacebookAuthPage({super.key});

  @override
  State<FirebaseFacebookAuthPage> createState() => _FirebaseFacebookAuthPageState();
}

class _FirebaseFacebookAuthPageState extends State<FirebaseFacebookAuthPage> {
  late FirebaseFacebookAuthHelper _faceBookAuthHelper;

  @override
  void initState() {
    super.initState();
    _faceBookAuthHelper = getit<FirebaseFacebookAuthHelper>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Face book auth",
        ),
      ),
      body: ListView(
        children: [
          StreamBuilder(
            stream: _faceBookAuthHelper.userChanges(),
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
              await _faceBookAuthHelper.facebookSignIn();
            },
            child: Text("Sign in"),
          ),
        ],
      ),
    );
  }
}
