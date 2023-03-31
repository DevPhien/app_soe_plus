import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:location/location.dart';
import 'package:path_provider/path_provider.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:dio/dio.dart' as dioform;
import 'package:flutter_face_api/face_api.dart' as regula;
import 'package:uuid/uuid.dart';
import 'package:network_info_plus/network_info_plus.dart';
import '../../../flutter_flow/flutter_flow_util.dart';
import '../../../utils/golbal/golbal.dart';
import 'QRcodeView2.dart';

class QRCode extends StatefulWidget {
  // final dynamic checkin;
  // final bool isInout;
  // final String? face;
  const QRCode({
    Key? key,
    // this.checkin,
    // this.face,
    // required this.isInout,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _QRViewExampleState();
}

class _QRViewExampleState extends State<QRCode> {
  var argument = {}.obs;

  //final Location location = Location();
  var qrText = '';
  bool flashState = true;
  bool cameraState = true;
  late QRViewController controller;
  String qrcode = "";
  String defeaultcode = "";
  String checkinID = "";
  String filename = "";
  int isType = 1;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  String dName = "";
  File? _image;
  String face = "";
  final picker = ImagePicker();
  @override
  void initState() {
    super.initState();
    argument.value = Get.arguments;
    initFace();
    bindListQrcode();
  }

  Future<void> initFace() async {
    var par = {
      "NhanSu_ID": Golbal.store.user["user_id"],
    };
    var strpar = json.encode(par);
    dioform.FormData formData =
        dioform.FormData.fromMap({"proc": "App_GetNhansuFace", "pas": strpar});
    dioform.Dio dio = dioform.Dio();
    dio.options.headers["Authorization"] = "Bearer ${Golbal.store.token}";
    dio.options.followRedirects = true;
    var res = await dio.post("${Golbal.congty!.api}/api/HomeApi/callProc",
        data: formData);
    if (res.data != null && res.data["error"] != 1) {
      var dts = List.castFrom(json.decode(res.data["data"])[0]);
      if (dts.isNotEmpty) face = dts[0]["Face"] ?? "";
    }
  }

  bindListQrcode() async {
    if (argument["checkin"] != null) {
      qrcode = argument["checkin"]["Qrcode"];
      defeaultcode = argument["checkin"]["QRcodeDefault"];
      checkinID = argument["checkin"]["Checkin_ID"];
      isType = argument["checkin"]["CIsType"];
      filename = Golbal.store.user["user_id"] +
          "_" +
          "${DateTime.now().hour}_${DateTime.now().minute}" +
          ".png";
      return;
    }
    var par = {
      "Congty_ID": Golbal.store.user["organization_id"],
    };
    var strpar = json.encode(par);
    dioform.FormData formData =
        dioform.FormData.fromMap({"proc": "App_GetOS_Checkin", "pas": strpar});
    dioform.Dio dio = dioform.Dio();
    dio.options.headers["Authorization"] = "Bearer ${Golbal.store.token}";
    dio.options.followRedirects = true;
    var res = await dio.post("${Golbal.congty!.api}/api/HomeApi/callProc",
        data: formData);

    if (res.data != null && res.data["data"] != null) {
      var arr = List.castFrom(json.decode(res.data["data"]));
      if (arr.isEmpty) {
        EasyLoading.showError(
          "Không thể checkin trong lúc này, vui lòng quay lại sau!.",
        );
        return;
      }
      qrcode = arr[0][0]["Qrcode"];
      defeaultcode = arr[0][0]["QRcodeDefault"];
      checkinID = arr[0][0]["Checkin_ID"];
      isType = arr[0][0]["IsType"];
      filename = Golbal.store.user["user_id"] +
          "_" +
          "${DateTime.now().hour}_${DateTime.now().minute}" +
          ".png";
    }
  }

  Future<String?> saveFaceImage() async {
    String path =
        "/Portals/${Golbal.store.user["organization_id"]}/SHRM/Checkin/${DateFormat("dMy").format(argument["checkin"]["Date"])}/";
    var mdata = {
      // "key": "t",
      // "FileNames": "$filename,Thumb_$filename",
      // "Congty_ID": Golbal.store.user["organization_id"],
      // "path": path,
      "models": json.encode({"path": path}),
      "files": [],
    };
    var ffiles = [];
    ffiles.add(
        await dioform.MultipartFile.fromFile(_image!.path, filename: filename));
    // ffiles.add(await dioform.MultipartFile.fromFile(_imageThumb!.path,
    //     filename: "FaceImageThumb"));
    mdata["files"] = ffiles;
    dioform.FormData formData = dioform.FormData.fromMap(mdata);
    dioform.Dio dio = dioform.Dio();
    dio.options.headers["Authorization"] = "Bearer ${Golbal.store.token}";
    dio.options.followRedirects = true;
    var res = await dio.put("${Golbal.congty!.api}/api/HomeApi/uploadFiles",
        data: formData);
    if (res.data != null) {
      return path + filename;
    }
    return null;
  }

  _showMaterialDialog(err) {
    showDialog(
        context: context,
        builder: (_) => AlertDialog(
              title: const Text("SOE"),
              content: SingleChildScrollView(child: Text(err ?? "")),
              actions: <Widget>[
                TextButton(
                  child: const Text('Đóng'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ],
            ));
  }

  Future<double> compareFace() async {
    try {
      print("face=${face.length}");
      EasyLoading.show(status: "Đang check xác minh khuôn mặt...");
      regula.MatchFacesImage im1 = regula.MatchFacesImage();
      regula.MatchFacesImage im2 = regula.MatchFacesImage();
      im1.imageType = regula.ImageType.PRINTED;
      im2.imageType = regula.ImageType.PRINTED;
      im1.bitmap = face;
      im2.bitmap = base64Encode(_image!.readAsBytesSync());
      var request = regula.MatchFacesRequest();
      request.images = [im1, im2];
      var value = await regula.FaceSDK.matchFaces(jsonEncode(request));
      var response = regula.MatchFacesResponse.fromJson(json.decode(value));
      var str = await regula.FaceSDK.matchFacesSimilarityThresholdSplit(
          jsonEncode(response!.results), 0.75);
      var split =
          regula.MatchFacesSimilarityThresholdSplit.fromJson(json.decode(str));
      EasyLoading.dismiss();
      return split!.matchedFaces.isNotEmpty
          ? (split.matchedFaces[0]!.similarity! * 100)
          : 0.0;
    } catch (e) {
      EasyLoading.dismiss();
      return 0;
    }
  }

  Future<void> checkIn(bool inout) async {
    if (qrText != qrcode && qrText != defeaultcode) {
      EasyLoading.showError("Mã QRcode không đúng!.");
      return;
    }
    var tyle = await compareFace();
    String lydo = "";
    int isDuyet = 1;
    if (tyle < 90) {
      EasyLoading.showError("Khuôn mặt đăng ký không đúng với tài khoản này!.");
      lydo = "Khuôn mặt đăng ký không đúng với tài khoản này ($tyle%)!.";
      isDuyet = -1;
      //return;
    }
    EasyLoading.showToast(tyle.toString());
    //So sánh khuôn mặt
    EasyLoading.show(
        status: "Đang check ${inout ? "in" : "out"}...", dismissOnTap: true);
    Location location = Location();
    bool serviceEnabled;
    PermissionStatus permissionGranted;
    LocationData? locationData;
    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        EasyLoading.showError(
            "Vui lòng bật định vị trước khi quét mã QRcode!.");
        return;
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        EasyLoading.showError(
            "Vui lòng bật định vị trước khi quét mã QRcode!.");
        return;
      }
    }
    try {
      locationData = await location.getLocation();
    } on PlatformException catch (e) {
      locationData = null;
    }
    String? wifiIP = "";
    String? wifiName = "MacOS";
    if (Platform.isAndroid || Platform.isIOS) {
      final NetworkInfo wifiInfo = NetworkInfo();
      wifiName = (await wifiInfo.getWifiName());
      wifiIP = (await wifiInfo.getWifiIP());
    }
    var finame = await saveFaceImage();
    var par = {
      "Checkin_ID": checkinID,
      "Congty_ID": Golbal.store.user["organization_id"],
      "NhanSu_ID": Golbal.store.user["user_id"],
      "GioCheckin ": DateTime.now().toIso8601String(),
      "FullName": Golbal.store.user["FullName"],
      "FromIP": wifiIP,
      "FromDivice": Golbal.store.device["deviceName"],
      "Latlong": locationData == null
          ? ""
          : "${locationData.latitude},${locationData.longitude}",
      "Wifi": wifiName,
      "IsInOut": inout.toString(),
      "FaceImage": finame,
      "IsType": isType.toString(),
      "IsAuto": "True",
      "Lydo": lydo,
      "IsWork": 1,
      "IsDuyet": isDuyet,
      "Nguoiduyet": Golbal.store.user["user_id"],
      "Ngayduyet": DateTime.now().toIso8601String(),
      "Ngaycong": DateTime.now().toIso8601String(),
      "Nguoicapnhat": Golbal.store.user["user_id"],
      "Ngaycapnhat": DateTime.now().toIso8601String(),
    };
    var strpar = json.encode(par);
    dioform.FormData formData =
        dioform.FormData.fromMap({"proc": "App_Checkin", "pas": strpar});
    dioform.Dio dio = dioform.Dio();
    dio.options.headers["Authorization"] = "Bearer ${Golbal.store.token}";
    dio.options.followRedirects = true;
    var res = await dio.post("${Golbal.congty!.api}/api/HomeApi/callProc",
        data: formData);
    EasyLoading.dismiss();
    if (res.data != null && res.data["error"] != 1) {
      EasyLoading.showSuccess(
          inout ? "Check in thành công!." : "Check out thành công!.");
      // ignore: use_build_context_synchronously
      //Navigator.of(context).pop();
      Get.back(result: true);
    } else {
      _showMaterialDialog(res.data["ms"]);
    }
  }

  void goQR2() {
    Navigator.of(context).pop();
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => QRCodeView2(
            checkin: argument["checkin"],
            isInout: argument["isInout"],
            face: argument["face"],
            key: null,
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffffffff),
      appBar: AppBar(
        backgroundColor: Golbal.appColorD,
        leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: () {
              Navigator.of(context).pop();
            }),
        elevation: 0.0,
        titleSpacing: 0.0,
        iconTheme: IconThemeData(color: Golbal.iconColor),
        title: Text(argument["isInout"] == false ? "Check Out" : "Check in",
            style: TextStyle(
                color: Golbal.titleappColor, fontWeight: FontWeight.bold)),
        centerTitle: true,
        systemOverlayStyle: SystemUiOverlayStyle.light,
        actions: [
          IconButton(
              onPressed: goQR2, icon: const Icon(Icons.qr_code_2_outlined))
        ],
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: _image != null
                ? Image.file(_image!)
                : QRView(
                    key: qrKey,
                    onQRViewCreated: _onQRViewCreated,
                    overlay: QrScannerOverlayShape(
                      borderColor: Colors.red,
                      borderRadius: 10,
                      borderLength: 30,
                      borderWidth: 10,
                      cutOutSize: 300,
                    ),
                  ),
          ),
          SafeArea(
              child: qrText != ""
                  ? Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 20.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (argument["isInout"])
                            Expanded(
                                child: ElevatedButton(
                                    onPressed: () {
                                      checkIn(true);
                                    },
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: Golbal.appColor),
                                    child: const Text(
                                      "Checkin",
                                      style: TextStyle(color: Colors.white),
                                    ))),
                          if (!argument["isInout"])
                            Expanded(
                                child: ElevatedButton(
                                    onPressed: () {
                                      checkIn(false);
                                    },
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.red),
                                    child: const Text(
                                      "Checkout",
                                      style: TextStyle(color: Colors.white),
                                    ))),
                        ],
                      ),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                          margin: const EdgeInsets.all(8),
                          child: IconButton(
                            onPressed: () {
                              controller.toggleFlash();
                              setState(() {
                                flashState = !flashState;
                              });
                            },
                            icon: Icon(flashState
                                ? Ionicons.ios_flash_off
                                : Ionicons.ios_flash),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.all(8),
                          child: IconButton(
                            onPressed: () {
                              controller.flipCamera();
                              setState(() {
                                cameraState = !cameraState;
                              });
                            },
                            icon: Icon(cameraState
                                ? Ionicons.ios_camera
                                : Ionicons.camera_reverse_outline),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.all(8),
                          child: IconButton(
                            onPressed: () {
                              controller.pauseCamera();
                            },
                            icon: const Icon(Icons.stop),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.all(8),
                          child: IconButton(
                            onPressed: () {
                              controller.resumeCamera();
                            },
                            icon: const Icon(Icons.play_circle_filled),
                          ),
                        )
                      ],
                    )),
        ],
      ),
    );
  }

  Future<void> _onQRViewCreated(QRViewController controller) async {
    this.controller = controller;
    try {
      await controller.resumeCamera();
    } catch (e) {}
    controller.scannedDataStream.listen((scanData) async {
      await getImage(scanData.code ?? "");
    }).onError((e) {
      Widget okButton = TextButton(
        child: const Text("OK"),
        onPressed: () {},
      );

      // set up the AlertDialog
      AlertDialog alert = AlertDialog(
        title: const Text("Lỗi Qrcode"),
        content: SingleChildScrollView(child: Text(e.toString())),
        actions: [
          okButton,
        ],
      );

      // show the dialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return alert;
        },
      );
    });
  }

  Future getImage(String scanData) async {
    controller.dispose();
    try {
      if (scanData != qrcode && scanData != defeaultcode) {
        EasyLoading.showError("Mã QRcode không đúng!.");
        return;
      }
      // EasyLoading.showInfo(
      //     "Vui lòng chụp ảnh check in của bạn bằng Camera trước.");
      Widget okButton = TextButton(
        child: const Text("OK"),
        onPressed: () async {
          Navigator.pop(context);
          controller.dispose();
          await Future.delayed(const Duration(seconds: 1));
          await regula.FaceSDK.presentFaceCaptureActivity()
              .then((result) async {
            try {
              var img = base64Decode(
                  regula.FaceCaptureResponse.fromJson(json.decode(result))!
                      .image!
                      .bitmap!
                      .replaceAll("\n", ""));
              final tempDir = await getTemporaryDirectory();
              var uuid = const Uuid();
              _image =
                  await File('${tempDir.path}/face${uuid.v4()}.png').create();
              _image!.writeAsBytesSync(img);
            } catch (e) {
              Navigator.pop(context);
            }
            setState(() {
              qrText = scanData;
            });
          });
        },
      );

      // set up the AlertDialog
      AlertDialog alert = AlertDialog(
        title: const Text("Thông báo"),
        content: const SingleChildScrollView(
            child:
                Text("Vui lòng chụp ảnh check in của bạn bằng camera trước!")),
        actions: [
          okButton,
        ],
      );

      // show the dialog
      await showDialog(
        context: context,
        builder: (BuildContext context) {
          return alert;
        },
      );
    } catch (e) {}
  }

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller.pauseCamera();
    } else if (Platform.isIOS) {
      controller.resumeCamera();
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
