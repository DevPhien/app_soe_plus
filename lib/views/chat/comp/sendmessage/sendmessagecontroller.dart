import 'dart:convert';
import 'dart:io';

import 'package:date_time_format/date_time_format.dart';
import 'package:dio/dio.dart';
import 'package:dio/dio.dart' as dioform;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:soe/utils/CompressImage.dart';
import 'package:soe/utils/golbal/golbal.dart';
import 'package:soe/views/chat/controller/messenger/chatcardcontroller.dart';
import 'package:uuid/uuid.dart';

class SendMessageController extends GetxController {
  ChatCardController chatCardController = Get.put(ChatCardController());
  late Rx<TextEditingController> textController = TextEditingController().obs;
  var getdata = {}.obs;
  var userdatas = [].obs;
  var chons = [].obs;
  dynamic model = {}.obs;
  RxBool isEmoij = false.obs;
  RxBool send = false.obs;
  RxBool sendding = false.obs;
  Rx<List<PlatformFile>> files = Rx<List<PlatformFile>>([]);

  FocusNode focus = FocusNode();
  final searchController = TextEditingController();

  final uuid = const Uuid();
  CompressImage comp = CompressImage();
  final ImagePicker _picker = ImagePicker();
  final DateTime now = DateTime.now();
  late File _image;
  late List images;
  String rootFilepath = "";

  void changeText(txt) {
    if (txt.isNotEmpty) {
      send.value = true;
    } else {
      send.value = false;
    }
  }

  void onSearch(txt) {
    searchController.text = txt;
    String s = Golbal.changeAlias(txt);
    userdatas.value = List.castFrom(getdata["userdatas"])
        .where((e) =>
            e["NhanSu_ID"] != Golbal.store.user["user_id"] &&
            Golbal.changeAlias(e["fullName"].toString())
                .toLowerCase()
                .contains(s))
        .toList();
  }

  void showEmoij(context) {
    if (MediaQuery.of(context).viewInsets.bottom > 0) {
      dismissKeybroad(context);
      isEmoij.value = !isEmoij.value;
    } else {
      isEmoij.value = !isEmoij.value;
    }
  }

  void setEmoij(emoji) {
    send.value = true;
    textController.value =
        TextEditingController(text: textController.value.text + emoji.emoji!);
  }

  void checkedUser(user, bool v) {
    user["check"] = false;
    chons.remove(user);

    user["isChecked"] = v;
    var idx = userdatas.indexWhere((e) => e["NhanSu_ID"] == user["NhanSu_ID"]);
    if (idx != -1) {
      userdatas[idx] = user;
    }

    chons.value = List.castFrom(getdata["userdatas"])
        .where((p0) => p0["isChecked"] == true)
        .toList();
  }

  //files
  void pickDocument(context) async {
    if (Platform.isAndroid) {
      var checkOkay = await Permission.storage.request().isGranted;
      if (!checkOkay) {
        EasyLoading.showToast("Bạn đã không cấp quyền truy cập thư mục này!");
        return;
      }
      try {
        //var paths = await FlutterDocumentPicker.openDocument();
        FilePickerResult? result =
            await FilePicker.platform.pickFiles(allowMultiple: true);
        if (result != null) {
          List<File> paths =
              result.paths.map((dynamic path) => File(path)).toList();
          if (paths.isNotEmpty) {
            send.value = true;
            for (File path in paths) {
              uploadDoc(path);
            }
            paths = [];
          }
        } else {
          // User canceled the picker
        }
      } catch (e) {}
    } else {
      try {
        FilePickerResult? result =
            await FilePicker.platform.pickFiles(allowMultiple: true);
        if (result != null) {
          List<File> paths =
              result.paths.map((dynamic path) => File(path)).toList();
          if (paths != null && paths.isNotEmpty) {
            send.value = true;
            for (File path in paths) {
              uploadDoc(path);
            }
            paths = [];
          }
        } else {
          // User canceled the picker
        }
      } catch (e) {}
    }
  }

  void uploadDoc(File f) async {
    rootFilepath = "/Portals/" +
        Golbal.store.user["organization_id"] +
        "/SChat/" +
        Golbal.store.user["user_id"] +
        "/" +
        DateTimeFormat.format(now, format: 'd-m-Y') +
        "/";
    String uid = uuid.v1();
    int len = await f.length();
    var ms = {
      "uuid": uid,
      "user_id": Golbal.store.user["user_id"],
      "nguoiGui": Golbal.store.user["user_id"],
      "file": f,
      "path": f.path,
      // "tenFile": "$uid${f.path.substring(f.path.lastIndexOf("."))}",
      // "duongDan":
      //     "$rootFilepath$uid${f.path.substring(f.path.lastIndexOf("."))}",
      "loai": 2,
      "loaiFile": f.path.substring(f.path.lastIndexOf(".")),
      "dungLuong": len,
      "ngayGui": DateTime.now().toIso8601String(),
      "fullName": Golbal.store.user["FullName"],
      "anhThumb": Golbal.store.user["Avartar"] != null
          ? Golbal.store.user["Avartar"].replaceAll(Golbal.congty!.fileurl, "")
          : "",
      "compress": true,
      "trangThai": 0 //Đang gửi
    };
    upLoadFile(ms);
  }

  void initMultiPickUp() async {
    images = [];
    List<XFile>? resultList = [];
    try {
      // resultList = await MultiImagePicker.pickImages(
      //   enableCamera: true,
      //   maxImages: 10,
      // );
      resultList = await _picker.pickMultiImage();
    } catch (e) {}
    if (resultList != null && resultList.isNotEmpty) {
      images = resultList;
      bindFilesChat();
    }
  }

  void bindFilesChat() async {
    rootFilepath = "/Portals/" +
        Golbal.store.user["organization_id"] +
        "/SChat/" +
        Golbal.store.user["user_id"] +
        "/" +
        DateTimeFormat.format(now, format: 'd-m-Y') +
        "/";
    String uid = uuid.v1();
    if (images.isNotEmpty) {
      final tempDir = await getTemporaryDirectory();
      for (XFile item in images) {
        uid = uuid.v1();
        var byte = await item.readAsBytes();
        String path = "${tempDir.path}/$uid.jpg";
        var decodedImageFile = File(path);
        decodedImageFile.writeAsBytesSync(byte.buffer.asUint8List());
        int len = await item.length(); //await decodedImageFile.length();
        var ms = {
          "uuid": uid,
          "user_id": Golbal.store.user["user_id"],
          "nguoiGui": Golbal.store.user["user_id"],
          "file": decodedImageFile,
          "path": path,
          //"tenFile": "$uid.jpg",
          //"duongDan": "$rootFilepath/$uid.jpg",
          "loai": 1,
          "dungLuong": len,
          "ngayGui": DateTime.now().toIso8601String(),
          "fullName": Golbal.store.user["FullName"],
          "anhThumb": Golbal.store.user["Avartar"] != null
              ? Golbal.store.user["Avartar"]
                  .replaceAll(Golbal.congty!.fileurl, "")
              : "",
          "compress": false,
          "trangThai": 0 //Đang gửi
        };
        compressImage(ms);
      }
    } else if (_image != null) {
      uid = uuid.v1();
      int len = await _image.length();
      var ms = {
        "uuid": uid,
        "user_id": Golbal.store.user["user_id"],
        "nguoiGui": Golbal.store.user["user_id"],
        "file": _image,
        "path": _image.path,
        //"tenFile": "$uid.jpg",
        //"duongDan": "/Portals/Chat/$uid.jpg",
        "loai": 1,
        "dungLuong": len,
        "ngayGui": DateTime.now().toIso8601String(),
        "fullName": Golbal.store.user["FullName"],
        "anhThumb": Golbal.store.user["Avartar"] != null
            ? Golbal.store.user["Avartar"]
                .replaceAll(Golbal.congty!.fileurl, "")
            : "",
        "compress": false,
        "trangThai": 0 //Đang gửi
      };

      compressImage(ms);
    }
  }

  void compressImage(ms) async {
    ms["filecompress"] = await comp.takePicture(ms["file"]);
    ms["compress"] = true;

    upLoadFile(ms);
  }

  void dismissKeybroad(context) {
    FocusScope.of(context).requestFocus(FocusNode());
    if (isEmoij.value) {
      isEmoij.value = false;
    }
  }

  void sendSMS() async {
    if (sendding.value == true) {
      EasyLoading.showToast(
          "Đang gửi tin nhắn, bạn vui lòng thao tác chậm lại!");
      return;
    }
    EasyLoading.show(status: 'Đang gửi ...');
    try {
      sendding.value = true;
      String uid = uuid.v1();
      var ms = {};
      ms = {
        "uuid": uid,
        "user_id": Golbal.store.user["user_id"],
        "nguoiGui": Golbal.store.user["user_id"],
        "noiDung": textController.value.text,
        "loai": 0,
        "ngayGui": DateTime.now().toIso8601String(),
        "fullName": Golbal.store.user["FullName"],
        "anhThumb": Golbal.store.user["Avartar"] != null
            ? Golbal.store.user["Avartar"]
                .replaceAll(Golbal.congty!.fileurl, "")
            : "",
        "trangThai": 0, //Đang gửi
        "isAdd": true,
        "event": "getSendMessage",
        "socketid": Golbal.socket.id,
      };
      var strbody = json.encode(ms);
      var ids = List.castFrom(getdata["userdatas"])
          .where((e) => e["isChecked"] == true)
          .map((e) => e["NhanSu_ID"])
          .toList()
          .join(',');
      dioform.FormData formData = dioform.FormData.fromMap({
        "user_id": Golbal.store.user["user_id"],
        "model": strbody,
        "users": ids,
      });
      Dio dio = Dio();
      dio.options.headers["Authorization"] = "Bearer ${Golbal.store.token}";
      dio.options.followRedirects = true;
      var response = await dio
          .put("${Golbal.congty!.api}/api/Chat/Send_Message", data: formData);
      var data = response.data;
      EasyLoading.dismiss();
      if (data["err"] == "1") {
        EasyLoading.showError("Có lỗi xảy ra, vui lòng thử lại!");
        return;
      }

      if (data["chats"] != null && data["chats"].length > 0) {
        for (var c in data["chats"]) {
          if (data["mess"] != null && data["mess"].length > 0) {
            for (var m in data["mess"]) {
              var mes = {
                //app
                "uuid": m["MessageID"],
                "ChatID": c,
                "user_id": Golbal.store.user["user_id"],
                "nguoiGui": Golbal.store.user["user_id"],
                "noiDung": ms["noiDung"],
                "loai": ms["loai"],
                "ngayGui": DateTime.now().toIso8601String(),
                "fullName": Golbal.store.user["FullName"],
                "anhThumb": Golbal.store.user["Avartar"] != null
                    ? Golbal.store.user["Avartar"]
                        .replaceAll(Golbal.congty!.fileurl, "")
                    : "",
                "trangThai": 0,
                "isAdd": true,
                "event": "getSendMessage",
                "socketid": Golbal.socket.id,
                "MessageID": ms["MessageID"],
                "ParentID": null,
                "tenFile": ms["tenFile"],
                "loaiFile": ms["loaiFile"],
                "duongDan": ms["duongDan"],
              };
              Golbal.socket.emit('sendData', mes);
            }
          }
        }
      }
      //End Realtime

      textController.value.text = "";
      send.value = false;
      sendding.value = false;

      chatCardController.initData(false);
      Get.back();
    } catch (e) {
      EasyLoading.dismiss();
      if (kDebugMode) {
        print(e);
      }
    }
  }

  void upLoadFile(ms) async {
    EasyLoading.show(status: 'Đang upload ...');
    try {
      var files = [];
      for (var fi in [ms["filecompress"] ?? ms["file"]]) {
        if (kIsWeb) {
          files.add(dioform.MultipartFile.fromBytes(fi.bytes!,
              filename: "${fi.path!.split('/').last ?? 'image.jpg'}"));
        } else {
          files.add(dioform.MultipartFile.fromFileSync(fi.path!,
              filename: "${fi.path!.split('/').last ?? 'image.jpg'}"));
        }
      }
      var body = {
        "uuid": ms["uuid"],
        "user_id": ms["user_id"],
        "nguoiGui": ms["nguoiGui"],
        "noiDung": ms["noiDung"] ?? "",
        "loai": ms["loai"],
        "loaiFile": ms["loaiFile"],
        "dungLuong": ms["dungLuong"],
        "ngayGui": ms["ngayGui"],
        "fullName": ms["fullName"],
        "anhThumb": ms["anhThumb"],
        "trangThai": 0, //Đang gửi
        "event": "getSendMessage",
        "socketid": Golbal.socket.id,
      };
      var strbody = json.encode(body);
      var ids = List.castFrom(getdata["userdatas"])
          .where((e) => e["isChecked"] == true)
          .map((e) => e["NhanSu_ID"])
          .toList()
          .join(',');
      dioform.FormData formData = dioform.FormData.fromMap({
        "user_id": Golbal.store.user["user_id"],
        "model": strbody,
        "users": ids,
        "files": files,
      });
      Dio dio = Dio();
      dio.options.headers["Authorization"] = "Bearer ${Golbal.store.token}";
      dio.options.followRedirects = true;
      var response = await dio
          .put("${Golbal.congty!.api}/api/Chat/Send_Message", data: formData);
      var data = response.data;
      EasyLoading.dismiss();
      if (data["err"] == "1") {
        EasyLoading.showError("Có lỗi xảy ra, vui lòng thử lại!");
        return;
      }

      if (data["chats"] != null && data["chats"].length > 0) {
        for (var c in data["chats"]) {
          if (data["mess"] != null && data["mess"].length > 0) {
            for (var m in data["mess"]) {
              var mes = {
                //app
                "uuid": m["MessageID"],
                "ChatID": c,
                "user_id": Golbal.store.user["user_id"],
                "nguoiGui": Golbal.store.user["user_id"],
                "noiDung": ms["noiDung"],
                "loai": ms["loai"],
                "ngayGui": DateTime.now().toIso8601String(),
                "fullName": Golbal.store.user["FullName"],
                "anhThumb": Golbal.store.user["Avartar"] != null
                    ? Golbal.store.user["Avartar"]
                        .replaceAll(Golbal.congty!.fileurl, "")
                    : "",
                "trangThai": 0,
                "isAdd": true,
                "event": "getSendMessage",
                "socketid": Golbal.socket.id,
                "MessageID": ms["MessageID"],
                "ParentID": null,
                "tenFile": ms["tenFile"],
                "loaiFile": ms["loaiFile"],
                "duongDan": ms["duongDan"],
              };
              Golbal.socket.emit('sendData', mes);
            }
          }
        }
      }

      send.value = false;
      sendding.value = false;

      chatCardController.initData(false);
      Get.back();
    } catch (e) {
      EasyLoading.dismiss();
      if (kDebugMode) {
        print(e);
      }
    }
  }

  @override
  void onInit() async {
    super.onInit();
    getdata.value = Get.arguments;
    initModel();
  }

  void initModel() {
    userdatas.value = List.castFrom(getdata["userdatas"])
        .where((e) => e["NhanSu_ID"] != Golbal.store.user["user_id"])
        .toList();
    for (var us in List.castFrom(userdatas)
        .where((e) => e["isChecked"] == true)
        .toList()) {
      us["isChecked"] = false;
    }
  }
}
