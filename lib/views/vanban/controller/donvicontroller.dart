import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:soe/views/vanban/controller/chitietvanbancontroller.dart';

import '../../../utils/golbal/golbal.dart';

class DonviController extends GetxController {
  var donvis = [].obs;
  var groups = [].obs;
  var tbs = [];
  bool isSearch = false;
  RxInt isChon = 0.obs;
  RxBool isloadding = true.obs;
  final ChitietVanbanController controller = Get.put(ChitietVanbanController());
  initDonvi() async {
    try {
      Dio dio = Dio();
      dio.options.headers["Authorization"] = "Bearer ${Golbal.store.token}";
      dio.options.followRedirects = true;
      var body = {"user_id": Golbal.store.user["user_id"]};
      var response = await dio.post(
          "${Golbal.congty!.api}/api/Doc/GetListOrgGroupPublish",
          data: body);
      var data = response.data;
      if (data != null) {
        tbs = List.castFrom(json.decode(data["data"]));
        if (tbs.isNotEmpty) {
          donvis.value = tbs[0];
          for (var g in tbs[1]) {
            if (g["nguoichucnangs"] != null) {
              g["nguoichucnangs"] = json.decode(g["nguoichucnangs"]);
            }
          }
          groups.value = tbs[1];
          isloadding.value = false;
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  void onChangeDonvi(one, u, vl) {
    var idx =
        donvis.indexWhere((element) => element["Congty_ID"] == u["Congty_ID"]);
    if (idx != -1) {
      donvis[idx]["chon"] = vl;
      donvis.refresh();
    }
    if (one) {
      donvis.refresh();
      Get.back(result: [u]);
    } else {
      onChonDonvi(false);
    }
  }

  void onChonDonvi(f) {
    var chons = [];
    donvis.where((p0) => p0["chon"] == true).forEach((element) {
      if (f == true) {
        element["chon"] = false;
      }
      if (chons.indexWhere((u) => u["Congty_ID"] == element["Congty_ID"]) ==
          -1) {
        chons.add(element);
      }
    });
    if (f == true) {
      isChon.value = 0;
      Get.back(result: chons);
    } else {
      isChon.value = chons.length;
    }
  }

  //
  void onChangeGroup(one, u, vl) {
    var idx = groups.indexWhere(
        (element) => element["NhomChucnang_ID"] == u["NhomChucnang_ID"]);
    if (idx != -1) {
      groups[idx]["chon"] = vl;
      groups.refresh();
    }
    if (one) {
      groups.refresh();
      Get.back(result: [u]);
    } else {
      onChonGroup(false);
    }
  }

  void onChonGroup(f) {
    var chons = [];
    groups.where((p0) => p0["chon"] == true).forEach((element) {
      if (f == true) {
        element["chon"] = false;
      }
      if (chons.indexWhere(
              (u) => u["NhomChucnang_ID"] == element["NhomChucnang_ID"]) ==
          -1) {
        chons.add(element);
      }
    });
    if (f == true) {
      isChon.value = 0;
      Get.back(result: chons);
    } else {
      isChon.value = chons.length;
    }
  }

  void search(String s) {
    //NhomChucnang_Ten
  }
  closeGroup() {
    if (isSearch) {
      groups.value = tbs[1];
      isSearch = false;
    }
  }

  void searchGroup(String? s) {
    isloadding.value = true;
    if (s == null || s == "") {
      groups.value = tbs[1];
      isSearch = false;
    } else {
      isSearch = true;
      s = s.toLowerCase();
      groups.value = tbs[1]
          .where((element) => element["NhomChucnang_Ten"]
              .toString()
              .toLowerCase()
              .contains(s ?? ""))
          .toList();
    }
    isloadding.value = false;
  }

  closeDonvi() {
    if (isSearch) {
      donvis.value = tbs[0];
      isSearch = false;
    }
  }

  void searchDonvi(String? s) {
    isloadding.value = true;
    if (s == null || s == "") {
      donvis.value = tbs[0];
      isSearch = false;
    } else {
      isSearch = true;
      s = s.toLowerCase();
      donvis.value = tbs[0]
          .where((element) =>
              element["tenCongty"].toString().toLowerCase().contains(s ?? ""))
          .toList();
    }
    isloadding.value = false;
  }

  @override
  void onInit() {
    super.onInit();
    initDonvi();
  }
}
