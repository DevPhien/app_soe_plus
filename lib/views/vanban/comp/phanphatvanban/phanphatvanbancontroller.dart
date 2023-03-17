import 'dart:convert';

import 'package:dio/dio.dart' as dio;
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:soe/views/vanban/controller/chitietvanbancontroller.dart';

import '../../../../utils/golbal/golbal.dart';
import '../../controller/donvicontroller.dart';
import '../../controller/uservanbancontroller.dart';
import '../listdonvi.dart';
import '../listgroupvanban.dart';
import '../listuser.dart';

class PhanPhatVanBanController extends GetxController {
  final ChitietVanbanController controller = Get.put(ChitietVanbanController());
  final UserVBController usercontroller = Get.put(UserVBController());
  final DonviController donvicontroller = Get.put(DonviController());
  var model = {}.obs;
  var userids = [].obs;
  var orgids = [].obs;
  var publishgroupids = [].obs;
  var butkey = "".obs;
  void resetChon(List users) {
    usercontroller.users
        .where((p0) =>
            users.indexWhere(
                (element) => element["NhanSu_ID"] == p0["NhanSu_ID"]) !=
            -1)
        .forEach((element) {
      element["chon"] = true;
    });
    usercontroller.groupusers
        .where((p0) =>
            users.indexWhere(
                (element) => element["NhanSu_ID"] == p0["NhanSu_ID"]) !=
            -1)
        .forEach((element) {
      element["chon"] = true;
    });
    usercontroller.isChon.value = users.length;
  }

  Future<void> showUser() async {
    usercontroller.users.where((p0) => p0["chon"] == true).forEach((element) {
      element["chon"] = false;
    });
    usercontroller.users.where((p0) => p0["chon"] == true).forEach((element) {
      element["chon"] = false;
    });
    usercontroller.isChon.value = 0;
    resetChon(userids);

    var rs = await showCupertinoModalBottomSheet(
      context: Get.context!,
      expand: true,
      builder: (context) => ListUserVanBan(),
    );
    if (rs != null) {
      userids.value = rs;
    }
  }

  //Đơn vị
  void resetChonDonvi(List donvis) {
    donvicontroller.donvis
        .where((p0) =>
            donvis.indexWhere(
                (element) => element["Congty_ID"] == p0["Congty_ID"]) !=
            -1)
        .forEach((element) {
      element["chon"] = true;
    });
    usercontroller.isChon.value = donvis.length;
  }

  Future<void> showDonvi() async {
    donvicontroller.donvis.where((p0) => p0["chon"] == true).forEach((element) {
      element["chon"] = false;
    });
    donvicontroller.isChon.value = 0;
    resetChonDonvi(orgids);
    var rs = await showCupertinoModalBottomSheet(
      context: Get.context!,
      expand: true,
      builder: (context) => ListDonvi(),
    );
    if (rs != null) {
      orgids.value = rs;
    }
  }

  //Group
  void resetChonGroup(List groups) {
    donvicontroller.groups
        .where((p0) =>
            groups.indexWhere((element) =>
                element["NhomChucnang_ID"] == p0["NhomChucnang_ID"]) !=
            -1)
        .forEach((element) {
      element["chon"] = true;
    });
    usercontroller.isChon.value = groups.length;
  }

  Future<void> showGroup() async {
    donvicontroller.groups.where((p0) => p0["chon"] == true).forEach((element) {
      element["chon"] = false;
    });
    donvicontroller.isChon.value = 0;
    resetChonGroup(publishgroupids);
    var rs = await showCupertinoModalBottomSheet(
      context: Get.context!,
      expand: true,
      builder: (context) => ListGroup(),
    );
    if (rs != null) {
      publishgroupids.value = rs;
    }
  }

  Future<void> submit() async {
    model["user_ids"] = userids.map((element) => element["NhanSu_ID"]).toList();
    model["org_ids"] = orgids.map((element) => element["Congty_ID"]).toList();
    model["publish_group_ids"] =
        publishgroupids.map((element) => element["NhomChucnang_ID"]).toList();

    EasyLoading.show(
      status: "Đang gửi văn bản ...",
    );
    Map<String, dynamic> mdata = {
      "doc_master_id": model["vanBanMasterID"],
      "message": model["message"],
      "follow_id": model["vanBanFollow_ID"],
      "user_id": Golbal.store.user["user_id"],
      "publish_user_id": model["publish_user_id"],
      "seetoknow_user_id": model["seetoknow_user_id"],
      "user_ids": model["user_ids"],
      "org_ids": model["org_ids"],
      "publish_group_ids": model["publish_group_ids"],
    };
    dio.Dio http = dio.Dio();
    http.options.headers["Authorization"] = "Bearer ${Golbal.store.token}";
    http.options.followRedirects = true;
    try {
      var response = await http.put('${Golbal.congty!.api}/api/Doc/PublishDoc',
          data: mdata);
      EasyLoading.dismiss();
      if (response.data["err"] == "1") {
        EasyLoading.showToast(response.data["err_app"] ??
            "Không thể phân phát văn bản này, vui lòng thử lại!");
      } else {
        if (response.data != null) {
          EasyLoading.showToast("Phân phát văn bản thành công!");
          Get.back(result: true);
        }
      }
    } catch (e) {
      http.put(Golbal.congty!.api + '/api/Log/AddLog', data: {
        "title": "Lỗi phân phát văn bản",
        "controller": "Doc/PublishDoc",
        "log_date": DateTime.now().toIso8601String(),
        "log_content": json.encode(mdata),
        "full_name": Golbal.store.user["FullName"],
        "user_id": Golbal.store.user["user_id"],
        "token_id": Golbal.store.user["Token_ID"],
        "is_type": 0,
        "module": "Doc",
      });
      EasyLoading.dismiss();
      EasyLoading.showToast(
        "Không thể phân phát bản này, vui lòng thử lại!",
      );
    }
  }

  void deleUser(int i) {
    userids.removeAt(i);
  }

  void deleDonvi(int i) {
    orgids.removeAt(i);
  }

  void deleGroup(int i) {
    publishgroupids.removeAt(i);
  }

  Future<void> openDate(String mkey) async {
    var rs = await showDatePicker(
      context: Get.context!,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2025),
    );
    if (rs != null) {
      model[mkey] = rs.toIso8601String();
    }
  }

  Future<void> initParam() async {
    try {
      EasyLoading.show(
        status: "Đang kiểm tra văn bản ...",
      );
      Dio dio = Dio();
      dio.options.headers["Authorization"] = "Bearer ${Golbal.store.token}";
      dio.options.followRedirects = true;
      var body = {
        "recall": {
          "vanBanMasterID": Get.arguments["vanBanMasterID"],
          "vanBanFollow_ID": Get.arguments["vanBanFollow_ID"],
          "vanBanFollowUser_ID": Get.arguments["vanBanFollowUser_ID"],
          "vanBanXemdebietUser_ID": Get.arguments["vanBanXemdebietUser_ID"],
          "vanBanTheodoiUser_ID": Get.arguments["vanBanTheodoiUser_ID"],
        }
      };
      var response = await dio.post(
          "${Golbal.congty!.api}/api/SendDoc/GetParamPublishSendDoc",
          data: body);
      var data = response.data;
      EasyLoading.dismiss();
      if (data != null) {
        var tbs = List.castFrom(json.decode(data["data"]));
        if (tbs.isNotEmpty) {
          model["vanBanFollow_ID"] = tbs[0]["Par_vanBanFollow_ID"];
          model["seetoknow_user_id"] = tbs[0]["Par_vanBanXemdebietUser_ID"];
          model["publish_user_id"] = tbs[0]["Par_vanBanFollowUser_ID"];
        }
      }
    } catch (e) {
      EasyLoading.showToast("Không thể thu hồi văn bản này.");
      if (kDebugMode) {
        print(e);
      }
    }
  }

  @override
  void onInit() {
    super.onInit();
    if (Get.parameters["pageIndex"] == "1") {
      model["vanBanMasterID"] = Get.arguments["vanBanMasterID"];
      model["vanBanFollow_ID"] = Get.arguments["vanBanFollow_ID"];
      model["seetoknow_user_id"] = Get.arguments["seetoknow_user_id"];
      model["publish_user_id"] = Get.arguments["publish_user_id"];
    } else {
      model["vanBanMasterID"] = Get.arguments["vanBanMasterID"];
      initParam();
    }
    butkey.value = Get.parameters["butkey"] ?? "";
  }
}
