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

class LichHopNgayController extends GetxController {
  RxBool isLoadding = true.obs;
  var datas = [].obs;
  var ghichu = "".obs;
  Map<String, dynamic> options = {
    "p": 1,
    "pz": 20,
    "s": null,
    "filter_congty_id": Golbal.store.user["organization_id"]
  };
  int getWeekOfYear() {
    DateTime _kita = DateTime.now();
    int d = DateTime.parse("${_kita.year}-01-01").millisecondsSinceEpoch;
    int t = _kita.millisecondsSinceEpoch;
    double daydiff = (t - d) / (1000 * (3600 * 24));
    double week = daydiff / 7;
    return (week.ceil());
  }

  initNote() async {
    try {
      var body = {
        "year": DateTime.now().year,
        "week": getWeekOfYear(),
        "congty_id": Golbal.store.user["organization_id"]
      };
      Dio dio = Dio();
      dio.options.headers["Authorization"] = "Bearer ${Golbal.store.token}";
      dio.options.followRedirects = true;
      var response = await dio.post(
          "${Golbal.congty!.api}/api/Calendar/Get_NoteByWeek",
          data: body);
      var data = response.data;
      if (data != null) {
        var tbs = List.castFrom(json.decode(data["data"]));
        if (tbs.isNotEmpty) {
          ghichu.value = tbs[0]["Noidung"];
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  openFileMobile(url) async {
    String filename = url;
    Directory tempDir = await getTemporaryDirectory();
    String type = filename.substring(filename.lastIndexOf(".")).trim();
    filename = filename.substring(0, filename.lastIndexOf(".")).trim();
    filename = filename.replaceAll(" ", "").replaceAll(".", "_") + type;
    String filePath = tempDir.path + "/" + filename;
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
        String viewUrl = Golbal.congty!.fileurl + "/Viewer/Index?url=" + link;
        !await launchUrl(Uri.parse(viewUrl),
            mode: LaunchMode.inAppWebView, webOnlyWindowName: "Xem Văn bản");
      }
    }
  }

  initLich(f) async {
    try {
      if (!f) {
        isLoadding.value = true;
      }
      var body = {
        "user_id": Golbal.store.user["user_id"],
        "date": DateTimeFormat.format(DateTime.now(), format: 'm/d/Y'),
        "is_type": "1",
        "filter_congty_id": options["filter_congty_id"],
        "s": options["s"] ?? " ",
      };
      String url = "Calendar/Get_CalendarToday";
      Dio dio = Dio();
      dio.options.headers["Authorization"] = "Bearer ${Golbal.store.token}";
      dio.options.followRedirects = true;
      var response =
          await dio.post("${Golbal.congty!.api}/api/$url", data: body);
      var data = response.data;
      if (data != null) {
        var tbs = List.castFrom(json.decode(data["data"]));
        if (tbs.isNotEmpty) {
          for (var element in tbs) {
            if (element["anhThumb"] != null) {
              element["anhThumb"] =
                  Golbal.congty!.fileurl + element["anhThumb"];
            }
            if (element["nguoithamdus"] != null) {
              element["nguoithamdus"] = json.decode(element["nguoithamdus"]);
            }
            if (element["files"] != null) {
              element["files"] = json.decode(element["files"]);
            }
          }
          tbs[tbs.length - 1]["IsLast"] = true;
          if (f) {
            datas.addAll(tbs);
          } else {
            datas.value = tbs;
          }
        }
      }
      if (isLoadding.value) {
        isLoadding.value = false;
      }
    } catch (e) {
      if (isLoadding.value) {
        isLoadding.value = false;
      }
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
  }

  Future<void> goDetail(calendar) async {
    var rs = await Get.toNamed("/detailcalendar", arguments: calendar);
    if (rs != null) {
      var idx =
          datas.indexWhere((e) => e["LichhopTuan_ID"] == rs["LichhopTuan_ID"]);
      datas[idx] = rs;
    }
  }

  void gomeeting(lich) {
    Get.toNamed("meet", arguments: lich);
  }

  @override
  void onInit() {
    super.onInit();
    initNote();
    initLich(false);
  }
}
