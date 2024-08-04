more info here:

1. https://firebase.flutter.dev/docs/analytics/overview

take a look to youtube video:

1. https://www.youtube.com/watch?v=hMUO8Vz-z0E&t=279s

about how to turn debug mode in order to see log faster take a look here

1. https://firebase.google.com/docs/analytics/debugview?hl=ru

add this package in yor pubspec.yaml file

    firebase_analytics: ^11.2.1

------------------------------------------------

#READ THIS!:

Debug events

DebugView enables you to see the raw event data logged by your app on development devices in near real-time.
This is very useful for validation purposes during the instrumentation phase of development and can help you
discover errors and mistakes in your Analytics implementation and confirm that all events and user properties are logged correctly.



Enable debug mode

Generally, events logged by your app are batched together over the period of approximately one hour and uploaded together.
This approach conserves the battery on end users’ devices and reduces network data usage. However,
for the purposes of validating your Analytics implementation (and, in order to view your Analytics in the DebugView report),
you can enable debug mode on your development device to upload events with a minimal delay.


--------------------------------------------

about all firebase analytics events and params take a look this links:

1. https://firebase.google.com/docs/reference/android/com/google/firebase/analytics/FirebaseAnalytics.Event
2. https://firebase.google.com/docs/reference/android/com/google/firebase/analytics/FirebaseAnalytics.Param