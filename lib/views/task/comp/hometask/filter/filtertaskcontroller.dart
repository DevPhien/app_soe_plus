import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import '../../../../../utils/golbal/golbal.dart';
import '../../../../component/date/custom_date_range_picker.dart';

class FilterTaskController extends GetxController {
  var nhoms = [].obs;
  var trangthais = [].obs;
  var noibanhanhs = [].obs;
  var nguoiguis = [].obs;
  var linhvucs = [].obs;
  var showTukhoa = false.obs;
  var arrTypes = [
    {"value": -1, "text": "Tất cả"},
    {"value": 1, "text": "Tôi làm"},
    {"value": 2, "text": "Quản lý"},
    {"value": 0, "text": "Theo dõi"},
    {"value": 3, "text": "Công việc liên quan"},
    {"value": -2, "text": "Người tạo"},
  ].obs;
  var arrSorts = [
    {"value": 0, "text": "Tên công việc A-Z"},
    {"value": 1, "text": "Tên công việc Z-A"},
    {"value": 2, "text": "Thứ tự"},
    {"value": 3, "text": "Ngày tạo"},
    {"value": 4, "text": "Ngày tạo mới nhất"},
    {"value": 5, "text": "Quá hạn"},
  ].obs;
  Rx<DateTime?> startDate = Rx<DateTime?>(null);
  Rx<DateTime?> endDate = Rx<DateTime?>(null);
  String? s = "";
  initTudien() async {
    try {
      Dio dio = Dio();
      dio.options.headers["Authorization"] = "Bearer ${Golbal.store.token}";
      dio.options.followRedirects = true;
      var body = {"user_id": Golbal.store.user["user_id"]};
      var response = await dio
          .post("${Golbal.congty!.api}/api/Doc/GetListTudien", data: body);
      var data = response.data;
      if (data != null) {
        var tbs = List.castFrom(json.decode(data["data"]));
        if (tbs.isNotEmpty) {
          var obj = (Get.arguments);
          if (obj != null) {
            initChon(obj, "groups", "NhomTaskID", tbs[0]);
            initChon(obj, "status", "TaskTrangthai_ID", tbs[1]);
            initChon(obj, "places", "noiBanHanhID", tbs[2]);
            initChon(obj, "senders", "NhanSu_ID", tbs[3]);
            initChon(obj, "fields", "linhvucID", tbs[4]);
            initChon(obj, "type", "value", arrTypes);
            initChon(obj, "sort", "value", arrSorts);
            arrTypes.refresh();
            arrSorts.refresh();

            if (obj["doc_sdate"] != null) {
              startDate.value = DateTime.tryParse(obj["doc_sdate"]);
            }
            if (obj["doc_edate"] != null) {
              endDate.value = DateTime.tryParse(obj["doc_edate"]);
            }
          }
          nhoms.value = tbs[0];
          trangthais.value = tbs[1];
          noibanhanhs.value = tbs[2];
          nguoiguis.value = tbs[3];
          linhvucs.value = tbs[4];
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  void deleChon(RxList<dynamic> dts, item, String id) {
    int idx = dts.indexWhere((element) => element[id] == item[id]);
    if (idx != -1) {
      dts[idx]["chon"] = false;
      dts.refresh();
    }
  }

  void chonFilter(RxList<dynamic> dts, int idx, bool isOne) {
    if (dts[idx]["chon"] == null) {
      dts[idx]["chon"] = true;
    } else {
      dts[idx]["chon"] = !dts[idx]["chon"];
    }
    dts.refresh();
    if (isOne) {
      Get.back();
    }
  }

  void clearAdv() {
    Get.back(result: {});
  }

  void chonDate() {
    showCustomDateRangePicker(
      Get.context!,
      dismissible: true,
      minimumDate: DateTime(2000, 1, 1),
      maximumDate: DateTime.now().add(const Duration(days: 1000)),
      endDate: endDate.value,
      startDate: startDate.value,
      onApplyClick: (start, end) {
        endDate.value = end;
        startDate.value = start;
      },
      onCancelClick: () {
        endDate.value = null;
        startDate.value = null;
      },
    );
  }

  void initChon(obj, key, id, datas) {
    if (obj[key] != null) {
      var chons = datas
          .where(
              (element) => obj[key].toString().contains(element[id].toString()))
          .toList();
      for (var e in chons) {
        e["chon"] = true;
      }
    }
  }

  void apDung() {
    var obj = {};
    var chonnhoms = nhoms
        .where((p0) => p0["chon"] == true)
        .map((e) => e["NhomTaskID"])
        .toList();
    if (chonnhoms.isNotEmpty) {
      obj["groups"] = chonnhoms.join(",");
    }
    //Trạng thái
    chonnhoms = trangthais
        .where((p0) => p0["chon"] == true)
        .map((e) => e["TaskTrangthai_ID"])
        .toList();
    if (chonnhoms.isNotEmpty) {
      obj["status"] = chonnhoms.join(",");
    }
    //Nơi ban hành
    chonnhoms = noibanhanhs
        .where((p0) => p0["chon"] == true)
        .map((e) => e["noiBanHanhID"])
        .toList();
    if (chonnhoms.isNotEmpty) {
      obj["places"] = chonnhoms.join(",");
    }

//Người gửi
    chonnhoms = nguoiguis
        .where((p0) => p0["chon"] == true)
        .map((e) => e["NhanSu_ID"])
        .toList();
    if (chonnhoms.isNotEmpty) {
      obj["senders"] = chonnhoms.join(",");
    }
    //Lĩnh vực
    chonnhoms = linhvucs
        .where((p0) => p0["chon"] == true)
        .map((e) => e["linhvucID"])
        .toList();
    if (chonnhoms.isNotEmpty) {
      obj["fields"] = chonnhoms.join(",");
    }
    if (s != "") {
      obj["s"] = s;
    }
    if (startDate.value != null) {
      obj["doc_sdate"] = startDate.value!.toIso8601String();
    }
    if (endDate.value != null) {
      obj["doc_edate"] = endDate.value!.toIso8601String();
    }
    //
    chonnhoms = arrTypes
        .where((p0) => p0["chon"] == true)
        .map((e) => e["value"])
        .toList();
    if (chonnhoms.isNotEmpty) {
      obj["type"] = chonnhoms[0];
    }
    chonnhoms = arrSorts
        .where((p0) => p0["chon"] == true)
        .map((e) => e["value"])
        .toList();
    if (chonnhoms.isNotEmpty) {
      obj["sort"] = chonnhoms[0];
    }

    Get.back(result: obj);
  }

  @override
  void onInit() {
    super.onInit();
    initTudien();
  }
}
