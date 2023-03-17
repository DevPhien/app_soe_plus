import 'dart:convert';

import 'package:dio/dio.dart' as dioform;
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:soe/views/component/phongban/listphongban.dart';
import 'package:soe/views/component/phongban/phongbancontroller.dart';

import '../../../../../utils/golbal/golbal.dart';
import '../../../../component/date/custom_date_range_picker.dart';
import '../../../../vanban/comp/listuser.dart';
import '../../../../vanban/controller/uservanbancontroller.dart';

class AddTaskController extends GetxController {
  final UserVBController usercontroller = Get.put(UserVBController());
  final PhongbanController phongbancontroller = Get.put(PhongbanController());
  final formKey = GlobalKey<FormState>();
  var loading = true.obs;
  var upload = false.obs;
  var getdata = {}.obs;

  var model = {}.obs;
  var giaoviecs = [].obs;
  var thuchiens = [].obs;
  var theodois = [].obs;

  var ttcongviecs = [].obs;
  var nhomscongviecs = [].obs;
  var trongsos = [].obs;
  var phongbans = [].obs;
  var duans = [].obs;

  var dictionarys = {};
  Rx<List<PlatformFile>> files = Rx<List<PlatformFile>>([]);
  var filesDA = [].obs;

  //Function Form
  DateTime? cvDate(dynamic sdate) {
    if (sdate is DateTime) return sdate;
    if (sdate == null) return DateTime.now();
    try {
      return DateTime.parse(sdate);
    } catch (e) {
      return DateTime.now();
    }
  }

  void setValue(key, value) {
    model[key] = value;
  }

  void defaultDataChon(RxList<dynamic> dts, String id, String key) {
    var index = dts.indexWhere((e) => e[id] == model[key]);
    if (index != -1) {
      dts[index]["chon"] = true;
    }
  }

  void chooseFilter(
      RxList<dynamic> dts, int idx, String id, String key, bool isOne) {
    if (isOne) {
      dts.where((p0) => p0["chon"] == true).toList().forEach((e) {
        e["chon"] = false;
      });
    }
    if (dts[idx]["chon"] != true) {
      dts[idx]["chon"] = true;

      var chons = dts.where((p0) => p0["chon"] == true).toList();
      if (chons.isNotEmpty) {
        model[key] = chons[0][id];
      }
    } else {
      dts[idx]["chon"] = !(dts[idx]["chon"] || false);
    }
    dts.refresh();
    if (isOne) {
      Get.back();
    }
  }

  void searchData(String s, RxList<dynamic> dts, String key, String name) {
    if (s == "") {
      dts.value = dictionarys[key];
    } else {
      s = Golbal.changeAlias(s);
      dts.value = dictionarys[key]
          .where((element) => Golbal.changeAlias(element[name].toString())
              .toLowerCase()
              .contains(s))
          .toList();
    }
  }

  void chonDate() {
    showCustomDateRangePicker(
      Get.context!,
      dismissible: true,
      minimumDate: DateTime(2000, 1, 1),
      maximumDate: DateTime.now().add(const Duration(days: 1000)),
      endDate: cvDate(model["NgayKetThuc"]),
      startDate: cvDate(model["NgayBatDau"]),
      onApplyClick: (start, end) {
        model["NgayKetThuc"] = end.toIso8601String();
        model["NgayBatDau"] = start.toIso8601String();
      },
      onCancelClick: () {
        model["NgayKetThuc"] = null;
        model["NgayBatDau"] = null;
      },
    );
  }

  void resetDataChon(RxList<dynamic> dts, String key) {
    for (var tb in dts.where((p0) => p0["chon"] == true).toList()) {
      tb["chon"] = false;
    }
    dts.refresh();
  }

  void deleChon(RxList<dynamic> dts, item, String id) {
    int idx = dts.indexWhere((element) => element[id] == item[id]);
    if (idx != -1) {
      dts[idx]["chon"] = false;
      dts.refresh();
    }
  }

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

  void resetChonPhongban(List users) {
    phongbancontroller.phongbans
        .where((p0) =>
            users.indexWhere(
                (element) => element["Phongban_ID"] == p0["Phongban_ID"]) !=
            -1)
        .forEach((element) {
      element["chon"] = true;
    });
    phongbancontroller.groupphongbans
        .where((p0) =>
            users.indexWhere(
                (element) => element["Phongban_ID"] == p0["Phongban_ID"]) !=
            -1)
        .forEach((element) {
      element["chon"] = true;
    });
    phongbancontroller.isChon.value = users.length;
  }

  void deleUser(int i, int loai) {
    if (loai == 1) {
      giaoviecs.removeAt(i);
    } else if (loai == 2) {
      thuchiens.removeAt(i);
    } else if (loai == 3) {
      theodois.removeAt(i);
    }
  }

  void delePhongban(int i, int loai) {
    if (loai == 1) {
      phongbans.removeAt(i);
    }
  }

  //Function
  Future<void> showUser(int loai) async {
    usercontroller.users.where((p0) => p0["chon"] == true).forEach((element) {
      element["chon"] = false;
    });
    usercontroller.users.where((p0) => p0["chon"] == true).forEach((element) {
      element["chon"] = false;
    });
    usercontroller.isChon.value = 0;
    bool one = false;
    if (loai == 1) {
      one = true;
      resetChon(giaoviecs);
    } else if (loai == 2) {
      one = true;
      resetChon(thuchiens);
    } else if (loai == 3) {
      resetChon(theodois);
    }
    var rs = await showCupertinoModalBottomSheet(
      context: Get.context!,
      expand: true,
      builder: (context) => ListUserVanBan(one: one),
    );
    if (rs != null) {
      if (loai == 1) {
        giaoviecs.value = rs;
      } else if (loai == 2) {
        thuchiens.value = rs;
      } else if (loai == 3) {
        theodois.value = rs;
      }
    }
  }

  Future<void> showPhongban(int loai) async {
    phongbancontroller.phongbans
        .where((p0) => p0["chon"] == true)
        .forEach((element) {
      element["chon"] = false;
    });
    phongbancontroller.groupphongbans
        .where((p0) => p0["chon"] == true)
        .forEach((element) {
      element["chon"] = false;
    });
    phongbancontroller.isChon.value = 0;
    bool one = false;
    if (loai == 1) {
      one = true;
      resetChonPhongban(phongbans);
    }
    var rs = await showCupertinoModalBottomSheet(
      context: Get.context!,
      expand: true,
      builder: (context) => ListPhongban(one: one),
    );
    if (rs != null) {
      if (loai == 1) {
        phongbans.value = rs;
      }
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

  Future<void> saveTask() async {
    try {
      formKey.currentState!.save();
      if (upload.value == true) {
        EasyLoading.showInfo(
            "Đang cập nhật công việc, bạn vui lòng thao tác chậm lại!");
        return;
      }
      if (model["CongviecTen"] == null || model["CongviecTen"] == "") {
        EasyLoading.showInfo("Vui lòng nhập tên công việc...");
        return;
      }
      if (model["IsDeadline"] == true &&
          (model["NgayBatDau"] == null || model["NgayKetThuc"] == null)) {
        EasyLoading.showInfo("Vui lòng nhập thời gian xử lý công việc!");
        return;
      }
      upload.value = true;
      if (formKey.currentState!.validate()) {
        formKey.currentState!.save();
        EasyLoading.show(status: 'Đang cập nhật...');

        if (phongbans.isNotEmpty) {
          model["Phongban_ID"] = phongbans[0]["Phongban_ID"];
        } else {
          model["Phongban_ID"] = null;
        }

        Map<String, dynamic> mdata = {
          "models": json.encode({
            "user_id": Golbal.store.user["user_id"],
            "task": model,
            "giaoviecs": giaoviecs
                .map((element) => {
                      "NhanSu_ID": element["NhanSu_ID"],
                      "CongviecThamgiaID": null,
                      "STT": 1,
                    })
                .toList(),
            "thuchiens": thuchiens
                .map((element) => {
                      "NhanSu_ID": element["NhanSu_ID"],
                      "CongviecThamgiaID": null,
                      "STT": 1,
                    })
                .toList(),
            "theodois": theodois
                .map((element) => {
                      "NhanSu_ID": element["NhanSu_ID"],
                      "CongviecThamgiaID": null,
                      "STT": 1,
                    })
                .toList(),
          })
        };
        var ffiles = [];
        for (var fi in files.value) {
          if (kIsWeb) {
            ffiles.add(
                dioform.MultipartFile.fromBytes(fi.bytes!, filename: fi.name));
          } else {
            ffiles.add(dioform.MultipartFile.fromFileSync(fi.path!,
                filename: fi.name));
          }
        }
        mdata["file"] = ffiles;
        dioform.FormData formData = dioform.FormData.fromMap(mdata);
        Dio dio = Dio();
        dio.options.headers["Authorization"] = "Bearer ${Golbal.store.token}";
        dio.options.followRedirects = true;
        var response = await dio
            .put("${Golbal.congty!.api}/api/Task/Update_Task", data: formData);
        var data = response.data;
        if (data["err"] == "1") {
          EasyLoading.showError("Có lỗi xảy ra, vui lòng thử lại!");
          return;
        }
        Get.back(result: true);
      } else {
        EasyLoading.showError(
            "Vui lòng nhập đầy đủ thông tin của phiếu công việc!");
        return;
      }
      upload.value = false;
      EasyLoading.dismiss();
    } catch (e) {
      upload.value = false;
      EasyLoading.dismiss();
      if (kDebugMode) {
        print(e);
      }
    }
  }

  void deleteFileDA(i) async {
    try {
      EasyLoading.show(status: "loading...");

      var body = {
        "user_id": Golbal.store.user["user_id"],
        "FileID": filesDA[i]["FileID"],
      };
      String url = "Task/Delete_File";
      Dio dio = Dio();
      dio.options.headers["Authorization"] = "Bearer ${Golbal.store.token}";
      dio.options.followRedirects = true;
      var response =
          await dio.put("${Golbal.congty!.api}/api/$url", data: body);
      var data = response.data;
      if (data["err"] == "1") {
        EasyLoading.showError("Có lỗi xảy ra, vui lòng thử lại!");
        return;
      }
      filesDA.removeAt(i);
      EasyLoading.showSuccess("Xóa thành công");
    } catch (e) {
      EasyLoading.showError("Có lỗi xảy ra!");
      if (kDebugMode) {
        print(e);
      }
    }
  }

  void deleteFile(i) {
    files.value.removeAt(i);
    files.refresh();
  }

  @override
  void onInit() {
    super.onInit();
    getdata.value = Get.arguments;
    initData();
  }

  void initData() {
    initDictionary();
    if (getdata["CongviecID"] != null) {
      getTask(true);
    } else {
      loading.value = false;
      model["ParentID"] = getdata["ParentID"];
      model["DuanID"] = getdata["DuanID"];
      model["YeucauReview"] = true;
      model["IsDeadline"] = true;
      model["Uutien"] = false;
      model["IsCheck"] = false;
      model["IsDelete"] = false;
      model["IsTodo"] = false;
      model["Trangthai"] = 0;
      model["STT"] = 1;
      model["Trongso"] = 2;
      model["CongviecID"] = -1;
      model["Congty_ID"] = Golbal.store.user["organization_id"];
      thuchiens.add({
        "NhanSu_ID": Golbal.store.user["user_id"],
        "anhThumb": Golbal.store.user["Avartar"],
        "fullName": Golbal.store.user["FullName"],
        "ten": Golbal.store.user["fname"],
      });
      giaoviecs.add({
        "NhanSu_ID": Golbal.store.user["user_id"],
        "anhThumb": Golbal.store.user["Avartar"],
        "fullName": Golbal.store.user["FullName"],
        "ten": Golbal.store.user["fname"],
      });
    }
  }

  void initDictionary() {
    if (getdata["dictionarys"] != null) {
      if (getdata["dictionarys"][0].isNotEmpty) {
        ttcongviecs.value = getdata["dictionarys"][0];
        dictionarys["ttcongviecs"] = getdata["dictionarys"][0];

        for (var t in List.castFrom(dictionarys["ttcongviecs"])
            .where((e) => e["chon"] == true)
            .toList()) {
          t["chon"] = false;
        }
      } else {
        ttcongviecs.value = [];
        dictionarys["ttcongviecs"] = [];
      }

      if (getdata["dictionarys"][2].isNotEmpty) {
        nhomscongviecs.value = getdata["dictionarys"][2];
        dictionarys["nhomscongviecs"] = getdata["dictionarys"][2];

        for (var t in List.castFrom(dictionarys["nhomscongviecs"])
            .where((e) => e["chon"] == true)
            .toList()) {
          t["chon"] = false;
        }
      } else {
        nhomscongviecs.value = [];
        dictionarys["nhomscongviecs"] = [];
      }

      if (getdata["dictionarys"][4].isNotEmpty) {
        trongsos.value = getdata["dictionarys"][4];
        dictionarys["trongsos"] = getdata["dictionarys"][4];

        for (var t in List.castFrom(dictionarys["trongsos"])
            .where((e) => e["chon"] == true)
            .toList()) {
          t["chon"] = false;
        }
      } else {
        trongsos.value = [];
        dictionarys["trongsos"] = [];
      }

      if (getdata["duans"].isNotEmpty) {
        duans.value = getdata["duans"];
        dictionarys["duans"] = getdata["duans"];

        for (var t in List.castFrom(dictionarys["duans"])
            .where((e) => e["chon"] == true)
            .toList()) {
          t["chon"] = false;
        }
      } else {
        duans.value = [];
        dictionarys["duans"] = [];
      }
    } else {
      ttcongviecs.value = [];
      dictionarys["ttcongviecs"] = [];
      nhomscongviecs.value = [];
      dictionarys["nhomscongviecs"] = [];
      trongsos.value = [];
      dictionarys["trongsos"] = [];
      duans.value = [];
      dictionarys["duans"] = [];
    }
  }

  void getTask(f) async {
    try {
      if (f) {
        loading.value = true;
        EasyLoading.show(status: "loading...");
      }
      Dio dio = Dio();
      dio.options.headers["Authorization"] = "Bearer ${Golbal.store.token}";
      dio.options.followRedirects = true;
      var response = await dio
          .post("${Golbal.congty!.api}/api/Task/Get_TaskByID", data: {
        "congviec_id": getdata["CongviecID"],
        "user_id": Golbal.store.user["user_id"]
      });
      var data = response.data;
      if (data["err"] == 1) {
        EasyLoading.showError("Có lỗi xảy ra, vui lòng thử lại");
      }
      if (data != null) {
        var tbs = List.castFrom(json.decode(data["data"]));
        if (tbs.isNotEmpty) {
          model.value = tbs[0][0];

          if (model["Thanhviens"] != null) {
            model["Thanhviens"] = json.decode(model["Thanhviens"]);
            List thanhviens = List.castFrom(model["Thanhviens"]);
            model["giaoviec"] = thanhviens.firstWhereOrNull((element) =>
                element["IsType"] != null &&
                element["IsType"].toString() == "2");
            model["thuchien"] = thanhviens.firstWhereOrNull((element) =>
                element["IsType"] != null &&
                element["IsType"].toString() == "1");
          }

          model["IsHT"] = model["Trangthai"] == 4 || model["Trangthai"] == 7;
          model["active"] = model["Trangthai"] == 1 ||
              model["Trangthai"] == 5 ||
              model["Trangthai"] == 6 ||
              model["Trangthai"] == 8;

          var members = List.castFrom(tbs[1]).toList();
          if (members.isNotEmpty) {
            giaoviecs.value = members
                .where((e) => e["IsType"] == 2 && e["IsActive"] == true)
                .toList();
            thuchiens.value = members
                .where((e) => e["IsType"] == 1 && e["IsActive"] == true)
                .toList();
            theodois.value = members
                .where((e) => e["IsType"] == 0 && e["IsActive"] == true)
                .toList();
            var me = members.firstWhere(
                (e) =>
                    e["IsType"] == 2 &&
                    e["NhanSu_ID"] == Golbal.store.user["user_id"],
                orElse: () => null);
            if (me != null) {
              model["isgiaoviec"] = true;
            } else {
              model["isgiaoviec"] = false;
            }
            me = members.firstWhere(
                (e) =>
                    e["IsType"] == 1 &&
                    e["NhanSu_ID"] == Golbal.store.user["NhanSu_ID"],
                orElse: () => null);
            if (me != null) {
              model["isthuchien"] = true;
            } else {
              model["isthuchien"] = false;
            }
          }

          filesDA.value = List.castFrom(tbs[2]).toList();

          if (model["Phongban_ID"] != null) {
            phongbans.value = [
              {
                "Phongban_ID": model["Phongban_ID"],
                "tenPhongban": model["tenPhongban"],
              },
            ];
          }
        }
      }
      if (loading.value) loading.value = false;
      EasyLoading.dismiss();
    } catch (e) {
      if (loading.value) loading.value = false;
      EasyLoading.dismiss();
      if (kDebugMode) {
        print(e);
      }
    }
  }

  // @override
  // void onClose() {
  //   super.onClose();
  // }
}
