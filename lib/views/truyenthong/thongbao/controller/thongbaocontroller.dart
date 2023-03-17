import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:open_app_file/open_app_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../utils/golbal/golbal.dart';

class ThongbaoController extends GetxController {
  var loaddingmore = false.obs;
  RxBool isLoadding = true.obs;
  var nhom = {}.obs;
  var datas = [].obs;
  var years = [].obs;
  var datanhoms = [].obs;
  RxInt year = (DateTime.now()).year.obs;
  Map<String, dynamic> options = {
    "p": 1,
    "pz": 20,
    "s": null,
    "filter_congty_id": Golbal.store.user["organization_id"]
  };
  void goNhom({typenhom}) {
    nhom.value = typenhom;
    datanhoms.refresh();
    datas.clear();
    options["LoaiTB_ID"] = typenhom["LoaiTB_ID"];
    initData();
  }

  void search(String? s) {
    options["s"] = s;
    options["p"] = 1;
    datas.clear();
    initData();
  }

  initCounts() async {
    try {
      var body = {
        "user_id": Golbal.store.user["user_id"],
        "year": year.toString()
      };
      Dio dio = Dio();
      dio.options.headers["Authorization"] = "Bearer ${Golbal.store.token}";
      dio.options.followRedirects = true;
      var response = await dio
          .post("${Golbal.congty!.api}/api/Notify/Get_Dictionary", data: body);
      var data = response.data;
      if (data != null) {
        var tbs = List.castFrom(json.decode(data["data"]));
        if (tbs.isNotEmpty) {
          years.value = tbs[0];
          datanhoms.value = tbs[1];
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  initData() async {
    isLoadding.value = true;
    try {
      var body = {
        "user_id": Golbal.store.user["user_id"],
        "is_type": "2",
        "notify_type": options["LoaiTB_ID"],
        "s": options["s"],
      };
      Dio dio = Dio();
      dio.options.headers["Authorization"] = "Bearer ${Golbal.store.token}";
      dio.options.followRedirects = true;
      var response = await dio.post(
          "${Golbal.congty!.api}/api/Notify/Get_NotifyByUserFilter",
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
          datas.value = tbs;
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  void goThongbao(tb) {
    var idx = datas
        .indexWhere((element) => element["Thongbao_ID"] == tb["Thongbao_ID"]);
    if (idx != -1) {
      datas[idx]["IsRead"] = true;
    }
    Get.toNamed("/detailthongbao", arguments: tb);
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

  @override
  void onInit() {
    super.onInit();
    initCounts();
    initData();
  }

}
