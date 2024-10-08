import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_firebase/core/firebase_helpers/firebase_analytics_helper/firebase_analytics_helper.dart';
import 'package:flutter_firebase/core/firebase_helpers/firebase_appcheck/firebase_app_check_helper.dart';
import 'package:flutter_firebase/core/firebase_helpers/firebase_auth/firebase_github_auth/firebase_github_auth_helper.dart';
import 'package:flutter_firebase/core/firebase_helpers/firebase_auth/firebase_twitter_auth/firebase_twitter_auth_helper.dart';
import 'package:flutter_firebase/core/firebase_helpers/firebase_cloud_firestore/firebase_cloud_firestore_helper.dart';
import 'package:flutter_firebase/core/firebase_helpers/firebase_cloud_storage/firebase_cloud_storage_helper.dart';
import 'package:flutter_firebase/core/firebase_helpers/firebase_messaging/awesome_notification_helper.dart';
import 'package:flutter_firebase/core/getit/getit_init.dart';
import 'package:flutter_firebase/firebase_options.dart';

import 'firebase_ui/firebase_sign_in_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetItInit.init();

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    await getit<AwesomeNotificationHelper>().initAwesomeNotifications();

    if (kIsWeb) {
      // initialize the facebook javascript SDK
      await FacebookAuth.i.webAndDesktopInitialize(
        appId: "YOUR_FACEBOOK_APP_ID",
        cookie: true,
        xfbml: true,
        version: "v15.0",
      );
    } else {
      await getit<FirebaseAppCheckHelper>().init();

      await getit<FirebaseCloudFireStoreHelper>().initFirestore();

      await getit<FirebaseCloudStorageHelper>().init();

      await getit<FirebaseTwitterAuthHelper>().initTwitterLogin();

      await getit<FirebaseGithubAuthHelper>().init();

      getit<FirebaseAnalyticsHelper>().analytics.setAnalyticsCollectionEnabled(true);
    }
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
        if (!kIsWeb)
          FirebaseAnalyticsObserver(
            analytics: getit<FirebaseAnalyticsHelper>().analytics,
          )
      ],
      home: const FirebaseSignInScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
