// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      throw UnsupportedError(
        'DefaultFirebaseOptions have not been configured for web - '
        'you can reconfigure this by running the FlutterFire CLI again.',
      );
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDcQZ0W91DbU2pJRXZ68WgIAqtYpfkeLyk',
    appId: '1:403332127037:android:2dd4b41b5073a23dea0d54',
    messagingSenderId: '403332127037',
    projectId: 'sign-in-firebase-93418',
    databaseURL: 'https://sign-in-firebase-93418-default-rtdb.firebaseio.com',
    storageBucket: 'sign-in-firebase-93418.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAJ1UeymiS3ZV_Z1Mqx54qA6y34FiY6vfU',
    appId: '1:403332127037:ios:b6e96455f06aec3fea0d54',
    messagingSenderId: '403332127037',
    projectId: 'sign-in-firebase-93418',
    databaseURL: 'https://sign-in-firebase-93418-default-rtdb.firebaseio.com',
    storageBucket: 'sign-in-firebase-93418.appspot.com',
    androidClientId: '403332127037-cfcmkuj8bu6a6pjk7q5a8q5q44bj6jfm.apps.googleusercontent.com',
    iosClientId: '403332127037-0ppdtbiseopqftdpkee8fo04sdg7eb0v.apps.googleusercontent.com',
    iosBundleId: 'com.bdaynabday.firebaseapp',
  );
}
