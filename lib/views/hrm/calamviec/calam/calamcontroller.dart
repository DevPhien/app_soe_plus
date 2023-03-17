import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart' as dioform;

import '../../../../utils/golbal/golbal.dart';

class CalamController extends GetxController {
  var datas = [].obs;
  Future<void> initData() async {
    EasyLoading.show(status: "Đang load dữ liệu...");
    dioform.FormData formData = dioform.FormData.fromMap({
      "proc": "App_Calamviec_List",
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

  Future<void> addCalamviec(model) async {
    if (model["tenca"] == null || model["tenca"] == "") {
      EasyLoading.showError("Vui lòng nhập tên ca làm việc");
      return;
    }
    if (model["batdau"] == null || model["batdau"] == "") {
      EasyLoading.showError("Vui lòng nhập giờ bắt đầu ca làm việc");
      return;
    }
    if (model["ketthuc"] == null || model["ketthuc"] == "") {
      EasyLoading.showError("Vui lòng nhập giờ kết thúc ca làm việc");
      return;
    }
    EasyLoading.show(status: "Đang thực hiện...");
    var objpar = {
      "Congty_ID": model["Congty_ID"],
      "tenca ": model["tenca"],
      "batdau": model["batdau"],
      "ketthuc": model["ketthuc"],
      "maunen ": model["maunen"],
      "mauchu": model["mauchu"],
      "trangthai": model["trangthai"]
    };
    String proc = "App_Calamviec_Update";
    if (model["caid"] != null) {
      objpar = {
        "caid": model["caid"],
        "tenca ": model["tenca"],
        "batdau": model["batdau"],
        "ketthuc": model["ketthuc"],
        "maunen ": model["maunen"],
        "mauchu": model["mauchu"],
        "trangthai": model["trangthai"]
      };
      proc = "App_Calamviec_Update";
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
      EasyLoading.showSuccess("Cập nhật ca làm việc thành công!");
      initData();
      Get.back();
    } else {
      EasyLoading.showError("Có lỗi xảy ra, vui lòng thử lại!");
    }
  }

  Future<void> delCalamviec(item) async {
    bool rs = await showDialog(
        context: Get.context!,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            //title: new Text('Thông báo'),
            content: SingleChildScrollView(
              child: ListBody(
                children: const <Widget>[
                  Text("Bạn có muốn xoá ca làm việc này không?"),
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
        "proc": "App_Calamviec_Delete",
        "pas": json.encode({
          "caid": item["caid"],
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
