import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:soe/utils/golbal/golbal.dart';

class TaskProjectController extends GetxController {
  ScrollController tkController = ScrollController();
  RxInt pageIndex = 1.obs;
  var loaddingmore = false;
  var getdata = {}.obs;
  RxBool isLoadding = true.obs;
  RxBool showFab = true.obs;
  var lastdata = false.obs;
  var datas = [].obs;
  var countdata = {}.obs;
  var dictionarys = [].obs;
  var duans = [].obs;
  RxInt typeVB = (-1).obs;
  Map<String, dynamic> options = {
    "p": 1,
    "pz": 20,
    "s": null,
    "istype": -1,
    "sort": 7,
    "loc": 0
  };
  var isSearchAdv = false.obs;
  var typeCongviecs = [
    {"id": "1", "title": "Tôi làm"},
    {"id": "2", "title": "Quản lý"},
    {"id": "0", "title": "Theo dõi"},
    {"id": "-2", "title": "Tôi tạo"},
  ];
  void goTypeTask(int type) {
    typeVB.value = type;
    datas.clear();
    options["s"] = null;
    options["p"] = 1;
    lastdata.value = false;
    initTask(false);
  }

  void onPageChanged(int p) {
    //datas.clear();
    if (p == 0) {
      Get.back();
      return;
    }
    pageIndex.value = p;
  }

  initTask(f) async {
    try {
      if (!f) {
        isLoadding.value = true;
      }
      var body = {
        "user_id": Golbal.store.user["user_id"],
        "duan_id": getdata["DuanID"],
        "p": options["p"],
        "pz": options["pz"],
        "sort": options["sort"],
        "s": options["s"],
        "loc": options["loc"],
        "start_date": options["start_date"],
        "end_date": options["end_date"],
        "yeucaureview": options["yeucaureview"],
        "isdeadline": options["isdeadline"],
        "uutien": options["uutien"],
        "trongso": options["trongso"],
        "nguoigiao": options["nguoigiao"],
        "thuchien": options["thuchien"],
        "phongbans": options["phongbans"],
        "status": options["status"],
        "istype": typeVB.value,
      };
      String url = "Task/Get_TaskByDuan";
      Dio dio = Dio();
      dio.options.headers["Authorization"] = "Bearer ${Golbal.store.token}";
      dio.options.followRedirects = true;
      var response =
          await dio.post("${Golbal.congty!.api}/api/$url", data: body);
      var data = response.data;
      if (data != null) {
        var tbs = List.castFrom(json.decode(data["data"]));
        if (tbs.isNotEmpty) {
          for (var element in tbs) {
            if (element["anhThumb"] != null) {
              element["anhThumb"] =
                  Golbal.congty!.fileurl + element["anhThumb"];
            }
            if (element["Thanhviens"] != null) {
              element["Thanhviens"] = json.decode(element["Thanhviens"]);
            }
          }
          if (f) {
            datas.addAll(tbs);
          } else {
            datas.value = tbs;
          }
          //print(tbs);
        } else {
          lastdata.value = true;
          EasyLoading.showToast("Bạn đã xem hết công việc rồi!");
        }
        if (loaddingmore) {
          loaddingmore = false;
        }
      } else {
        lastdata.value = true;
        EasyLoading.showToast("Bạn đã xem hết công việc rồi!");
      }
      if (isLoadding.value) {
        isLoadding.value = false;
      }
      EasyLoading.dismiss();
    } catch (e) {
      if (isLoadding.value) {
        isLoadding.value = false;
      }
      if (kDebugMode) {
        print(e);
      }
      EasyLoading.dismiss();
    }
  }

  Future<void> refershData() {
    datas.clear();
    options["s"] = "";
    options["p"] = 1;
    initTask(false);
    return Future.value(null);
  }

  void search(String s) {
    isLoadding.value = true;
    datas.clear();
    options["s"] = s;
    options["p"] = 1;
    initTask(false);
  }

  void resetOpition() {
    options["start_date"] = null;
    options["end_date"] = null;
    options["yeucaureview"] = null;
    options["isdeadline"] = null;
    options["uutien"] = null;
    options["trongso"] = null;
    options["nguoigiao"] = null;
    options["thuchien"] = null;
    options["phongbans"] = null;
    options["status"] = null;
    options["loc"] = 0;
    options["istype"] = -1;
    options["sort"] = 1;
    options["s"] = null;
  }

  Future<void> goFilterAdv() async {
    EasyLoading.showInfo("Chức năng đang được cập nhật");
    return;
    // var rs = await Get.toNamed("filtertask", arguments: options);
    // if (rs == null) {
    //   return;
    // }
    // if (rs != null && rs.keys.length > 0) {
    //   isSearchAdv.value = true;
    //   for (var k in rs.keys) {
    //     options[k] = rs[k];
    //   }
    // } else {
    //   isSearchAdv.value = false;
    //   resetOpition();
    // }
    // tkController.animateTo(0,
    //     duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
    // isLoadding.value = true;
    // datas.clear();
    // options["p"] = 1;
    // initTask(false);
  }

  void clearAdv() {
    isSearchAdv.value = false;
    resetOpition();
    tkController.animateTo(0,
        duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
    isLoadding.value = true;
    datas.clear();
    options["p"] = 1;
    initTask(false);
  }

  Future<void> onLoadmore() {
    if (loaddingmore || lastdata.value == true) return Future.value(null);
    loaddingmore = true;
    options["p"] = int.parse(options["p"].toString()) + 1;
    EasyLoading.show(
      status: "Đang tải trang ${options["p"]}",
    );
    initTask(true);
    return Future.value(null);
  }

  //Detail
  Future<void> goTask(task) async {
    var rs = await Get.toNamed("detailtask", arguments: task);
    if (rs != null && rs["task"] != null) {
      if (rs["isdel"] == true) {
        int idx = datas
            .indexWhere((e) => e["CongviecID"] == rs["task"]["CongviecID"]);
        if (idx != -1) {
          datas.removeAt(idx);
          EasyLoading.showSuccess("Xóa thành công");
        }
      } else {
        int idx = datas
            .indexWhere((e) => e["CongviecID"] == rs["task"]["CongviecID"]);
        if (idx != -1) {
          datas[idx] = rs["task"];
        }
      }
    }
    return;
  }

  Future<void> addTask({String? parentID}) async {
    var rs = await Get.toNamed("addtask", arguments: {
      "title": "Thêm công việc",
      "ParentID": parentID,
      "DuanID": getdata["DuanID"],
      "dictionarys": dictionarys,
      "duans": duans,
    });
    if (rs == true) {
      refershData();
    }
  }

  @override
  void onInit() {
    super.onInit();
    getdata.value = Get.arguments;
    initTask(false);
    initTudien();
    initDuan();
  }

  @override
  void onClose() {
    tkController.dispose();
    super.onClose();
  }

  void initTudien() async {
    try {
      Dio dio = Dio();
      dio.options.headers["Authorization"] = "Bearer ${Golbal.store.token}";
      dio.options.followRedirects = true;
      var response = await dio.post(
          "${Golbal.congty!.api}/api/Task/Get_TaskDictionary",
          data: {"user_id": Golbal.store.user["user_id"]});
      var data = response.data;
      if (data != null) {
        var tbs = List.castFrom(json.decode(data["data"]));
        dictionarys.value = tbs;
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  void initDuan() async {
    try {
      Dio dio = Dio();
      dio.options.headers["Authorization"] = "Bearer ${Golbal.store.token}";
      dio.options.followRedirects = true;
      var response = await dio
          .post("${Golbal.congty!.api}/api/Task/Get_DuanByUser", data: {
        "user_id": Golbal.store.user["user_id"],
        "nhomduan_id": null,
        "s": null,
        "trangthai": -1,
        "istype": -1
      });
      var data = response.data;
      if (data != null) {
        var tbs = List.castFrom(json.decode(data["data"]));
        duans.value = tbs;
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }
}
