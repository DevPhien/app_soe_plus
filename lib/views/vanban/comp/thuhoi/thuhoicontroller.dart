import 'dart:convert';

import 'package:dio/dio.dart' as dio;
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:soe/views/vanban/controller/chitietvanbancontroller.dart';
import 'package:graphview/GraphView.dart' as gh;
import '../../../../utils/golbal/golbal.dart';

class ThuhoiVanbanController extends GetxController {
  final ChitietVanbanController controller = Get.put(ChitietVanbanController());
  var model = {};
  RxBool isloadding = true.obs;
  final gh.Graph graph = gh.Graph()..isTree = true;
  gh.BuchheimWalkerConfiguration builder = gh.BuchheimWalkerConfiguration();
  var nodeUser = [].obs;
  Future<void> submit() async {
    if (nodeUser.isEmpty) {
      EasyLoading.showError(
        "Vui lòng chọn người để thu hồi!",
      );
      return;
    }
    if (model["message"] == null || model["message"].toString().trim() == "") {
      EasyLoading.showError(
        "Vui lòng nhập nội dung thu hồi.",
      );
      return;
    }
    EasyLoading.show(
      status: "Đang gửi thu hồi văn bản ...",
    );
    var recalls = [];
    for (var nd in nodeUser) {
      recalls.add({
        "NhanSu_ID": nd["NhanSu_ID"],
        "Congty_ID": nd["Congty_ID"],
        "NhomDuyetVanBan_ID": nd["NhomDuyetVanBan_ID"],
        "vanBanMasterID": model["vanBanMasterID"],
        //Lấy từ user
        "vanBanFollow_ID": nd["vanBanFollow_ID"],
        "vanBanFollowUser_ID": nd["vanBanFollowUser_ID"],
        "vanBanXemdebietUser_ID": nd["vanBanXemdebietUser_ID"],
        "vanBanTheodoiUser_ID": nd["vanBanTheodoiUser_ID"],
      });
    }
    Map<String, dynamic> data = {
      "user_id": Golbal.store.user["user_id"],
      "recalls": recalls,
      "message": model["message"],
    };
    dio.Dio http = dio.Dio();
    http.options.headers["Authorization"] = "Bearer ${Golbal.store.token}";
    http.options.followRedirects = true;
    try {
      var response = await http.put('${Golbal.congty!.api}/api/SendDoc/Recall',
          data: data);
      EasyLoading.dismiss();
      if (response.data["err"] == "1") {
        EasyLoading.showError(response.data["err_app"] ??
            "Không thể gửi thu hồi văn bản này, vui lòng thử lại!");
      } else {
        if (response.data != null) {
          EasyLoading.showSuccess("Thu hồi văn bản thành công!");
          Get.back(result: true);
        }
      }
    } catch (e) {
      http.put('${Golbal.congty!.api}/api/Log/AddLog', data: {
        "title": "Lỗi gửi thu hồi văn bản",
        "controller": "Doc/ReturnDoc",
        "log_date": DateTime.now().toIso8601String(),
        "log_content": json.encode(data),
        "full_name": Golbal.store.user["FullName"],
        "user_id": Golbal.store.user["user_id"],
        "token_id": Golbal.store.user["Token_ID"],
        "is_type": 0,
        "module": "Doc",
      });
      EasyLoading.dismiss();
      EasyLoading.showError(
        "Không thể gửi thu hồi văn bản này, vui lòng thử lại!",
      );
    }
  }

  void addUser(u) {
    if (u["IsRoot"] == true) {
      EasyLoading.showToast(
        "Không thể gửi thu hồi văn bản từ người gửi này, vui lòng thử lại!",
      );
      return;
    } else {
      if (nodeUser.indexWhere((element) =>
              element["sender"][0]["NhanSu_ID"] ==
              u["sender"][0]["NhanSu_ID"]) ==
          -1) {
        nodeUser.add(u);
      }
    }
  }

  void deleteUser(u) {
    var idx = nodeUser.indexWhere((element) =>
        element["sender"][0]["NhanSu_ID"] == u["sender"][0]["NhanSu_ID"]);
    if (idx != -1) {
      nodeUser.removeAt(idx);
    }
  }

  Future<void> initTree() async {
    try {
      EasyLoading.show(
        status: "Đang kiểm tra văn bản ...",
      );
      Dio dio = Dio();
      dio.options.headers["Authorization"] = "Bearer ${Golbal.store.token}";
      dio.options.followRedirects = true;
      var body = {
        "recall": {
          "vanBanMasterID": model["vanBanMasterID"],
          "vanBanFollow_ID": model["vanBanFollow_ID"],
          "vanBanFollowUser_ID": model["vanBanFollowUser_ID"],
          "vanBanXemdebietUser_ID": model["vanBanXemdebietUser_ID"],
          "vanBanTheodoiUser_ID": model["vanBanTheodoiUser_ID"],
        }
      };
      var response = await dio.post(
          "${Golbal.congty!.api}/api/SendDoc/GetListTreeRecall",
          data: body);
      var data = response.data;
      EasyLoading.dismiss();
      if (data != null) {
        var tbs = List.castFrom(json.decode(data["data"]));
        if (tbs.isNotEmpty) {
          for (var element in tbs) {
            if (element["sender"] != null) {
              element["sender"] = List.castFrom(json.decode(element["sender"]));
            }
            if (element["tailieus"] != null) {
              element["tailieus"] =
                  List.castFrom(json.decode(element["tailieus"]));
            }
          }
          tbs[0]["IsRoot"] = true;
          initGraph(tbs);
        }
      }
    } catch (e) {
      EasyLoading.dismiss();
    }
  }

  void initGraph(List tbs) {
    try {
      var nodes = [];
      for (var vb in tbs) {
        nodes.add(gh.Node.Id(vb));
      }
      for (int i = 1; i <= tbs.length - 1; i++) {
        var cnode = nodes[i];
        int j = i - 1;
        while (j > 0 &&
            cnode.key!.value["CapCha_ID"] != nodes[j].key!.value["IDKey"]) {
          j--;
        }
        if (i != j) {
          nodes[j].key!.value["Noidunggui"] = nodes[i].key!.value["Noidung"];
          graph.addEdge(nodes[j], nodes[i]);
        }
      }
      builder
        ..siblingSeparation = (30)
        ..levelSeparation = (20)
        ..subtreeSeparation = (30)
        ..orientation = (gh.BuchheimWalkerConfiguration.ORIENTATION_TOP_BOTTOM);
      isloadding.value = false;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  @override
  void onInit() {
    super.onInit();
    //print(Get.arguments);
    model["vanBanMasterID"] = Get.arguments["vanBanMasterID"];
    model["vanBanFollow_ID"] = Get.arguments["vanBanFollow_ID"];
    model["vanBanFollowUser_ID"] = Get.arguments["vanBanFollowUser_ID"];
    model["vanBanXemdebietUser_ID"] = Get.arguments["vanBanXemdebietUser_ID"];
    model["vanBanTheodoiUser_ID"] = Get.arguments["vanBanTheodoiUser_ID"];
    initTree();
  }
}
