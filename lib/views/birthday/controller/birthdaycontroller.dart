import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import '../../../utils/golbal/golbal.dart';

class BirthdayController extends GetxController {
  var birthtoday_datas = [].obs;
  var birthganday_datas = [].obs;
  var birthsaptoi_datas = [].obs;
  var birthtomonth_datas = [].obs;
  var birthtomonthorther_datas = [].obs;
  var birthtomonthorther_datascopy = [].obs;

  StreamController<int> monthStream = StreamController<int>();
  List<int> months = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12];
  int month = 1;

  final Colors = [
    "#F8E69A",
    "#AFDFCF",
    "#F4B2A3",
    "#9A97EC",
    "#CAE2B0",
    "#8BCFFB",
    "#CCADD7"
  ];

  static String getDayName(String ngaySN) {
    DateTime? sn;
    try {
      sn = DateTime.tryParse(ngaySN)!;
    } catch (e) {}
    if (sn == null) return "";
    DateTime date = DateTime(DateTime.now().year, sn.month, sn.day);
    var firstDayOfYear = date.weekday;
    if (firstDayOfYear == DateTime.monday) return "Thứ 2";
    if (firstDayOfYear == DateTime.tuesday) return "Thứ 3";
    if (firstDayOfYear == DateTime.wednesday) return "Thứ 4";
    if (firstDayOfYear == DateTime.thursday) return "Thứ 5";
    if (firstDayOfYear == DateTime.friday) return "Thứ 6";
    if (firstDayOfYear == DateTime.saturday) return "Thứ 7";
    return "Chủ nhật";
  }

  void goMonth(m) {
    month = m + 1;

    birthtomonthorther_datas.value = birthtomonthorther_datascopy.value
        .where((element) => element["miy"] == month)
        .toList();
  }

  @override
  void onInit() {
    super.onInit();
    if (birthtoday_datas.isEmpty) {
      getSinhNhatToDay();
    }
    if (birthganday_datas.isEmpty) {
      getSinhNhatGanDay();
    }
    if (birthsaptoi_datas.isEmpty) {
      getSinhNhatSapToi();
    }
    // if (birthtomonth_datas.isEmpty) {
    //   getSinhNhatToMonth();
    // }
    if (birthtomonthorther_datas.isEmpty) {
      getSinhNhatToMonthOther();
    }
  }

  void getSinhNhatToDay() async {
    try {
      var body = {"user_id": Golbal.store.user["user_id"]};
      Dio dio = Dio();
      dio.options.headers["Authorization"] = "Bearer ${Golbal.store.token}";
      dio.options.followRedirects = true;
      var response = await dio.post(
          "${Golbal.congty!.api}/api/Birthday/Get_SinhNhatToDay",
          data: body);
      var data = response.data;
      if (data != null) {
        var tbs = json.decode(data["data"]);
        if (tbs != null && tbs.length > 0) {
          for (var i = 0; i < tbs.length; i++) {
            tbs[i]["hasImage"] = false;
            if (tbs[i]["anhThumb"] != null && tbs[i]["anhThumb"] != "") {
              tbs[i]["hasImage"] = true;
              tbs[i]["anhThumb"] = Golbal.congty!.fileurl + tbs[i]["anhThumb"];
            }
            tbs[i]["subten"] = (tbs[i]["ten"] != null)
                ? tbs[i]["ten"].trim().substring(0, 1)
                : "";
            tbs[i]["bgColor"] = Colors[i % 7];
          }
          birthtoday_datas.value = tbs;
        } else {
          birthtoday_datas.value = [];
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  void getSinhNhatGanDay() async {
    try {
      var body = {"user_id": Golbal.store.user["user_id"]};
      Dio dio = Dio();
      dio.options.headers["Authorization"] = "Bearer ${Golbal.store.token}";
      dio.options.followRedirects = true;
      var response = await dio.post(
          "${Golbal.congty!.api}/api/Birthday/Get_SinhNhatGanDay",
          data: body);
      var data = response.data;
      if (data != null) {
        var tbs = json.decode(data["data"]);
        if (tbs != null && tbs.length > 0) {
          for (var i = 0; i < tbs.length; i++) {
            tbs[i]["hasImage"] = false;
            if (tbs[i]["anhThumb"] != null && tbs[i]["anhThumb"] != "") {
              tbs[i]["hasImage"] = true;
              tbs[i]["anhThumb"] = Golbal.congty!.fileurl + tbs[i]["anhThumb"];
            }
            tbs[i]["subten"] = (tbs[i]["ten"] != null)
                ? tbs[i]["ten"].trim().substring(0, 1)
                : "";
            tbs[i]["bgColor"] = Colors[i % 7];
          }
          birthganday_datas.value = tbs;
        } else {
          birthganday_datas.value = [];
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  void getSinhNhatSapToi() async {
    try {
      var body = {"user_id": Golbal.store.user["user_id"]};
      Dio dio = Dio();
      dio.options.headers["Authorization"] = "Bearer ${Golbal.store.token}";
      dio.options.followRedirects = true;
      var response = await dio.post(
          "${Golbal.congty!.api}/api/Birthday/Get_SinhNhatSapToi",
          data: body);
      var data = response.data;
      if (data != null) {
        var tbs = json.decode(data["data"]);
        if (tbs != null && tbs.length > 0) {
          for (var i = 0; i < tbs.length; i++) {
            tbs[i]["hasImage"] = false;
            if (tbs[i]["anhThumb"] != null && tbs[i]["anhThumb"] != "") {
              tbs[i]["hasImage"] = true;
              tbs[i]["anhThumb"] = Golbal.congty!.fileurl + tbs[i]["anhThumb"];
            }
            tbs[i]["subten"] = (tbs[i]["ten"] != null)
                ? tbs[i]["ten"].trim().substring(0, 1)
                : "";
            tbs[i]["bgColor"] = Colors[i % 7];
          }
          birthsaptoi_datas.value = tbs;
        } else {
          birthsaptoi_datas.value = [];
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  void getSinhNhatToMonth() async {
    try {
      var body = {"user_id": Golbal.store.user["user_id"]};
      Dio dio = Dio();
      dio.options.headers["Authorization"] = "Bearer ${Golbal.store.token}";
      dio.options.followRedirects = true;
      var response = await dio.post(
          "${Golbal.congty!.api}/api/Birthday/Get_SinhNhatToMonth",
          data: body);
      var data = response.data;
      if (data != null) {
        var tbs = json.decode(data["data"]);
        if (tbs != null && tbs.length > 0) {
          for (var i = 0; i < tbs.length; i++) {
            tbs[i]["hasImage"] = false;
            if (tbs[i]["anhThumb"] != null && tbs[i]["anhThumb"] != "") {
              tbs[i]["hasImage"] = true;
              tbs[i]["anhThumb"] = Golbal.congty!.fileurl + tbs[i]["anhThumb"];
            }
            tbs[i]["subten"] = (tbs[i]["ten"] != null)
                ? tbs[i]["ten"].trim().substring(0, 1)
                : "";
            tbs[i]["bgColor"] = Colors[i % 7];
          }
          birthtomonth_datas.value = tbs;
        } else {
          birthtomonth_datas.value = [];
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  void getSinhNhatToMonthOther() async {
    try {
      var body = {"user_id": Golbal.store.user["user_id"]};
      Dio dio = Dio();
      dio.options.headers["Authorization"] = "Bearer ${Golbal.store.token}";
      dio.options.followRedirects = true;
      var response = await dio.post(
          "${Golbal.congty!.api}/api/Birthday/Get_SinhNhatToMonthOther",
          data: body);
      var data = response.data;
      if (data != null) {
        var tbs = json.decode(data["data"]);
        if (tbs != null && tbs.length > 0) {
          for (var i = 0; i < tbs.length; i++) {
            tbs[i]["hasImage"] = false;
            if (tbs[i]["anhThumb"] != null && tbs[i]["anhThumb"] != "") {
              tbs[i]["hasImage"] = true;
              tbs[i]["anhThumb"] = Golbal.congty!.fileurl + tbs[i]["anhThumb"];
            }
            tbs[i]["subten"] = (tbs[i]["ten"] != null)
                ? tbs[i]["ten"].trim().substring(0, 1)
                : "";
            tbs[i]["bgColor"] = Colors[i % 7];
          }
          birthtomonthorther_datas.value = tbs;
          birthtomonthorther_datascopy.value = tbs;
        } else {
          birthtomonthorther_datas.value = [];
          birthtomonthorther_datascopy.value = [];
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }
}
