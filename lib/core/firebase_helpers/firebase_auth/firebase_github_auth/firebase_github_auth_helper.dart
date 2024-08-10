import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_firebase/core/firebase_helpers/firebase_auth/firebase_github_auth/firebase_github_settings.dart';
import 'package:flutter_firebase/core/firebase_helpers/firebase_auth/firebase_github_auth/github_auth_helper/github_sign_in_plus.dart';

class FirebaseGithubAuthHelper {
  //
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  late final GitHubSignIn _gitHubSignIn;

  Future<void> init() async {
    _gitHubSignIn = GitHubSignIn(
      clientId: FirebaseGithubSettings.clientId,
      clientSecret: FirebaseGithubSettings.clientSecret,
      redirectUrl: FirebaseGithubSettings.redirectUrl,
    );
  }

  Future<void> signIn() async {}
//
}
