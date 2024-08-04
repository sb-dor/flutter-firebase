import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';

// Analytics automatically logs some events for you; you don't need to add any code to receive them.
// If your app needs to collect additional data, you can log up to 500 different Analytics Event types in your app.
// There is no limit on the total volume of events your app logs.
// Note that event names are case-sensitive and that logging two events whose names differ only in
// case will result in two distinct events.
class FirebaseAnalyticsHelper {
  //
  final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;

  FirebaseAnalytics get analytics => _analytics;

  // custom events

  // Generally, events logged by your app are batched together over the period of approximately one
  // hour and uploaded together. This approach conserves the battery on end users’ devices and reduces
  // network data usage. However, for the purposes of validating your Analytics implementation (and,
  // in order to view your Analytics in the DebugView report), you can enable debug mode on your
  // development device to upload events with a minimal delay.
  Future<void> analyticsLogEvent({
    required String logEvent,
    required Map<String, Object> parameters,
  }) async {
    try {
      await _analytics.logEvent(
        name: logEvent,
        parameters: parameters,
      );
    } on Exception catch (e) {
      debugPrint("log event error is $e");
    }
  }

  //
  Future<void> analyticsSetUserProperty() async {}
}
