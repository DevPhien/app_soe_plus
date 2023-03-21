// ignore_for_file: unnecessary_null_comparison

import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:soe/utils/golbal/golbal.dart';
import 'package:soe/views/chat/comp/contact.dart';
import 'package:soe/views/chat/controller/chatcontroller.dart';

class FavoritesController extends GetxController {
  var datas = [].obs;
  final searchController = TextEditingController();
  RxBool loading = true.obs;

  final ChatController chatController = Get.put(ChatController());

  void onSearch(txt) {
    searchController.text = txt;
    initData();
  }

  void openModalAddFavorites(context) async {
    await Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => ContactModal(
              isBar: true,
              title: "Chọn người cần thêm",
              one: false,
              initialValue: "",
              onValueChange: (us) {
                dismissKeybroad(context);
              },
              onSend: saveAddFavorites,
              datas: chatController.users_datas,
              id: "NhanSu_ID",
              name: "fullName",
              icon: "anhThumb",
              subtitle: "tenChucVu",
            ),
        fullscreenDialog: true));
  }

  void saveAddFavorites(us) async {
    if (us != null && us.isNotEmpty) {
      EasyLoading.show(status: 'loading...');
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
      initData();
      EasyLoading.showToast("Bạn đã thêm người yêu thích thành công!");
    }
  }

  void dismissKeybroad(context) {
    FocusScope.of(context).requestFocus(FocusNode());
  }

  void removeFavorites(user) async {
    try {
      EasyLoading.show(status: 'loading...');
      int idx = datas.indexOf(user);
      datas.removeAt(idx);
      var body = {
        "user_id": Golbal.store.user["user_id"],
        "NhanSu_ID": user["NhanSu_ID"],
      };
      Dio dio = Dio();
      dio.options.headers["Authorization"] = "Bearer ${Golbal.store.token}";
      dio.options.followRedirects = true;
      var response = await dio.put(
          "${Golbal.congty!.api}/api/Chat/Remove_UserFavorites",
          data: body);
      var data = response.data;
      if (data["err"] == "1") {
        EasyLoading.dismiss();
        EasyLoading.showError("Có lỗi xảy ra, vui lòng thử lại!");
        datas.insert(idx, user);
        return;
      }
      datas.remove(user);
      EasyLoading.dismiss();
      EasyLoading.showToast("Bạn xóa người yêu thích thành công!");
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  Future<void> goInfoUser(user) async {
    var result = Get.toNamed("infouser", arguments: user);
    if (result != null) {}
    return;
  }

  @override
  void onInit() {
    super.onInit();
    if (datas.isEmpty) {
      initData();
    }
  }

  void initData() async {
    try {
      loading.value = true;
      var body = {
        "user_id": Golbal.store.user["user_id"],
        "s": searchController.text,
      };
      Dio dio = Dio();
      dio.options.headers["Authorization"] = "Bearer ${Golbal.store.token}";
      dio.options.followRedirects = true;
      var response = await dio
          .post("${Golbal.congty!.api}/api/Chat/Get_UserFavorites", data: body);
      var data = response.data;
      if (data != null) {
        var tbs = json.decode(data["data"]);
        if (tbs.length > 0) {
          for (var i = 0; i < tbs.length; i++) {
            tbs[i]["info"] = "";
            if (tbs[i]["phone"] != null && tbs[i]["phone"] != "") {
              tbs[i]["info"] += tbs[i]["phone"];
            }
            if (tbs[i]["tenChucVu"] != null && tbs[i]["tenChucVu"] != "") {
              tbs[i]["info"] += (" | " + tbs[i]["tenChucVu"]);
            }
          }
          datas.value = tbs;
        } else {
          datas.value = [];
        }
      }
      loading.value = false;
    } catch (e) {
      loading.value = false;
      EasyLoading.showError("Có lỗi xảy ra!");
      if (kDebugMode) {
        print(e);
      }
    }
  }
}
