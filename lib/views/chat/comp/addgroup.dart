// ignore_for_file: unnecessary_null_comparison

import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:dio/dio.dart' as dioform;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:soe/utils/Config.dart';
import 'package:soe/utils/golbal/golbal.dart';
import 'package:soe/views/chat/comp/contact.dart';
import 'package:soe/views/chat/controller/chatcontroller.dart';
import 'package:soe/views/chat/controller/chatgroup/chatgroupcontroller.dart';
import 'package:soe/views/chat/controller/messenger/chatcardcontroller.dart';

class AddGroup extends StatefulWidget {
  final ChatController chatController = Get.put(ChatController());
  final ChatCardController chatcardController = Get.put(ChatCardController());
  final ChatGroupController chatgroupController =
      Get.put(ChatGroupController());

  final String? id;

  AddGroup({Key? key, this.id}) : super(key: key);

  @override
  _AddGroupState createState() {
    return _AddGroupState();
  }
}

class _AddGroupState extends State<AddGroup> {
  TextEditingController? tc;
  FocusNode fc = FocusNode();
  List chons = [];
  String tenNhom = "";
  String initialValue = "";
  bool loadding = true;
  _AddGroupState();
  @override
  void initState() {
    super.initState();
    if (widget.id == null) {
      loadding = false;
    }
    //Golbal.page = "AddGroup";
    tc = TextEditingController();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (widget.id != null) {
        getChatGroup();
        loadMembers();
      }
    });
  }

  void loadMembers() async {
    try {
      var body = {
        "user_id": Golbal.store.user["user_id"],
        "ChatID": widget.id,
      };
      Dio dio = Dio();
      dio.options.headers["Authorization"] = "Bearer ${Golbal.store.token}";
      dio.options.followRedirects = true;
      var response = await dio
          .post("${Golbal.congty!.api}/api/Chat/Get_MemberByChat", data: body);
      var data = response.data;
      if (data["err"] == "1") {
        EasyLoading.showError("Có lỗi xảy ra, vui lòng thử lại!");
        return;
      }
      if (data != null) {
        var tbs = json.decode(data["data"]);
        if (mounted) {
          for (var item in tbs) {
            if (item["ngayThamgia"] != null) {
              item["ngayThamgia"] = Golbal.timeAgo(item["ngayThamgia"]);
            }
            if (item["ngayThoat"] != null) {
              item["ngayThoat"] = Golbal.timeAgo(item["ngayThoat"]);
            }
          }
          chons = tbs;
        }
      }
    } catch (e) {
      EasyLoading.showError("Có lỗi xảy ra!");
      if (kDebugMode) {
        print(e);
      }
    }
  }

  void getChatGroup() async {
    try {
      var body = {
        "user_id": Golbal.store.user["user_id"],
        "ChatID": widget.id,
      };
      Dio dio = Dio();
      dio.options.headers["Authorization"] = "Bearer ${Golbal.store.token}";
      dio.options.followRedirects = true;
      var response = await dio
          .post("${Golbal.congty!.api}/api/Chat/Get_ChatGroup", data: body);
      var data = response.data;
      if (data["err"] == "1") {
        EasyLoading.showError("Có lỗi xảy ra, vui lòng thử lại!");
        return;
      }
      if (data != null) {
        var tbs = json.decode(data["data"]);
        if (tbs != null && tbs.length > 0) {
          tenNhom = tbs["tenNhom"];
          List<String> ids = [];
          ids.add(tbs["nguoiLap"]);
          if (tbs["mtop"] != null && tbs["mtop"].length > 0) {
            tbs["mtop"] = json.decode(tbs["mtop"]);
            List.castFrom(tbs["mtop"]).forEach((e) {
              if (!ids.contains(e["nguoiThamGia"])) ids.add(e["nguoiThamGia"]);
            });
          }
          if (mounted) {
            tc = TextEditingController(text: tenNhom);
            initialValue = ids.join(",");
            loadding = false;
          }
        }
      }
    } catch (e) {
      EasyLoading.showError("Có lỗi xảy ra!");
      if (kDebugMode) {
        print(e);
      }
    }
  }

  // initVL() {
  //   String str = "";
  //   for (var u in chons) {
  //     str += u["nhanSuID"] + ",";
  //   }
  //   setState(() {
  //     initialValue = str;
  //   });
  // }

  void addChatGroup() async {
    if (tenNhom == null || tenNhom == "") {
      EasyLoading.showError("Vui lòng nhập tên nhóm!");
      return;
    }
    if (chons.isEmpty) {
      EasyLoading.showError("Bạn chưa thêm người dùng vào nhóm!");
      return;
    }
    EasyLoading.show(status: 'loading...');
    var chat = {
      "ChatID": -1,
      "nguoiChat": Golbal.store.user["user_id"],
      "tenNhom": tenNhom,
      "loaiNhom": 0,
      "ngayLap": DateTime.now().toIso8601String(),
      "nguoiLap": Golbal.store.user["user_id"],
      "trangThai": 1,
      "ngayCapNhat": DateTime.now().toIso8601String(),
      "nhom": true
    };
    var members = [];
    members.add({
      "nguoiThamGia": Golbal.store.user["user_id"],
      "ngayThamgia": DateTime.now().toIso8601String(),
      "ngayThoat": DateTime.now().toIso8601String(),
      "trangThai": 1,
      "chuaDoc": 0,
      "chuNhom": true,
      "ghim": false,
      "thuTuGhim": 1,
      "baoTinNhan": true
    });
    for (var u
        in chons.where((m) => m["NhanSu_ID"] != Golbal.store.user["user_id"])) {
      members.add({
        "nguoiThamGia": u["NhanSu_ID"],
        "ngayThamgia": DateTime.now().toIso8601String(),
        "ngayThoat": DateTime.now().toIso8601String(),
        "trangThai": 1,
        "chuaDoc": 0,
        "chuNhom": false,
        "ghim": false,
        "thuTuGhim": 1,
        "baoTinNhan": true
      });
    }

    try {
      var body = {
        "user_id": Golbal.store.user["user_id"],
        "chat": chat,
        "members": members,
        "event": "getAddChat",
        "socketid": Golbal.socket.id,
      };
      var strbody = json.encode(body);
      dioform.FormData formData = dioform.FormData.fromMap({"models": strbody});
      Dio dio = Dio();
      dio.options.headers["Authorization"] = "Bearer ${Golbal.store.token}";
      dio.options.followRedirects = true;
      var response = await dio.put(
          "${Golbal.congty!.api}/api/Chat/Update_ChatGroup",
          data: formData);
      var data = response.data;
      if (data["err"] == "1") {
        EasyLoading.showError("Có lỗi xảy ra, vui lòng thử lại!");
        return;
      }

      //Realtime
      Golbal.socket.emit('sendData', body);
      //End realtime

      Navigator.pop(context);
      EasyLoading.dismiss();
      EasyLoading.showSuccess("Bạn vừa thêm nhóm chat thành công");
      widget.chatcardController.initData(false);
      widget.chatgroupController.initData(false);
    } catch (e) {
      EasyLoading.dismiss();
      EasyLoading.showError("Có lỗi xảy ra!");
      if (kDebugMode) {
        print(e);
      }
    }
  }

  void updateChatGroup() async {
    EasyLoading.show(status: 'loading...');
    var members = [];
    for (var u in chons) {
      members.add({
        "nguoiThamGia": u["NhanSu_ID"],
        "ngayThamgia": DateTime.now().toIso8601String(),
        "ngayThoat": DateTime.now().toIso8601String(),
        "trangThai": 1,
        "chuaDoc": 0,
        "chuNhom": false,
        "ghim": false,
        "thuTuGhim": 1,
        "baoTinNhan": true
      });
    }
    try {
      var body = {
        "user_id": Golbal.store.user["user_id"],
        "chat": {},
        "members": members,
      };
      var strbody = json.encode(body);
      dioform.FormData formData = dioform.FormData.fromMap({"models": strbody});
      Dio dio = Dio();
      dio.options.headers["Authorization"] = "Bearer ${Golbal.store.token}";
      dio.options.followRedirects = true;
      var response = await dio.put(
          "${Golbal.congty!.api}/api/Chat/Update_ChatGroup",
          data: formData);
      var data = response.data;
      if (data["err"] == "1") {
        EasyLoading.showError("Có lỗi xảy ra, vui lòng thử lại!");
        return;
      }
      Navigator.pop(context);
      EasyLoading.dismiss();
      EasyLoading.showSuccess("Bạn vừa thêm nhóm chat thành công");
      widget.chatcardController.initData(false);
      widget.chatgroupController.initData(false);
    } catch (e) {
      EasyLoading.dismiss();
      EasyLoading.showError("Có lỗi xảy ra!");
      if (kDebugMode) {
        print(e);
      }
    }
  }

  dismissKeybroad() {
    FocusScope.of(context).requestFocus(FocusNode());
  }

  @override
  Widget build(BuildContext context) => GestureDetector(
      onTap: dismissKeybroad,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          iconTheme: const IconThemeData(color: Colors.black54),
          titleSpacing: 0.0,
          elevation: 0.0,
          title: Column(
            children: <Widget>[
              Text(widget.id != null ? "Cập nhật thành viên" : "Tạo nhóm mới",
                  style: const TextStyle(color: appColor)),
              chons.isNotEmpty
                  ? Text("Đã chọn ${chons.length}",
                      style:
                          const TextStyle(color: Colors.black45, fontSize: 13))
                  : const SizedBox(
                      width: 0.0,
                      height: 0.0,
                    ),
            ],
          ),
          actions: <Widget>[
            IconButton(
              onPressed: addChatGroup,
              icon: const Icon(FontAwesome.save),
            ),
          ],
          centerTitle: true,
        ),
        body: Container(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextField(
                focusNode: fc,
                controller: tc,
                //enabled: widget.id == null,
                decoration: const InputDecoration(
                  enabledBorder: UnderlineInputBorder(
                      borderSide:
                          BorderSide(width: 0.5, color: Colors.black26)),
                  focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(width: 0.5, color: appColor)),
                  hintText: "Đặt tên nhóm",
                  isDense: true,
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 12.0, horizontal: 10.0),
                ),
                keyboardType: TextInputType.multiline,
                keyboardAppearance: Brightness.light,
                maxLines: null,
                onChanged: (txt) {
                  tenNhom = txt;
                },
                style: const TextStyle(
                    fontSize: 16.0,
                    color: Colors.black,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10.0),
              Expanded(
                child: loadding == true
                    ? const Center(
                        child: SpinKitCircle(color: Colors.black45, size: 32.0),
                      )
                    : ContactModal(
                        isBar: false,
                        title: "Chọn người xử lý",
                        one: false,
                        initialValue: initialValue,
                        onValueChange: (us) {
                          dismissKeybroad();
                          setState(() {
                            chons = us;
                          });
                        },
                        datas: widget.chatController.users_datas,
                        id: "NhanSu_ID",
                        name: "fullName",
                        icon: "anhThumb",
                        subtitle: "tenChucVu",
                      ),
              )
            ],
          ),
        ),
      ));
}
