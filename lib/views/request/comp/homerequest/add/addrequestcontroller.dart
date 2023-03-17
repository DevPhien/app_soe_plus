import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:dio/dio.dart' as dioform;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:soe/utils/golbal/golbal.dart';
import 'package:soe/views/vanban/comp/listuser.dart';
import 'package:soe/views/vanban/controller/uservanbancontroller.dart';

class AddRequestController extends GetxController {
  final UserVBController usercontroller = Get.put(UserVBController());
  StreamController<List<int>> ctrrows = StreamController<List<int>>.broadcast();
  var loading = true.obs;
  var upload = false.obs;
  var getdata = {}.obs;
  final formKey = GlobalKey<FormState>();
  var model = {}.obs;
  var form = {}.obs;
  var formD = [].obs;
  var teamdxs = [].obs;
  var loaidxs = [].obs;
  var mucdodxs = [
    {"Uutien": 0, "TenUutien": "Bình thường"},
    {"Uutien": 1, "TenUutien": "Gấp"},
    {"Uutien": 2, "TenUutien": "Rất gấp"},
  ].obs;
  var loaiqts = [
    {"IsQuytrinhduyet": 0, "QT_Name": "Duyệt 1 trong nhiều"},
    {"IsQuytrinhduyet": 1, "QT_Name": "Duyệt tuần tự"},
    {"IsQuytrinhduyet": 2, "QT_Name": "Duyệt ngẫu nhiên"},
  ].obs;
  var nguoiduyets = [].obs;
  var nguoiquanlys = [].obs;
  var nguoiheodois = [].obs;
  var signusers = [].obs;

  var dictionarys = {};
  Rx<List<PlatformFile>> files = Rx<List<PlatformFile>>([]);
  var filesDA = [].obs;

  //style

  //function page
  void goBack(isload) {
    Get.back(result: isload);
  }

  void defaultDataChon(RxList<dynamic> dts, String id, String key) {
    var index = dts.indexWhere((e) => e[id] == model[key]);
    if (index != -1) {
      dts[index]["chon"] = true;
    }
  }

  void resetDataChon(RxList<dynamic> dts, String key) {
    for (var tb in dts.where((p0) => p0["chon"] == true).toList()) {
      tb["chon"] = false;
    }
    dts.refresh();
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
    if (key == "Form_ID") {
      renderForm();
    }
    if (isOne) {
      Get.back();
    }
  }

  void renderForm() {
    var arrteams = List.castFrom(getdata["dictionarys"][1])
        .where((p0) =>
            List.castFrom(getdata["dictionarys"][3]).indexWhere((e) =>
                e["Form_ID"] == model["Form_ID"] &&
                e["Team_ID"] == p0["Team_ID"]) !=
            -1)
        .toList();
    var tid;
    if (teamdxs.isNotEmpty) {
      tid = teamdxs[0]["Team_ID"];
    }
    var fteam = List.castFrom(getdata["dictionarys"][3]).firstWhere(
        (e) => e["Form_ID"] == model["Form_ID"] && e["Team_ID"] == tid,
        orElse: () => null);

    var fd = model["Ngaylap"] as DateTime;
    if (fteam != null && model["Form_ID"] != null) {
      model["Dateline"] =
          fd.add(Duration(minutes: calcranks((fteam["IsSLA"] ?? 8) * 60)));

      model["IsSLA"] = fteam["IsSLA"];
      model["IsChangeQT"] = fteam["IsChangeQT"];
      model["IsSkip"] = fteam["IsSkip"] ?? false;
      model["IsQuytrinhduyet"] = model["IsQuytrinhduyet"] ?? 1;
      model["Form_ID"] = model["Form_ID"];
      model["Form_Name"] = model["Form_Name"];
      model["Team_ID"] = fteam["Team_ID"];
      var team = teamdxs.firstWhere((e) => e["Team_ID"] == fteam["Team_ID"],
          orElse: () => null);
      if (team != null) {
        model["Team_Name"] = team["Team_Name"];
      }

      teamdxs.value = arrteams;
    } else if (model["Form_ID"] == null) {
      model["Dateline"] = fd.add(Duration(minutes: calcranks(8 * 60)));

      model["IsSLA"] = 8;
      model["IsChangeQT"] = true;
      model["IsSkip"] = true;
      model["IsQuytrinhduyet"] = 1;
      model["Form_ID"] = null;
      model["Form_Name"] = "Đề xuất trực tiếp";
      model["Team_ID"] = teamdxs[0]["Team_ID"];
      model["Team_Name"] = teamdxs[0]["Team_Name"];

      teamdxs.value = List.castFrom(getdata["dictionarys"][1]);
    } else {
      model["Team_ID"] = null;
      model["Team_Name"] = null;
      model["IsSLA"] = model["IsSLA"] ?? 8;
      model["Dateline"] =
          fd.add(Duration(minutes: calcranks((model["IsSLA"] ?? 8) * 60)));
      model["IsChangeQT"] = false;
      model["IsSkip"] = false;
      model["IsQuytrinhduyet"] = model["IsQuytrinhduyet"] ?? 1;
      model["Form_ID"] = model["Form_ID"];
      model["Form_Name"] = model["Form_Name"];

      teamdxs.value = arrteams;
    }
    loadForm();
    loadSignUser();
  }

  int calcranks(ranks) {
    return ranks.round();
  }

  //function add
  Future<void> tabDate(BuildContext context, da) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: da["IsGiatri"] ?? DateTime.now(),
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != da["IsGiatri"]) {
      da["IsGiatri"] = picked;
    }
  }

  Future<void> tabTime(BuildContext context, da) async {
    final TimeOfDay? picked = await showTimePicker(
        context: context,
        initialTime:
            timeConvert((da["IsGiatri"] ?? TimeOfDay.now()).toString()));
    if (picked != null && picked != da["IsGiatri"]) {
      da["IsGiatri"] = picked.format(context);
    }
  }

  TimeOfDay timeConvert(String normTime) {
    if (normTime.isEmpty) {
      return TimeOfDay.now();
    }
    var time = normTime.split(":");
    return TimeOfDay(hour: int.parse(time[0]), minute: int.parse(time[1]));
  }

  String datetimeString(dd) {
    if (dd is DateTime) {
      return dd.toIso8601String();
    }
    return dd ?? "";
  }

  void setValue(key, value) {
    model[key] = value;
  }

  Future<void> showUser(int loai) async {
    usercontroller.users.where((p0) => p0["chon"] == true).forEach((element) {
      element["chon"] = false;
    });
    usercontroller.users.where((p0) => p0["chon"] == true).forEach((element) {
      element["chon"] = false;
    });
    usercontroller.isChon.value = 0;
    bool one = false;
    if (loai == 0) {
      resetChon(nguoiheodois);
    } else if (loai == 1) {
      resetChon(nguoiquanlys);
    } else if (loai == 2) {
      resetChon(nguoiduyets);
    }
    var rs = await showCupertinoModalBottomSheet(
      context: Get.context!,
      expand: true,
      builder: (context) => ListUserVanBan(one: one),
    );
    if (rs != null) {
      if (loai == 0) {
        nguoiheodois.value = rs;
      } else if (loai == 1) {
        nguoiquanlys.value = rs;
      } else if (loai == 2) {
        nguoiduyets.value = rs;
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
    if (loai == 0) {
      nguoiheodois.removeAt(i);
    } else if (loai == 1) {
      nguoiquanlys.removeAt(i);
    } else if (loai == 2) {
      nguoiduyets.removeAt(i);
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

  void deleteFileDA(i) async {
    try {
      EasyLoading.show(status: "loading...");

      var body = {
        "user_id": Golbal.store.user["user_id"],
        "FileID": filesDA[i]["FileID"],
      };
      String url = "Request/Delete_File";
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

  //Function table
  void addRowInTable(sttrows, heads) {
    int maxr = sttrows[sttrows.length - 1] + 1;
    for (var e in heads) {
      var o = Map.from(e);
      o["STTRow"] = maxr;
      formD.add(o);
    }
    sttrows.add(maxr);
    ctrrows.add(List.castFrom(sttrows));
  }

  //Save Request
  void saveRequest() async {
    try {
      formKey.currentState!.save();
      if (upload.value == true) {
        EasyLoading.showToast(
            "Đang cập nhật đề xuất, bạn vui lòng thao tác chậm lại!");
        return;
      }
      if (model["Team_ID"] == null) {
        EasyLoading.showError("Vui lòng chọn Team lập đề xuất!");
        return;
      }
      upload.value = true;
      if (formKey.currentState!.validate()) {
        formKey.currentState!.save();
        EasyLoading.show(status: 'Đang cập nhật...');

        var obj = model;
        if (obj["Ngaylap"] is DateTime) {
          obj["Ngaylap"] = obj["Ngaylap"].toIso8601String();
        }
        if (obj["Dateline"] is DateTime) {
          obj["Dateline"] = obj["Dateline"].toIso8601String();
        }

        var fds = formD;
        if (fds.isNotEmpty) {
          for (var r in fds
              .where((e) =>
                  e["KieuTruong"] == "date" || e["KieuTruong"] == "datetime")
              .toList()) {
            if (r["IsGiatri"] is DateTime) {
              r["IsGiatri"] = r["IsGiatri"].toIso8601String();
            }
          }
          for (var r in fds.where((e) => e["KieuTruong"] == "radio").toList()) {
            if (r["FormD_ID"] == obj["radio"]) {
              r["IsGiatri"] = true;
            } else {
              r["IsGiatri"] = false;
            }
          }
          for (var r
              in fds.where((e) => e["KieuTruong"] == "checkbox").toList()) {
            r["IsGiatri"] = obj["checkbox${r["FormD_ID"]}"] ?? false;
          }
        }

        List nds = nguoiduyets.map((e) => e["NhanSu_ID"]).toSet().toList();
        List qls = nguoiquanlys.map((e) => e["NhanSu_ID"]).toSet().toList();
        List tds = nguoiheodois.map((e) => e["NhanSu_ID"]).toSet().toList();

        if (model["Form_ID"] == null && nds.isEmpty) {
          upload.value = false;
          EasyLoading.showError("Vui lòng chọn người duyệt đề xuất!");
          return;
        }

        var models = {
          "user_id": Golbal.store.user["user_id"],
          "request": obj,
          "formD": fds,
          "duyets": nds,
          "quanlys": qls,
          "theodois": tds,
        };
        var strmodels = json.encode(models);

        var fs = [];
        for (var fi in files.value) {
          if (kIsWeb) {
            fs.add(dioform.MultipartFile.fromBytes(fi.bytes!,
                filename: fi.path!.split('/').last));
          } else {
            fs.add(dioform.MultipartFile.fromFileSync(fi.path!,
                filename: fi.path!.split('/').last));
          }
        }

        dioform.FormData formData = dioform.FormData.fromMap({
          "models": strmodels,
          "files": fs,
        });
        Dio dio = Dio();
        dio.options.headers["Authorization"] = "Bearer ${Golbal.store.token}";
        dio.options.followRedirects = true;
        var response = await dio.put(
            "${Golbal.congty!.api}/api/Request/Update_Request",
            data: formData);
        var data = response.data;

        if (data["err"] == "1") {
          upload.value = false;
          EasyLoading.dismiss();
          EasyLoading.showError("Có lỗi xảy ra, vui lòng thử lại!");
          return;
        }
        Get.back(result: true);
        upload.value = false;
        EasyLoading.dismiss();
      } else {
        upload.value = false;
        EasyLoading.showError(
            "Vui lòng nhập đầy đủ thông tin của phiếu đề xuất!");
        return;
      }
    } catch (e) {
      upload.value = false;
      EasyLoading.dismiss();
      if (kDebugMode) {
        print(e);
      }
    }
  }

  @override
  void onInit() {
    super.onInit();
    getdata.value = Get.arguments;
    initData();
  }

  void initData() {
    if (getdata["RequestMaster_ID"] != null) {
      model.value = {};
      initModel();
      getRequest(true);
    } else {
      loading.value = false;
      model.value = {
        "Congty_ID": Golbal.congty!.congtyID.toString(),
        "Form_ID": null,
        "Form_Name": "Đề xuất trực tiếp",
        "IsQuytrinhduyet": 1,
        "QT_Name": "Duyệt tuần tự",
        "IsEdit": true,
        "Uutien": 0,
        "TenUutien": "Bình thường",
        "IsChangedQT": false,
        "Trangthai": 0,
        "IsDelete": false,
        "Ngaylap": DateTime.now(),
        "Dateline": DateTime.now(),
        "STT": getdata["STT"],
      };
      initModel();
      loadForm();
    }
  }

  void getRequest(f) async {
    try {
      if (f) {
        loading.value = true;
        EasyLoading.show(status: "loading...");
      }
      var body = {
        "user_id": Golbal.store.user["user_id"],
        "RequestMaster_ID": getdata["RequestMaster_ID"],
      };
      String url = "Request/Request_Edit";
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
        if (model["Ngaylap"] != null && model["Ngaylap"] != "") {
          model["Ngaylap"] = DateTime.parse(model["Ngaylap"]);
        } else {
          model["Ngaylap"] = DateTime.now();
        }
        loadSignUser();
      }
      nguoiquanlys.value = List.castFrom(tbs[2]).toList();
      nguoiduyets.value = List.castFrom(tbs[3]).toList();
      nguoiheodois.value = List.castFrom(tbs[4]).toList();
      filesDA.value = tbs[1];
      formD.value = List.castFrom(tbs[5]).toList();
      for (var f in formD) {
        if (f["KieuTruong"] == "radio" || f["KieuTruong"] == "checkbox") {
          if (f["IsGiatri"] == "True") {
            f["IsGiatri"] = true;
          } else if (f["IsGiatri"] == "False") {
            f["IsGiatri"] = false;
          }
          model["${f["KieuTruong"]}${f["FormD_ID"]}"] = f["IsGiatri"];
        }

        var fds =
            formD.where((e) => e["IsParent_ID"] == f["FormD_ID"]).toList();
        if (fds.isNotEmpty) {
          List heads = fds.where((x) => x["STTRow"] == null).toList();
          List rows = fds.where((x) => x["STTRow"] != null).toList();
          if (rows.isEmpty && heads.isNotEmpty) {
            for (var e in heads) {
              var o = Map.from(e);
              o["STTRow"] = 0;
              formD.add(o);
            }
          }
        }
      }
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

  void initModel() async {
    if (getdata["dictionarys"] != null) {
      dictionarys["mucdodxs"] = [
        {"Uutien": 0, "text": "Bình thường"},
        {"Uutien": 1, "text": "Gấp"},
        {"Uutien": 2, "text": "Rất gấp"},
      ];

      if (getdata["dictionarys"][1].isNotEmpty) {
        teamdxs.value = getdata["dictionarys"][1];
        dictionarys["teamdxs"] = getdata["dictionarys"][1];

        for (var t in List.castFrom(dictionarys["teamdxs"])
            .where((e) => e["chon"] == true)
            .toList()) {
          t["chon"] = false;
        }
      } else {
        teamdxs.value = [];
        dictionarys["teamdxs"] = [];
      }

      if (getdata["dictionarys"][2].isNotEmpty) {
        loaidxs.value = getdata["dictionarys"][2];
        dictionarys["loaidxs"] = getdata["dictionarys"][2];

        for (var t in List.castFrom(dictionarys["loaidxs"])
            .where((e) => e["chon"] == true)
            .toList()) {
          t["chon"] = false;
        }
      } else {
        loaidxs.value = [];
        dictionarys["loaidxs"] = [];
      }
    } else {
      teamdxs.value = [];
      dictionarys["teamdxs"] = [];
      loaidxs.value = [];
      dictionarys["loaidxs"] = [];
    }

    List forms = getdata["dictionarys"] != null
        ? List.castFrom(getdata["dictionarys"][2])
        : [];
    List teams =
        getdata["dictionarys"] != null ? getdata["dictionarys"][1] : [];
    if (getdata["RequestMaster_ID"] == null &&
        forms.isNotEmpty &&
        teams.isNotEmpty) {
      model["Team_ID"] = teams[0]["Team_ID"];
      model["Team_Name"] = teams[0]["Team_Name"];
    }
  }

  void loadForm() async {
    try {
      var body = {
        "Form_ID": model["Form_ID"],
      };
      String url = "Request/Get_FormD";
      Dio dio = Dio();
      dio.options.headers["Authorization"] = "Bearer ${Golbal.store.token}";
      dio.options.followRedirects = true;
      var response =
          await dio.post("${Golbal.congty!.api}/api/$url", data: body);
      var data = response.data;
      if (data != null) {
        var tbs = List.castFrom(json.decode(data["data"]));
        if (tbs[0].isNotEmpty) {
          form.value = tbs[0][0];
        }
        formD.value = tbs[1];
        for (var f in formD) {
          var fds =
              formD.where((e) => e["IsParent_ID"] == f["FormD_ID"]).toList();
          if (fds.isNotEmpty) {
            List heads = fds.where((x) => x["STTRow"] == null).toList();
            List rows = fds.where((x) => x["STTRow"] != null).toList();
            if (rows.isEmpty && heads.isNotEmpty) {
              for (var e in heads) {
                var o = Map.from(e);
                o["STTRow"] = 0;
                formD.add(o);
              }
            }
          }
        }
      } else {
        formD.value = [];
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  void loadSignUser() async {
    nguoiheodois.value = [];

    try {
      var body = {
        "Form_ID": model["Form_ID"],
        "Team_ID": model["Team_ID"],
      };
      String url = "Request/Get_SignUser";
      Dio dio = Dio();
      dio.options.headers["Authorization"] = "Bearer ${Golbal.store.token}";
      dio.options.followRedirects = true;
      var response =
          await dio.post("${Golbal.congty!.api}/api/$url", data: body);
      var data = response.data;
      if (data != null) {
        var tbs = List.castFrom(json.decode(data["data"]))[0];
        if (tbs.isNotEmpty) {
          for (var r in tbs) {
            if (r["users"] != null) {
              r["users"] = json.decode(r["users"]);
            }
          }
          var fd = model["Ngaylap"];
          if (fd is DateTime) {
          } else {
            fd = DateTime.parse(fd);
          }
          var cs = 0;
          for (var si in tbs) {
            if (si["users"] != null) {
              nguoiheodois.addAll(
                  si["users"].where((a) => a["IsType"] == "3").toList());
              si["users"] =
                  si["users"].where((a) => a["IsType"] != "3").toList();
              int csi = si["users"]
                  .where((a) => a["IsType"] != "4" && a["IsType"] != "3")
                  .length;
              if (si["IsTypeDuyet"] == 0) {
                if (csi > 0) csi = 1;
              }
              cs += csi;
            }
          }

          signusers.value = tbs;
          model["IsSLA"] = cs * calcranks((model["IsSLA"] ?? 8));
          model["Dateline"] =
              fd.add(Duration(minutes: calcranks((model["IsSLA"] ?? 8) * 60)));
        } else {
          signusers.value = [];
        }
      } else {
        signusers.value = [];
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }
}
