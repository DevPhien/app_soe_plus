import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:soe/utils/golbal/golbal.dart';
import 'package:soe/views/component/dialog.dart';

class GiahanTaskController extends GetxController {
  ScrollController scrollController = ScrollController();
  final textController = TextEditingController();
  //Declare
  var loading = true.obs;
  var loaddingmore = false;
  var lastdata = false.obs;
  var showFab = false.obs;
  var task = {}.obs;
  var datas = [].obs;
  var countdata = 0.obs;
  var isGiahan = false.obs;
  var giahan = {}.obs;
  var sendding = false.obs;

  //Function
  Future<void> openModelGiahan(context) async {
    var rs = await Animateddialogbox.showScaleAlertBox(
      context: context,
      firstButton: MaterialButton(
        // FIRST BUTTON IS REQUIRED
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(40),
        ),
        color: Colors.white,
        child: const Text('Huỷ'),
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
        color: Golbal.appColor,
        padding: const EdgeInsets.symmetric(horizontal: 30.0),
        child: const Text(
          'Gửi',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        onPressed: () {
          if (giahan["HanxulyMoi"] == null) {
            EasyLoading.showError("Bạn phải chọn ngày xin gia hạn!");
            return;
          }
          Navigator.of(context).pop(true);
        },
      ),
      icon: Container(width: 0.0), // IF YOU WANT TO ADD ICON
      yourWidget: StatefulBuilder(
        builder: (context, setState) {
          return Container(
            width: double.maxFinite,
            constraints:
                BoxConstraints(maxHeight: Golbal.screenSize.height * 0.8),
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  const Text(
                    "Gia hạn xử lý công việc",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 25.0),
                  Row(
                    children: <Widget>[
                      const Text("Hạn xử lý cũ",
                          style:
                              TextStyle(fontSize: 13.0, color: Colors.black54)),
                      const Spacer(),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(40),
                          color: const Color(0xff6fbf73),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 10.0),
                        child: Text(
                          giahan["HanxulyCu"] != null
                              ? Golbal.formatDate(giahan["HanxulyCu"], "d/m/Y",
                                  nam: true)
                              : "Chưa chọn",
                          style: const TextStyle(
                            fontSize: 13.0,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10.0),
                  Row(
                    children: <Widget>[
                      const Text("Hạn xử lý mới",
                          style:
                              TextStyle(fontSize: 13.0, color: Colors.black54)),
                      const Spacer(),
                      Obx(
                        () => MaterialButton(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(40),
                          ),
                          color: const Color(0xFFff8b4e),
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: Text(
                            giahan["HanxulyMoi"] != null
                                ? Golbal.formatDate(
                                    giahan["HanxulyMoi"], "d/m/Y",
                                    nam: true)
                                : "Chưa chọn",
                            style: const TextStyle(
                              fontSize: 13.0,
                              color: Colors.white,
                            ),
                          ),
                          onPressed: () {
                            ngayHanxulyMoi(context);
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20.0),
                  ConstrainedBox(
                    constraints: const BoxConstraints(
                      maxHeight: 250.0,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          reverse: true,
                          child: TextField(
                            keyboardAppearance: Brightness.light,
                            textInputAction: TextInputAction.newline,
                            maxLines: null,
                            minLines: 5,
                            onChanged: (String txt) {
                              giahan["Lydo"] = txt;
                            },
                            decoration: const InputDecoration(
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
                              hintText: 'Nội dung gia hạn',
                              hintStyle: TextStyle(fontSize: 13.0),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 5.0),
                ],
              ),
            ),
          );
        },
      ),
    );
    if (rs == true) {
      updateGiahan();
    }
  }

  Future<void> ngayHanxulyMoi(context) async {
    DateTime d = giahan["HanxulyMoi"] != null
        ? DateTime.parse(giahan["HanxulyMoi"])
        : DateTime.now();
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: d,
        firstDate: DateTime.now(),
        lastDate: DateTime(2101));
    if (picked != null && picked != d) {
      giahan["HanxulyMoi"] = picked.toIso8601String();
    }
  }

  void updateGiahan() async {
    try {
      if (sendding.value) {
        EasyLoading.showInfo(
            "Đang cập nhật gia hạn, vui lòng thao tác chậm lại!");
      }

      if (giahan["NgayKetThucHienTai"] is DateTime) {
        giahan["NgayKetThucHienTai"] =
            giahan["NgayKetThucHienTai"].toIso8601String();
      }
      if (giahan["HanxulyMoi"] is DateTime) {
        giahan["HanxulyMoi"] = giahan["HanxulyMoi"].toIso8601String();
      }
      giahan["HanxulyCu"] = giahan["HanxulyMoi"];
      if (task["quanly"] == true) {
        giahan["Dongy"] = true;
        giahan["Nguoiduyet"] = giahan["Nguoigiahan"];
        // congViecBloc.setTT(
        //     TrangThaiCongviec(hanxuly: DateTime.parse(giahan["HanxulyCu"])));
      }

      sendding.value = true;
      EasyLoading.show(status: "loading...");
      Dio dio = Dio();
      dio.options.headers["Authorization"] = "Bearer ${Golbal.store.token}";
      dio.options.followRedirects = true;
      var response = await dio.put(
        "${Golbal.congty!.api}/api/Task/Update_GiahanTask",
        data: {
          "user_id": Golbal.store.user["user_id"],
          "giahan": giahan,
        },
      );

      var data = response.data;
      sendding.value = false;
      if (data["err"] == 1) {
        EasyLoading.showError("Có lỗi xảy ra, vui lòng thử lại");
      }
      initData();
      EasyLoading.showSuccess("Gửi gia hạn thành công");
    } catch (e) {
      sendding.value = false;
      EasyLoading.dismiss();
      if (kDebugMode) {
        print(e);
      }
    }
  }

  Future<void> funreview(context, item, bool f) async {
    giahan.value = item;
    var rs = await Animateddialogbox.showScaleAlertBox(
        context: context,
        firstButton: MaterialButton(
          // FIRST BUTTON IS REQUIRED
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(40),
          ),
          color: Colors.white,
          child: const Text('Huỷ'),
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
          color: Golbal.appColor,
          padding: const EdgeInsets.symmetric(horizontal: 30.0),
          child: const Text(
            'Gửi',
            style: TextStyle(color: Colors.white),
          ),
          onPressed: () {
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
                  "${f ? "Đồng ý" : "Không đồng ý"} gia hạn",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 15.0),
                if (f) ...[
                  Row(
                    children: <Widget>[
                      const Text("Hạn xử lý hiện tại",
                          style:
                              TextStyle(fontSize: 13.0, color: Colors.black54)),
                      const Spacer(),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(40),
                          color: const Color(0xff6fbf73),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 10.0),
                        child: Text(
                          task["NgayKetThuc"] != null
                              ? Golbal.formatDate(task["NgayKetThuc"], "d/m/Y",
                                  nam: true)
                              : "Chưa chọn",
                          style: const TextStyle(
                            fontSize: 13.0,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
                const SizedBox(height: 10.0),
                if (f) ...[
                  Row(
                    children: <Widget>[
                      const Text("Hạn xử lý đề xuất",
                          style:
                              TextStyle(fontSize: 13.0, color: Colors.black54)),
                      const Spacer(),
                      MaterialButton(
                        // OPTIONAL BUTTON
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(40),
                        ),
                        color: const Color(0xFFff8b4e),
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Text(
                          giahan["HanxulyMoi"] != null
                              ? Golbal.formatDate(giahan["HanxulyMoi"], "d/m/Y",
                                  nam: true)
                              : "Chưa chọn",
                          style: const TextStyle(
                            fontSize: 13.0,
                            color: Colors.white,
                          ),
                        ),
                        onPressed: () {
                          ngayHanxulyMoi(context);
                        },
                      ),
                    ],
                  ),
                ],
                const SizedBox(height: 10.0),
                ConstrainedBox(
                    constraints: const BoxConstraints(
                      maxHeight: 250.0,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            reverse: true,
                            child: TextField(
                              keyboardAppearance: Brightness.light,
                              textInputAction: TextInputAction.newline,
                              maxLines: null,
                              minLines: 5,
                              onChanged: (String txt) {
                                giahan["Traloi"] = txt;
                              },
                              decoration: const InputDecoration(
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
                                hintText: 'Ghi chú',
                                hintStyle: TextStyle(fontSize: 13.0),
                              ),
                            ))
                      ],
                    )),
                const SizedBox(height: 5.0),
              ],
            )),
          );
        }));
    if (rs == true) {
      sendding.value = false;
      giahan["Dongy"] = f;
      updateDongyGiahan();
    }
  }

  void updateDongyGiahan() async {
    try {
      if (sendding.value) {
        EasyLoading.showInfo(
            "Đang cập nhật gia hạn, vui lòng thao tác chậm lại!");
      }

      if (giahan["NgayKetThucHienTai"] is DateTime) {
        giahan["NgayKetThucHienTai"] =
            giahan["NgayKetThucHienTai"].toIso8601String();
      }
      if (giahan["HanxulyMoi"] is DateTime) {
        giahan["HanxulyMoi"] = giahan["HanxulyMoi"].toIso8601String();
      }
      if (giahan["HanxulyCu"] is DateTime) {
        giahan["HanxulyCu"] = giahan["HanxulyCu"].toIso8601String();
      }
      giahan["HanxulyCu"] = giahan["HanxulyMoi"];
      if (task["quanly"] == true) {
        giahan["Dongy"] = true;
        giahan["Nguoiduyet"] = giahan["Nguoigiahan"];
        // congViecBloc.setTT(
        //     TrangThaiCongviec(hanxuly: DateTime.parse(giahan["HanxulyCu"])));
      }

      sendding.value = true;
      EasyLoading.show(status: "loading...");
      Dio dio = Dio();
      dio.options.headers["Authorization"] = "Bearer ${Golbal.store.token}";
      dio.options.followRedirects = true;
      var response = await dio.put(
        "${Golbal.congty!.api}/api/Task/Update_DongyGiahanTask",
        data: {
          "user_id": Golbal.store.user["user_id"],
          "giahan": giahan,
        },
      );

      var data = response.data;
      sendding.value = false;
      if (data["err"] == 1) {
        EasyLoading.showError("Có lỗi xảy ra, vui lòng thử lại");
      }
      initData();
      EasyLoading.showSuccess("Xác nhận gia hạn thành công");
    } catch (e) {
      sendding.value = false;
      EasyLoading.dismiss();
      if (kDebugMode) {
        print(e);
      }
    }
  }

  //init
  @override
  void onInit() {
    super.onInit();
    task.value = Get.arguments;
    isGiahan.value =
        ((task["isthuchien"] == true || task["isgiaoviec"] == true) &&
            task["close"] != true);
    giahan.value = {
      "DuanID": task["DuanID"],
      "CongviecID": task["CongviecID"],
      "NgayKetThucHienTai": task["NgayKetThuc"],
      "HanxulyCu": task["NgayKetThuc"],
      "Lydo": textController.text,
      "Nguoigiahan": Golbal.store.user["user_id"],
      "Ngaygiahan": DateTime.now().toIso8601String()
    };
    initData();
  }

  void initData() async {
    try {
      loading.value = true;
      EasyLoading.show(status: "loading...");
      Dio dio = Dio();
      dio.options.headers["Authorization"] = "Bearer ${Golbal.store.token}";
      dio.options.followRedirects = true;
      var response = await dio.post(
        "${Golbal.congty!.api}/api/Task/Get_Giahan",
        data: {
          "user_id": Golbal.store.user["user_id"],
          "CongviecID": task["CongviecID"],
        },
      );
      var data = response.data;
      loading.value = false;
      if (data["err"] == 1) {
        EasyLoading.showError("Có lỗi xảy ra, vui lòng thử lại");
      }
      if (data != null) {
        var tbs = List.castFrom(json.decode(data["data"]));
        if (tbs[0].isNotEmpty) {
          datas.value = tbs[0];
        }
      }
      EasyLoading.dismiss();
    } catch (e) {
      loading.value = false;
      EasyLoading.dismiss();
      if (kDebugMode) {
        print(e);
      }
    }
  }
}
