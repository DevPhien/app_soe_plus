import 'dart:convert';

import 'package:art_sweetalert/art_sweetalert.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';
import 'package:page_transition/page_transition.dart';
import 'package:dio/dio.dart';
import '../../utils/golbal/golbal.dart';
import '../home/home.dart';
import '../intro/choncongty.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final List<FocusNode> focusNodes = List.generate(2, (int n) {
    return FocusNode();
  }).toList();
  final textStyle = const TextStyle(
      color: Colors.black54, fontSize: 16.0, fontWeight: FontWeight.normal);
  ScrollController scrollController = ScrollController();
  bool autovalidate = false;
  bool showPass = false;
  String logo = Golbal.congty!.logo!;
  @override
  void initState() {
    super.initState();
  }

  var dataform = {"user_id": "", "is_password": ""};
  void showInSnackBar(String value) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(value)));
  }

  void _handleSignIn() async {
    // if (Golbal.connectivityResult == -1) {
    //   EasyLoading.showToast("Vui lòng kiểm tra lại kết nối internet của bạn!");
    //   return;
    // }
    if (dataform["user_id"].toString().trim() == "") {
      EasyLoading.showToast("Tài khoản đăng nhập không được để trống!");
      return;
    }
    if (dataform["is_password"].toString().trim() == "") {
      EasyLoading.showToast("Mật khẩu không được để trống!");
      return;
    }
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

  Future<void> sendOTP() async {
    String username = "";
    String phone = "";
    String otpphone = "";
    var rs = await ArtSweetAlert.show(
        context: context,
        artDialogArgs: ArtDialogArgs(
            type: ArtSweetAlertType.info,
            title: "Lấy lại mật khẩu",
            onConfirm: () {
              Get.back(result: phone);
            },
            customColumns: [
              TextField(
                decoration: const InputDecoration(label: Text("Tài khoản")),
                onChanged: (String value) {
                  username = value;
                },
              ),
              const SizedBox(height: 10),
              IntlPhoneField(
                showDropdownIcon: false,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                ),
                initialCountryCode: 'VN',
                searchText: "Tìm quốc gia",
                disableLengthCheck: true,
                onChanged: (phonen) {
                  phone = "0${phonen.number}";
                  otpphone = phonen.completeNumber;
                },
              ),
              const SizedBox(height: 20),
            ]));
    if (rs != null && rs != "") {
      var body = {"phone": phone, "username": username};
      try {
        Dio dio = Dio();
        dio.options.headers["Authorization"] = "Bearer ${Golbal.store.token}";
        dio.options.followRedirects = true;
        var response = await dio.post(
            "${Golbal.congty!.api}/api/HomeApp/GetPassFromToken",
            data: body);
        if (response.data != null) {
          var data = response.data;
          if (data["err"].toString() != "0") {
            EasyLoading.showError(
                "Tên truy cập hoặc số điện thoại không đúng!");
            return;
          }
          reSetPass(otpphone, data["data"]);
        }
      } catch (e) {
        EasyLoading.showError("Tên truy cập hoặc số điện thoại không đúng!");
      }
    }
  }

  Future<void> xacnhanOTP(String otp, String pass) async {
    String inputotp = "";
    var rs = await ArtSweetAlert.show(
        context: context,
        artDialogArgs: ArtDialogArgs(
            type: ArtSweetAlertType.info,
            title: "Nhập mã xác thực OTP",
            onConfirm: () {
              Get.back(result: inputotp);
            },
            customColumns: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: TextField(
                  decoration: const InputDecoration(),
                  onChanged: (String value) {
                    inputotp = value;
                  },
                ),
              ),
            ]));
    if (rs != null && rs != "") {
      EasyLoading.show(
        status: "Đang xác thực...",
      );
      PhoneAuthCredential credential =
          PhoneAuthProvider.credential(verificationId: otp, smsCode: inputotp);
      try {
        var user =
            (await FirebaseAuth.instance.signInWithCredential(credential)).user;
        if (user != null) {
          EasyLoading.dismiss();
          showNewPass(pass);
        } else {
          EasyLoading.showError("Mã xác nhận không đúng!");
        }
      } catch (e) {
        EasyLoading.showError("Mã xác nhận không đúng!");
      }
      //showNewPass(pass);
    } else {
      EasyLoading.showError("Mã xác nhận không đúng!");
    }
  }

  void showNewPass(String? pass) {
    ArtSweetAlert.show(
        context: context,
        artDialogArgs: ArtDialogArgs(
          type: ArtSweetAlertType.success,
          title: "Mật khẩu mới của bạn là!",
          customColumns: [
            Padding(
                padding: const EdgeInsets.all(20),
                child: Text(pass ?? "",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 30,
                        color: Golbal.titleColor)))
          ],
        ));
  }

  Future<void> reSetPass(String phone, String pass) async {
    try {
      EasyLoading.show(
        status: "Vui lòng đợi hệ thống gửi mã xác nhận ...",
      );
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: phone,
        verificationCompleted: (PhoneAuthCredential credential) {},
        verificationFailed: (FirebaseAuthException e) {
          EasyLoading.showError("Mã xác nhận không đúng!");
        },
        codeSent: (String verificationId, int? resendToken) {
          EasyLoading.showInfo(
              "Mã xác nhận đã được gửi đến số điện thoại của bạn!");

          xacnhanOTP(verificationId, pass);
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          EasyLoading.showError(
              "Đã hết hạn nhập mã xác nhận, vui lòng thử lại");
        },
      );
    } catch (e) {
      EasyLoading.showError("Không thể gửi mã xác nhận, vui lòng thử lại!");
    }
  }

  @override
  Widget build(BuildContext context) {
    double hh = MediaQuery.of(context).size.height;
    bool isSafeA = MediaQuery.of(context).viewPadding.top > 0 &&
        MediaQuery.of(context).viewPadding.bottom > 0;
    bool haskeyboard = MediaQuery.of(context).viewInsets.bottom > 0;
    double he = hh / 2 - (isSafeA ? 100 : 70);
    if (haskeyboard) {
      he = 100;
    }
    return MediaQuery(
        data: MediaQuery.of(context)
            .copyWith(textScaleFactor: Golbal.textScaleFactor),
        child: KeyboardDismisser(
            gestures: const [
              GestureType.onTap,
              GestureType.onPanUpdateDownDirection,
            ],
            child: Scaffold(
                backgroundColor: Colors.white,
                key: _scaffoldKey,
                body: AnnotatedRegion<SystemUiOverlayStyle>(
                  value: SystemUiOverlayStyle.light,
                  child: Stack(
                    children: [
                      Positioned(
                        child: ClipPath(
                          clipper: WaveClipperTwo(),
                          child: Container(
                            height: he,
                            color: const Color(0xFF0078D4),
                          ),
                        ),
                      ),
                      Positioned(
                        top: haskeyboard ? 40 : he / 2,
                        left: haskeyboard ? 20 : 50,
                        child: Text("Smart Office",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w400,
                                fontSize: haskeyboard ? 20 : 40.0)),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 30.0),
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              SizedBox(height: he),
                              Center(
                                  child: InkWell(
                                      onTap: () {
                                        Navigator.of(context)
                                            .push(MaterialPageRoute(
                                                builder: (context) =>
                                                    const ChonCongTy(
                                                        back: true),
                                                fullscreenDialog: true))
                                            .then((value) {
                                          setState(() {
                                            logo = Golbal.congty!.logo ?? "";
                                          });
                                        });
                                      },
                                      child: CachedNetworkImage(
                                        height: 90 * Golbal.textScaleFactor,
                                        fit: BoxFit.cover,
                                        imageUrl: logo,
                                        errorWidget: (context, url, error) =>
                                            Image.asset('assets/logoso.png',
                                                height:
                                                    72 * Golbal.textScaleFactor,
                                                fit: BoxFit.contain),
                                      ))),
                              const SizedBox(height: 20.0),
                              Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 5.0),
                                  child: TextField(
                                    keyboardAppearance: Brightness.light,
                                    onChanged: (txt) {
                                      dataform["user_id"] = txt;
                                    },
                                    onSubmitted: (_) =>
                                        FocusScope.of(context).nextFocus(), //
                                    decoration: const InputDecoration(
                                      hintText: "Tài khoản",
                                      prefixIcon: Icon(Icons.person),
                                      contentPadding: EdgeInsets.fromLTRB(
                                          20.0, 10.0, 20.0, 10.0),
                                    ),
                                  )),
                              Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 5.0),
                                  child: TextField(
                                    keyboardAppearance: Brightness.light,
                                    onChanged: (txt) {
                                      dataform["is_password"] = txt;
                                    },
                                    obscureText: !showPass,
                                    decoration: InputDecoration(
                                      hintText: "Mật khẩu",
                                      prefixIcon: const Icon(Icons.vpn_key),
                                      suffixIcon: IconButton(
                                          icon: Icon(showPass
                                              ? Ionicons.ios_eye
                                              : Ionicons.ios_eye_off),
                                          onPressed: () {
                                            setState(() {
                                              showPass = !showPass;
                                            });
                                          }),
                                      contentPadding: const EdgeInsets.fromLTRB(
                                          20.0, 10.0, 20.0, 10.0),
                                    ),
                                  )),
                              Padding(
                                  padding: const EdgeInsets.only(top: 50.0),
                                  child: ConstrainedBox(
                                      constraints: const BoxConstraints(
                                          minWidth: double.infinity,
                                          minHeight: 45.0),
                                      child: ElevatedButton(
                                        //Color(0xFF0078D4)
                                        style: ButtonStyle(
                                            shape: MaterialStateProperty.all<
                                                    RoundedRectangleBorder>(
                                                RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20.0),
                                        ))),
                                        onPressed: _handleSignIn,
                                        child: const Text(
                                          "Đăng nhập",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 16.0),
                                        ),
                                      ))),
                              Padding(
                                  padding: const EdgeInsets.only(top: 15.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      TextButton(
                                          onPressed: sendOTP,
                                          child: const Text(
                                            "Bạn quên mật khẩu?",
                                            style: TextStyle(
                                                color: Colors.black54,
                                                fontSize: 16.0),
                                          )),
                                      // TextButton(
                                      //     onPressed: () async {},
                                      //     child: const Text(
                                      //       "Xoá cache",
                                      //       style: TextStyle(
                                      //           color: Colors.black54,
                                      //           fontSize: 16.0),
                                      //     ))
                                    ],
                                  )),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ))));
  }
}
