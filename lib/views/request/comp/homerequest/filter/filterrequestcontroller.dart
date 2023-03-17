import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:soe/utils/golbal/golbal.dart';
import 'package:soe/views/component/date/custom_date_range_picker.dart';

class FilterRequestController extends GetxController {
  var congtys = [].obs;
  var forms = [].obs;
  var teams = [].obs;

  Rx<DateTime?> startCreateDate = Rx<DateTime?>(null);
  Rx<DateTime?> endCreateDate = Rx<DateTime?>(null);

  Rx<DateTime?> startFinishDate = Rx<DateTime?>(null);
  Rx<DateTime?> endFinishDate = Rx<DateTime?>(null);

  var sortRequests = [
    {"value": 0, "text": "A-Z"},
    {"value": 1, "text": "Z-A"},
    {"value": 10, "text": "Ngày lập cũ nhất"},
    {"value": 11, "text": "Ngày lập mới nhất"},
    {"value": 2, "text": "STT bé nhất"},
    {"value": 9, "text": "STT lớn nhất"},
    {"value": 3, "text": "Ngày tạo cũ nhất"},
    {"value": 4, "text": "Ngày tạo mới nhất"},
    {"value": 6, "text": "Ngày cập nhật cũ nhất"},
    {"value": 7, "text": "Cập nhật mới nhất"},
    {"value": 5, "text": "Số ngày quá hạn nhiều nhất"},
    {"value": 8, "text": "Số ngày quá hạn ít nhất"},
    {"value": 12, "text": "Ngày duyệt cũ nhất"},
    {"value": 13, "text": "Ngày duyệt mới nhất"},
    {"value": 14, "text": "Đánh giá thấp nhất"},
    {"value": 15, "text": "Đánh giá cao nhất"}
  ].obs;

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

  void deleChon(RxList<dynamic> dts, item, String id) {
    int idx = dts.indexWhere((element) => element[id] == item[id]);
    if (idx != -1) {
      dts[idx]["chon"] = false;
      dts.refresh();
    }
  }

  void chonFilter(RxList<dynamic> dts, int idx, bool isOne) {
    if (isOne) {
      var chons = dts.where((p0) => p0["chon"] == true);
      for (var c in chons) {
        c["chon"] = false;
      }
    }
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

  void chonCreateDate() {
    showCustomDateRangePicker(
      Get.context!,
      dismissible: true,
      minimumDate: DateTime(2000, 1, 1),
      maximumDate: DateTime.now().add(const Duration(days: 1000)),
      endDate: endCreateDate.value,
      startDate: startCreateDate.value,
      onApplyClick: (start, end) {
        endCreateDate.value = end;
        startCreateDate.value = start;
      },
      onCancelClick: () {
        endCreateDate.value = null;
        startCreateDate.value = null;
      },
    );
  }

  void chonFinishDate() {
    showCustomDateRangePicker(
      Get.context!,
      dismissible: true,
      minimumDate: DateTime(2000, 1, 1),
      maximumDate: DateTime.now().add(const Duration(days: 1000)),
      endDate: endFinishDate.value,
      startDate: startFinishDate.value,
      onApplyClick: (start, end) {
        endFinishDate.value = end;
        startFinishDate.value = start;
      },
      onCancelClick: () {
        endFinishDate.value = null;
        startFinishDate.value = null;
      },
    );
  }

  void clearAdv() {
    Get.back(result: {});
  }

  void apDung() {
    var obj = {};
    //Đơn vị
    obj["congtys"] = null;
    var chondonvis = congtys
        .where((p0) => p0["chon"] == true)
        .map((e) => e["Congty_ID"])
        .toList();
    if (chondonvis.isNotEmpty) {
      obj["congtys"] = chondonvis.join(",");
    }
    //Team
    obj["teams"] = null;
    var chonteams = teams
        .where((p0) => p0["chon"] == true)
        .map((e) => e["Team_ID"])
        .toList();
    if (chonteams.isNotEmpty) {
      obj["teams"] = chonteams.join(",");
    }
    //Form
    obj["forms"] = null;
    var chonforms = forms
        .where((p0) => p0["chon"] == true)
        .map((e) => e["Form_ID"])
        .toList();
    if (chonforms.isNotEmpty) {
      obj["forms"] = chonforms.join(",");
    }
    //Ngày lập
    obj["start_date"] = null;
    if (startCreateDate.value != null) {
      obj["start_date"] = startCreateDate.value!.toIso8601String();
    }
    obj["end_date"] = null;
    if (endCreateDate.value != null) {
      obj["end_date"] = endCreateDate.value!.toIso8601String();
    }
    //Ngày hoàn thành
    obj["start_finishdate"] = null;
    if (startFinishDate.value != null) {
      obj["start_finishdate"] = startFinishDate.value!.toIso8601String();
    }
    obj["end_finishdate"] = null;
    if (endFinishDate.value != null) {
      obj["end_finishdate"] = endFinishDate.value!.toIso8601String();
    }

    var chonsort = sortRequests
        .where((p0) => p0["chon"] == true)
        .map((e) => e["value"])
        .toList();
    if (chonsort.isNotEmpty) {
      obj["sort"] = chonsort[0] == -1 ? null : chonsort[0];
    }

    Get.back(result: obj);
  }

  @override
  void onInit() {
    super.onInit();
    initDictionary();
  }

  initDictionary() async {
    try {
      Dio dio = Dio();
      dio.options.headers["Authorization"] = "Bearer ${Golbal.store.token}";
      dio.options.followRedirects = true;
      var body = {"user_id": Golbal.store.user["user_id"]};
      var response = await dio.post(
          "${Golbal.congty!.api}/api/Request/Get_RequestDictionary",
          data: body);
      var data = response.data;
      if (data != null) {
        var tbs = List.castFrom(json.decode(data["data"]));
        if (tbs.isNotEmpty) {
          var obj = (Get.arguments);
          if (obj != null) {
            initChon(obj, "congtys", "Congty_ID", tbs[0]);
            initChon(obj, "teams", "Team_ID", tbs[1]);
            initChon(obj, "forms", "Form_ID", tbs[2]);
            initChon(obj, "sort", "value", sortRequests);
            sortRequests.refresh();

            if (obj["start_date"] != null) {
              startCreateDate.value = DateTime.tryParse(obj["start_date"]);
            }
            if (obj["end_date"] != null) {
              endCreateDate.value = DateTime.tryParse(obj["end_date"]);
            }

            if (obj["start_finishdate"] != null) {
              startFinishDate.value =
                  DateTime.tryParse(obj["start_finishdate"]);
            }
            if (obj["end_finishdate"] != null) {
              endFinishDate.value = DateTime.tryParse(obj["end_finishdate"]);
            }
          }
          congtys.value = tbs[0];
          teams.value = tbs[1];
          forms.value = tbs[2];
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }
}
