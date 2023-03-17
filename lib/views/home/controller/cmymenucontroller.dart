import 'dart:convert';

import 'package:art_sweetalert/art_sweetalert.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:soe/utils/golbal/golbal.dart';

class HomeMyMenuController extends GetxController {
  var datas = [].obs;
  RxInt pageIndex = 0.obs;
  @override
  void onInit() {
    super.onInit();
    initData();
  }

  void goMenu(m) {
    if (m["IsLink"] != null) {
      Get.toNamed(m["IsLink"].toString().trim());
    } else {
      ArtSweetAlert.show(
          context: Get.context!,
          artDialogArgs: ArtDialogArgs(
              dialogAlignment: Alignment.centerLeft,
              title: "Smart Office",
              text: "Tính năng này sẽ có trong phiên bản sắp tới!"));
    }
  }

  initData() async {
    try {
      var body = {"user_id": Golbal.store.user["user_id"]};
      Dio dio = Dio();
      dio.options.headers["Authorization"] = "Bearer ${Golbal.store.token}";
      dio.options.followRedirects = true;
      var response = await dio
          .post("${Golbal.congty!.api}/api/HomeApp/GetListMenu", data: body);
      if (response.statusCode == 401) {
        return;
      }
      var data = response.data;
      if (data != null) {
        var tbs = json.decode(data["data"]);
        if (tbs.length > 0) {
          for (var m in tbs) {
            if (m["Icon"] != null) {
              m["Icon"] = Golbal.congty!.fileurl + m["Icon"];
            }
          }
          datas.value = tbs;
        }
      }
    } catch (e) {}
  }
}
