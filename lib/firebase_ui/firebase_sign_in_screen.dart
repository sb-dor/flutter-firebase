import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:firebase_ui_oauth_google/firebase_ui_oauth_google.dart';
import 'package:firebase_ui_oauth_twitter/firebase_ui_oauth_twitter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase/core/firebase_helpers/firebase_auth/firebase_twitter_auth/firebase_twitter_auth_settings.dart';
import 'data_helper.dart';

class FirebaseSignInScreen extends StatefulWidget {
  const FirebaseSignInScreen({super.key});

  @override
  State<FirebaseSignInScreen> createState() => _FirebaseSignInScreenState();
}

class _FirebaseSignInScreenState extends State<FirebaseSignInScreen> {
  List<AuthProvider> providers = [
    EmailAuthProvider(),
    GoogleProvider(
      clientId: googleClientId,
    ),
    TwitterProvider(
      apiKey: FirebaseTwitterAuthSettings.apiKey,
      apiSecretKey: FirebaseTwitterAuthSettings.appSecret,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return SignInScreen(
      providers: providers,
    );
  }
}
