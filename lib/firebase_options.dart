// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for ios - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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
    apiKey: 'AIzaSyBuqRJ65YOWkPKruUfNekaekYqsH174HNw',
    appId: '1:680615551294:web:7f93f682ef51d13e014c6f',
    messagingSenderId: '680615551294',
    projectId: 'learn-iot-esp32',
    authDomain: 'learn-iot-esp32.firebaseapp.com',
    databaseURL: 'https://learn-iot-esp32-default-rtdb.firebaseio.com',
    storageBucket: 'learn-iot-esp32.appspot.com',
    measurementId: 'G-R66Z92QP0T',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBqGsfGsi83aTUtJIlqaJFS2lcNAHAnHJs',
    appId: '1:680615551294:android:acd2dd15ae3c5d03014c6f',
    messagingSenderId: '680615551294',
    projectId: 'learn-iot-esp32',
    databaseURL: 'https://learn-iot-esp32-default-rtdb.firebaseio.com',
    storageBucket: 'learn-iot-esp32.appspot.com',
  );
}
