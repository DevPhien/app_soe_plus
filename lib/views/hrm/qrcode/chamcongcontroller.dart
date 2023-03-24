import 'dart:convert';

import 'package:art_sweetalert/art_sweetalert.dart';
import 'package:dio/dio.dart';
import 'package:dio/dio.dart' as dioform;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:soe/utils/golbal/golbal.dart';
import 'package:flutter_face_api/face_api.dart' as regula;
import '../../../flutter_flow/flutter_flow_util.dart';
import '../../component/Calendar/Component/CleanCalendar/Utils.dart';
import 'qrcode.dart';

class ChamCongQRController extends GetxController {
  //Declare
  double initialScrollOffset = 0.0;
  var loading = true.obs;
  RxBool isLoadding = true.obs;
  var datas = [].obs;
  var songaycong = "0".obs;
  var songaycongthang = "0".obs;
  ScrollController? thangcontroller;
  RxInt isType = (0).obs;
  int cmonth = DateTime.now().month;
  var month = DateTime.now().month.obs;
  var months = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12];
  var years = [];
  var thus = ["T2", "T3", "T4", "T5", "T6", "T7", "CN"];
  int cyear = DateTime.now().year;
  var year = DateTime.now().year.obs;
  var days = [].obs;
  var ngayles = [].obs;
  var phongbans = [].obs;
  var events = {}.obs;
  var checkins = [].obs;
  var selectedEvents = [].obs;
  RxInt soNgayDaNghi = (0).obs;
  RxInt soNgayPhep = (0).obs;
  String face = "";

  bool isMonth = false;
  DateTime date = DateTime.now();
  RxString today =
      Golbal.formatDate(DateTime.now().toIso8601String(), "d/m/Y", nam: true)
          .obs;
  //Function

  Future listTBS() async {
    events.value = {};
    selectedEvents.value = [];
    selectedEvents.refresh();
    var par = {
      "Congty_ID": Golbal.store.user["organization_id"],
      "NhanSu_ID": Golbal.store.user["user_id"],
      "Phongbans ": null,
      "Date": date.toIso8601String(),
      "IsMonth": isMonth.toString(),
      "IsType": isType.toString(),
    };
    var strpar = json.encode(par);
    dioform.FormData formData =
        dioform.FormData.fromMap({"proc": "App_ListCheckin", "pas": strpar});
    dioform.Dio dio = dioform.Dio();
    dio.options.headers["Authorization"] = "Bearer ${Golbal.store.token}";
    dio.options.followRedirects = true;
    var res = await dio.post("${Golbal.congty!.api}/api/HomeApi/callProc",
        data: formData);
    if (res.data["data"] == null) {
    } else {
      var arr = List.castFrom(json.decode(res.data["data"]));
      arr[0].forEach((r) {
        r["Date"] = DateTime.parse(r["Date"]);
        r["NgayString"] = DateFormat("dd").format(r["Date"]);
        r["Thu"] = Golbal.getDayName(r["Date"].toIso8601String());
        events[Utils.apiDayFormat(r["Date"])] =
            List.castFrom(arr[0]).where((e) => e["Date"] == r["Date"]).toList();
      });
      selectedEvents.value = events[Utils.apiDayFormat(date)] ?? [];
      checkins.value = arr[0];
      loading.value = false;
    }
  }

  Future<void> goQRView(checkin) async {
    if (checkin["CheckinNhanSu_ID"] != null) {
      Get.toNamed("checkin", arguments: checkin);
    } else if (checkin["IsCheckin"] == true && checkin["IsTimein"] == true) {
      if (checkin["countDay"] != 0) {
        EasyLoading.showInfo(
          "Đã quá hạn Checkin, vui lòng liên hệ bộ phận HRM để checkin bổ sung.",
        );
      } else {
        if (face == "") {
          ArtDialogResponse response = await ArtSweetAlert.show(
              barrierDismissible: true,
              context: Get.context!,
              artDialogArgs: ArtDialogArgs(
                  denyButtonText: "Không",
                  title: "Xác nhận",
                  text: "Thiết lập tính năng nhận diện gương mặt?",
                  confirmButtonText: "Có",
                  type: ArtSweetAlertType.warning));

          if (response.isTapConfirmButton) {
            choiceCamera();
          }
        } else {
          await Navigator.push(
              Get.context!,
              MaterialPageRoute(
                builder: (context) => QRCode(
                  checkin: checkin,
                  isInout: false,
                  face: face,
                ),
              ));
          //await Get.toNamed("qrcode", arguments: checkin);
          listTBS();
        }
      }
    } else {
      EasyLoading.showInfo(
          "Không thể checkin trong lúc này, vui lòng quay lại sau.");
    }
  }

  Future listNgayle() async {
    var par = {
      "Congty_ID": Golbal.store.user["organization_id"],
      "NhanSu_ID": Golbal.store.user["user_id"],
    };
    var strpar = json.encode(par);
    dioform.FormData formData =
        dioform.FormData.fromMap({"proc": "App_NgayLe", "pas": strpar});
    dioform.Dio dio = dioform.Dio();
    dio.options.headers["Authorization"] = "Bearer ${Golbal.store.token}";
    dio.options.followRedirects = true;
    var res = await dio.post("${Golbal.congty!.api}/api/HomeApi/callProc",
        data: formData);
    if (res.data["data"] != null) {
      var arr = List.castFrom(json.decode(res.data["data"]));
      arr[0].forEach((r) {
        r["Date"] = DateTime.parse(r["Ngay"]);
        r["NgayString"] = DateFormat("dd").format(r["Date"]);
        r["Thu"] = Golbal.getDayName(r["Date"].toIso8601String());
        events[Utils.apiDayFormat(DateTime.parse(r["Ngay"]))] = [r];
      });
      selectedEvents.value = events[Utils.apiDayFormat(date)] ?? [];
      ngayles.value = arr[0];
    }
  }

  void handleNewDate(da) {
    date = da;
    selectedEvents.value = events[Utils.apiDayFormat(date)] ?? [];
    if (selectedEvents.isEmpty) listTBS();
  }

  void initNgayNghiPhep() async {
    isLoadding.value = true;
    try {
      var par = {
        "user_id": Golbal.store.user["user_id"],
        "year": year.value,
      };
      var strpar = json.encode(par);
      dioform.FormData formData =
          dioform.FormData.fromMap({"proc": "App_NgayNghiPhep", "pas": strpar});
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
          soNgayDaNghi.value = tbs[0]["soNgayDaNghi"];
          soNgayPhep.value = tbs[0]["soNgayPhep"];
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  initData() async {
    initDataDay();
    listTBS();
    listNgayle();
    initNgayNghiPhep();
    try {
      isLoadding.value = true;
      songaycong.value = "0";
      songaycongthang.value = "0";
      var body = {
        "user_id": Golbal.store.user["user_id"],
        "month": month.value,
        "year": year.value,
      };
      String url = "Hrm/GetCountWorkdays";
      dioform.Dio dio = dioform.Dio();
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
              : "0";
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
      dioform.Dio dio = dioform.Dio();
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
      dioform.Dio dio = dioform.Dio();
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

  void toogleType() {
    isType.value = (isType.value == 0 ? 1 : 0);
    initData();
  }

  void initDay() {
    int soday = daysInMonth(DateTime(year.value, month.value, 1));
    days.value = getWeeksForRange(DateTime(year.value, month.value, 1),
        DateTime(year.value, month.value, soday));
  }

  //Init
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
    initFace();
  }

  void goDay(d) {
    date = d["date"];
    today.value = Golbal.formatDate(date.toIso8601String(), "d/m/Y", nam: true);
    listTBS();
    listNgayle();
  }

  void animateToIndex() {
    thangcontroller =
        ScrollController(initialScrollOffset: initialScrollOffset);
  }

  Future<void> initFace() async {
    var par = {
      "NhanSu_ID": Golbal.store.user["user_id"],
    };
    var strpar = json.encode(par);
    dioform.FormData formData =
        dioform.FormData.fromMap({"proc": "App_GetNhansuFace", "pas": strpar});
    dioform.Dio dio = dioform.Dio();
    dio.options.headers["Authorization"] = "Bearer ${Golbal.store.token}";
    dio.options.followRedirects = true;
    var res = await dio.post("${Golbal.congty!.api}/api/HomeApi/callProc",
        data: formData);
    if (res.data != null && res.data["error"] != 1) {
      var dts = List.castFrom(json.decode(res.data["data"])[0]);
      if (dts.isNotEmpty) face = dts[0]["Face"] ?? "";
    }
  }

  setImage(List<int>? imageFile, int type) async {
    EasyLoading.show(status: "Đang tải...");
    if (imageFile == null) return;
    face = base64Encode(imageFile);
    var par = {
      "NhanSu_ID": Golbal.store.user["user_id"],
      "Face": face,
      "Nguoitao": Golbal.store.user["user_id"],
    };
    var strpar = json.encode(par);
    dioform.FormData formData =
        dioform.FormData.fromMap({"proc": "App_AddNhansuFace", "pas": strpar});
    dioform.Dio dio = dioform.Dio();
    dio.options.headers["Authorization"] = "Bearer ${Golbal.store.token}";
    dio.options.followRedirects = true;
    var res = await dio.post("${Golbal.congty!.api}/api/HomeApi/callProc",
        data: formData);
    if (res.data != null && res.data["error"] != 1) {
      EasyLoading.showSuccess("Đăng ký khuôn mặt thành công!");
    } else {
      EasyLoading.showError(
          "Đăng ký khuôn mặt không thành công, vui lòng thử lại!");
    }
    EasyLoading.dismiss();
  }

  void choiceCamera() {
    regula.FaceSDK.presentFaceCaptureActivity().then((result) => setImage(
        base64Decode(regula.FaceCaptureResponse.fromJson(json.decode(result))!
            .image!
            .bitmap!
            .replaceAll("\n", "")),
        regula.ImageType.LIVE));
  }

  Future<void> goFace() async {
    if (face == "") {
      ArtDialogResponse response = await ArtSweetAlert.show(
          barrierDismissible: true,
          context: Get.context!,
          artDialogArgs: ArtDialogArgs(
              denyButtonText: "Không",
              title: "Xác nhận",
              text: "Thiết lập tính năng nhận diện gương mặt?",
              confirmButtonText: "Có",
              type: ArtSweetAlertType.warning));

      if (response.isTapConfirmButton) {
        choiceCamera();
      }
    } else {
      Get.to(() => Scaffold(
            appBar: AppBar(title: const Text("Khuôn mặt đã đăng ký")),
            body: Image.memory(base64Decode(face)),
          ));
    }
  }

  @override
  void onClose() {
    if (thangcontroller != null) thangcontroller!.dispose();
    super.onClose();
  }
}
