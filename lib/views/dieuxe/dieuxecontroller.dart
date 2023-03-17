import 'dart:convert';
import 'dart:io';

import 'package:art_sweetalert/art_sweetalert.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:open_app_file/open_app_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../utils/golbal/golbal.dart';
import '../vanban/comp/listuser.dart';
import '../vanban/controller/uservanbancontroller.dart';

class DieuxeController extends GetxController {
  RxInt pageIndex = 0.obs;
  RxInt istype = (-1).obs;
  var loaddingmore = false.obs;
  var isloaddingmore = false.obs;
  RxBool isPhieu = true.obs;
  RxBool isLoadding = true.obs;
  var lastdata = false.obs;
  var datas = [].obs;
  var countdata = {}.obs;
  final UserVBController usercontroller = Get.put(UserVBController());
  Map<String, dynamic> options = {
    "p": 1,
    "pz": 20,
    "s": null,
    "filter_congty_id": Golbal.store.user["organization_id"],
    "user_id": Golbal.store.user["user_id"]
  };

  void onPageChanged(int p) {
    datas.clear();
    options["p"] = 1;
    pageIndex.value = p;
    if (pageIndex.value == 0 || pageIndex.value == 1 || pageIndex.value == 2) {
      initCounts();
    }
    //loadData(false);
  }

  void loadData(f) {
    if (!f) {
      datas.clear();
    }
    switch (pageIndex.value) {
      case 1:
        istype.value = 1;
        break;
      case 2:
        istype.value = 2;
        options["user_id"] = null;
        break;
      case 3:
        options["user_id"] = null;
        istype.value = 3;
        break;
      case 4:
        break;
    }
    initPhieuLenh(f);
  }

  initCounts() async {
    try {
      var body = {
        "user_id": Golbal.store.user["user_id"],
        "s": null,
        "fromdate": options["fromdate"]
      };
      Dio dio = Dio();
      dio.options.headers["Authorization"] = "Bearer ${Golbal.store.token}";
      dio.options.followRedirects = true;
      var response = await dio.post(
          "${Golbal.congty!.api}/api/Car/${pageIndex.value == 2 ? "Get_CountTheodoi" : "Get_CountChoduyet"}",
          data: body);
      var data = response.data;
      if (data != null) {
        var tbs = List.castFrom(json.decode(data["data"]));
        if (tbs.isNotEmpty) {
          countdata.value = {
            "totalPhieu": tbs[0][0]["totalPhieu"],
            "totalLenh": tbs[1][0]["totalLenh"]
          };
          initPhieuLenh(false);
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  openFileMobile(url) async {
    String filename = url;
    Directory tempDir = await getTemporaryDirectory();
    String type = filename.substring(filename.lastIndexOf(".")).trim();
    filename = filename.substring(0, filename.lastIndexOf(".")).trim();
    filename = filename.replaceAll(" ", "").replaceAll(".", "_") + type;
    String filePath = "${tempDir.path}/$filename";
    EasyLoading.show(
      status: "Đang hiển thị file ...",
    );
    Dio dio = Dio();
    dio.options.headers["Authorization"] = "Bearer ${Golbal.store.token}";
    dio.options.followRedirects = true;
    try {
      await dio.download(url, filePath);
      await OpenAppFile.open(filePath);
    } catch (e) {}
    EasyLoading.dismiss();
  }

  loadFile(link) async {
    if (link != null) {
      if (defaultTargetPlatform == TargetPlatform.android ||
          defaultTargetPlatform == TargetPlatform.iOS) {
        String url =
            Golbal.congty!.fileurl + link.toString().replaceAll("\\", "/");
        if (defaultTargetPlatform == TargetPlatform.iOS &&
            link.toString().toLowerCase().contains(".pdf")) {
          !await launchUrl(Uri.parse(url),
              mode: LaunchMode.inAppWebView, webOnlyWindowName: "Xem Văn bản");
        } else {
          openFileMobile(url);
        }
      } else {
        String viewUrl = "${Golbal.congty!.fileurl}/Viewer/Index?url=" + link;
        !await launchUrl(Uri.parse(viewUrl),
            mode: LaunchMode.inAppWebView, webOnlyWindowName: "Xem Văn bản");
      }
    }
  }

  toogleDieuxe(g) {
    isPhieu.value = g;
    options["p"] = 1;
    initPhieuLenh(false);
  }

  Future<void> openDate() async {
    final DateTime? picked = await showDatePicker(
      context: Get.context!,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2025),
    );
    if (picked != null) {
      options["fromdate"] = picked.toIso8601String();
    } else {
      options["fromdate"] = null;
    }
    options["p"] = 1;
    initCounts();
  }

  initPhieuLenh(f) async {
    if (!f) datas.clear();
    lastdata.value = false;
    try {
      if (!f) {
        isLoadding.value = true;
      }
      var body = {
        "user_id": options["user_id"] ?? Golbal.store.user["user_id"],
        "is_type": "2",
        "s": options["s"],
      };
      String url = "Car/Get_ListLenhByUser";
      if (pageIndex.value != 0 && !isPhieu.value) {
        url = "Car/Get_ListLenhchoduyet";
      }
      switch (pageIndex.value) {
        case 1:
          body = {
            "user_id": options["user_id"] ?? Golbal.store.user["user_id"],
            "p": options["p"],
            "pz": options["pz"],
            "s": options["s"],
            "fromdate": options["fromdate"]
          };
          url = "Car/Get_ListPhieuchoduyet";
          if (!isPhieu.value) {
            url = "Car/Get_ListLenhchoduyet";
          }
          break;
        case 2:
          body = {
            "user_id": options["user_id"] ?? Golbal.store.user["user_id"],
            "p": options["p"],
            "pz": options["pz"],
            "status": options["status"],
            "s": options["s"],
            "fromdate": options["fromdate"]
          };
          url = "Car/Get_ListtheodoiPhieu";
          if (!isPhieu.value) {
            url = "Car/Get_ListtheodoiLenh";
          }
          break;
        case 3:
          break;
        default:
      }
      Dio dio = Dio();
      dio.options.headers["Authorization"] = "Bearer ${Golbal.store.token}";
      dio.options.followRedirects = true;
      var response =
          await dio.post("${Golbal.congty!.api}/api/$url", data: body);
      var data = response.data;
      if (data != null) {
        var tbs = List.castFrom(json.decode(data["data"]));
        if (pageIndex.value == 2 || pageIndex.value == 0) tbs = tbs[0];
        if (tbs.isNotEmpty) {
          for (var element in tbs) {
            if (element["anhThumb"] != null) {
              element["anhThumb"] =
                  Golbal.congty!.fileurl + element["anhThumb"];
            }
          }
          if (f) {
            datas.addAll(tbs);
          } else {
            datas.value = tbs;
          }
          isloaddingmore.value = datas.length >= options["pz"] &&
              datas.length <
                  (isPhieu.value
                      ? countdata["totalPhieu"]
                      : countdata["totalLenh"]);
        } else {
          lastdata.value = true;
        }
        if (loaddingmore.value) {
          loaddingmore.value = false;
        }
      } else {
        lastdata.value = true;
      }
      if (isLoadding.value) {
        isLoadding.value = false;
      }
    } catch (e) {
      if (isLoadding.value) {
        isLoadding.value = false;
      }
      if (kDebugMode) {
        print(e);
      }
    }
  }

  Future<void> refershData() {
    datas.clear();
    return Future.value(null);
  }

  void search(String s) {
    datas.clear();
    options["s"] = s;
    options["p"] = 1;
    loadData(true);
  }

  Future<void> onLoadmore() {
    if (loaddingmore.value || lastdata.value == true || !isloaddingmore.value) {
      return Future.value(null);
    }
    loaddingmore.value = true;
    options["p"] = int.parse(options["p"].toString()) + 1;
    loadData(true);
    return Future.value(null);
  }

  //Duyệt phiếu
  Future<void> duyetphieu(model) async {
    ArtDialogResponse response = await ArtSweetAlert.show(
        barrierDismissible: true,
        context: Get.context!,
        artDialogArgs: ArtDialogArgs(
            denyButtonText: "Không",
            title: "Xác nhận",
            text: "Bạn có chắc chắn muốn duyệt phiếu này không!",
            confirmButtonText: "Có",
            type: ArtSweetAlertType.warning));

    if (response.isTapConfirmButton) {
      Dio dio = Dio();
      dio.options.headers["Authorization"] = "Bearer ${Golbal.store.token}";
      dio.options.followRedirects = true;
      EasyLoading.show(
        status: "Đang xử lý ...",
      );
      var body = {
        "user_id": Golbal.store.user["user_id"],
        "qt_nhom_id": model["qt_nhom_id"],
        "phieu_id": model["PhieuDX_ID"],
        "noidung": model["Noidung"],
        "nhomduyet_id": model["nhomduyet_id"],
        "nguoiduyet_id": model["nguoiduyet_id"],
        "loaiduyet": "0",
        "dieuxe_follow_id": model["dieuxe_follow_id"],
      };
      try {
        var response = await dio.put(
            "${Golbal.congty!.api}/api/Car/App_DuyetPhieuchoduyet",
            data: body);
        EasyLoading.dismiss();
        if (response.data["err"] == "1") {
          EasyLoading.showToast(
              "Không thể duyệt phiếu điều xe này, vui lòng thử lại!");
        } else {
          if (response.data != null) {
            Get.back();
            Get.back();
            initCounts();
            EasyLoading.showToast("Duyệt phiếu thành công!");
          }
        }
      } catch (e) {
        dio.put('${Golbal.congty!.api}/api/Log/AddLog', data: {
          "title": "Lỗi duyệt phiếu điều xe",
          "controller": "Car/App_DuyetPhieuchoduyet",
          "log_date": DateTime.now().toIso8601String(),
          "log_content": json.encode(body),
          "full_name": Golbal.store.user["FullName"],
          "user_id": Golbal.store.user["user_id"],
          "token_id": Golbal.store.user["Token_ID"],
          "is_type": 0,
          "module": "Car",
        });
        EasyLoading.dismiss();
        EasyLoading.showToast(
          "Không thể duyệt phiếu này, vui lòng thử lại!",
        );
      }
    }
  }

  Future<void> tralailphieu(model) async {
    ArtDialogResponse response = await ArtSweetAlert.show(
        barrierDismissible: true,
        context: Get.context!,
        artDialogArgs: ArtDialogArgs(
            denyButtonText: "Không",
            title: "Xác nhận",
            text: "Bạn có chắc chắn muốn trả lại phiếu này không!",
            confirmButtonText: "Có",
            type: ArtSweetAlertType.warning));

    if (response.isTapConfirmButton) {
      Dio dio = Dio();
      dio.options.headers["Authorization"] = "Bearer ${Golbal.store.token}";
      dio.options.followRedirects = true;
      EasyLoading.show(
        status: "Đang xử lý ...",
      );
      var body = {
        "user_id": Golbal.store.user["user_id"],
        "qt_nhom_id": model["qt_nhom_id"],
        "phieu_id": model["PhieuDX_ID"],
        "lenh_id": model["LenhDX_ID"],
        "noidung": model["Noidung"],
        "nhomtralai_id": model["nhomtralai_id"],
        "nguoitralai_id": model["nguoitralai_id"],
        "loaitralai": model["loaitralai"],
        "dieuxe_follow_id": model["dieuxe_follow_id"],
      };
      try {
        var response = await dio.put("${Golbal.congty!.api}/api/Car/App_Tralai",
            data: body);
        EasyLoading.dismiss();
        if (response.data["err"] == "1") {
          EasyLoading.showToast(
              "Không thể trả lại phiếu điều xe này, vui lòng thử lại!");
        } else {
          if (response.data != null) {
            Get.back();
            Get.back();
            initCounts();
            EasyLoading.showToast("Trả lại phiếu thành công!");
          }
        }
      } catch (e) {
        dio.put('${Golbal.congty!.api}/api/Log/AddLog', data: {
          "title": "Lỗi trả lại phiếu điều xe",
          "controller": "Car/App_Tralai",
          "log_date": DateTime.now().toIso8601String(),
          "log_content": json.encode(body),
          "full_name": Golbal.store.user["FullName"],
          "user_id": Golbal.store.user["user_id"],
          "token_id": Golbal.store.user["Token_ID"],
          "is_type": 0,
          "module": "Car",
        });
        EasyLoading.dismiss();
        EasyLoading.showToast(
          "Không thể trả lại phiếu điều xe này, vui lòng thử lại!",
        );
      }
    }
  }

  //Duyệt lệnh
  Future<void> laplenh(model) async {
    ArtDialogResponse response = await ArtSweetAlert.show(
        barrierDismissible: true,
        context: Get.context!,
        artDialogArgs: ArtDialogArgs(
            denyButtonText: "Không",
            title: "Xác nhận",
            text: "Bạn có chắc chắn muốn lập lệnh này không!",
            confirmButtonText: "Có",
            type: ArtSweetAlertType.warning));

    if (response.isTapConfirmButton) {
      Dio dio = Dio();
      dio.options.headers["Authorization"] = "Bearer ${Golbal.store.token}";
      dio.options.followRedirects = true;
      EasyLoading.show(
        status: "Đang xử lý ...",
      );
      var body = {
        "user_id": Golbal.store.user["user_id"],
        "lenh_id": model["LenhDX_ID"],
        "loaidat": model["loaidat"],
        "sochongoi": model["sochongoi"],
        "loaixe": model["loaixe"],
        "bienso": model["bienso"],
        "nguoilaixe": model["nguoilaixe"],
        "dienthoai": model["dienthoai"],
        "datxengoai": model["datxengoai"],
      };
      try {
        var response = await dio
            .post("${Golbal.congty!.api}/api/Car/Insert_InfoLenh", data: body);
        EasyLoading.dismiss();
        if (response.data["err"] == "1") {
          EasyLoading.showToast(
              "Không thể lập lệnh điều xe này, vui lòng thử lại!");
        } else {
          if (response.data != null) {
            Get.back();
            initCounts();
            EasyLoading.showToast("Lập lệnh thành công!");
          }
        }
      } catch (e) {
        dio.put('${Golbal.congty!.api}/api/Log/AddLog', data: {
          "title": "Lỗi lập lệnh điều xe",
          "controller": "Car/Insert_InfoLenh",
          "log_date": DateTime.now().toIso8601String(),
          "log_content": json.encode(body),
          "full_name": Golbal.store.user["FullName"],
          "user_id": Golbal.store.user["user_id"],
          "token_id": Golbal.store.user["Token_ID"],
          "is_type": 0,
          "module": "Car",
        });
        EasyLoading.dismiss();
        EasyLoading.showToast(
          "Không thể lập lệnh này, vui lòng thử lại!",
        );
      }
    }
  }

  var userduyet = {}.obs;
  void resetChon() {
    usercontroller.users.where((p0) => p0["chon"] == true).forEach((element) {
      element["chon"] = false;
    });
    usercontroller.groupusers
        .where((p0) => p0["chon"] == true)
        .forEach((element) {
      element["chon"] = true;
    });
  }

  Future<void> showUser() async {
    resetChon();
    var rs = await showCupertinoModalBottomSheet(
      context: Get.context!,
      expand: true,
      builder: (context) => ListUserVanBan(one: true),
    );
    if (rs != null) {
      userduyet.value = rs[0];
    }
  }

  Future<void> duyetlenh(model) async {
    ArtDialogResponse response = await ArtSweetAlert.show(
        barrierDismissible: true,
        context: Get.context!,
        artDialogArgs: ArtDialogArgs(
            denyButtonText: "Không",
            title: "Xác nhận",
            text: "Bạn có chắc chắn muốn duyệt lệnh này không!",
            confirmButtonText: "Có",
            type: ArtSweetAlertType.warning));

    if (response.isTapConfirmButton) {
      Dio dio = Dio();
      dio.options.headers["Authorization"] = "Bearer ${Golbal.store.token}";
      dio.options.followRedirects = true;
      EasyLoading.show(
        status: "Đang xử lý ...",
      );
      var body = {
        "user_id": Golbal.store.user["user_id"],
        "qt_nhom_id": model["qt_nhom_id"],
        "lenh_id": model["LenhDX_ID"],
        "noidung": model["Noidung"],
        "nhomduyet_id": model["nhomduyet_id"],
        "nguoiduyet_id": userduyet["NhanSu_ID"] ?? model["nguoiduyet_id"],
        "loaiduyet": userduyet["NhanSu_ID"] != null ? "2" : "0",
        "dieuxe_follow_id": model["dieuxe_follow_id"],
      };
      try {
        var response = await dio.put(
            "${Golbal.congty!.api}/api/Car/App_DuyetLenhchoduyet",
            data: body);
        EasyLoading.dismiss();
        if (response.data["err"] == "1") {
          EasyLoading.showToast(
              "Không thể duyệt lệnh điều xe này, vui lòng thử lại!");
        } else {
          if (response.data != null) {
            Get.back();
            Get.back();
            initCounts();
            EasyLoading.showToast("Duyệt lệnh thành công!");
          }
        }
      } catch (e) {
        dio.put('${Golbal.congty!.api}/api/Log/AddLog', data: {
          "title": "Lỗi duyệt lệnh điều xe",
          "controller": "Car/App_DuyetLenhchoduyet",
          "log_date": DateTime.now().toIso8601String(),
          "log_content": json.encode(body),
          "full_name": Golbal.store.user["FullName"],
          "user_id": Golbal.store.user["user_id"],
          "token_id": Golbal.store.user["Token_ID"],
          "is_type": 0,
          "module": "Car",
        });
        EasyLoading.dismiss();
        EasyLoading.showToast(
          "Không thể duyệt lệnh này, vui lòng thử lại!",
        );
      }
    }
  }

  Future<void> tralailenh(model) async {
    ArtDialogResponse response = await ArtSweetAlert.show(
        barrierDismissible: true,
        context: Get.context!,
        artDialogArgs: ArtDialogArgs(
            denyButtonText: "Không",
            title: "Xác nhận",
            text: "Bạn có chắc chắn muốn trả lại lệnh này không!",
            confirmButtonText: "Có",
            type: ArtSweetAlertType.warning));

    if (response.isTapConfirmButton) {
      Dio dio = Dio();
      dio.options.headers["Authorization"] = "Bearer ${Golbal.store.token}";
      dio.options.followRedirects = true;
      EasyLoading.show(
        status: "Đang xử lý ...",
      );
      var body = {
        "user_id": Golbal.store.user["user_id"],
        "qt_nhom_id": model["qt_nhom_id"],
        "phieu_id": model["PhieuDX_ID"],
        "lenh_id": model["LenhDX_ID"],
        "noidung": model["Noidung"],
        "nhomtralai_id": model["nhomtralai_id"],
        "nguoitralai_id": model["nguoitralai_id"],
        "loaitralai": model["loaitralai"],
        "dieuxe_follow_id": model["dieuxe_follow_id"],
      };
      try {
        var response = await dio.put("${Golbal.congty!.api}/api/Car/App_Tralai",
            data: body);
        EasyLoading.dismiss();
        if (response.data["err"] == "1") {
          EasyLoading.showToast(
              "Không thể trả lại lệnh điều xe này, vui lòng thử lại!");
        } else {
          if (response.data != null) {
            Get.back();
            Get.back();
            initCounts();
            EasyLoading.showToast("Trả lại lệnh thành công!");
          }
        }
      } catch (e) {
        dio.put('${Golbal.congty!.api}/api/Log/AddLog', data: {
          "title": "Lỗi trả lại lệnh điều xe",
          "controller": "Car/App_Tralai",
          "log_date": DateTime.now().toIso8601String(),
          "log_content": json.encode(body),
          "full_name": Golbal.store.user["FullName"],
          "user_id": Golbal.store.user["user_id"],
          "token_id": Golbal.store.user["Token_ID"],
          "is_type": 0,
          "module": "Car",
        });
        EasyLoading.dismiss();
        EasyLoading.showToast(
          "Không thể trả lại lệnh điều xe này, vui lòng thử lại!",
        );
      }
    }
  }

  Future<void> hoanthanhlenh(model) async {
    ArtDialogResponse response = await ArtSweetAlert.show(
        barrierDismissible: true,
        context: Get.context!,
        artDialogArgs: ArtDialogArgs(
            denyButtonText: "Không",
            title: "Xác nhận",
            text: "Bạn có chắc chắn muốn hoàn thành lệnh này không!",
            confirmButtonText: "Có",
            type: ArtSweetAlertType.warning));

    if (response.isTapConfirmButton) {
      Dio dio = Dio();
      dio.options.headers["Authorization"] = "Bearer ${Golbal.store.token}";
      dio.options.followRedirects = true;
      EasyLoading.show(
        status: "Đang xử lý ...",
      );
      var body = {
        "user_id": Golbal.store.user["user_id"],
        "lenh_id": model["LenhDX_ID"],
        "km_xacnhan": (model["km_xacnhan"] ?? "")
            .toString()
            .replaceAll("KM", "")
            .replaceAll(".", "")
            .trim(),
        "phicauduong": (model["phicauduong"] ?? "")
            .toString()
            .replaceAll("VND", "")
            .replaceAll(".", "")
            .trim(),
        "xangxe": (model["xangxe"] ?? "")
            .toString()
            .replaceAll("VND", "")
            .replaceAll(".", "")
            .trim(),
        "km_ketthuc": (model["km_ketthuc"] ?? "")
            .toString()
            .replaceAll("KM", "")
            .replaceAll(".", "")
            .trim(),
        "danhgia": model["danhgia"] ?? 0,
      };
      if (body["km_xacnhan"] == "") body["km_xacnhan"] = null;
      if (body["phicauduong"] == "") body["phicauduong"] = null;
      if (body["xangxe"] == "") body["xangxe"] = null;
      if (body["km_ketthuc"] == "") body["km_ketthuc"] = null;
      try {
        var response = await dio.put(
            "${Golbal.congty!.api}/api/Car/App_Xacnhanhoanthanh",
            data: body);
        EasyLoading.dismiss();
        if (response.data["err"] == "1") {
          EasyLoading.showToast(
              "Không thể hoàn thành lệnh điều xe này, vui lòng thử lại!");
        } else {
          if (response.data != null) {
            Get.back();
            Get.back();
            initCounts();
            EasyLoading.showToast("Hoàn thành lệnh thành công!");
          }
        }
      } catch (e) {
        dio.put('${Golbal.congty!.api}/api/Log/AddLog', data: {
          "title": "Lỗi hoàn thành lệnh điều xe",
          "controller": "Car/App_Xacnhanhoanthanh",
          "log_date": DateTime.now().toIso8601String(),
          "log_content": json.encode(body),
          "full_name": Golbal.store.user["FullName"],
          "user_id": Golbal.store.user["user_id"],
          "token_id": Golbal.store.user["Token_ID"],
          "is_type": 0,
          "module": "Car",
        });
        EasyLoading.dismiss();
        EasyLoading.showToast(
          "Không thể hoàn thành lệnh này, vui lòng thử lại!",
        );
      }
    }
  }

  Future<void> capnhatrangthai(model) async {
    ArtDialogResponse response = await ArtSweetAlert.show(
        barrierDismissible: true,
        context: Get.context!,
        artDialogArgs: ArtDialogArgs(
            denyButtonText: "Không",
            title: "Xác nhận",
            text:
                "Bạn có chắc chắn muốn cập nhật trạng thái cho lệnh này không!",
            confirmButtonText: "Có",
            type: ArtSweetAlertType.warning));

    if (response.isTapConfirmButton) {
      Dio dio = Dio();
      dio.options.headers["Authorization"] = "Bearer ${Golbal.store.token}";
      dio.options.followRedirects = true;
      EasyLoading.show(
        status: "Đang xử lý ...",
      );
      var body = {
        "user_id": Golbal.store.user["user_id"],
        "bienso": model["LenhDX_Bienso"],
        "trangthai": model["trangthai"],
        "lenh_id": model["LenhDX_ID"],
        "ghichu": model["ghichu"],
        "km_batdau": (model["km_batdau"] ?? "")
            .toString()
            .replaceAll("KM", "")
            .replaceAll(".", "")
            .trim(),
        "km_ketthuc": (model["km_ketthuc"] ?? "")
            .toString()
            .replaceAll("KM", "")
            .replaceAll(".", "")
            .trim(),
      };
      if (body["km_batdau"] == "") body["km_batdau"] = null;
      if (body["km_ketthuc"] == "") body["km_ketthuc"] = null;
      try {
        var response = await dio.post(
            "${Golbal.congty!.api}/api/Car/App_UpdateTrangthaixe",
            data: body);
        EasyLoading.dismiss();
        if (response.data["err"] == "1") {
          EasyLoading.showToast(
              "Không thể cập nhật trạng thái lệnh điều xe này, vui lòng thử lại!");
        } else {
          if (response.data != null) {
            Get.back();
            Get.back();
            initCounts();
            EasyLoading.showToast("Cập nhật trạng thái lệnh thành công!");
          }
        }
      } catch (e) {
        dio.put('${Golbal.congty!.api}/api/Log/AddLog', data: {
          "title": "Lỗi Cập nhật trạng thái lệnh điều xe",
          "controller": "Car/App_UpdateTrangthaixe",
          "log_date": DateTime.now().toIso8601String(),
          "log_content": json.encode(body),
          "full_name": Golbal.store.user["FullName"],
          "user_id": Golbal.store.user["user_id"],
          "token_id": Golbal.store.user["Token_ID"],
          "is_type": 0,
          "module": "Car",
        });
        EasyLoading.dismiss();
        EasyLoading.showToast(
          "Không thể cập nhật trạng thái lệnh này, vui lòng thử lại!",
        );
      }
    }
  }

  @override
  void onInit() {
    super.onInit();
    initCounts();
  }
}
