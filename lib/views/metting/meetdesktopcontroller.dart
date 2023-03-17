import 'dart:convert';

import 'package:art_sweetalert/art_sweetalert.dart';
import 'package:dio/dio.dart' as dioform;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jitsi_meet/jitsi_meet.dart';
import 'package:soe/utils/golbal/golbal.dart';
import 'package:desktop_webview_window/desktop_webview_window.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';

class MeetDesktopController extends GetxController {
  dynamic model;
  late Webview webview;
  RxBool isLoad = RxBool(true);
  @override
  Future<void> onInit() async {
    super.onInit();
    model = Get.arguments;
    Future.delayed(const Duration(seconds: 1), () {
      joinMeeting(data: model);
    });
  }

  Future<void> showMS(ms) async {
    await ArtSweetAlert.show(
        barrierDismissible: false,
        context: Get.context!,
        artDialogArgs: ArtDialogArgs(
            dialogAlignment: Alignment.centerLeft,
            title: "Smart Office",
            text: ms));
    Get.back();
  }

  Future<bool> updateMeeting() async {
    try {
      var par = {
        "user_id": Golbal.store.user["user_id"],
        "LichhopTuan_ID": model["LichhopTuan_ID"],
        "IsMeeting ": "1",
      };
      var strpar = json.encode(par);
      dioform.FormData formData = dioform.FormData.fromMap(
          {"proc": "App_UpdateIsMeeting", "pas": strpar});
      dioform.Dio dio = dioform.Dio();
      dio.options.headers["Authorization"] = "Bearer ${Golbal.store.token}";
      dio.options.followRedirects = true;
      var rs = await dio.post("${Golbal.congty!.api}/api/HomeApi/callProc",
          data: formData);
      return json.decode(rs.data["data"])[0][0]["IsMeeting"];
      // ignore: empty_catches
    } catch (e) {
      return false;
    }
  }

  Future<void> launchInBrowser(Uri url) async {
    if (!await launchUrl(
      url,
      mode: LaunchMode.externalApplication,
    )) {
      throw 'Could not launch $url';
    }
  }

  void joinMeeting({data}) async {
    if (data != null) {
      model = data;
    }
    DateTime batdau = model["BatdauNgay"] != null
        ? DateTime.parse(model["BatdauNgay"])
        : DateTime.now();
    DateTime ketthuc = model["KetthucNgay"] != null
        ? DateTime.parse(model["KetthucNgay"])
        : DateTime.now();
    DateTime today = DateTime.now();
    if (today.difference(batdau).inMinutes <= -10) {
      showMS("Cuộc họp chưa diễn ra.");
      return;
    } else if (today.difference(ketthuc).inMinutes > 10) {
      showMS("Cuộc họp đã kết thúc.");
      return;
    }
    if (model["Chutri"] != Golbal.store.user["user_id"] &&
        model["IsMeeting"] != 1) {
      showMS("Người chủ trì chưa bắt đầu cuộc họp.");
      return;
    } else if (model["Chutri"] == Golbal.store.user["user_id"]) {
      bool rs = await updateMeeting();
      if (!rs) {
        showMS("Đơn vị của bạn chưa được kích hoạt chức năng họp trực tuyến!");
        return;
      }
    }
    joinWeb();
    Get.back();
    //joinWebview();
  }

  joinWeb() {
    String? serverUrl = "https://meet.soe.vn/${model["LichhopTuan_ID"]}#";
    bool fullquyen = model["Chutri"] == Golbal.store.user["user_id"];
    var toolbar = [
      "camera",
      "chat",
      "closedcaptions",
      "desktop",
      "download",
      "etherpad",
      "feedback",
      "filmstrip",
      "fullscreen",
      "hangup",
      "help",
      "highlight",
      "linktosalesforce",
      "livestreaming",
      "microphone",
      "noisesuppression",
      "profile",
      "raisehand",
      "recording",
      "select-background",
      "shareaudio",
      "sharedvideo",
      "stats",
      "tileview",
      "toggle-camera",
      "videoquality",
    ];
    if (fullquyen) {
      toolbar = [
        "camera",
        "chat",
        "closedcaptions",
        "desktop",
        "dock-iframe",
        "download",
        "embedmeeting",
        "etherpad",
        "feedback",
        "filmstrip",
        "fullscreen",
        "hangup",
        "help",
        "highlight",
        "invite",
        "linktosalesforce",
        "livestreaming",
        "microphone",
        "noisesuppression",
        "participants-pane",
        "profile",
        "raisehand",
        "recording",
        "security",
        "select-background",
        "settings",
        "shareaudio",
        "sharedvideo",
        "shortcuts",
        "stats",
        "tileview",
        "toggle-camera",
        "undock-iframe",
        "videoquality",
      ];
    }
    var strToolbars = [];
    for (var element in toolbar) {
      strToolbars.add("%22$element%22");
    }
    serverUrl += "config.startWithVideoMuted=true";
    serverUrl += "&config.startWithAudioMuted=true";
    serverUrl += "&config.disableInviteFunctions=true";
    serverUrl += "&interfaceConfig.WELCOME_PAGE_ENABLED=false";
    serverUrl += "&interfaceConfig.CLOSE_CAPTIONS_ENABLED=false";
    serverUrl += "&interfaceConfig.INVITE_ENABLED=false";
    serverUrl += "&interfaceConfig.ADD_PEOPLE_ENABLED=false";
    serverUrl += "&interfaceConfig.HIDE_INVITE_MORE_HEADER=true";
    serverUrl +=
        "&interfaceConfig.TOOLBAR_BUTTONS=%5B${strToolbars.join("%2C")}%D";
    serverUrl += "&config.defaultLanguage=%22vi%22";
    serverUrl += "&userInfo.displayName=%22${Golbal.store.user["FullName"]}%22";
    launchInBrowser(Uri.parse(serverUrl));
  }

  Future<void> joinWebview() async {
    String? serverUrl = "https://home.soe.vn";
    webview = await WebviewWindow.create(
      configuration: CreateConfiguration(
        windowHeight: Golbal.screenSize.height.toInt(),
        windowWidth: Golbal.screenSize.width.toInt(),
        title: model['Noidung'],
        titleBarTopPadding:
            defaultTargetPlatform == TargetPlatform.macOS ? 20 : 0,
        userDataFolderWindows: await _getWebViewPath(),
      ),
    );
    webview
      ..registerJavaScriptMessageHandler("onloadPage", (name, body) {
        debugPrint('on javaScipt message: $name $body');
      })
      ..setApplicationNameForUserAgent(
          "Mozilla/5.0 (Macintosh; Intel Mac OS X 12_5_1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/105.0.0.0 Safari/537.36")
      ..launch(serverUrl)
      ..addOnUrlRequestCallback((url) {})
      ..onClose.whenComplete(() {
        debugPrint("on close web");
      });
    await Future.delayed(const Duration(seconds: 1));
    webview
        .evaluateJavaScript("initMeet('${json.encode(model)}','${json.encode({
          "NhanSu_ID": Golbal.store.user["user_id"],
          "fullName": Golbal.store.user["FullName"]
        })}')");
  }

  Future<String> _getWebViewPath() async {
    final document = await getApplicationDocumentsDirectory();
    return p.join(
      document.path,
      'desktop_webview_window',
    );
  }

  void back() {}

  @override
  Future<void> dispose() async {
    JitsiMeet.closeMeeting();
    super.dispose();
  }
}
