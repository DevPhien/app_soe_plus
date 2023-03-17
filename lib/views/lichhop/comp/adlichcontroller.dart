import 'dart:convert';

import 'package:dio/dio.dart' as dioform;
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:soe/views/component/phongban/listphongban.dart';
import 'package:soe/views/component/phongban/phongbancontroller.dart';

import '../../../../utils/golbal/golbal.dart';
import '../../vanban/comp/listuser.dart';
import '../../vanban/controller/uservanbancontroller.dart';

class AddLichController extends GetxController {
  final UserVBController usercontroller = Get.put(UserVBController());
  final PhongbanController phongbancontroller = Get.put(PhongbanController());
  var loading = true.obs;
  var isload = false.obs;
  var getdata = {}.obs;
  final formKey = GlobalKey<FormState>();
  var year = (DateTime.now().year).obs;

  var model = {}.obs;
  var chutris = [].obs;
  var thamgias = [].obs;
  var phongbans = [].obs;

  var phonghops = [].obs;
  var kieulaps = [].obs;

  var dictionarys = {};
  Rx<List<PlatformFile>> files = Rx<List<PlatformFile>>([]);
  var filesDA = [].obs;

  //Declare
  String datetimeString(dd) {
    if (dd is DateTime) {
      return dd.toIso8601String();
    }
    return dd ?? "";
  }

  void setValue(key, value) {
    model[key] = value;
  }

  //Function form
  void defaultDataChon(RxList<dynamic> dts, String id, String key) {
    var index = dts.indexWhere((e) => e[id] == model[key]);
    if (index != -1) {
      dts[index]["chon"] = true;
    }
  }

  void showModalCategory(String title, datas, String dictionary, String id,
      String name, String key, bool isOne, bool isSearch) {
    FocusScope.of(Get.context!).unfocus();
    showCupertinoModalBottomSheet(
      context: Get.context!,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.8,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(title,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20)),
                    InkWell(
                        onTap: Get.back,
                        child: const Icon(Ionicons.close_circle_outline,
                            size: 32, color: Colors.black87))
                  ]),
            ),
            if (isSearch) ...[
              const SizedBox(height: 10),
              Container(
                width: double.infinity,
                height: 40,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: const Color(0xFFf9f8f8),
                    border:
                        Border.all(color: const Color(0xffeeeeee), width: 1.0)),
                child: Center(
                  child: TextField(
                    onSubmitted: (String txt) {
                      searchData(txt, datas, dictionary, name);
                    },
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.all(5),
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      border: InputBorder.none,
                      hintText: 'Tìm kiếm',
                      prefixIcon: Icon(Icons.search),
                    ),
                  ),
                ),
              ),
            ],
            const SizedBox(height: 10),
            Expanded(
              child: Obx(() => ListView.separated(
                    shrinkWrap: true,
                    itemBuilder: (ct, i) {
                      return Material(
                          color: Colors.transparent,
                          child: ListTile(
                            onTap: () {
                              chooseFilter(datas, i, name, key, isOne);
                            },
                            title: Text(datas[i][name] ?? "",
                                style: const TextStyle(
                                    fontWeight: FontWeight.normal)),
                            trailing: datas[i]["chon"] == true
                                ? Icon(Feather.check, color: Golbal.appColor)
                                : null,
                          ));
                    },
                    itemCount: datas.length,
                    separatorBuilder: (ct, i) => const Divider(height: 1),
                  )),
            ),
          ],
        ),
      ),
    );
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

  //Function
  DateTime? cvDate(dynamic sdate) {
    if (sdate is DateTime) return sdate;
    if (sdate == null) return DateTime.now();
    try {
      return DateTime.parse(sdate);
    } catch (e) {
      return DateTime.now();
    }
  }

  Future<void> showUser(int loai) async {
    usercontroller.users.where((p0) => p0["chon"] == true).forEach((element) {
      element["chon"] = false;
    });
    usercontroller.groupusers
        .where((p0) => p0["chon"] == true)
        .forEach((element) {
      element["chon"] = false;
    });
    usercontroller.isChon.value = 0;
    bool one = false;
    if (loai == 1) {
      one = true;
      resetChonUser(chutris);
    } else if (loai == 2) {
      resetChonUser(thamgias);
    }

    var rs = await showCupertinoModalBottomSheet(
      context: Get.context!,
      expand: true,
      builder: (context) => ListUserVanBan(one: one),
    );
    if (rs != null) {
      if (loai == 1) {
        chutris.value = rs;
      } else if (loai == 2) {
        thamgias.value = rs;
      }
      model["Songuoithamdu"] = (chutris.length + thamgias.length);
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

  Future<void> saveCalendar() async {
    try {
      formKey.currentState!.save();
      if (isload.value == true) {
        EasyLoading.showToast(
            "Đang cập nhật lịch họp, bạn vui lòng thao tác chậm lại!");
        return;
      }
      if (model["Diadiem_ID"] == null) {
        EasyLoading.showError("Vui lòng chọn chọn địa điểm họp!");
        return;
      }
      isload.value = true;
      if (formKey.currentState!.validate()) {
        formKey.currentState!.save();
        EasyLoading.show(status: 'Đang cập nhật...');
        var obj = model;
        if (obj["Ngaytao"] is DateTime) {
          obj["Ngaytao"] = obj["Ngaytao"].toIso8601String();
        }
        if (obj["Songuoithamdu"] != null && obj["Songuoithamdu"] != "") {
          obj["Songuoithamdu"] = int.parse(obj["Songuoithamdu"]);
        } else {
          obj["Songuoithamdu"] = 0;
        }
        if (obj["Laplich"] != null && obj["Laplich"] != 0) {
          if (obj["Solap"] != null && obj["Solap"] != "") {
            obj["Solap"] = int.parse(obj["Solap"]);
          } else {
            obj["Solap"] = 1;
          }
          if (obj["Solanlap"] != null && obj["Solanlap"] != "") {
            obj["Solanlap"] = int.parse(obj["Solanlap"]);
          } else {
            obj["Solanlap"] = 0;
          }
        }

        Map<String, dynamic> mdata = {
          "models": json.encode({
            "user_id": Golbal.store.user["user_id"],
            "calendar": obj,
            "chutris": chutris.map((e) => e["NhanSu_ID"]).toList(),
            "thamgias": thamgias.map((e) => e["NhanSu_ID"]).toList(),
            "phongbans": phongbans.map((e) => e["Phongban_ID"]).toList(),
          })
        };
        var ffiles = [];
        for (var fi in files.value) {
          if (kIsWeb) {
            ffiles.add(dioform.MultipartFile.fromBytes(fi.bytes!,
                filename: fi.path!.split('/').last));
          } else {
            ffiles.add(dioform.MultipartFile.fromFileSync(fi.path!,
                filename: fi.path!.split('/').last));
          }
        }
        mdata["files"] = ffiles;
        dioform.FormData formData = dioform.FormData.fromMap(mdata);
        Dio dio = Dio();
        dio.options.headers["Authorization"] = "Bearer ${Golbal.store.token}";
        dio.options.followRedirects = true;
        var response = await dio.put(
            "${Golbal.congty!.api}/api/Calendar/Update_Calendar",
            data: formData);
        var data = response.data;
        isload.value = false;
        EasyLoading.dismiss();
        if (data["err"] == "1") {
          EasyLoading.showError("Có lỗi xảy ra, vui lòng thử lại!");
          return;
        }
        Get.back(result: true);
      } else {
        isload.value = false;
        EasyLoading.showError("Vui lòng nhập đầy đủ thông tin của lịch họp!");
        return;
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
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

  void chonFilter(RxList<dynamic> dts, int idx, bool isOne, id) {
    if (dts[idx]["chon"] == null) {
      dts[idx]["chon"] = true;
    } else {
      dts[idx]["chon"] = !dts[idx]["chon"];
    }
    dts.refresh();
    if (isOne) {
      Get.back(result: dts[idx][id]);
    }
  }

  void resetChonUser(List users) {
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
      phongbans.removeAt(i);
    }
  }

  void delePhongban(int i, int loai) {
    if (loai == 1) {
      chutris.removeAt(i);
    } else if (loai == 2) {
      thamgias.removeAt(i);
    }
  }

  void deleteFileDA(i) async {
    try {
      EasyLoading.show(status: "loading...");

      var body = {
        "user_id": Golbal.store.user["user_id"],
        "LichhopFile_ID": filesDA[i]["LichhopFile_ID"],
      };
      String url = "Calendar/Delete_File";
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

  //init
  @override
  void onInit() {
    super.onInit();
    getdata.value = Get.arguments;
    initData();
  }

  void initData() {
    initDictionary();
    if (getdata["LichhopTuan_ID"] != null) {
      getCalendar(true);
    } else {
      model["IsImportant"] = true;
      model["IsDeadline"] = true;
      model["Uutien"] = true;
      model["IsCheck"] = false;
      model["IsDelete"] = false;
      model["IsTodo"] = false;
      model["Trangthai"] = 0;
      model["STT"] = 1;
      model["Trongso"] = 2;
      model["CongviecID"] = -1;
      model["Congty_ID"] = Golbal.store.user["organization_id"];
      chutris.add({
        "NhanSu_ID": Golbal.store.user["user_id"],
        "anhThumb": Golbal.store.user["Avartar"],
        "fullName": Golbal.store.user["FullName"],
        "ten": Golbal.store.user["fname"],
      });
    }
  }

  void getCalendar(f) async {
    try {
      if (f) {
        loading.value = true;
        EasyLoading.show(status: "loading...");
      }
      Dio dio = Dio();
      dio.options.headers["Authorization"] = "Bearer ${Golbal.store.token}";
      dio.options.followRedirects = true;
      var response = await dio
          .post("${Golbal.congty!.api}/api/Calendar/Get_CalendarByID", data: {
        "LichhopTuan_ID": getdata["LichhopTuan_ID"],
        "user_id": Golbal.store.user["user_id"]
      });
      var data = response.data;
      if (data != null) {
        var tbs = List.castFrom(json.decode(data["data"]));
        if (tbs.isNotEmpty) {
          for (var element in tbs) {
            if (element["nguoithamdus"] != null) {
              element["nguoithamdus"] = json.decode(element["nguoithamdus"]);
            }
            if (element["phongbans"] != null) {
              element["phongbans"] = json.decode(element["phongbans"]);
              phongbans.value = element["phongbans"];
            }
            if (element["files"] != null) {
              element["files"] = json.decode(element["files"]);
              filesDA.value = element["files"];
            }
          }
          model.value = tbs[0];

          if (model["Chutri"] != null && model["Chutri"] != "") {
            chutris.value = [
              {
                "NhanSu_ID": model["Chutri"],
                "fullName": model["Chutri_FullName"],
                "ten": model["Chutri_Ten"],
                "anhThumb": model["Chutri_Thumb"],
              }
            ];
          }
          if (model["nguoithamdus"].isNotEmpty) {
            for (var td in model["nguoithamdus"]) {
              var obj = {
                "NhanSu_ID": td["Nguoithamdu_ID"],
                "fullName": td["fullName"],
                "ten": td["ten"],
                "anhThumb": td["anhThumb"],
              };
              thamgias.add(obj);
            }
          }

          model["Songuoithamdu"] = (chutris.length + thamgias.length);
          model["Laplich_Ten"] = kieulaps.firstWhere(
              (e) => e["Laplich"] == model["Laplich"],
              orElse: () => {"Laplich_Ten": ""})["Laplich_Ten"];
        }
        if (loading.value) loading.value = false;
      }
      EasyLoading.dismiss();
    } catch (e) {
      if (loading.value) loading.value = false;
      EasyLoading.dismiss();
      if (kDebugMode) {
        print(e);
      }
    }
  }

  void initDictionary() async {
    if (getdata["dictionarys"] != null) {
      if (getdata["dictionarys"][0].isNotEmpty) {
        phonghops.value = getdata["dictionarys"][0];
        dictionarys["phonghops"] = getdata["dictionarys"][0];

        for (var t in List.castFrom(dictionarys["phonghops"])
            .where((e) => e["chon"] == true)
            .toList()) {
          t["chon"] = false;
        }
      } else {
        phonghops.value = [];
        dictionarys["phonghops"] = [];
      }

      if (getdata["dictionarys"][1].isNotEmpty) {
        kieulaps.value = getdata["dictionarys"][1];
        dictionarys["kieulaps"] = getdata["dictionarys"][1];

        for (var t in List.castFrom(dictionarys["kieulaps"])
            .where((e) => e["chon"] == true)
            .toList()) {
          t["chon"] = false;
        }
      } else {
        kieulaps.value = [];
        dictionarys["kieulaps"] = [];
      }
    } else {
      phonghops.value = [];
      dictionarys["phonghops"] = [];
      kieulaps.value = [];
      dictionarys["kieulaps"] = [];
    }
  }
}
