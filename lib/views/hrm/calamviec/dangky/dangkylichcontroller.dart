import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart' as dioform;
import '../../../../utils/golbal/golbal.dart';

extension Iterables<E> on Iterable<E> {
  Map<K, List<E>> groupBy<K>(K Function(E) keyFunction) => fold(
      <K, List<E>>{},
      (Map<K, List<E>> map, E element) =>
          map..putIfAbsent(keyFunction(element), () => <E>[]).add(element));
}

class DangkylichController extends GetxController {
  RxBool showAction = false.obs;
  RxInt nam = (DateTime.now().year).obs;
  RxInt thang = (DateTime.now().month).obs;
  var calams = [].obs;
  var diadiems = [].obs;
  var thuens = [
    "Monday",
    "Tuesday",
    "Wednesday",
    "Thursday",
    "Friday",
    "Saturday",
    "Sunday"
  ];
  var thuvis = ["T2", "T3", "T4", "T5", "T6", "T7", "CN"];
  var dtngays = [].obs;
  Future<void> initData() async {
    EasyLoading.show(status: "Đang load dữ liệu...");
    dioform.FormData formData = dioform.FormData.fromMap({
      "proc": "HRM_Dangkylamviec_ListCanhan",
      "pas": json.encode({
        "NhanSu_ID": Golbal.store.user["user_id"],
        "thang": thang.value.toString(),
        "nam": nam.value.toString(),
      })
    });
    dioform.Dio dio = dioform.Dio();
    dio.options.headers["Authorization"] = "Bearer ${Golbal.store.token}";
    dio.options.followRedirects = true;
    var res = await dio.post("${Golbal.congty!.api}/api/HomeApi/callProc",
        data: formData);
    if (res.data["err"] == "0") {
      var dts = List.castFrom(json.decode(res.data["data"])[0])
          .toList()
          .groupBy((p0) => p0["Tuan"]);
      int k = 0;
      dtngays.value = [];
      dts.forEach((key, value) {
        int len = value.length;
        for (int i = 1; i <= 7 - len; i++) {
          if (k == 0) {
            value.insert(0, {});
          } else {
            value.add({});
          }
        }
        dtngays.add(value);
        k++;
      });
      EasyLoading.dismiss();
    } else {
      EasyLoading.showError("Có lỗi xảy ra, vui lòng thử lại!");
    }
  }

  void nextThang(bool f) {
    showAction.value = false;
    if (f) {
      if (thang.value < 12) {
        thang.value += 1;
      } else {
        thang.value = 1;
        nam.value += 1;
      }
    } else {
      if (thang.value > 1) {
        thang.value -= 1;
      } else {
        thang.value = 12;
        nam.value -= 1;
      }
    }
    initData();
  }

  Future<void> delCa() async {
    bool rs = await showDialog(
        context: Get.context!,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            //title: new Text('Thông báo'),
            content: SingleChildScrollView(
              child: ListBody(
                children: const <Widget>[
                  Text("Bạn có muốn xoá ca làm việc này không?"),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: Text(
                  'Có',
                  style: TextStyle(color: Golbal.appColor, fontSize: 16.0),
                ),
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
              ),
              TextButton(
                child: const Text(
                  'Không',
                  style: TextStyle(color: Colors.black45, fontSize: 16.0),
                ),
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
              ),
            ],
          );
        });
    if (rs) {
      EasyLoading.show(status: "Đang thực hiện...");
      var ngaylamviecs = [];
      dtngays
          .where(
              (p0) => p0.indexWhere((element) => element["chon"] == true) != -1)
          .forEach((element) {
        element.where((e) => e["chon"] == true).forEach((it) {
          ngaylamviecs.add(it["Ngay"]);
        });
      });
      var objpar = {
        "dangkyid": 0,
        "caid": -1,
        "diadiemid": -1,
        "diadiemkhac": "",
        "CheckinLatLong": null,
        "ngaylamviec": ngaylamviecs.join(","),
        "NhanSu_ID": Golbal.store.user["user_id"]
      };
      var strpar = json.encode(objpar);
      dioform.FormData formData = dioform.FormData.fromMap(
          {"proc": "App_DangkycalamviecList", "pas": strpar});
      dioform.Dio dio = dioform.Dio();
      dio.options.headers["Authorization"] = "Bearer ${Golbal.store.token}";
      dio.options.followRedirects = true;
      var res = await dio.post("${Golbal.congty!.api}/api/HomeApi/callProc",
          data: formData);
      if (res.data["err"] == "0") {
        EasyLoading.showSuccess("Xoá ca làm việc thành công!");
        initData();
      } else {
        EasyLoading.showError("Có lỗi xảy ra, vui lòng thử lại!");
      }
    }
  }

  void chonItem(item) {
    item["chon"] = !(item["chon"] ?? false);
    showAction.value = dtngays
        .where(
            (p0) => p0.indexWhere((element) => element["chon"] == true) != -1)
        .isNotEmpty;
    dtngays.refresh();
  }

  void chonAllItem(list, item) {
    item["chon"] = !(item["chon"] ?? false);
    for (var e in list) {
      if (e["dayngay"] != null) e["chon"] = item["chon"];
    }
    showAction.value = dtngays
        .where(
            (p0) => p0.indexWhere((element) => element["chon"] == true) != -1)
        .isNotEmpty;
    dtngays.refresh();
  }

  Future<void> initTudien() async {
    dioform.FormData formData = dioform.FormData.fromMap({
      "proc": "App_Dangkylamviec_Tudien",
      "pas": json.encode({
        "Congty_ID": Golbal.store.user["organization_id"],
      })
    });
    dioform.Dio dio = dioform.Dio();
    dio.options.headers["Authorization"] = "Bearer ${Golbal.store.token}";
    dio.options.followRedirects = true;
    var res = await dio.post("${Golbal.congty!.api}/api/HomeApi/callProc",
        data: formData);
    if (res.data["err"] == "0") {
      var dts = List.castFrom(json.decode(res.data["data"]));
      calams.value = dts[0];
      diadiems.value = dts[1];
    }
  }

  void chonca(item) {
    calams.where((element) => element["chon"] == true).forEach((element) {
      element["chon"] = false;
    });
    item["chon"] = !(item["chon"] ?? false);
    calams.refresh();
  }

  void chondiadien(item) {
    diadiems.where((element) => element["chon"] == true).forEach((element) {
      element["chon"] = false;
    });
    item["chon"] = !(item["chon"] ?? false);
    diadiems.refresh();
  }

  Future<void> addDkylamviec() async {
    var calam = calams.firstWhereOrNull((p0) => p0["chon"] == true);
    if (calam == null) {
      EasyLoading.showError("Vui lòng chọn ca làm việc");
      return;
    }
    var diadiem = diadiems.firstWhereOrNull((p0) => p0["chon"] == true);
    if (diadiem == null) {
      EasyLoading.showError("Vui lòng chọn địa điểm làm việc");
      return;
    }
    EasyLoading.show(status: "Đang thực hiện...");
    var ngaylamviecs = [];
    dtngays
        .where(
            (p0) => p0.indexWhere((element) => element["chon"] == true) != -1)
        .forEach((element) {
      element.where((e) => e["chon"] == true).forEach((it) {
        ngaylamviecs.add(it["Ngay"]);
      });
    });
    var objpar = {
      "dangkyid": dtngays
              .where((p0) =>
                  p0.indexWhere((element) =>
                      element["chon"] == true && element["dangkyid"] != null) !=
                  -1)
              .isNotEmpty
          ? 0
          : -1,
      "caid": "${calam["caid"]}",
      "diadiemid": "${diadiem["diadiemid"]}",
      "diadiemkhac": "",
      "CheckinLatLong": diadiem["CheckinLatLong"],
      "ngaylamviec": ngaylamviecs.join(","),
      "NhanSu_ID": Golbal.store.user["user_id"]
    };
    var strpar = json.encode(objpar);
    dioform.FormData formData = dioform.FormData.fromMap(
        {"proc": "App_DangkycalamviecList", "pas": strpar});
    dioform.Dio dio = dioform.Dio();
    dio.options.headers["Authorization"] = "Bearer ${Golbal.store.token}";
    dio.options.followRedirects = true;
    var res = await dio.post("${Golbal.congty!.api}/api/HomeApi/callProc",
        data: formData);
    if (res.data["err"] == "0") {
      EasyLoading.showSuccess("Cập nhật ca làm việc thành công!");
      initData();
    } else {
      EasyLoading.showError("Có lỗi xảy ra, vui lòng thử lại!");
    }
    Get.back();
  }

  @override
  void onInit() {
    super.onInit();
    initData();
    initTudien();
  }

  @override
  void onClose() {
    EasyLoading.dismiss();
    super.onClose();
  }
}
