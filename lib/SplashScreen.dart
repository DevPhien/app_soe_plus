// ignore: file_names
import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:page_transition/page_transition.dart';
import 'utils/golbal/golbal.dart';
import 'views/home/home.dart';
import 'views/intro/intro.dart';
import 'views/login/login.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  var duration = const Duration(seconds: 2);
  final Connectivity _connectivity = Connectivity();
  initStore() async {
    await Golbal.initStore();
    if (!Golbal.store.intro) {
      Golbal.store.intro = true;
      Navigator.of(context).pushAndRemoveUntil(
          PageTransition(type: PageTransitionType.fade, child: const Intro()),
          (Route<dynamic> r) => false);
    } else if (Golbal.store.login) {
      Navigator.of(context).pushAndRemoveUntil(
          PageTransition(type: PageTransitionType.fade, child: const Home()),
          (Route<dynamic> r) => false);
    } else {
      Navigator.of(context).pushAndRemoveUntil(
          PageTransition(
              type: PageTransitionType.fade, child: const LoginPage()),
          (Route<dynamic> r) => false);
    }
  }

  @override
  void initState() {
    // ignore: todo
    // TODO: implement initState
    super.initState();
    initConnectivity();
    Future.delayed(duration, () {
      initStore();
    });
  }

  Future<void> initConnectivity() async {
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      var connectionStatus = (await _connectivity.checkConnectivity());
      if (connectionStatus == ConnectivityResult.mobile) {
        Golbal.connectivityResult = 1;
      } else if (connectionStatus == ConnectivityResult.wifi) {
        Golbal.connectivityResult = 0;
      } else {
        Golbal.connectivityResult = -1;
        // showToastMessage(
        //     "Bạn đang không có kết nối internet!\n Vui lòng bật wifi hoặc 4G trên điện thoại của bạn");
      }
    } on PlatformException {
      Golbal.connectivityResult = -1;
    }
    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) {
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    Golbal.screenSize = MediaQuery.of(context).size;
    if (!kIsWeb &&
        Golbal.screenSize.shortestSide >= 600 &&
        defaultTargetPlatform != TargetPlatform.windows &&
        defaultTargetPlatform != TargetPlatform.macOS &&
        defaultTargetPlatform != TargetPlatform.linux) {
      Golbal.textScaleFactor = 1.5;
    }
    return MediaQuery(
        data: MediaQuery.of(context)
            .copyWith(textScaleFactor: Golbal.textScaleFactor),
        child: Scaffold(
          backgroundColor: Colors.white,
          body: Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("assets/bg.png"),
                    alignment: Alignment.bottomRight)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Image(
                    image: const AssetImage("assets/logoso.png"),
                    width: Golbal.screenSize.width,
                    height: 96,
                    fit: BoxFit.contain),
                Padding(
                  padding: const EdgeInsets.only(top: 20.0, bottom: 5.0),
                  child: AnimatedTextKit(
                    animatedTexts: [
                      ColorizeAnimatedText(
                        "Smart Office",
                        textStyle: const TextStyle(
                            fontSize: 32.0,
                            color: Colors.black87,
                            fontWeight: FontWeight.bold),
                        colors: [
                          Colors.black87,
                          Colors.blue,
                          Colors.yellow,
                          Colors.red,
                          Colors.indigo
                        ],
                        textAlign: TextAlign.start,
                      ),
                    ],
                    repeatForever: true,
                  ),
                ),
                // const Text("www.soe.vn",
                //     style: TextStyle(
                //         fontWeight: FontWeight.w300,
                //         color: Colors.black45,
                //         fontSize: 13.0))
              ],
            ),
          ),
        ));
  }
}
