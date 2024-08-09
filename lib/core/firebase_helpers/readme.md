in order to avoid unexpected error try to add this 

        dependencies {

        implementation platform('com.google.firebase:firebase-bom:33.0.0')
        implementation 'com.facebook.android:facebook-login:latest.release'
    
        }

in the end in your android android/app/build.gradle file