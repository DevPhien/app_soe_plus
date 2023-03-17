import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:image_picker/image_picker.dart';
import 'package:location/location.dart';
import 'package:path_provider/path_provider.dart';
import 'package:simple_barcode_scanner/simple_barcode_scanner.dart';
import 'package:soe/utils/golbal/golbal.dart';
import 'package:dio/dio.dart' as dioform;
import 'package:flutter_face_api/face_api.dart' as regula;
import 'package:uuid/uuid.dart';
import 'package:wifi_info_flutter/wifi_info_flutter.dart';

import '../../../flutter_flow/flutter_flow_util.dart';

class QRCodeView2 extends StatefulWidget {
  final dynamic checkin;
  final bool isInout;
  final String? face;
  const QRCodeView2({
    Key? key,
    this.checkin,
    this.face,
    required this.isInout,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _QRViewExampleState();
}

class _QRViewExampleState extends State<QRCodeView2> {
  //final Location location = Location();
  var qrText = '';
  String qrcode = "";
  String defeaultcode = "";
  String checkinID = "";
  String filename = "";
  int isType = 1;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  String dName = "";
  File? _image;
  final picker = ImagePicker();
  @override
  void initState() {
    super.initState();
    bindListQrcode();
  }

  bindListQrcode() async {
    if (widget.checkin != null) {
      qrcode = widget.checkin["Qrcode"];
      defeaultcode = widget.checkin["QRcodeDefault"];
      checkinID = widget.checkin["Checkin_ID"];
      isType = widget.checkin["CIsType"];
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
        "/Portals/${Golbal.store.user["organization_id"]}/SHRM/Checkin/${DateFormat("dMy").format(widget.checkin["Date"])}/";

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
    //     filename: "FaceImage"));
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
      EasyLoading.show(status: "Đang check xác minh khuôn mặt...");
      regula.MatchFacesImage im1 = regula.MatchFacesImage();
      regula.MatchFacesImage im2 = regula.MatchFacesImage();
      im1.imageType = regula.ImageType.PRINTED;
      im2.imageType = regula.ImageType.PRINTED;
      im1.bitmap = widget.face;
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
    if (tyle < 90) {
      EasyLoading.showError("Khôn mặt đăng ký không đúng với tài khoản này!.");
      return;
    }
    EasyLoading.show(status: "Đang check ${inout ? " in" : " out"}...");
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
      final WifiInfo wifiInfo = WifiInfo();
      wifiName = (await wifiInfo.getWifiName());
      wifiIP = (await wifiInfo.getWifiIP());
    }
    var finame = await saveFaceImage();
    var par = {
      "Checkin_ID": checkinID,
      "Congty_ID": Golbal.store.user["organization_id"],
      "NhanSu_ID": Golbal.store.user["user_id"],
      "GioCheckin ": DateTime.now().toIso8601String(),
      "FullName": Golbal.store.user["fullName"],
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
      "Lydo": "",
      "IsWork": 1,
      "IsDuyet": 1,
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
      EasyLoading.showSuccess("Check in thành công!.");
      // ignore: use_build_context_synchronously
      Navigator.of(context).pop();
    } else {
      _showMaterialDialog(res.data["ms"]);
    }
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
          title: Text(widget.isInout == false ? "Check Out" : "Check in",
              style: TextStyle(
                  color: Golbal.titleappColor, fontWeight: FontWeight.bold)),
          centerTitle: true,
          systemOverlayStyle: SystemUiOverlayStyle.light),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Expanded(
              child: _image != null
                  ? Image.file(_image!)
                  : InkWell(
                      onTap: goQRcode,
                      child: Container(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            children: const [
                              Icon(Icons.qr_code_2_outlined),
                              Text("Quét mã QRcode")
                            ],
                          )),
                    )),
          SafeArea(
              child: qrText != ""
                  ? Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 20.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
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
                          const SizedBox(width: 20.0),
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
                  : const SizedBox.shrink()),
        ],
      ),
    );
  }

  Future<void> goQRcode() async {
    var res = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const SimpleBarcodeScannerPage(),
        ));
    if (res is String) {
      await getImage(res);
    }
  }

  Future getImage(String scanData) async {
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
          // final ImagePicker picker = ImagePicker();
          // final pickedFile = await picker.pickImage(
          //     source: ImageSource.camera,
          //     maxHeight: 1280,
          //     maxWidth: 720,
          //     imageQuality: 90,
          //     preferredCameraDevice: CameraDevice.front); //
          // _image = File(pickedFile!.path);
          // setState(() {
          //   qrText = scanData;
          // });
          regula.FaceSDK.presentFaceCaptureActivity().then((result) async {
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
  void dispose() {
    super.dispose();
  }
}
