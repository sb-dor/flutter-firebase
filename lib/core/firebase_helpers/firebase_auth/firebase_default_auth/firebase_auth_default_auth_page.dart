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

  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();

  final TextEditingController _nameController = TextEditingController();

  // final

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Firebase auth default auth page"),
      ),
      body: ListView(
        padding: const EdgeInsets.all(8),
        children: [
          StreamBuilder(
            stream: _firebaseDefaultAuthHelper.userChanges(),
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
                    _nameController.text = data?.displayName ?? '';
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("email: ${data?.email}"),
                        Text("displayname: ${data?.displayName}"),
                        Text("id: ${data?.uid}"),
                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: _nameController,
                                decoration: InputDecoration(hintText: "Name"),
                              ),
                            ),
                            TextButton(
                              onPressed: () async {
                                await _firebaseDefaultAuthHelper
                                    .updateUserName(_nameController.text.trim());
                                FocusManager.instance.primaryFocus?.unfocus();
                              },
                              child: Text(
                                "Change Name",
                              ),
                            )
                          ],
                        ),
                        SizedBox(height: 20),
                      ],
                    );
                  } else {
                    return const SizedBox();
                  }
              }
            },
          ),
          const SizedBox(height: 10),
          TextField(
            controller: _emailController,
            decoration: const InputDecoration(hintText: "Email"),
          ),
          TextField(
            controller: _passwordController,
            decoration: const InputDecoration(hintText: "Password"),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              TextButton(
                onPressed: () {
                  _firebaseDefaultAuthHelper.registrationWithEmailAndPassword(
                    email: _emailController.text.trim(),
                    password: _passwordController.text.trim(),
                  );
                },
                child: const Text("Register"),
              ),
              TextButton(
                onPressed: () {
                  _firebaseDefaultAuthHelper.signInWithEmailAndPassword(
                    email: _emailController.text.trim(),
                    password: _passwordController.text.trim(),
                  );
                },
                child: const Text("Login"),
              ),
              TextButton(
                onPressed: () {
                  _firebaseDefaultAuthHelper.signOut();
                },
                child: const Text("Sign out"),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
