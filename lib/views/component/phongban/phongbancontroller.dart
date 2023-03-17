import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import '../../../utils/golbal/golbal.dart';

class PhongbanController extends GetxController {
  var phongbans = [].obs;
  var groupphongbans = [].obs;
  var dtphongbans = [];
  var dtgroupphongbans = [];
  bool isSearch = false;
  RxInt isChon = 0.obs;
  RxBool isloadding = true.obs;
  RxBool isloaddingGroup = true.obs;
  String s = "";

  initPhongban() async {
    try {
      Dio dio = Dio();
      dio.options.headers["Authorization"] = "Bearer ${Golbal.store.token}";
      dio.options.followRedirects = true;
      var body = {"user_id": Golbal.store.user["user_id"]};
      var response = await dio
          .post("${Golbal.congty!.api}/api/HomeApi/Get_Phongbans", data: body);
      var data = response.data;
      if (data != null) {
        var tbs = List.castFrom(json.decode(data["data"]));
        if (tbs.isNotEmpty) {
          dtphongbans = tbs[0];
          phongbans.value = tbs[0];
          dtgroupphongbans = tbs[0];
          groupphongbans.value = tbs[0];
          isloadding.value = false;
          isloaddingGroup.value = false;
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  void onChangePhongban(one, u, vl) {
    var idx = phongbans
        .indexWhere((element) => element["Phongban_ID"] == u["Phongban_ID"]);
    if (idx != -1) {
      phongbans[idx]["chon"] = vl;
      phongbans.refresh();
    }
    if (one) {
      phongbans.refresh();
      Get.back(result: [u]);
    } else {
      onChonPhongban(false);
    }
  }

  void onChangePhongbanGroup(one, u, vl) {
    var idx = groupphongbans
        .indexWhere((element) => element["Phongban_ID"] == u["Phongban_ID"]);
    if (idx != -1) {
      groupphongbans[idx]["chon"] = vl;
      groupphongbans.refresh();
    }
    if (one) {
      phongbans.refresh();
      Get.back(result: [u]);
    } else {
      onChonPhongban(false);
    }
  }

  void onChonPhongban(f) {
    var chons = [];
    phongbans.where((p0) => p0["chon"] == true).forEach((element) {
      if (f == true) {
        element["chon"] = false;
      }
      if (chons.indexWhere((u) => u["Phongban_ID"] == element["Phongban_ID"]) ==
          -1) {
        chons.add(element);
      }
    });
    groupphongbans.where((p0) => p0["chon"] == true).forEach((element) {
      if (f == true) {
        element["chon"] = false;
      }
      if (chons.indexWhere((u) => u["Phongban_ID"] == element["Phongban_ID"]) ==
          -1) {
        chons.add(element);
      }
    });
    if (f == true) {
      isChon.value = 0;
      closePhongban();
      Get.back(result: chons);
    } else {
      isChon.value = chons.length;
    }
  }

  closePhongban() {
    if (isSearch) {
      phongbans.value = dtphongbans;
      groupphongbans.value = dtgroupphongbans;
      isSearch = false;
    }
  }

  void search({String? ss}) {
    if (ss != null) {
      s = ss;
    }
    isloadding.value = true;
    if (s == "") {
      phongbans.value = dtphongbans;
      groupphongbans.value = dtgroupphongbans;
      isSearch = false;
    } else {
      isSearch = true;
      s = s.toLowerCase();
      phongbans.value = dtphongbans
          .where((element) =>
              element["Phongban_ID"].toString().contains(s) ||
              element["tenPhongban"].toString().toLowerCase().contains(s))
          .toList();
      groupphongbans.value = dtgroupphongbans
          .where((element) =>
              element["Phongban_ID"].toString().contains(s) ||
              element["tenPhongban"].toString().toLowerCase().contains(s))
          .toList();
    }
    isloadding.value = false;
  }

  @override
  void onInit() {
    super.onInit();
    initPhongban();
  }
}
