import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:soe/utils/golbal/golbal.dart';

class RequestMemberController extends GetxController {
  ScrollController scrollController = ScrollController();
  final searchController = TextEditingController();
  //Declare
  var loading = true.obs;
  var loaddingmore = false;
  var lastdata = false.obs;
  var showFab = false.obs;
  var user = {}.obs;
  var datas = [].obs;
  var countdata = 0.obs;

  Map<String, dynamic> options = {
    "p": 1,
    "pz": 20,
    "s": null,
    "sort": 7,
    "Trangthai": 7,
    "start_date": null,
    "end_date": null,
    "start_finishdate": null,
    "end_finishdate": null,
    "IsIn": true,
    "IsOut": false,
    "IsMe": false,
    "IsQH": -1,
    "IsStatus": -100,
    "congtys": null,
    "teams": null,
    "forms": null,
  };

  //Function
  Future<void> onLoadmore() {
    if (loaddingmore || lastdata.value == true) return Future.value(null);
    loaddingmore = true;
    options["p"] = int.parse(options["p"].toString()) + 1;
    EasyLoading.show(
      status: "Đang tải trang ${options["p"]}",
    );
    initRequest(false);
    return Future.value(null);
  }

  void search(String s) {
    loading.value = true;
    datas.clear();
    options["s"] = s;
    options["p"] = 1;
    initRequest(false);
  }

  //init
  @override
  void onInit() {
    super.onInit();
    user.value = Get.arguments;
    initData();
  }

  void initData() {
    initRequest(true);
  }

  void initRequest(f) async {
    try {
      if (f) {
        loading.value = true;
      }
      var body = {
        "user_id": user["NhanSu_ID"],
        "p": options["p"],
        "pz": options["pz"],
        "s": options["s"],
        "sort": options["sort"],
        "Trangthai": options["Trangthai"],
        "start_date": options["start_date"],
        "end_date": options["end_date"],
        "IsIn": options["IsIn"],
        "IsOut": options["IsOut"],
      };
      String url = "Request/Get_RequestByUser";
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
            if (element["Tiendo"] == null) {
              element["Tiendo"] = 0.0;
            }
            List users = [];
            if (element["Thanhviens"] != null) {
              element["Thanhviens"] = json.decode(element["Thanhviens"]);
              users = element["Thanhviens"];
            }
            if (element["Signs"] != null) {
              element["Signs"] = json.decode(element["Signs"]);
              element["Signs"].forEach((si) {
                si["users"] = users
                    .where((e) => e["RequestSign_ID"] == si["RequestSign_ID"])
                    .toList();
                if (si["IsTypeDuyet"] == "0") {
                  si["users"] =
                      si["users"].where((e) => e["IsSign"] != "0").toList();
                  int len = si["users"]
                      .where((e) => e["IsSign"] != "0" && e["IsType"] != "4")
                      .toList()
                      .length;
                  if (len == 0) {
                    si["users"] = users
                        .where(
                            (e) => e["RequestSign_ID"] == si["RequestSign_ID"])
                        .toList();
                  }
                }
              });
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
            EasyLoading.showToast("Bạn đã xem hết đề xuất rồi!");
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
        EasyLoading.showToast("Bạn đã xem hết đề xuất rồi!");
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
}
