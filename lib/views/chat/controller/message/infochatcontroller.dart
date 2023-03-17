import 'dart:convert';

import 'package:date_time_format/date_time_format.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:soe/utils/golbal/golbal.dart';
import 'package:soe/views/chat/comp/contact.dart';
import 'package:soe/views/chat/controller/chatcontroller.dart';
import 'package:soe/views/chat/controller/favorites/favoritescontroller.dart';
import 'package:soe/views/chat/controller/message/messagecontroller.dart';
import 'package:url_launcher/url_launcher.dart';

class InfoChatController extends GetxController {
  ChatController chatController = Get.put(ChatController());
  FavoritesController favoritesController = Get.put(FavoritesController());
  MessageController messageController = Get.put(MessageController());
  final formKey = GlobalKey<FormState>();
  RxBool loading = true.obs;
  var chat = {}.obs;
  var members = [].obs;
  var files = [].obs;

  TextStyle labelStyle = const TextStyle(color: Colors.black54);
  TextStyle saoStyle = const TextStyle(color: Colors.red);

  void setFaverites(value) async {
    chat["IsFaverites"] = value ?? false;
    try {
      EasyLoading.show(status: 'loading...');
      List<dynamic> ids = [chat["NhanSu_ID"]];
      var body = {
        "user_id": Golbal.store.user["user_id"],
        "ids": ids,
        "status": chat["IsFaverites"],
      };
      Dio dio = Dio();
      dio.options.headers["Authorization"] = "Bearer ${Golbal.store.token}";
      dio.options.followRedirects = true;
      var response = await dio.put(
          "${Golbal.congty!.api}/api/Chat/Update_UserFavorites",
          data: body);
      var data = response.data;
      EasyLoading.dismiss();
      if (data["err"] == "1") {
        EasyLoading.showError("Có lỗi xảy ra, vui lòng thử lại!");
        return;
      }
      favoritesController.initData();
      EasyLoading.showSuccess("Cập nhật thành công");
    } catch (e) {
      EasyLoading.dismiss();
      EasyLoading.showError("Có lỗi xảy ra!");
      if (kDebugMode) {
        print(e);
      }
    }
  }

  void callPhone(dynamic chat) async {
    try {
      final url = Uri(
        scheme: 'tel',
        path: chat["phone"],
      );
      if (await canLaunchUrl(url)) {
        await launchUrl(url);
      } else {
        EasyLoading.showError("Số điện thoại người dùng không hợp lệ!");
      }
    } catch (e) {
      EasyLoading.showError("Số điện thoại người dùng không hợp lệ!");
    }
  }

  void goSMS(dynamic chat) async {
    try {
      final url = Uri(
        scheme: 'sms',
        path: chat["phone"],
      );
      if (await canLaunchUrl(url)) {
        await launchUrl(url);
      } else {
        EasyLoading.showError("Số điện thoại người dùng không hợp lệ!");
      }
    } catch (e) {
      EasyLoading.showError("Số điện thoại người dùng không hợp lệ!");
    }
  }

  void sendMail(String mail) async {
    try {
      final url = Uri(
        scheme: 'mailto',
        path: mail,
        query: 'subject=&body=,',
      );

      if (await canLaunchUrl(url)) {
        await launchUrl(url);
      } else {
        EasyLoading.showError("Email người dùng không hợp lệ!");
      }
    } catch (e) {
      EasyLoading.showError("Email người dùng không hợp lệ!");
    }
  }

  void removeMember(user, context) async {
    showDialog(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            content: SingleChildScrollView(
              child: ListBody(
                children: const <Widget>[
                  Text("Bạn có muốn xóa thành viên này không?"),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('Có'),
                onPressed: () async {
                  int idx = members.indexOf(user);
                  if (idx != -1) {
                    members.removeAt(idx);
                  }
                  Navigator.of(context).pop();
                  try {
                    if (user["chatMemberID"] != null &&
                        user["chatMemberID"] != "") {
                      EasyLoading.show(status: 'loading...');
                      var body = {
                        "user_id": Golbal.store.user["user_id"],
                        "ChatID": chat["ChatID"],
                        "nguoiThamGia": user["nguoiThamGia"],
                      };
                      Dio dio = Dio();
                      dio.options.headers["Authorization"] =
                          "Bearer ${Golbal.store.token}";
                      dio.options.followRedirects = true;
                      var response = await dio.put(
                          "${Golbal.congty!.api}/api/Chat/Remove_UserGroupChat",
                          data: body);
                      var data = response.data;
                      if (data["err"] == "1") {
                        EasyLoading.dismiss();
                        EasyLoading.showError(
                            "Có lỗi xảy ra, vui lòng thử lại!");
                        members.insert(idx, user);
                        return;
                      }
                      messageController.initData();
                      EasyLoading.dismiss();
                      EasyLoading.showSuccess("Bạn xóa thành công!");
                    }
                  } catch (e) {
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

  void saveChatGroup(context) async {
    formKey.currentState!.save();
    if (chat["tenNhom"] == null) {
      EasyLoading.showError('Vui lòng nhập tên nhóm');
      return;
    }

    if (loading.value) return;
    if (formKey.currentState!.validate()) {
      try {
        loading.value = true;
        EasyLoading.show(status: 'loading...');
        var body = {
          "user_id": Golbal.store.user["user_id"],
          "chat": chat,
          "members": members,
        };
        Dio dio = Dio();
        dio.options.headers["Authorization"] = "Bearer ${Golbal.store.token}";
        dio.options.followRedirects = true;
        var response = await dio
            .put("${Golbal.congty!.api}/api/Chat/Update_GroupChat", data: body);
        var data = response.data;
        if (data["err"] == "1") {
          EasyLoading.dismiss();
          EasyLoading.showError("Có lỗi xảy ra, vui lòng thử lại!");
          return;
        }
        messageController.initData();
        Navigator.of(context).pop();
        EasyLoading.dismiss();
        EasyLoading.showSuccess("Cập nhật thành công");
      } catch (e) {
        EasyLoading.dismiss();
        EasyLoading.showError("Có lỗi xảy ra!");
        if (kDebugMode) {
          print(e);
        }
      }
    }
  }

  void openModalAddUserChatGroup(context) async {
    await Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => ContactModal(
              isBar: true,
              title: "Chọn người cần thêm",
              one: false,
              initialValue: "",
              onValueChange: (us) {
                dismissKeybroad(context);
              },
              onSend: addUserChatGroup,
              datas: chatController.users_datas,
              id: "NhanSu_ID",
              name: "fullName",
              icon: "anhThumb",
              subtitle: "tenChucVu",
            ),
        fullscreenDialog: true));
  }

  void addUserChatGroup(us) async {
    if (us != null && us.isNotEmpty) {
      for (var e in us) {
        e["info"] = "";
        if (e["phone"] != null && e["phone"] != "") {
          e["info"] += e["phone"];
        }
        if (e["tenChucVu"] != null && e["tenChucVu"] != "") {
          e["info"] += (" | " + e["tenChucVu"]);
        }
        var user = {
          "NhanSu_ID": e["NhanSu_ID"],
          "nguoiThamGia": e["NhanSu_ID"],
          "fullName": e["fullName"],
          "ten": e["ten"],
          "anhThumb": e["anhThumb"],
          "info": e["info"],
        };
        if (user["anhThumb"] != null && user["anhThumb"] != "") {
          user["anhThumb"] =
              user["anhThumb"].replaceAll(Golbal.congty!.fileurl, "");
        }
        if (members.indexWhere(
                (el) => el["nguoiThamGia"] == user["nguoiThamGia"]) ==
            -1) {
          members.add(user);
        }
      }
    }
  }

  void dismissKeybroad(context) {
    FocusScope.of(context).requestFocus(FocusNode());
  }

  Future<void> goArchives() async {
    var rs = await Get.toNamed("archives", arguments: chat);
    if (rs == true) {}
  }

  @override
  void onInit() {
    super.onInit();
    chat.value = Get.arguments;
    initData();
  }

  void initData() async {
    loading.value = true;
    try {
      var body = {
        "ChatID": chat["ChatID"],
        "user_id": Golbal.store.user["user_id"],
      };
      Dio dio = Dio();
      dio.options.headers["Authorization"] = "Bearer ${Golbal.store.token}";
      dio.options.followRedirects = true;
      var response = await dio
          .post("${Golbal.congty!.api}/api/Chat/Get_InfoChat", data: body);
      var data = response.data;
      loading.value = false;
      if (data["err"] == "1") {
        EasyLoading.showError("Có lỗi xảy ra, vui lòng thử lại!");
        return;
      }
      if (data != null) {
        var tbs = List.castFrom(json.decode(data["data"]));
        if (tbs.isNotEmpty) {
          chat.value = tbs[0][0];
          if (chat["nhom"]) {
            if (tbs[1] != null && tbs[1].length > 0) {
              for (var e in tbs[1]) {
                e["info"] = "";
                if (e["phone"] != null && e["phone"] != "") {
                  e["info"] += e["phone"];
                }
                if (e["tenChucVu"] != null && e["tenChucVu"] != "") {
                  e["info"] += (" | " + e["tenChucVu"]);
                }
              }
              members.value = tbs[1];
            }
          } else {
            if (chat["ngaySinh"] != null) {
              chat["ngaySinh"] = DateTimeFormat.format(
                  DateTime.parse(chat["ngaySinh"]),
                  format: 'd/m/Y');
            }
          }

          if (chat["nhom"] == true) {
            files.value = tbs[2];
          } else {
            files.value = tbs[1];
          }
        }
      }
    } catch (e) {
      loading.value = false;
      if (kDebugMode) {
        print(e);
      }
    }
  }
}
