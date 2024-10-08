import 'package:flutter_firebase/core/firebase_helpers/firebase_analytics_helper/firebase_analytics_helper.dart';
import 'package:flutter_firebase/core/firebase_helpers/firebase_appcheck/firebase_app_check_helper.dart';
import 'package:flutter_firebase/core/firebase_helpers/firebase_auth/firebase_apple_auth/firebase_apple_auth_helper.dart';
import 'package:flutter_firebase/core/firebase_helpers/firebase_auth/firebase_default_auth/firebase_default_auth_helper.dart';
import 'package:flutter_firebase/core/firebase_helpers/firebase_auth/firebase_facebook_auth/firebase_facebook_auth_helper.dart';
import 'package:flutter_firebase/core/firebase_helpers/firebase_auth/firebase_github_auth/firebase_github_auth_helper.dart';
import 'package:flutter_firebase/core/firebase_helpers/firebase_auth/firebase_google_auth/firebase_google_auth_helper.dart';
import 'package:flutter_firebase/core/firebase_helpers/firebase_auth/firebase_phone_auth/firebase_phone_auth_helper.dart';
import 'package:flutter_firebase/core/firebase_helpers/firebase_auth/firebase_twitter_auth/firebase_twitter_auth_helper.dart';
import 'package:flutter_firebase/core/firebase_helpers/firebase_cloud_firestore/firebase_cloud_firestore_helper.dart';
import 'package:flutter_firebase/core/firebase_helpers/firebase_cloud_storage/firebase_cloud_storage_helper.dart';
import 'package:flutter_firebase/core/firebase_helpers/firebase_messaging/awesome_notification_helper.dart';
import 'package:flutter_firebase/core/firebase_helpers/firebase_realtime_database/firebase_realtime_database_helper.dart';
import 'package:flutter_firebase/core/shared_pref/shared_pref.dart';
import 'package:get_it/get_it.dart';

final getit = GetIt.I;

abstract final class GetItInit {
  static Future<void> init() async {
    //
    getit.registerLazySingleton<FirebaseAnalyticsHelper>(
      () => FirebaseAnalyticsHelper(),
    );

    //
    getit.registerLazySingleton<FirebaseAppCheckHelper>(
      () => FirebaseAppCheckHelper(),
    );

    //
    getit.registerLazySingleton<FirebaseCloudFireStoreHelper>(
      () => FirebaseCloudFireStoreHelper(),
    );

    //
    getit.registerLazySingleton<FirebaseCloudStorageHelper>(
      () => FirebaseCloudStorageHelper(),
    );

    //
    getit.registerLazySingleton<FirebaseDefaultAuthHelper>(
      () => FirebaseDefaultAuthHelper(),
    );

    //
    getit.registerLazySingleton<SharedPref>(
      () => SharedPref(),
    );

    await getit<SharedPref>().initPref();

    //
    getit.registerLazySingleton<FirebaseGoogleAuthHelper>(
      () => FirebaseGoogleAuthHelper(),
    );

    //
    getit.registerLazySingleton<FirebaseFacebookAuthHelper>(
      () => FirebaseFacebookAuthHelper(),
    );

    //
    getit.registerLazySingleton<FirebaseAppleAuthHelper>(
      () => FirebaseAppleAuthHelper(),
    );

    //
    getit.registerLazySingleton<FirebaseTwitterAuthHelper>(
      () => FirebaseTwitterAuthHelper(),
    );

    //
    getit.registerLazySingleton<FirebaseGithubAuthHelper>(
      () => FirebaseGithubAuthHelper(),
    );

    //
    getit.registerLazySingleton<FirebasePhoneAuthHelper>(
      () => FirebasePhoneAuthHelper(),
    );

    //
    getit.registerLazySingleton<AwesomeNotificationHelper>(
      () => AwesomeNotificationHelper(),
    );

    //
    getit.registerLazySingleton<FirebaseRealtimeDatabaseHelper>(
        () => FirebaseRealtimeDatabaseHelper());
  }
}
