// ignore_for_file: unnecessary_null_comparison

import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:soe/utils/golbal/golbal.dart';

class ChatCardController extends GetxController {
  var datas = [].obs;
  final searchController = TextEditingController();
  RxBool loading = true.obs;

  void onSearch(txt) {
    searchController.text = txt;
    initData(true);
  }

  @override
  void onInit() {
    super.onInit();
    if (datas.isEmpty) {
      initData(true);
    }
  }

  void initData(f) async {
    try {
      if (f) {
        loading.value = true;
      }
      var body = {
        "user_id": Golbal.store.user["user_id"],
        "s": searchController.text
      };
      Dio dio = Dio();
      dio.options.headers["Authorization"] = "Bearer ${Golbal.store.token}";
      dio.options.followRedirects = true;
      var response = await dio.post(
          "${Golbal.congty!.api}/api/Chat/Get_ChatListByUser",
          data: body);
      var data = response.data;
      if (data != null) {
        var tbs = json.decode(data["data"]);
        if (tbs.length > 0) {
          for (var c in tbs) {
            if (c["ngayGui"] != null) {
              c["ngayGui"] = Golbal.timeAgo(c["ngayGui"]);
            }
            if (c["me"] != null) {
              c["me"] = json.decode(c["me"]);
              if (c["me"] != null && c["me"].length > 0) {
                for (var i = 0; i < c["me"].length; i++) {
                  if (c["me"][i]["baoTinNhan"] == "true") {
                    c["me"][i]["baoTinNhan"] = true;
                  } else {
                    c["me"][i]["baoTinNhan"] = false;
                  }
                }
              } else {
                c["me"] = [];
              }
            }
            if (c["members"] != null) {
              c["members"] = json.decode(c["members"]);
            }
          }
          datas.value = tbs;
        } else {
          datas.value = [];
        }
      }
      loading.value = false;
    } catch (e) {
      loading.value = false;
      EasyLoading.showError("Có lỗi xảy ra!");
      if (kDebugMode) {
        print(e);
      }
    }
  }
}
