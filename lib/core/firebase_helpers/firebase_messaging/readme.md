### REMEMBER THAT THIS CONFIGURATION OF HANDLING NOTIFICATION IS ONLY FROM FIREBASE
### IF YOU WANT TO INTEGRATE WITH YOUR OWN SERVER HANDLING WILL BE A LITTLE BIT DIFFERENT


for more info take a look this websites:

1. https://firebase.flutter.dev/docs/messaging/overview
2. https://youtu.be/k0zGEbiDJcQ

add this packages in you pubspec.yaml

    firebase_messaging: ^15.0.4
    awesome_notifications: ^0.9.3+1
    awesome_notifications_core: ^0.9.3
    firebase_core: ^3.3.0

do android and ios config:

1. https://pub.dev/packages/awesome_notifications
2. https://firebase.google.com/docs/cloud-messaging/flutter/client

add this implementation in android\app\build.gradle:

    dependencies {
        implementation 'com.google.firebase:firebase-messaging:23.1.2'
    }

ios configuration is in awesome notification package's website

if you get and error NULL CHECK OPERATOR USED ON ON A NULL VALUE:
take a look this article

1. https://stackoverflow.com/questions/67304706/flutter-fcm-unhandled-exception-null-check-operator-used-on-a-null-value