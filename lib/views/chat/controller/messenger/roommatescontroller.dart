import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:soe/utils/golbal/golbal.dart';

import '../chatcontroller.dart';

class UserRoommatesController extends GetxController {
  var datas = [].obs;
  RxBool loading = true.obs;

  final ChatController chatController = Get.put(ChatController());

  @override
  void onInit() {
    super.onInit();
    if (datas.isEmpty) {
      initData();
    }
  }

  initData() async {
    try {
      loading.value = true;
      var body = {"user_id": Golbal.store.user["user_id"]};
      Dio dio = Dio();
      dio.options.headers["Authorization"] = "Bearer ${Golbal.store.token}";
      dio.options.followRedirects = true;
      var response = await dio
          .post("${Golbal.congty!.api}/api/Chat/Get_UserRoommates", data: body);
      var data = response.data;
      if (data != null) {
        var tbs = json.decode(data["data"]);
        if (tbs.length > 0) {
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
