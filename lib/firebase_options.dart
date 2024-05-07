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
        return macos;
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
    apiKey: 'AIzaSyBH2whkP9pY5WGrKqQBQnW15tnLCQwQaCY',
    appId: '1:530197448339:web:873cbd38c57f7611faef66',
    messagingSenderId: '530197448339',
    projectId: 'chat-app-c2a84',
    authDomain: 'chat-app-c2a84.firebaseapp.com',
    storageBucket: 'chat-app-c2a84.appspot.com',
    measurementId: 'G-R50YMCDDD9',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBxkud-1p_1BV53pQEupLC_CJM2JsgzG_8',
    appId: '1:530197448339:android:13532a313446bc92faef66',
    messagingSenderId: '530197448339',
    projectId: 'chat-app-c2a84',
    storageBucket: 'chat-app-c2a84.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCju-wrb88RuzSIDott1x6YjGIV284yYHo',
    appId: '1:530197448339:ios:c98a100dee2f7bf3faef66',
    messagingSenderId: '530197448339',
    projectId: 'chat-app-c2a84',
    storageBucket: 'chat-app-c2a84.appspot.com',
    iosBundleId: 'com.example.chatApp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCju-wrb88RuzSIDott1x6YjGIV284yYHo',
    appId: '1:530197448339:ios:c98a100dee2f7bf3faef66',
    messagingSenderId: '530197448339',
    projectId: 'chat-app-c2a84',
    storageBucket: 'chat-app-c2a84.appspot.com',
    iosBundleId: 'com.example.chatApp',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyBH2whkP9pY5WGrKqQBQnW15tnLCQwQaCY',
    appId: '1:530197448339:web:a27d29db89f30c0cfaef66',
    messagingSenderId: '530197448339',
    projectId: 'chat-app-c2a84',
    authDomain: 'chat-app-c2a84.firebaseapp.com',
    storageBucket: 'chat-app-c2a84.appspot.com',
    measurementId: 'G-PEXP10KXHE',
  );
}
