import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'meetdesktopcontroller.dart';

class MeetDesktopPage extends StatelessWidget {
  MeetDesktopPage({Key? key}) : super(key: key);
  final MeetDesktopController meetctr = Get.put(MeetDesktopController());

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          meetctr.back();
          return true;
        },
        child: Scaffold(
          appBar: AppBar(
            iconTheme: const IconThemeData(color: Colors.black87),
            elevation: 0,
            backgroundColor: Colors.white,
            title: Text(meetctr.model["Noidung"] ?? "Meeting",
                style: const TextStyle(
                    color: Color(0xFF0186f8),
                    fontWeight: FontWeight.bold,
                    fontSize: 24.0)),
          ),
          backgroundColor: const Color(0xffeeeeee),
          body: Obx(() => meetctr.isLoad.value
              ? Container(
                  margin: const EdgeInsets.fromLTRB(10.0, 0, 0, 10.0),
                  height: double.infinity,
                  color: Colors.white,
                  child: const Center(child: CircularProgressIndicator()),
                )
              : Container()),
        ));
  }
}
