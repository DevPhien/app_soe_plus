import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jitsi_meet/jitsi_meet.dart';

import 'meetcontroller.dart';

class MeetPage extends StatelessWidget {
  MeetPage({Key? key}) : super(key: key);
  final MeetController meetctr = Get.put(MeetController());

  Widget widgetBodyWidget(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return SizedBox(
      width: screenSize.width,
      height: screenSize.height,
      child: JitsiMeetConferencing(
        extraJS: const [
          // extraJs setup example
          '<script src="https://code.jquery.com/jquery-3.5.1.slim.js" integrity="sha256-DrT5NfxfbHvMHux31Lkhxg42LY6of8TaYyK50jnxRnM=" crossorigin="anonymous"></script>'
        ],
      ),
    );
  }

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
          body: Obx(() => meetctr.isLoad.value
              ? Container(
                  margin: const EdgeInsets.fromLTRB(10.0, 0, 0, 10.0),
                  height: double.infinity,
                  color: Colors.white,
                  child: const Center(child: CircularProgressIndicator()),
                )
              : widgetBodyWidget(context)),
          backgroundColor: const Color(0xffeeeeee),
        ));
  }
}
