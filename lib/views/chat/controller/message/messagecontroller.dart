// ignore_for_file: non_constant_identifier_names, unused_field, invalid_use_of_protected_member, unnecessary_null_comparison

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:date_time_format/date_time_format.dart';
import 'package:dio/dio.dart';
import 'package:dio/dio.dart' as dioform;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_reaction_button/flutter_reaction_button.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:open_app_file/open_app_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:soe/utils/CompressImage.dart';
import 'package:soe/utils/golbal/golbal.dart';
import 'package:soe/views/chat/controller/chatcontroller.dart';
import 'package:soe/views/chat/controller/chatgroup/chatgroupcontroller.dart';
import 'package:soe/views/chat/controller/messenger/chatcardcontroller.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:uuid/uuid.dart';

class MessageController extends GetxController {
  final ChatController chatController = Get.put(ChatController());
  final ChatCardController chatcardController = Get.put(ChatCardController());
  final ChatGroupController chatgroupcardController =
      Get.put(ChatGroupController());
  //Message
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final uuid = const Uuid();
  ScrollController scrollController = ScrollController();
  CompressImage comp = CompressImage();
  TextEditingController controllers = TextEditingController();
  final StreamController<bool> streamTypeController =
      StreamController<bool>.broadcast();
  FocusNode focus = FocusNode();
  RxBool send = false.obs;
  RxBool sendding = false.obs;
  RxBool edit = false.obs;
  RxBool loading = true.obs;
  RxBool typing = false.obs;
  RxBool isQuate = false.obs;
  RxBool isEmoij = false.obs;
  String message_search = "";
  RxInt page = 1.obs;
  RxInt pagex = 1.obs;
  RxInt perpage = 50.obs;
  RxInt perpagex = 50.obs;
  RxBool first = true.obs;
  RxString user_id = "".obs;
  var duration = const Duration(milliseconds: 200);
  List<Reaction<Object>> facebookReactions = [];
  List<Reaction<Object>> facebookReactionsNull = [];
  final ImagePicker _picker = ImagePicker();

  final DateTime now = DateTime.now();
  late File _image;
  late List images;

  String rootFilepath = "";
  dynamic messageEdit = {}.obs;
  dynamic messageQuate = {}.obs;

  //data message
  var chat = {}.obs;
  var message_datas = [].obs;
  var count_message = 0.obs;
  var members_data = [].obs;
  RxBool downloading = false.obs;
  var progressString = "".obs;

  //Function calling binding
  void scroolBottom() {
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

  // function Stick
  Widget _buildPreviewIconFacebook(String path) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 3.5, vertical: 5),
        child: Image.asset(path, height: 40),
      );

  Widget _buildIconFacebook(String path, Text text) => Card(
        elevation: 4.0,
        shape: const CircleBorder(),
        clipBehavior: Clip.antiAlias,
        child: CircleAvatar(
          backgroundColor: const Color(0xffffffff),
          radius: 15,
          child: Center(
            child: Image.asset(path, height: 20),
          ),
        ),
      );

  void updateStickByMessage(message, String id) async {
    try {
      var body = {
        "user_id": Golbal.store.user["user_id"],
        "nguoiGui": Golbal.store.user["user_id"],
        "ChatID": message["ChatID"],
        "MessageID": message["MessageID"],
        "StickID": id,
        "NgayTao": DateTime.now().toIso8601String(),
        "event": "getStick",
        "socketid": Golbal.socket.id,
      };
      Dio dio = Dio();
      dio.options.headers["Authorization"] = "Bearer ${Golbal.store.token}";
      dio.options.followRedirects = true;
      var response = await dio.put(
          "${Golbal.congty!.api}/api/Chat/Update_StickByMessage",
          data: body);
      var data = response.data;
      if (data["err"] == "1") {
        EasyLoading.showError("Có lỗi xảy ra, vui lòng thử lại!");
        return;
      }
      //Realtime
      Golbal.socket.emit('sendData', body);
      //End Realtime
    } catch (e) {
      EasyLoading.dismiss();
      EasyLoading.showError("Có lỗi xảy ra!");
      loading.value = false;
      if (kDebugMode) {
        print(e);
      }
    }
  }

  //Function Message
  void seenMessage() async {
    try {
      var body = {
        "user_id": Golbal.store.user["user_id"],
        "ChatID": chatController.chatFocus["ChatID"],
      };
      Dio dio = Dio();
      dio.options.headers["Authorization"] = "Bearer ${Golbal.store.token}";
      dio.options.followRedirects = true;
      var response = await dio
          .put("${Golbal.congty!.api}/api/Chat/Seen_Message", data: body);
      var data = response.data;
      if (data["err"] == "1") {
        EasyLoading.dismiss();
        EasyLoading.showError("Có lỗi xảy ra, vui lòng thử lại!");
        if (kDebugMode) {
          print(data);
        }
        return;
      }
      var idx1 = chatcardController.datas.indexWhere((e) =>
          e["ChatID"] == chatController.chatFocus["ChatID"] &&
          e["nhom"] != true);
      if (idx1 != -1) {
        chatcardController.datas[idx1]["chuaDoc"] = 0;
      }
      var idx2 = chatgroupcardController.datas.indexWhere((e) =>
          e["ChatID"] == chatController.chatFocus["ChatID"] &&
          e["nhom"] == true);
      if (idx2 != -1) {
        chatgroupcardController.datas[idx2]["chuaDoc"] = 0;
      }
      chatcardController.datas.refresh();
      chatgroupcardController.datas.refresh();
    } catch (e) {
      EasyLoading.dismiss();
      EasyLoading.showError("Có lỗi xảy ra!");
      if (kDebugMode) {
        print(e);
      }
    }
  }

  void dismissKeybroad(context) {
    FocusScope.of(context).requestFocus(FocusNode());
    if (isEmoij.value) {
      isEmoij.value = false;
    }
    if (isQuate.value) {
      isQuate.value = false;
    }
  }

  void popGroupActionMessage(context, message) {
    List<Widget> list = [];
    if (message["IsMe"]) {
      if (message["loai"] == 0) {
        list.add(ListTile(
          leading: const Icon(
            Feather.edit,
            color: Colors.orange,
          ),
          onTap: () {
            Navigator.of(context).pop();
            editMessage(context, message);
          },
          title: const Text("Chỉnh sửa"),
          trailing: IconButton(
            icon: const Icon(Icons.close),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ));
        list.add(ListTile(
          leading: const Icon(
            Entypo.quote,
            color: Colors.purple,
          ),
          onTap: () {
            Navigator.of(context).pop();
            showQuate(context, message);
          },
          title: const Text("Trích dẫn"),
        ));
        list.add(ListTile(
          leading: const Icon(
            Entypo.forward,
            color: Colors.green,
          ),
          onTap: () {
            Navigator.of(context).pop();
            showForward(context, message);
          },
          title: const Text("Chia sẻ"),
        ));
        list.add(ListTile(
          leading: const Icon(
            MaterialCommunityIcons.content_copy,
            color: Colors.blue,
          ),
          onTap: () {
            Navigator.of(context).pop();
            copyMessage(context, message);
          },
          title: const Text("Sao chép"),
        ));
      } else if (message["loai"] == 1 || message["loai"] == 2) {
        list.add(ListTile(
          leading: const Icon(
            Entypo.quote,
            color: Colors.purple,
          ),
          onTap: () {
            Navigator.of(context).pop();
            showQuate(context, message);
          },
          title: const Text("Trích dẫn"),
          trailing: IconButton(
            icon: const Icon(Icons.close),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ));
        list.add(ListTile(
          leading: const Icon(
            Entypo.forward,
            color: Colors.green,
          ),
          onTap: () {
            Navigator.of(context).pop();
            showForward(context, message);
          },
          title: const Text("Chia sẻ"),
        ));
        // list.add(ListTile(
        //   leading: const Icon(
        //     AntDesign.download,
        //     color: Colors.blue,
        //   ),
        //   onTap: () {
        //     Navigator.of(context).pop();
        //     downloadFile(message);
        //   },
        //   title: const Text("Tải xuống"),
        // ));
      }
      list.add(ListTile(
        leading: const Icon(
          FontAwesome.trash_o,
          color: Colors.red,
        ),
        onTap: () {
          Navigator.of(context).pop();
          deleteComment(context, message);
        },
        title: const Text("Xóa"),
      ));
    } else {
      list.add(ListTile(
        leading: const Icon(
          Entypo.quote,
          color: Colors.purple,
        ),
        onTap: () {
          Navigator.of(context).pop();
          showQuate(context, message);
        },
        title: const Text("Trích dẫn"),
        trailing: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ));
      list.add(ListTile(
        leading: const Icon(
          Entypo.forward,
          color: Colors.green,
        ),
        onTap: () {
          Navigator.of(context).pop();
          showForward(context, message);
        },
        title: const Text("Chia sẻ"),
      ));
      if (message["loai"] == 0) {
        list.add(ListTile(
          leading: const Icon(
            MaterialCommunityIcons.content_copy,
            color: Colors.blue,
          ),
          onTap: () {
            Navigator.of(context).pop();
            copyMessage(context, message);
          },
          title: const Text("Sao chép"),
        ));
      } else if (message["loai"] == 1 || message["loai"] == 2) {
        // list.add(ListTile(
        //   leading: const Icon(
        //     AntDesign.download,
        //     color: Colors.blue,
        //   ),
        //   onTap: () {
        //     Navigator.of(context).pop();
        //     downloadFile(message);
        //   },
        //   title: const Text("Tải xuống"),
        // ));
      }
    }
    if (list.isNotEmpty) {
      showModalBottomSheet(
          context: context,
          builder: (BuildContext context) {
            return SizedBox(
              height: message["IsMe"] ? 310 : 200,
              child: SingleChildScrollView(
                child: ListBody(
                  children: list,
                ),
              ),
            );
          });
    }
  }

  void editMessage(context, message) {
    //FocusScope.of(context).requestFocus(focus);
    controllers = TextEditingController(text: message["noiDung"]);
    send.value = true;
    edit.value = true;
    messageEdit.value = message;

    isQuate.value = false;
  }

  void showQuate(context, message) {
    isQuate.value = true;
    messageQuate.value = message;

    edit.value = false;
  }

  void hideQuate(context) {
    if (MediaQuery.of(context).viewInsets.bottom > 0) {
      dismissKeybroad(context);
    }
    isQuate.value = false;
    messageQuate.value = {};
  }

  void showForward(context, message) {
    dynamic arguments = message;
    arguments.removeWhere((key, value) => key == "CountReply");
    arguments.removeWhere((key, value) => key == "Comments");
    arguments.removeWhere((key, value) => key == "ParentComment");
    arguments.removeWhere((key, value) => key == "seens");
    Get.toNamed("sharemessage", arguments: arguments);
  }

  void showEmoij(context) {
    if (MediaQuery.of(context).viewInsets.bottom > 0) {
      dismissKeybroad(context);
      isEmoij.value = !isEmoij.value;
    } else {
      isEmoij.value = !isEmoij.value;
    }
  }

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
      "ChatID": chatController.chatFocus.value["ChatID"],
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

  void upLoadFile(ms) async {
    EasyLoading.show(status: 'Đang tải lên...');
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
        "ChatID": ms["ChatID"],
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
      dioform.FormData formData =
          dioform.FormData.fromMap({"model": strbody, "files": files});
      Dio dio = Dio();
      dio.options.headers["Authorization"] = "Bearer ${Golbal.store.token}";
      dio.options.followRedirects = true;
      var response = await dio
          .put("${Golbal.congty!.api}/api/Chat/Update_Message", data: formData);
      var data = response.data;
      EasyLoading.dismiss();
      if (data["err"] == "1") {
        EasyLoading.showError("Có lỗi xảy ra, vui lòng thử lại!");
        return;
      }

      //Realtime
      body["MessageID"] = data["messageID"];
      body["tenFile"] = data["tenFile"] ?? "";
      body["duongDan"] = data["duongDan"] ?? "";
      Golbal.socket.emit('sendData', body);
      //End realtime

      ms["ngayGuiOld"] = ms["ngayGui"];
      ms["sdate"] = false;
      if (message_datas.length > 1) {
        var minutes = (DateTime.parse(ms["ngayGuiOld"])
                .difference(DateTime.parse(
                    message_datas[message_datas.length - 1]["ngayGuiOld"]))
                .inMinutes)
            .abs();
        if (minutes > 1440) {
          ms["sdate"] = true;
          ms["startdate"] = ms["ngayGuiOld"];
        }
      }

      ms["MessageID"] = data["messageID"];
      ms["tenFile"] = data["tenFile"] ?? "";
      ms["duongDan"] = data["duongDan"] ?? "";
      ms["ngayGui"] = Golbal.timeAgo(ms["ngayGui"]);
      ms["IsMe"] = true;
      ms["showImage"] = false;
      message_datas.insert(message_datas.length, ms);
      var m = message_datas
          .where((e) => e != null && e["uuid"] == ms["uuid"])
          .toList();
      if (m.isNotEmpty) {
        if (data["error"] == 0) {
          m[0]["trangThai"] = 1;
        } else {
          m[0]["trangThai"] = -1;
        }
      }

      send.value = false;
      sendding.value = false;
      scroolBottom();
    } catch (e) {
      EasyLoading.dismiss();
      if (kDebugMode) {
        print(e);
      }
    }
  }

  void sendSMS() async {
    if (sendding.value == true) {
      EasyLoading.showToast(
          "Đang gửi tin nhắn, bạn vui lòng thao tác chậm lại!");
    }
    if (send.value && !sendding.value) {
      try {
        sendding.value = true;
        String uid = uuid.v1();
        var ms = {};
        if (edit.value) {
          ms = {
            "uuid": uid,
            "ChatID": chatController.chatFocus.value["ChatID"],
            "user_id": Golbal.store.user["user_id"],
            "nguoiGui": Golbal.store.user["user_id"],
            "MessageID": messageEdit["MessageID"],
            "noiDung": controllers.text,
            "isAdd": false,
            "event": "getEditMessage",
          };
        } else {
          ms = {
            "uuid": uid,
            "ChatID": chatController.chatFocus.value["ChatID"],
            "user_id": Golbal.store.user["user_id"],
            "nguoiGui": Golbal.store.user["user_id"],
            "noiDung": controllers.text,
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
          if (isQuate.value) {
            ms["ParentID"] = messageQuate["MessageID"];
          }
        }
        var strbody = json.encode(ms);
        dioform.FormData formData =
            dioform.FormData.fromMap({"model": strbody});
        Dio dio = Dio();
        dio.options.headers["Authorization"] = "Bearer ${Golbal.store.token}";
        dio.options.followRedirects = true;
        var response = await dio.put(
            "${Golbal.congty!.api}/api/Chat/Update_Message",
            data: formData);
        var data = response.data;
        if (data["err"] == "1") {
          return;
        }

        //Realtime
        ms["MessageID"] = data["messageID"];
        ms["tenFile"] = data["tenFile"] ?? "";
        ms["duongDan"] = data["duongDan"] ?? "";
        Golbal.socket.emit('sendData', ms);

        var u = {
          "user_id": Golbal.store.user["user_id"],
          "nguoiGui": Golbal.store.user["user_id"],
          "FullName": Golbal.store.user["FullName"],
          "fname": Golbal.store.user["fname"],
          "Avartar": Golbal.store.user["Avartar"],
          "ChatID": data["ChatID"],
          "typing": false,
          "event": "typing",
          "socketid": Golbal.socket.id,
        };
        Golbal.socket.emit('sendData', u);
        //End Realtime

        if (edit.value) {
          var idx = message_datas
              .indexWhere((e) => e["MessageID"] == messageEdit["MessageID"]);
          message_datas[idx]["noiDung"] = controllers.text;
          if (idx == message_datas.length - 1) {
            chatcardController.initData(false);
            chatgroupcardController.initData(false);
          }
        } else {
          ms["ngayGuiOld"] = ms["ngayGui"];
          ms["sdate"] = false;
          if (message_datas.length > 1) {
            var minutes = (DateTime.parse(ms["ngayGuiOld"])
                    .difference(DateTime.parse(
                        message_datas[message_datas.length - 1]["ngayGuiOld"]))
                    .inMinutes)
                .abs();
            if (minutes > 1440) {
              ms["sdate"] = true;
              ms["startdate"] = ms["ngayGuiOld"];
            }
          }
          ms["ngayGui"] = Golbal.timeAgo(ms["ngayGui"]);
          ms["IsMe"] = true;
          ms["showImage"] = false;
          message_datas.insert(message_datas.length, ms);

          for (var ms in message_datas) {
            ms["CountReply"] = [];
            ms["CountReply"] = message_datas
                .where((x) => x["ParentID"] == ms["MessageID"])
                .toList();
            if (ms["ParentID"] != null && ms["ParentID"] != "") {
              ms["Comments"] = message_datas
                  .where((x) => x["ParentID"] == ms["MessageID"])
                  .toList();
              ms["ParentComment"] = message_datas.firstWhere(
                  (x) => x["MessageID"] == ms["ParentID"],
                  orElse: () => null);
            }
          }

          var m = message_datas
              .where((e) => e != null && e["uuid"] == uid)
              .toList();
          if (m.isNotEmpty) {
            if (data["err"] == 0) {
              m[0]["trangThai"] = 1;
            } else {
              m[0]["trangThai"] = -1;
            }
          }

          chatcardController.initData(false);
          chatgroupcardController.initData(false);
          scroolBottom();
        }

        edit.value = false;
        messageEdit.value = {};
        isQuate.value = false;
        messageQuate.value = {};
        controllers.text = "";
        send.value = false;
        sendding.value = false;
      } catch (e) {
        if (kDebugMode) {
          print(e);
        }
      }
    }
  }

  void initMultiPickUp(mounted) async {
    images = [];
    List<XFile>? resultList = [];
    try {
      // resultList = await MultiImagePicker.pickImages(
      //   enableCamera: true,
      //   maxImages: 10,
      // );
      resultList = await _picker.pickMultiImage();
    } catch (e) {}

    if (!mounted) return;

    if (resultList != null && resultList.isNotEmpty) {
      images = resultList;
      bindFilesChat(mounted);
    }
  }

  void bindFilesChat(mounted) async {
    rootFilepath = "/Portals/" +
        Golbal.store.user["organization_id"] +
        "/SChat/" +
        Golbal.store.user["user_id"] +
        "/" +
        DateTimeFormat.format(now, format: 'd-m-Y') +
        "/";
    sendding.value = true;
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
          "ChatID": chatController.chatFocus.value["ChatID"],
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

        scroolBottom();

        compressImage(mounted, ms);
      }
    } else if (_image != null) {
      uid = uuid.v1();
      int len = await _image.length();
      var ms = {
        "uuid": uid,
        "ChatID": chatController.chatFocus.value["ChatID"],
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

      scroolBottom();

      compressImage(mounted, ms);
    }
  }

  void compressImage(mounted, ms) async {
    ms["filecompress"] = await comp.takePicture(ms["file"]);
    ms["compress"] = true;
    if (mounted) {
      upLoadFile(ms);
    }
  }

  void copyMessage(context, message) {
    //FocusScope.of(context).requestFocus(focus);
    controllers = TextEditingController(text: message["noiDung"]);
    send.value = true;
  }

  void reply(context, message) {
    EasyLoading.showToast("Chức năng này đang được phát triển!");
    // FocusScope.of(context).requestFocus(_focus);
    // message = r;
    // setState(() {
    //   message["quote"] = true;
    // });
  }

  void deleteComment(context, message) {
    showDialog(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            content: SingleChildScrollView(
              child: ListBody(
                children: const <Widget>[
                  Text("Bạn có muốn xóa tin nhắn này không?"),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('Có'),
                onPressed: () async {
                  int idx = message_datas.indexOf(message);
                  if (idx != -1) {
                    message_datas.removeAt(idx);
                  }
                  Navigator.of(context).pop();
                  try {
                    var body = {
                      "ChatID": chatController.chatFocus.value["ChatID"],
                      "MessageID": message["MessageID"],
                      "user_id": Golbal.store.user["user_id"],
                      "nguoiGui": Golbal.store.user["user_id"],
                      "event": "getDelMessage",
                      "socketid": Golbal.socket.id,
                    };
                    Dio dio = Dio();
                    dio.options.headers["Authorization"] =
                        "Bearer ${Golbal.store.token}";
                    dio.options.followRedirects = true;
                    var response = await dio.put(
                        "${Golbal.congty!.api}/api/Chat/Delete_Message",
                        data: body);
                    var data = response.data;
                    if (data["err"] == "1") {
                      EasyLoading.showToast("Có lỗi xảy ra, vui lòng thử lại!");
                      message_datas.insert(idx, message);
                      return;
                    }

                    //Realtime
                    Golbal.socket.emit('sendData', body);
                    //End Realtime

                    if (idx == message_datas.length) {
                      chatcardController.initData(false);
                      chatgroupcardController.initData(false);
                    }
                  } catch (e) {
                    message_datas.insert(idx, message);
                    if (kDebugMode) {
                      print(e);
                    }
                  }
                },
              ),
              TextButton(
                child: const Text('Không'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }

  void goInfoChat(chat) async {
    Get.toNamed("infochat", arguments: {
      "ChatID": chat["ChatID"] ?? "",
    });
  }

  Future<void> downloadFile(message) async {
    // Dio dio = Dio();
    // try {
    //   EasyLoading.show(status: "Tải file $progressString");
    //   var dir = await getApplicationDocumentsDirectory();
    //   await dio.download(
    //       "${Golbal.congty!.fileurl}${message["duongDan"] ?? ""}",
    //       "${dir.path}/${message["tenFile"] ?? "filename.jpg"}",
    //       onReceiveProgress: (rec, total) {
    //     downloading.value = true;
    //     progressString.value = ((rec / total) * 100).toStringAsFixed(0) + "%";
    //   });
    // } catch (e) {
    //   EasyLoading.showError('Đường dẫn file không tồn tại!');
    //   if (kDebugMode) {
    //     print(e);
    //   }
    // }
    // downloading.value = false;
    // EasyLoading.showSuccess("Tải xuống thành công");

    // downloading.value = true;
    // EasyLoading.show(status: "Tải file $progressString");
    // if (message["loai"] == 1) {
    //   bool downloaded = await saveImage(
    //       "${Golbal.congty!.fileurl}${message["duongDan"] ?? ""}",
    //       "${message["tenFile"] ?? "filename.jpg"}");
    //   if (downloaded) {
    //   } else {
    //     EasyLoading.showError('Đường dẫn file không tồn tại!');
    //     return;
    //   }
    // } else {
    //   bool downloaded = await saveFile(
    //       "${Golbal.congty!.fileurl}${message["duongDan"] ?? ""}",
    //       "${message["tenFile"] ?? "filename.jpg"}");
    //   if (downloaded) {
    //   } else {
    //     EasyLoading.showError('Đường dẫn file không tồn tại!');
    //     return;
    //   }
    // }
    // downloading.value = false;
    // EasyLoading.showSuccess("Tải xuống thành công");

    loadFile(message["duongDan"]);
  }

  Future<bool> saveImage(String url, String fileName) async {
    Dio dio = Dio();
    Directory directory;
    try {
      if (Platform.isAndroid == true) {
        directory = (await getExternalStorageDirectory())!;
        String newPath = "";
        List<String> paths = directory.path.split("/");
        for (int x = 1; x < paths.length; x++) {
          String folder = paths[x];
          if (folder != "Android") {
            newPath += "/" + folder;
          } else {
            break;
          }
        }
        newPath = newPath + "/SOE";
        directory = Directory(newPath);
      } else {
        directory = await getTemporaryDirectory();
      }
      File saveFile = File("${directory.path}/" + fileName);
      if (!await directory.exists()) {
        await directory.create(recursive: true);
      }
      if (await directory.exists()) {
        await dio.download(url, saveFile.path, onReceiveProgress: (rec, total) {
          downloading.value = true;
          progressString.value = ((rec / total) * 100).toStringAsFixed(0) + "%";
        });
        if (Platform.isIOS) {
          await ImageGallerySaver.saveFile(saveFile.path,
              isReturnPathOfIOS: true);
        }
        return true;
      }
      return false;
    } catch (e) {
      if (kDebugMode) {
        print(e);
        return false;
      }
    }
    return true;
  }

  Future<bool> saveFile(String url, String fileName) async {
    Dio dio = Dio();
    Directory directory;
    try {
      if (Platform.isAndroid == true) {
        directory = (await getExternalStorageDirectory())!;
        String newPath = "";
        List<String> paths = directory.path.split("/");
        for (int x = 1; x < paths.length; x++) {
          String folder = paths[x];
          if (folder != "Android") {
            newPath += "/" + folder;
          } else {
            break;
          }
        }
        newPath = newPath + "/SOE";
        directory = Directory(newPath);
      } else {
        directory = await getApplicationDocumentsDirectory();
      }
      File saveFile = File("${directory.path}/" + fileName);
      if (await directory.exists()) {
        var response = await dio.get(
          url,
          onReceiveProgress: (rec, total) {
            downloading.value = true;
            progressString.value =
                ((rec / total) * 100).toStringAsFixed(0) + "%";
          },
          options: Options(
            responseType: ResponseType.bytes,
            followRedirects: false,
            //receiveTimeout: 0,
          ),
        );
        var file = saveFile.openSync(mode: FileMode.write);
        file.writeFromSync(response.data);
        await file.close();

        openFileMobile(url);
        //final pfile = await pickFile();
        return true;
      }
      return false;
    } catch (e) {
      if (kDebugMode) {
        print(e);
        return false;
      }
    }
    return true;
  }

  loadFile(link) async {
    if (link != null) {
      if (defaultTargetPlatform == TargetPlatform.android ||
          defaultTargetPlatform == TargetPlatform.iOS) {
        String url =
            Golbal.congty!.fileurl + link.toString().replaceAll("\\", "/");
        if (defaultTargetPlatform == TargetPlatform.iOS &&
            link.toString().toLowerCase().contains(".pdf")) {
          !await launchUrl(Uri.parse(url),
              mode: LaunchMode.inAppWebView, webOnlyWindowName: "Xem tài liệu");
        } else {
          openFileMobile(url);
        }
      } else {
        String viewUrl = Golbal.congty!.fileurl + "/Viewer/Index?url=" + link;
        !await launchUrl(Uri.parse(viewUrl),
            mode: LaunchMode.inAppWebView, webOnlyWindowName: "Xem tài liệu");
      }
    }
  }

  openFileMobile(url) async {
    String filename = url;
    Directory tempDir = await getTemporaryDirectory();
    String type = filename.substring(filename.lastIndexOf(".")).trim();
    filename = filename.substring(0, filename.lastIndexOf(".")).trim();
    filename = filename.replaceAll(" ", "").replaceAll(".", "_") + type;
    String filePath = tempDir.path + "/" + filename;
    EasyLoading.show(
      status: "Đang hiển thị file ...",
    );
    Dio dio = Dio();
    dio.options.headers["Authorization"] = "Bearer ${Golbal.store.token}";
    dio.options.followRedirects = true;
    try {
      await dio.download(url, filePath);
      await OpenAppFile.open(filePath);
    } catch (e) {}
    EasyLoading.dismiss();
  }

  Future<File?> pickFile() async {
    final result = await FilePicker.platform.pickFiles();
    if (result == null) return null;

    return File(result.files.first.path!);
  }

  Future<bool> _requestPermission(Permission permission) async {
    if (await permission.isGranted) {
      return true;
    } else {
      var result = await permission.request();
      if (result == PermissionStatus.granted) {
        return true;
      }
    }
    return false;
  }

  @override
  void onInit() {
    super.onInit();
    chat.value = Get.arguments;
    message_datas.value = [];
    facebookReactions = [
      Reaction(
        id: 1,
        value: 1,
        previewIcon: _buildPreviewIconFacebook('assets/like/like.gif'),
        icon: _buildIconFacebook(
          'assets/like/like_fill.png',
          const Text(
            '',
            style: TextStyle(
              color: Color(0XFF3b5998),
            ),
          ),
        ),
      ),
      Reaction(
        id: 2,
        value: 2,
        previewIcon: _buildPreviewIconFacebook('assets/like/love.gif'),
        icon: _buildIconFacebook(
          'assets/like/love.png',
          const Text(
            '',
            style: TextStyle(
              color: Color(0XFFed5168),
            ),
          ),
        ),
      ),
      Reaction(
        id: 3,
        value: 3,
        previewIcon: _buildPreviewIconFacebook('assets/like/wow.gif'),
        icon: _buildIconFacebook(
          'assets/like/wow.png',
          const Text(
            '',
            style: TextStyle(
              color: Color(0XFFffda6b),
            ),
          ),
        ),
      ),
      Reaction(
        id: 4,
        value: 4,
        previewIcon: _buildPreviewIconFacebook('assets/like/haha.gif'),
        icon: _buildIconFacebook(
          'assets/like/haha.png',
          const Text(
            '',
            style: TextStyle(
              color: Color(0XFFffda6b),
            ),
          ),
        ),
      ),
      Reaction(
        id: 5,
        value: 5,
        previewIcon: _buildPreviewIconFacebook('assets/like/sad.gif'),
        icon: _buildIconFacebook(
          'assets/like/sad.png',
          const Text(
            '',
            style: TextStyle(
              color: Color(0XFFffda6b),
            ),
          ),
        ),
      ),
      Reaction(
        id: 6,
        value: 6,
        previewIcon: _buildPreviewIconFacebook('assets/like/angry.gif'),
        icon: _buildIconFacebook(
          'assets/like/angry.png',
          const Text(
            '',
            style: TextStyle(
              color: Color(0XFFf05766),
            ),
          ),
        ),
      ),
    ];
    initData();
  }

  void initData() async {
    loading.value = true;
    //EasyLoading.show(status: "loading...");
    if (chat["type"] == true) {
      try {
        var body = {
          "user_id": Golbal.store.user["user_id"],
          "nguoiChat": chat["NhanSu_ID"],
        };
        Dio dio = Dio();
        dio.options.headers["Authorization"] = "Bearer ${Golbal.store.token}";
        dio.options.followRedirects = true;
        var response = await dio.put("${Golbal.congty!.api}/api/Chat/New_Chat",
            data: body);
        var data = response.data;
        if (data["err"] == "1") {
          EasyLoading.showError("Có lỗi xảy ra, vui lòng thử lại!");
          return;
        }
        if (data != null) {
          chat.value = json.decode(data["data"])[0];
          //
          if (chat["ngayGui"] != null) {
            chat["ngayGui"] = Golbal.timeAgo(chat["ngayGui"]);
          }
          if (chat["members"] != null) {
            chat["members"] = json.decode(chat["members"]);
          }

          chatController.chatFocus.value = chat;

          //
          var idx1 = chatcardController.datas
              .indexWhere((e) => e["ChatID"] == chat["ChatID"]);
          if (idx1 != -1) {
            chatcardController.datas[idx1]["chuaDoc"] = 0;
            chatcardController.datas.refresh();
          }
          var idx2 = chatgroupcardController.datas
              .indexWhere((e) => e["ChatID"] == chat["ChatID"]);
          if (idx2 != -1) {
            chatgroupcardController.datas[idx2]["chuaDoc"] = 0;
            chatgroupcardController.datas.refresh();
          }
          initMessage();
        }
      } catch (e) {
        EasyLoading.dismiss();
        EasyLoading.showError("Có lỗi xảy ra!");
        loading.value = false;
        if (kDebugMode) {
          print(e);
        }
      }
    } else {
      try {
        var body = {
          "user_id": Golbal.store.user["user_id"],
          "ChatID": chat["ChatID"],
        };
        Dio dio = Dio();
        dio.options.headers["Authorization"] = "Bearer ${Golbal.store.token}";
        dio.options.followRedirects = true;
        var response = await dio.put("${Golbal.congty!.api}/api/Chat/Get_Chat",
            data: body);
        var data = response.data;
        if (data["err"] == "1") {
          EasyLoading.showError("Có lỗi xảy ra, vui lòng thử lại!");
          return;
        }
        if (data != null) {
          data["data"] = json.decode(data["data"]);
          if (data["data"].length == 0) {
            Get.back(result: true);
            return;
          }
          chat.value = data["data"][0];
          //
          if (chat["ngayGui"] != null) {
            chat["ngayGui"] = Golbal.timeAgo(chat["ngayGui"]);
          }
          if (chat["members"] != null) {
            chat["members"] = json.decode(chat["members"]);
          }

          chatController.chatFocus.value = chat;

          //
          chat["isOnline"] = chatController.connected_datas.firstWhere(
                  (e) => (e["user_id"] == chat["NhanSu_ID"] &&
                      e["userStatus"] == true),
                  orElse: () => null) !=
              null;

          dynamic exist = chatController.connected_datas.firstWhere(
              (e) =>
                  e["user_id"] == chat["NhanSu_ID"] &&
                  e["connections"].length > 0,
              orElse: () => null);

          chat["lastOnline"] = null;
          if (exist != null) {
            var connections = exist["connections"];
            List<DateTime> dateTimes = [];
            for (var cn in connections) {
              var time = DateTime.parse(cn["time"]);
              dateTimes.add(time);
            }
            dateTimes.sort((a, b) => a.compareTo(b));

            chat["lastOnline"] = Golbal.timeAgo(dateTimes.first);
          }

          //
          var idx1 = chatcardController.datas
              .indexWhere((e) => e["ChatID"] == chat["ChatID"]);
          if (idx1 != -1) {
            chatcardController.datas[idx1]["chuaDoc"] = 0;
            chatcardController.datas.refresh();
          }
          var idx2 = chatgroupcardController.datas
              .indexWhere((e) => e["ChatID"] == chat["ChatID"]);
          if (idx2 != -1) {
            chatgroupcardController.datas[idx2]["chuaDoc"] = 0;
            chatgroupcardController.datas.refresh();
          }
          initMessage();
        }
      } catch (e) {
        EasyLoading.dismiss();
        loading.value = false;
        if (kDebugMode) {
          print(e);
        }
        Get.back(result: true);
      }
    }
  }

  void initMessage() {
    loadMessage(true);
    loadMember();
  }

  void loadMessage(f) async {
    //EasyLoading.show();
    try {
      if (f) {
        loading.value = true;
      }
      var body = {
        "chat_id": chat["ChatID"],
        "user_id": Golbal.store.user["user_id"],
        "p": page.value,
        "pz": perpage.value,
        "s": message_search,
      };
      Dio dio = Dio();
      dio.options.headers["Authorization"] = "Bearer ${Golbal.store.token}";
      dio.options.followRedirects = true;
      var response = await dio
          .post("${Golbal.congty!.api}/api/Chat/Get_Message", data: body);
      var data = response.data;
      if (data["err"] == "1") {
        EasyLoading.dismiss();
        EasyLoading.showError("Có lỗi xảy ra, vui lòng thử lại!");
        if (kDebugMode) {
          print(data);
        }
        return;
      }
      if (data != null) {
        data = json.decode(data["data"]);
        var tbs = data[0];
        if (tbs != null && tbs.length > 0) {
          for (var i = 0; i < tbs.length; i++) {
            tbs[i]["sdate"] = false;
            if (i > 0) {
              var minutes = (DateTime.parse(tbs[i]["ngayGui"])
                      .difference(DateTime.parse(tbs[i - 1]["ngayGui"]))
                      .inMinutes)
                  .abs();
              if (minutes > 1440) {
                tbs[i]["sdate"] = true;
                tbs[i]["startdate"] = Golbal.timeAgo(tbs[i]["ngayGui"]);
              }
            }
          }
          for (var m in tbs) {
            m["ngayGuiOld"] = m["ngayGui"];
            m["ngayGui"] = Golbal.timeAgo(m["ngayGui"]);
            m["CountReply"] = [];
            m["CountReply"] =
                tbs.where((x) => x["ParentID"] == m["MessageID"]).toList();
            if (m["ParentID"] != null && m["ParentID"] != "") {
              m["Comments"] =
                  tbs.where((x) => x["ParentID"] == m["MessageID"]).toList();
              m["ParentComment"] = tbs.firstWhere(
                  (x) => x["MessageID"] == m["ParentID"],
                  orElse: () => null);
            }
          }
          var reverse = tbs.reversed.toList();
          for (var i = 0; i < reverse.length; i++) {
            reverse[i]["showImage"] = (reverse[i]["IsMe"] != true &&
                (i == 0 ||
                    (i > 0 &&
                        reverse[i]["nguoiGui"] != reverse[i - 1]["nguoiGui"]) ||
                    (reverse[i - 1]["nguoiGui"] ==
                        Golbal.store.user["user_id"])));
          }
          message_datas.value = reverse;
          if (f) {
            scroolBottom();
          } else {
            // SchedulerBinding.instance.addPostFrameCallback((_) {
            //   scrollController
            //       .jumpTo(scrollController.position.maxScrollExtent);
            // });
          }
        } else {
          message_datas.value = [];
        }
        count_message.value = data[1][0]["c"];
      }
      loading.value = false;
      EasyLoading.dismiss();
    } catch (e) {
      EasyLoading.dismiss();
      EasyLoading.showError("Có lỗi xảy ra!");
      loading.value = false;
      if (kDebugMode) {
        print(e);
      }
    }
  }

  void loadMember() async {
    try {
      var body = {
        "user_id": Golbal.store.user["user_id"],
        "ChatID": chat["ChatID"],
      };
      Dio dio = Dio();
      dio.options.headers["Authorization"] = "Bearer ${Golbal.store.token}";
      dio.options.followRedirects = true;
      var response = await dio
          .post("${Golbal.congty!.api}/api/Chat/Get_MemberByChat", data: body);
      var data = response.data;
      if (data["err"] == "1") {
        EasyLoading.dismiss();
        EasyLoading.showError("Có lỗi xảy ra, vui lòng thử lại!");
        return;
      }
      if (data != null) {
        var tbs = json.decode(data["data"]);
        if (tbs != null && tbs.length > 0) {
          members_data.value = tbs;
        } else {
          members_data.value = [];
        }
      }
    } catch (e) {
      EasyLoading.dismiss();
      EasyLoading.showError("Có lỗi xảy ra!");
      loading.value = false;
      if (kDebugMode) {
        print(e);
      }
    }
  }

  void initSocketDataMessage(data) {
    if (chatController.connected_datas != null &&
        chatController.connected_datas.isNotEmpty &&
        chatcardController.datas != null &&
        chatcardController.datas.isNotEmpty) {
      var exist = chatcardController.datas.indexWhere((a) =>
              a["ChatID"] == data["ChatID"] &&
              data["ChatID"] == chat["ChatID"] &&
              List.castFrom(chatController.connected_datas)
                  .where((a) =>
                          (a["user_id"] != data["nguoiGui"] ||
                              (a["user_id"] == data["nguoiGui"] &&
                                  a["socketid"] == Golbal.socket.id &&
                                  data["socketid"] != Golbal.socket.id)) &&
                          a["user_id"] == Golbal.store.user["user_id"]
                      //&& a["userStatus"] == true
                      )
                  .toList()
                  .isNotEmpty) !=
          -1;
      if (exist) {
        switch (data["event"]) {
          case "typing":
            user_id.value = data["user_id"];
            if (!streamTypeController.isClosed && !first.value) {
              streamTypeController.add(data["typing"]);
            }
            first.value = false;
            break;
          case "getSendMessage":
            if (data["ngayGui"].length > 5) {
              data["ngayGuiOld"] = data["ngayGui"];
              data["ngayGui"] = Golbal.timeAgo(data["ngayGui"]);
            }
            data["sdate"] = false;
            if (message_datas.length > 1) {
              var minutes = (DateTime.parse(data["ngayGuiOld"])
                      .difference(DateTime.parse(
                          message_datas[message_datas.length - 1]
                              ["ngayGuiOld"]))
                      .inMinutes)
                  .abs();
              if (minutes > 1440) {
                data["sdate"] = true;
                data["startdate"] = data["ngayGuiOld"];
              }
            }
            data["IsMe"] = false;
            if (data["anhThumb"] != null && data["anhThumb"] != "") {
              data["anhThumb"] = data["anhThumb"];
            }
            data["showImage"] = false;
            if (message_datas == null || message_datas.isEmpty) {
              data["showImage"] = true;
            } else if (message_datas.isNotEmpty) {
              if (message_datas[message_datas.length - 1]["nguoiGui"] !=
                  data["nguoiGui"]) {
                data["showImage"] = true;
              }
            }
            message_datas.insert(message_datas.length, data);

            for (var ms in message_datas) {
              ms["CountReply"] = [];
              ms["CountReply"] = message_datas
                  .where((x) => x["ParentID"] == ms["MessageID"])
                  .toList();
              if (ms["ParentID"] != null && ms["ParentID"] != "") {
                ms["Comments"] = message_datas
                    .where((x) => x["ParentID"] == ms["MessageID"])
                    .toList();
                ms["ParentComment"] = message_datas.firstWhere(
                    (x) => x["MessageID"] == ms["ParentID"],
                    orElse: () => null);
              }
            }
            scroolBottom();
            seenMessage();
            break;
          case "getEditMessage":
            var idx = message_datas
                .indexWhere((e) => e["MessageID"] == data["MessageID"]);
            if (idx != -1) {
              message_datas[idx]["noiDung"] = data["noiDung"];
              message_datas.refresh();
            }
            break;
          case "getDelMessage":
            var idx = message_datas
                .indexWhere((e) => e["MessageID"] == data["MessageID"]);
            if (idx != -1) {
              message_datas.removeAt(idx);
            }
            break;
          case "getStick":
            var idx = message_datas
                .indexWhere((e) => e["MessageID"] == data["MessageID"]);
            if (idx != -1) {
              message_datas[idx]["StickID"] = data["StickID"];
            }
            message_datas.refresh();
            break;
        }
      }
    }
  }
}
