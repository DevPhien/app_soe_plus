import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import '../../../utils/golbal/golbal.dart';

class MyprofileController extends GetxController {
  RxBool isLoadding = true.obs;
  var data = {}.obs;

  initData() async {
    try {
      isLoadding.value = true;
      var body = {
        "user_id": Golbal.store.user["user_id"],
      };
      String url = "Hrm/GetProfile";
      Dio dio = Dio();
      dio.options.headers["Authorization"] = "Bearer ${Golbal.store.token}";
      dio.options.followRedirects = true;
      var response =
          await dio.post("${Golbal.congty!.api}/api/$url", data: body);
      var dt = response.data;
      if (dt != null) {
        var tbs = List.castFrom(json.decode(dt["data"]));
        if (tbs.isNotEmpty) {
          data.value = tbs[0];
        }
      }
      if (isLoadding.value) {
        isLoadding.value = false;
      }
    } catch (e) {
      if (isLoadding.value) {
        isLoadding.value = false;
      }
      if (kDebugMode) {
        print(e);
      }
    }
  }

  @override
  void onInit() {
    super.onInit();
    initData();
  }
}
