add this packages in your pubspec.yaml file:

    flutter_facebook_auth: ^7.0.1
    crypto: ^3.0.3


for more info take a look this website

1. https://firebase.flutter.dev/docs/auth/social#facebook
2. https://facebook.meedu.app/docs/7.x.x/intro

do whatever says the docs

Before getting started setup your
Facebook Developer App and follow the setup process to enable Facebook Login.

## REMEMBER IT IS BETTER TO CREATE NEW FACEBOOK APP IN FACEBOOK DEV CONSOLE

Here is a config code for Info.plist file. Google sign in scheme also added
in order to introduce how it will look like 

    <key>CFBundleURLTypes</key>
    <array>
        <!-- Google Sign-In scheme -->
        <dict>
            <key>CFBundleTypeRole</key>
            <string>Editor</string>
            <key>CFBundleURLSchemes</key>
            <array>
                <string>com.googleusercontent.apps.403332127037-0ppdtbiseopqftdpkee8fo04sdg7eb0v</string>
            </array>
        </dict>
         <!-- Facebook scheme -->
        <dict>
              <key>CFBundleTypeRole</key>
              <string>Editor</string>
              <key>CFBundleURLSchemes</key>
              <array>
                 <!-- The configuration should look like this ->   fbTHE_APP_ID    that is why dont forget to put fb at start -->
                 <string>fb2233168260355735</string>
              </array>
        </dict>
    </array>

    <!-- Facebook configuration -->
    <key>FacebookAppID</key>
    <string>2233168260355735</string>
    <key>FacebookClientToken</key>
    <string>ce7f69971f50e5eeb148b890aee6038c</string>
    <key>FacebookDisplayName</key>
    <string>Yahay</string>

    <!-- To use any of the Facebook dialogs (e.g., Login, Share, App Invites, etc.) that can perform an app switch to Facebook apps, your application's Info.plist also needs to include the following:  -->
    <key>LSApplicationQueriesSchemes</key>
    <array>
      <string>fbapi</string>
      <string>fb-messenger-share-api</string>
    </array>


in order to generate code for Android Key Hashes

in mac
    
    keytool -exportcert -alias androiddebugkey -keystore /Users/amanullah/.android/debug.keystore
    | openssl sha1 -binary | openssl base64 | cut -c1-28

in windows -> you have to first download openssl:

1. https://code.google.com/archive/p/openssl-for-windows/downloads

for more info about in windows is here

1. https://www.youtube.com/watch?v=Ai3QWQ_1pJM&t=308s

    keytool -exportcert -alias androiddebugkey -keystore "C:\Users\amanullah\.android\debug.keystore"
    | "C:\Users\amanullah\Desktop\openssl-0.9.8k_WIN32\bin\openssl" sha1 -binary | "C:\Users\amanullah\Desktop\openssl-0.9.8k_WIN32\bin\openssl" base64


if you will get error on auth check this github solution:

1. https://github.com/firebase/flutterfire/issues/13015

in order to avoid error in andorid try to add this code in the of your android/app/build.gradle file:


        dependencies {

        implementation platform('com.google.firebase:firebase-bom:33.0.0')
        implementation 'com.facebook.android:facebook-login:latest.release'
    
        }

## IN THE END REMEMBER TO MAKE RIGHT CONFIGURATION OF YOUR AndroidManifest.xml file otherwise it will not work
### Take a look inside "android/app/src/main/res/values" file and take look "android/app/src/main/AndroidManifest.xml"
### in order to figure out what's going on


WEB configuration :

    Future<void> main() async {
    // check if is running on Web
        if (kIsWeb) {
        // initialize the facebook javascript SDK
        await FacebookAuth.i.webAndDesktopInitialize(
            appId: "YOUR_FACEBOOK_APP_ID",
            cookie: true,
            xfbml: true,
            version: "v15.0",
        );
        }
        runApp(MyApp());
    }