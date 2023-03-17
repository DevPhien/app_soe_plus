import 'dart:io';

import 'package:device_preview/device_preview.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app_icon_badge/flutter_app_icon_badge.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
//import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
//import 'package:window_manager/window_manager.dart';

import 'firebase_options.dart';
import 'route/route.dart';
import 'utils/golbal/golbal.dart';
import 'views/unknownroutepage.dart';

Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
}

Future<void> main() async {
  ErrorWidget.builder = (FlutterErrorDetails flutterErrorDetails) =>
      errorScreen(flutterErrorDetails.exception);
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  //await Firebase.initializeApp();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  // Set the background messaging handler early on, as a named top-level function
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  if (!kIsWeb) {
    /// Update the iOS foreground notification presentation options to allow
    /// heads up notifications.
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  }
  Golbal.isfirebase =
      kIsWeb || (defaultTargetPlatform != TargetPlatform.windows);
  //if (!kIsWeb && defaultTargetPlatform == TargetPlatform.windows) {
  //await windowManager.ensureInitialized();
  //await windowManager.maximize();
  //}
  await GetStorage.init();
  // if (defaultTargetPlatform == TargetPlatform.android ||
  //     defaultTargetPlatform == TargetPlatform.iOS) {
  //   runApp(const MyApp());
  // } else {
  //   runApp(
  //     DevicePreview(
  //       enabled: true,
  //       isToolbarVisible: false,
  //       backgroundColor: const Color(0xFF303030),
  //       builder: (context) => const MyApp(), // Wrap your app
  //     ),
  //   );
  // }
  runApp(const MyApp());
  configLoading();
}

void configLoading() {
  EasyLoading.instance
    ..displayDuration = const Duration(milliseconds: 2000)
    ..indicatorType = EasyLoadingIndicatorType.fadingCircle
    ..loadingStyle = EasyLoadingStyle.dark
    ..indicatorSize = 45.0
    ..radius = 10.0
    ..progressColor = Colors.yellow
    ..backgroundColor = Colors.green
    ..indicatorColor = Colors.yellow
    ..textColor = Colors.yellow
    ..maskColor = Colors.blue.withOpacity(0.5)
    ..userInteractions = true
    ..dismissOnTap = false;
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light.copyWith(
      statusBarColor: Colors.transparent,
    ));
    return GetMaterialApp(
      useInheritedMediaQuery: true,
      debugShowCheckedModeBanner: false,
      //showPerformanceOverlay: true,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('vi', "VN"),
      ],
      locale: const Locale('vi', "VN"),
      title: 'Smart Office',
      scrollBehavior: ScrollConfiguration.of(context).copyWith(
        scrollbars: false,
        dragDevices: {
          PointerDeviceKind.mouse,
          PointerDeviceKind.touch,
        },
      ),
      builder: EasyLoading.init(),
      theme: ThemeData(
        pageTransitionsTheme: const PageTransitionsTheme(builders: {
          TargetPlatform.android: CupertinoPageTransitionsBuilder(),
          TargetPlatform.macOS: CupertinoPageTransitionsBuilder(),
          TargetPlatform.windows: CupertinoPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder()
        }),
        primarySwatch: Colors.blue,
        // textTheme: GoogleFonts.latoTextTheme(
        //   Theme.of(context).textTheme,
        // ),
      ),
      //home: const SplashScreen(),
      getPages: RouterGet.route,
      unknownRoute:
          GetPage(name: '/notfound', page: () => const UnknownRoutePage()),
      initialRoute: "/splashscreen",
      defaultTransition: Transition.native,
    );
  }
}

Widget errorScreen(dynamic detailsException) {
  return Scaffold(
    backgroundColor: Colors.white,
    appBar: AppBar(
      elevation: 0.0,
      backgroundColor: Colors.white,
      iconTheme: const IconThemeData(color: Colors.black45),
      titleSpacing: 0.0,
      centerTitle: true,
      title: Text("Error", style: TextStyle(color: Golbal.appColor)),
      systemOverlayStyle: SystemUiOverlayStyle.dark,
    ),
    body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Lottie.network(
                    "https://assets3.lottiefiles.com/packages/lf20_aaesnvcw.json"),
              ),
              const SizedBox(height: 5.0),
              MaterialButton(
                height: 45,
                minWidth: 200,
                shape: RoundedRectangleBorder(
                    // ignore: unnecessary_new
                    borderRadius: new BorderRadius.circular(8)),
                onPressed: () async {
                  if (kIsWeb) return;
                  var isbadge = await FlutterAppIconBadge.isAppBadgeSupported();
                  if (isbadge) FlutterAppIconBadge.removeBadge();
                  exit(0);
                },
                color: Golbal.appColor,
                child: const Text(
                  "Xoá bộ nhớ Cache",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 30.0),
            ],
          ),
        )),
  );
}
