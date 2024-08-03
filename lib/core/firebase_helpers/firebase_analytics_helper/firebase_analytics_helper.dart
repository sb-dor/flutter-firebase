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

  //
  Future<void> analyticsLogEvent({
    required String logEvent,
    required Map<String, Object> parameters,
  }) async {
    try {
      await _analytics.logEvent(
        name: logEvent,
        parameters: parameters,
      );
      // await _analytics.logAddToCart(items: [
      //   AnalyticsEventItem(itemName: "Av"),
      // ], value: 10, currency: "USD");
    } on Exception catch (e) {
      debugPrint("log event error is $e");
    }
  }
}
