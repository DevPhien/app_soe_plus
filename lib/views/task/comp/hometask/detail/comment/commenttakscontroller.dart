import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import '../../../../../../utils/golbal/golbal.dart';
import '../detailtaskcontroller.dart';

class CommentTaskController extends GetxController {
  final ChitietTaskController controller = Get.put(ChitietTaskController());
  var isloadding = true.obs;
  var comments = [].obs;
  initData(String congviecID, bool f) async {
    try {
      Dio dio = Dio();
      dio.options.headers["Authorization"] = "Bearer ${Golbal.store.token}";
      dio.options.followRedirects = true;
      var response = await dio
          .post("${Golbal.congty!.api}/api/Task/Get_CommentByTask", data: {
        "user_id": Golbal.store.user["user_id"],
        "congviec_id": congviecID,
        "p": 1,
        "pz": 1000,
        "s": "",
      });
      var data = response.data;
      if (data != null) {
        var tbs = List.castFrom(json.decode(data["data"]));
        for (var tb in tbs) {
          if (tb["files"] != null) {
            tb["files"] =
                json.decode(tb["files"].toString().replaceAll('""', '"'));
          }
        }
        comments.value = tbs;
        isloadding.value = false;
        if (f == true) {
          controller.scroolBottom();
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  @override
  void onInit() {
    super.onInit();
    if (controller.task.keys.isNotEmpty &&
        controller.task["CongviecID"] != null) {
      initData(controller.task["CongviecID"], false);
    }
    Golbal.socket.on('getData', (data) {
      if (data != null &&
          data["module"] == "task" &&
          controller.task["CongviecID"] == data["CongviecID"]) {
        switch (data["type"]) {
          case 0:
            if (data["user_id"] != Golbal.store.user["user_id"]) {
              initData(controller.task["CongviecID"], true);
            }
            break;
        }
      }
    });
  }

  @override
  void onClose() {
    controller.dispose();
    super.onClose();
  }
}
