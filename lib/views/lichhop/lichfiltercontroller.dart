import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import '../../../../utils/golbal/golbal.dart';

class FilterLichController extends GetxController {
  var phonghops = [].obs;
  var congtys = [].obs;
  var lanhdaos = [].obs;
  var model = {}.obs;
  var trangthais = [
    {"value": -1, "text": "Tất cả"},
    {"value": 1, "text": "Cá nhân"},
    {"value": 2, "text": "Chờ duyệt"},
    {"value": 3, "text": "Đã duyệt"},
    {"value": 4, "text": "Đã tạo"},
    {"value": 5, "text": "Đã huỷ"},
  ].obs;
  initTudien() async {
    try {
      var body = {
        "user_id": Golbal.store.user["user_id"],
        "year": DateTime.now().year
      };
      Dio dio = Dio();
      dio.options.headers["Authorization"] = "Bearer ${Golbal.store.token}";
      dio.options.followRedirects = true;
      var response = await dio.post(
          "${Golbal.congty!.api}/api/Calendar/Get_Dictionary",
          data: body);
      var data = response.data;
      if (data != null) {
        var tbs = List.castFrom(json.decode(data["data"]));
        if (tbs.isNotEmpty) {
          if (model["filter_congty_id"] != null) {
            var cty = List.castFrom(tbs[3]).firstWhereOrNull(
                (element) => element["Congty_ID"] == model["filter_congty_id"]);
            if (cty != null) {
              cty["chon"] = true;
            }
          }
          if (model["s"] != null) {
            var cty = List.castFrom(tbs[2]).firstWhereOrNull(
                (element) => element["Diadiem_Ten"] == model["s"]);
            if (cty != null) {
              cty["chon"] = true;
            }
          }
          if (model["user_id"] != null) {
            var cty = List.castFrom(tbs[4]).firstWhereOrNull(
                (element) => element["NhanSu_ID"] == model["user_id"]);
            if (cty != null) {
              cty["chon"] = true;
            }
          }
          if (model["is_type"] != null) {
            var cty = trangthais.firstWhereOrNull(
                (element) => element["value"] == model["is_type"]);
            if (cty != null) {
              cty["chon"] = true;
            }
          }
          phonghops.value = tbs[2];
          congtys.value = tbs[3];
          lanhdaos.value = tbs[4];
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  void setCongty(item) {
    var chons = congtys
        .where((element) =>
            element["chon"] == true &&
            element["Congty_ID"] != item["Congty_ID"])
        .toList();
    for (var e in chons) {
      e["chon"] = false;
    }
    int idx = congtys
        .indexWhere((element) => element["Congty_ID"] == item["Congty_ID"]);
    if (idx != -1) {
      if (congtys[idx]["chon"] != true) {
        congtys[idx]["chon"] = true;
        model["is_type"] = 6;
      } else {
        congtys[idx]["chon"] = false;
        model["is_type"] = Get.arguments["is_type"];
      }
      model["filter_congty_id"] = item["Congty_ID"];
      congtys.refresh();
    }
  }

  void setPhonghop(item) {
    var chons = phonghops
        .where((element) =>
            element["chon"] == true &&
            element["Diadiem_ID"] != item["Diadiem_ID"])
        .toList();
    for (var e in chons) {
      e["chon"] = false;
    }
    int idx = phonghops
        .indexWhere((element) => element["Diadiem_ID"] == item["Diadiem_ID"]);
    if (idx != -1) {
      if (phonghops[idx]["chon"] != true) {
        phonghops[idx]["chon"] = true;
        model["s"] = item["Diadiem_Ten"];
      } else {
        phonghops[idx]["chon"] = false;
        model["s"] = "";
      }
      model["is_type"] = -1;
      phonghops.refresh();
    }
  }

  void setLanhdao(item) {
    var chons = lanhdaos
        .where((element) =>
            element["chon"] == true &&
            element["NhanSu_ID"] != item["NhanSu_ID"])
        .toList();
    for (var e in chons) {
      e["chon"] = false;
    }
    int idx = lanhdaos
        .indexWhere((element) => element["NhanSu_ID"] == item["NhanSu_ID"]);
    if (idx != -1) {
      if (lanhdaos[idx]["chon"] != true) {
        lanhdaos[idx]["chon"] = true;
        model["user_id"] = item["NhanSu_ID"];
        model["is_type"] = 1;
      } else {
        lanhdaos[idx]["chon"] = false;
        model["user_id"] = null;
        model["is_type"] = -1;
      }

      lanhdaos.refresh();
    }
  }

  void setTrangthai(item) {
    var chons = trangthais.where((element) => element["chon"] == true).toList();
    for (var e in chons) {
      e["chon"] = false;
    }
    int idx =
        trangthais.indexWhere((element) => element["value"] == item["value"]);
    if (idx != -1) {
      if (trangthais[idx]["chon"] != true) {
        trangthais[idx]["chon"] = true;
        model["is_type"] = item["value"];
      } else {
        trangthais[idx]["chon"] = false;
        model["is_type"] = 1;
      }
      trangthais.refresh();
    }
  }

  void clearAdv() {
    Get.back(result: {});
  }

  void apDung() {
    Get.back(result: model);
  }

  @override
  void onInit() {
    super.onInit();
    model.value = Get.arguments;
    initTudien();
  }
}
