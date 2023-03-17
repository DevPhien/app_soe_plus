import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:soe/utils/golbal/golbal.dart';
import 'package:soe/views/task/comp/hometask/detail/detailtaskcontroller.dart';
import 'package:soe/views/task/controller/taskcontroller.dart';

class SubTaskController extends GetxController {
  final TaskController taskcontroller = Get.put(TaskController());
  ScrollController scrollController = ScrollController();
  //Declảe
  var loading = true.obs;
  var task = {}.obs;
  var datas = [].obs;

  //Function
  Future<void> addTask({String? parentID}) async {
    var rs = await Get.toNamed("addtask", arguments: {
      "title": "Thêm công việc",
      "ParentID": parentID,
      "dictionarys": taskcontroller.dictionarys,
      "duans": taskcontroller.duans,
    });
    if (rs == true) {
      initData();
    }
  }

  Future<void> goTask(task) async {
    Get.delete<ChitietTaskController>();
    var rs = await Get.toNamed("detailtask", arguments: task);
    if (rs != null && rs["task"] != null) {
      if (rs["isdel"] == true) {
        int idx = datas
            .indexWhere((e) => e["CongviecID"] == rs["task"]["CongviecID"]);
        if (idx != -1) {
          datas.removeAt(idx);
          EasyLoading.showSuccess("Xóa thành công");
        }
      } else {
        int idx = datas
            .indexWhere((e) => e["CongviecID"] == rs["task"]["CongviecID"]);
        if (idx != -1) {
          datas[idx] = rs["task"];
        }
      }
    }
    return;
  }

  //init
  @override
  void onInit() {
    super.onInit();
    task.value = Get.arguments;
    initData();
  }

  void initData() async {
    try {
      loading.value = true;
      EasyLoading.show(status: "loading...");
      Dio dio = Dio();
      dio.options.headers["Authorization"] = "Bearer ${Golbal.store.token}";
      dio.options.followRedirects = true;
      var response = await dio.post(
        "${Golbal.congty!.api}/api/Task/Get_SubTask",
        data: {
          "user_id": Golbal.store.user["user_id"],
          "CongviecID": task["CongviecID"],
        },
      );
      var data = response.data;
      loading.value = false;
      if (data["err"] == 1) {
        EasyLoading.showError("Có lỗi xảy ra, vui lòng thử lại");
      }
      if (data != null) {
        var tbs = List.castFrom(json.decode(data["data"]));
        if (tbs[0].isNotEmpty) {
          datas.value = tbs[0];
          for (var element in tbs[0]) {
            if (element["anhThumb"] != null) {
              element["anhThumb"] =
                  Golbal.congty!.fileurl + element["anhThumb"];
            }
            if (element["Thanhviens"] != null) {
              element["Thanhviens"] = json.decode(element["Thanhviens"]);
            }
          }
        }
      }
      EasyLoading.dismiss();
    } catch (e) {
      loading.value = false;
      EasyLoading.dismiss();
      if (kDebugMode) {
        print(e);
      }
    }
  }
}
