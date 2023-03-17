import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:soe/utils/golbal/golbal.dart';

class ActivityTaskController extends GetxController {
  ScrollController scrollController = ScrollController();
  //Declare
  var loading = true.obs;
  var loaddingmore = false;
  var lastdata = false.obs;
  var showFab = false.obs;
  var task = {}.obs;
  var datas = [].obs;
  var countdata = 0.obs;

  Map<String, dynamic> options = {
    "p": 1,
    "pz": 20,
    "IsType": null,
  };

  //Function
  Future<void> onLoadmore() {
    if (loaddingmore || lastdata.value == true) return Future.value(null);
    loaddingmore = true;
    options["p"] = int.parse(options["p"].toString()) + 1;
    EasyLoading.show(
      status: "Đang tải trang ${options["p"]}",
    );
    initData(false);
    return Future.value(null);
  }

  //Init
  @override
  void onInit() {
    super.onInit();
    task.value = Get.arguments;
    initData(true);
  }

  void initData(f) async {
    try {
      loading.value = true;
      EasyLoading.show(status: "loading...");
      Dio dio = Dio();
      dio.options.headers["Authorization"] = "Bearer ${Golbal.store.token}";
      dio.options.followRedirects = true;
      var response = await dio.post(
        "${Golbal.congty!.api}/api/Task/Get_Log",
        data: {
          "user_id": Golbal.store.user["user_id"],
          "DuanID": task["DuanID"],
          "CongviecID": task["CongviecID"],
          "p": options["p"],
          "pz": options["pz"],
          "IsType": options["IsType"],
        },
      );
      var data = response.data;
      loading.value = false;
      if (data["err"] == 1) {
        EasyLoading.showError("Có lỗi xảy ra, vui lòng thử lại");
      }
      if (data != null) {
        var tbs = List.castFrom(json.decode(data["data"]));
        if (tbs[0].isNotEmpty) {
          if (f) {
            datas.value = tbs[0];
          } else {
            datas.addAll(tbs[0]);
          }
        } else {
          if (loaddingmore) {
            lastdata.value = true;
            EasyLoading.showToast("Bạn đã xem hết lịch sử rồi!");
          } else {
            datas.value = [];
          }
        }
        if (tbs[1].isNotEmpty) {
          countdata.value = tbs[1][0]["c"];
        }
        if (loaddingmore) {
          loaddingmore = false;
        }
      }
      EasyLoading.dismiss();
    } catch (e) {
      loading.value = false;
      EasyLoading.dismiss();
      if (kDebugMode) {
        print(e);
      }
    }
  }
}
