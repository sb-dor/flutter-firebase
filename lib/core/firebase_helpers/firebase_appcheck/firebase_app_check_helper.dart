import 'package:firebase_app_check/firebase_app_check.dart';

class FirebaseAppCheckHelper {
  final FirebaseAppCheck _firebaseAppCheck = FirebaseAppCheck.instance;

  FirebaseAppCheck get firebaseAppCheck => _firebaseAppCheck;

  Future<void> init() async {
    // android and ios settings already set
    // only web not set, check the docs for more info (check the readme.md file)
    // check your firebase app and configure the specific application (web, mobile, ios)
    // in order to register and activate sum features (Cloud FireStore, Cloud Storage etc.) only for your
    // specific application that if other people got access to your firebase project through your firebase key (accidentally)
    // to not get access them to write or read data
    _firebaseAppCheck.activate();
  }
}
