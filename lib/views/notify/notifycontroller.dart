import 'dart:convert';
import 'dart:io';

import 'package:date_time_format/date_time_format.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:open_app_file/open_app_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../utils/golbal/golbal.dart';
import '../home/controller/homeappcontroller.dart';

class NotyController extends GetxController {
  final HomeAppController homecontroller = Get.put(HomeAppController());
  RxInt istype = (-1).obs;
  var loaddingmore = false;
  RxBool isLoadding = true.obs;
  var lastdata = false.obs;
  var datas = [].obs;
  var countTB = 0.obs;
  int tongso = 0;
  var nhomnotys = [].obs;
  var nhom = {}.obs;
  Map<String, dynamic> options = {
    "p": 1,
    "pz": 20,
    "s": null,
    "filter_congty_id": Golbal.store.user["organization_id"]
  };
  void goNhom(n) {
    nhom.value = n;
  }

  void goNotification(n) async {
    //print(n);
    var idx =
        datas.indexWhere((element) => element["sendHubID"] == n["sendHubID"]);
    if (idx != -1) {
      datas[idx]["doc"] = true;
      datas.refresh();
    }
    updateNoti(n);
    if (n["loai"] == 1) {
      Get.toNamed("message", arguments: {
        "ChatID": n["groupID"] ?? n["idKey"],
        "type": false,
      });
    } else if (n["loai"] == 3) {
      Get.toNamed("detailcalendar", arguments: {"LichhopTuan_ID": n["idKey"]});
    } else if (n["loai"] == 0) {
      Get.toNamed("detaildoc", arguments: {
        "vanBanMasterID": n["idKey"],
        "group_id": n["groupID"] ?? "",
        "anhThumb": n["anhThumb"],
        "ten": n["ten"],
        "fullName": n["fullName"],
      });
    } else if (n["loai"] == 5) {
      if (n["groupID"] == "LDX") {
        Get.toNamed("detaillenhcar", arguments: {"LenhDX_ID": n["idKey"]});
      } else {
        Get.toNamed("detailphieucar", arguments: {"PhieuDX_ID": n["idKey"]});
      }
    } else if (n["loai"] == 10) {
      var result = await Get.toNamed("detailproject",
          arguments: {"DuanID": n["DuanID"] ?? n["idKey"]});
      if (result != null) {
        if (result["isdel"] == true) {
          EasyLoading.showInfo(result["message"] ?? "");
        }
      }
    } else if (n["loai"] == 11) {
      var result = await Get.toNamed("detailtask",
          arguments: {"CongviecID": n["CongviecID"] ?? n["idKey"]});
      if (result != null) {
        if (result["isdel"] == true) {
          EasyLoading.showInfo(result["message"] ?? "");
        }
      }
    } else if (n["loai"] == 2) {
      Get.toNamed("detailthongbao", arguments: {"Thongbao_ID": n["idKey"]});
    } else if (n["loai"] == 9) {
      Get.toNamed("detailtintuc", arguments: {"Tintuc_ID": n["idKey"]});
    } else if (n["loai"] == 13) {
      Get.toNamed("detailrequest", arguments: {"RequestMaster_ID": n["idKey"]});
    }

    homecontroller.counthome["CountThongbao"]--;
    homecontroller.updateBadge();
  }

  Future<void> updateNoti(n) async {
    Dio http = Dio();
    http.options.headers["Authorization"] = "Bearer ${Golbal.store.token}";
    http.options.followRedirects = true;
    try {
      http.put('${Golbal.congty!.api}/api/HomeApp/UpdateIsViewedSendHub',
          data: {"sendhub_id": n["sendHubID"]});
    } catch (e) {}
  }

  Future<void> delNotification(n) async {
    EasyLoading.show(
      status: "Đang thực hiện ...",
    );
    Dio http = Dio();
    http.options.headers["Authorization"] = "Bearer ${Golbal.store.token}";
    http.options.followRedirects = true;
    try {
      var response = await http.delete(
          '${Golbal.congty!.api}/api/HomeApp/RemoveSendHub',
          data: {"sendhub_id": n["sendHubID"]});
      EasyLoading.dismiss();
      if (response.data == null || response.data["err"] != "0") {
        EasyLoading.showToast(
            "Xoá thông báo không thành công, vui lòng thử lại!");
      } else {
        if (response.data != null) {
          var idx = datas
              .indexWhere((element) => element["sendHubID"] == n["sendHubID"]);
          if (idx != -1) {
            datas.removeAt(idx);
          }
          EasyLoading.showToast("Xoá thông báo thành công!");
          Get.back(result: true);
        }
      }
    } catch (e) {
      EasyLoading.dismiss();
      EasyLoading.showToast(
        "Không thể xoá thông báo này, vui lòng thử lại!",
      );
    }
  }

  initNoty(f) async {
    try {
      if (!f) {
        isLoadding.value = true;
      }
      var body = {
        "user_id": Golbal.store.user["user_id"],
        "p": options["p"],
        "pz": options["pz"],
        "s": options["s"],
        "type": istype.value == -1 ? null : istype.value,
      };
      String url = "HomeApp/GetListSendHub";
      Dio dio = Dio();
      dio.options.headers["Authorization"] = "Bearer ${Golbal.store.token}";
      dio.options.followRedirects = true;
      var response =
          await dio.post("${Golbal.congty!.api}/api/$url", data: body);
      var data = response.data;
      if (data != null) {
        var tbs = List.castFrom(json.decode(data["data"]));
        if (tbs.isNotEmpty) {
          var cdate = DateTimeFormat.format(DateTime.now(), format: 'd/m/Y');
          for (var element in tbs[0]) {
            if (element["anhThumb"] != null) {
              element["anhThumb"] =
                  Golbal.congty!.fileurl + element["anhThumb"];
            }
            element["IsToday"] = element["Ngay"] == cdate;
          }
          countTB.value = tbs[1][0]["c"];
          tongso = tbs[2][0]["c"] + countTB.value;
          if (countTB.value == 0) {
            homecontroller.counthome["CountThongbao"] = 0;
            homecontroller.updateBadge();
          }
          if (f) {
            datas.addAll(tbs[0]);
          } else {
            datas.value = tbs[0];
          }
        } else {
          lastdata.value = true;
        }
        if (loaddingmore) {
          loaddingmore = false;
        }
      } else {
        lastdata.value = true;
      }
      if (isLoadding.value) {
        isLoadding.value = false;
      }
      EasyLoading.dismiss();
    } catch (e) {
      if (isLoadding.value) {
        isLoadding.value = false;
      }
      EasyLoading.dismiss();
      if (kDebugMode) {
        print(e);
      }
    }
  }

  Future<void> refershData() {
    datas.clear();
    return Future.value(null);
  }

  void search(String s) {
    datas.clear();
    options["s"] = s;
    options["p"] = 1;
    initNoty(false);
  }

  Future<void> onLoadmore() {
    if (loaddingmore || datas.length == tongso) return Future.value(null);
    loaddingmore = true;
    EasyLoading.show(
      status: "Đang tải trang ${options["p"]}",
    );
    options["p"] = int.parse(options["p"].toString()) + 1;
    initNoty(true);
    return Future.value(null);
  }

  openFileMobile(url) async {
    String filename = url;
    Directory tempDir = await getTemporaryDirectory();
    String type = filename.substring(filename.lastIndexOf(".")).trim();
    filename = filename.substring(0, filename.lastIndexOf(".")).trim();
    filename = filename.replaceAll(" ", "").replaceAll(".", "_") + type;
    String filePath = "${tempDir.path}/$filename";
    EasyLoading.show(
      status: "Đang hiển thị file ...",
    );
    Dio dio = Dio();
    dio.options.headers["Authorization"] = "Bearer ${Golbal.store.token}";
    dio.options.followRedirects = true;
    try {
      await dio.download(url, filePath);
      await OpenAppFile.open(filePath);
    } catch (e) {}
    EasyLoading.dismiss();
  }

  loadFile(link) async {
    if (link != null) {
      if (defaultTargetPlatform == TargetPlatform.android ||
          defaultTargetPlatform == TargetPlatform.iOS) {
        String url =
            Golbal.congty!.fileurl + link.toString().replaceAll("\\", "/");
        if (defaultTargetPlatform == TargetPlatform.iOS &&
            link.toString().toLowerCase().contains(".pdf")) {
          !await launchUrl(Uri.parse(url),
              mode: LaunchMode.inAppWebView, webOnlyWindowName: "Xem Văn bản");
        } else {
          openFileMobile(url);
        }
      } else {
        String viewUrl = "${Golbal.congty!.fileurl}/Viewer/Index?url=" + link;
        !await launchUrl(Uri.parse(viewUrl),
            mode: LaunchMode.inAppWebView, webOnlyWindowName: "Xem Văn bản");
      }
    }
  }

  @override
  void onInit() {
    super.onInit();
    initNoty(false);
  }
}
