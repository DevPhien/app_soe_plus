import 'dart:convert';

import 'package:dio/dio.dart' as dio;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:soe/views/vanban/controller/chitietvanbancontroller.dart';

import '../../../../utils/golbal/golbal.dart';

class XacnhanHoanthanhVanbanController extends GetxController {
  final ChitietVanbanController controller = Get.put(ChitietVanbanController());
  var model = {}.obs;
  Rx<List<PlatformFile>> files = Rx<List<PlatformFile>>([]);

  Future<void> submit() async {
    if ((model["message"] == null ||
            model["message"].toString().trim() == "") &&
        files.value.isEmpty) {
      EasyLoading.show(
        status: "Vui lòng nhập nội dung xác nhận hoặc file đính kèm.",
      );
      return;
    }
    EasyLoading.show(
      status: "Đang gửi xác nhận văn bản ...",
    );
    Map<String, dynamic> mdata = {
      "model": json.encode({
        "doc_master_id": model["vanBanMasterID"],
        "message": model["message"],
        "handle_date": model["handle_date"],
        "follow_id": model["vanBanFollow_ID"],
        "user_id": Golbal.store.user["user_id"]
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
      var response = await http.put(
          '${Golbal.congty!.api}/api/Doc/CompletedConfirm',
          data: formData);
      EasyLoading.dismiss();
      if (response.data["err"] == "1") {
        EasyLoading.showToast(response.data["err_app"] ??
            "Không thể gửi xác nhận văn bản này, vui lòng thử lại!");
      } else {
        if (response.data != null) {
          EasyLoading.showToast("Gửi xác nhận văn bản thành công!");
          Get.back(result: true);
        }
      }
    } catch (e) {
      http.put('${Golbal.congty!.api}/api/Log/AddLog', data: {
        "title": "Lỗi gửi xác nhận văn bản",
        "controller": "Doc/CompletedConfirm",
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
        "Không thể gửi xác nhận văn bản này, vui lòng thử lại!",
      );
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
