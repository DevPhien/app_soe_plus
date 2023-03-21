import 'dart:convert';

import 'package:diacritic/diacritic.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import '../../../utils/golbal/golbal.dart';

class UserVBController extends GetxController {
  var users = [].obs;
  var tempusers = [].obs;
  var groupusers = [].obs;
  var tempgroupusers = [].obs;
  var dtusers = [];
  var dtgroupusers = [];
  bool isSearch = false;
  RxInt isChon = 0.obs;
  RxBool isloadding = true.obs;
  RxBool isloaddingGroup = true.obs;
  String s = "";
  initUser() async {
    try {
      Dio dio = Dio();
      dio.options.headers["Authorization"] = "Bearer ${Golbal.store.token}";
      dio.options.followRedirects = true;
      var body = {"user_id": Golbal.store.user["user_id"]};
      var response = await dio
          .post("${Golbal.congty!.api}/api/Doc/GetListDefaultUser", data: body);
      var data = response.data;
      if (data != null) {
        var tbs = List.castFrom(json.decode(data["data"]));
        if (tbs.isNotEmpty) {
          for (var u in tbs) {
            u["fullNameen"] = removeDiacritics(u["fullName"]);
          }
          dtusers = tbs;
          users.value = tbs;
          tempusers.value = tbs;
          isloadding.value = false;
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  initGroupUser() async {
    try {
      Dio dio = Dio();
      dio.options.headers["Authorization"] = "Bearer ${Golbal.store.token}";
      dio.options.followRedirects = true;
      var body = {"user_id": Golbal.store.user["user_id"]};
      var response = await dio
          .post("${Golbal.congty!.api}/api/Doc/GetListGroupUser", data: body);
      var data = response.data;
      if (data != null) {
        var tbs = List.castFrom(json.decode(data["data"]));
        if (tbs.isNotEmpty) {
          for (var u in tbs) {
            u["fullNameen"] = removeDiacritics(u["fullName"]);
          }
          dtgroupusers = tbs;
          groupusers.value = tbs;
          tempgroupusers.value = tbs;
          isloaddingGroup.value = false;
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  void onChangeUser(one, u, vl) {
    var idx =
        users.indexWhere((element) => element["NhanSu_ID"] == u["NhanSu_ID"]);
    if (idx != -1) {
      users[idx]["chon"] = vl;
      users.refresh();
    }
    var idx2 =
        users.indexWhere((element) => element["NhanSu_ID"] == u["NhanSu_ID"]);
    if (idx2 != -1) {
      tempusers[idx2]["chon"] = vl;
      tempusers.refresh();
    }
    if (one) {
      users.refresh();
      groupusers.refresh();
      //tempusers.refresh();
      Get.back(result: [u]);
    } else {
      onChonUser(false);
    }
  }

  void onChangeUserGroup(one, u, vl) {
    var idx = groupusers
        .indexWhere((element) => element["NhanSu_ID"] == u["NhanSu_ID"]);
    if (idx != -1) {
      groupusers[idx]["chon"] = vl;
      groupusers.refresh();
    }
    var idx2 = tempgroupusers
        .indexWhere((element) => element["NhanSu_ID"] == u["NhanSu_ID"]);
    if (idx2 != -1) {
      tempgroupusers[idx2]["chon"] = vl;
      tempgroupusers.refresh();
    }
    if (one) {
      users.refresh();
      groupusers.refresh();
      //tempusers.refresh();
      Get.back(result: [u]);
    } else {
      onChonUser(false);
    }
  }

  void onChonUser(f) {
    var chons = [];
    users.where((p0) => p0["chon"] == true).forEach((element) {
      if (f == true) {
        element["chon"] = false;
      }
      if (chons.indexWhere((u) => u["NhanSu_ID"] == element["NhanSu_ID"]) ==
          -1) {
        chons.add(element);
      }
    });
    groupusers.where((p0) => p0["chon"] == true).forEach((element) {
      if (f == true) {
        element["chon"] = false;
      }
      if (chons.indexWhere((u) => u["NhanSu_ID"] == element["NhanSu_ID"]) ==
          -1) {
        chons.add(element);
      }
    });
    tempusers.where((p0) => p0["chon"] == true).forEach((element) {
      if (f == true) {
        element["chon"] = false;
      }
      if (chons.indexWhere((u) => u["NhanSu_ID"] == element["NhanSu_ID"]) ==
          -1) {
        chons.add(element);
      }
    });
    tempgroupusers.where((p0) => p0["chon"] == true).forEach((element) {
      if (f == true) {
        element["chon"] = false;
      }
      if (chons.indexWhere((u) => u["NhanSu_ID"] == element["NhanSu_ID"]) ==
          -1) {
        chons.add(element);
      }
    });
    if (f == true) {
      isChon.value = 0;
      closeUser();
      Get.back(result: chons);
    } else {
      isChon.value = chons.length;
    }
  }

  closeUser() {
    if (isSearch) {
      users.value = dtusers;
      groupusers.value = dtgroupusers;
      isSearch = false;
    }
  }

  void search({String? ss}) {
    if (ss != null) {
      s = ss;
    }
    isloadding.value = true;
    if (s == "") {
      users.value = dtusers;
      groupusers.value = dtgroupusers;
      isSearch = false;
    } else {
      isSearch = true;
      s = s.toLowerCase();
      users.value = dtusers
          .where((element) =>
              element["NhanSu_ID"].toString().contains(s) ||
              element["fullName"].toString().toLowerCase().contains(s) ||
              element["fullNameen"].toString().toLowerCase().contains(s))
          .toList();
      groupusers.value = dtgroupusers
          .where((element) =>
              element["NhanSu_ID"].toString().contains(s) ||
              element["fullName"].toString().toLowerCase().contains(s) ||
              element["fullNameen"].toString().toLowerCase().contains(s))
          .toList();
    }
    isloadding.value = false;
  }

  @override
  void onInit() {
    super.onInit();
    initUser();
    initGroupUser();
  }
}
