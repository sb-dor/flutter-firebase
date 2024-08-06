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

  final TextEditingController _emailControllerForChange = TextEditingController();

  // final

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _firebaseDefaultAuthHelper.checkAuth();
  }

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
                    _emailControllerForChange.text = data?.email ?? '';
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("email: ${data?.email}"),
                        Text("displayname: ${data?.displayName}"),
                        Text("id: ${data?.uid}"),
                        _TextFieldWithFirebaseFunc(
                          controller: _nameController,
                          onButtonTap: () async {
                            await _firebaseDefaultAuthHelper
                                .updateUserName(_nameController.text.trim());
                            FocusManager.instance.primaryFocus?.unfocus();
                          },
                          hintText: "Name",
                          buttonText: "Change Name",
                        ),
                        _TextFieldWithFirebaseFunc(
                          controller: _emailControllerForChange,
                          onButtonTap: () async {
                            await _firebaseDefaultAuthHelper.updateUserEmail(
                              _emailControllerForChange.text.trim(),
                            );
                            FocusManager.instance.primaryFocus?.unfocus();
                          },
                          hintText: "Email",
                          buttonText: "Change email",
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

class _TextFieldWithFirebaseFunc extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onButtonTap;
  final String hintText;
  final String buttonText;

  const _TextFieldWithFirebaseFunc({
    super.key,
    required this.controller,
    required this.onButtonTap,
    required this.hintText,
    required this.buttonText,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: controller,
            decoration: InputDecoration(hintText: hintText),
          ),
        ),
        TextButton(
          onPressed: onButtonTap,
          child: Text(
            buttonText,
          ),
        )
      ],
    );
  }
}
