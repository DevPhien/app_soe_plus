import 'dart:convert';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../utils/golbal/golbal.dart';

class PhieuluongController extends GetxController {
  RxBool isLoadding = true.obs;
  var datas = [].obs;
  var tongluong = "100.000.000".obs;
  int cmonth = DateTime.now().month;
  var months = [].obs;
  var years = [];
  int cyear = DateTime.now().year;
  var year = DateTime.now().year.obs;
  var days = [].obs;
  initData() async {
    try {
      isLoadding.value = true;
      tongluong.value = "";
      var body = {
        "user_id": Golbal.store.user["user_id"],
        "year": year.value,
      };
      String url = "Hrm/GetPaycheck";
      Dio dio = Dio();
      dio.options.headers["Authorization"] = "Bearer ${Golbal.store.token}";
      dio.options.followRedirects = true;
      var response =
          await dio.post("${Golbal.congty!.api}/api/$url", data: body);
      var data = response.data;
      if (data != null) {
        var tbs = List.castFrom(json.decode(data["data"]));
        if (tbs.isNotEmpty) {
          initMonths(tbs);
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

  void setYear(int y) {
    year.value = y;
    initData();
  }

  void randomluong() {
    var rng = Random();
    var tbs = [[], []];
    int k = 0;
    int tong = 0;
    for (int i = 1; i <= 12; i++) {
      int luong = 10000000 + (rng.nextInt(100) * 200000);
      if (year.value == cyear && cmonth < i) {
      } else {
        tbs[0].add({"thang": i, "Thucnhan": luong});
        k += 1;
        tong += luong;
      }
    }
    tbs[1].add({"totalThucnhan": tong});
    initMonths(tbs);
  }

  void initMonths(List tbs) {
    var ms = [];
    int tong =
        double.parse((tbs[1][0]["totalThucnhan"] ?? 0).toString()).ceil();
    int t = 0;
    for (int i = 1; i <= 12; i++) {
      var oluong = List.castFrom(tbs[0])
          .firstWhereOrNull((element) => element["thang"] == i);
      var obj = {
        "month": i,
        "luong": oluong != null
            ? double.parse((oluong["Thucnhan"] ?? 0).toString()).ceil()
            : null,
        "luonghienthi": "Chưa tính"
      };
      if (obj["luong"] != null) {
        obj["luonghienthi"] = NumberFormat.decimalPattern('vi')
            .format(int.parse(obj["luong"].toString()));
        t++;
      }
      ms.add(obj);
    }
    var tb = tong / t;
    for (var m in ms) {
      if (m["luong"] != null) {
        m["color"] = m["luong"] >= tb
            ? "#5CB85C"
            : m["luong"] == tb
                ? "#086FE8"
                : "#FF8126";
      }
    }
    tongluong.value = NumberFormat.decimalPattern('vi').format(tong);
    months.value = ms;
  }

  @override
  void onInit() {
    super.onInit();
    for (int i = year.value; i >= year.value - 20; i--) {
      years.add(i);
    }
    initData();
  }
}
