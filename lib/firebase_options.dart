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
        return ios;
      case TargetPlatform.macOS:
        return macos;
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
    apiKey: 'AIzaSyDumScMFYiAzf9k6ECHhj_0rf8MYhYArIk',
    appId: '1:664849248516:web:c45f6afe1b77757596e051',
    messagingSenderId: '664849248516',
    projectId: 'testing-450ca',
    authDomain: 'testing-450ca.firebaseapp.com',
    storageBucket: 'testing-450ca.appspot.com',
    measurementId: 'G-YQEVMEJTB1',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCLaKfglgYO2U3zGTRS6YMz5v0iIick_cg',
    appId: '1:664849248516:android:b4e4633bc829e72296e051',
    messagingSenderId: '664849248516',
    projectId: 'testing-450ca',
    storageBucket: 'testing-450ca.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCtYu3uG9PqvJN64Ijw5tOqwrUPEljWnUw',
    appId: '1:664849248516:ios:7ab5b3e6cb3407fb96e051',
    messagingSenderId: '664849248516',
    projectId: 'testing-450ca',
    storageBucket: 'testing-450ca.appspot.com',
    iosBundleId: 'com.example.mingo',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCtYu3uG9PqvJN64Ijw5tOqwrUPEljWnUw',
    appId: '1:664849248516:ios:5a53253f3d05ded096e051',
    messagingSenderId: '664849248516',
    projectId: 'testing-450ca',
    storageBucket: 'testing-450ca.appspot.com',
    iosBundleId: 'com.example.mingo.RunnerTests',
  );
}
