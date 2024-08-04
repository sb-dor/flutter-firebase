import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase/core/firebase_helpers/firebase_analytics_helper/analytics_ecommerce_page/analytics_ecommerce_page.dart';
import 'package:flutter_firebase/core/firebase_helpers/firebase_analytics_helper/firebase_analytics_helper.dart';
import 'package:flutter_firebase/core/firebase_helpers/firebase_appcheck/firebase_app_check_helper.dart';
import 'package:flutter_firebase/core/firebase_helpers/firebase_cloud_firestore/firebase_cloud_firestore_helper.dart';
import 'package:flutter_firebase/core/firebase_helpers/firebase_cloud_firestore/firebase_cloud_firestore_page.dart';
import 'package:flutter_firebase/core/getit/getit_init.dart';
import 'package:flutter_firebase/firebase_options.dart';

import 'core/firebase_helpers/firebase_analytics_helper/firebase_analytics_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetItInit.init();

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    await getit<FirebaseAppCheckHelper>().init();

    await getit<FirebaseCloudFireStoreHelper>().initFirestore();

    getit<FirebaseAnalyticsHelper>().analytics.setAnalyticsCollectionEnabled(true);
  } catch (e) {
    debugPrint("Failed to initialize Firebase: $e");
  }

  runApp(const _MainApp());
}

class _MainApp extends StatelessWidget {
  const _MainApp();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorObservers: [
        FirebaseAnalyticsObserver(
          analytics: getit<FirebaseAnalyticsHelper>().analytics,
        )
      ],
      home: const FirebaseCloudFirestorePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
