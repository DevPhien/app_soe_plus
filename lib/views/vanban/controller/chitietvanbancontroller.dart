import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:open_app_file/open_app_file.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../utils/golbal/golbal.dart';
import '../../component/use/inlineloadding.dart';
import '../../component/use/nodata.dart';
import '../../home/controller/cmenucontroller.dart';
import '../comp/itemchidao.dart';
import '../comp/itemnhansu.dart';
import 'package:path_provider/path_provider.dart';

import '../comp/mybox/myfolder.dart';
import '../comp/mytask/mytask.dart';
import 'taskcontroller.dart';
import 'vanbanhomecontroller.dart';

class ChitietVanbanController extends GetxController {
  var vanban = {}.obs;
  var tailieus = [].obs;
  var hoanthanhs = [].obs;
  var vanbanlienquans = [].obs;
  var vanbanduthaos = [].obs;
  var uservanbans = [].obs;
  var ykienvanbans = [].obs;
  var isloadding = true.obs;
  var isloaddingVB = true.obs;
  var index = 0.obs;
  var buttonkey = [].obs;
  String pageIndex = "1";
  void setIndex(int idx) {
    index.value = idx;
    switch (idx) {
      case 1:
        showYkienVanban();
        if (ykienvanbans.isEmpty) {
          initYkienVanban();
        }
        break;
      case 2:
        showUserVanban();
        if (uservanbans.isEmpty) {
          initUserVanban();
        }
        break;
      case 3:
        Get.toNamed("/graph", arguments: vanban);
        break;
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

  initData(body) async {
    try {
      Dio dio = Dio();
      dio.options.headers["Authorization"] = "Bearer ${Golbal.store.token}";
      dio.options.followRedirects = true;
      var response = await dio
          .post("${Golbal.congty!.api}/api/Doc/GetDetailDoc", data: body);
      var data = response.data;
      if (data != null) {
        var tbs = List.castFrom(json.decode(data["data"]));
        if (tbs.isNotEmpty) {
          tbs[0][0]["vanBanMasterID"] = body["doc_master_id"];
          tbs[0][0]["follow_id"] = body["follow_id"];
          tbs[0][0]["seetoknow_user_id"] = body["seetoknow_user_id"];
          tbs[0][0]["publish_user_id"] = body["publish_user_id"];
          if (pageIndex == "1") {
            tbs[0][0]["vanBanFollow_ID"] = body["vanBanFollow_ID"];
            tbs[0][0]["vanBanFollowUser_ID"] = body["vanBanFollowUser_ID"];
            tbs[0][0]["vanBanXemdebietUser_ID"] =
                body["vanBanXemdebietUser_ID"];
            tbs[0][0]["vanBanTheodoiUser_ID"] = body["vanBanTheodoiUser_ID"];
          }
          if (tbs[0][0]["anhThumb"] == null &&
              Get.arguments != null &&
              Get.arguments["anhThumb"] != null) {
            tbs[0][0]["anhThumb"] = Get.arguments["anhThumb"];
          }
          vanban.value = tbs[0][0];
          tailieus.value = tbs[1];
          vanbanlienquans.value = tbs[2];
          vanbanduthaos.value = tbs[3];
          hoanthanhs.value = tbs[4];
          if (tbs[5][0]["IsReceiver"] == true ||
              tbs[5][0]["IsSender"] == true ||
              pageIndex == "1" ||
              pageIndex == "2") {
            if (Get.parameters["pageIndex"] != null &&
                Get.parameters["pageIndex"]!.toString() != "3") {
              initFunction();
            }
          }
          if (isloaddingVB.value) isloaddingVB.value = false;
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  initFollow() async {
    try {
      var vb = Get.arguments;
      Dio dio = Dio();
      dio.options.headers["Authorization"] = "Bearer ${Golbal.store.token}";
      dio.options.followRedirects = true;
      var body = {
        "user_id": Golbal.store.user["user_id"],
        "group_id": vb["group_id"]
      };
      var response = await dio
          .post("${Golbal.congty!.api}/api/Doc/GetParamsFollow", data: body);
      var data = response.data;
      if (data != null) {
        var tbs = List.castFrom(json.decode(data["data"]));
        if (tbs.isNotEmpty) {
          body = {
            "doc_master_id": vb["vanBanMasterID"],
            "user_id": Golbal.store.user["user_id"],
            "follow_id": tbs[0]["vanBanFollow_ID"],
            "seetoknow_user_id": tbs[0]["vanBanXemdebietUser_ID"],
            "publish_user_id": tbs[0]["vanBanFollowUser_ID"],
            "group_id": vb["group_id"],
            "vanBanFollow_ID": tbs[0]["vanBanFollow_ID"],
            "vanBanFollowUser_ID": tbs[0]["vanBanFollowUser_ID"],
            "vanBanXemdebietUser_ID": tbs[0]["vanBanXemdebietUser_ID"],
            "vanBanTheodoiUser_ID": tbs[0]["vanBanTheodoiUser_ID"],
          };
          initData(body);
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  initFunction() async {
    try {
      var vb = Get.arguments;
      Dio dio = Dio();
      dio.options.headers["Authorization"] = "Bearer ${Golbal.store.token}";
      dio.options.followRedirects = true;
      var body = {
        "user_id": Golbal.store.user["user_id"],
        "doc_master_id": vb["vanBanMasterID"]
      };
      var response = await dio.post(
          "${Golbal.congty!.api}/api/${Get.parameters["pageIndex"] == "1" ? "Doc" : "SendDoc"}/GetListFuncDoc",
          data: body);
      var data = response.data;
      // print(
      //     "${Golbal.congty!.api}/api/${Get.parameters["pageIndex"] == "1" ? "Doc" : "SendDoc"}/GetListFuncDoc");
      // print(data);
      if (data != null) {
        var tbs = List.castFrom(json.decode(data["data"]));
        if (tbs.isNotEmpty) {
          buttonkey.value = tbs[0]["res"].toString().split(",");
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  initUserVanban() async {
    try {
      isloadding.value = true;
      Dio dio = Dio();
      dio.options.headers["Authorization"] = "Bearer ${Golbal.store.token}";
      dio.options.followRedirects = true;
      var body = {"doc_master_id": vanban["vanBanMasterID"]};
      var response = await dio
          .post("${Golbal.congty!.api}/api/Doc/GetUserRelDoc", data: body);
      var data = response.data;
      if (data != null) {
        var tbs = List.castFrom(json.decode(data["data"]));
        if (tbs.isNotEmpty) {
          uservanbans.value = tbs;
        }
      }
      isloadding.value = false;
    } catch (e) {
      isloadding.value = false;
      if (kDebugMode) {
        print(e);
      }
    }
  }

  initYkienVanban() async {
    try {
      isloadding.value = true;
      Dio dio = Dio();
      dio.options.headers["Authorization"] = "Bearer ${Golbal.store.token}";
      dio.options.followRedirects = true;
      var body = {"doc_master_id": vanban["vanBanMasterID"]};
      var response = await dio.post(
          "${Golbal.congty!.api}/api/Doc/GetListMessageFollow",
          data: body);
      var data = response.data;
      if (data != null) {
        var tbs = List.castFrom(json.decode(data["data"]));
        if (tbs.isNotEmpty) {
          for (var element in tbs) {
            if (element["nhansu"] != null) {
              element["nhansu"] = json.decode(element["nhansu"]);
            }
            if (element["tailieus"] != null) {
              element["tailieus"] = json.decode(element["tailieus"]);
            }
          }
          ykienvanbans.value = tbs;
        }
      }
      isloadding.value = false;
    } catch (e) {
      isloadding.value = false;
      if (kDebugMode) {
        print(e);
      }
    }
  }

  void showUserVanban() {
    showCupertinoModalBottomSheet(
      context: Get.context!,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.6,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
        child: Column(
          children: [
            Obx(() => Text(
                  "Nhân sự nhận văn bản ${uservanbans.isNotEmpty ? "(${uservanbans.length})" : ""}",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Golbal.titleColor,
                      fontSize: 18),
                )),
            const SizedBox(height: 10),
            Expanded(
                child: Obx(() => isloadding.value
                    ? const InlineLoadding()
                    : uservanbans.isEmpty
                        ? const WidgetNoData(
                            icon: AntDesign.user,
                            txt: "Chưa có nhân sự nhận văn bản",
                          )
                        : ListView.separated(
                            separatorBuilder: (ct, i) => const Divider(
                                  height: 2,
                                  color: Color(0xFFeeeeee),
                                ),
                            itemCount: uservanbans.length,
                            itemBuilder: (ct, i) =>
                                ItemUser(user: uservanbans[i]))))
          ],
        ),
      ),
    );
  }

  void showYkienVanban() {
    showCupertinoModalBottomSheet(
      context: Get.context!,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.6,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
        child: Column(
          children: [
            Obx(() => Text(
                  "Ý kiến/ Chỉ đạo ${ykienvanbans.isNotEmpty ? "(${ykienvanbans.length})" : ""}",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Golbal.titleColor,
                      fontSize: 18),
                )),
            const SizedBox(height: 10),
            Expanded(
                child: Obx(() => isloadding.value
                    ? const InlineLoadding()
                    : ykienvanbans.isEmpty
                        ? const WidgetNoData(
                            icon: AntDesign.edit,
                            txt: "Chưa có ý kiến chỉ đạo nào",
                          )
                        : ListView.separated(
                            separatorBuilder: (ct, i) => const Divider(
                                  height: 2,
                                  color: Color(0xFFeeeeee),
                                ),
                            itemCount: ykienvanbans.length,
                            itemBuilder: (ct, i) => ItemYkien(
                                user: ykienvanbans[i], loadFile: loadFile))))
          ],
        ),
      ),
    );
  }

  void showMoreButton(List buttons) {
    showCupertinoModalBottomSheet(
      context: Get.context!,
      builder: (context) => Container(
        height: buttons.length * 90 + 120,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
        child: Column(
          children: [
            Text(
              "Chức năng khác",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Golbal.titleColor,
                  fontSize: 18),
            ),
            const SizedBox(height: 10),
            Expanded(
                child: ListView.builder(
                    itemCount: buttons.length,
                    itemBuilder: (ct, i) => ListTile(
                          onTap: () => clickButtonVanban(buttons[i]["key"]),
                          leading: Icon(buttons[i]["icon"]),
                          title: Text(buttons[i]["title"]),
                        )))
          ],
        ),
      ),
    );
  }

  //Action xử lý văn bản
  Future<void> clickButtonVanban(butkey) async {
    dynamic rs;
    switch (butkey) {
      case "4": //Chuyển đích danh
        rs = await Get.toNamed("/chuyendichdanh", arguments: vanban);
        break;
      case "1": //Trình phê duyệt
      case "2": //Duyệt chuyển tiếp
        rs = await Get.toNamed("/duyetchuyentiep", arguments: vanban);
        break;
      case "3": //Duyệt phát hành
        rs = await Get.toNamed("/duyetphathanh", arguments: vanban);
        break;
      case "9": //Phân phát văn bản
      case "9.1": //Phân phát văn bản
        rs = await Get.toNamed("/phanphatvanban",
            arguments: vanban,
            parameters: {"pageIndex": pageIndex.toString(), "butkey": butkey});
        break;
      case "10": //Xác nhận hoàn thành văn bản
        rs = await Get.toNamed("/xacnhanhoanthanh", arguments: vanban);
        break;
      case "12": //Trả lại văn bản
        rs = await Get.toNamed("/tralai", arguments: vanban);
        break;
      case "18": //Thu hồi văn bản
        rs = await checkThuhoi();
        break;
      case "14": //Liên kết công việc
        rs = await showTask();
        break;
      case "15": //Copy vào Mybox
      case "16": //Link vào Mybox
        if (butkey == "16") Get.back();
        rs = await showMyBox(butkey);
        break;
    }
    if (rs == true) {
      Get.back();
      final HomeVanbanController homecontroller =
          Get.put(HomeVanbanController());
      final HomeMenuController menucontroller = Get.put(HomeMenuController());
      homecontroller.loadData(false);
      menucontroller.initData();
    }
  }

  FutureOr<bool> showMyBox(String butkey) async {
    var rs = await showCupertinoModalBottomSheet(
      context: Get.context!,
      expand: true,
      builder: (context) => ListFolder(isOne: true),
    );
    if (rs == null || rs.length == 0) {
      return Future.value(false);
    }
    return await sendMybox(rs[0], butkey);
  }

  Future<bool> sendMybox(String folderid, String butkey) async {
    String title = butkey == "15" ? "Copy" : "Link";
    EasyLoading.show(
      status: "Đang $title văn bản vào Mybox ...",
    );
    Map<String, dynamic> data = {
      "user_id": Golbal.store.user["user_id"],
      "doc_master_id": vanban["vanBanMasterID"],
      "folder_id": folderid,
    };
    Dio http = Dio();
    http.options.headers["Authorization"] = "Bearer ${Golbal.store.token}";
    http.options.followRedirects = true;
    try {
      var response = await http
          .put('${Golbal.congty!.api}/api/Doc/${title}Mybox', data: data);
      EasyLoading.dismiss();
      if (response.data["err"] == "1") {
        EasyLoading.showToast(
            "Không thể $title văn bản này, vui lòng thử lại!");
        return Future.value(false);
      } else {
        if (response.data != null) {
          EasyLoading.showToast("$title văn bản thành công!");
          return Future.value(true);
        }
      }
    } catch (e) {
      http.put('${Golbal.congty!.api}/api/Log/AddLog', data: {
        "title": "Lỗi $title văn bản vào Mybox",
        "controller": "Doc/${title}Mybox",
        "log_date": DateTime.now().toIso8601String(),
        "log_content": json.encode(data),
        "full_name": Golbal.store.user["FullName"],
        "user_id": Golbal.store.user["user_id"],
        "token_id": Golbal.store.user["Token_ID"],
        "is_type": 0,
        "module": "Doc",
      });
      EasyLoading.showToast(
        "Không thể $title văn bản này vào Mybox, vui lòng thử lại!",
      );
      return Future.value(false);
    }
    return Future.value(false);
  }

  //
  FutureOr<bool> showTask() async {
    final TaskVBController taskcontroller = Get.put(TaskVBController());
    taskcontroller.initTask(vanban["vanBanMasterID"]);
    var rs = await showCupertinoModalBottomSheet(
      context: Get.context!,
      expand: true,
      builder: (context) => ListTask(
        isOne: false,
      ),
    );
    if (rs == null || rs.length == 0) {
      return Future.value(false);
    }
    return await sendTask(rs);
  }

  Future<bool> sendTask(List ids) async {
    EasyLoading.show(
      status: "Đang liên kết văn bản vào Công việc ...",
    );
    Map<String, dynamic> data = {
      "user_id": Golbal.store.user["user_id"],
      "doc_master_id": vanban["vanBanMasterID"],
      "task_ids": ids,
    };
    Dio http = Dio();
    http.options.headers["Authorization"] = "Bearer ${Golbal.store.token}";
    http.options.followRedirects = true;
    try {
      var response =
          await http.put('${Golbal.congty!.api}/api/Doc/LinkTask', data: data);
      EasyLoading.dismiss();
      if (response.data["err"] == "1") {
        EasyLoading.showToast(
            "Không thể liên kết văn bản này, vui lòng thử lại!");
        return Future.value(false);
      } else {
        if (response.data != null) {
          EasyLoading.showToast("Liên kết văn bản vào công việc thành công!");
          return Future.value(true);
        }
      }
    } catch (e) {
      http.put('${Golbal.congty!.api}/api/Log/AddLog', data: {
        "title": "Lỗi liên kết văn bản vào công việc",
        "controller": "Doc/LinkTask",
        "log_date": DateTime.now().toIso8601String(),
        "log_content": json.encode(data),
        "full_name": Golbal.store.user["FullName"],
        "user_id": Golbal.store.user["user_id"],
        "token_id": Golbal.store.user["Token_ID"],
        "is_type": 0,
        "module": "Doc",
      });
      EasyLoading.showToast(
        "Không thể liên kết văn bản này vào công việc, vui lòng thử lại!",
      );
      return Future.value(false);
    }
    return Future.value(false);
  }

  Future<bool> checkThuhoi() async {
    try {
      EasyLoading.show(
        status: "Đang kiểm tra văn bản ...",
      );
      Dio dio = Dio();
      dio.options.headers["Authorization"] = "Bearer ${Golbal.store.token}";
      dio.options.followRedirects = true;
      var body = {
        "recall": {
          "vanBanMasterID": vanban["vanBanMasterID"],
          "vanBanFollow_ID": vanban["vanBanFollow_ID"],
          "vanBanFollowUser_ID": vanban["vanBanFollowUser_ID"],
          "vanBanXemdebietUser_ID": vanban["vanBanXemdebietUser_ID"],
          "vanBanTheodoiUser_ID": vanban["vanBanTheodoiUser_ID"],
        }
      };
      var response = await dio
          .post("${Golbal.congty!.api}/api/SendDoc/CheckCanRecall", data: body);
      var data = response.data;
      EasyLoading.dismiss();
      if (data != null) {
        var tbs = List.castFrom(json.decode(data["data"]));
        if (tbs.isEmpty || tbs[0]["canRecall"] == false) {
          EasyLoading.showToast("Không thể thu hồi văn bản này.");
          return Future.value(false);
        } else if (tbs[0]["canRecall"] == true) {
          var rs = await Get.toNamed("/thuhoi", arguments: vanban);
          if (rs == null) {
            return Future.value(false);
          }
          return rs;
        }
      }
    } catch (e) {
      EasyLoading.showToast("Không thể thu hồi văn bản này.");
      if (kDebugMode) {
        print(e);
      }
    }
    return Future.value(false);
  }

  void reloadVanban() {
    vanban.value = Get.arguments;
    if (!isloaddingVB.value) isloaddingVB.value = true;
    if (pageIndex == "1") {
      initFollow();
    } else {
      var body = {
        "doc_master_id": Get.arguments["vanBanMasterID"],
        "user_id": Golbal.store.user["user_id"],
        "follow_id": Get.arguments["vanBanFollow_ID"],
        "seetoknow_user_id": Get.arguments["vanBanXemdebietUser_ID"],
        "publish_user_id": Get.arguments["vanBanFollowUser_ID"],
        "group_id": Get.arguments["group_id"],
      };
      initData(body);
    }
  }

  @override
  void onInit() {
    super.onInit();
    pageIndex = Get.parameters["pageIndex"] ?? "1";
    if (vanban.isEmpty) {
      reloadVanban();
    }
  }
}
