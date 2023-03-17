// ignore_for_file: unnecessary_null_comparison, non_constant_identifier_names

import 'dart:convert';
import 'dart:io';
import 'package:circular_image/circular_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:image_picker/image_picker.dart';
import 'package:soe/utils/golbal/golbal.dart';
import 'package:soe/views/chat/comp/addgroup.dart';
import 'package:soe/views/chat/controller/chatgroup/chatgroupcontroller.dart';
import 'package:soe/views/chat/controller/messenger/chatcardcontroller.dart';
import 'package:url_launcher/url_launcher.dart';

class ChatController extends GetxController {
  final ChatCardController chatcardController = Get.put(ChatCardController());
  final ChatGroupController chatgroupcardController =
      Get.put(ChatGroupController());
  //Declare
  RxInt pageIndex = 1.obs;
  RxBool openDetail = false.obs;
  String search = "";

  var chatFocus = {}.obs;

  var congty_datas = [].obs;
  var phongban_datas = [].obs;
  var users_datas = [].obs;
  var connected_datas = [].obs;

  //render avatar
  String renderText(String? name) {
    if (name == null) return "";
    name = name.trim();
    int i = name.lastIndexOf(" ");
    try {
      if (name.length <= i + 2) {
        return name;
      }
      return name.substring(i + 1, i + 2).toUpperCase();
    } catch (e) {
      return name;
    }
  }

  Widget renderAvarta(
      dynamic item, int? index, double? radius, double? radius1) {
    bool nhom = item["nhom"] ?? false;
    dynamic members = item["members"] ?? [];
    int countmb = item["countmb"] ?? 0;

    switch (nhom) {
      case true:
        return Stack(
          children: [
            const CircleAvatar(
              radius: 24,
              child: Text(""),
              backgroundColor: Colors.transparent,
            ),
            for (var i = 0; i < members.length; i++)
              if (members[i]["anhThumb"] != null &&
                  members[i]["anhThumb"] != "")
                Positioned(
                  left: (i % 2 == 0 && i < 2) ? 24 : 0,
                  bottom: (i % 2 == 0 && i > 1) ? 0 : 24,
                  child: CircularImage(
                    radius: 12,
                    source: Golbal.congty!.fileurl + members[i]["anhThumb"],
                  ),
                )
              else
                Positioned(
                  left: (i % 2 == 0 && i < 2) ? 24 : 0,
                  bottom: (i % 2 == 0 && i > 1) ? 0 : 24,
                  child: CircleAvatar(
                    backgroundColor: HexColor(Golbal.randomColors[i % 7]),
                    radius: 12,
                    child: Text(
                      renderText(members[i]['ten']),
                      style: TextStyle(
                        fontSize: 12,
                        color: HexColor('#ffffff'),
                      ),
                    ),
                  ),
                ),
            Positioned(
              left: (members.length % 2 == 0 && members.length != 2)
                  ? 0
                  : (members.length == 2)
                      ? 12
                      : 24,
              bottom: (members.length >= 2) ? 0 : 24,
              child: CircleAvatar(
                backgroundColor: HexColor('#eeeeee'),
                radius: 12,
                child: Text(
                  "$countmb",
                  style: const TextStyle(fontSize: 12),
                ),
              ),
            ),
          ],
        );
      case false:
        String anh = members.length > 0
            ? (members[0]["anhThumb"])
            : (item["anhThumb"] ?? "");
        String name = members.length > 0
            ? (members[0]["ten"] ?? "")
            : (item["ten"] ?? "");

        bool isOnline = false;
        var check = connected_datas.firstWhere(
            (e) => (e["user_id"] ==
                    (item["NhanSu_ID"] ?? item["nguoiGui"] ?? "") &&
                e["userStatus"] == true),
            orElse: () => null);
        if (check != null) {
          isOnline = true;
        }
        return SizedBox(
          width: 48,
          height: 48,
          child: Stack(
            children: [
              if (anh != null && anh != "")
                CircularImage(
                  radius: radius ?? 24,
                  source: Golbal.congty!.fileurl + anh,
                )
              else
                CircleAvatar(
                  backgroundColor:
                      HexColor(Golbal.randomColors[(index ?? 0) % 7]),
                  radius: radius ?? 24,
                  child: Text(
                    renderText(name),
                    style: TextStyle(
                      fontSize: 20,
                      color: HexColor('#ffffff'),
                    ),
                  ),
                ),
              if (isOnline)
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    height: radius1 ?? 12,
                    width: radius1 ?? 12,
                    decoration: BoxDecoration(
                      color: const Color(0xFF79D676),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white,
                      ),
                    ),
                  ),
                )
            ],
          ),
        );
    }
    return const CircleAvatar(
      radius: 24,
      child: Text(""),
    );
  }

  //function chat
  void goChat(chat, type) async {
    Get.toNamed("message", arguments: {
      "ChatID": chat["ChatID"] ?? "",
      "NhanSu_ID": chat["NhanSu_ID"] ?? "",
      "type": type,
    });
  }

  void callPhone(dynamic chat) async {
    if (chat["nhom"] == true) {
      EasyLoading.showToast(
          "Công ty của bạn chưa đăng ký sử dụng dịch vụ này!");
    } else {
      var u = chat["members"].firstWhere(
          (x) =>
              x["NhanSu_ID"] != Golbal.store.user["user_id"] &&
              (x["NhanSu_ID"] == chat["nguoiChat"] ||
                  x["NhanSu_ID"] == chat["nguoiLap"]),
          orElse: () => null);
      if (u != null) {
        try {
          final url = Uri(
            scheme: 'tel',
            path: u["phone"],
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
    }
  }

  void callPhoneFavorites(user) async {
    if (user != null) {
      try {
        final url = Uri(
          scheme: 'tel',
          path: user["phone"],
        );
        if (await canLaunchUrl(url)) {
          await launchUrl(url);
        } else {}
      } catch (e) {}
    }
  }

  void callVideo() {
    EasyLoading.showToast("Công ty của bạn chưa đăng ký sử dụng dịch vụ này!");
  }

  void popGroupActionChat(context, chat) async {
    var me = chat["me"][0];
    if (me != null) {
      showModalBottomSheet(
          context: context,
          builder: (BuildContext context) {
            return SizedBox(
              height: (chat["nhom"] &&
                      (chat["me"][0]["chuNhom"] == true ||
                          chat["me"][0]["chuNhom"] == "true"))
                  ? 360
                  : (chat["nhom"])
                      ? 360
                      : 300,
              child: SingleChildScrollView(
                child: ListBody(
                  children: [
                    Container(
                      padding: const EdgeInsets.only(left: 20.0),
                      decoration: const BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: Color(0xFFcccccc),
                            width: 0.5,
                          ),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Expanded(
                            child: Text(
                              chat["chatName"] ?? "",
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.close),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          )
                        ],
                      ),
                    ),
                    ListTile(
                      leading: me["baoTinNhan"]
                          ? const Icon(
                              Feather.bell_off,
                              color: Colors.orangeAccent,
                            )
                          : const Icon(
                              Feather.bell,
                              color: Colors.orangeAccent,
                            ),
                      onTap: () {
                        Navigator.of(context).pop();
                        turnoffNotify(context, chat, me);
                      },
                      title: Text(
                          me["baoTinNhan"] ? "Tắt thông báo" : "Bật thông báo"),
                    ),
                    ListTile(
                      leading: const Icon(FontAwesome.check_square_o,
                          color: Colors.green),
                      onTap: () {
                        Navigator.of(context).pop();
                        markRead(context, chat);
                      },
                      title: const Text("Đánh dấu đã đọc"),
                    ),
                    (chat["nhom"] != true)
                        ? ListTile(
                            leading: const Icon(FontAwesome.trash_o,
                                color: Colors.red),
                            onTap: () {
                              Navigator.of(context).pop();
                              removeChat(context, chat);
                            },
                            title: const Text("Xóa cuộc hội thoại này"),
                          )
                        : Container(width: 0.0),
                    if (chat["nhom"] == true) ...[
                      // ListTile(
                      //   leading: const Icon(
                      //       MaterialCommunityIcons.chat_remove_outline,
                      //       color: Colors.orange),
                      //   onTap: () {
                      //     Navigator.of(context).pop();
                      //     removeMessage(context, chat);
                      //   },
                      //   title: const Text("Xóa lịch sử trò chuyện"),
                      // ),
                      ListTile(
                        leading: const Icon(
                            MaterialCommunityIcons.account_remove_outline,
                            color: Colors.orange),
                        onTap: () {
                          Navigator.of(context).pop();
                          leaveChat(context, chat);
                        },
                        title: const Text("Rời nhóm"),
                      ),
                      ListTile(
                        leading:
                            const Icon(FontAwesome.trash_o, color: Colors.red),
                        onTap: () {
                          Navigator.of(context).pop();
                          deleteChat(context, chat);
                        },
                        title: const Text("Xóa cuộc hội thoại này"),
                      )
                    ],
                  ],
                ),
              ),
            );
          });
    }
  }

  void turnoffNotify(context, chat, me) async {
    var rs = await showDialog(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text((me["baoTinNhan"])
                      ? "Bạn có muốn tắt thông báo cho cuộc hội thoại này không?"
                      : "Bạn có muốn bật thông báo cho cuộc hội thoại này không?"),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: Text(
                  'Có',
                  style: TextStyle(
                    color: Golbal.appColor,
                    fontSize: 16.0,
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
              ),
              TextButton(
                child: const Text(
                  'Không',
                  style: TextStyle(
                    color: Colors.black45,
                    fontSize: 16.0,
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
              )
            ],
          );
        });
    if (rs == true) {
      EasyLoading.show(status: 'loading...');
      try {
        me["baoTinNhan"] = !(me["baoTinNhan"] || false);
        var body = {
          "user_id": Golbal.store.user["user_id"],
          "ChatID": chat["ChatID"],
          "baoTinNhan": me["baoTinNhan"],
        };
        Dio dio = Dio();
        dio.options.headers["Authorization"] = "Bearer ${Golbal.store.token}";
        dio.options.followRedirects = true;
        var response = await dio
            .put("${Golbal.congty!.api}/api/Chat/TurnOff_Nnotify", data: body);
        var data = response.data;
        if (data["err"] == "1") {
          EasyLoading.showError("Có lỗi xảy ra, vui lòng thử lại!");
          return;
        }
        EasyLoading.dismiss();
        EasyLoading.showSuccess((me["baoTinNhan"])
            ? "Bật thông báo thành công"
            : "Tắt thông báo thành công");
      } catch (e) {
        EasyLoading.dismiss();
        EasyLoading.showError("Có lỗi xảy ra!");
        if (kDebugMode) {
          print(e);
        }
      }
    }
  }

  void removeMessage(context, chat) async {
    bool rs = await showDialog(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            //title: new Text('Thông báo'),
            content: SingleChildScrollView(
              child: ListBody(
                children: const <Widget>[
                  Text(
                      "Bạn có muốn xóa lịch sử trò chuyện của cuộc hội thoại này không?"),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: Text(
                  'Có',
                  style: TextStyle(color: Golbal.appColor, fontSize: 16.0),
                ),
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
              ),
              TextButton(
                child: const Text(
                  'Không',
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
      EasyLoading.show(status: 'loading...');
      try {
        var body = {
          "user_id": Golbal.store.user["user_id"],
          "ChatID": chat["ChatID"],
        };
        Dio dio = Dio();
        dio.options.headers["Authorization"] = "Bearer ${Golbal.store.token}";
        dio.options.followRedirects = true;
        var response = await dio
            .put("${Golbal.congty!.api}/api/Chat/Remove_Message", data: body);
        var data = response.data;
        if (data["err"] == "1") {
          EasyLoading.showError("Có lỗi xảy ra, vui lòng thử lại!");
          return;
        }
        chatcardController.initData(false);
        chatgroupcardController.initData(false);
        EasyLoading.dismiss();
        EasyLoading.showSuccess("Bạn đã xoá lịch sử trò chuyện thành công");
      } catch (e) {
        EasyLoading.dismiss();
        EasyLoading.showError("Có lỗi xảy ra!");
        if (kDebugMode) {
          print(e);
        }
      }
    }
  }

  void removeChat(context, chat) async {
    bool rs = await showDialog(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            //title: new Text('Thông báo'),
            content: SingleChildScrollView(
              child: ListBody(
                children: const <Widget>[
                  Text("Bạn có muốn xóa cuộc hội thoại này không?"),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: Text(
                  'Có',
                  style: TextStyle(color: Golbal.appColor, fontSize: 16.0),
                ),
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
              ),
              TextButton(
                child: const Text(
                  'Không',
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
      EasyLoading.show(status: 'loading...');
      try {
        var body = {
          "user_id": Golbal.store.user["user_id"],
          "ChatID": chat["ChatID"],
        };
        Dio dio = Dio();
        dio.options.headers["Authorization"] = "Bearer ${Golbal.store.token}";
        dio.options.followRedirects = true;
        var response = await dio
            .put("${Golbal.congty!.api}/api/Chat/Remove_Chat", data: body);
        var data = response.data;
        if (data["err"] == "1") {
          EasyLoading.showError("Có lỗi xảy ra, vui lòng thử lại!");
          return;
        }
        chatcardController.initData(false);
        chatgroupcardController.initData(false);
        EasyLoading.dismiss();
        EasyLoading.showSuccess("Bạn đã xoá cuộc trò chuyện thành công");
      } catch (e) {
        EasyLoading.dismiss();
        EasyLoading.showError("Có lỗi xảy ra!");
        if (kDebugMode) {
          print(e);
        }
      }
    }
  }

  void markRead(context, chat) async {
    var rs = await showDialog(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            //title: new Text('Thông báo'),
            content: SingleChildScrollView(
              child: ListBody(
                children: const <Widget>[
                  Text(
                      "Đánh dấu đã đọc cho tất cả các tin nhắn của cuộc hội thoại này?"),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: Text(
                  'Có',
                  style: TextStyle(
                    color: Golbal.appColor,
                    fontSize: 16.0,
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
              ),
              TextButton(
                child: const Text(
                  'Không',
                  style: TextStyle(
                    color: Colors.black45,
                    fontSize: 16.0,
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
              ),
            ],
          );
        });
    if (rs == true) {
      EasyLoading.show(status: 'loading...');
      try {
        var body = {
          "user_id": Golbal.store.user["user_id"],
          "ChatID": chat["ChatID"],
        };
        Dio dio = Dio();
        dio.options.headers["Authorization"] = "Bearer ${Golbal.store.token}";
        dio.options.followRedirects = true;
        var response = await dio.put("${Golbal.congty!.api}/api/Chat/Mark_Read",
            data: body);
        var data = response.data;
        if (data["err"] == "1") {
          EasyLoading.showError("Có lỗi xảy ra, vui lòng thử lại!");
          return;
        }
        chat["chuaDoc"] = 0;
        EasyLoading.dismiss();
        EasyLoading.showSuccess("Bạn đã đánh dấu tin nhắn thành công!");
      } catch (e) {
        EasyLoading.dismiss();
        EasyLoading.showError("Có lỗi xảy ra!");
        if (kDebugMode) {
          print(e);
        }
      }
    }
  }

  void leaveChat(context, chat) async {
    var rs = await showDialog(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            //title: new Text('Thông báo'),
            content: SingleChildScrollView(
              child: ListBody(
                children: const <Widget>[
                  Text("Bạn có muốn rời khỏi nhóm này không?"),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: Text(
                  'Có',
                  style: TextStyle(
                    color: Golbal.appColor,
                    fontSize: 16.0,
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
              ),
              TextButton(
                child: const Text(
                  'Không',
                  style: TextStyle(
                    color: Colors.black45,
                    fontSize: 16.0,
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
              ),
            ],
          );
        });
    if (rs == true) {
      EasyLoading.show(status: 'loading...');
      // int idx = chatcardController.datas.indexOf(chat);
      // chatcardController.datas.removeAt(idx);
      try {
        var body = {
          "user_id": Golbal.store.user["user_id"],
          "ChatID": chat["ChatID"],
        };
        Dio dio = Dio();
        dio.options.headers["Authorization"] = "Bearer ${Golbal.store.token}";
        dio.options.followRedirects = true;
        var response = await dio
            .put("${Golbal.congty!.api}/api/Chat/Leave_Chat", data: body);
        var data = response.data;
        if (data["err"] == "1") {
          //chatcardController.datas.insert(idx, chat);
          EasyLoading.showError("Có lỗi xảy ra, vui lòng thử lại!");
          return;
        }
        chatcardController.initData(false);
        chatgroupcardController.initData(false);
        EasyLoading.dismiss();
        EasyLoading.showSuccess("Bạn đã rời khỏi nhóm!");
      } catch (e) {
        //chatcardController.datas.insert(idx, chat);
        EasyLoading.dismiss();
        EasyLoading.showError("Có lỗi xảy ra!");
        if (kDebugMode) {
          print(e);
        }
      }
    }
  }

  void deleteChat(context, chat) async {
    var rs = await showDialog(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            //title: new Text('Thông báo'),
            content: SingleChildScrollView(
              child: ListBody(
                children: const <Widget>[
                  Text("Bạn có muốn xóa nhóm chat này không?"),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: Text(
                  'Có',
                  style: TextStyle(
                    color: Golbal.appColor,
                    fontSize: 16.0,
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
              ),
              TextButton(
                child: const Text(
                  'Không',
                  style: TextStyle(
                    color: Colors.black45,
                    fontSize: 16.0,
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
              ),
            ],
          );
        });
    if (rs == true) {
      EasyLoading.show(status: 'loading...');
      int idx = -1;
      switch (pageIndex.value) {
        case 0:
          idx = chatcardController.datas.indexOf(chat);
          chatcardController.datas.removeAt(idx);
          chatgroupcardController.initData(false);
          break;
        case 3:
          // idx = chatgroupcardController.datas.indexOf(chat);
          // chatgroupcardController.datas.removeAt(idx);
          chatcardController.initData(false);
          break;
      }
      try {
        var body = {
          "user_id": Golbal.store.user["user_id"],
          "ChatID": chat["ChatID"],
          "members": chat["members"],
          "event": "getDelChat",
          "socketid": Golbal.socket.id,
        };
        Dio dio = Dio();
        dio.options.headers["Authorization"] = "Bearer ${Golbal.store.token}";
        dio.options.followRedirects = true;
        var response = await dio
            .put("${Golbal.congty!.api}/api/Chat/Delete_Chat", data: body);
        var data = response.data;
        if (data["err"] == "1") {
          if (idx != -1) {
            switch (pageIndex.value) {
              case 0:
                chatcardController.datas.insert(idx, chat);
                break;
              case 3:
                chatgroupcardController.datas.insert(idx, chat);
                break;
            }
          }
          EasyLoading.showError("Có lỗi xảy ra, vui lòng thử lại!");
          return;
        }

        //Realtime
        Golbal.socket.emit('sendData', body);
        //End realtime

        EasyLoading.dismiss();
        EasyLoading.showSuccess("Bạn đã xóa nhóm chat thành công!");
      } catch (e) {
        if (idx != -1) {
          switch (pageIndex.value) {
            case 0:
              chatcardController.datas.insert(idx, chat);
              break;
            case 3:
              chatgroupcardController.datas.insert(idx, chat);
              break;
          }
        }
        EasyLoading.dismiss();
        EasyLoading.showError("Có lỗi xảy ra!");
        if (kDebugMode) {
          print(e);
        }
      }
    }
  }

  // Tree users
  void onPageChanged(int p) {
    pageIndex.value = p;
    if (p == 0) {
      Get.back();
    }
  }

  void searchUser(dynamic s) {
    search = s;
    loadTreeUser();
  }

  void closeDialog() {
    search = "";
    //userChecked.value = [];
    loadTreeUser();
  }

  //Chat
  RxBool IsEdit = false.obs;
  String initialValue = "";
  List chons = [];
  List<File>? imageFiles;
  final formKey = GlobalKey<FormState>();
  TextStyle labelStyle = const TextStyle(color: Colors.black38);
  InputBorder ipborder = const OutlineInputBorder(
      borderSide: BorderSide(color: Color(0xffcccccc)));
  InputBorder fcborder = OutlineInputBorder(
      borderSide: BorderSide(color: Golbal.appColor, width: 1.0));
  InputBorder uipborder = const OutlineInputBorder(
      borderSide: BorderSide(color: Color(0xffcccccc)));
  InputBorder ufcborder = OutlineInputBorder(
      borderSide: BorderSide(color: Golbal.appColor, width: 1.0));
  var modelchat = {
    "nguoiChat": Golbal.store.user["user_id"],
    "loaiNhom": 0,
    "ngayLap": DateTime.now().toIso8601String(),
    "nguoiLap": Golbal.store.user["user_id"],
    "trangThai": 1,
    "ngayCapNhat": DateTime.now().toIso8601String(),
    "nhom": true
  };

  // Chat
  void openModalAddChatGroup(context) async {
    // Navigator.of(context).push(MaterialPageRoute(
    //     builder: (BuildContext context) {
    //       return FormChat(
    //         title: "Tạo nhóm mới",
    //       );
    //     },
    //     fullscreenDialog: true));

    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => AddGroup(), fullscreenDialog: true));
    // if (result == "load") {
    //   if (_page != 3) {
    //     _pageController.jumpToPage(3);
    //   } else {
    //     //Api.load = 0;
    //     changeNotifier.sink.add(null);
    //   }
    // }
  }

  Future onImageButtonPressed(ImageSource source) async {
    try {
      if (source != null) {
        final picker = ImagePicker();
        var file = await picker.pickImage(
            source: source, maxWidth: 1024, maxHeight: 1024);
        if (file != null) {
          imageFiles = [File(file.path)];
        }
      }
    } catch (e) {}
  }

  void dismissKeybroad(context) {
    FocusScope.of(context).requestFocus(FocusNode());
  }

  void saveAddChat(us) async {
    if (us != null && us.isNotEmpty) {
      EasyLoading.show(status: "loading...");
      List<dynamic> ids = us.map((e) => e["NhanSu_ID"]).toList();
      var body = {
        "user_id": Golbal.store.user["user_id"],
        "ids": ids,
      };
      Dio dio = Dio();
      dio.options.headers["Authorization"] = "Bearer ${Golbal.store.token}";
      dio.options.followRedirects = true;
      var response = await dio
          .put("${Golbal.congty!.api}/api/Chat/Add_UserFavorites", data: body);
      var data = response.data;
      if (data["err"] == "1") {
        EasyLoading.dismiss();
        EasyLoading.showError("Có lỗi xảy ra, vui lòng thử lại!");
        return;
      }
      //chatcardController.initData();
      EasyLoading.showToast("Bạn đã thêm người yêu thích thành công!");
    }
  }

  void goSendMessage() {
    Get.toNamed("sendmessage", arguments: {
      "userdatas": users_datas,
    });
  }

  @override
  void onInit() {
    super.onInit();
    if (congty_datas.isEmpty && users_datas.isEmpty) {
      loadTreeUser();
    }
    if (Get.parameters != null && Get.parameters["pageIndex"] != null) {
      pageIndex.value =
          int.tryParse(Get.parameters["pageIndex"].toString()) ?? 0;
    }
  }

  void loadTreeUser() async {
    try {
      var body = {"user_id": Golbal.store.user["user_id"], "s": search};
      Dio dio = Dio();
      dio.options.headers["Authorization"] = "Bearer ${Golbal.store.token}";
      dio.options.followRedirects = true;
      var response = await dio
          .post("${Golbal.congty!.api}/api/Chat/Get_UserList", data: body);
      var data = response.data;
      if (data != null) {
        var tbs = json.decode(data["data"]);
        if (tbs[1] != null && tbs[1].length > 0) {
          congty_datas.value = tbs[1];
        } else {
          congty_datas.value = [];
        }
        if (tbs[3] != null && tbs[3].length > 0) {
          phongban_datas.value = tbs[3];
        } else {
          phongban_datas.value = [];
        }
        if (tbs[4] != null && tbs[4].length > 0) {
          var users = tbs[4];
          for (var i = 0; i < users.length; i++) {
            users[i]["hasImage"] = false;
            if (users[i]["anhThumb"] != null && users[i]["anhThumb"] != "") {
              users[i]["hasImage"] = true;
              // users[i]["anhThumb"] =
              //     Golbal.congty!.fileurl + users[i]["anhThumb"];
            }

            users[i]["subten"] = (users[i]["ten"] != null)
                ? users[i]["ten"].trim().substring(0, 1)
                : "";

            users[i]["bgColor"] = Golbal.randomColors[i % 7];

            users[i]["info"] = "";
            if (users[i]["phone"] != null && users[i]["phone"] != "") {
              users[i]["info"] += users[i]["phone"];
            }
            if (users[i]["tenChucVu"] != null && users[i]["tenChucVu"] != "") {
              users[i]["info"] += (" | " + users[i]["tenChucVu"]);
            }
          }
          users_datas.value = users;
        } else {
          users_datas.value = [];
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  void initSocketConnected(data) {
    connected_datas.value = data;
  }

  void initSocketDataChat(data) {
    if (connected_datas != null &&
        connected_datas.isNotEmpty &&
        data["members"] != null &&
        data["members"].isNotEmpty) {
      for (var us in List.castFrom(connected_datas)
          .where((a) =>
              a["user_id"] != data["nguoiGui"] &&
              a["user_id"] == Golbal.store.user["user_id"] &&
              // && a["userStatus"] == true
              List.castFrom(data["members"])
                  .where((b) => b["nguoiThamGia"] == a["user_id"])
                  .toList()
                  .isNotEmpty)
          .toList()) {
        if (us["user_id"] != null) {
          switch (data["event"]) {
            case "getAddChat":
              chatcardController.initData(false);
              chatgroupcardController.initData(false);
              break;
            case "getDelChat":
              chatcardController.initData(false);
              chatgroupcardController.initData(false);
              break;
          }
        }
      }
    }
  }

  void initSocketDataMessage(data) {
    if (connected_datas != null &&
        connected_datas.isNotEmpty &&
        chatcardController.datas != null &&
        chatcardController.datas.isNotEmpty) {
      for (var us in List.castFrom(connected_datas)
          .where((a) =>
              a["user_id"] != data["nguoiGui"] &&
              a["user_id"] == Golbal.store.user["user_id"] &&
              a["userStatus"] == true)
          .toList()) {
        if (us["user_id"] != null) {
          switch (data["event"]) {
            case "getSendMessage":
              chatcardController.initData(false);
              chatgroupcardController.initData(false);
              break;
            case "getEditMessage":
              chatcardController.initData(false);
              chatgroupcardController.initData(false);
              break;
            case "getDelMessage":
              chatcardController.initData(false);
              chatgroupcardController.initData(false);
              break;
          }
        }
      }
    }
  }
}
