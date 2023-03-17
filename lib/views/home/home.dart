import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:page_transition/page_transition.dart';
import 'package:socket_io_client/socket_io_client.dart';

import '../../utils/golbal/golbal.dart';
// import '../chat/comp/messenger/chathome.dart';
// import '../chat/comp/phonebook/phonebookhome.dart';
import '../login/login.dart';
import '../notify/notify.dart';
import '../user/user.dart';
import 'comp/appbarhome.dart';
import 'comp/comhome.dart';
import 'controller/homeappcontroller.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  HomeState createState() => HomeState();
}

// Custom config
class HomeState extends State<Home> with WidgetsBindingObserver {
  final HomeAppController homecontroller = Get.put(HomeAppController());

  int _page = 0;
  final PageController _pageController = PageController();

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _pageController.dispose();
    Golbal.socket.disconnect();
    Golbal.socket.clearListeners();
    Golbal.socket.close();
    Golbal.socket.dispose();
    super.dispose();
  }

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
    initFB();
    initSocket();
  }

  void initSocket() {
    if (kIsWeb) {
      Golbal.socket = io(
          Golbal.congty!.socket, OptionBuilder().disableAutoConnect().build());
    } else {
      Golbal.socket = io(
          Golbal.congty!.socket,
          OptionBuilder()
              .setTransports(['websocket']) // for Flutter or Dart VM
              .disableAutoConnect()
              .build());
    }
    Golbal.socket.connect();
    Golbal.socket.onConnect((_) {
      var u = {
        "user_id": Golbal.store.user["user_id"],
        "FullName": Golbal.store.user["FullName"],
        "fname": Golbal.store.user["fname"],
        "Devicde": Golbal.store.device["deviceName"],
        "Avartar": Golbal.store.user["Avartar"],
        "socketid": Golbal.socket.id,
      };
      Golbal.socket.emit('connectsocket', u);
      Golbal.socket
          .on('getData', (data) => homecontroller.initSocketData(data));
    });
    //Golbal.socket.on("connect_error", (err) => {print(err)});
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        break;
      case AppLifecycleState.inactive:
        break;
      case AppLifecycleState.paused:
        homecontroller.updateBadge();
        break;
      case AppLifecycleState.detached:
        break;
    }
  }

  void initFB() {
    FirebaseMessaging.instance.requestPermission();
    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage? message) {
      if (message != null) {
        try {
          var obj = json.decode(message.data["hub"]);
          homecontroller.goNotification(obj["Data"]);
        } catch (e) {}
      }
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null && !kIsWeb) {}
      print("onMessage");
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      if (kDebugMode) {
        print('A new onMessageOpenedApp event was published!$message');
      }
      try {
        var obj = json.decode(message.data["hub"]);
        homecontroller.goNotification(obj["Data"]);
      } catch (e) {}
    });
  }

  //Function
  void onPageChanged(int page) {
    if (page == 1) {
      Get.toNamed("chat");
    } else if (page == 2) {
      Get.toNamed("chat", parameters: {"pageIndex": "3"});
    } else {
      setState(() {
        _page = page;
      });
      _pageController.jumpToPage(page);
    }
  }

  void goInfoUser() {
    Get.toNamed("user");
  }

  void logout() {
    Golbal.clearStore();
    Navigator.of(context).pushAndRemoveUntil(
        PageTransition(type: PageTransitionType.fade, child: const LoginPage()),
        (Route<dynamic> r) => false);
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context)
          .copyWith(textScaleFactor: Golbal.textScaleFactor),
      child: Scaffold(
        backgroundColor: const Color(0xffffffff),
        appBar: _page == 3 ? null : const AppBarHome(title: "Smart Office"),
        body: PageView(
          controller: _pageController,
          onPageChanged: onPageChanged,
          physics: const NeverScrollableScrollPhysics(),
          children: <Widget>[
            CompHome(),
            const SizedBox.shrink(),
            const SizedBox.shrink(),
            // _page == 1 ? ChatHome(isscrool: true) : const SizedBox.shrink(),
            // _page == 2
            //     ? PhoneBookHome(isscrool: true)
            //     : const SizedBox.shrink(),
            _page == 3 ? Noty() : const SizedBox.shrink(),
            _page == 4 ? User() : const SizedBox.shrink(),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.white,
          items: [
            const BottomNavigationBarItem(
                backgroundColor: Colors.white,
                icon: Icon(AntDesign.home),
                label: "Home"),
            BottomNavigationBarItem(
                backgroundColor: Colors.white,
                icon: Stack(
                  children: <Widget>[
                    const SizedBox(
                      width: 40.0,
                      child: Icon(AntDesign.message1),
                    ),
                    Obx(() => homecontroller.counthome["CountTinnhan"] !=
                                null &&
                            homecontroller.counthome["CountTinnhan"] > 0
                        ? Positioned(
                            right: 0,
                            child: CircleAvatar(
                              radius: 10,
                              backgroundColor: Colors.red,
                              child: Text(
                                homecontroller.counthome["CountTinnhan"] < 10
                                    ? homecontroller.counthome["CountTinnhan"]
                                        .toString()
                                    : "+9",
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 10),
                              ),
                            ))
                        : const SizedBox.shrink())
                  ],
                ),
                label: "Tin nhắn"),
            const BottomNavigationBarItem(
                backgroundColor: Colors.white,
                icon: Icon(AntDesign.contacts),
                label: "Danh bạ"),
            BottomNavigationBarItem(
                backgroundColor: Colors.white,
                icon: Stack(
                  children: <Widget>[
                    const SizedBox(
                      width: 40.0,
                      child: Icon(AntDesign.bells),
                    ),
                    Obx(() => homecontroller.counthome["CountThongbao"] !=
                                null &&
                            homecontroller.counthome["CountThongbao"] > 0
                        ? Positioned(
                            right: 0,
                            child: CircleAvatar(
                              radius: 10,
                              backgroundColor: Colors.red,
                              child: Text(
                                homecontroller.counthome["CountThongbao"] < 10
                                    ? homecontroller.counthome["CountThongbao"]
                                        .toString()
                                    : "+9",
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 10),
                              ),
                            ))
                        : const SizedBox.shrink())
                  ],
                ),
                label: "Thông báo"),
            const BottomNavigationBarItem(
                backgroundColor: Colors.white,
                icon: Icon(AntDesign.setting),
                label: "Thiết lập")
          ],
          currentIndex: _page,
          onTap: onPageChanged,
          type: BottomNavigationBarType.fixed,
          fixedColor: const Color(0xFF0b72ff),
        ),
      ),
    );
  }
}
