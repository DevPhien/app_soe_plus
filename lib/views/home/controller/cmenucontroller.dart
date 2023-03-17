import 'dart:convert';

import 'package:art_sweetalert/art_sweetalert.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:soe/utils/golbal/golbal.dart';

class HomeMenuController extends GetxController {
  var datas = [].obs;
  var countdata = {}.obs;
  RxInt pageIndex = 0.obs;
  @override
  void onInit() {
    super.onInit();
    initData();
  }

  void goMenu(mn) {
    //print(mn);
    switch (mn["ModuleName"]) {
      case "S.Doc":
        Get.toNamed("doc");
        break;
      case "S.Calendar":
        Get.toNamed("calendar");
        break;
      case "S.News":
        Get.toNamed("truyenthong");
        break;
      case "S.Chat":
        Get.toNamed("chat");
        break;
      case "S.Task":
        Get.toNamed("task");
        break;
      case "S.Request":
        Get.toNamed("request");
        break;
      case "S.Car":
        Get.toNamed("car");
        break;
      default:
        ArtSweetAlert.show(
            context: Get.context!,
            artDialogArgs: ArtDialogArgs(
                dialogAlignment: Alignment.centerLeft,
                title: "Smart Office",
                text: "Tính năng này sẽ có trong phiên bản sắp tới!"));
        break;
    }
  }

  initData() async {
    try {
      var body = {"user_id": Golbal.store.user["user_id"]};
      Dio dio = Dio();
      dio.options.headers["Authorization"] = "Bearer ${Golbal.store.token}";
      dio.options.followRedirects = true;
      var response = await dio
          .post("${Golbal.congty!.api}/api/HomeApp/GetListModule", data: body);
      var data = response.data;
      if (data != null) {
        var tbs = json.decode(data["data"]);
        if (tbs.length > 0) {
          for (var m in tbs) {
            m["Image"] = Golbal.congty!.fileurl + m["Image"];
          }
          datas.value = tbs;
          initCounts();
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  initCounts() async {
    try {
      var body = {"user_id": Golbal.store.user["user_id"]};
      Dio dio = Dio();
      dio.options.headers["Authorization"] = "Bearer ${Golbal.store.token}";
      dio.options.followRedirects = true;
      var response = await dio
          .post("${Golbal.congty!.api}/api/HomeApp/GetCountModule", data: body);
      var data = response.data;
      if (data != null) {
        var tbs = List.castFrom(json.decode(data["data"]));
        if (tbs.isNotEmpty) {
          var objc = {};
          for (var md in datas) {
            objc[md["Module_ID"]] = tbs.firstWhereOrNull(
                (element) => element["Module_ID"] == md["Module_ID"])?["c"];
          }
          countdata.value = objc;
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }
}
