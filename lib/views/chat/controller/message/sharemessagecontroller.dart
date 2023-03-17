import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:soe/utils/golbal/golbal.dart';
import 'package:soe/views/chat/controller/chatgroup/chatgroupcontroller.dart';
import 'package:soe/views/chat/controller/messenger/chatcardcontroller.dart';
import 'package:soe/views/chat/controller/phonebook/phonebookcontroller.dart';

class ShareMessageController extends GetxController {
  final ChatCardController chatcardController = Get.put(ChatCardController());
  final ChatGroupController chatgroupcardController =
      Get.put(ChatGroupController());
  final PhoneBookController phonebookController =
      Get.put(PhoneBookController());
  final searchController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  RxBool loading = true.obs;
  RxBool isCheckedAllChat = false.obs;
  RxBool isCheckedAllUser = false.obs;
  var message = {}.obs;
  var chatdatas = [].obs;
  var userdatas = [].obs;

  void onSearch(txt) {
    searchController.text = txt;
    chatdatas.value = chatcardController.datas
        .where((e) => e["chatName"].toLowerCase().contains(txt.toLowerCase()))
        .toList();
    userdatas.value = phonebookController.phonebook_datas
        .where((e) => e["fullName"].toLowerCase().contains(txt.toLowerCase()))
        .toList();
  }

  void onCheckedAllChat(bool v) {
    isCheckedAllChat.value = v;
    for (var c in chatdatas) {
      c["isChecked"] = v;

      var idx = chatdatas.indexWhere((e) => e["ChatID"] == c["ChatID"]);
      if (idx != -1) {
        chatdatas[idx] = c;
      }
    }
  }

  void onCheckedAllUser(bool v) {
    isCheckedAllUser.value = v;
    for (var u in userdatas) {
      u["isChecked"] = v;

      var idx = userdatas.indexWhere((e) => e["NhanSu_ID"] == u["NhanSu_ID"]);
      if (idx != -1) {
        userdatas[idx] = u;
      }
    }
  }

  void checkedChat(chat, bool v) {
    chat["isChecked"] = v;
    var idx = chatdatas.indexWhere((e) => e["ChatID"] == chat["ChatID"]);
    if (idx != -1) {
      chatdatas[idx] = chat;
    }
  }

  void checkedUser(chat, bool v) {
    chat["isChecked"] = v;
    var idx = userdatas.indexWhere((e) => e["NhanSu_ID"] == chat["NhanSu_ID"]);
    if (idx != -1) {
      userdatas[idx] = chat;
    }
  }

  void shareMessage(context) async {
    var chats = List.castFrom(chatcardController.datas)
        .where((e) => e["isChecked"] == true)
        .map((e) => e["ChatID"])
        .toList();
    var users = List.castFrom(phonebookController.phonebook_datas)
        .where((e) => e["isChecked"] == true)
        .map((e) => e["NhanSu_ID"])
        .toList();

    if (chats.isEmpty && users.isEmpty) {
      EasyLoading.showError(
          "Bạn chưa chọn cuộc hội thoại, người dùng chia sẻ!");
      return;
    }
    if (loading.value) {
      return;
    }

    try {
      loading.value = true;
      var body = {
        "user_id": Golbal.store.user["user_id"],
        "MessageID": message["MessageID"],
        "noiDung": message["noiDung"],
        "chats": chats,
        "users": users,
      };
      Dio dio = Dio();
      dio.options.headers["Authorization"] = "Bearer ${Golbal.store.token}";
      dio.options.followRedirects = true;
      var response = await dio
          .put("${Golbal.congty!.api}/api/Chat/Share_Message", data: body);
      loading.value = false;
      var data = response.data;
      if (data["err"] == "1") {
        EasyLoading.dismiss();
        EasyLoading.showError(
            data["data"] ?? "Có lỗi xảy ra, vui lòng thử lại!");
        return;
      }
      chatcardController.initData(true);
      chatgroupcardController.initData(true);
      EasyLoading.dismiss();
      EasyLoading.showSuccess("Chia sẻ tin nhắn thành công");
      Navigator.of(context).pop();

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
                "noiDung": message["noiDung"],
                "loai": message["loai"],
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
                "MessageID": message["MessageID"],
                "ParentID": null,
                "tenFile": message["tenFile"],
                "loaiFile": message["loaiFile"],
                "duongDan": message["duongDan"],
              };
              Golbal.socket.emit('sendData', mes);
            }
          }
        }
      }
    } catch (e) {
      loading.value = false;
      EasyLoading.dismiss();
      EasyLoading.showError("Có lỗi xảy ra!");
      if (kDebugMode) {
        print(e);
      }
    }
  }

  @override
  void onInit() {
    super.onInit();
    message.value = Get.arguments;
    initData();
  }

  void initData() async {
    loading.value = false;
    chatdatas.value = chatcardController.datas;
    userdatas.value = phonebookController.phonebook_datas;
    clearData();
  }

  void clearData() {
    for (var c in List.castFrom(chatdatas)
        .where((e) => e["isChecked"] == true)
        .toList()) {
      c["isChecked"] = false;
    }
    for (var c in List.castFrom(userdatas)
        .where((e) => e["isChecked"] == true)
        .toList()) {
      c["isChecked"] = false;
    }
  }
}
