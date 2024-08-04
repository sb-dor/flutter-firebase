import 'package:firebase_app_check/firebase_app_check.dart';

class FirebaseAppCheckHelper {
  final FirebaseAppCheck _firebaseAppCheck = FirebaseAppCheck.instance;

  FirebaseAppCheck get firebaseAppCheck => _firebaseAppCheck;

  Future<void> init() async {
    // android and ios settings already set
    // only web not set, check the docs for more info (check the readme.md file)
    _firebaseAppCheck.activate();
  }
}
