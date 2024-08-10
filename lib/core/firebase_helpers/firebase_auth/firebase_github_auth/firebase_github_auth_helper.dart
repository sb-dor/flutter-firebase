import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase/core/firebase_helpers/firebase_auth/firebase_github_auth/firebase_github_settings.dart';
import 'package:flutter_firebase/core/firebase_helpers/firebase_auth/firebase_github_auth/github_auth_helper/github_sign_in_plus.dart';
import 'package:flutter_firebase/core/getit/getit_init.dart';
import 'package:flutter_firebase/core/shared_pref/shared_pref.dart';

class FirebaseGithubAuthHelper {
  //
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  final SharedPref _sharedPref = getit<SharedPref>();

  late final GitHubSignIn _gitHubSignIn;

  Future<void> init() async {
    _gitHubSignIn = GitHubSignIn(
      clientId: FirebaseGithubSettings.clientId,
      clientSecret: FirebaseGithubSettings.clientSecret,
      redirectUrl: FirebaseGithubSettings.redirectUrl,
    );
  }

  Stream<User?> userChanges() async* {
    yield* _firebaseAuth.userChanges();
  }

  Future<void> signIn(BuildContext context) async {
    final result = await _gitHubSignIn.signIn(context);

    if (result.token == null) return;

    final credential = GithubAuthProvider.credential(result.token!);

    await _sharedPref.saveString(key: "github_token", value: result.token!);

    await _firebaseAuth.signInWithCredential(credential);
  }

  Future<void> checkAuth() async {
    final token = _sharedPref.getStringByKey(key: "github_token");

    if(token == null) return;

    final credential = GithubAuthProvider.credential(token);

    await _firebaseAuth.signInWithCredential(credential);
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }
//
}
