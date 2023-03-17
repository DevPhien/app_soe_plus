import 'dart:convert';

import 'package:dio/dio.dart' as dio;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:soe/views/vanban/controller/chitietvanbancontroller.dart';

import '../../../../utils/golbal/golbal.dart';
import '../../controller/uservanbancontroller.dart';
import '../listuser.dart';

class ChuyenDichDanhVanbanController extends GetxController {
  final ChitietVanbanController controller = Get.put(ChitietVanbanController());
  final UserVBController usercontroller = Get.put(UserVBController());
  var model = {}.obs;
  var handlers = [].obs;
  var trackers = [].obs;
  var viewers = [].obs;
  Rx<List<PlatformFile>> files = Rx<List<PlatformFile>>([]);
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

  Future<void> showUser(int loai) async {
    usercontroller.users.where((p0) => p0["chon"] == true).forEach((element) {
      element["chon"] = false;
    });
    usercontroller.users.where((p0) => p0["chon"] == true).forEach((element) {
      element["chon"] = false;
    });
    usercontroller.isChon.value = 0;
    if (loai == 1) {
      resetChon(handlers);
    } else if (loai == 2) {
      resetChon(trackers);
    } else if (loai == 3) {
      resetChon(viewers);
    }
    var rs = await showCupertinoModalBottomSheet(
      context: Get.context!,
      expand: true,
      builder: (context) => ListUserVanBan(),
    );
    if (rs != null) {
      if (loai == 1) {
        handlers.value = rs;
      } else if (loai == 2) {
        trackers.value = rs;
      } else if (loai == 3) {
        viewers.value = rs;
      }
    }
  }

  Future<void> submit() async {
    model["handlers"] =
        handlers.map((element) => element["NhanSu_ID"]).toList();
    model["trackers"] =
        trackers.map((element) => element["NhanSu_ID"]).toList();
    model["viewers"] = viewers.map((element) => element["NhanSu_ID"]).toList();
    EasyLoading.show(
      status: "Đang gửi văn bản ...",
    );
    Map<String, dynamic> mdata = {
      "model": json.encode({
        "doc_master_id": model["vanBanMasterID"],
        "message": model["message"],
        "handle_date": model["handle_date"],
        "follow_id": model["vanBanFollow_ID"],
        "user_id": Golbal.store.user["user_id"],
        "handlers": model["handlers"],
        "trackers": model["trackers"],
        "viewers": model["viewers"],
      })
    };
    var ffiles = [];
    for (var fi in files.value) {
      if (kIsWeb) {
        ffiles.add(dio.MultipartFile.fromBytes(fi.bytes!, filename: fi.name));
      } else {
        ffiles.add(dio.MultipartFile.fromFileSync(fi.path!, filename: fi.name));
      }
    }
    mdata["file"] = ffiles;
    dio.FormData formData = dio.FormData.fromMap(mdata);
    dio.Dio http = dio.Dio();
    http.options.headers["Authorization"] = "Bearer ${Golbal.store.token}";
    http.options.followRedirects = true;
    try {
      var response = await http
          .put('${Golbal.congty!.api}/api/Doc/FollowPersonDoc', data: formData);
      EasyLoading.dismiss();
      if (response.data["err"] == "1") {
        EasyLoading.showToast(response.data["err_app"] ??
            "Không thể chuyển đích danh văn bản này, vui lòng thử lại!");
      } else {
        if (response.data != null) {
          EasyLoading.showToast("Chuyển văn bản thành công!");
          Get.back(result: true);
        }
      }
    } catch (e) {
      http.put(Golbal.congty!.api + '/api/Log/AddLog', data: {
        "title": "Lỗi chuyển đích danh văn bản",
        "controller": "Doc/FollowPersonDoc",
        "log_date": DateTime.now().toIso8601String(),
        "log_content": mdata["model"],
        "full_name": Golbal.store.user["FullName"],
        "user_id": Golbal.store.user["user_id"],
        "token_id": Golbal.store.user["Token_ID"],
        "is_type": 0,
        "module": "Doc",
      });
      EasyLoading.dismiss();
      EasyLoading.showToast(
        "Không thể chuyển đích danh văn bản này, vui lòng thử lại!",
      );
    }
  }

  void deleUser(int i, int loai) {
    if (loai == 1) {
      handlers.removeAt(i);
    } else if (loai == 2) {
      trackers.removeAt(i);
    } else if (loai == 3) {
      viewers.removeAt(i);
    }
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

  Future<void> openFile() async {
    FilePickerResult? result =
        await FilePicker.platform.pickFiles(allowMultiple: true);

    if (result != null) {
      files.value = result.files;
    } else {
      // User canceled the picker
    }
  }

  void deleteFile(i) {
    files.value.removeAt(i);
    files.refresh();
  }

  @override
  void onInit() {
    super.onInit();
    //print(Get.arguments);
    model["vanBanMasterID"] = Get.arguments["vanBanMasterID"];
    model["vanBanFollow_ID"] = Get.arguments["vanBanFollow_ID"];
  }
}
