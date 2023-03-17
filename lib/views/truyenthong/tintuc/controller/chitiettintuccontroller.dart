import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import '../../../../utils/golbal/golbal.dart';
import '../itemtintuc.dart';

class ChitietTintucController extends GetxController {
  var isLoadding = false.obs;
  var tintuc = {}.obs;
  var users = [].obs;
  var isWebview=true.obs;
  initUsers() async {
    isLoadding.value = true;
    try {
      var body = {
        "Tintuc_ID": tintuc["Tintuc_ID"],
      };
      Dio dio = Dio();
      dio.options.headers["Authorization"] = "Bearer ${Golbal.store.token}";
      dio.options.followRedirects = true;
      var response = await dio.post(
          "${Golbal.congty!.api}/api/Notify/Get_NotifyUserByID",
          data: body);
      var data = response.data;
      isLoadding.value = false;
      if (data != null) {
        var tbs = List.castFrom(json.decode(data["data"]));
        if (tbs.isNotEmpty) {
          users.value = tbs;
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  void showLuotxem() {
    showCupertinoModalBottomSheet(
      context: Get.context!,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.6,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
        child: Column(
          children: [
            Obx(() => Text(
                  "Nhân sự xem thông báo ${users.isNotEmpty ? "(" + users.length.toString() + ")" : ""}",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Golbal.titleColor,
                      fontSize: 18),
                )),
            const SizedBox(height: 10),
            Expanded(
                child: Obx(() => ListView.separated(
                    separatorBuilder: (ct, i) => const Divider(
                          height: 2,
                          color: Color(0xFFeeeeee),
                        ),
                    itemCount: users.length,
                    itemBuilder: (ct, i) => ItemUserTintuc(user: users[i]))))
          ],
        ),
      ),
    );
  }

  initData() async {
    isLoadding.value = true;
    try {
      var body = {
        "Tintuc_ID": tintuc["Tintuc_ID"],
        "user_id": Golbal.store.user["user_id"],
      };
      Dio dio = Dio();
      dio.options.headers["Authorization"] = "Bearer ${Golbal.store.token}";
      dio.options.followRedirects = true;
      var response = await dio.post("${Golbal.congty!.api}/api/New/Get_NewByID",
          data: body);
      var data = response.data;
      isLoadding.value = false;
      if (data != null) {
        var tbs = List.castFrom(json.decode(data["data"]));
        if (tbs.isNotEmpty) {
          for (var tb in tbs) {
            if (tb["files"] != null) {
              tb["files"] = json.decode(tb["files"]);
            }
          }
          tintuc.value = tbs[0];
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  @override
  void onInit() {
    super.onInit();
    tintuc.value = Get.arguments;
    initData();
    //initUsers();
  }

  @override
  void onClose() {
    super.onClose();
  }
}
