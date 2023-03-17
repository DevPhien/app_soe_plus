import 'dart:convert';

import 'package:diacritic/diacritic.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import '../../../../utils/golbal/golbal.dart';

class CaymohinhController extends GetxController {
  var mohinhs = [].obs;
  var dtmohinhs = [];
  RxBool isloadding = true.obs;
  String s = "";
  initData() async {
    try {
      Dio dio = Dio();
      dio.options.headers["Authorization"] = "Bearer ${Golbal.store.token}";
      dio.options.followRedirects = true;
      var body = {"user_id": Golbal.store.user["user_id"]};
      var response = await dio
          .post("${Golbal.congty!.api}/api/Task/Get_Mohinhtochuc", data: body);
      var data = response.data;
      if (data != null) {
        var tbs = List.castFrom(json.decode(data["data"]));
        if (tbs.isNotEmpty) {
          for (var u in tbs[1]) {
            u["tenPhongbanen"] = removeDiacritics(u["tenPhongban"]);
            var cty = List.castFrom(tbs[0]).firstWhereOrNull(
                (element) => element["Congty_ID"] == u["Congty_ID"]);
            u["tenCongty"] = cty["tenCongty"];
            u["thutuCongty"] = cty["Parent_ID"] == null ? -1 : cty["thutu"];
          }
          dtmohinhs = tbs[1];
          mohinhs.value = tbs[1];
          isloadding.value = false;
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  void search({String? ss}) {
    if (ss != null) {
      s = ss;
    }
    isloadding.value = true;
    if (s == "") {
      mohinhs.value = dtmohinhs;
    } else {
      s = s.toLowerCase();
      mohinhs.value = dtmohinhs
          .where((element) =>
              element["tenPhongban"].toString().toLowerCase().contains(s) ||
              element["tenPhongbanen"].toString().toLowerCase().contains(s))
          .toList();
    }
    isloadding.value = false;
  }

  void chonPB(item) {
    int idx = mohinhs
        .indexWhere((element) => element["Phongban_ID"] == item["Phongban_ID"]);
    if (idx != -1) {
      //mohinhs[idx]['chon'] = !(mohinhs[idx]['chon'] ?? false);
      //mohinhs.refresh();
      Get.back(result: item);
    }
  }

  @override
  void onInit() {
    super.onInit();
    initData();
  }
}
