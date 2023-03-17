import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

import '../../../utils/golbal/golbal.dart';

class XeController extends GetxController {
  RxBool isLoadding = true.obs;
  RxBool isloaddingmore = false.obs;
  RxBool loaddingmore = false.obs;
  var cars = [].obs;
  var hystorycars = [].obs;
  var car = {}.obs;
  Map<String, dynamic> options = {"p": 1, "pz": 20, "s": "", "total": 0};

  void onLoadmore() {
    options["p"] = options["p"] + 1;
    loaddingmore.value = true;
    historyCar();
  }

  initData() async {
    try {
      var body = {"user_id": Golbal.store.user["user_id"], "s": null};
      Dio dio = Dio();
      dio.options.headers["Authorization"] = "Bearer ${Golbal.store.token}";
      dio.options.followRedirects = true;
      var response = await dio
          .post("${Golbal.congty!.api}/api/Car/Get_ListOtoHome", data: body);
      var data = response.data;
      if (data != null) {
        var tbs = List.castFrom(json.decode(data["data"]));
        if (tbs.isNotEmpty) {
          cars.value = tbs[0];
          isLoadding.value = false;
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  infoCar() async {
    try {
      var body = {
        "user_id": Golbal.store.user["user_id"],
        "oto_id": car["XeOto_ID"]
      };
      Dio dio = Dio();
      dio.options.headers["Authorization"] = "Bearer ${Golbal.store.token}";
      dio.options.followRedirects = true;
      var response = await dio.post("${Golbal.congty!.api}/api/Car/Get_InfoOto",
          data: body);
      var data = response.data;
      if (data != null) {
        var tbs = List.castFrom(json.decode(data["data"]));
        if (tbs.isNotEmpty) {
          if (tbs[0][0]["khauhao"] == null) {
            tbs[0][0]["khauhao"] =
                (tbs[0][0]["totalKm"] / 300000).toStringAsFixed(1);
          }
          car.value = tbs[0][0];
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  void search(String txt) {
    options["s"] = txt;
    options["p"] = 1;
    historyCar();
  }

  Future<void> openDate() async {
    final DateTime? picked = await showDatePicker(
      context: Get.context!,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2025),
    );
    if (picked != null) {
      options["fromdate"] = picked.toIso8601String();
    } else {
      options["fromdate"] = null;
    }
    options["p"] = 1;
    historyCar();
  }

  historyCar() async {
    if (options["p"] == 1) {
      hystorycars.clear();
      isloaddingmore.value = false;
      loaddingmore.value = false;
      isLoadding.value = true;
    }
    try {
      var body = {
        "user_id": Golbal.store.user["user_id"],
        "oto_id": car["XeOto_ID"],
        "p": options["p"].toString(),
        "pz": options["pz"].toString(),
        "search": options["s"],
        "fromdate": options["fromdate"]
      };
      Dio dio = Dio();
      dio.options.headers["Authorization"] = "Bearer ${Golbal.store.token}";
      dio.options.followRedirects = true;
      var response = await dio
          .post("${Golbal.congty!.api}/api/Car/Get_HistoryOto_1", data: body);
      var data = response.data;
      if (data != null) {
        var tbs = List.castFrom(json.decode(data["data"]));
        hystorycars.addAll(tbs[0]);
        options["total"] = tbs[1][0]["total"];
        loaddingmore.value = false;
        isloaddingmore.value = hystorycars.length < options["total"];
      }
      if (isLoadding.value = true) {
        isLoadding.value = false;
      }
      if (options["p"] > 1) {
        EasyLoading.showSuccess("Đã tải trang ${options["p"]}",
            duration: const Duration(milliseconds: 500));
      }
    } catch (e) {
      if (isLoadding.value = true) {
        isLoadding.value = false;
      }
      if (kDebugMode) {
        print(e);
      }
    }
  }

  void goCar(item) {
    car.value = item;
    infoCar();
    Get.toNamed("/thongtinxe", arguments: item);
  }

  void goinfoCar(item) {
    Get.toNamed("/chitietxe", arguments: item);
  }

  void gohistoryCar(item) {
    options["p"] = 1;
    options["fromdate"] = null;
    options["total"] = 0;
    options["s"] = "";
    isloaddingmore.value = false;
    loaddingmore.value = false;
    historyCar();
    Get.toNamed("/lichsuxe", arguments: item);
  }

  @override
  void onInit() {
    super.onInit();
    initData();
  }
}
