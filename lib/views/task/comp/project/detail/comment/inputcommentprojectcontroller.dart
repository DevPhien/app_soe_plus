import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:dio/dio.dart' as dioform;
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:soe/utils/golbal/golbal.dart';
import 'package:soe/views/task/comp/project/detail/comment/commentprojectcontroller.dart';
import 'package:soe/views/task/comp/project/detail/detailprojectcontroller.dart';

class InputCommentProjectController extends GetxController {
  final DetailProjectController controller = Get.put(DetailProjectController());
  final CommentProjectController cmcontroller =
      Get.put(CommentProjectController());
  //Declare
  final TextEditingController textcontroller = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  RxBool emojiShowing = false.obs;
  RxBool showmoreFile = true.obs;
  RxBool isSend = false.obs;
  RxBool sendding = false.obs;
  RxBool isEdit = false.obs;
  Rx<List<PlatformFile>> files = Rx<List<PlatformFile>>([]);
  Rx<List> images = Rx<List>([]);

  //Function
  onEmojiSelected(Emoji emoji) {
    textcontroller
      ..text += emoji.emoji
      ..selection = TextSelection.fromPosition(
          TextPosition(offset: textcontroller.text.length));
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

  void deleteFile(i) {
    files.value.removeAt(i);
    files.refresh();
  }

  void deleteImage(i) {
    images.value.removeAt(i);
    images.refresh();
  }

  Future<void> sendMessage() async {
    if (sendding.value == true) {
      EasyLoading.showToast(
          "Đang gửi bình luận, bạn vui lòng thao tác chậm lại!");
      return;
    }
    if (textcontroller.text == "") {
      EasyLoading.showError("Vui lòng nhập nội dung bình luận!");
      return;
    }
    EasyLoading.show(status: "Đang gửi bình luận ...");

    try {
      var ms = {};
      if (isEdit.value) {
      } else {
        ms = {
          "isAdd": true,
          "Noidung": textcontroller.text,
          "DuanID": controller.project["DuanID"],
          "CommentID": -1,
          "IsType": 0,
          "NguoiTao": Golbal.store.user["user_id"],
          "fullName": Golbal.store.user["FullName"],
          "anhThumb": Golbal.store.user["Avartar"],
          "NgayTao": DateTime.now().toIso8601String(),
          "event": "getSendCommentRequest",
          "socketid": Golbal.socket.id,
        };
        if (cmcontroller.quote.isNotEmpty) {
          ms["ParentID"] = cmcontroller.quote["CommentID"];
        }
      }
      var ffiles = [];
      for (var fi in files.value) {
        if (kIsWeb) {
          ffiles.add(dioform.MultipartFile.fromBytes(fi.bytes!,
              filename: fi.path!.split('/').last));
        } else {
          ffiles.add(dioform.MultipartFile.fromFileSync(fi.path!,
              filename: fi.path!.split('/').last));
        }
      }
      for (var fi in images.value) {
        if (kIsWeb) {
          ffiles.add(dioform.MultipartFile.fromBytes(fi.bytes!,
              filename: fi.path!.split('/').last));
        } else {
          ffiles.add(dioform.MultipartFile.fromFileSync(fi.path!,
              filename: fi.path!.split('/').last));
        }
      }
      var strbody = json.encode(ms);
      dioform.FormData formData = dioform.FormData.fromMap({
        "model": strbody,
        "files": ffiles,
      });
      Dio dio = Dio();
      dio.options.headers["Authorization"] = "Bearer ${Golbal.store.token}";
      dio.options.followRedirects = true;
      var response = await dio.put(
          '${Golbal.congty!.api}/api/Task/Update_CommentProject',
          data: formData);
      var data = response.data;
      if (data["err"] == "1") {
        EasyLoading.showError("Không thể gửi bình luận, vui lòng thử lại!");
        return;
      } else {
        EasyLoading.showSuccess("Gửi bình luận thành công!");

        if (data["files"] != null && data["files"] != "") {
          var fs = json.decode(data["files"]);
          ms["files"] = fs;
        }

        //Realtime
        ms["IsMe"] = false;
        ms["CommentID"] = data["CommentID"];
        Golbal.socket.emit('sendData', ms);
        //End Realtime

        if (isEdit.value) {
        } else {
          ms["IsMe"] = true;
          cmcontroller.comments.insert(cmcontroller.comments.length, ms);
        }

        controller.scrollBottom();

        cmcontroller.quote.value = {};
        textcontroller.text = "";
        files.value = [];
        images.value = [];
        isSend.value = false;
        sendding.value = false;
        isEdit.value = false;
      }
    } catch (e) {
      EasyLoading.dismiss();
      EasyLoading.showError("Không thể gửi bình luận, vui lòng thử lại!");

      cmcontroller.quote.value = {};
      textcontroller.text = "";
      files.value = [];
      images.value = [];
      isSend.value = false;
      sendding.value = false;
      isEdit.value = false;
      if (kDebugMode) {
        print(e);
      }
    }
  }

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onClose() {
    textcontroller.dispose();
    super.onClose();
  }
}
