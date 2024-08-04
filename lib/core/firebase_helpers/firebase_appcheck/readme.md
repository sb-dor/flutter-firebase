App Check helps protect your backend resources (such as Cloud Storage) from abuse (such as billing fraud or phishing).

With App Check, devices running your app will use an app identity attestation provider to certify it
is indeed your authentic app, and may also check that it's running on an authentic, untampered device.
This certification is attached to every request your app makes to your Firebase backend resources.

for more info about "AppCheck" have a look this link:
(in order to integrate with app check go through this link)

1. https://firebase.flutter.dev/docs/app-check/overview

add the package in your pubspec.yaml file

    firebase_app_check: ^0.3.0+4




