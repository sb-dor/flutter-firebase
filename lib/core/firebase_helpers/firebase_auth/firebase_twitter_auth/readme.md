add this package in your pubspec.yaml file:

    twitter_login

for more info take a look this links:

1. https://firebase.flutter.dev/docs/auth/social#twitter
2. https://pub.dev/packages/twitter_login
3. https://youtu.be/Jp9g-b1PPS0?t=374&si=88NnpRongVMFem3r


add this code in your AndroidManifest.xml file
for more info take a look "android/app/src/main/res/values/string_example.xml" path

     <intent-filter>
                <action android:name="android.intent.action.VIEW" />

                <category android:name="android.intent.category.DEFAULT" />
                <category android:name="android.intent.category.BROWSABLE" />
                <!-- Accepts URIs that begin with "example://gizmos” -->
                <!-- Registered Callback URLs in TwitterApp -->
                <data android:scheme="socialauth" /> <!-- is necessary -->
            </intent-filter>

# REMEMBER TO CONFIG YOUR TWITTER APP IN DEV CONSOLE WITH "socialauth://" Callback URI / Redirect URL

add this code in your Info.plist file
for more info take a look "ios/Runner/Info.plist" path

        <dict>
            <key>CFBundleTypeRole</key>
                <string>Editor</string>
            <key>CFBundleURLName</key>
            <string></string>
                <key>CFBundleURLSchemes</key>
            <array>
                <!-- Registered Callback URLs in TwitterApp -->
                <string>socialauth</string>
            </array>
        </dict>

