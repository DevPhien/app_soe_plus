import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:dio/dio.dart' as dioform;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:local_auth/local_auth.dart';
import 'package:sliding_sheet/sliding_sheet.dart';
import 'package:soe/utils/golbal/golbal.dart';
import 'package:soe/views/component/dialog.dart';
import 'package:soe/views/request/controller/requestcontroller.dart';
import 'package:sweetsheet/sweetsheet.dart';

class DetailRequestController extends GetxController {
  final RequestController controller = Get.put(RequestController());
  StreamController<List<int>> ctrrows = StreamController<List<int>>.broadcast();
  final LocalAuthentication auth = LocalAuthentication();
  ScrollController scrollController = ScrollController();
  final sheetCtr = SheetController();
  final SweetSheet _sweetSheet = SweetSheet();
  final ImagePicker _picker = ImagePicker();
  //Declare
  var loading = true.obs;
  var sendding = true.obs;
  var request = {}.obs;
  var formD = [].obs;
  var files = [].obs;
  var showInputComment = true.obs;
  var connected_datas = [].obs;
  RxBool isview = true.obs;
  Rx<List<PlatformFile>> filesDA = Rx<List<PlatformFile>>([]);
  Rx<List> imagesDA = Rx<List>([]);

  dismissKeybroad(context) {
    FocusScope.of(context).requestFocus(FocusNode());
  }

  void scrollBottom() {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void goBack(isdel) {
    //Navigator.of(context).pop();
    Get.back(result: {"request": request, "isdel": isdel});
  }

  Future<void> goAtivity() async {
    var rs = await Get.toNamed("activityrequest", arguments: request);
    return;
  }

  //Function form
  void setValue(key, value) {
    request[key] = value;
  }

  String datetimeString(dd) {
    if (dd is DateTime) {
      return dd.toIso8601String();
    }
    return dd ?? "";
  }

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

  //Function
  void moreAction(context) {
    List<Widget> list = [];
    // if (request["IsEdit"] == true) {
    //   list.add(ListTile(
    //     leading: const Icon(
    //       MaterialCommunityIcons.account_check_outline,
    //     ),
    //     onTap: () {
    //       Navigator.of(context).pop();
    //       //editMessage(context, message);
    //     },
    //     title: const Text("Cập nhật mức độ ưu tiên"),
    //   ));
    // }
    // list.add(ListTile(
    //   leading: const Icon(
    //     Feather.folder,
    //   ),
    //   onTap: () {
    //     Navigator.of(context).pop();
    //     //editMessage(context, message);
    //   },
    //   title: const Text("Quản lý tài liệu"),
    // ));
    list.add(ListTile(
      leading: const Icon(
        Feather.clock,
      ),
      onTap: () {
        Navigator.of(context).pop();
        goAtivity();
      },
      title: const Text("Hoạt động"),
    ));
    if (request["IsTao"] == true && request["IsFun"] == true) {
      list.add(ListTile(
        leading: const Icon(
          Feather.edit,
        ),
        onTap: () {
          Navigator.of(context).pop();
          openEditRequest(context);
        },
        title: const Text("Chỉnh sửa"),
      ));
      list.add(ListTile(
        leading: const Icon(
          Feather.trash,
        ),
        onTap: () {
          Navigator.of(context).pop();
          deleteRequest(context);
        },
        title: const Text("Xoá"),
      ));
    }
    showSlidingBottomSheet(context, builder: (context) {
      return SlidingSheetDialog(
        headerBuilder: (c, s) => Material(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  margin: const EdgeInsets.only(top: 10.0),
                  width: 40,
                  height: 5,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color: const Color(0xFFdddddd),
                  ),
                ),
              ],
            ),
          ),
        ),
        controller: sheetCtr,
        elevation: 8,
        cornerRadius: 16,
        listener: (state) {
          if (state.isExpanded) {
            sheetCtr.rebuild();
          }
        },
        snapSpec: const SnapSpec(
          snap: false,
          snappings: [0.7, 0.8, 0.9],
          positioning: SnapPositioning.relativeToAvailableSpace,
        ),
        builder: (context, state) {
          return SizedBox(
            height: MediaQuery.of(context).size.height * 0.9,
            child: Material(
              color: Colors.white,
              child: ListView.separated(
                separatorBuilder: (context, i) =>
                    const Divider(height: 1.0, thickness: 1),
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                itemCount: list.length,
                itemBuilder: (context, i) => list[i],
              ),
            ),
          );
        },
      );
    });
  }

  Future<void> openEditRequest(context) async {
    var rs = await Get.toNamed("addrequest", arguments: {
      "title": "Cập nhật đề xuất",
      "RequestMaster_ID": request["RequestMaster_ID"],
      "dictionarys": controller.dictionarys,
    });
    if (rs == true) {
      getRequest(false);
      initFile();
      EasyLoading.showSuccess("Cập nhật thành công");
    }
  }

  Future<void> openFile() async {
    FilePickerResult? result =
        await FilePicker.platform.pickFiles(allowMultiple: true);

    if (result != null) {
      filesDA.value.addAll(result.files);
      filesDA.refresh();
    }
  }

  Future<void> openFileImage() async {
    // FilePickerResult? result = await FilePicker.platform.pickFiles(
    //   type: FileType.custom,
    //   allowMultiple: true,
    //   allowedExtensions: ['jpg', 'png', 'gif', 'jpeg', 'svg'],
    // );

    // if (result != null) {
    //   files.value.addAll(result.files);
    //   files.refresh();
    // }

    List<XFile>? result = [];
    try {
      result = await _picker.pickMultiImage();
    } catch (e) {}

    if (result != null) {
      imagesDA.value += result;
      imagesDA.refresh();
    }
  }

  Widget listFile() {
    return Container(
      color: const Color(0xFFcccccc),
      constraints: const BoxConstraints(maxHeight: 300),
      child: ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: filesDA.value.length,
        itemBuilder: (ct, i) {
          PlatformFile file = filesDA.value[i];
          return Card(
            elevation: 0,
            color: const Color(0xFFf5f5f5),
            child: ListTile(
              leading: Image(
                  image: AssetImage(
                      "assets/file/${file.extension!.replaceAll('.', '')}.png"),
                  width: 24,
                  height: 24,
                  fit: BoxFit.contain),
              title: Text(file.name),
              trailing: SizedBox(
                width: 30,
                child: TextButton(
                    onPressed: () {
                      deleteFile(i);
                    },
                    child: const Icon(
                      Ionicons.trash_outline,
                      color: Colors.black54,
                      size: 16,
                    )),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget listImage() {
    return Container(
      color: const Color(0xFFcccccc),
      constraints: const BoxConstraints(maxHeight: 300),
      child: ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: imagesDA.value.length,
        itemBuilder: (ct, i) {
          XFile file = imagesDA.value[i];
          return Card(
            elevation: 0,
            color: const Color(0xFFf5f5f5),
            child: ListTile(
              leading: Image(
                  image: AssetImage(
                      "assets/file/${file.name.split('.').last}.png"),
                  width: 24,
                  height: 24,
                  fit: BoxFit.contain),
              title: Text(file.name),
              trailing: SizedBox(
                width: 30,
                child: TextButton(
                    onPressed: () {
                      deleteImage(i);
                    },
                    child: const Icon(
                      Ionicons.trash_outline,
                      color: Colors.black54,
                      size: 16,
                    )),
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> openSendRequest(context, String title, int? sign) async {
    if (Golbal.store.settingRequest["IsVerifySign"] == true &&
        (Golbal.store.device == null ||
            Golbal.store.device["Device_ID"] == null)) {
      _sweetSheet.show(
        context: context,
        title: const Text("Thiết bị chưa được đăng ký."),
        description: const Text(
            'Để bảo mật và xác thực khi phê duyệt, vui lòng đăng ký thiết bị.'),
        color: SweetSheetColor.WARNING,
        icon: Icons.portable_wifi_off,
        positive: SweetSheetAction(
          onPressed: () {
            Navigator.of(context).pop();
            goCaidat();
          },
          color: Colors.white,
          title: 'Đăng ký thiết bị',
        ),
        negative: SweetSheetAction(
          onPressed: () {
            Navigator.of(context).pop();
          },
          title: 'Huỷ',
        ),
      );
      return;
    }
    var modelrequest = {
      "IsSign": sign,
      "IsSkip": request["IsSkip"],
      "RequestMaster_ID": request["RequestMaster_ID"]
    };
    sendding.value = false;
    var rs = await Animateddialogbox.showScaleAlertBox(
        context: context,
        firstButton: MaterialButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(40),
          ),
          color: Colors.white,
          height: 36 * Golbal.textScaleFactor,
          child: const Text('Huỷ'),
          padding:
              EdgeInsets.symmetric(horizontal: 40.0 * Golbal.textScaleFactor),
          onPressed: () {
            Navigator.of(context).pop(false);
          },
        ),
        secondButton: MaterialButton(
          // OPTIONAL BUTTON
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(40),
          ),
          color: sign == null || sign == 1
              ? Golbal.appColor
              : sign == 2
                  ? const Color(0xFF4caf50)
                  : sign == 3
                      ? Colors.orange
                      : const Color(0xFFf44336),
          height: 36 * Golbal.textScaleFactor,
          padding:
              EdgeInsets.symmetric(horizontal: 20.0 * Golbal.textScaleFactor),
          child: Text(title, style: const TextStyle(color: Colors.white)),
          onPressed: () {
            Navigator.of(context).pop(true);
          },
        ),
        icon: Container(width: 0.0), // IF YOU WANT TO ADD ICON
        yourWidget: StatefulBuilder(builder: (context, setState) {
          return Container(
            width: double.maxFinite,
            constraints: BoxConstraints(
              maxHeight: Golbal.screenSize.height * 0.8,
              maxWidth: 720,
            ),
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        "$title đề xuất",
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          IconButton(
                            icon: const Icon(Feather.image,
                                color: Colors.black38),
                            onPressed: () {
                              openFileImage();
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.attach_file,
                                color: Colors.black38),
                            onPressed: () {
                              openFile();
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 10.0),
                  Container(
                    constraints: const BoxConstraints(
                      maxHeight: 250.0,
                    ),
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      //reverse: true,
                      child: TextField(
                        keyboardAppearance: Brightness.light,
                        textInputAction: TextInputAction.newline,
                        maxLines: null,
                        minLines: Golbal.screenSize.width > 720 ? 8 : 5,
                        onChanged: (String txt) {
                          modelrequest["Noidung"] = txt;
                        },
                        decoration: const InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Color(0xFFdddddd)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Color(0xFFdddddd)),
                          ),
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 15.0),
                          filled: true,
                          fillColor: Colors.white,
                          hintText: 'Nội dung',
                          hintStyle: TextStyle(fontSize: 13.0),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  Obx(() => listImage()),
                  Obx(() => listFile()),
                ],
              ),
            ),
          );
        }));
    if (rs == true) {
      sendding.value = false;
      if (sign == 3) {
        eviction(context, modelrequest);
      } else {
        sendRequest(context, modelrequest, title: title);
      }
    } else {
      filesDA.value = [];
    }
  }

  Future<void> openUpdateXLRequest(context, String title, int tt,
      {bool? IsDG}) async {
    if (Golbal.store.settingRequest["IsVerifySign"] == true &&
        (Golbal.store.device == null ||
            Golbal.store.device["Device_ID"] == null)) {
      _sweetSheet.show(
        context: context,
        title: const Text("Thiết bị chưa được đăng ký."),
        description: const Text(
            'Để bảo mật và xác thực khi phê duyệt, vui lòng đăng ký thiết bị.'),
        color: SweetSheetColor.WARNING,
        icon: Icons.portable_wifi_off,
        positive: SweetSheetAction(
          onPressed: () {
            Navigator.of(context).pop();
            goCaidat();
          },
          color: Colors.white,
          title: 'Đăng ký thiết bị',
        ),
        negative: SweetSheetAction(
          onPressed: () {
            Navigator.of(context).pop();
          },
          title: 'Huỷ',
        ),
      );
      return;
    }
    var modelrequest = {
      "tt": tt,
      "RequestMaster_ID": request["RequestMaster_ID"],
      "point": 0.0,
    };
    sendding.value = false;
    var rs = await Animateddialogbox.showScaleAlertBox(
        context: context,
        firstButton: MaterialButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(40),
          ),
          color: Colors.white,
          height: 36 * Golbal.textScaleFactor,
          child: const Text('Huỷ'),
          padding:
              EdgeInsets.symmetric(horizontal: 40.0 * Golbal.textScaleFactor),
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
          height: 36 * Golbal.textScaleFactor,
          padding:
              EdgeInsets.symmetric(horizontal: 20.0 * Golbal.textScaleFactor),
          child: Text(title, style: const TextStyle(color: Colors.white)),
          onPressed: () {
            Navigator.of(context).pop(true);
          },
        ),
        icon: Container(width: 0.0), // IF YOU WANT TO ADD ICON
        yourWidget: StatefulBuilder(builder: (context, setState) {
          return Container(
            width: double.maxFinite,
            constraints: BoxConstraints(
                maxHeight: Golbal.screenSize.height * 0.8, maxWidth: 720),
            child: SingleChildScrollView(
                child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    const Spacer(),
                    Text(
                      "$title đề xuất",
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const Spacer(),
                  ],
                ),
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
                              minLines: Golbal.screenSize.width > 720 ? 8 : 5,
                              onChanged: (String txt) {
                                modelrequest["Noidung"] = txt;
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
                                hintText: 'Nội dung',
                                hintStyle: TextStyle(fontSize: 13.0),
                              ),
                            ))
                      ],
                    )),
                const SizedBox(height: 10.0),
                if (IsDG == true) ...[
                  RatingBar.builder(
                    initialRating: modelrequest["point"],
                    minRating: 1,
                    direction: Axis.horizontal,
                    allowHalfRating: true,
                    itemCount: 5,
                    //itemSize: 20,
                    itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                    itemBuilder: (context, _) => const Icon(
                      Icons.star,
                      color: Colors.amber,
                    ),
                    onRatingUpdate: (v) {},
                  ),
                ],
              ],
            )),
          );
        }));
    if (rs == true) {
      sendding.value = false;
      updateXLRequest(context, modelrequest);
    } else {
      filesDA.value = [];
      imagesDA.value = [];
    }
  }

  Future<void> updateXLRequest(context, rq) async {
    if (Golbal.store.settingRequest["IsVerifySign"] == true &&
        Golbal.store.device != null &&
        Golbal.store.device["IsVerifySign"] != 0) {
      bool canCheckBiometrics = await auth.canCheckBiometrics;
      if (canCheckBiometrics == false) {
        EasyLoading.showError("Xác thực không thành công, vui lòng thử lại!");
        return;
      }

      var authenticated = await auth.authenticate(
        localizedReason: 'Vui lòng sử dụng vân tay để xác thực ký.',
        options: const AuthenticationOptions(
          useErrorDialogs: true,
          stickyAuth: true,
          //biometricOnly: true,
        ),
      );
      if (authenticated == false) {
        EasyLoading.showError("Xác thực không thành công, vui lòng thử lại!");
        return;
      }
    }
    if (sendding.value == true) {
      return;
    }
    sendding.value = true;
    try {
      EasyLoading.show(status: "loading...");
      var body = {
        "user_id": Golbal.store.user["user_id"],
        "RequestMaster_ID": rq["RequestMaster_ID"],
        "point": rq["point"],
        "Noidung": rq["Noidung"],
        "tt": rq["tt"],
      };
      Dio dio = Dio();
      dio.options.headers["Authorization"] = "Bearer ${Golbal.store.token}";
      dio.options.followRedirects = true;
      String url = "Request/UpdateXL_Request";
      if (request["TrangthaiXL"] != 3 &&
          request["Trangthai"] == 2 &&
          request["IsTao"] == true) {
        url = "Request/Danhgia_Request";
      }
      var response =
          await dio.put("${Golbal.congty!.api}/api/$url", data: body);
      var data = response.data;
      if (data["err"] == "1") {
        _sweetSheet.show(
          context: context,
          title: const Text("Không thể ký"),
          description: Text('${data["ms"]}'),
          color: SweetSheetColor.WARNING,
          icon: Icons.portable_wifi_off,
          positive: SweetSheetAction(
            onPressed: () {
              Navigator.of(context).pop();
              goCaidat();
            },
            color: Colors.white,
            title: 'Đăng ký thiết bị',
          ),
          negative: SweetSheetAction(
            onPressed: () {
              Navigator.of(context).pop();
            },
            title: 'Huỷ',
          ),
        );
      }
      dismissKeybroad(context);
      getRequest(false);

      sendding.value = false;
      EasyLoading.showSuccess("Cập nhật thành công");
    } catch (e) {
      sendding.value = false;
      EasyLoading.dismiss();
      if (kDebugMode) {
        print(e);
      }
    }
  }

  Future<void> cancelRequest(context) async {
    showDialog(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text("Bạn có muốn trả lại Đề xuất này không?"),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Có'),
              onPressed: () async {
                Navigator.of(context).pop();
                try {
                  EasyLoading.show(status: "loading...");
                  var body = {
                    "user_id": Golbal.store.user["user_id"],
                    "ids": [request["RequestMaster_ID"]],
                    "Noidung": null,
                  };
                  Dio dio = Dio();
                  dio.options.headers["Authorization"] =
                      "Bearer ${Golbal.store.token}";
                  dio.options.followRedirects = true;
                  var response = await dio.put(
                      "${Golbal.congty!.api}/api/Request/Cancel_Request",
                      data: body);
                  var data = response.data;
                  if (data["err"] == "1") {
                    EasyLoading.showToast("Có lỗi xảy ra, vui lòng thử lại!");
                    return;
                  }
                  EasyLoading.showSuccess("Trả lại thành công");
                } catch (e) {
                  EasyLoading.dismiss();
                  if (kDebugMode) {
                    print(e);
                  }
                }
              },
            ),
            TextButton(
              child: const Text('Không'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        );
      },
    );
  }

  Future<void> deleteRequest(context) async {
    showDialog(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text("Bạn có muốn xoá Đề xuất này không?"),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Có'),
              onPressed: () async {
                Navigator.of(context).pop();
                try {
                  EasyLoading.show(status: "loading...");
                  var body = {
                    "user_id": Golbal.store.user["user_id"],
                    "ids": [request["RequestMaster_ID"]],
                  };
                  Dio dio = Dio();
                  dio.options.headers["Authorization"] =
                      "Bearer ${Golbal.store.token}";
                  dio.options.followRedirects = true;
                  var response = await dio.put(
                      "${Golbal.congty!.api}/api/Request/Delete_Request",
                      data: body);
                  var data = response.data;
                  if (data["err"] == "1") {
                    EasyLoading.showToast("Có lỗi xảy ra, vui lòng thử lại!");
                    return;
                  }
                  goBack(true);
                } catch (e) {
                  EasyLoading.dismiss();
                  if (kDebugMode) {
                    print(e);
                  }
                }
              },
            ),
            TextButton(
              child: const Text('Không'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        );
      },
    );
  }

  void deleteFile(i) {
    filesDA.value.removeAt(i);
    filesDA.refresh();
  }

  void deleteImage(i) {
    imagesDA.value.removeAt(i);
    imagesDA.refresh();
  }

  void goCaidat() {}

  void taojob() {
    EasyLoading.showToast("Chức năng đang được cập nhật");
    return;
  }

  void eviction(context, request) async {
    try {
      sendding.value = true;
      EasyLoading.show(status: "loading...");
      var body = {
        "user_id": Golbal.store.user["user_id"],
        "ids": [request["RequestMaster_ID"]],
        "Noidung": request["Noidung"],
      };
      Dio dio = Dio();
      dio.options.headers["Authorization"] = "Bearer ${Golbal.store.token}";
      dio.options.followRedirects = true;
      var response = await dio.put(
          "${Golbal.congty!.api}/api/Request/RollBack_Request",
          data: body);
      var data = response.data;
      if (data["err"] == "1") {
        EasyLoading.showToast("Có lỗi xảy ra, vui lòng thử lại!");
        return;
      }

      dismissKeybroad(context);
      getRequest(false);

      sendding.value = false;
      EasyLoading.showSuccess("Thu hồi thành công");
    } catch (e) {
      sendding.value = false;
      EasyLoading.dismiss();
      if (kDebugMode) {
        print(e);
      }
    }
  }

  void sendRequest(context, request, {String? title}) async {
    if (Golbal.store.settingRequest["IsVerifySign"] == true &&
        Golbal.store.device != null &&
        Golbal.store.device["IsVerifySign"] != 0) {
      bool canCheckBiometrics = await auth.canCheckBiometrics;
      if (canCheckBiometrics == false) {
        EasyLoading.showError("Xác thực không thành công, vui lòng thử lại!");
        return;
      }
      var authenticated = await auth.authenticate(
        localizedReason: 'Vui lòng sử dụng vân tay để xác thực ký.',
        options: const AuthenticationOptions(
          useErrorDialogs: true,
          stickyAuth: true,
          //biometricOnly: true,
        ),
      );
      if (authenticated == false) {
        EasyLoading.showError("Xác thực không thành công, vui lòng thử lại!");
        return;
      }
    }
    if (sendding.value == true) {
      return;
    }
    sendding.value = true;
    EasyLoading.show(status: "loading...");

    try {
      var body = {
        "user_id": Golbal.store.user["user_id"],
        "IsSign": request["IsSign"],
        "Device_ID": Golbal.store.device["Device_ID"],
        "Noidung": request["Noidung"],
        "ids": [request["RequestMaster_ID"]],
        "RequestSignUser_ID": null,
      };

      var ffiles = [];
      for (var fi in filesDA.value) {
        if (kIsWeb) {
          ffiles.add(dioform.MultipartFile.fromBytes(fi.bytes!,
              filename: fi.path!.split('/').last));
        } else {
          ffiles.add(dioform.MultipartFile.fromFileSync(fi.path!,
              filename: fi.path!.split('/').last));
        }
      }
      for (var fi in imagesDA.value) {
        if (kIsWeb) {
          ffiles.add(dioform.MultipartFile.fromBytes(fi.bytes!,
              filename: fi.path!.split('/').last));
        } else {
          ffiles.add(dioform.MultipartFile.fromFileSync(fi.path!,
              filename: fi.path!.split('/').last));
        }
      }
      var strbody = json.encode(body);
      dioform.FormData formData = dioform.FormData.fromMap({
        "model": strbody,
        "files": ffiles,
      });

      Dio dio = Dio();
      dio.options.headers["Authorization"] = "Bearer ${Golbal.store.token}";
      dio.options.followRedirects = true;
      var response = await dio.put(
          "${Golbal.congty!.api}/api/Request/SendNext_Request",
          data: formData);
      var data = response.data;
      sendding.value = false;
      if (data["err"] == "1") {
        //EasyLoading.showToast("Có lỗi xảy ra, vui lòng thử lại!");
        _sweetSheet.show(
          context: context,
          title: const Text("Không thể ký"),
          description: Text('${data["ms"]}'),
          color: SweetSheetColor.WARNING,
          icon: Icons.portable_wifi_off,
          positive: SweetSheetAction(
            onPressed: () {
              Navigator.of(context).pop();
              goCaidat();
            },
            color: Colors.white,
            title: 'Đăng ký thiết bị',
          ),
          negative: SweetSheetAction(
            onPressed: () {
              Navigator.of(context).pop();
            },
            title: 'Huỷ',
          ),
        );
      } else if (data["err"] == "2") {
        EasyLoading.showError(data["ms"]);
      }
      filesDA.value = [];
      imagesDA.value = [];
      dismissKeybroad(context);
      getRequest(false);

      sendding.value = true;
      EasyLoading.dismiss();
    } catch (e) {
      sendding.value = true;
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
    reloadRequest();
  }

  void reloadRequest() {
    request.value = Get.arguments;
    loading.value = false;
    initSocket();
    initData();
  }

  void initData() {
    getRequest(true);
    //initFormD();
    initFile();
  }

  void getRequest(f) async {
    formD.value = [];
    if (f) {
      EasyLoading.show(status: "loading...");
    }
    try {
      var body = {
        "user_id": Golbal.store.user["user_id"],
        "RequestMaster_ID": request["RequestMaster_ID"],
      };
      Dio dio = Dio();
      dio.options.headers["Authorization"] = "Bearer ${Golbal.store.token}";
      dio.options.followRedirects = true;
      var response = await dio
          .post("${Golbal.congty!.api}/api/Request/Get_Request", data: body);
      var data = response.data;
      if (data["err"] == "1") {
        EasyLoading.showToast("Có lỗi xảy ra, vui lòng thử lại!");
        return;
      }
      if (data != null) {
        var tbs = List.castFrom(json.decode(data["data"]));
        request.value = tbs[0][0];
        if (request["Tiendo"] == null) {
          request["Tiendo"] = 0.0;
        }
        List users = [];
        if (request["Thanhviens"] != null) {
          request["Thanhviens"] = json.decode(request["Thanhviens"]);
          users = request["Thanhviens"];
        }
        if (request["Signs"] != null) {
          request["Signs"] = json.decode(request["Signs"]);
          request["Signs"].forEach((si) {
            si["users"] = users
                .where((e) => e["RequestSign_ID"] == si["RequestSign_ID"])
                .toList();
            if (si["IsTypeDuyet"] == "0") {
              si["users"] =
                  si["users"].where((e) => e["IsSign"] != "0").toList();
              int len = si["users"]
                  .where((e) => e["IsSign"] != "0" && e["IsType"] != "4")
                  .toList()
                  .length;
              if (len == 0) {
                si["users"] = users
                    .where((e) => e["RequestSign_ID"] == si["RequestSign_ID"])
                    .toList();
              }
            }
          });
        }

        formD.value = List.castFrom(tbs[1]).toList();
        for (var f in formD) {
          if (f["KieuTruong"] == "radio" || f["KieuTruong"] == "checkbox") {
            if (f["IsGiatri"] == "True") {
              f["IsGiatri"] = true;
            } else if (f["IsGiatri"] == "False") {
              f["IsGiatri"] = false;
            }
            request["${f["KieuTruong"]}${f["FormD_ID"]}"] = f["IsGiatri"];
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
        EasyLoading.dismiss();
      }
    } catch (e) {
      EasyLoading.dismiss();
      if (kDebugMode) {
        print(e);
      }
    }
  }

  void initFormD() async {
    try {
      var body = {
        "RequestMaster_ID": request["RequestMaster_ID"],
      };
      String url = "Request/Get_FormDByRequestMaster_ID";
      Dio dio = Dio();
      dio.options.headers["Authorization"] = "Bearer ${Golbal.store.token}";
      dio.options.followRedirects = true;
      var response =
          await dio.post("${Golbal.congty!.api}/api/$url", data: body);
      var data = response.data;
      if (data != null) {
        var tbs = List.castFrom(json.decode(data["data"]));
        formD.value = tbs[0];
      } else {
        formD.value = [];
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  void initFile() async {
    try {
      var body = {
        "RequestMaster_ID": request["RequestMaster_ID"],
        "user_id": Golbal.store.user["user_id"],
      };
      String url = "Request/Get_File";
      Dio dio = Dio();
      dio.options.headers["Authorization"] = "Bearer ${Golbal.store.token}";
      dio.options.followRedirects = true;
      var response =
          await dio.post("${Golbal.congty!.api}/api/$url", data: body);
      var data = response.data;
      if (data != null) {
        var tbs = List.castFrom(json.decode(data["data"]));
        files.value = tbs[0];
      } else {
        files.value = [];
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  void initSocket() {
    Golbal.socket.on('countUsers', (data) => initSocketConnected(data));
  }

  void initSocketConnected(data) {
    connected_datas.value = data;
  }
}
