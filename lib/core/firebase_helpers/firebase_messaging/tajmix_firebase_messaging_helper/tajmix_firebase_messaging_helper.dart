// packages that were used:
// firebase_messaging: ^16.0.2
// flutter_local_notifications: ^19.4.2

// import 'dart:async';
// import 'dart:convert';
// import 'dart:io';
// import 'package:firebase_crashlytics/firebase_crashlytics.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:logger/logger.dart';
// import 'package:moshin24/src/core/utils/constants.dart';
// import 'package:moshin24/src/core/utils/device_info/device_info_helper.dart';
// import 'package:moshin24/src/core/utils/reusable_global_functions.dart';
// import 'package:moshin24/src/core/utils/shared_prefer_helper.dart';
// import 'package:path_provider/path_provider.dart';
//
// // Builds an FCM message with only the data payload.
// // Unlike notification pushes, this type of message will not be
// // automatically displayed by the system and must be handled
// // manually in the app through Flutter Local Notifications.
// // This provides full control over how notifications are displayed
// // and how navigation is handled on click.
//
// // For ex: if you send notification with "notification" property (which firebase console or laravel does it automatically) ...
// // ... "firebase_messaging" package handles background notification automatically.
// // So you can't show your own type of notification (if you want to tap on notification, you won't be able to do something on tap)
// // Just take a look to the implementation of
//
// const String _androidChannelId = 'notification_important_channel';
// const String _androidChannelName = 'Info High Importance Notifications';
// const String _androidChannelDescription = 'This channel is used for important notifications.';
// const String _androidAppIcon = 'ic_stat_notification_icon';
// const String _subscribedCitiesTopics = 'subscribed_cities';
//
// @pragma('vm:entry-point')
// class FirebaseMessagingHelper {
//   FirebaseMessagingHelper({
//     required final FirebaseMessaging firebaseMessaging,
//     required final SharedPreferHelper sharedPreferHelper,
//     required final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin,
//     required final Logger logger,
//     required final ReusableGlobalFunctions reusableGlobalFunctions,
//     required final DeviceInfoHelper deviceInfoHelper,
//   }) : _firebaseMessaging = firebaseMessaging,
//         _sharedPreferHelper = sharedPreferHelper,
//         _flutterLocalNotificationsPlugin = flutterLocalNotificationsPlugin,
//         _logger = logger,
//         _reusableGlobalFunctions = reusableGlobalFunctions,
//         _deviceInfoHelper = deviceInfoHelper;
//
//   final FirebaseMessaging _firebaseMessaging;
//   final SharedPreferHelper _sharedPreferHelper;
//   final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin;
//   final Logger _logger;
//   final ReusableGlobalFunctions _reusableGlobalFunctions;
//   final DeviceInfoHelper _deviceInfoHelper;
//
//   // Token will be generated on app entrance
//   // unique key for device
//   // once it generated one token it will not generate new one until we delete that token
//   Future<String?> token() async {
//     if (defaultTargetPlatform == TargetPlatform.iOS) {
//       final apnToken = await _firebaseMessaging.getAPNSToken();
//       if (apnToken == null) {
//         FirebaseCrashlytics.instance.recordError(
//           Exception("APNs was not generated for iOS"),
//           StackTrace.current,
//           reason: await _deviceInfoHelper.getDeviceInfo(),
//         );
//         return null;
//       }
//     }
//     final token = await _firebaseMessaging.getToken();
//     if (token != null) await _sharedPreferHelper.setStringByKey(key: fcmToken, value: token);
//     _logger.log(Level.info, "Unique firebase token for device: $token");
//     return token;
//   }
//
//   // delete token is not necessary at all (for now)
//   // because token is per device (and it's unique and will be saved locally in phone)
//   // so, token generation is not required on each log-in
//   // I just clear the token in remote database not locally, on login I send token again
//   Future<void> deleteToken() async {
//     await _firebaseMessaging.deleteToken();
//     await _sharedPreferHelper.removeByKey(key: fcmToken);
//   }
//
//   Future<void> subscribeToTopic(final String topic, {final bool useDebugName = true}) async {
//     // iOS throws an error if we don't have apn token
//     // double checking
//     // if the user still hasn't received the token
//     final getToken = await token();
//
//     // if it's ios and token is null we will not continue
//     // the only one reason that token may not be generated is "iosApnToken" that was not generated
//     // so that is why if it's an ios and token was not generated we will not subscribe to the topics
//     if (defaultTargetPlatform == TargetPlatform.iOS && getToken == null) return;
//
//     final renamedTopic = "${(kDebugMode && useDebugName) ? "test_" : ""}$topic".trim();
//     await _firebaseMessaging.subscribeToTopic(renamedTopic);
//     _logger.log(Level.info, "Subscribed to the topic: $renamedTopic");
//   }
//
//   Future<void> unSubscribeFromTopic(final String topic, {final bool useDebugName = true}) async {
//     final renamedTopic = "${(kDebugMode && useDebugName) ? "test_" : ""}$topic".trim();
//     await _firebaseMessaging.unsubscribeFromTopic(renamedTopic);
//     _logger.log(Level.info, "Unsubscribed from the topic: $renamedTopic");
//   }
//
//   // what does this subscribeToCityTopics do?
//   // so, if user entered to the application with two different devices
//   // if he subscribed to one topic (topic for city) that had different id
//   // and from another device he enters and chooses another city
//   // so first device should unsubscribe from another city and subscribe to the current city's topic
//   Future<void> subscribeToCityTopics(final String topic) async {
//     await unsubscribeFromAllPreviousSubscribedCityTopics();
//     try {
//       final renamedTopic = "${kDebugMode ? "test_" : ""}$topic".trim();
//       final subscribedCities = _sharedPreferHelper.getStringByKey(key: _subscribedCitiesTopics);
//       final List<String> subTokensList = [renamedTopic];
//       if (subscribedCities == null) {
//         await subscribeToTopic(renamedTopic, useDebugName: false);
//         await _sharedPreferHelper.setStringByKey(
//           key: _subscribedCitiesTopics,
//           value: jsonEncode(subTokensList),
//         );
//       } else {
//         final List<dynamic> parsedSubsTopics = jsonDecode(subscribedCities);
//         for (final topic in parsedSubsTopics) {
//           if (topic is String) {
//             subTokensList.add(topic);
//           }
//         }
//         for (final topic in subTokensList) {
//           await subscribeToTopic(topic, useDebugName: false);
//         }
//         await _sharedPreferHelper.setStringByKey(
//           key: _subscribedCitiesTopics,
//           value: jsonEncode(subTokensList),
//         );
//       }
//     } catch (error, stackTrace) {
//       _logger.log(Level.error, "Can't subscribe to the city topic: $topic");
//       Error.throwWithStackTrace(error, stackTrace);
//     }
//   }
//
//   Future<void> unsubscribeFromAllPreviousSubscribedCityTopics() async {
//     final subscribedCities = _sharedPreferHelper.getStringByKey(key: _subscribedCitiesTopics);
//     if (subscribedCities != null) {
//       _logger.log(Level.debug, "removing city tokens: $subscribedCities");
//       final List<dynamic> parsedSubsTopics = jsonDecode(subscribedCities);
//       for (final topic in parsedSubsTopics) {
//         if (topic is String) {
//           try {
//             // cause we've already set with debugName inside sharedPreferences
//             await unSubscribeFromTopic(topic, useDebugName: false);
//           } catch (error, stackTrace) {
//             _logger.log(Level.error, "Can't unsubscribe from the city topic: $topic");
//             Error.throwWithStackTrace(error, stackTrace);
//           }
//         }
//       }
//       await _sharedPreferHelper.removeByKey(key: _subscribedCitiesTopics);
//     }
//   }
//
//   Future<void> initForegroundNotification({
//     void Function(String type, Map<String, dynamic>? data)? onForegroundNotification,
//   }) async {
//     FirebaseMessaging.onMessage.listen(
//           (message) =>
//           _foregroundMessageHandler(message, onForegroundNotification: onForegroundNotification),
//     );
//   }
//
//   // not necessary at all, cause background notification will be displayed automatically by firebase
//   // messaging package
//   Future<void> initBackgroundNotification() async {
//     // ios will handle background notification by the system (with firebase_messaging)
//     if (defaultTargetPlatform == TargetPlatform.android) {
//       FirebaseMessaging.onBackgroundMessage(_backgroundMessageHandler);
//     }
//   }
//
//   // Notification clicking!!!
//   // works only while application is alive and is in the foreground
//   Future<void> initializeNotificationSettingsEntry({
//     void Function(String screen, Map<String, dynamic>? data)? onRedirect,
//   }) async {
//     // create high priority notification for Android
//     // Notes: It will not create duplicated channel if you use this logic several times!
//     if (defaultTargetPlatform == TargetPlatform.android) {
//       const AndroidNotificationChannel channel = AndroidNotificationChannel(
//         _androidChannelId,
//         _androidChannelName,
//         description: _androidChannelDescription,
//         importance: Importance.max,
//       );
//
//       final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//       FlutterLocalNotificationsPlugin();
//
//       await flutterLocalNotificationsPlugin
//           .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
//           ?.createNotificationChannel(channel);
//     }
//
//     // other default settings both for android and ios
//     await _initSettings(_flutterLocalNotificationsPlugin, onRedirect: onRedirect);
//   }
//
//   static Future<void> _initSettings(
//       final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin, {
//         final void Function(String screen, Map<String, dynamic>? data)? onRedirect,
//       }) async {
//     const AndroidInitializationSettings androidConfigs = AndroidInitializationSettings(
//       _androidAppIcon,
//     );
//
//     // even if we do not write code for iOS at all, we need to initialize that
//     // while we in foreground mode, otherwise it will not show ant notification
//     const DarwinInitializationSettings appleConfigs = DarwinInitializationSettings();
//
//     const initializationsSettings = InitializationSettings(
//       android: androidConfigs,
//       iOS: appleConfigs,
//     );
//
//     await flutterLocalNotificationsPlugin.initialize(
//       initializationsSettings,
//       // "onDidReceiveNotificationResponse" is necessary while user clicks on notification and app is in the foreground
//       // so, it is the logic of handling tapping in foreground mode
//       // for foreground notifications I use another package called "flutter_local_notifications" (I did that from docs)
//       // that shows notification. Foreground mode does not work properly with "firebase_messaging" package
//       // I when I show that notification in foreground I save "data" in "payload" (take a look at "_foregroundMessageHandler" function)
//       // So, whenever user clicks on notification I parse that payload and navigate to specific screen
//       // Remember!!! This logic works fine in background mode and I get those "data" directly from "data" property of the message
//       // --- take a look at "notificationAppLaunchDetails" function ---
//       onDidReceiveNotificationResponse: (NotificationResponse response) {
//         if (response.payload != null) {
//           final Map<String, dynamic>? payloadConverter = jsonDecode(response.payload ?? "{}");
//           if (payloadConverter != null &&
//               payloadConverter.isNotEmpty &&
//               payloadConverter.containsKey('screen')) {
//             onRedirect?.call("${payloadConverter['screen']}", payloadConverter);
//           }
//         }
//       },
//     );
//   }
//
//   // works whenever user enters to the application (while it was terminated) by clicking on notification
//   //
//   // Because of that: iOS handles notifications by system (with firebase_messaging package) and for Android I use flutter_local_notification package...
//   // I have to handle "on notification tap" logic differently
//   // So,
//   // for ios: logic will be handled by firebase_messaging package
//   // for android: I do that with flutter_local_notifications package
//   Future<void> notificationAppLaunchDetails({
//     void Function(String screen, Map<String, dynamic>? data)? onRedirect,
//   }) async {
//     if (defaultTargetPlatform == TargetPlatform.android) {
//       final notificationOnLaunch =
//       await _flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();
//       if (notificationOnLaunch != null && notificationOnLaunch.didNotificationLaunchApp) {
//         final notificationResponse = notificationOnLaunch.notificationResponse;
//         if (notificationResponse != null) {
//           final Map<String, dynamic> payloadConverter = jsonDecode(
//             notificationResponse.payload ?? "{}",
//           );
//           if (payloadConverter.isNotEmpty && payloadConverter.containsKey('screen')) {
//             onRedirect?.call("${payloadConverter['screen']}", payloadConverter);
//           }
//         }
//       }
//     } else if (defaultTargetPlatform == TargetPlatform.iOS) {
//       bool redirected = false;
//       final RemoteMessage? initialMessage = await FirebaseMessaging.instance.getInitialMessage();
//
//       if (initialMessage != null && initialMessage.data.isNotEmpty) {
//         redirected = true;
//         onRedirect?.call("${initialMessage.data['screen']}", initialMessage.data);
//       }
//
//       FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
//         if (message.notification != null) {
//           if (!redirected) onRedirect?.call("${message.data['screen']}", message.data);
//         }
//       });
//     }
//   }
//
//   Future<bool> checkNotificationPermission({void Function()? notificationPopup}) async {
//     final NotificationSettings permission = await FirebaseMessaging.instance.requestPermission();
//
//     final authorized = permission.authorizationStatus == AuthorizationStatus.authorized;
//     final provisional = permission.authorizationStatus == AuthorizationStatus.provisional;
//
//     if (!authorized && !provisional) {
//       notificationPopup?.call();
//       return false;
//     }
//
//     return true;
//   }
//
//   Future<void> _foregroundMessageHandler(
//       final RemoteMessage message, {
//         void Function(String type, Map<String, dynamic>? data)? onForegroundNotification,
//       }) async {
//     _logger.log(
//       Level.debug,
//       "foreground messaging: ${message.notification?.toMap()} | ${message.data}",
//     );
//     await _showNotification(
//       _flutterLocalNotificationsPlugin,
//       _reusableGlobalFunctions,
//       message.data,
//       onForegroundNotification: onForegroundNotification,
//     );
//   }
//
//   // not necessary at all, cause background notification will be displayed automatically by firebase
//   // messaging package
//   @pragma('vm:entry-point')
//   static Future<void> _backgroundMessageHandler(RemoteMessage message) async {
//     // final notification = message.notification?.toMap();
//     // final data = message.data;
//     if (kDebugMode) {
//       debugPrint("background messaging: ${message.notification?.toMap()} | ${message.data}");
//     }
//     final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
//
//     final reusableGlobalFunctions = ReusableGlobalFunctions.instance;
//
//     // other default settings both for android and ios
//     await _initSettings(flutterLocalNotificationsPlugin);
//
//     await _showNotification(flutterLocalNotificationsPlugin, reusableGlobalFunctions, message.data);
//   }
//
//   static Future<void> _showNotification(
//       final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin,
//       final ReusableGlobalFunctions reusableGlobalFunctions,
//       final Map<String, dynamic> notificationData, {
//         final void Function(String type, Map<String, dynamic>? data)? onForegroundNotification,
//       }) async {
//     if (notificationData.isNotEmpty &&
//         (notificationData.containsKey('title') || notificationData.containsKey('body'))) {
//       //
//       StyleInformation? styleInformation;
//       ByteArrayAndroidBitmap? byteArrayAndroidBitmap;
//       DarwinNotificationAttachment? iosNotificationAttachment;
//
//       if (notificationData.containsKey('image') &&
//           notificationData['image'] != null &&
//           notificationData['image'] is String &&
//           (notificationData['image'] as String).contains('http')) {
//         // LOGIC FOR SHOWING IMAGE
//         final request = await HttpClient().getUrl(Uri.parse("${notificationData['image']}"));
//         final response = await request.close();
//         final bytes = await consolidateHttpClientResponseBytes(response);
//
//         // ---- ANDROID ----
//         if (defaultTargetPlatform == TargetPlatform.android) {
//           final base64Str = base64Encode(bytes);
//           byteArrayAndroidBitmap = ByteArrayAndroidBitmap.fromBase64String(base64Str);
//           styleInformation = BigPictureStyleInformation(
//             byteArrayAndroidBitmap,
//             largeIcon: byteArrayAndroidBitmap,
//             hideExpandedLargeIcon: true,
//           );
//         }
//
//         // ---- iOS ----
//         // Notification image for ios is showing only on foreground
//         // could not write logic for handling image on background
//         if (defaultTargetPlatform == TargetPlatform.iOS) {
//           final directory = await getTemporaryDirectory();
//           final filePath =
//               '${directory.path}/notification_image_${reusableGlobalFunctions.randomId()}.jpg';
//           final file = File(filePath);
//           await file.writeAsBytes(bytes);
//           iosNotificationAttachment = DarwinNotificationAttachment(filePath, hideThumbnail: false);
//         }
//       }
//
//       if (notificationData.containsKey('search_id')) {
//         final id = int.tryParse("${notificationData['search_id']}");
//         final count = int.tryParse("${notificationData['search_count']}");
//         onForegroundNotification?.call(searchNotificationType, {"id": id, "count": count});
//       }
//
//       await flutterLocalNotificationsPlugin.show(
//         notificationData.hashCode,
//         notificationData['title'] as String?,
//         notificationData['body'] as String?,
//         NotificationDetails(
//           android: AndroidNotificationDetails(
//             _androidChannelId,
//             _androidChannelName,
//             channelDescription: _androidChannelDescription,
//             icon: _androidAppIcon,
//             importance: Importance.max,
//             priority: Priority.high,
//             styleInformation: styleInformation,
//             largeIcon: byteArrayAndroidBitmap,
//             // The "ticker" text is passed here is optional and specific to Android. This allows for
//             // text to be shown in the status bar on older versions of Android when the notification is shown.
//             ticker: 'ticker',
//           ),
//           iOS: DarwinNotificationDetails(
//             attachments: iosNotificationAttachment == null ? null : [iosNotificationAttachment],
//           ),
//         ),
//         payload: jsonEncode(notificationData),
//       );
//     }
//   }
// }
