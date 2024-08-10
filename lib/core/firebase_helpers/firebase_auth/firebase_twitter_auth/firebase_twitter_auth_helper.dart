import 'package:flutter_firebase/core/firebase_helpers/firebase_auth/firebase_twitter_auth/firebase_twitter_auth_settings.dart';
import 'package:twitter_login/twitter_login.dart';

class FirebaseTwitterAuthHelper {
  late TwitterLogin _twitterLogin;

  Future<void> initTwitterLogin() async {
    _twitterLogin = TwitterLogin(
      apiKey: FirebaseTwitterAuthSettings.apiKey,
      apiSecretKey: FirebaseTwitterAuthSettings.appSecret,
      redirectURI: FirebaseTwitterAuthSettings.firebaseOwnGeneratedRedirect,
    );
  }
}
