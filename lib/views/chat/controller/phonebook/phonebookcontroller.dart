// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:soe/utils/golbal/golbal.dart';
import 'package:soe/views/chat/controller/chatcontroller.dart';
import 'package:url_launcher/url_launcher.dart';

class PhoneBookController extends GetxController {
  final ChatController chatController = Get.put(ChatController());

  final searchController = TextEditingController();
  late TabController tabController;

  var userleader_datas = [].obs;
  var phonebook_datas = [].obs;
  var tree_datas = [].obs;
  RxBool loading = true.obs;

  void onSearch(txt) {
    searchController.text = txt;
    initData();
  }

  void callPhone(dynamic user) async {
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

  void goInfoChat(user) async {
    Get.toNamed("infochat", arguments: {
      "NhanSu_ID": user["NhanSu_ID"] ?? "",
    });
  }

  @override
  void onInit() {
    super.onInit();
    initData();
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
          .post("${Golbal.congty!.api}/api/Chat/Get_Phonebook", data: body);
      var data = response.data;
      if (data != null) {
        var tbs = json.decode(data["data"]);

        var userleaders = List.castFrom(tbs[0]).toList();
        if (userleaders.isNotEmpty) {
          userleader_datas.value = userleaders;
        } else {
          userleader_datas.value = [];
        }
        var phonebooks = List.castFrom(tbs[1]).toList();
        if (phonebooks.isNotEmpty) {
          for (var i = 0; i < phonebooks.length; i++) {
            phonebooks[i]["info"] = "";
            if (phonebooks[i]["phone"] != null &&
                phonebooks[i]["phone"] != "") {
              phonebooks[i]["info"] += phonebooks[i]["phone"];
            }
            if (phonebooks[i]["tenChucVu"] != null &&
                phonebooks[i]["tenChucVu"] != "") {
              phonebooks[i]["info"] += (" | " + phonebooks[i]["tenChucVu"]);
            }
          }
          phonebook_datas.value = phonebooks;
        } else {
          phonebook_datas.value = [];
        }

        var trees = List.castFrom(tbs[3]).toList();
        if (trees.isNotEmpty) {
          for (var i = 0; i < trees.length; i++) {
            trees[i]["info"] = "";
            if (trees[i]["phone"] != null && trees[i]["phone"] != "") {
              trees[i]["info"] += trees[i]["phone"];
            }
            if (trees[i]["tenChucVu"] != null && trees[i]["tenChucVu"] != "") {
              trees[i]["info"] += (" | " + trees[i]["tenChucVu"]);
            }
          }
          tree_datas.value = trees;
        } else {
          tree_datas.value = [];
        }
      }
      loading.value = false;
    } catch (e) {
      loading.value = false;
      if (kDebugMode) {
        print(e);
      }
    }
  }
}
