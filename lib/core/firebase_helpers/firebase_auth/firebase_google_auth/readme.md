for ios in order to add google sign in add
go the google website:

https://developers.google.com/identity/sign-in/ios/start-integrating?hl=ru#add_a_url_scheme_for_google_sign-in_to_your_project

and create id for your project for IOS

then add this line in your Info.plis:

    <key>CFBundleURLTypes</key>
    <array>
        <dict>
            <key>CFBundleTypeRole</key>
            <string>Editor</string>
            <key>CFBundleURLSchemes</key>
            <array>
                <string>YOUR_IOS_BUNDLE_ID</string>
            </array>
        </dict>
        <dict>
            <key>CFBundleTypeRole</key>
            <string>Editor</string>
            <key>CFBundleURLSchemes</key>
            <array>
                <string>com.googleusercontent.apps.GENERATED_ID_HERE</string>
            </array>
        </dict>
        <dict>
            <key>CFBundleTypeRole</key>
            <string>Editor</string>
            <key>CFBundleURLSchemes</key>
            <array>
                <string>***Something here***</string>
            </array>
        </dict>
    </array>


in order to create google auth in android you have to create
an upload keystore file and register sha key (sha-1 especially) in firebase settings for android
take a look this link for creating an upload keystore file - (otherwise in will not work)

1. https://docs.flutter.dev/deployment/android

and after putting sha (sha-1 especially) in your firebase project's setting do not forget to download new 
google-service.json file and put inside android/app folder


for more information about facebook and google ath take a look to the
android and ios folder -> AndroidManifest.xml and Info.plist

