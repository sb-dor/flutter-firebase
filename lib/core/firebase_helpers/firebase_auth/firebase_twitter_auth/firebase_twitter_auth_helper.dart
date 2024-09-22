import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_firebase/core/firebase_helpers/firebase_auth/firebase_twitter_auth/firebase_twitter_auth_settings.dart';
import 'package:flutter_firebase/core/getit/getit_init.dart';
import 'package:flutter_firebase/core/shared_pref/shared_pref.dart';
import 'package:twitter_login/twitter_login.dart';

class FirebaseTwitterAuthHelper {
  //
  //
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  final SharedPref _sharedPref = getit<SharedPref>();

  late TwitterLogin _twitterLogin;

  Stream<User?> userChanges() async* {
    yield* _firebaseAuth.userChanges();
  }

  Future<void> initTwitterLogin() async {
    _twitterLogin = TwitterLogin(
      apiKey: FirebaseTwitterAuthSettings.apiKey,
      apiSecretKey: FirebaseTwitterAuthSettings.appSecret,
      redirectURI: FirebaseTwitterAuthSettings.firebaseOwnGeneratedRedirect,
    );
  }

  Future<void> signIn() async {
    final loginStatus = await _twitterLogin.loginV2();

    if (loginStatus.status == TwitterLoginStatus.loggedIn) {
      final twitterAuthCredential = TwitterAuthProvider.credential(
        accessToken: loginStatus.authToken!,
        secret: loginStatus.authTokenSecret!,
      );

      await _firebaseAuth.signInWithCredential(twitterAuthCredential);

      await _sharedPref.saveString(
        key: "twitter_access_token",
        value: twitterAuthCredential.accessToken!,
      );

      await _sharedPref.saveString(
        key: "twitter_secret_key",
        value: twitterAuthCredential.secret!,
      );
    }
  }

  Future<void> checkAuth() async {
    if (_firebaseAuth.currentUser != null) return;

    final token = _sharedPref.getStringByKey(key: "twitter_access_token");

    final secret = _sharedPref.getStringByKey(key: "twitter_secret_key");

    if (token == null || secret == null) return;

    _firebaseAuth.signInWithCredential(
      TwitterAuthProvider.credential(
        accessToken: token,
        secret: secret,
      ),
    );
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
    await _sharedPref.deleteByKey(key: "twitter_access_token");
    await _sharedPref.deleteByKey(key: "twitter_secret_key");
  }
}
