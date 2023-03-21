// ignore_for_file: unnecessary_null_comparison

import 'dart:convert';
import 'dart:io';

import 'package:date_time_format/date_time_format.dart';
import 'package:device_info_plus/device_info_plus.dart';

import 'package:dio/dio.dart';
import 'package:dio/dio.dart' as dioform;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';
import 'package:page_transition/page_transition.dart';
import 'package:sliding_sheet/sliding_sheet.dart';
import 'package:soe/views/login/login.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../../../utils/golbal/golbal.dart';
import '../../component/dialog.dart';
import '../../home/home.dart';
import '../comp/event.dart';
import '../comp/infosmartoffice.dart';
import '../comp/infouser.dart';
import '../comp/userswitch.dart';

final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

class UserController extends GetxController {
  final sheetCtr = SheetController();
  var datas = {}.obs;
  var urlApp = Golbal.congty!.api.obs;
  var loading = false.obs;
  int year = DateTime.now().year;
  String version = "";
  String appName = "";
  String buildNumber = "";

  var infoApp = "".obs;

  List<File>? _imageFiles;

  // ignore: unused_element
  Future onImageButtonPressed(ImageSource source) async {
    try {
      if (source != null) {
        final picker = ImagePicker();
        var file = await picker.pickImage(
            source: source, maxWidth: 1024, maxHeight: 1024);
        if (file != null) {
          _imageFiles = [File(file.path)];
          saveImage(_imageFiles);
        }
      }
    } catch (e) {}
  }

  void goInfo(context, user) {
    // Navigator.of(context).push(MaterialPageRoute(
    //   builder: (context) => InfoUser(user: user),
    // ));
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => InfoUser(),
    ));
  }

  Future<String> initDevicde() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    String? model = "";
    if (defaultTargetPlatform == TargetPlatform.android) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      model = "${androidInfo.model} (Android)";
    } else if (defaultTargetPlatform == TargetPlatform.iOS) {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      model = "${iosInfo.utsname.machine!} (IOS)";
    }
    return Future.value(model);
  }

  Future<void> updateFB(String oldToken) async {
    Dio http = Dio();
    http.options.headers["Authorization"] = "Bearer ${Golbal.store.token}";
    http.options.followRedirects = true;
    String? dname = await initDevicde();
    Golbal.store.device = {"deviceName": dname};
    int istype = (defaultTargetPlatform == TargetPlatform.android)
        ? 1
        : (defaultTargetPlatform == TargetPlatform.iOS)
            ? 2
            : 0;
    try {
      await http.put('${Golbal.congty!.api}/api/HomeApp/UpdateFirebase', data: {
        "user_id": Golbal.store.user["user_id"],
        "tokencmd": Golbal.store.tokencmd,
        "tokencmd_old": oldToken,
        "dname": dname,
        "istype": istype
      });
    } catch (e) {}
  }

  void handleSignIn(dataform, context) async {
    EasyLoading.show(
      status: "loading ...",
    );
    try {
      var response = await Dio()
          .post('${Golbal.congty!.api}/api/Login/Login', data: dataform);
      EasyLoading.dismiss();
      if (response.data["err"] == "1") {
        EasyLoading.showToast(
            "Không thể đăng nhập vào hệ thống, vui lòng liên hệ với quản trị!");
      } else {
        if (response.data != null && response.data["err"] == "0") {
          try {
            logout(context, f: true);
            Golbal.store.user =
                json.decode(await Golbal.decr(response.data["u"]));
            if (Golbal.store.user["Avartar"] != null) {
              Golbal.store.user["Avartar"] =
                  Golbal.congty!.fileurl + Golbal.store.user["Avartar"];
            }
            Golbal.store.login = true;
            Golbal.store.token = response.data["data"];
            try {
              if (Golbal.isfirebase) {
                _firebaseMessaging.getToken().then((String? token) async {
                  String oldToken = Golbal.store.tokencmd;
                  Golbal.store.tokencmd = token!;
                  updateFB(oldToken);
                });
              }
            } catch (e) {
              if (kDebugMode) {
                print(e);
              }
            }
            Golbal.saveStore();
            Navigator.of(context).pushAndRemoveUntil(
                PageTransition(
                    type: PageTransitionType.fade, child: const Home()),
                (Route<dynamic> r) => false);
          } catch (error) {
            if (kDebugMode) {
              print(error);
            }
          }
        }
      }
    } catch (e) {
      EasyLoading.showToast(
        "Không thể đăng nhập vào hệ thống, vui lòng liên hệ với quản trị!",
      );
    }
  }

  void goSWitchUser(context) async {
    EasyLoading.show(status: "Đang lấy danh sách tài khoản...");
    try {
      var body = {"user_id": Golbal.store.user["user_id"]};
      Dio dio = Dio();
      dio.options.headers["Authorization"] = "Bearer ${Golbal.store.token}";
      dio.options.followRedirects = true;
      var response = await dio.post(
          "${Golbal.congty!.api}/api/HomeApi/Get_InfoSubUsers",
          data: body);
      var data = response.data;
      if (data["err"] == 1) {
        EasyLoading.dismiss();
        return;
      }
      var dts = List.castFrom(json.decode(data["data"]));
      if (dts.isEmpty) {
        EasyLoading.showInfo("Bạn hiện không có tài khoản phụ nào!");
        return;
      }
      EasyLoading.dismiss();
      var rs = await Navigator.of(context).push(
        MaterialPageRoute(
            builder: (context) => UserSwitch(
                  dataswitchs: dts,
                ),
            fullscreenDialog: true),
      );
      if (rs != null) {
        handleSignIn(
            {"user_id": rs["FmaTruyCap_ID"], "is_password": rs["matKhau"]},
            context);
      }
    } catch (e) {
      EasyLoading.dismiss();

      if (kDebugMode) {
        print(e);
      }
    }
  }

  void goInfoSmartOffice(context) {
    Navigator.of(context).push(
      MaterialPageRoute(
          builder: (context) => InfoSmartOffice(), fullscreenDialog: true),
    );
  }

  void goBirthday(context) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => Event(),
    ));
  }

  void doiMK(context) async {
    String mkcu = "";
    String mkmoi = "";
    String nhapmkmoi = "";
    bool showPasscu = false;
    bool showPassmoi = false;
    bool showPassxnh = false;
    bool rs = await Animateddialogbox.showScaleAlertBox(
        context: context,
        firstButton: MaterialButton(
          // FIRST BUTTON IS REQUIRED
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(40),
          ),
          color: Colors.white,
          child: Text('Huỷ'),
          padding: const EdgeInsets.symmetric(horizontal: 50.0),
          onPressed: () {
            Navigator.of(context).pop(false);
          },
        ),
        secondButton: MaterialButton(
          // OPTIONAL BUTTON
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(40),
          ),
          color: const Color(0xFF0186f8),
          padding: const EdgeInsets.symmetric(horizontal: 30.0),
          child: const Text(
            'Gửi',
            style: TextStyle(color: Colors.white),
          ),
          onPressed: () {
            if (mkcu == null || mkcu == "") {
              EasyLoading.showToast("Vui lòng nhập mật khẩu cũ!");
              return;
            }
            if (mkmoi == null || mkmoi == "") {
              EasyLoading.showToast("Vui lòng nhập mật khẩu mới!");
              return;
            }
            if (mkmoi != nhapmkmoi) {
              EasyLoading.showToast("Xác nhận mật khẩu không đúng!");
              return;
            }
            Navigator.of(context).pop(true);
          },
        ),
        icon: Container(width: 0.0), // IF YOU WANT TO ADD ICON
        yourWidget: StatefulBuilder(builder: (context, setState) {
          return Container(
            width: double.maxFinite,
            constraints:
                BoxConstraints(maxHeight: Golbal.screenSize.height * 0.8),
            child: SingleChildScrollView(
                child: Column(
              children: <Widget>[
                Text(
                  "Đổi thông tin mật khẩu",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10.0),
                ConstrainedBox(
                    constraints: BoxConstraints(
                      maxHeight: 250.0,
                    ),
                    child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        reverse: true,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            SizedBox(height: 10.0),
                            TextField(
                              obscureText: !showPasscu,
                              keyboardAppearance: Brightness.light,
                              onChanged: (String txt) {
                                mkcu = txt;
                              },
                              decoration: InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Color(0xFFdddddd)),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Color(0xFFdddddd)),
                                ),
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 10.0, horizontal: 15.0),
                                filled: true,
                                fillColor: Colors.white,
                                hintText: 'Mật khẩu cũ',
                                suffixIcon: IconButton(
                                    icon: Icon(showPasscu
                                        ? Ionicons.ios_eye
                                        : Ionicons.ios_eye_off),
                                    onPressed: () {
                                      setState(() {
                                        showPasscu = !showPasscu;
                                      });
                                    }),
                                hintStyle: TextStyle(fontSize: 13.0),
                              ),
                            ),
                            SizedBox(height: 10.0),
                            TextField(
                              obscureText: !showPassmoi,
                              keyboardAppearance: Brightness.light,
                              onChanged: (String txt) {
                                mkmoi = txt;
                              },
                              decoration: InputDecoration(
                                enabledBorder: const OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Color(0xFFdddddd)),
                                ),
                                focusedBorder: const OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Color(0xFFdddddd)),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                    vertical: 10.0, horizontal: 15.0),
                                filled: true,
                                fillColor: Colors.white,
                                suffixIcon: IconButton(
                                    icon: Icon(showPassmoi
                                        ? Ionicons.ios_eye
                                        : Ionicons.ios_eye_off),
                                    onPressed: () {
                                      setState(() {
                                        showPassmoi = !showPassmoi;
                                      });
                                    }),
                                hintText: 'Mật khẩu mới',
                                hintStyle: TextStyle(fontSize: 13.0),
                              ),
                            ),
                            const SizedBox(height: 10.0),
                            TextField(
                              obscureText: !showPassxnh,
                              keyboardAppearance: Brightness.light,
                              onChanged: (String txt) {
                                nhapmkmoi = txt;
                              },
                              decoration: InputDecoration(
                                enabledBorder: const OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Color(0xFFdddddd)),
                                ),
                                focusedBorder: const OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Color(0xFFdddddd)),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                    vertical: 10.0, horizontal: 15.0),
                                filled: true,
                                fillColor: Colors.white,
                                suffixIcon: IconButton(
                                    icon: Icon(showPassxnh
                                        ? Ionicons.ios_eye
                                        : Ionicons.ios_eye_off),
                                    onPressed: () {
                                      setState(() {
                                        showPassxnh = !showPassxnh;
                                      });
                                    }),
                                hintText: 'Nhập lại mật khẩu mới',
                                hintStyle: TextStyle(fontSize: 13.0),
                              ),
                            )
                          ],
                        ))),
                const SizedBox(height: 5.0),
              ],
            )),
          );
        }));
    if (rs) {
      updatePassWord(mkcu, mkmoi, context);
    }
  }

  void logout(context, {f}) async {
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
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
    Golbal.clearStore();
    Get.deleteAll();
    if (f != true) {
      Navigator.of(context).pushAndRemoveUntil(
          PageTransition(
              type: PageTransitionType.fade, child: const LoginPage()),
          (Route<dynamic> r) => false);
    }
  }

  void saveImage(_imageFiles) async {
    try {
      EasyLoading.show(status: 'loading...');
      var files = [];
      for (var fi in _imageFiles) {
        if (kIsWeb) {
          files.add(dioform.MultipartFile.fromBytes(fi.bytes!,
              filename: fi.path!.split('/').last));
        } else {
          files.add(dioform.MultipartFile.fromFileSync(fi.path!,
              filename: fi.path!.split('/').last));
        }
      }
      var body = {
        "user_id": Golbal.store.user["user_id"],
      };
      var strbody = json.encode(body);
      dioform.FormData formData =
          dioform.FormData.fromMap({"model": strbody, "files": files});
      Dio dio = Dio();
      dio.options.headers["Authorization"] = "Bearer ${Golbal.store.token}";
      dio.options.followRedirects = true;
      var response = await dio.put(
          "${Golbal.congty!.api}/api/User/Update_Anhdaidien",
          data: formData);
      var data = response.data;
      if (data["err"] == "1") {
        EasyLoading.dismiss();
        EasyLoading.showError("Cập nhật không thành công!");
        return;
      }
      EasyLoading.dismiss();
      EasyLoading.show(status: "Bạn đã đổi ảnh đại diện thành công!");
      initData();
    } catch (e) {
      EasyLoading.dismiss();
      EasyLoading.showError("Có lỗi xảy ra!");
      if (kDebugMode) {
        print(e);
      }
    }
  }

  void updatePassWord(mkcu, mkmoi, context) async {
    EasyLoading.show(
      status: "loading ...",
    );
    try {
      String op = await Golbal.encr(mkcu);
      String str = await Golbal.encr(json.encode({
        "oldPass": mkcu,
        "matKhau": mkmoi,
        "rePass": mkmoi,
        "NhanSu_ID": Golbal.store.user["user_id"],
      }));
      var body = {
        "op": op,
        "str": str,
      };
      Dio dio = Dio();
      dio.options.headers["Authorization"] = "Bearer ${Golbal.store.token}";
      dio.options.followRedirects = true;
      var response = await dio
          .put("${Golbal.congty!.api}/api/User/Update_Password", data: body);
      var data = response.data;
      if (data["err"] == "1") {
        EasyLoading.showToast("Mật khẩu cũ không đúng!");
        return;
      }
      EasyLoading.dismiss();
      showDialog(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: Row(
              children: <Widget>[
                Image.asset("assets/logoso.png", height: 24.0),
                const SizedBox(width: 10.0),
                const Expanded(
                  child: Text('Smart Office'),
                )
              ],
            ),
            content: const Text(
                'Bạn đã đổi mật khẩu thành công, vui lòng đăng nhập lại tài khoản với mật khẩu bạn vừa đổi.'),
            actions: <Widget>[
              TextButton(
                child: const Text(
                  'OK',
                  style: TextStyle(color: Color(0xFF0186f8), fontSize: 16.0),
                ),
                onPressed: () async {
                  Golbal.clearStore();
                  Golbal.store.login = false;

                  var bodys = {
                    "user_id": Golbal.store.user["user_id"],
                    "TokenCMID": Golbal.store.tokencmd,
                  };
                  Dio dio = Dio();
                  dio.options.headers["Authorization"] =
                      "Bearer ${Golbal.store.token}";
                  dio.options.followRedirects = true;
                  var response = await dio.put(
                      "${Golbal.congty!.api}/api/User/delFirebase",
                      data: bodys);
                  var data = response.data;
                  if (data["err"] == 1) {
                    EasyLoading.showToast("Mật khẩu cũ không đúng!");
                    return;
                  }
                  // if (Golbal.isWeb != true && !Platform.isMacOS) {
                  //   var isbadge =
                  //       await FlutterAppIconBadge.isAppBadgeSupported();
                  //   if (isbadge) FlutterAppIconBadge.removeBadge();
                  // }
                  //Api.cancelAllNotifications();
                  Navigator.of(context).pushAndRemoveUntil(
                      CupertinoPageRoute(
                          builder: (context) => const LoginPage()),
                      (Route<dynamic> r) => false);
                },
              ),
            ],
          );
        },
      );
    } catch (e) {
      EasyLoading.dismiss();
      if (kDebugMode) {
        print(e);
      }
    }
  }

  void sendMail(String mail) async {
    try {
      final url = Uri(
        scheme: 'mailto',
        path: mail,
        query: 'subject=Hỗ trợ sử dụng SmartOffice&body=Dear OrientSoft,',
      );

      if (await canLaunchUrl(url)) {
        await launchUrl(url);
      } else {}
    } catch (e) {}
  }

  void initCall(String phone) async {
    try {
      final url = Uri(
        scheme: 'tel',
        path: phone,
      );
      if (await canLaunchUrl(url)) {
        await launchUrl(url);
      } else {}
    } catch (e) {}
  }

  void goUrl(String mail) async {
    try {
      final url = Uri(
        scheme: 'mailto',
        path: mail,
      );
      if (await canLaunchUrl(url)) {
        await launchUrl(url);
      } else {}
    } catch (e) {}
  }

  void goSetting(context) async {
    bool rs = await showDialog(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: Row(
              children: <Widget>[
                Image.asset("assets/logoso.png", height: 24.0),
                const SizedBox(width: 10.0),
                const Expanded(
                  child: Text('Địa chỉ chạy ứng dụng'),
                )
              ],
            ),
            content: TextFormField(
              keyboardAppearance: Brightness.light,
              initialValue: urlApp.value,
              onChanged: (String txt) {
                urlApp.value = txt;
              },
            ),
            actions: <Widget>[
              TextButton(
                child: const Text(
                  'CẬP NHẬT',
                  style: TextStyle(color: Color(0xFF0186f8), fontSize: 16.0),
                ),
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
              ),
              TextButton(
                child: const Text(
                  'HUỶ',
                  style: TextStyle(color: Colors.black45, fontSize: 16.0),
                ),
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
              ),
            ],
          );
        });
    if (rs == true) {
      EasyLoading.showToast("Loading...");
      // Golbal.clearStore();
      // Golbal.store.login = false;
      // var bodys = {
      //   "user_id": Golbal.store.user["user_id"],
      //   "TokenCMID": Golbal.store.tokencmd,
      // };
      // Dio dio = Dio();
      // dio.options.headers["Authorization"] = "Bearer ${Golbal.store.token}";
      // dio.options.followRedirects = true;
      // var response = await dio.put("${Golbal.congty!.api}/api/User/delFirebase",
      //     data: bodys);
      // var data = response.data;
      // if (data["err"] == 1) {
      //   EasyLoading.showToast("Cập nhật không thành công!");
      //   return;
      // }
      Golbal.congty!.api = urlApp.value;
      EasyLoading.dismiss();
      EasyLoading.showToast("Cập nhật thành công!");
      //Golbal.setApi();
      // if (Golbal.isWeb != true && !Platform.isMacOS) {
      //   var isbadge = await FlutterAppIconBadge.isAppBadgeSupported();
      //   if (isbadge) FlutterAppIconBadge.removeBadge();
      // }
      // Navigator.of(context).pushAndRemoveUntil(
      //     CupertinoPageRoute(builder: (context) => const LoginPage()),
      //     (Route<dynamic> r) => false);
    }
  }

  Future<void> openModalStatus(context, String statusName) async {
    var breakRow = const SizedBox(height: 10);
    var rs = await showSlidingBottomSheet(context, builder: (context) {
      return SlidingSheetDialog(
        headerBuilder: (c, s) => Material(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  margin: const EdgeInsets.only(top: 10.0),
                  width: 40,
                  height: 5,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color: const Color(0xFFdddddd),
                  ),
                ),
              ],
            ),
          ),
        ),
        controller: sheetCtr,
        elevation: 8,
        cornerRadius: 16,
        listener: (state) {
          if (state.isExpanded) {
            sheetCtr.rebuild();
          }
        },
        snapSpec: const SnapSpec(
          snap: false,
          snappings: [0.7, 0.8, 0.9],
          positioning: SnapPositioning.relativeToAvailableSpace,
        ),
        builder: (context, state) {
          return SizedBox(
            height: MediaQuery.of(context).size.height * 0.9,
            child: KeyboardDismisser(
              child: Scaffold(
                backgroundColor: Colors.white,
                body: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: Form(
                    child: Column(
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const <Widget>[
                            Text(
                              "Cập nhật trạng thái",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        breakRow,
                        breakRow,
                        Row(
                          children: [
                            Text("Nội dung", style: Golbal.stylelabel),
                          ],
                        ),
                        breakRow,
                        TextFormField(
                          initialValue: statusName,
                          minLines: 2,
                          maxLines: 4,
                          maxLength: 500,
                          decoration: Golbal.decoration,
                          style: Golbal.styleinput,
                          onChanged: (String txt) => statusName = txt,
                        ),
                        breakRow,
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 10.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Expanded(
                                child: ElevatedButton(
                                  style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.all<Color>(
                                      const Color(0xFFF2F2F2),
                                    ),
                                  ),
                                  onPressed: () {
                                    Navigator.of(context).pop(false);
                                  },
                                  child: const Text(
                                    "Hủy",
                                    maxLines: 1,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black54,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10.0),
                              Expanded(
                                child: ElevatedButton(
                                  style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.all<Color>(
                                      Golbal.appColor,
                                    ),
                                  ),
                                  onPressed: () {
                                    Navigator.of(context).pop(true);
                                  },
                                  child: const Text(
                                    "Lưu",
                                    maxLines: 1,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      );
    });

    if (rs == true) {
      saveStatus(statusName);
    }
  }

  void saveStatus(statusName) async {
    try {
      if (loading.value) return;
      loading.value = true;
      EasyLoading.show(status: "loading...");

      var body = {
        "status_name": statusName,
      };
      Dio dio = Dio();
      dio.options.headers["Authorization"] = "Bearer ${Golbal.store.token}";
      dio.options.followRedirects = true;
      var response = await dio
          .put("${Golbal.congty!.api}/api/User/Update_Status", data: body);
      var data = response.data;
      loading.value = false;
      if (data["err"] == "1") {
        EasyLoading.showError("Có lỗi xảy ra, vui lòng thử lại!");
        return;
      }
      initData();
      EasyLoading.dismiss();
    } catch (e) {
      loading.value = false;
      EasyLoading.showError("Có lỗi xảy ra!");
      if (kDebugMode) {
        print(e);
      }
    }
  }

  @override
  void onInit() {
    super.onInit();
    if (datas.isEmpty) {
      initPackage();
      initData();
      //test();
    }
  }

  test() async {
    try {
      var par = {
        "user_id": "6FFAC711B0AD4E619911CAC5B681ED85",
        "LichhopTuan_ID": "41402B3347D84ED69086696AD0D61C4A",
        "IsMeeting": "1"
      };
      var strpar = json.encode(par);
      dioform.FormData formData = dioform.FormData.fromMap(
          {"proc": "App_UpdateIsMeeting", "pas": strpar});
      Dio dio = Dio();
      dio.options.headers["Authorization"] = "Bearer ${Golbal.store.token}";
      dio.options.followRedirects = true;
      var response = await dio
          .post("${Golbal.congty!.api}/api/HomeApi/callProc", data: formData);
      var data = response.data;
      if (data["err"] == "1") {
        EasyLoading.showToast("Cập nhật không thành công!");
        return;
      }
      EasyLoading.showToast("Bạn đã đổi ảnh đại diện thành công!");
      initData();
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  initPackage() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    version = packageInfo.version;
    appName = packageInfo.appName != "" ? packageInfo.appName : "SOE";
    buildNumber = packageInfo.buildNumber;

    infoApp.value =
        "${(appName != '' ? appName : "SOE")}.${(version != '' ? version : '1.0')} (${(buildNumber != '' ? buildNumber : '1')})";
  }

  initData() async {
    try {
      EasyLoading.show(status: 'loading...');
      var body = {"user_id": Golbal.store.user["user_id"]};
      Dio dio = Dio();
      dio.options.headers["Authorization"] = "Bearer ${Golbal.store.token}";
      dio.options.followRedirects = true;
      var response = await dio
          .post("${Golbal.congty!.api}/api/User/Get_InfoUser", data: body);
      var data = response.data;
      if (data != null) {
        var tbs = json.decode(data["data"])[0];
        if (tbs != null) {
          tbs["hasImage"] = false;
          if (tbs["anhThumb"] != null && tbs["anhThumb"] != "") {
            tbs["hasImage"] = true;
            tbs["anhThumb"] = Golbal.congty!.fileurl + tbs["anhThumb"];
          }
          tbs["subten"] =
              (tbs["ten"] != null) ? tbs["ten"].trim().substring(0, 1) : "";
          if (tbs["ngaySinh"] != null) {
            tbs["ngaySinh"] = DateTimeFormat.format(
                DateTime.parse(tbs["ngaySinh"]),
                format: 'd/m/Y');
          } else {
            tbs["ngaySinh"] = '';
          }
          datas.value = tbs;
        } else {
          datas.value = {};
        }
      }
      EasyLoading.dismiss();
    } catch (e) {
      EasyLoading.dismiss();
      EasyLoading.showError("Có lỗi xảy ra");
      if (kDebugMode) {
        print(e);
      }
    }
  }
}
