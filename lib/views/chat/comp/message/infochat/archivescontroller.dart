import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:soe/utils/golbal/golbal.dart';

class ArchivesController extends GetxController {
  ScrollController scrollController = ScrollController();
  final searchController = TextEditingController();
  //Declare
  var loading = true.obs;
  var loadingmore = false;
  var lastdata = false.obs;
  var showFab = true.obs;
  var getdata = {}.obs;
  var datas = [].obs;
  //Rx<dynamic> files = Rx<dynamic>([]);
  var countdata = 0.obs;

  Map<String, dynamic> options = {
    "p": 1,
    "pz": 20,
    "s": null,
  };

  //Function
  Future<void> onLoadmore() {
    if (loadingmore || lastdata.value == true) return Future.value(null);
    loadingmore = true;
    options["p"] = int.parse(options["p"].toString()) + 1;
    EasyLoading.show(
      status: "Đang tải trang ${options["p"]}",
    );
    initData(false);
    return Future.value(null);
  }

  void search(String s) {
    loading.value = true;
    datas.clear();
    options["s"] = s;
    options["p"] = 1;
    initData(true);
  }

  //Init
  @override
  void onInit() {
    super.onInit();
    getdata.value = Get.arguments;
    initData(true);
  }

  void initData(f) async {
    loading.value = true;
    try {
      var body = {
        "user_id": Golbal.store.user["user_id"],
        "ChatID": getdata["ChatID"],
        "p": options["p"],
        "pz": options["pz"],
        "s": options["s"],
      };
      Dio dio = Dio();
      dio.options.headers["Authorization"] = "Bearer ${Golbal.store.token}";
      dio.options.followRedirects = true;
      var response = await dio
          .post("${Golbal.congty!.api}/api/Chat/Get_ChatFile", data: body);
      var data = response.data;
      loading.value = false;
      if (data["err"] == "1") {
        EasyLoading.showError("Có lỗi xảy ra, vui lòng thử lại!");
        return;
      }
      if (data != null) {
        var tbs = List.castFrom(json.decode(data["data"]));
        if (tbs[0].isNotEmpty) {
          if (f) {
            datas.value = tbs[0];
            if (datas.isNotEmpty) {
              for (var d in datas) {
                if (d["files"] != null) {
                  d["files"] = json.decode(d["files"]);
                  if (d["files"] != null && d["files"] != "") {
                    for (var f in d["files"]) {
                      if (f["IsImage"] == "1") {
                        f["IsImage"] = true;
                      } else {
                        f["IsImage"] = false;
                      }
                    }
                  }
                }
              }
            }
          } else {
            datas.addAll(tbs[0]);
          }
        } else {
          if (loadingmore) {
            lastdata.value = true;
            EasyLoading.showToast("Bạn đã xem hết tài liệu rồi!");
          } else {
            datas.value = [];
          }
        }
        if (tbs[1].isNotEmpty) {
          countdata.value = tbs[1][0]["c"];
        }
        if (loadingmore) {
          loadingmore = false;
        }
      }
    } catch (e) {
      loading.value = false;
      if (kDebugMode) {
        print(e);
      }
    }
  }
}
