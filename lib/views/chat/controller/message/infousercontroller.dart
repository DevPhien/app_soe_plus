import 'dart:convert';

import 'package:date_time_format/date_time_format.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:soe/utils/golbal/golbal.dart';
import 'package:soe/views/chat/controller/favorites/favoritescontroller.dart';
import 'package:url_launcher/url_launcher.dart';

class InfoUserController extends GetxController {
  FavoritesController favoritesController = Get.put(FavoritesController());
  final formKey = GlobalKey<FormState>();
  RxBool loading = true.obs;
  var user = {}.obs;
  var members = [].obs;
  var files = [].obs;

  TextStyle labelStyle = const TextStyle(color: Colors.black54);
  TextStyle saoStyle = const TextStyle(color: Colors.red);

  void setFaverites(value) async {
    user["IsFaverites"] = value ?? false;
    try {
      EasyLoading.show(status: 'loading...');
      List<dynamic> ids = [user["NhanSu_ID"]];
      var body = {
        "user_id": Golbal.store.user["user_id"],
        "ids": ids,
        "status": user["IsFaverites"],
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

  void dismissKeybroad(context) {
    FocusScope.of(context).requestFocus(FocusNode());
  }

  Future<void> goChat(user) async {
    var result = Get.toNamed("message", arguments: {
      "ChatID": user["ChatID"] ?? "",
      "NhanSu_ID": user["NhanSu_ID"] ?? "",
      "type": user["ChatID"] != null ? true : false,
    });
    if (result != null) {}
    return;
  }

  @override
  void onInit() {
    super.onInit();
    user.value = Get.arguments;
    initData();
  }

  void initData() async {
    loading.value = true;
    try {
      var body = {
        "NhanSu_ID": user["NhanSu_ID"],
        "user_id": Golbal.store.user["user_id"],
      };
      Dio dio = Dio();
      dio.options.headers["Authorization"] = "Bearer ${Golbal.store.token}";
      dio.options.followRedirects = true;
      var response = await dio
          .post("${Golbal.congty!.api}/api/Chat/Get_InfoUser", data: body);
      var data = response.data;
      loading.value = false;
      if (data["err"] == "1") {
        EasyLoading.showError("Có lỗi xảy ra, vui lòng thử lại!");
        return;
      }
      if (data != null) {
        var tbs = List.castFrom(json.decode(data["data"]));
        if (tbs.isNotEmpty) {
          if (tbs[0] != null && tbs[0].isNotEmpty) {
            user.value = tbs[0][0];
            if (user["ngaySinh"] != null) {
              user["ngaySinh"] = DateTimeFormat.format(
                  DateTime.parse(user["ngaySinh"]),
                  format: 'd/m/Y');
            }
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
