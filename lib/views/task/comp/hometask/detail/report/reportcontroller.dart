import 'dart:convert';

import 'package:dio/dio.dart' as dio;
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:soe/utils/golbal/golbal.dart';
import 'package:soe/views/task/comp/hometask/detail/report/inputreportcontroller.dart';

class ReportTaskController extends GetxController {
  ScrollController scrollController = ScrollController();
  final textController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  //Declare
  var loading = true.obs;
  var loaddingmore = false;
  var lastdata = false.obs;
  var showFab = false.obs;
  var task = {}.obs;
  var datas = [].obs;
  var countdata = 0.obs;
  var isGiahan = false.obs;
  var giahan = {}.obs;
  var sendding = false.obs;
  var isReport = false.obs;
  var isReview = false.obs;
  var danhgia = (0.0).obs;

  Rx<List> images = Rx<List>([]);
  Rx<List<PlatformFile>> files = Rx<List<PlatformFile>>([]);

  //Function
  void scrollBottom() {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void clickBody() {
    final InputReportController ipcontroller = Get.put(InputReportController());
    ipcontroller.emojiShowing.value = false;
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

  void deleteFile(i) {
    files.value.removeAt(i);
    files.refresh();
  }

  void deleteImage(i) {
    images.value.removeAt(i);
    images.refresh();
  }

  Future<void> sendReview(bc, review) async {
    if (textController.text == "") {
      EasyLoading.showError("Vui lòng nhập nội dung đánh");
      return;
    }
    if (sendding.value) return;
    sendding.value = true;
    EasyLoading.show(
      status: "Đang gửi đánh giá...",
    );
    Map<String, dynamic> mdata = {
      "models": json.encode({
        "user_id": Golbal.store.user["user_id"],
        "review": review,
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
          '${Golbal.congty!.api}/api/Task/Update_DanhgiaTask',
          data: formData);
      EasyLoading.dismiss();
      //print(response.data);
      sendding.value = false;
      if (response.data == null || response.data["err"] == "1") {
        EasyLoading.showError(response.data["err_app"] ??
            "Không thể gửi đánh giá, vui lòng thử lại!");
      } else {
        EasyLoading.showSuccess("Gửi đánh giá thành công!");
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
        textController.text = "";
        initData(false);
      }
    } catch (e) {
      sendding.value = false;
      EasyLoading.dismiss();
      EasyLoading.showToast(
        "Không thể gửi bình luận, vui lòng thử lại!",
      );
    }
  }

  Future<void> deleteReport(context, item) async {
    bool rs = await showDialog(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: Row(
              children: <Widget>[
                Image.asset("assets/logoso.png", height: 24.0),
                const SizedBox(width: 10.0),
                const Expanded(
                  child: Text('Xác nhận'),
                )
              ],
            ),
            content: const Text('Bạn có muốn xoá báo cáo này không?'),
            actions: <Widget>[
              TextButton(
                child: Text(
                  'CÓ',
                  style: TextStyle(color: Golbal.appColor, fontSize: 16.0),
                ),
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
              ),
              TextButton(
                child: const Text(
                  'KHÔNG',
                  style: TextStyle(color: Colors.black45, fontSize: 16.0),
                ),
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
              ),
            ],
          );
        });
    if (rs == true) {
      try {
        if (sendding.value) return;
        sendding.value = true;
        EasyLoading.show(status: "loading...");
        Dio dio = Dio();
        dio.options.headers["Authorization"] = "Bearer ${Golbal.store.token}";
        dio.options.followRedirects = true;
        var response = await dio.put(
          "${Golbal.congty!.api}/api/Task/Delele_Baocao",
          data: {
            "user_id": Golbal.store.user["user_id"],
            "BaocaoID": item["BaocaoID"],
          },
        );
        var data = response.data;
        sendding.value = false;
        if (data["err"] == "1") {
          EasyLoading.showError("Có lỗi xảy ra, vui lòng thử lại");
        }
        var idx = datas.indexWhere((e) => e["BaocaoID"] == item["BaocaoID"]);
        if (idx != -1) {
          datas.removeAt(idx);
        }
        EasyLoading.showSuccess("Xóa thành công");
      } catch (e) {
        sendding.value = false;
        EasyLoading.dismiss();
        if (kDebugMode) {
          print(e);
        }
      }
    }
  }

  //init
  @override
  void onInit() {
    super.onInit();
    task.value = Get.arguments;
    initData(true);
  }

  void initData(f) async {
    try {
      if (f) {
        loading.value = true;
        EasyLoading.show(status: "loading...");
      }
      Dio dio = Dio();
      dio.options.headers["Authorization"] = "Bearer ${Golbal.store.token}";
      dio.options.followRedirects = true;
      var response = await dio.post(
        "${Golbal.congty!.api}/api/Task/Get_Baocao",
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
          for (var r in datas) {
            if (r["files"] != null) {
              r["files"] = json.decode(r["files"]);
            }
            if (r["reviews"] != null) {
              r["reviews"] = List.castFrom(
                  json.decode(r["reviews"].replaceAll('\n', '\\n')));
              r["reviews"].forEach((re) {
                if (re["files"] != null && re["files"] != "") {
                  re["files"] = List.castFrom(
                      json.decode(re["files"].replaceAll('\n', '\\n')));
                } else {
                  re["files"] = null;
                }
              });
            }
            if (r["Trangthai"] == 0) {
              isReport.value = false;
            }
          }
        }
      }
      scrollBottom();
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
