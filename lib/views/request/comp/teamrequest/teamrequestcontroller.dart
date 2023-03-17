import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:soe/utils/golbal/golbal.dart';

class TeamRequestController extends GetxController {
  ScrollController scrollController = ScrollController();
  //Declare
  var loading = true.obs;
  var index = 1.obs;
  var isGrid = true.obs;
  var isCty = false.obs;
  var isAllCty = false.obs;
  var trangthais = [].obs;
  var trangthaiDis = [].obs;
  var countRequest = {}.obs;
  var countRequestDi = {}.obs;
  var teams = [].obs;
  var soCV = 0.obs;
  var countTV = 0.obs;
  var tiendoTV = (0).obs;
  var members = [].obs;

  //Function
  void setIndexCongviec(idx) {
    index.value = idx;
  }

  Future<void> goMember(context, r) async {
    r ??= {
      "ten": "tất cả thành viên",
      "NhanSu_ID": members.map((e) => e["NhanSu_ID"]).toList().join(",")
    };
    var rs = Get.toNamed("requestmember", arguments: r);
    // var rs = await Navigator.of(context).push(MaterialPageRoute(
    //     builder: (BuildContext context) {
    //       return RequestThanhVienPage(r);
    //     },
    //     fullscreenDialog: true));
    // if (rs == true) {
    //   listMember();
    // }
  }

  void setGrid() {
    isGrid.value = !(isGrid.value);
  }

  //init
  @override
  void onInit() {
    super.onInit();
    initData();
  }

  void initData() {
    initCountRequest();
    listMember();
  }

  void initCountRequest() async {
    try {
      loading.value = true;
      var body = {
        "user_id": Golbal.store.user["user_id"],
      };
      String url = "Request/Get_ThongkeCount";
      Dio dio = Dio();
      dio.options.headers["Authorization"] = "Bearer ${Golbal.store.token}";
      dio.options.followRedirects = true;
      var response =
          await dio.post("${Golbal.congty!.api}/api/$url", data: body);
      var data = response.data;
      loading.value = false;
      if (data["err"] == "1") {
        EasyLoading.showError("Có lỗi xảy ra, vui lòng thử lại");
        return;
      }
      if (data != null) {
        var tbs = List.castFrom(json.decode(data["data"]));
        trangthais.value =
            List.castFrom(tbs[0]).where((e) => e["type"] == 0).toList();
        trangthaiDis.value =
            List.castFrom(tbs[0]).where((e) => e["type"] == 1).toList();
        for (var e in trangthais) {
          countRequest[e["Trangthai"].toString()] = e["count"];
        }
        for (var e in trangthaiDis) {
          countRequestDi[e["Trangthai"].toString()] = e["count"];
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  void listMember() async {
    try {
      var body = {
        "user_id": Golbal.store.user["user_id"],
      };
      String url = "Request/Get_MemberByUser";
      Dio dio = Dio();
      dio.options.headers["Authorization"] = "Bearer ${Golbal.store.token}";
      dio.options.followRedirects = true;
      var response =
          await dio.post("${Golbal.congty!.api}/api/$url", data: body);
      var data = response.data;
      if (data["err"] == "1") {
        EasyLoading.showError("Có lỗi xảy ra, vui lòng thử lại");
        return;
      }
      if (data != null) {
        var tbs = List.castFrom(json.decode(data["data"]));
        countTV.value = tbs[0][0]["soUser"] ?? 0;
        soCV.value = tbs[0][0]["soRQ"] ?? 0;
        if (tbs[0][0]["Tiendo"] != null) {
          tiendoTV.value =
              double.tryParse(tbs[0][0]["Tiendo"].toString())!.ceil();
        } else {
          tiendoTV.value = 0;
        }
        tbs[1].forEach((e) {
          if (e["Thanhviens"] != null) {
            e["Thanhviens"] = json.decode(e["Thanhviens"]);
          }
        });
        members.value = tbs[2];
        teams.value = tbs[1];
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }
}
