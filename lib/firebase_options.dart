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
    apiKey: 'AIzaSyCoQ1bBUxN24gb6jRt1IRnx5Hc8MlHjN2E',
    appId: '1:1077667384080:web:3505e58fcdbe0e245bb395',
    messagingSenderId: '1077667384080',
    projectId: 'chesscursion',
    authDomain: 'chesscursion.firebaseapp.com',
    storageBucket: 'chesscursion.appspot.com',
    measurementId: 'G-CCNPWELC02',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCQ0pWgLTz6FOuf2eVYccNngu9w_8ILd-8',
    appId: '1:1077667384080:android:6c9406c4d00c54eb5bb395',
    messagingSenderId: '1077667384080',
    projectId: 'chesscursion',
    storageBucket: 'chesscursion.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDgvKxu-zNQeKlN5LmfnbEdLxb4A82nrTQ',
    appId: '1:1077667384080:ios:94e49d243c8540915bb395',
    messagingSenderId: '1077667384080',
    projectId: 'chesscursion',
    storageBucket: 'chesscursion.appspot.com',
    iosClientId: '1077667384080-qmfjar6t7ls297b4fc66ualbkc5jj7nt.apps.googleusercontent.com',
    iosBundleId: 'com.example.chesscursionCreator',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDgvKxu-zNQeKlN5LmfnbEdLxb4A82nrTQ',
    appId: '1:1077667384080:ios:91ae9a739ab2769e5bb395',
    messagingSenderId: '1077667384080',
    projectId: 'chesscursion',
    storageBucket: 'chesscursion.appspot.com',
    iosClientId: '1077667384080-fg03p8oj4pfaj9h7f1n2v2nnsgkfo3g7.apps.googleusercontent.com',
    iosBundleId: 'com.example.chesscursionCreator.RunnerTests',
  );
}