import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:dio/dio.dart' as dioform;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../utils/golbal/golbal.dart';

class TruyenthongController extends GetxController {
  ScrollController? tuancontroller;
  RxInt pageIndex = 1.obs;
  RxBool isLoadding = true.obs;
  RxBool isActive = false.obs;
  var datas = [];
  void onPageChanged(int p) {
    datas.clear();
    if (p == 0) {
      Get.back();
      return;
    }
    pageIndex.value = p;
    loadData(false);
  }

  void loadData(f) {
    switch (pageIndex.value) {
      case 1:
        break;
      case 2:
        break;
      case 3:
        break;
    }
  }

  void initdata() async {
    isLoadding.value = true;
    try {
      var par = {
        "organization_id": Golbal.store.user["organization_id"],
      };
      var strpar = json.encode(par);
      dioform.FormData formData = dioform.FormData.fromMap(
          {"proc": "App_ActiveTruyenthong", "pas": strpar});
      Dio dio = Dio();
      dio.options.headers["Authorization"] = "Bearer ${Golbal.store.token}";
      dio.options.followRedirects = true;
      var response = await dio
          .post("${Golbal.congty!.api}/api/HomeApi/callProc", data: formData);
      isLoadding.value = false;
      var data = response.data;
      if (data["err"] == "1") {
        return;
      }
      if (data != null) {
        var tbs = json.decode(data["data"])[0];
        if (tbs[0] != null && tbs[0].length > 0) {
          isActive.value = tbs[0]["isActive"];
          pageIndex.value = 1;
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  @override
  void onInit() {
    super.onInit();
    initdata();
  }

  @override
  void onClose() {
    super.onClose();
  }
}
