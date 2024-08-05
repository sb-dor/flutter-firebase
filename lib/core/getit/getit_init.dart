import 'package:flutter_firebase/core/firebase_helpers/firebase_analytics_helper/firebase_analytics_helper.dart';
import 'package:flutter_firebase/core/firebase_helpers/firebase_appcheck/firebase_app_check_helper.dart';
import 'package:flutter_firebase/core/firebase_helpers/firebase_cloud_firestore/firebase_cloud_firestore_helper.dart';
import 'package:flutter_firebase/core/firebase_helpers/firebase_cloud_storage/firebase_cloud_storage_helper.dart';
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
  }
}
