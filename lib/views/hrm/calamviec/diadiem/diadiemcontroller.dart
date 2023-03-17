import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:geocoder2/geocoder2.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart' as dioform;
import '../../../../utils/golbal/golbal.dart';

class DiadiemlamController extends GetxController {
  var datas = [].obs;
  Future<void> initData() async {
    EasyLoading.show(status: "Đang load dữ liệu...");
    dioform.FormData formData = dioform.FormData.fromMap({
      "proc": "App_Diadiem_List",
      "pas": json.encode({
        "Congty_ID": Golbal.store.user["organization_id"],
      })
    });
    dioform.Dio dio = dioform.Dio();
    dio.options.headers["Authorization"] = "Bearer ${Golbal.store.token}";
    dio.options.followRedirects = true;
    var res = await dio.post("${Golbal.congty!.api}/api/HomeApi/callProc",
        data: formData);
    if (res.data["err"] == "0") {
      datas.value = json.decode(res.data["data"])[0];
      EasyLoading.dismiss();
    } else {
      EasyLoading.showError("Có lỗi xảy ra, vui lòng thử lại!");
    }
  }

  Future<void> addDiadiemlamviec(model) async {
    if (model["tendiadiem"] == null || model["tendiadiem"] == "") {
      EasyLoading.showError("Vui lòng nhập tên địa điểm làm việc");
      return;
    }
    if (model["diachi"] == null || model["diachi"] == "") {
      EasyLoading.showError("Vui lòng nhập địa chỉ làm việc");
      return;
    }
    EasyLoading.show(status: "Đang thực hiện...");
    if (model["CheckinLatLong"] == null || model["CheckinLatLong"] == "") {
      try {
        GeoData data = await Geocoder2.getDataFromAddress(
            address: model["diachi"], googleMapApiKey: Golbal.googleApiKey);
        model["CheckinLatLong"] = "${data.latitude},${data.longitude}";
      } catch (e) {}
    }
    var objpar = {
      "Congty_ID": model["Congty_ID"],
      "tendiadiem ": model["tendiadiem"],
      "diachi": model["diachi"],
      "CheckinLatLong": model["CheckinLatLong"],
      "bankinh": model["bankinh"] ?? 100,
      "qrcode": model["qrcode"] ?? false,
      "trangthai": model["trangthai"]
    };
    String proc = "App_Diadiemlamviec_Add";
    if (model["diadiemid"] != null) {
      objpar = {
        "diadiemid": model["diadiemid"],
        "tendiadiem ": model["tendiadiem"],
        "diachi": model["diachi"],
        "CheckinLatLong": model["CheckinLatLong"],
        "bankinh": model["bankinh"] ?? 100,
        "qrcode": model["qrcode"] ?? false,
        "trangthai": model["trangthai"]
      };
      proc = "App_Diadiemlamviec_Update";
    }
    var strpar = json.encode(objpar);
    dioform.FormData formData =
        dioform.FormData.fromMap({"proc": proc, "pas": strpar});
    dioform.Dio dio = dioform.Dio();
    dio.options.headers["Authorization"] = "Bearer ${Golbal.store.token}";
    dio.options.followRedirects = true;
    var res = await dio.post("${Golbal.congty!.api}/api/HomeApi/callProc",
        data: formData);
    if (res.data["err"] == "0") {
      EasyLoading.showSuccess("Cập nhật địa điểm làm việc thành công!");
      initData();
      Get.back();
    } else {
      EasyLoading.showError("Có lỗi xảy ra, vui lòng thử lại!");
    }
  }

  Future<void> delDiadiemlamviec(item) async {
    bool rs = await showDialog(
        context: Get.context!,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            //title: new Text('Thông báo'),
            content: SingleChildScrollView(
              child: ListBody(
                children: const <Widget>[
                  Text("Bạn có muốn xoá địa điểm làm việc này không?"),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: Text(
                  'Có',
                  style: TextStyle(color: Golbal.appColor, fontSize: 16.0),
                ),
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
              ),
              TextButton(
                child: const Text(
                  'Không',
                  style: TextStyle(color: Colors.black45, fontSize: 16.0),
                ),
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
              ),
            ],
          );
        });
    if (rs) {
      EasyLoading.show(status: "Đang thực hiện...");
      dioform.FormData formData = dioform.FormData.fromMap({
        "proc": "App_Diadiemlamviec_Delete",
        "pas": json.encode({
          "diadiemid": item["diadiemid"],
        })
      });
      dioform.Dio dio = dioform.Dio();
      dio.options.headers["Authorization"] = "Bearer ${Golbal.store.token}";
      dio.options.followRedirects = true;
      var res = await dio.post("${Golbal.congty!.api}/api/HomeApi/callProc",
          data: formData);
      if (res.data["err"] == "0") {
        datas.remove(item);
        EasyLoading.dismiss();
      } else {
        EasyLoading.showError("Có lỗi xảy ra, vui lòng thử lại!");
      }
    }
  }

  @override
  void onInit() {
    super.onInit();
    initData();
  }

  @override
  void onClose() {
    EasyLoading.dismiss();
    super.onClose();
  }
}
