import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

import '../../../utils/golbal/golbal.dart';

class ChamcongController extends GetxController {
  RxBool isLoadding = true.obs;
  ScrollController? thangcontroller;
  double initialScrollOffset = 0.0;
  var datas = [].obs;
  var songaycong = "0".obs;
  var songaycongthang = "0".obs;
  int cmonth = DateTime.now().month;
  var month = DateTime.now().month.obs;
  var months = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12];
  var years = [];
  var thus = ["T2", "T3", "T4", "T5", "T6", "T7", "CN"];
  int cyear = DateTime.now().year;
  var year = DateTime.now().year.obs;
  var days = [].obs;
  initData() async {
    initDataDay();
    try {
      isLoadding.value = true;
      songaycong.value = "";
      songaycongthang.value = "";
      var body = {
        "user_id": Golbal.store.user["user_id"],
        "month": month.value,
        "year": year.value,
      };
      String url = "Hrm/GetCountWorkdays";
      Dio dio = Dio();
      dio.options.headers["Authorization"] = "Bearer ${Golbal.store.token}";
      dio.options.followRedirects = true;
      var response =
          await dio.post("${Golbal.congty!.api}/api/$url", data: body);
      var data = response.data;
      if (data != null) {
        var tbs = List.castFrom(json.decode(data["data"]));
        if (tbs.isNotEmpty) {
          songaycong.value = tbs[0][0]["totalUserWorkdays"] != null
              ? tbs[0][0]["totalUserWorkdays"].toString().replaceAll(".0", "")
              : "";
          songaycongthang.value = tbs[1][0]["totalWorkdays"] != null
              ? tbs[1][0]["totalWorkdays"].toString().replaceAll(".0", "")
              : "";
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

  initDataDay() async {
    try {
      isLoadding.value = true;
      var body = {
        "user_id": Golbal.store.user["user_id"],
        "month": month.value,
        "year": year.value,
      };
      String url = "Hrm/GetListWorkdays";
      Dio dio = Dio();
      dio.options.headers["Authorization"] = "Bearer ${Golbal.store.token}";
      dio.options.followRedirects = true;
      var response =
          await dio.post("${Golbal.congty!.api}/api/$url", data: body);
      var data = response.data;
      if (data != null) {
        var tbs = List.castFrom(json.decode(data["data"]));
        for (var arr in days) {
          if (arr != null) {
            for (var d in arr) {
              if (d != null) {
                var obj = tbs.firstWhereOrNull(
                    (element) => element["Ngay"] == "D${d["day"]}");
                if (obj == null) {
                  d["IsType"] = -1; //đi làm
                } else if (obj["Chamcong"] == "\\") {
                  d["IsType"] = 2; //đi làm 1/2
                } else if (obj["Chamcong"] == "x") {
                  d["IsType"] = 1; //Nghỉ
                }
              }
            }
          }
        }
        days.refresh();
        initDataHolyday();
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

  void showLydo(e) {
    EasyLoading.showInfo(e["Lydo"] ?? "");
  }

  initDataHolyday() async {
    try {
      isLoadding.value = true;
      var body = {
        "user_id": Golbal.store.user["user_id"],
        "month": month.value,
        "year": year.value,
      };
      String url = "Hrm/GetListHolidays";
      Dio dio = Dio();
      dio.options.headers["Authorization"] = "Bearer ${Golbal.store.token}";
      dio.options.followRedirects = true;
      var response =
          await dio.post("${Golbal.congty!.api}/api/$url", data: body);
      var data = response.data;
      if (data != null) {
        var tbs = List.castFrom(json.decode(data["data"])[0]);
        for (var arr in days) {
          if (arr != null) {
            for (var d in arr) {
              if (d != null) {
                var holyday = tbs.firstWhereOrNull((e) =>
                    DateTime.parse(e["TuNgay"]).day <= d["day"] &&
                    DateTime.parse(e["DenNgay"]).day >= d["day"]);
                if (holyday != null) {
                  d["Holiday"] = holyday;
                }
              }
            }
          }
        }
        days.refresh();
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

  void openYear() {
    Get.bottomSheet(Container(
      decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          )),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
      child: SingleChildScrollView(
        child: Wrap(
            alignment: WrapAlignment.center,
            children: years
                .map((data) => Container(
                    height: 60,
                    margin: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                        color: const Color(0xFF005A9E),
                        borderRadius: BorderRadius.circular(5)),
                    width: 80,
                    child: InkResponse(
                      focusColor: Colors.transparent,
                      hoverColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      onTap: () {
                        setYear(data);
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Năm",
                            style: TextStyle(color: Colors.white),
                          ),
                          const SizedBox(
                            height: 3,
                          ),
                          Text(
                            "$data",
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontSize: 18),
                          ),
                        ],
                      ),
                    )))
                .toList()),
      ),
    ));
  }

  void setYear(int y) {
    Get.back();
    year.value = y;
    if (y != cyear) {
      month.value = 1;
      initialScrollOffset = 0;
    } else {
      month.value = cmonth;
      initialScrollOffset = month.value * 73;
    }
    thangcontroller?.animateTo(initialScrollOffset,
        duration: const Duration(milliseconds: 500), curve: Curves.ease);
    initDay();
    initData();
  }

  int daysInMonth(DateTime date) {
    var firstDayThisMonth = DateTime(date.year, date.month, date.day);
    var firstDayNextMonth = DateTime(firstDayThisMonth.year,
        firstDayThisMonth.month + 1, firstDayThisMonth.day);
    return firstDayNextMonth.difference(firstDayThisMonth).inDays;
  }

  List<List<dynamic>> getWeeksForRange(DateTime start, DateTime end) {
    var result = <List<dynamic>>[];

    var date = start;
    var week = <dynamic>[];

    while (date.difference(end).inDays <= 0) {
      // start new week on Monday
      if (date.weekday == 1 && week.isNotEmpty) {
        result.add(week);
        week = <dynamic>[];
      }

      week.add({"day": date.day, "date": date});

      date = date.add(const Duration(days: 1));
    }

    result.add(week);
    while (result[0].length < 7) {
      result[0].insert(0, null);
    }
    while (result.last.length < 7) {
      result.last.insert(result.last.length, null);
    }
    return result;
  }

  void setMonth(int m) {
    month.value = m;
    initDay();
    initData();
  }

  void initDay() {
    int soday = daysInMonth(DateTime(year.value, month.value, 1));
    days.value = getWeeksForRange(DateTime(year.value, month.value, 1),
        DateTime(year.value, month.value, soday));
  }

  @override
  void onInit() {
    super.onInit();
    for (int i = year.value; i >= year.value - 20; i--) {
      years.add(i);
    }
    initialScrollOffset = month.value * 73;
    animateToIndex();
    initDay();
    initData();
  }

  void animateToIndex() {
    thangcontroller =
        ScrollController(initialScrollOffset: initialScrollOffset);
  }

  @override
  void onClose() {
    if (thangcontroller != null) thangcontroller!.dispose();
    super.onClose();
  }
}
