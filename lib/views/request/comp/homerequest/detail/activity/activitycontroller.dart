import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:soe/utils/golbal/golbal.dart';

class ActivityController extends GetxController {
  //Declare
  var request = {}.obs;
  var loading = true.obs;
  var charts = [].obs;
  var logs = [].obs;
  var views = [].obs;

  //Function

  //Init
  @override
  void onInit() {
    super.onInit();
    request.value = Get.arguments;
    initData();
  }

  void initData() {
    initLog();
    initView();
  }

  void initLog() async {
    try {
      loading.value = true;
      var body = {
        "user_id": Golbal.store.user["user_id"],
        "RequestMaster_ID": request["RequestMaster_ID"],
      };
      String url = "Request/Get_ListLog";
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
        tbs[0].forEach((r) {
          r["Thanhviens"] = tbs[1]
              .where((e) => e["RequestSign_ID"] == r["RequestSign_ID"])
              .toList();
          if (r["IsTypeDuyet"] == 0) {
            r["USign"] =
                r["Thanhviens"].where((x) => x["IsSign"] != 0).toList();
            r["Thanhviens"] =
                r["Thanhviens"].where((x) => x["IsSign"] == 0).toList();
          }
          var tvs = r["Thanhviens"]
              .where((u) => !u["IsClose"] || u["IsSign"] != 0)
              .toList();
          r["SoThanhvien"] = tvs.length;
        });
        if (tbs[0].isEmpty && tbs[1].isNotEmpty) {
          var r = {
            "GroupName": "Quy trình động",
            "IsTypeDuyet": request["IsQuytrinhduyet"]
          };
          r["Thanhviens"] = tbs[1]
              .where((x) => x["RequestSign_ID"] == null && x["IsType"] == 5);
          if (r["IsTypeDuyet"].toString() == "0") {
            //Duyệt 1 trong nhiều
            r["USign"] =
                r["Thanhviens"].where((x) => x["IsSign"] != 0).toList();
            r["Thanhviens"] =
                r["Thanhviens"].where((x) => x["IsSign"] == 0).toList();
          }
          var tvs = r["Thanhviens"]
              .where((u) => !u["IsClose"] || u["IsSign"] != 0)
              .toList();
          r["SoThanhvien"] = tvs.length;
          tbs[0] = [r];
        }

        charts.value = List.castFrom(tbs[0]);
        //signs = tbs[1];
        logs.value = List.castFrom(tbs[2]);
        //thanhviens = tbs[3];
        //theodois = tbs[4];
      }
    } catch (e) {
      loading.value = false;
      EasyLoading.showError("Có lỗi xảy ra");
      if (kDebugMode) {
        print(e);
      }
    }
  }

  void initView() async {
    try {
      var body = {
        "user_id": Golbal.store.user["user_id"],
        "RequestMaster_ID": request["RequestMaster_ID"],
      };
      String url = "Request/Get_ViewUser";
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
      var tbs = List.castFrom(json.decode(data["data"]));
      views.value = tbs[0];
    } catch (e) {
      EasyLoading.showError("Có lỗi xảy ra");
      if (kDebugMode) {
        print(e);
      }
    }
  }
}
