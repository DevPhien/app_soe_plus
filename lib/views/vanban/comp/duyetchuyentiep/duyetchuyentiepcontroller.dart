import 'dart:convert';

import 'package:art_sweetalert/art_sweetalert.dart';
import 'package:dio/dio.dart' as dio;
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:page_transition/page_transition.dart';
import 'package:soe/views/vanban/controller/chitietvanbancontroller.dart';

import '../../../../utils/golbal/golbal.dart';
import '../../controller/uservanbancontroller.dart';
import '../listuser.dart';
import '../webviewkyvanban/webview.dart';
import '../webviewkyvanban/webviewweb.dart';
import '../webviewkyvanban/webviewwindow.dart';

class DuyetChuyenTiepVanbanController extends GetxController {
  final ChitietVanbanController controller = Get.put(ChitietVanbanController());
  final UserVBController usercontroller = Get.put(UserVBController());
  var model = {}.obs;
  var receiver = [].obs;
  var chuky = {};
  var vanbangockys = [].obs;
  var vanbandinhkemkys = [].obs;
  Rx<List<PlatformFile>> files = Rx<List<PlatformFile>>([]);
  void resetChon(List users) {
    usercontroller.users
        .where((p0) =>
            users.indexWhere(
                (element) => element["NhanSu_ID"] == p0["NhanSu_ID"]) !=
            -1)
        .forEach((element) {
      element["chon"] = true;
    });
    usercontroller.groupusers
        .where((p0) =>
            users.indexWhere(
                (element) => element["NhanSu_ID"] == p0["NhanSu_ID"]) !=
            -1)
        .forEach((element) {
      element["chon"] = true;
    });
    usercontroller.isChon.value = users.length;
  }

  Future<void> showUser() async {
    usercontroller.users.where((p0) => p0["chon"] == true).forEach((element) {
      element["chon"] = false;
    });
    usercontroller.users.where((p0) => p0["chon"] == true).forEach((element) {
      element["chon"] = false;
    });
    usercontroller.isChon.value = 0;
    resetChon(receiver);
    var rs = await showCupertinoModalBottomSheet(
      context: Get.context!,
      expand: true,
      builder: (context) => ListUserVanBan(one: true),
    );
    if (rs != null) {
      receiver.value = rs;
    }
  }

  Future<void> openWebview(tl, flag) async {
    String url = tl["tailieuPath"];
    String viewUrl = "${Golbal.congty!.api}/PDFWriter/Viewer?url=$url";
    String? pathky =
        model["Kynhay"] == true ? chuky["chuKyNhay"] : chuky["chuKy"];
    if (pathky == null) {
      EasyLoading.showToast("Vui lòng thêm chữ ký trước khi ký văn bản này.");
      return;
    }
    String fullchuky = Golbal.congty!.fileurl + pathky;
    dynamic rs;
    dynamic mpos = [];
    if (model["water_images"] != null && model["water_images"].length > 0) {
      var mobjs = List.castFrom(model["water_images"])
          .firstWhereOrNull((element) => element[tl["tailieuPath"]] != null);
      if (mobjs != null) {
        List.castFrom(mobjs[tl["tailieuPath"]]).forEach((mobj) {
          mpos.add({
            "x": mobj["HorizontalDistance"],
            "y": mobj["VerticalDistance"],
            "page": mobj["PageRange"],
            "width": mobj["Width"],
            "Rotation": mobj["Rotation"],
            "Opacity": mobj["Opacity"],
          });
        });
      }
    }
    if (kIsWeb) {
      rs = await Navigator.of(Get.context!).push(
        PageTransition(
            type: PageTransitionType.fade,
            child: WebViewWeb(url: viewUrl, chuky: fullchuky),
            fullscreenDialog: true),
      );
    } else if (defaultTargetPlatform == TargetPlatform.windows) {
      rs = await Navigator.of(Get.context!).push(
        PageTransition(
            type: PageTransitionType.fade,
            child: WebBrowser(url: viewUrl, chuky: fullchuky),
            fullscreenDialog: true),
      );
    } else {
      rs = await Navigator.of(Get.context!).push(
        PageTransition(
            type: PageTransitionType.fade,
            child:
                WebViewMobile(url: viewUrl, chuky: fullchuky, imagePos: mpos),
            fullscreenDialog: true),
      );
    }
    if (rs == null) {
      return;
    }
    if (flag == 0) {
      int ix = vanbangockys
          .indexWhere((element) => element["tailieuID"] == tl["tailieuID"]);
      if (ix != -1) {
        vanbangockys[ix]["Sign"] = true;
      }
    } else {
      int ix = vanbandinhkemkys
          .indexWhere((element) => element["tailieuID"] == tl["tailieuID"]);
      if (ix != -1) {
        vanbandinhkemkys[ix]["Sign"] = true;
      }
    }
    var tailieuPaths = [];
    List.castFrom(rs).forEach((element) {
      tailieuPaths.add({
        "ImageFile": pathky,
        "Width": element["width"],
        "Height": element["height"],
        "HorizontalDistance": element["x"],
        "VerticalDistance": element["y"],
        "PageRange": element["page"],
        "Rotation": element["Rotation"] ?? 0,
        "Opacity": element["Opacity"] ?? 100
      });
    });
    var waterimage = {tl["tailieuPath"]: tailieuPaths};
    int idx = List.castFrom(model["water_images"])
        .indexWhere((el) => el[tl["tailieuPath"]] != null);
    if (idx != -1) {
      model["water_images"][idx] = waterimage;
    } else {
      model["water_images"].add(waterimage);
    }
    var typesign = {
      "vanBanMasterID": model["vanBanMasterID"],
      "vanBanFollow_ID": model["vanBanFollow_ID"],
      "tailieuID": tl["tailieuID"],
      "tailieuPath": tl["tailieuPath"],
      "Kynhay": model["Kynhay"],
    };
    idx = List.castFrom(model["type_signs"])
        .indexWhere((el) => el[tl["tailieuID"]] == tl["tailieuID"]);
    if (idx != -1) {
      model["type_signs"][idx] = typesign;
    } else {
      model["type_signs"].add(typesign);
    }
  }

  Future<void> submit() async {
    if (receiver.isNotEmpty) {
      model["receiver"] = receiver[0]["NhanSu_ID"];
    } else {
      EasyLoading.showToast("Vui lòng chọn người nhận văn bản.");
      return;
    }
    int gocky = vanbangockys.where((p0) => p0["Sign"] == null).length;
    int dkemky = vanbandinhkemkys.where((p0) => p0["Sign"] == null).length;
    if (gocky + dkemky > 0) {
      ArtDialogResponse response = await ArtSweetAlert.show(
          barrierDismissible: false,
          context: Get.context!,
          artDialogArgs: ArtDialogArgs(
              denyButtonText: "Huỷ duyệt",
              title: "Xác nhận!",
              text:
                  "Bạn vẫn còn ${gocky + dkemky} văn bản chưa được ký. Bạn có muốn tiếp tục duyệt những văn bản này không?",
              confirmButtonText: "Vẫn duyệt",
              type: ArtSweetAlertType.warning));

      if (!response.isTapConfirmButton) {
        return;
      }
    }
    EasyLoading.show(
      status: "Đang duyệt văn bản ...",
    );
    var approval = {
      "handle_date": model["handle_date"],
      "message": model["message"],
      "receiver": model["receiver"],
      "is_flag": model["is_flag"],
      "type_signs": model["type_signs"],
      "water_images": model["water_images"],
      //"water_txts": [],
      //"is_inworkflow ": false,
    };
    Map<String, dynamic> mdata = {
      "model": json.encode({
        "doc_master_id": model["vanBanMasterID"],
        "follow_id": model["vanBanFollow_ID"],
        "user_id": Golbal.store.user["user_id"],
        "approval": approval
      })
    };
    var ffiles = [];
    for (var fi in files.value) {
      if (kIsWeb) {
        ffiles.add(dio.MultipartFile.fromBytes(fi.bytes!, filename: fi.name));
      } else {
        ffiles.add(dio.MultipartFile.fromFileSync(fi.path!, filename: fi.name));
      }
    }
    if (ffiles.isNotEmpty) mdata["file"] = ffiles;
    dio.FormData formData = dio.FormData.fromMap(mdata);
    dio.Dio http = dio.Dio();
    http.options.headers["Authorization"] = "Bearer ${Golbal.store.token}";
    http.options.followRedirects = true;
    try {
      var response = await http.put(
          '${Golbal.congty!.api}/api/Doc/SubmittedForApproval',
          data: formData);
      EasyLoading.dismiss();
      if (response.data["err"] == "1") {
        EasyLoading.showToast(response.data["err_app"] ??
            "Không thể duyệt chuyển tiếp văn bản này, vui lòng thử lại!");
        http.put('${Golbal.congty!.api}/api/Log/AddLog', data: {
          "title": "Lỗi duyệt văn bản",
          "controller": "Doc/SubmittedForApproval",
          "log_date": DateTime.now().toIso8601String(),
          "log_content": response.data["err_app"] + "|" + mdata["model"],
          "full_name": Golbal.store.user["FullName"],
          "user_id": Golbal.store.user["user_id"],
          "token_id": Golbal.store.user["Token_ID"],
          "is_type": 0,
          "module": "Doc",
        });
      } else {
        if (response.data != null) {
          EasyLoading.showToast("Chuyển văn bản thành công!");
          Get.back(result: true);
        }
      }
    } catch (e) {
      http.put('${Golbal.congty!.api}/api/Log/AddLog', data: {
        "title": "Lỗi duyệt chuyển tiếp văn bản",
        "controller": "Doc/SubmittedForApproval",
        "log_date": DateTime.now().toIso8601String(),
        "log_content": mdata["model"],
        "full_name": Golbal.store.user["FullName"],
        "user_id": Golbal.store.user["user_id"],
        "token_id": Golbal.store.user["Token_ID"],
        "is_type": 0,
        "module": "Doc",
      });
      EasyLoading.dismiss();
      EasyLoading.showToast(
        "Không thể duyệt chuyển tiếp văn bản này, vui lòng thử lại!",
      );
    }
  }

  void deleUser(int i) {
    receiver.value = [];
  }

  Future<void> openDate(String mkey) async {
    var rs = await showDatePicker(
      context: Get.context!,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2025),
    );
    if (rs != null) {
      model[mkey] = rs.toIso8601String();
    }
  }

  Future<void> openFile() async {
    FilePickerResult? result =
        await FilePicker.platform.pickFiles(allowMultiple: true);

    if (result != null) {
      files.value = result.files;
    } else {
      // User canceled the picker
    }
  }

  void deleteFile(i) {
    files.value.removeAt(i);
    files.refresh();
  }

  initVanbanKy() async {
    try {
      Dio dio = Dio();
      dio.options.headers["Authorization"] = "Bearer ${Golbal.store.token}";
      dio.options.followRedirects = true;
      var body = {"doc_master_id": model["vanBanMasterID"]};
      var response = await dio
          .post("${Golbal.congty!.api}/api/Doc/GetRelFileDoc", data: body);
      var data = response.data;
      if (data != null) {
        var tbs = List.castFrom(json.decode(data["data"]));
        if (tbs.isNotEmpty) {
          vanbangockys.value =
              tbs.where((element) => element["loai"] == 0).toList();
          vanbandinhkemkys.value =
              tbs.where((element) => element["loai"] == 1).toList();
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  initChuKy() async {
    try {
      Dio dio = Dio();
      dio.options.headers["Authorization"] = "Bearer ${Golbal.store.token}";
      dio.options.followRedirects = true;
      var body = {"user_id": Golbal.store.user["user_id"]};
      var response = await dio
          .post("${Golbal.congty!.api}/api/Doc/GetDocSignature", data: body);
      var data = response.data;
      if (data != null) {
        var tbs = List.castFrom(json.decode(data["data"]));
        if (tbs.isNotEmpty) {
          chuky = tbs[0];
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  @override
  void onInit() {
    super.onInit();
    //print(Get.arguments);
    model["vanBanMasterID"] = Get.arguments["vanBanMasterID"];
    model["vanBanFollow_ID"] = Get.arguments["vanBanFollow_ID"];
    model["Kynhay"] = false;
    model["is_flag"] = false;
    model["water_images"] = [];
    model["type_signs"] = [];
    initVanbanKy();
    initChuKy();
  }
}
