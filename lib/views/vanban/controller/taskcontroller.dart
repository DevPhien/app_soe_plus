import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import '../../../utils/golbal/golbal.dart';

class TaskVBController extends GetxController {
  var tasks = [].obs;
  RxInt pageIndex = 1.obs;
  late String vbid;
  RxBool isloadding = true.obs;
  initTask(String vanBanMasterID) async {
    vbid = vanBanMasterID;
    tasks.clear();
    try {
      Dio dio = Dio();
      dio.options.headers["Authorization"] = "Bearer ${Golbal.store.token}";
      dio.options.followRedirects = true;
      var body = {
        "user_id": Golbal.store.user["user_id"],
        "doc_master_id": vanBanMasterID,
        "type_task": "${pageIndex.value}",
        "s": null,
      };
      var response = await dio
          .post("${Golbal.congty!.api}/api/Doc/GetListLinkTask", data: body);
      var data = response.data;
      if (data != null) {
        var tbs = json.decode(data["data"]);
        if (tbs.isNotEmpty) {
          var arr =
              tbs.where((element) => element["Parent_ID"] == null).toList();
          for (var dt in arr) {
            initTree(tbs, dt);
            dt["open"] = true;
            dt["chon"] = false;
            dt["CongviecTen"] =
                dt["CongviecTen"].toString().trim().replaceAll("&nbsp;", "");
          }
          tasks.value = arr;
        }
        isloadding.value = false;
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  void setPageIndex(int idx) {
    pageIndex.value = idx;
    isloadding.value = true;
    initTask(vbid);
  }

  void dequyChon(fd, vl) {
    if (fd["hasChild"] == true) {
      for (var fd1 in fd["Childs"]) {
        dequyChon(fd1, vl);
      }
    }
    fd["chon"] = vl;
  }

  void toogleTask(fd) {
    fd["open"] = !fd["open"];
    tasks.refresh();
  }

  void resetChon() {
    for (var fd in tasks) {
      dequyChon(fd, false);
    }
  }

  void toogleChon(fd, bool isOne) {
    if (isOne) resetChon();
    fd["chon"] = !fd["chon"];
    if (!isOne) {
      dequyChon(fd, fd["chon"]);
    }
    tasks.refresh();
  }

  void setChon(bool isOne, fd, vl) {
    if (isOne) resetChon();
    fd["chon"] = vl;
    if (!isOne) {
      dequyChon(fd, fd["chon"]);
    }
    tasks.refresh();
  }

  initTree(List<dynamic> tbs, obj) {
    var dts = tbs
        .where((element) => element["Parent_ID"] == obj["CongviecID"])
        .toList();
    if (dts.isNotEmpty) {
      for (var dt in dts) {
        initTree(tbs, dt);
      }
      obj["Childs"] = dts;
    }
    obj["hasChild"] = dts.isNotEmpty;
    obj["open"] = false;
    obj["chon"] = false;
    obj["CongviecTen"] =
        obj["CongviecTen"].toString().trim().replaceAll("&nbsp;", "");
  }

  void getdqChon(List chons, fd) {
    if (fd["chon"] == true) {
      chons.add(fd["CongviecID"]);
    }
    if (fd["hasChild"] == true) {
      for (var fd1 in List.castFrom(fd["Childs"])
          .where((element) => element["chon"] == true)) {
        getdqChon(chons, fd1);
      }
    }
  }

  List getChon() {
    var chons = [];
    for (var fd in tasks) {
      getdqChon(chons, fd);
    }
    return chons;
  }

  void saveChon() {
    var chons = getChon();
    resetChon();
    Get.back(result: chons);
  }

  void back() {
    resetChon();
    Get.back();
  }

  @override
  void onInit() {
    super.onInit();
  }
}
