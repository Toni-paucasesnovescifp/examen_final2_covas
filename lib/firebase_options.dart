// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
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
        return ios;
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.windows:
        return windows;
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
    apiKey: 'AIzaSyC2dnfDyv6tSMSxayT1dMypjiztjKnt6vw',
    appId: '1:832497748821:web:8cc120c2ba0fd1405b7ddc',
    messagingSenderId: '832497748821',
    projectId: 'flutter-app-productes-74d4d',
    authDomain: 'flutter-app-productes-74d4d.firebaseapp.com',
    databaseURL: 'https://flutter-app-productes-74d4d-default-rtdb.europe-west1.firebasedatabase.app',
    storageBucket: 'flutter-app-productes-74d4d.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCkYGh8yuCQ3eUx3MhVeE2D6Fc1b_URxS4',
    appId: '1:832497748821:android:f4a0ca1b22987aa45b7ddc',
    messagingSenderId: '832497748821',
    projectId: 'flutter-app-productes-74d4d',
    databaseURL: 'https://flutter-app-productes-74d4d-default-rtdb.europe-west1.firebasedatabase.app',
    storageBucket: 'flutter-app-productes-74d4d.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAhwrBnzxEWV5Fo8-SMvpc4fyO-vLbTSFw',
    appId: '1:832497748821:ios:a70ee2107c2e5a875b7ddc',
    messagingSenderId: '832497748821',
    projectId: 'flutter-app-productes-74d4d',
    databaseURL: 'https://flutter-app-productes-74d4d-default-rtdb.europe-west1.firebasedatabase.app',
    storageBucket: 'flutter-app-productes-74d4d.firebasestorage.app',
    iosBundleId: 'com.example.productesApp',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyC2dnfDyv6tSMSxayT1dMypjiztjKnt6vw',
    appId: '1:832497748821:web:9be9d0a14b2075325b7ddc',
    messagingSenderId: '832497748821',
    projectId: 'flutter-app-productes-74d4d',
    authDomain: 'flutter-app-productes-74d4d.firebaseapp.com',
    databaseURL: 'https://flutter-app-productes-74d4d-default-rtdb.europe-west1.firebasedatabase.app',
    storageBucket: 'flutter-app-productes-74d4d.firebasestorage.app',
  );
}
