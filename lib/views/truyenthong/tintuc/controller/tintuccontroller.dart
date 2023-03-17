import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import '../../../../utils/golbal/golbal.dart';

class TintucController extends GetxController {
  var loaddingmore = false.obs;
  RxBool isLoadding = true.obs;
  var nhom = {}.obs;
  var datas = [].obs;
  var datanhoms = [].obs;
  Map<String, dynamic> options = {
    "p": 1,
    "pz": 20,
    "s": null,
    "filter_congty_id": Golbal.store.user["organization_id"]
  };
  void goNhom({typenhom}) {
    nhom.value = typenhom;
  }

  void goTintuc(tb) {
    Get.toNamed("/detailtintuc", arguments: tb);
  }

  void search(String? s) {
    options["s"] = s;
    options["p"] = 1;
    datas.clear();
    initData();
  }

  initCounts() async {
    try {
      var body = {
        "user_id": Golbal.store.user["user_id"],
      };
      Dio dio = Dio();
      dio.options.headers["Authorization"] = "Bearer ${Golbal.store.token}";
      dio.options.followRedirects = true;
      var response = await dio
          .post("${Golbal.congty!.api}/api/New/Get_Dictionary", data: body);
      var data = response.data;
      if (data != null) {
        var tbs = List.castFrom(json.decode(data["data"]));
        if (tbs.isNotEmpty) {
          datanhoms.value = tbs[0];
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  initData() async {
    isLoadding.value = true;
    try {
      var body = {
        "user_id": Golbal.store.user["user_id"],
        "is_type": "2",
        "LoaiTT_ID": options["LoaiTT_ID"],
        "s": options["s"],
      };
      Dio dio = Dio();
      dio.options.headers["Authorization"] = "Bearer ${Golbal.store.token}";
      dio.options.followRedirects = true;
      var response = await dio
          .post("${Golbal.congty!.api}/api/New/Get_NewFilter", data: body);
      var data = response.data;
      if (data != null) {
        var tbs = List.castFrom(json.decode(data["data"]));
        if (tbs.isNotEmpty) {
          datas.value = tbs;
        }
      }
      isLoadding.value = false;
    } catch (e) {
      isLoadding.value = false;
      //print(e);
      if (kDebugMode) {
        print(e);
      }
    }
  }

  @override
  void onInit() {
    super.onInit();
    initCounts();
    initData();
  }

  @override
  void onClose() {
    super.onClose();
  }
}
