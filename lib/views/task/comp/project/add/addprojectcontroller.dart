import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio/dio.dart' as dioform;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:soe/utils/golbal/golbal.dart';
import 'package:soe/views/component/date/custom_date_range_picker.dart';
import 'package:soe/views/component/phongban/listphongban.dart';
import 'package:soe/views/component/phongban/phongbancontroller.dart';
import 'package:soe/views/vanban/comp/listuser.dart';
import 'package:soe/views/vanban/controller/uservanbancontroller.dart';

class AddProjectController extends GetxController {
  final UserVBController usercontroller = Get.put(UserVBController());
  final PhongbanController phongbancontroller = Get.put(PhongbanController());
  final ImagePicker _picker = ImagePicker();

  //Declare
  var loading = true.obs;
  var upload = false.obs;
  var getdata = {}.obs;
  final formKey = GlobalKey<FormState>();
  var model = {}.obs;
  var quantris = [].obs;
  var thamgias = [].obs;
  var phongbans = [].obs;
  var nhoms = [].obs;
  var status = [
    {"Trangthai": 0, "text": "Đang lập kế hoạch"},
    {"Trangthai": 1, "text": "Đang thực hiện"},
    {"Trangthai": 2, "text": "Đã hoàn thành"},
    {"Trangthai": 3, "text": "Tạm dừng"},
    {"Trangthai": 4, "text": "Đóng"},
  ].obs;

  var dictionarys = {};
  Rx<File> logo = File("").obs;
  Rx<File> anhnen = File("").obs;
  Rx<List<PlatformFile>> files = Rx<List<PlatformFile>>([]);
  var filesDA = [].obs;

  //Funtion choose user
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
      resetChon(quantris);
    } else if (loai == 0) {
      resetChon(thamgias);
    }
    var rs = await showCupertinoModalBottomSheet(
      context: Get.context!,
      expand: true,
      builder: (context) => ListUserVanBan(one: one),
    );
    if (rs != null) {
      if (loai == 1) {
        quantris.value = rs;
      } else if (loai == 0) {
        thamgias.value = rs;
      }
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

  void deleUser(int i, int loai) {
    if (loai == 1) {
      quantris.removeAt(i);
    } else if (loai == 0) {
      thamgias.removeAt(i);
    }
  }

  void defaultDataChon(RxList<dynamic> dts, String id, String key) {
    var index = dts.indexWhere((e) => e[id] == model[key]);
    if (index != -1) {
      dts[index]["chon"] = true;
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

  DateTime? cvDate(dynamic sdate) {
    if (sdate is DateTime) return sdate;
    if (sdate == null) return DateTime.now();
    try {
      return DateTime.parse(sdate);
    } catch (e) {
      return DateTime.now();
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

  Future getImage(f) async {
    final XFile? result = await _picker.pickImage(source: ImageSource.gallery);
    if (result != null) {
      if (f) {
        logo.value = File(result.path);
        model["Logo"] = null;
      } else {
        anhnen.value = File(result.path);
        model["Anhnen"] = null;
      }
    }
  }

  //Function
  Future<void> saveProject() async {
    try {
      formKey.currentState!.save();
      if (upload.value == true) {
        EasyLoading.showInfo(
            "Đang cập nhật công việc, bạn vui lòng thao tác chậm lại!");
        return;
      }
      if (model["TenDuan"] == null || model["TenDuan"] == "") {
        EasyLoading.showInfo("Vui lòng nhập tên dự án!");
        return;
      }
      upload.value = true;
      if (formKey.currentState!.validate()) {
        formKey.currentState!.save();
        EasyLoading.show(status: 'Đang cập nhật...');

        Map<String, dynamic> mdata = {
          "models": json.encode({
            "user_id": Golbal.store.user["user_id"],
            "project": model,
            "quantris": quantris.map((e) => e["NhanSu_ID"]).toSet().toList(),
            "thamgias": thamgias.map((e) => e["NhanSu_ID"]).toSet().toList(),
            "phongbans":
                phongbans.map((e) => e["Phongban_ID"]).toSet().toList(),
          })
        };
        if (logo.value.path != "") {
          mdata["logo"] = await dioform.MultipartFile.fromFile(logo.value.path,
              filename: logo.value.path.split('/').last);
        }
        if (anhnen.value.path != "") {
          mdata["anhnen"] = await dioform.MultipartFile.fromFile(
              anhnen.value.path,
              filename: anhnen.value.path.split('/').last);
        }
        dioform.FormData formData = dioform.FormData.fromMap(mdata);
        Dio dio = Dio();
        dio.options.headers["Authorization"] = "Bearer ${Golbal.store.token}";
        dio.options.followRedirects = true;
        var response = await dio.put(
            "${Golbal.congty!.api}/api/Task/Update_Project",
            data: formData);
        var data = response.data;
        if (data["err"] == "1") {
          EasyLoading.showError("Có lỗi xảy ra, vui lòng thử lại!");
          return;
        }
        Get.back(result: true);
      } else {
        EasyLoading.showError(
            "Vui lòng nhập đầy đủ thông tin của phiếu dự án!");
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

  Future<void> openFile() async {
    FilePickerResult? result =
        await FilePicker.platform.pickFiles(allowMultiple: true);

    if (result != null) {
      files.value = result.files;
    } else {
      // User canceled the picker
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

  void delePhongban(int i, int loai) {
    if (loai == 1) {
      phongbans.removeAt(i);
    }
  }

  //init

  @override
  void onInit() {
    super.onInit();
    getdata.value = Get.arguments;
    initData();
  }

  void initData() {
    if (getdata["DuanID"] != null) {
      model.value = {};
      initModel();
      getProject(true);
    } else {
      loading.value = false;
      model.value = {
        "Congty_ID": Golbal.congty!.congtyID.toString(),
        "DuanID": null,
        "LoaiDuan": 0,
        "YeucauReview": true,
        "Trangthai": 0,
        "STT": getdata["STT"],
      };
      initModel();
    }
  }

  void initModel() {
    if (getdata["dictionarys"] != null) {
      if (getdata["dictionarys"][1].isNotEmpty) {
        nhoms.value = getdata["dictionarys"][1];
        dictionarys["nhoms"] = getdata["dictionarys"][1];

        for (var t in List.castFrom(dictionarys["nhoms"])
            .where((e) => e["chon"] == true)
            .toList()) {
          t["chon"] = false;
        }
      } else {
        nhoms.value = [];
        dictionarys["nhoms"] = [];
      }
    } else {
      nhoms.value = [];
      dictionarys["nhoms"] = [];
    }

    dictionarys["status"] = [
      {"Trangthai": 0, "text": "Đang lập kế hoạch"},
      {"Trangthai": 1, "text": "Đang thực hiện"},
      {"Trangthai": 2, "text": "Đã hoàn thành"},
      {"Trangthai": 3, "text": "Tạm dừng"},
      {"Trangthai": 4, "text": "Đóng"},
    ];
  }

  void getProject(f) async {
    try {
      if (f) {
        loading.value = true;
        EasyLoading.show(status: "loading...");
      }
      var body = {
        "user_id": Golbal.store.user["user_id"],
        "DuanID": getdata["DuanID"],
      };
      String url = "Task/Project_Edit";
      Dio dio = Dio();
      dio.options.headers["Authorization"] = "Bearer ${Golbal.store.token}";
      dio.options.followRedirects = true;
      var response =
          await dio.post("${Golbal.congty!.api}/api/$url", data: body);
      var data = response.data;
      if (data["err"] == 1) {
        loading.value = false;
        EasyLoading.showError("Có lỗi xảy ra, vui lòng thử lại!");
        return;
      }

      var tbs = List.castFrom(json.decode(data["data"]));
      if (tbs[0].isNotEmpty) {
        model.value = tbs[0][0];
      }
      quantris.value = List.castFrom(tbs[1]).toList();
      thamgias.value = List.castFrom(tbs[2]).toList();
      phongbans.value = List.castFrom(tbs[3]).toList();
      filesDA.value = List.castFrom(tbs[4]).toList();

      loading.value = false;
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
