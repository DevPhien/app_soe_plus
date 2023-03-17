import 'dart:convert';

import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart' as dio;
import 'package:image_picker/image_picker.dart';

import '../../../../../../utils/golbal/golbal.dart';
import 'commenttakscontroller.dart';

class InputCommentController extends GetxController {
  RxBool emojiShowing = false.obs;
  RxBool showmoreFile = true.obs;
  RxBool isSend = false.obs;
  final ImagePicker _picker = ImagePicker();
  Rx<List<PlatformFile>> files = Rx<List<PlatformFile>>([]);
  Rx<List> images = Rx<List>([]);
  final TextEditingController textcontroller = TextEditingController();
  final CommentTaskController cmcontroller = Get.put(CommentTaskController());
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
    // FilePickerResult? result = await FilePicker.platform.pickFiles(
    //   type: FileType.custom,
    //   allowMultiple: true,
    //   allowedExtensions: ['jpg', 'png', 'gif', 'jpeg', 'svg'],
    // );

    // if (result != null) {
    //   files.value.addAll(result.files);
    //   files.refresh();
    // }

    List<XFile>? result = [];
    try {
      result = await _picker.pickMultiImage();
    } catch (e) {}

    if (result != null) {
      images.value += result;
      images.refresh();
    }
  }

  Future<void> sendMessage() async {
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
    if (textcontroller.text == "" && ffiles.isEmpty) {
      EasyLoading.showError("Vui lòng nhập nội dung bình luận!");
      return;
    }
    EasyLoading.show(
      status: "Đang gửi tin nhắn ...",
    );
    Map<String, dynamic> mdata = {
      "models": json.encode({
        "user_id": Golbal.store.user["user_id"],
        "congviec_id": cmcontroller.controller.task["CongviecID"],
        "ids": "",
        "comment": {
          "Noidung": textcontroller.text,
          "CongviecID": cmcontroller.controller.task["CongviecID"]
        },
      })
    };
    if (ffiles.isNotEmpty) {
      mdata["files"] = ffiles;
    }
    dio.FormData formData = dio.FormData.fromMap(mdata);
    dio.Dio http = dio.Dio();
    http.options.headers["Authorization"] = "Bearer ${Golbal.store.token}";
    http.options.followRedirects = true;
    try {
      var response = await http.put(
          '${Golbal.congty!.api}/api/Task/Update_TaskComment',
          data: formData);
      EasyLoading.dismiss();
      //print(response.data);
      isSend.value = false;
      if (response.data == null || response.data["err"] == "1") {
        EasyLoading.showToast(response.data["err_app"] ??
            "Không thể gửi bình luận, vui lòng thử lại!");
      } else {
        EasyLoading.showToast("Gửi bình luận thành công!");
        files.value.clear();
        images.value.clear();
        files.refresh();
        images.refresh();
        cmcontroller.initData(cmcontroller.controller.task["CongviecID"], true);
        //Socket
        Golbal.sendSocketData({
          "CongviecID": cmcontroller.controller.task["CongviecID"],
          "type": 0, //Gửi comment,
          "module": "task",
          "ms": textcontroller.text,
          "user_id": Golbal.store.user["user_id"],
          "title": Golbal.store.user["FullName"],
        });
        textcontroller.text = "";
      }
    } catch (e) {
      http.put(Golbal.congty!.api + '/api/Log/AddLog', data: {
        "title": "Lỗi gửi bình luận",
        "controller": "Task/Update_TaskComment",
        "log_date": DateTime.now().toIso8601String(),
        "log_content": mdata["model"],
        "full_name": Golbal.store.user["FullName"],
        "user_id": Golbal.store.user["user_id"],
        "token_id": Golbal.store.user["Token_ID"],
        "is_type": 0,
        "module": "Task",
      });
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

  @override
  void onClose() {
    textcontroller.dispose();
    super.onClose();
  }
}
