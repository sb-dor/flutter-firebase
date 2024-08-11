import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase/core/firebase_helpers/firebase_messaging/awesome_notification_helper.dart';
import 'package:flutter_firebase/core/getit/getit_init.dart';

// make your methods static or top-level function
// otherwise it will throw an error
// for more info take a look this link:
// https://stackoverflow.com/questions/67304706/flutter-fcm-unhandled-exception-null-check-operator-used-on-a-null-value
abstract final class FirebaseMessagingHelper {
  //
  static final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  static final AwesomeNotificationHelper _awesomeNotificationHelper =
      getit<AwesomeNotificationHelper>();

  //
  static Future<String?> initTopic() async {
    //
    await _firebaseMessaging.requestPermission();

    final firebaseToken = await _firebaseMessaging.getToken();

    await _firebaseMessaging.subscribeToTopic('name_of_your_any_topic');

    initBackgroundNotification();

    initForeGroundNotification();

    return firebaseToken;
  }

  //
  static Future<void> initBackgroundNotification() async {
    //
    final res = await _firebaseMessaging.requestPermission();

    debugPrint("res: ${res.authorizationStatus}");

    if (res.authorizationStatus == AuthorizationStatus.authorized) {
      // you can use that in the future on order to send notification only for specific user
      final firebaseMessagingToken = await _firebaseMessaging.getToken();

      debugPrint("test token: $firebaseMessagingToken");

      FirebaseMessaging.onBackgroundMessage(_backgroundMessageHandler);
    }
  }

  //
  static Future<void> initForeGroundNotification() async {
    final res = await _firebaseMessaging.requestPermission();

    if (res.authorizationStatus == AuthorizationStatus.authorized) {
      FirebaseMessaging.onMessage.listen(_backgroundMessageHandler);
    }
  }

  static Future<void> _backgroundMessageHandler(RemoteMessage? message) async {
    if (message == null) return;
    debugPrint("Title: ${message.notification?.title}");
    debugPrint("body: ${message.notification?.body}");
    debugPrint("image: ${message.notification?.toMap()}");
    debugPrint("playload of background listener: ${message.data}");
    debugPrint("data: ${message.data}");

    // debugPrint("payLoad: ${message.data}");
    //
    // if sending from laravel is json type
    // Map<String, dynamic> notification = jsonDecode(message.data['title']);

    // await AwesomeNotificationsHelper.showAwesomeNotification(
    //     notification: notification['notification'], offline: false);

    if (defaultTargetPlatform == TargetPlatform.iOS) {
      await _awesomeNotificationHelper.showAwesomeNotification(
        title: message.notification?.title ?? '',
        body: message.notification?.body ?? '',
        image: message.notification?.apple?.imageUrl,
      );
    } else {
      await _awesomeNotificationHelper.showAwesomeNotification(
        title: message.notification?.title ?? '',
        body: message.notification?.body ?? '',
        image: message.notification?.android?.imageUrl,
      );
    }
  }
}
