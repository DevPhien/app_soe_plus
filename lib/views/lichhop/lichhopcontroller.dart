import 'dart:convert';
import 'dart:io';

import 'package:art_sweetalert/art_sweetalert.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:get/get.dart';
import 'package:open_app_file/open_app_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../utils/golbal/golbal.dart';

class LichHopController extends GetxController {
  ScrollController? tuancontroller;
  RxInt pageIndex = 1.obs;
  RxInt istype = (-1).obs;
  double initialScrollOffset = 0.0;
  var loaddingmore = false.obs;
  RxBool isLoadding = true.obs;
  RxInt solichchon = (0).obs;
  var phonghops = [].obs;
  var kieulaps = [].obs;
  var lastdata = false.obs;
  var datas = [].obs;
  var countdata = {}.obs;
  var tuan = {}.obs;
  var tuans = [].obs;
  var ghichu = "".obs;
  var quyen = {}.obs;
  RxBool chonall = false.obs;
  List<int> years = [];
  var year = (DateTime.now().year).obs;
  var isSearchAdv = false.obs;
  Map<String, dynamic> options = {
    "p": 1,
    "pz": 20,
    "s": null,
    "filter_congty_id": Golbal.store.user["organization_id"],
    "user_id": Golbal.store.user["user_id"]
  };
  //Chọn duyệt
  void closeChon() {
    solichchon.value = 0;
    datas.where((p0) => p0["Chon"] == true).forEach((element) {
      element["Chon"] = false;
    });
    datas.refresh();
  }

  void changeChonAll(vl) {
    chonall.value = vl;
    for (var element in datas) {
      element["Chon"] = chonall.value;
    }
    datas.refresh();
    if (vl) {
      solichchon.value = datas.length;
    } else {
      solichchon.value = 0;
    }
  }

  void openChon(lich, bool chon) {
    if (pageIndex.value == 3) {
      lich["Chon"] = chon;
      var i = datas.indexWhere(
          (element) => element["LichhopTuan_ID"] == lich["LichhopTuan_ID"]);
      if (i != -1) {
        datas[i] = lich;
      }
    }

    solichchon.value = datas.where((p0) => p0["Chon"] == true).length;
  }

  void onPageChanged(int p) {
    datas.clear();
    if (p == 0) {
      Get.back();
      return;
    }
    pageIndex.value = p;
    solichchon.value = 0;
    loadData(false);
  }

  void loadData(f) {
    datas.clear();
    switch (pageIndex.value) {
      case 1:
        istype.value = -1;
        break;
      case 2:
        istype.value = 1;
        options["user_id"] = null;
        break;
      case 3:
        options["user_id"] = null;
        var t = tuans.firstWhereOrNull((element) => element["IsCurrentWeek"]);
        t = tuans.firstWhereOrNull(
            (element) => element["WeekNo"] == t["WeekNo"] + 1);
        if (t != null) tuan.value = t;
        istype.value = 2;
        break;
      case 4:
        break;
    }
    initLich(false);
  }

  void animateToIndex() {
    tuancontroller = ScrollController(initialScrollOffset: initialScrollOffset);
  }

  void goTuan(t) {
    tuan.value = t;
    ghichu.value = "";
    initLich(false);
    initNote();
  }

  initCounts() async {
    try {
      var body = {"user_id": Golbal.store.user["user_id"], "year": year.value};
      Dio dio = Dio();
      dio.options.headers["Authorization"] = "Bearer ${Golbal.store.token}";
      dio.options.followRedirects = true;
      var response = await dio.post(
          "${Golbal.congty!.api}/api/Calendar/Get_Dictionary",
          data: body);
      var data = response.data;
      if (data != null) {
        var tbs = List.castFrom(json.decode(data["data"]));
        if (tbs.isNotEmpty) {
          int idx = List.castFrom(tbs[0])
              .indexWhere((element) => element["IsCurrentWeek"] == true);
          if (idx == -1) {
            idx = 0;
          }
          initialScrollOffset = idx * 105;
          animateToIndex();
          tuans.value = tbs[0];
          initYear(tbs[1]);
          if (idx != -1) {
            tuan.value = tbs[0][idx];
            initLich(false);
            initNote();
          } else {
            isLoadding.value = false;
          }

          phonghops.value = tbs[2];

          kieulaps.value = [
            {"Laplich": 0, "Laplich_Ten": "Không lặp", "donvi": "ngày"},
            {"Laplich": 1, "Laplich_Ten": "Lặp ngày", "donvi": "ngày"},
            {"Laplich": 2, "Laplich_Ten": "Lặp tuần", "donvi": "tuần"},
            {"Laplich": 3, "Laplich_Ten": "Lặp tháng", "donvi": "tháng"},
            {"Laplich": 4, "Laplich_Ten": "Lặp năm", "donvi": "năm"}
          ];
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  initNote() async {
    try {
      var body = {
        "year": year.value,
        "week": tuan["WeekNo"],
        "congty_id": Golbal.store.user["organization_id"]
      };
      Dio dio = Dio();
      dio.options.headers["Authorization"] = "Bearer ${Golbal.store.token}";
      dio.options.followRedirects = true;
      var response = await dio.post(
          "${Golbal.congty!.api}/api/Calendar/Get_NoteByWeek",
          data: body);
      var data = response.data;
      if (data != null) {
        var tbs = List.castFrom(json.decode(data["data"]));
        if (tbs.isNotEmpty) {
          ghichu.value = tbs[0]["Noidung"];
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
    String filePath = tempDir.path + "/" + filename;
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
        String viewUrl = Golbal.congty!.fileurl + "/Viewer/Index?url=" + link;
        !await launchUrl(Uri.parse(viewUrl),
            mode: LaunchMode.inAppWebView, webOnlyWindowName: "Xem Văn bản");
      }
    }
  }

  void openEdit(context, calendar) async {
    var rs = await Get.toNamed("addcalendar", arguments: {
      "title": "Cập nhật lịch họp",
      "LichhopTuan_ID": calendar["LichhopTuan_ID"],
      "dictionarys": [
        phonghops,
        kieulaps,
      ],
    });
    if (rs == true) {
      initLich(false);
      EasyLoading.showSuccess("Cập nhật thành công");
    }
  }

  initLichtrung(lichhop) async {
    try {
      EasyLoading.show(
        status: "Đang kiểm tra thông tin lịch trùng ...",
      );
      Dio dio = Dio();
      dio.options.headers["Authorization"] = "Bearer ${Golbal.store.token}";
      dio.options.followRedirects = true;
      var response = await dio
          .post("${Golbal.congty!.api}/api/Calendar/Get_LichTrungByID", data: {
        "LichhopTuan_ID": lichhop["LichhopTuan_ID"],
        "user_id": Golbal.store.user["user_id"]
      });
      var data = response.data;
      if (data != null) {
        var tbs = List.castFrom(json.decode(data["data"]));
        if (tbs.isNotEmpty) {
          RegExp exp = RegExp(r"<[^>]*>", multiLine: true, caseSensitive: true);
          for (var element in tbs) {
            if (element["nguoithamdus"] != null) {
              element["nguoithamdus"] = json.decode(element["nguoithamdus"]);
            }
            if (element["files"] != null) {
              element["files"] = json.decode(element["files"]);
            }
            if (element["Noidung"] != null) {
              element["Noidung"] =
                  element["Noidung"].toString().replaceAll(exp, "");
            }
          }
          Get.bottomSheet(Container(
            decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                )),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Text("Các lịch đã trùng (${tbs.length})",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Golbal.titleColor,
                          fontSize: 20)),
                ),
                Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemBuilder: (ct, i) => ListTile(
                        onTap: () {
                          goDetail(tbs[i]);
                        },
                        leading: const Icon(FontAwesome.calendar_check_o),
                        subtitle: HtmlWidget(tbs[i]["Noidung"] ?? ""),
                        title: Text(tbs[i]["Lichtrung"],
                            style: const TextStyle(color: Colors.red))),
                    itemCount: tbs.length,
                  ),
                ),
              ],
            ),
          ));
          EasyLoading.dismiss();
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  Future<void> goDetail(calendar) async {
    var rs = await Get.toNamed("/detailcalendar", arguments: calendar);
    if (rs != null) {
      var idx =
          datas.indexWhere((e) => e["LichhopTuan_ID"] == rs["LichhopTuan_ID"]);
      datas[idx] = rs;
    }
  }

  initLich(f) async {
    datas.clear();
    try {
      if (!f) {
        isLoadding.value = true;
      }
      var body = {
        "user_id": options["user_id"] ?? Golbal.store.user["user_id"],
        "week_start_date":
            DateTime.parse(tuan["WeekStartDate"]).toIso8601String(),
        "week_end_date": DateTime.parse(tuan["WeekEndDate"]).toIso8601String(),
        "is_type": istype.value,
        "filter_congty_id": options["filter_congty_id"],
        "s": options["s"],
      };
      String url = "Calendar/Get_CalendarEnactByWeek";
      Dio dio = Dio();
      dio.options.headers["Authorization"] = "Bearer ${Golbal.store.token}";
      dio.options.followRedirects = true;
      var response =
          await dio.post("${Golbal.congty!.api}/api/$url", data: body);
      var data = response.data;
      if (data != null) {
        var tbs = List.castFrom(json.decode(data["data"]));
        if (tbs.isNotEmpty) {
          for (var element in tbs) {
            if (element["anhThumb"] != null) {
              element["anhThumb"] =
                  Golbal.congty!.fileurl + element["anhThumb"];
            }
            if (element["nguoithamdus"] != null) {
              element["nguoithamdus"] = json.decode(element["nguoithamdus"]);
            }
            if (element["files"] != null) {
              element["files"] = json.decode(element["files"]);
            }
          }
          tbs[tbs.length - 1]["IsLast"] = true;
          if (f) {
            datas.addAll(tbs);
          } else {
            datas.value = tbs;
          }
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
    if (loaddingmore.value || lastdata.value == true) return Future.value(null);
    loaddingmore.value = true;
    options["p"] = int.parse(options["p"].toString()) + 1;
    loadData(true);
    return Future.value(null);
  }

  void openYear() {
    Get.bottomSheet(Container(
      decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          )),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
      child: SingleChildScrollView(
        child: Wrap(
            alignment: WrapAlignment.center,
            children: years
                .map((data) => Container(
                    height: 60,
                    margin: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                        color: const Color(0xFF005A9E),
                        borderRadius: BorderRadius.circular(5)),
                    width: 80,
                    child: InkResponse(
                      focusColor: Colors.transparent,
                      hoverColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      onTap: () {
                        year.value = data;
                        initCounts();
                        Get.back();
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Năm",
                            style: TextStyle(color: Colors.white),
                          ),
                          const SizedBox(
                            height: 3,
                          ),
                          Text(
                            "$data",
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontSize: 18),
                          ),
                        ],
                      ),
                    )))
                .toList()),
      ),
    ));
  }

  Future<void> goFilterAdv() async {
    options["pageIndex"] = pageIndex.value;
    var rs = await Get.toNamed("filterlich", arguments: options);
    if (rs == null) return;
    if (rs != null && rs.keys.length > 0) {
      isSearchAdv.value = true;
      for (var k in rs.keys) {
        options[k] = rs[k];
      }
      istype.value = options["is_type"];
    } else {
      isSearchAdv.value = false;
      options = {
        "p": 1,
        "pz": 20,
        "s": null,
        "filter_congty_id": Golbal.store.user["organization_id"],
        "user_id": Golbal.store.user["user_id"]
      };
      istype.value = -1;
    }
    initCounts();
  }

  void initYear(dtyears) {
    years = [];
    for (var y in dtyears) {
      years.add(y["year"]);
    }
  }

  Future<void> initQuyen() async {
    try {
      var body = {"user_id": Golbal.store.user["user_id"]};
      Dio dio = Dio();
      dio.options.headers["Authorization"] = "Bearer ${Golbal.store.token}";
      dio.options.followRedirects = true;
      var response = await dio.post(
          "${Golbal.congty!.api}/api/Calendar/Get_RoleByUser",
          data: body);
      var data = response.data;
      if (data != null) {
        var tbs = List.castFrom(json.decode(data["data"]));
        if (tbs.isNotEmpty) {
          quyen.value = tbs[0];
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  //Duyệt lịch
  Future<void> duyetlich() async {
    ArtDialogResponse response = await ArtSweetAlert.show(
        barrierDismissible: false,
        context: Get.context!,
        artDialogArgs: ArtDialogArgs(
            denyButtonText: "Không",
            title: "Xác nhận",
            text: "Bạn có chắc chắn muốn duyệt các lịch họp này không!",
            confirmButtonText: "Có",
            type: ArtSweetAlertType.warning));

    if (response.isTapConfirmButton) {
      try {
        String noidung = "";
        var rs = await Get.defaultDialog(
            barrierDismissible: false,
            titlePadding: const EdgeInsets.all(20),
            title: "Nội dung duyệt",
            confirm: Container(
              padding: const EdgeInsets.only(bottom: 10),
              height: 46,
              child: ElevatedButton.icon(
                icon: const Icon(Feather.send),
                onPressed: () {
                  Get.back(result: true);
                },
                label: const Text("Gửi", style: TextStyle(color: Colors.white)),
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Golbal.appColor),
                ),
              ),
            ),
            content: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  TextField(
                    minLines: 5,
                    maxLines: 10,
                    decoration: Golbal.decoration,
                    style: Golbal.styleinput,
                    onChanged: (String txt) => noidung = txt,
                  ),
                ],
              ),
            ),
            radius: 30);
        if (rs == false) {
          return;
        }
        Dio dio = Dio();
        dio.options.headers["Authorization"] = "Bearer ${Golbal.store.token}";
        dio.options.followRedirects = true;
        EasyLoading.show(
          status: "Đang xử lý ...",
        );
        var body = {
          "ids": datas
              .where((p0) => p0["Chon"] == true)
              .map((e) => e["LichhopTuan_ID"])
              .toList(),
          "Nguoigui": Golbal.store.user["user_id"],
          "Noidung": noidung,
        };
        try {
          var response = await dio.put(
              "${Golbal.congty!.api}/api/Calendar/Send_NextStep",
              data: body);
          EasyLoading.dismiss();
          if (response.data["err"] == "1") {
            EasyLoading.showToast(
                "Không thể duyệt lịch họp này, vui lòng thử lại!");
          } else {
            if (response.data != null) {
              solichchon.value = 0;
              loadData(false);
              EasyLoading.showToast("Duyệt lịch họp thành công!");
            }
          }
        } catch (e) {
          dio.put(Golbal.congty!.api + '/api/Log/AddLog', data: {
            "title": "Lỗi duyệt lịch họp",
            "controller": "Calendar/Send_NextStep",
            "log_date": DateTime.now().toIso8601String(),
            "log_content": json.encode(body),
            "full_name": Golbal.store.user["FullName"],
            "user_id": Golbal.store.user["user_id"],
            "token_id": Golbal.store.user["Token_ID"],
            "is_type": 0,
            "module": "calendar",
          });
          EasyLoading.dismiss();
          EasyLoading.showToast(
            "Không thể duyệt lịch họp này, vui lòng thử lại!",
          );
        }
      } catch (e) {
        if (kDebugMode) {}
      }
      return;
    }
  }

  Future<void> tralich() async {
    ArtDialogResponse response = await ArtSweetAlert.show(
        barrierDismissible: false,
        context: Get.context!,
        artDialogArgs: ArtDialogArgs(
            denyButtonText: "Không",
            title: "Xác nhận",
            text: "Bạn có chắc chắn muốn trả lại các lịch họp này không!",
            confirmButtonText: "Có",
            type: ArtSweetAlertType.warning));

    if (response.isTapConfirmButton) {
      try {
        String noidung = "";
        var rs = await Get.defaultDialog(
            barrierDismissible: false,
            titlePadding: const EdgeInsets.all(20),
            title: "Lý do trả lại",
            confirm: Container(
              padding: const EdgeInsets.only(bottom: 10),
              height: 46,
              child: ElevatedButton.icon(
                icon: const Icon(Feather.send),
                onPressed: () {
                  Get.back(result: true);
                },
                label: const Text("Gửi", style: TextStyle(color: Colors.white)),
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Golbal.appColor),
                ),
              ),
            ),
            content: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  TextField(
                    minLines: 5,
                    maxLines: 10,
                    decoration: Golbal.decoration,
                    style: Golbal.styleinput,
                    onChanged: (String txt) => noidung = txt,
                  ),
                ],
              ),
            ),
            radius: 30);
        if (rs == false) {
          return;
        }
        Dio dio = Dio();
        dio.options.headers["Authorization"] = "Bearer ${Golbal.store.token}";
        dio.options.followRedirects = true;
        EasyLoading.show(
          status: "Đang xử lý ...",
        );
        var body = {
          "ids": datas
              .where((p0) => p0["Chon"] == true)
              .map((e) => e["LichhopTuan_ID"])
              .toList(),
          "Nguoigui": Golbal.store.user["user_id"],
          "Noidung": noidung,
        };
        try {
          var response = await dio.put(
              "${Golbal.congty!.api}/api/Calendar/Send_PrevStep",
              data: body);
          EasyLoading.dismiss();
          if (response.data["err"] == "1") {
            EasyLoading.showToast(
                "Không thể trả lại lịch họp này, vui lòng thử lại!");
          } else {
            if (response.data != null) {
              solichchon.value = 0;
              loadData(false);
              EasyLoading.showToast("Trả lại lịch họp thành công!");
            }
          }
        } catch (e) {
          dio.put(Golbal.congty!.api + '/api/Log/AddLog', data: {
            "title": "Lỗi trả lại lịch họp",
            "controller": "Calendar/Send_PrevStep",
            "log_date": DateTime.now().toIso8601String(),
            "log_content": json.encode(body),
            "full_name": Golbal.store.user["FullName"],
            "user_id": Golbal.store.user["user_id"],
            "token_id": Golbal.store.user["Token_ID"],
            "is_type": 0,
            "module": "calendar",
          });
          EasyLoading.dismiss();
          EasyLoading.showToast(
            "Không thể trả lại lịch họp này, vui lòng thử lại!",
          );
        }
      } catch (e) {
        if (kDebugMode) {}
      }
      return;
    }
  }

  void gomeeting(lich) {
    String rul = (defaultTargetPlatform == TargetPlatform.windows ||
            defaultTargetPlatform == TargetPlatform.macOS ||
            defaultTargetPlatform == TargetPlatform.linux)
        ? "meetdesktop"
        : "meet";
    Get.toNamed(rul, arguments: lich);
  }

  @override
  void onInit() {
    super.onInit();
    initQuyen();
    initCounts();
  }

  @override
  void onClose() {
    if (tuancontroller != null) tuancontroller!.dispose();
    super.onClose();
  }
}
