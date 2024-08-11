import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter_firebase/core/getit/getit_init.dart';
import 'package:flutter_firebase/core/shared_pref/shared_pref.dart';

class AwesomeNotificationHelper {
  final SharedPref _sharedPref = getit<SharedPref>();

  // init notification here
  Future<void> initAwesomeNotifications() async {
    await AwesomeNotifications().initialize(
      null,
      [
        NotificationChannel(
          // here can be any id. Putting id do not forget to put this id everywhere in channels_key
          channelKey: "test-firebase-notification-id",
          channelName: "Firebase app test notification",
          channelDescription: "Desc for firebase app test notification",
          importance: NotificationImportance.Max,
          channelShowBadge: true,
          onlyAlertOnce: true,
          playSound: true,
          criticalAlerts: true,
        ),
      ],
    );

    AwesomeNotifications().isNotificationAllowed().then(
      (allowed) async {
        if (!allowed) {
          await AwesomeNotifications().requestPermissionToSendNotifications();
        }
        await _clearAllNotifications();
      },
    );
  }

  Future<void> showAwesomeNotification({
    required String title,
    required String body,
    required String? image,
  }) async {
    if (image != null) {
      await showNotificationWithBigImageImage(title: title, body: body, image: image);
    } else {
      await showSimpleNotification(title: title, body: body);
    }
  }

  Future<void> showNotificationWithBigImageImage({
    required String title,
    required String body,
    required String? image,
  }) async {
    // debugPrint("notification image: ${ApiSettings.MAIN_URL}/get-promo-banner-img/$image");
    //if you want to show notification every time create and save "id" in shared_preferences and get that
    AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: await _lastNotificationId(),
        channelKey: "test-firebase-notification-id",
        title: title,
        body: body,
        bigPicture: image,
        notificationLayout:
            image == null ? NotificationLayout.Messaging : NotificationLayout.BigPicture,
      ),
    );
  }

  Future<void> showSimpleNotification({
    required String title,
    required String body,
  }) async {
    //if you want to show notification every time create and save "id" in shared_preferences and get that
    AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: await _lastNotificationId(),
        channelKey: "test-firebase-notification-id",
        title: title,
        body: body,
      ),
    );
  }

  Future<int> _lastNotificationId() async {
    int lastNotificationId = _sharedPref.getIntByKey(key: 'last_notify_id') ?? 0;
    lastNotificationId++;
    await _sharedPref.saveInt(key: "last_notify_id", value: lastNotificationId);
    return lastNotificationId;
  }

  Future<void> _clearAllNotifications() async {
    await AwesomeNotifications().cancelAll();
    // await _updateNotificationBadge();
  }

//  Future<void> _updateNotificationBadge() async {
//   await FlutterAppBadger.removeBadge();
//   await FlutterAppBadger.updateBadgeCount(0);
// }
}
