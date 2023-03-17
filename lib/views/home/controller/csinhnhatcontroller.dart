import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:soe/utils/golbal/golbal.dart';

class HomeSinhNhatController extends GetxController {
  var datas = [].obs;
  RxInt pageIndex = 0.obs;
  @override
  void onInit() {
    super.onInit();
    initData();
  }

  initData() async {
    datas.value = [];
    try {
      var body = {"user_id": Golbal.store.user["user_id"], "top": 5};
      Dio dio = Dio();
      dio.options.headers["Authorization"] = "Bearer ${Golbal.store.token}";
      dio.options.followRedirects = true;
      var response = await dio.post(
          "${Golbal.congty!.api}/api/HomeApp/GetTopUpcomingBirthday",
          data: body);
      var data = response.data;
      if (data != null) {
        var tbs = List.castFrom(json.decode(data["data"]));
        if (tbs.isNotEmpty) {
          for (var element in tbs) {
            if (element["anhThumb"] != null &&
                element["anhThumb"].trim() != "") {
              element["anhThumb"] =
                  Golbal.congty!.fileurl + element["anhThumb"];
            }
          }
          datas.value = tbs;
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }
}
