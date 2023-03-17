import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:soe/utils/golbal/golbal.dart';

class HomeThongBaoController extends GetxController {
  var datas = [].obs;
  RxInt pageIndex = 0.obs;
  @override
  void onInit() {
    super.onInit();
    initData();
  }

  void goDetailThongbao(tb) {
    Get.toNamed("/detailthongbao", arguments: tb);
  }

  initData() async {
    try {
      var body = {"user_id": Golbal.store.user["user_id"], "top": 3};
      Dio dio = Dio();
      dio.options.headers["Authorization"] = "Bearer ${Golbal.store.token}";
      dio.options.followRedirects = true;
      var response = await dio.post(
          "${Golbal.congty!.api}/api/HomeApp/GetListTopNotify",
          data: body);
      var data = response.data;
      if (data != null) {
        var tbs = json.decode(data["data"]);
        if (tbs.length > 0) {
          datas.value = tbs;
        }
      }
    } catch (e) {}
  }
}
