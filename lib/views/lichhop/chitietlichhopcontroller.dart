import 'dart:convert';

import 'package:art_sweetalert/art_sweetalert.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:soe/views/lichhop/lichhopcontroller.dart';

import '../../utils/golbal/golbal.dart';

class ChitietLichhopController extends GetxController {
  LichHopController controller = Get.put(LichHopController());
  var lichhop = {}.obs;
  var isloadding = true.obs;
  void reloadLichhop() {
    lichhop.value = Get.arguments;
    isloadding.value = true;
    if (!isloadding.value) isloadding.value = true;
    initData();
  }

  initData() async {
    try {
      Dio dio = Dio();
      dio.options.headers["Authorization"] = "Bearer ${Golbal.store.token}";
      dio.options.followRedirects = true;
      var response = await dio
          .post("${Golbal.congty!.api}/api/Calendar/Get_CalendarByID", data: {
        "LichhopTuan_ID": lichhop["LichhopTuan_ID"],
        "user_id": Golbal.store.user["user_id"]
      });
      var data = response.data;
      if (data != null) {
        var tbs = List.castFrom(json.decode(data["data"]));
        if (tbs.isNotEmpty) {
          for (var element in tbs) {
            if (element["nguoithamdus"] != null) {
              element["nguoithamdus"] = json.decode(element["nguoithamdus"]);
            }
            if (element["files"] != null) {
              element["files"] = json.decode(element["files"]);
            }
          }
          lichhop.value = tbs[0];
          if (isloadding.value) isloadding.value = false;
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  void gomeeting(lich) {
    String rul = (defaultTargetPlatform == TargetPlatform.windows ||
            defaultTargetPlatform == TargetPlatform.macOS ||
            defaultTargetPlatform == TargetPlatform.linux)
        ? "meetdesktop"
        : "meet";
    Get.toNamed(rul, arguments: lich);
  }

  Future<void> editLich() async {
    var rs = await Get.toNamed("addlich", arguments: lichhop);
    if (rs == true) {}
  }

  void openEdit(context, calendar) async {
    var rs = await Get.toNamed("addcalendar", arguments: {
      "title": "Cập nhật lịch họp",
      "LichhopTuan_ID": calendar["LichhopTuan_ID"],
      "dictionarys": [
        controller.phonghops,
        controller.kieulaps,
      ],
    });
    if (rs == true) {
      reloadLichhop();
      EasyLoading.showSuccess("Cập nhật thành công");
    }
  }

  //Function
  Future<void> huyLich(lich) async {
    ArtDialogResponse response = await ArtSweetAlert.show(
        barrierDismissible: false,
        context: Get.context!,
        artDialogArgs: ArtDialogArgs(
            denyButtonText: "Không",
            title: "Xác nhận",
            text: "Bạn có chắc chắn muốn huỷ lịch này không!",
            confirmButtonText: "Có",
            type: ArtSweetAlertType.warning));

    if (response.isTapConfirmButton) {
      String lydo = "";
      var rs = await Get.defaultDialog(
          barrierDismissible: false,
          titlePadding: const EdgeInsets.all(20),
          title: "Lý do huỷ lịch",
          confirm: Container(
            padding: const EdgeInsets.only(bottom: 10),
            height: 46,
            child: ElevatedButton.icon(
              icon: const Icon(Feather.send),
              onPressed: () {
                Get.back(result: true);
              },
              label: const Text("Gửi", style: TextStyle(color: Colors.white)),
              style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all<Color>(Golbal.appColor),
              ),
            ),
          ),
          content: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                TextField(
                  minLines: 5,
                  maxLines: 10,
                  decoration: Golbal.decoration,
                  style: Golbal.styleinput,
                  onChanged: (String txt) => lydo = txt,
                ),
              ],
            ),
          ),
          radius: 30);
      if (rs == true) {
        updateHuylich(lich, lydo);
      }
      return;
    }
  }

  Future<void> thamgia(lich, bool isthamgia) async {
    ArtDialogResponse response = await ArtSweetAlert.show(
        barrierDismissible: false,
        context: Get.context!,
        artDialogArgs: ArtDialogArgs(
            denyButtonText: "Không",
            title: "Xác nhận",
            text:
                "Bạn có chắc chắn muốn ${isthamgia ? 'tham gia' : 'không tham gia'} lịch họp này không!",
            confirmButtonText: "Có",
            type: ArtSweetAlertType.warning));

    if (response.isTapConfirmButton) {
      if (isthamgia == false) {
        String lydo = "";
        var rs = await Get.defaultDialog(
            barrierDismissible: false,
            titlePadding: const EdgeInsets.all(20),
            title: "Lý do không tham gia",
            confirm: Container(
              padding: const EdgeInsets.only(bottom: 10),
              height: 46,
              child: ElevatedButton.icon(
                icon: const Icon(Feather.send),
                onPressed: () {
                  Get.back(result: true);
                },
                label: const Text("Gửi", style: TextStyle(color: Colors.white)),
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Golbal.appColor),
                ),
              ),
            ),
            content: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  TextField(
                    minLines: 5,
                    maxLines: 10,
                    decoration: Golbal.decoration,
                    style: Golbal.styleinput,
                    onChanged: (String txt) => lydo = txt,
                  ),
                ],
              ),
            ),
            radius: 30);
        if (rs == true) {
          updateThamgia(lich, isthamgia, lydo);
        }
      } else {
        updateThamgia(lich, isthamgia, "");
      }
      return;
    }
  }

  updateHuylich(lich, String lydo) async {
    try {
      Dio dio = Dio();
      dio.options.headers["Authorization"] = "Bearer ${Golbal.store.token}";
      dio.options.followRedirects = true;
      EasyLoading.show(
        status: "Đang gửi xác nhận ...",
      );
      var body = {
        "ids": [lichhop["LichhopTuan_ID"]],
        "Nguoigui": Golbal.store.user["user_id"],
        "Noidung": lydo,
      };

      try {
        var response = await dio.put(
            "${Golbal.congty!.api}/api/Calendar/Cancel_Calendar",
            data: body);
        EasyLoading.dismiss();
        if (response.data["err"] == "1") {
          EasyLoading.showToast(
              "Không thể huỷ lịch họp này, vui lòng thử lại!");
        } else {
          if (response.data != null) {
            EasyLoading.showToast("Huỷ lịch họp thành công!");
            reloadLichhop();
          }
        }
      } catch (e) {
        dio.put(Golbal.congty!.api + '/api/Log/AddLog', data: {
          "title": "Lỗi huỷ lịch họp",
          "controller": "Calendar/Cancel_Calendar",
          "log_date": DateTime.now().toIso8601String(),
          "log_content": json.encode(body),
          "full_name": Golbal.store.user["FullName"],
          "user_id": Golbal.store.user["user_id"],
          "token_id": Golbal.store.user["Token_ID"],
          "is_type": 0,
          "module": "calendar",
        });
        EasyLoading.dismiss();
        EasyLoading.showToast(
          "Không thể huỷ lịch họp này, vui lòng thử lại!",
        );
      }
    } catch (e) {
      if (kDebugMode) {}
    }
  }

  updateThamgia(lich, bool isthamgia, String lydo) async {
    try {
      Dio dio = Dio();
      dio.options.headers["Authorization"] = "Bearer ${Golbal.store.token}";
      dio.options.followRedirects = true;
      EasyLoading.show(
        status: "Đang gửi xác nhận ...",
      );
      var body = {
        "LichhopTuan_ID": lichhop["LichhopTuan_ID"],
        "user_id": Golbal.store.user["user_id"],
        "IsThamGia": isthamgia,
        "lydo": lydo,
      };
      try {
        var response = await dio.put(
            "${Golbal.congty!.api}/api/Calendar/Update_Collect_Calendar",
            data: body);
        EasyLoading.dismiss();
        if (response.data["err"] == "1") {
          EasyLoading.showToast(
              "Không thể gửi xác nhận ${isthamgia ? 'tham gia' : 'không tham gia'} lịch họp này, vui lòng thử lại!");
        } else {
          if (response.data != null) {
            EasyLoading.showToast(
                "Gửi xác nhận ${isthamgia ? 'tham gia' : 'không tham gia'} lịch họp thành công!");
            reloadLichhop();
          }
        }
      } catch (e) {
        dio.put(Golbal.congty!.api + '/api/Log/AddLog', data: {
          "title":
              "Lỗi gửi xác nhận ${isthamgia ? 'tham gia' : 'không tham gia'} lịch họp",
          "controller": "Calendar/Get_CalendarByID",
          "log_date": DateTime.now().toIso8601String(),
          "log_content": json.encode(body),
          "full_name": Golbal.store.user["FullName"],
          "user_id": Golbal.store.user["user_id"],
          "token_id": Golbal.store.user["Token_ID"],
          "is_type": 0,
          "module": "calendar",
        });
        EasyLoading.dismiss();
        EasyLoading.showToast(
          "Không thể gửi xác nhận ${isthamgia ? 'tham gia' : 'không tham gia'} lịch họp này, vui lòng thử lại!",
        );
      }
    } catch (e) {
      if (kDebugMode) {}
    }
  }

  @override
  void onInit() {
    super.onInit();
    reloadLichhop();
  }
}
