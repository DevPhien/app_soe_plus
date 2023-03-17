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
        return macos;
      case TargetPlatform.linux:
        return macos;
      default:
        return macos;
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyBvuCPgl-Rb-mLypJCL0Xw2Tj_x7P46DDg',
    appId: '1:974921430368:web:38a79e06d7e113b3095a05',
    messagingSenderId: '974921430368',
    projectId: 'soe-2020',
    authDomain: 'soe-2020.firebaseapp.com',
    databaseURL: 'https://soe-2020.firebaseio.com',
    storageBucket: 'soe-2020.appspot.com',
    measurementId: 'G-CR08SWJYBV',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCKCVI1JZ7rqEgN52tyDK_A2iOkV7aMHvw',
    appId: '1:974921430368:android:dee64af9cbfd0b8d095a05',
    messagingSenderId: '974921430368',
    projectId: 'soe-2020',
    databaseURL: 'https://soe-2020.firebaseio.com',
    storageBucket: 'soe-2020.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDjkCjQkJQ4uOGgs3-eIF97bnhV5GMii9Q',
    appId: '1:974921430368:ios:8b148020162fefe0095a05',
    messagingSenderId: '974921430368',
    projectId: 'soe-2020',
    databaseURL: 'https://soe-2020.firebaseio.com',
    storageBucket: 'soe-2020.appspot.com',
    androidClientId:
        '974921430368-a8ngres6smbi7s9r869tq76icr5uhb2c.apps.googleusercontent.com',
    iosClientId:
        '974921430368-qlkhgt860rjjhs7urfbc0nnuovbuoua4.apps.googleusercontent.com',
    iosBundleId: 'vn.soe.orientsoft',
  );
  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDjkCjQkJQ4uOGgs3-eIF97bnhV5GMii9Q',
    appId: '1:974921430368:ios:8b148020162fefe0095a05',
    messagingSenderId: '974921430368',
    projectId: 'soe-2020',
    databaseURL: 'https://soe-2020.firebaseio.com',
    storageBucket: 'soe-2020.appspot.com',
    androidClientId:
        '974921430368-a8ngres6smbi7s9r869tq76icr5uhb2c.apps.googleusercontent.com',
    iosClientId:
        '974921430368-qlkhgt860rjjhs7urfbc0nnuovbuoua4.apps.googleusercontent.com',
    iosBundleId: 'vn.soe.orientsoft',
  );
}