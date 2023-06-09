import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'chamcongcontroller.dart';
import 'qrcode.dart';

class CheckinController extends GetxController {
  final ChamCongQRController controller = Get.put(ChamCongQRController());
  //Declare
  var loading = true.obs;
  var checkin = {}.obs;
  double? lat;
  double? lon;

  goQRView() async {
    if (checkin["IsCheckin"] == true && checkin["IsTimein"] == true) {
      // await Navigator.push(
      //     Get.context!,
      //     MaterialPageRoute(
      //       builder: (context) => QRCode(
      //         checkin: checkin,
      //         isInout: false,
      //       ),
      //     ));
      // Get.toNamed("qrcode",
      //     arguments: {"checkin": checkin, "isInout": false});
      var rs = await Get.toNamed("qrcode", arguments: {
        "checkin": checkin,
        "isInout": false,
      });
      if (rs == true) {
        controller.listTBS();
      }
      Get.back();
    }
  }

  //Init
  @override
  void onInit() {
    super.onInit();
    initState();
  }

  void initState() {
    checkin.value = Get.arguments;
    List<String>? lls;
    if (checkin["CheckinLatLong"] == null) {
      lls = null;
    } else {
      lls = checkin["CheckinLatLong"].toString().split(",");
    }
    if (lls != null && lls.isNotEmpty) {
      lat = double.parse(lls[0]);
      lon = double.parse(lls[1]);
    }
  }
}
