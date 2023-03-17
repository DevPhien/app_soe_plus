import 'dart:convert';

import 'package:date_time_format/date_time_format.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import '../../../utils/golbal/golbal.dart';
import '../../component/use/avatar.dart';
import '../dieuxecontroller.dart';

class ChitietLenhxeController extends GetxController {
  DieuxeController controller = Get.put(DieuxeController());
  var phieuxe = {}.obs;
  var isUserDuyetLenh = false.obs;
  var isUserHoanthanh = false.obs;
  var isUserLapLenh = false.obs;
  var isloadding = true.obs;
  var danhgia = 0.obs;
  var trangthai = 0.obs;
  var modelduyet = {};
  var isxecongty = true.obs;
  var xechon = {}.obs;
  var laixechon = {}.obs;
  var dtxes = [].obs;
  var dtlaixes = [].obs;
  void reloadPhieuxe() {
    phieuxe.value = Get.arguments;
    isloadding.value = true;
    if (!isloadding.value) isloadding.value = true;
    initData();
    initQuyen();
    initOtos();
    initLaixes();
  }

  initData() async {
    try {
      Dio dio = Dio();
      dio.options.headers["Authorization"] = "Bearer ${Golbal.store.token}";
      dio.options.followRedirects = true;
      var response = await dio
          .post("${Golbal.congty!.api}/api/Car/Get_DetailLenhdieuxe", data: {
        "user_id": Golbal.store.user["user_id"],
        "lenh_id": phieuxe["LenhDX_ID"]
      });
      var data = response.data;
      if (data != null) {
        var tbs = List.castFrom(json.decode(data["data"]));
        if (tbs.isNotEmpty) {
          tbs[0][0]["dieuxe_follow_id"] = tbs[0][0]["DieuxeFollow_ID"];
          if (tbs[2].length > 0) {
            tbs[0][0]["qt_nhom_id"] = tbs[2][0]["QT_Nhom_ID"];
          }
          if (tbs[1].length > 0) {
            tbs[0][0]["nhomduyet_id"] = tbs[1][0]["NhomDuyet_ID"];
          }
          tbs[0][0]["nhomtralai_id:"] = tbs[0][0]["nhomtralai_id:"];
          tbs[0][0]["nguoitralai_id"] = tbs[0][0]["nguoitralai_id"];
          tbs[0][0]["loaitralai"] = tbs[0][0]["loaitralai"];
          phieuxe.value = tbs[0][0];
          if (isloadding.value) isloadding.value = false;
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  initOtos() async {
    try {
      Dio dio = Dio();
      dio.options.headers["Authorization"] = "Bearer ${Golbal.store.token}";
      dio.options.followRedirects = true;
      var response = await dio
          .post("${Golbal.congty!.api}/api/Car/Get_ListOtoHome", data: {
        "user_id": Golbal.store.user["user_id"],
      });
      var data = response.data;
      if (data != null) {
        var tbs = List.castFrom(json.decode(data["data"]));
        if (tbs.isNotEmpty) {
          dtxes.value = List.castFrom(tbs[0])
              .where((element) => element["Trangthai"] == 0)
              .toList();
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  initLaixes() async {
    try {
      Dio dio = Dio();
      dio.options.headers["Authorization"] = "Bearer ${Golbal.store.token}";
      dio.options.followRedirects = true;
      var response =
          await dio.post("${Golbal.congty!.api}/api/Car/Get_ListLaixe", data: {
        "user_id": Golbal.store.user["user_id"],
      });
      var data = response.data;
      if (data != null) {
        var tbs = List.castFrom(json.decode(data["data"]));
        if (tbs.isNotEmpty) {
          dtlaixes.value = tbs[0];
        }
      }
    } catch (e) {
      if (kDebugMode) {}
    }
  }

  initQuyen() async {
    try {
      Dio dio = Dio();
      dio.options.headers["Authorization"] = "Bearer ${Golbal.store.token}";
      dio.options.followRedirects = true;
      var response = await dio
          .post("${Golbal.congty!.api}/api/Car/Get_UserIsDuyet", data: {
        "user_id": Golbal.store.user["user_id"],
        "id_check": phieuxe["LenhDX_ID"],
        "type_check": "1"
      });
      var data = response.data;
      if (data != null) {
        var tbs = List.castFrom(json.decode(data["data"]));
        if (tbs.isNotEmpty && tbs[0].length > 0) {
          isUserDuyetLenh.value = tbs[0][0]["isUserDuyetLenh"];
          isUserHoanthanh.value = tbs[1][0]["isUserHoanthanh"];
          isUserLapLenh.value = tbs[2][0]["isUserLapLenh"];
        } else {
          Get.back();
          EasyLoading.showInfo("Lệnh điều xe đã xoá.");
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print("initQuyen$e");
      }
    }
  }

  Future<void> chonxe() async {
    var rs = await Get.toNamed("/chonxe");
    if (rs != null) {
      xechon.value = rs;
    }
  }

  Future<void> chonlaixe() async {
    var rs = await Get.toNamed("/chonlaixe");
    if (rs != null) {
      laixechon.value = rs;
    }
  }

  //Duyệt lệnh
  void openDuyet(int type, dynamic item) {
    switch (type) {
      case 1:
        modelduyet = item;
        Get.toNamed("/duyetlenh");
        break;
      case 2:
        modelduyet = item;
        Get.toNamed("/tralailenh");
        break;
      case 3:
        modelduyet = item;
        Get.toNamed("/hoanthanhlenh");
        break;
      case 4:
        modelduyet = item;
        Get.toNamed("/laplenh");
        break;
      case 5:
        modelduyet = item;
        Get.toNamed("/capnhatrangthaixe");
        break;
      default:
    }
  }

  Future<void> laplenh() async {
    modelduyet["loaidat"] = isxecongty.value == true ? 0 : 1;
    modelduyet["sochongoi"] = xechon["Sochongoi"];
    modelduyet["loaixe"] = xechon["Loaixe"];
    modelduyet["bienso"] = xechon["Bienso"];
    modelduyet["nguoilaixe"] = laixechon["NhanSu_ID"];
    modelduyet["dienthoai"] = laixechon["phone"];
    modelduyet["datxengoai"] = modelduyet["LenhDX_DatXeNgoai"];
    await controller.laplenh(modelduyet);
    Get.back();
  }

  var logs = [];
  initLog() async {
    EasyLoading.show(status: "Đang tải dữ liệu...");
    try {
      Dio dio = Dio();
      dio.options.headers["Authorization"] = "Bearer ${Golbal.store.token}";
      dio.options.followRedirects = true;
      var body = {
        "lenh_id": phieuxe["LenhDX_ID"],
        "phieu_id": phieuxe["PhieuDX_ID"],
        "user_id": Golbal.store.user["user_id"],
      };
      var response = await dio
          .post("${Golbal.congty!.api}/api/Car/Get_DieuxeLog", data: body);
      var data = response.data;
      if (data != null) {
        var tbs = List.castFrom(json.decode(data["data"]));
        if (tbs.isNotEmpty) {
          logs = tbs[0];
        }
      }
      EasyLoading.dismiss();
      if (logs.isNotEmpty) {
        showLog();
      } else {
        EasyLoading.showInfo("Chưa có lịch sử duyệt");
      }
    } catch (e) {
      EasyLoading.dismiss();
      if (kDebugMode) {
        print(e);
      }
    }
  }

  Widget dateWidget(String? d) {
    if (d == null) {
      return const SizedBox.shrink();
    } else {
      return Text(
          ", ${DateTimeFormat.format(DateTime.parse(d), format: 'd/m/y H:i')}",
          style: const TextStyle(color: Colors.black87));
    }
  }

  void showLog() {
    showCupertinoModalBottomSheet(
      context: Get.context!,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.6,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
        child: Column(
          children: [
            Text(
              "Lịch sử duyệt ${logs.isNotEmpty ? "(${logs.length})" : ""}",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Golbal.titleColor,
                  fontSize: 18),
            ),
            const SizedBox(height: 10),
            Expanded(
                child: ListView.separated(
                    separatorBuilder: (ct, i) => const Divider(
                          height: 2,
                          color: Color(0xFFeeeeee),
                        ),
                    itemCount: logs.length,
                    itemBuilder: (ct, i) {
                      var item = logs[i];
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            UserAvarta(
                              user: {
                                "anhThumb": item["anhDaiDien"],
                                "fullName": item["fullname"],
                              },
                              radius: 24,
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                                child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Flexible(
                                      child: Text(item["fullname"] ?? "",
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black87)),
                                    ),
                                    if (item["NgayTao"] != null)
                                      dateWidget(item["NgayTao"]),
                                  ],
                                ),
                                Container(
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 10),
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 10.0, horizontal: 22),
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(30),
                                      color: item["NguoiTao"] ==
                                              Golbal.store.user["user_id"]
                                          ? const Color(0xFFDBF1FF)
                                          : const Color(0xFFf5f5f5)),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(item["Noidung"] ?? "",
                                          style: const TextStyle(
                                              color: Colors.black87,
                                              fontSize: 13)),
                                    ],
                                  ),
                                ),
                              ],
                            ))
                          ],
                        ),
                      );
                    }))
          ],
        ),
      ),
    );
  }

  @override
  void onInit() {
    super.onInit();
    reloadPhieuxe();
  }
}
