import 'dart:convert';

import 'package:art_sweetalert/art_sweetalert.dart';
import 'package:dio/dio.dart';
import 'package:dio/dio.dart' as dioform;
import 'package:elegant_notification/elegant_notification.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_icon_badge/flutter_app_icon_badge.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:page_transition/page_transition.dart';
import 'package:soe/views/home/controller/cmenucontroller.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:store_redirect/store_redirect.dart';
import '../../../model/appversion.dart';
import '../../../utils/golbal/golbal.dart';
import '../../login/login.dart';
import 'cmymenucontroller.dart';
import 'csinhnhatcontroller.dart';
import 'cthongbaocontroller.dart';
import 'ctintuccontroller.dart';

class HomeAppController extends GetxController {
  var counthome = {}.obs;
  RxBool isLoadding = true.obs;
  RxBool isActive = false.obs;
  @override
  void onInit() {
    super.onInit();
    initActive();
    initData();
    initVersion();
  }

  void initSocketData(data) {
    if (data != null && data["module"] == "task") {
      switch (data["type"]) {
        case 0:
          if (data["user_id"] != Golbal.store.user["user_id"]) {
            if (Get.context != null) {
              ElegantNotification(
                title: Text(data["title"] ?? ""),
                description: Text(data["ms"] ?? ""),
                icon: Icon(
                  Octicons.tasklist,
                  color: Golbal.appColor,
                ),
              ).show(Get.context!);
            }
          }
          break;
      }
    }
  }

  Future<void> onrefersh() async {
    Get.deleteAll();
    final HomeMenuController mcontroller = Get.put(HomeMenuController());
    final HomeMyMenuController mycontroller = Get.put(HomeMyMenuController());
    final HomeSinhNhatController sncontroller =
        Get.put(HomeSinhNhatController());
    final HomeThongBaoController tbcontroller =
        Get.put(HomeThongBaoController());
    final HomeTintucController ttcontroller = Get.put(HomeTintucController());
    initData();
    mcontroller.initData();
    mycontroller.initData();
    sncontroller.initData();
    tbcontroller.initData();
    ttcontroller.initData();
  }

  void goNotification(n) {
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
      if (n["tieuDe"] == "Lệnh điều xe") {
        Get.toNamed("detaillenhcar", arguments: {"LenhDX_ID": n["idKey"]});
      } else {
        Get.toNamed("detailphieucar", arguments: {"PhieuDX_ID": n["idKey"]});
      }
    } else if (n["loai"] == 10) {
    } else if (n["loai"] == 11) {
      Get.toNamed("detailtask",
          arguments: {"CongviecID": n["groupID"] ?? n["idKey"]});
    } else if (n["loai"] == 2) {
      Get.toNamed("detailthongbao", arguments: {"Thongbao_ID": n["idKey"]});
    } else if (n["loai"] == 9) {
      Get.toNamed("detailtintuc", arguments: {"Tintuc_ID": n["idKey"]});
    } else if (n["loai"] == 13) {
      Get.toNamed("detailrequest", arguments: {"RequestMaster_ID": n["idKey"]});
    }

    // counthome["CountThongbao"]--;
    // updateBadge();
  }

  Future<void> updateBadge() async {
    bool res = await FlutterAppIconBadge.isAppBadgeSupported();
    if (res) {
      try {
        FlutterAppIconBadge.updateBadge(counthome["CountThongbao"] ?? 0);
      } catch (e) {}
    }
  }

  void logout() async {
    try {
      var bodys = {
        "tokencmd": Golbal.store.tokencmd,
      };
      Dio dio = Dio();
      dio.options.headers["Authorization"] = "Bearer ${Golbal.store.token}";
      dio.options.followRedirects = true;
      var response = await dio.delete(
          "${Golbal.congty!.api}/api/HomeApp/RemoveFirebase",
          data: bodys);
      var data = response.data;
      if (data["err"] == 1) {
        return;
      }
    } catch (e) {}
    Golbal.clearStore();
    Get.deleteAll();
    Navigator.of(Get.context!).pushAndRemoveUntil(
        PageTransition(type: PageTransitionType.fade, child: const LoginPage()),
        (Route<dynamic> r) => false);
  }

  initData() async {
    try {
      var body = {"user_id": Golbal.store.user["user_id"]};
      Dio dio = Dio();
      dio.options.headers["Authorization"] = "Bearer ${Golbal.store.token}";
      dio.options.followRedirects = true;
      var response = await dio.post(
          "${Golbal.congty!.api}/api/HomeApp/CountMenuHomePage",
          data: body);
      var data = response.data;
      if (data != null) {
        var tbs = List.castFrom(json.decode(data["data"]));
        if (tbs.isNotEmpty) {
          tbs[0]["/lichngay"] = tbs[0]["CountLichTrongngay"];
          counthome.value = tbs[0];
          bool res = await FlutterAppIconBadge.isAppBadgeSupported();
          if (res) {
            try {
              FlutterAppIconBadge.updateBadge(tbs[0]["CountThongbao"]);
            } catch (e) {}
          }
        }
      }
    } on DioError catch (e) {
      if (e.response!.statusCode == 401) {
        ArtDialogResponse response = await ArtSweetAlert.show(
            barrierDismissible: false,
            context: Get.context!,
            artDialogArgs: ArtDialogArgs(
                title: "Thông báo!",
                text:
                    "Mã Token đã hết hạn, vui lòng đăng nhập lại ứng dụng để tiếp tục sử dụng!",
                confirmButtonText: "Đăng nhập lại",
                type: ArtSweetAlertType.warning));

        if (response.isTapConfirmButton) {
          logout();
          return;
        }
        return;
      }
      // in case of a code that is not success, you can get it here through object 'e'
    }
  }

  void initActive() async {
    isLoadding.value = true;
    try {
      var par = {
        "organization_id": Golbal.store.user["organization_id"],
      };
      var strpar = json.encode(par);
      dioform.FormData formData = dioform.FormData.fromMap(
          {"proc": "App_ActiveTruyenthong", "pas": strpar});
      Dio dio = Dio();
      dio.options.headers["Authorization"] = "Bearer ${Golbal.store.token}";
      dio.options.followRedirects = true;
      var response = await dio
          .post("${Golbal.congty!.api}/api/HomeApi/callProc", data: formData);
      isLoadding.value = false;
      var data = response.data;
      if (data["err"] == "1") {
        return;
      }
      if (data != null) {
        var tbs = json.decode(data["data"])[0];
        if (tbs[0] != null && tbs[0].length > 0) {
          isActive.value = tbs[0]["isActive"];
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  Future<void> showUpdateApp(String version) async {
    ArtDialogResponse response = await ArtSweetAlert.show(
        barrierDismissible: false,
        context: Get.context!,
        artDialogArgs: ArtDialogArgs(
            title: "Thông báo!",
            text:
                "Đã có phiên bản mới $version, vui lòng cập nhật ứng dụng để tiếp tục sử dụng!",
            confirmButtonText: "Cập nhật",
            type: ArtSweetAlertType.warning));

    if (response.isTapConfirmButton) {
      await StoreRedirect.redirect(
          androidAppId: "vn.soe.orientsoft", iOSAppId: "1499178321");
      return;
    }
  }

  initVersion() async {
    try {
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      Dio dio = Dio();
      dio.options.followRedirects = true;
      var response = await dio.get("https://soe.vn/app/app.json");
      var data = response.data;
      if (data != null) {
        AppVersion appVersion = AppVersion.fromJson(data);
        int currentVersion = int.tryParse(packageInfo.buildNumber) ?? 0;
        int latestAppVersion = 0;
        String version = "";
        if (defaultTargetPlatform == TargetPlatform.iOS) {
          latestAppVersion = appVersion.ios;
          version = appVersion.iosname;
        } else if (defaultTargetPlatform == TargetPlatform.android) {
          latestAppVersion = appVersion.android;
          version = appVersion.androidname;
        }
        if (latestAppVersion > currentVersion) {
          showUpdateApp(version);
        }
      }
    } on DioError catch (e) {}
  }
}
