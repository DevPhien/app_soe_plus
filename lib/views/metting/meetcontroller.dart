import 'dart:convert';

import 'package:art_sweetalert/art_sweetalert.dart';
import 'package:dio/dio.dart' as dioform;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:soe/utils/golbal/golbal.dart';
import 'package:jitsi_meet/jitsi_meet.dart';
import 'package:url_launcher/url_launcher.dart';

class MeetController extends GetxController {
  RxBool isLoad = RxBool(true);
  final iosAppBarRGBAColor =
      TextEditingController(text: "#0080FF80"); //transparent blue
  dynamic model;
  @override
  Future<void> onInit() async {
    super.onInit();
    model = Get.arguments;
    isLoad.value = false;
    // JitsiMeet.addListener(JitsiMeetingListener(
    //     onConferenceWillJoin: _onConferenceWillJoin,
    //     onConferenceJoined: _onConferenceJoined,
    //     onConferenceTerminated: _onConferenceTerminated,
    //     onError: _onError));
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

  void joinMeeting({data}) async {
    String? serverUrl = "https://meet.soe.vn";
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
    // Enable or disable any feature flag here
    // If feature flag are not provided, default values will be used
    // Full list of feature flags (and defaults) available in the README
    bool fullquyen = model["Chutri"] == Golbal.store.user["user_id"];
    Map<FeatureFlagEnum, bool> featureFlags = {
      FeatureFlagEnum.WELCOME_PAGE_ENABLED: false,
      FeatureFlagEnum.CLOSE_CAPTIONS_ENABLED: false,
      FeatureFlagEnum.INVITE_ENABLED: fullquyen,
      FeatureFlagEnum.ADD_PEOPLE_ENABLED: fullquyen,
    };
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

    // Define meetings options here
    var options = JitsiMeetingOptions(room: model['LichhopTuan_ID'])
      ..serverURL = serverUrl
      ..subject = model['Noidung']
      ..userDisplayName = Golbal.store.user["FullName"]
      //..userEmail = "conghditos@gmail.com"
      ..iosAppBarRGBAColor = iosAppBarRGBAColor.text
      ..userAvatarURL = Golbal.store.user["Avatar"]
      ..token = Golbal.store.token
      ..audioOnly = true
      ..audioMuted = false
      ..videoMuted = false
      ..featureFlags.addAll(featureFlags)
      ..webOptions = {
        "roomName": model['LichhopTuan_ID'],
        "width": "100%",
        "height": "100%",
        "enableWelcomePage": false,
        "audioMuted": false,
        "videoMuted": false,
        "chromeExtensionBanner": null,
        "lang": 'vi',
        "userInfo": {"displayName": Golbal.store.user["FullName"]},
        "configOverwrite": {"disableInviteFunctions": true},
        "interfaceConfigOverwrite": {
          "WELCOME_PAGE_ENABLED": false,
          "CLOSE_CAPTIONS_ENABLED": false,
          "INVITE_ENABLED": false,
          "ADD_PEOPLE_ENABLED": false,
          "HIDE_INVITE_MORE_HEADER": true,
          "TOOLBAR_BUTTONS": toolbar,
        }
      };

    try {
      await JitsiMeet.joinMeeting(
        options,
        listener: JitsiMeetingListener(
            onConferenceWillJoin: (message) {
              debugPrint("${options.room} will join with message: $message");
            },
            onConferenceJoined: (message) {
              debugPrint("${options.room} joined with message: $message");
              JitsiMeet.executeCommand('subject', [model['Noidung']]);
              JitsiMeet.executeCommand('localSubject', [model['Noidung']]);
            },
            onConferenceTerminated: (message) {
              debugPrint("${options.room} terminated with message: $message");
              Get.back();
            },
            genericListeners: [
              JitsiGenericListener(
                  eventName: 'readyToClose',
                  callback: (dynamic message) {
                    debugPrint("readyToClose callback");
                  }),
            ]),
      );
    } catch (e) {
      Get.back();
      joinWeb();
    }
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

  Future<void> launchInBrowser(Uri url) async {
    if (!await launchUrl(
      url,
      mode: LaunchMode.externalApplication,
    )) {
      throw 'Could not launch $url';
    }
  }

  // void _onConferenceWillJoin(message) {
  //   debugPrint("_onConferenceWillJoin broadcasted with message: $message");
  // }

  // void _onConferenceJoined(message) {
  //   debugPrint("_onConferenceJoined broadcasted with message: $message");
  // }

  // void _onConferenceTerminated(message) {
  //   Get.back();
  //   debugPrint("_onConferenceTerminated broadcasted with message: $message");
  // }

  // _onError(error) {
  //   debugPrint("_onError broadcasted: $error");
  // }

  void back() {
    //JitsiMeet.closeMeeting();
  }

  @override
  Future<void> dispose() async {
    JitsiMeet.closeMeeting();
    super.dispose();
  }
}
