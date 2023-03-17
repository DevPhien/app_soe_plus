import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

import '../../../utils/golbal/golbal.dart';

class HomeVanbanController extends GetxController {
  ScrollController vbController = ScrollController();
  RxInt pageIndex = 1.obs;
  var loaddingmore = false;
  RxBool isLoadding = true.obs;
  var lastdata = false.obs;
  var datas = [].obs;
  var countdata = {}.obs;
  RxInt typeVB = 0.obs;
  Map<String, dynamic> options = {"p": 1, "pz": 20, "s": null};
  var isSearchAdv = false.obs;
  void goTypeVanban(int type) {
    typeVB.value = type;
    datas.clear();
    options["s"] = null;
    options["p"] = 1;
    lastdata.value = false;
    loadData(false, iscount: false);
  }

  void onPageChanged(int p) {
    datas.clear();
    if (p == 0) {
      Get.back();
      return;
    }
    typeVB.value = 0;
    pageIndex.value = p;
    lastdata.value = false;
    vbController.animateTo(0,
        duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
    loadData(false);
  }

  void loadData(f, {bool? iscount}) {
    switch (pageIndex.value) {
      case 1:
        if (!f) {
          if (iscount != false) {
            initCounts("Doc");
          }
          options["p"] = 1;
        }
        initTopDocNhan(f);
        break;
      case 2:
        if (!f) {
          if (iscount != false) {
            initCounts("SendDoc");
          }
          options["p"] = 1;
        }
        initTopDocGui(f);
        break;
      case 3:
        if (!f) {
          if (iscount != false) {
            initCounts("DocStore");
          }
          options["p"] = 1;
        }
        initTopDocTu(f);
        break;
    }
  }

  initCounts(String api) async {
    countdata.value = {};
    try {
      var body = {"user_id": Golbal.store.user["user_id"]};
      Dio dio = Dio();
      dio.options.headers["Authorization"] = "Bearer ${Golbal.store.token}";
      dio.options.followRedirects = true;
      var response = await dio
          .post("${Golbal.congty!.api}/api/$api/GetCountHomeDoc", data: body);
      var data = response.data;
      if (data != null) {
        var tbs = List.castFrom(json.decode(data["data"]));
        if (tbs.isNotEmpty) {
          countdata.value = tbs[0];
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  initTopDocNhan(f) async {
    try {
      if (!f) {
        isLoadding.value = true;
      }
      var body = {
        "user_id": Golbal.store.user["user_id"],
        "p": options["p"],
        "pz": options["pz"],
        "s": options["s"] != "" ? options["s"] : null
      };
      String url = "Doc/GetListTopDoc";
      if (typeVB.value != 0) {
        body = {
          "user_id": Golbal.store.user["user_id"],
          "type": typeVB.value,
          "p": options["p"],
          "pz": options["pz"],
          "s": options["s"] != "" ? options["s"] : null
        };
        url = "Doc/GetListDocByType";
      }
      if (isSearchAdv.value) {
        body = {
          "user_id": Golbal.store.user["user_id"],
          "type": options["type"],
          "sort": options["sort"],
          "groups": options["groups"],
          "status": options["status"],
          "doc_sdate": options["doc_sdate"],
          "doc_edate": options["doc_edate"],
          "places": options["places"],
          "senders": options["senders"],
          "fields": options["fields"],
          "p": options["p"],
          "pz": options["pz"],
          "s": options["s"] != "" ? options["s"] : null
        };
        url = "Doc/GetListDocByFilter";
      }
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
          }
          if (f) {
            datas.addAll(tbs);
          } else {
            datas.value = tbs;
          }
          //print(tbs);
        } else {
          lastdata.value = true;
          EasyLoading.showToast("Bạn đã xem hết văn bản rồi!");
        }
        if (loaddingmore) {
          loaddingmore = false;
        }
      } else {
        lastdata.value = true;
        EasyLoading.showToast("Bạn đã xem hết văn bản rồi!");
      }
      if (isLoadding.value) {
        isLoadding.value = false;
      }
      EasyLoading.dismiss();
    } catch (e) {
      if (isLoadding.value) {
        isLoadding.value = false;
      }
      if (kDebugMode) {
        print(e);
      }
      EasyLoading.dismiss();
    }
  }

  initTopDocGui(f) async {
    try {
      if (!f) {
        isLoadding.value = true;
      }
      var body = {
        "user_id": Golbal.store.user["user_id"],
        "p": options["p"],
        "pz": options["pz"],
        "s": options["s"] != "" ? options["s"] : null
      };
      String url = "SendDoc/GetListTopDoc";
      if (typeVB.value != 0) {
        body = {
          "user_id": Golbal.store.user["user_id"],
          "type": typeVB.value,
          "p": options["p"],
          "pz": options["pz"],
          "s": options["s"] != "" ? options["s"] : null
        };
        url = "SendDoc/GetListDocByType";
      }
      if (isSearchAdv.value) {
        body = {
          "user_id": Golbal.store.user["user_id"],
          "type": options["type"],
          "sort": options["sort"],
          "groups": options["groups"],
          "status": options["status"],
          "doc_sdate": options["doc_sdate"],
          "doc_edate": options["doc_edate"],
          "places": options["places"],
          "senders": options["senders"],
          "fields": options["fields"],
          "p": options["p"],
          "pz": options["pz"],
          "s": options["s"] != "" ? options["s"] : null
        };
        url = "SendDoc/GetListDocByFilter";
      }
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
          }
          if (f) {
            datas.addAll(tbs);
          } else {
            datas.value = tbs;
          }
          //print(tbs);
        } else {
          lastdata.value = true;
          EasyLoading.showToast("Bạn đã xem hết văn bản rồi!");
        }
        if (loaddingmore) {
          loaddingmore = false;
        }
      } else {
        lastdata.value = true;
        EasyLoading.showToast("Bạn đã xem hết văn bản rồi!");
      }
      if (isLoadding.value) {
        isLoadding.value = false;
      }
      EasyLoading.dismiss();
    } catch (e) {
      if (isLoadding.value) {
        isLoadding.value = false;
      }
      if (kDebugMode) {
        print(e);
      }
      EasyLoading.dismiss();
    }
  }

  initTopDocTu(f) async {
    try {
      if (!f) {
        isLoadding.value = true;
      }
      var body = {
        "user_id": Golbal.store.user["user_id"],
        "p": options["p"],
        "pz": options["pz"],
        "s": options["s"] != "" ? options["s"] : null
      };
      String url = "DocStore/GetListTopDoc";
      if (typeVB.value != 0) {
        body = {
          "user_id": Golbal.store.user["user_id"],
          "type": typeVB.value,
          "p": options["p"],
          "pz": options["pz"],
          "s": options["s"] != "" ? options["s"] : null
        };
        url = "DocStore/GetListDocByType";
      }
      if (isSearchAdv.value) {
        body = {
          "user_id": Golbal.store.user["user_id"],
          "type": options["type"],
          "sort": options["sort"],
          "groups": options["groups"],
          "status": options["status"],
          "doc_sdate": options["doc_sdate"],
          "doc_edate": options["doc_edate"],
          "places": options["places"],
          "senders": options["senders"],
          "fields": options["fields"],
          "p": options["p"],
          "pz": options["pz"],
          "s": options["s"] != "" ? options["s"] : null
        };
        url = "DocStore/GetListDocByFilter";
      }
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
          }
          if (f) {
            datas.addAll(tbs);
          } else {
            datas.value = tbs;
          }
          //print(tbs);
        } else {
          lastdata.value = true;
          EasyLoading.showToast("Bạn đã xem hết văn bản rồi!");
        }
        if (loaddingmore) {
          loaddingmore = false;
        }
      } else {
        lastdata.value = true;
        EasyLoading.showToast("Bạn đã xem hết văn bản rồi!");
      }
      if (isLoadding.value) {
        isLoadding.value = false;
      }
      EasyLoading.dismiss();
    } catch (e) {
      if (isLoadding.value) {
        isLoadding.value = false;
      }
      if (kDebugMode) {
        print(e);
      }
      EasyLoading.dismiss();
    }
  }

  Future<void> refershData() {
    datas.clear();
    return Future.value(null);
  }

  void search(String s) {
    isLoadding.value = true;
    datas.clear();
    options["s"] = s;
    options["p"] = 1;
    loadData(true);
  }

  Future<void> goFilterAdv() async {
    var rs = await Get.toNamed("filtervanban", arguments: options);
    if (rs == null) return;
    if (rs != null && rs.keys.length > 0) {
      isSearchAdv.value = true;
      for (var k in rs.keys) {
        options[k] = rs[k];
      }
    } else {
      isSearchAdv.value = false;
      options["groups"] = null;
      options["places"] = null;
      options["status"] = null;
      options["senders"] = null;
      options["fields"] = null;
      options["s"] = null;
      options["type"] = null;
      options["sort"] = 1;
    }
    vbController.animateTo(0,
        duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
    isLoadding.value = true;
    datas.clear();
    options["p"] = 1;
    loadData(true);
  }

  void clearAdv() {
    isSearchAdv.value = false;
    options["groups"] = null;
    options["places"] = null;
    options["status"] = null;
    options["senders"] = null;
    options["fields"] = null;
    options["type"] = null;
    options["sort"] = 1;
    vbController.animateTo(0,
        duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
    isLoadding.value = true;
    datas.clear();
    options["p"] = 1;
    loadData(true);
  }

  Future<void> onLoadmore() {
    if (loaddingmore || lastdata.value == true) return Future.value(null);
    loaddingmore = true;
    options["p"] = int.parse(options["p"].toString()) + 1;
    EasyLoading.show(
      status: "Đang tải trang ${options["p"]}",
    );
    loadData(true);
    return Future.value(null);
  }

  @override
  void onClose() {
    vbController.dispose();
    super.onClose();
  }

  @override
  void onInit() {
    super.onInit();
    if (countdata["vball"] == null) {
      initCounts("doc");
      initTopDocNhan(false);
    }
  }
}
