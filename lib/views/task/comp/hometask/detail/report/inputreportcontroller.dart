import 'dart:convert';

import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart' as dio;
import 'package:image_picker/image_picker.dart';
import 'package:soe/views/task/comp/hometask/detail/report/reportcontroller.dart';

import '../../../../../../utils/golbal/golbal.dart';

class InputReportController extends GetxController {
  ReportTaskController controller = Get.put(ReportTaskController());
  var report = {}.obs;
  var showProgress = false.obs;
  var tiendoDexuat = (0.0).obs;
  RxBool emojiShowing = false.obs;
  RxBool showmoreFile = true.obs;
  RxBool isSend = false.obs;
  Rx<List> images = Rx<List>([]);
  Rx<List<PlatformFile>> files = Rx<List<PlatformFile>>([]);
  final TextEditingController textcontroller = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  onEmojiSelected(Emoji emoji) {
    textcontroller
      ..text += emoji.emoji
      ..selection = TextSelection.fromPosition(
          TextPosition(offset: textcontroller.text.length));
  }

  void changeInput(String? txt) {
    if (txt == null || txt == "") {
      if (!showmoreFile.value) {
        showmoreFile.value = true;
      }
      if (isSend.value) {
        isSend.value = false;
      }
    } else {
      if (showmoreFile.value) {
        showmoreFile.value = false;
      }
      if (!isSend.value) {
        isSend.value = true;
      }
    }
  }

  onBackspacePressed() {
    textcontroller
      ..text = textcontroller.text.characters.skipLast(1).toString()
      ..selection = TextSelection.fromPosition(
          TextPosition(offset: textcontroller.text.length));
  }

  Future<void> openFile() async {
    FilePickerResult? result =
        await FilePicker.platform.pickFiles(allowMultiple: true);

    if (result != null) {
      files.value.addAll(result.files);
      files.refresh();
    }
  }

  Future<void> openFileImage() async {
    List<XFile>? result = [];
    try {
      result = await _picker.pickMultiImage();
    } catch (e) {}

    if (result != null) {
      images.value += result;
      images.refresh();
    }
  }

  Future<void> sendReport() async {
    if (textcontroller.text == "") {
      EasyLoading.showError("Vui lòng nhập nội dung báo cáo!");
      return;
    }
    EasyLoading.show(
      status: "Đang gửi báo cáo...",
    );
    showProgress.value = false;
    Map<String, dynamic> mdata = {
      "models": json.encode({
        "user_id": Golbal.store.user["user_id"],
        "report": {
          "DuanID": controller.task["DuanID"],
          "CongviecID": controller.task["CongviecID"],
          "Noidung": textcontroller.text,
          "CommentID": -1,
          "TiendoDexuat": report["TiendoDexuat"] != null
              ? report["TiendoDexuat"].ceil()
              : 0,
          "Tiendo": report["TiendoDexuat"] != null
              ? report["TiendoDexuat"].ceil()
              : 0,
          "IsType": 4,
          "NguoiTao": Golbal.store.user["user_id"],
          "NgayTao": DateTime.now().toIso8601String(),
          "NgayBaocao": DateTime.now().toIso8601String(),
          "Trangthai": 0,
        },
      })
    };
    var ffiles = [];
    for (var fi in files.value) {
      if (kIsWeb) {
        ffiles.add(dio.MultipartFile.fromBytes(fi.bytes!,
            filename: fi.path!.split('/').last));
      } else {
        ffiles.add(dio.MultipartFile.fromFileSync(fi.path!,
            filename: fi.path!.split('/').last));
      }
    }
    for (var fi in images.value) {
      if (kIsWeb) {
        ffiles.add(dio.MultipartFile.fromBytes(fi.bytes!,
            filename: fi.path!.split('/').last));
      } else {
        ffiles.add(dio.MultipartFile.fromFileSync(fi.path!,
            filename: fi.path!.split('/').last));
      }
    }
    if (ffiles.isNotEmpty) {
      mdata["files"] = ffiles;
    }
    dio.FormData formData = dio.FormData.fromMap(mdata);
    dio.Dio http = dio.Dio();
    http.options.headers["Authorization"] = "Bearer ${Golbal.store.token}";
    http.options.followRedirects = true;
    try {
      var response = await http.put(
          '${Golbal.congty!.api}/api/Task/Update_BaocaoTask',
          data: formData);
      EasyLoading.dismiss();
      //print(response.data);
      isSend.value = false;
      if (response.data == null || response.data["err"] == "1") {
        EasyLoading.showError(response.data["err_app"] ??
            "Không thể gửi báo cáo, vui lòng thử lại!");
      } else {
        EasyLoading.showSuccess("Gửi báo cáo thành công!");
        files.value.clear();
        files.refresh();
        images.value.clear();
        images.refresh();
        //cmcontroller.initData(cmcontroller.controller.task["CongviecID"], true);
        //Socket
        // Golbal.sendSocketData({
        //   //"CongviecID": cmcontroller.controller.task["CongviecID"],
        //   "type": 0, //Gửi comment,
        //   "module": "task",
        //   "ms": textcontroller.text,
        //   "user_id": Golbal.store.user["user_id"],
        //   "title": Golbal.store.user["FullName"],
        // });
        textcontroller.text = "";
        tiendoDexuat.value = 0;
        controller.initData(false);
      }
    } catch (e) {
      EasyLoading.dismiss();
      EasyLoading.showToast(
        "Không thể gửi bình luận, vui lòng thử lại!",
      );
    }
  }

  void deleteFile(i) {
    files.value.removeAt(i);
    files.refresh();
  }

  void deleteImage(i) {
    images.value.removeAt(i);
    images.refresh();
  }

  @override
  void onClose() {
    textcontroller.dispose();
    super.onClose();
  }
}
