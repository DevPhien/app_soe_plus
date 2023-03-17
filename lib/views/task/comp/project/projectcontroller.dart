import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:sliding_sheet/sliding_sheet.dart';
import 'package:soe/utils/golbal/golbal.dart';

class ProjectController extends GetxController {
  ScrollController scrollController = ScrollController();
  final searchController = TextEditingController();
  final sheetCtr = SheetController();
  //Declare
  var loading = true.obs;
  var showFab = true.obs;
  RxInt typeP = (-1).obs;

  var datas = [].obs;
  var countdata = (0).obs;
  var countdatas = {}.obs;
  var lastdata = false.obs;
  var isSearchAdv = false.obs;
  var dictionarys = [].obs;

  bool isWeb = kIsWeb;
  var loaddingmore = false;

  Map<String, dynamic> options = {
    "p": 1,
    "pz": 20,
    "s": null,
    "sort": 7,
    "Trangthai": -1,
    "start_date": null,
    "end_date": null,
    "IsType": -1,
    "congtys": null,
    "nhoms": null,
    "status": null,
  };

  var typeProjects = [
    {"id": 0, "title": "Tham gia"},
    {"id": 1, "title": "Quản lý"},
    {"id": 2, "title": "Theo dõi"},
    {"id": -2, "title": "Tôi tạo"},
  ];

  //function count
  void goTypeProject(context, type) {
    typeP.value = type;
    options["s"] = null;
    options["p"] = 1;
    lastdata.value = false;
    initProject(true);
  }

  //Function
  void resetOpition() {
    options["s"] = null;
    options["sort"] = 7;
    options["Trangthai"] = -1;
    options["congtys"] = null;
    options["nhoms"] = null;
    options["status"] = null;
  }

  Future<void> onLoadmore() {
    if (loaddingmore || lastdata.value == true) return Future.value(null);
    loaddingmore = true;
    options["p"] = int.parse(options["p"].toString()) + 1;
    EasyLoading.show(
      status: "Đang tải trang ${options["p"]}",
    );
    initProject(false);
    return Future.value(null);
  }

  void search(s) {
    loading.value = true;
    datas.clear();
    options["s"] = s;
    options["p"] = 1;
    initProject(false);
  }

  Future<void> goFilterAdv() async {
    var rs = await Get.toNamed("filterproject", arguments: options);
    if (rs == null) return;
    if (rs != null && rs.keys.length > 0) {
      isSearchAdv.value = true;
      for (var k in rs.keys) {
        options[k] = rs[k];
      }
    } else {
      isSearchAdv.value = false;
      resetOpition();
    }
    scrollController.animateTo(0,
        duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
    loading.value = true;
    datas.clear();
    options["p"] = 1;
    initProject(false);
  }

  void clearAdv() {
    isSearchAdv.value = false;
    resetOpition();
    scrollController.animateTo(0,
        duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
    loading.value = true;
    datas.clear();
    options["p"] = 1;
    initProject(true);
  }

  Future<void> openAddProject() async {
    var rs = await Get.toNamed("addproject", arguments: {
      "title": "Thêm dự án",
      "STT": countdatas[0],
      "dictionarys": dictionarys,
    });
    if (rs == true) {
      initProject(true);
      countProject();
      EasyLoading.showSuccess("Cập nhật thành công");
    }
  }

  Future<void> goProject(project) async {
    var rs = await Get.toNamed("detailproject", arguments: project);
    if (rs != null && rs["project"] != null) {
      if (rs["isdel"] == true) {
        int idx =
            datas.indexWhere((e) => e["DuanID"] == rs["project"]["DuanID"]);
        if (idx != -1) {
          datas.removeAt(idx);
          countProject();
          EasyLoading.showSuccess("Xóa thành công");
        }
      } else {
        int idx =
            datas.indexWhere((e) => e["DuanID"] == rs["project"]["DuanID"]);
        if (idx != -1) {
          datas[idx] = rs["project"];
        }
      }
    }
    return;
  }

  //init
  @override
  void onInit() {
    super.onInit();
    initData();
  }

  void initData() {
    initProject(true);
    countProject();
    initDictionary();
  }

  void initProject(f) async {
    try {
      if (f) {
        loading.value = true;
      }
      var body = {
        "user_id": Golbal.store.user["user_id"],
        "p": options["p"],
        "pz": options["pz"],
        "s": options["s"],
        "sort": options["sort"],
        "Trangthai": options["Trangthai"],
        "start_date": options["start_date"],
        "end_date": options["end_date"],
        "IsType": typeP.value,
        "congtys": options["congtys"],
        "nhoms": options["nhoms"],
        "status": options["status"],
      };
      String url = "Task/Get_ProjectByMe";
      Dio dio = Dio();
      dio.options.headers["Authorization"] = "Bearer ${Golbal.store.token}";
      dio.options.followRedirects = true;
      var response =
          await dio.post("${Golbal.congty!.api}/api/$url", data: body);
      var data = response.data;
      if (data != null) {
        var tbs = List.castFrom(json.decode(data["data"]));
        if (tbs[0].isNotEmpty) {
          for (var element in tbs[0]) {
            if (element["Thanhviens"] != null) {
              element["Thanhviens"] = json.decode(element["Thanhviens"]);
            } else {
              element["Thanhviens"] = [];
            }
          }
          if (f) {
            datas.value = tbs[0];
          } else {
            datas.addAll(tbs[0]);
          }
          //print(tbs);
        } else {
          if (loaddingmore) {
            lastdata.value = true;
            EasyLoading.showToast("Bạn đã xem hết dự án rồi!");
          } else {
            datas.value = [];
          }
        }
        if (tbs[1].isNotEmpty) {
          countdata.value = tbs[1][0]["c"];
        }
        if (loaddingmore) {
          loaddingmore = false;
        }
      } else {
        lastdata.value = true;
        EasyLoading.showToast("Bạn đã xem hết dự án rồi!");
      }
      if (loading.value) {
        loading.value = false;
      }
      EasyLoading.dismiss();
    } catch (e) {
      loading.value = false;
      if (kDebugMode) {
        print(e);
      }
      EasyLoading.dismiss();
    }
  }

  void countProject() async {
    try {
      var body = {
        "user_id": Golbal.store.user["user_id"],
        "s": options["s"],
        "Trangthai": options["Trangthai"],
        "start_date": options["start_date"],
        "end_date": options["end_date"],
        "congtys": options["congtys"],
        "nhoms": options["nhoms"],
        "status": options["status"],
      };
      String url = "Task/Get_CountProjectByMe";
      Dio dio = Dio();
      dio.options.headers["Authorization"] = "Bearer ${Golbal.store.token}";
      dio.options.followRedirects = true;
      var response =
          await dio.post("${Golbal.congty!.api}/api/$url", data: body);
      var data = response.data;
      if (data != null) {
        var tbs = List.castFrom(json.decode(data["data"]));
        if (tbs[0].isNotEmpty) {
          var obj = {};
          for (var tb in tbs[0]) {
            if (tb["count"] != null) {
              obj[tb["Trangthai"]] = tb["count"];
            }
          }
          countdatas.value = obj;
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  void initDictionary() async {
    try {
      var body = {
        "user_id": Golbal.store.user["user_id"],
      };
      String url = "Task/Get_ProjectDictionary";
      Dio dio = Dio();
      dio.options.headers["Authorization"] = "Bearer ${Golbal.store.token}";
      dio.options.followRedirects = true;
      var response =
          await dio.post("${Golbal.congty!.api}/api/$url", data: body);
      var data = response.data;
      if (data != null) {
        var tbs = List.castFrom(json.decode(data["data"]));
        dictionarys.value = tbs;
      } else {
        dictionarys.value = [];
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }
}
