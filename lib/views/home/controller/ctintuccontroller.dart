import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:soe/utils/golbal/golbal.dart';

class HomeTintucController extends GetxController {
  var datas = [].obs;
  RxInt pageIndex = 0.obs;
  @override
  void onInit() {
    super.onInit();
    initData();
  }

  void goDetail(tb) {
    Get.toNamed("/detailtintuc", arguments: tb);
  }

  initData() async {
    try {
      var body = {"user_id": Golbal.store.user["user_id"], "top": 5};
      Dio dio = Dio();
      dio.options.headers["Authorization"] = "Bearer ${Golbal.store.token}";
      dio.options.followRedirects = true;
      var response = await dio
          .post("${Golbal.congty!.api}/api/HomeApp/GetListTopNews", data: body);
      var data = response.data;
      if (data != null) {
        var tbs = List.castFrom(json.decode(data["data"]));
        if (tbs.isNotEmpty) {
          for (var element in tbs) {
            if (element["Hinhanh"] != null) {
              element["Hinhanh"] = Golbal.congty!.fileurl + element["Hinhanh"];
            }
          }
          datas.value = tbs;
        }
      }
    } catch (e) {
      print(e);
    }
  }
}
