// File generated from Firebase Console
// Project ID: couple-mood-f5dc1
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyBXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX', // Bạn cần lấy từ Firebase Console
    appId: '1:396608344584:web:xxxxxxxxxxxxx',
    messagingSenderId: '396608344584',
    projectId: 'couple-mood-f5dc1',
    authDomain: 'couple-mood-f5dc1.firebaseapp.com',
    databaseURL: 'https://couple-mood-f5dc1-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'couple-mood-f5dc1.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX', // Bạn cần lấy từ Firebase Console
    appId: '1:396608344584:android:xxxxxxxxxxxxx',
    messagingSenderId: '396608344584',
    projectId: 'couple-mood-f5dc1',
    databaseURL: 'https://couple-mood-f5dc1-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'couple-mood-f5dc1.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyEXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX', // Bạn cần lấy từ Firebase Console
    appId: '1:396608344584:ios:xxxxxxxxxxxxx',
    messagingSenderId: '396608344584',
    projectId: 'couple-mood-f5dc1',
    databaseURL: 'https://couple-mood-f5dc1-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'couple-mood-f5dc1.firebasestorage.app',
    iosBundleId: 'com.example.coupleMoodMobile',
  );
}
