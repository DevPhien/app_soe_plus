import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import '../../../utils/golbal/golbal.dart';

class FolderController extends GetxController {
  var foldes = [].obs;
  RxBool isloadding = true.obs;
  initFolder() async {
    foldes.clear();
    try {
      Dio dio = Dio();
      dio.options.headers["Authorization"] = "Bearer ${Golbal.store.token}";
      dio.options.followRedirects = true;
      var body = {"user_id": Golbal.store.user["user_id"]};
      var response = await dio
          .post("${Golbal.congty!.api}/api/Doc/GetListMyboxFolder", data: body);
      var data = response.data;
      if (data != null) {
        var tbs = json.decode(data["data"]);
        if (tbs.isNotEmpty) {
          var arr =
              tbs.where((element) => element["Capcha_ID"] == null).toList();
          for (var dt in arr) {
            initTree(tbs, dt);
            dt["open"] = true;
            dt["chon"] = false;
            dt["Name"] = dt["Name"].toString().trim().replaceAll("&nbsp;", "");
          }
          foldes.value = arr;
        }
      }
      isloadding.value = false;
    } catch (e) {
      isloadding.value = false;
      if (kDebugMode) {
        print(e);
      }
    }
  }

  void dequyChon(fd, vl) {
    if (fd["hasChild"] == true) {
      for (var fd1 in fd["Childs"]) {
        dequyChon(fd1, vl);
      }
    }
    fd["chon"] = vl;
  }

  void toogleFolder(fd) {
    fd["open"] = !fd["open"];
    foldes.refresh();
  }

  void resetChon() {
    for (var fd in foldes) {
      dequyChon(fd, false);
    }
  }

  void toogleChon(fd, bool isOne) {
    if (isOne) resetChon();
    fd["chon"] = !fd["chon"];
    if (!isOne) {
      dequyChon(fd, fd["chon"]);
    }
    foldes.refresh();
  }

  void setChon(bool isOne, fd, vl) {
    if (isOne) resetChon();
    fd["chon"] = vl;
    if (!isOne) {
      dequyChon(fd, fd["chon"]);
    }
    foldes.refresh();
  }

  initTree(List<dynamic> tbs, obj) {
    var dts = tbs
        .where((element) => element["Capcha_ID"] == obj["Folder_ID"])
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
    obj["Name"] = obj["Name"].toString().trim().replaceAll("&nbsp;", "");
  }

  void getdqChon(List chons, fd) {
    if (fd["chon"] == true) {
      chons.add(fd["Folder_ID"]);
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
    for (var fd in foldes) {
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
    initFolder();
  }
}
