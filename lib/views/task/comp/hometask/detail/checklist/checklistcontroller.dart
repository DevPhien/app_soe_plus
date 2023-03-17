import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';
import 'package:pattern_formatter/pattern_formatter.dart';
import 'package:sliding_sheet/sliding_sheet.dart';

import '../../../../../../utils/golbal/golbal.dart';
import '../detailtaskcontroller.dart';

class CheckListTaskController extends GetxController {
  final ChitietTaskController controller = Get.put(ChitietTaskController());
  final sheetCtr = SheetController();
  var isloadding = true.obs;
  var load = false.obs;
  var checklists = [].obs;
  var model = {}.obs;
  initData(String congviecID) async {
    try {
      Dio dio = Dio();
      dio.options.headers["Authorization"] = "Bearer ${Golbal.store.token}";
      dio.options.followRedirects = true;
      var response = await dio.post(
        "${Golbal.congty!.api}/api/Task/Get_ChecklistByTask",
        data: {
          "congviec_id": congviecID,
        },
      );
      var data = response.data;
      if (data != null) {
        var tbs = List.castFrom(json.decode(data["data"]));
        initTask(tbs, congviecID, null);
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  initTask(List arrChecks, String congviecID, String? checklistid) async {
    try {
      Dio dio = Dio();
      dio.options.headers["Authorization"] = "Bearer ${Golbal.store.token}";
      dio.options.followRedirects = true;
      var response = await dio
          .post("${Golbal.congty!.api}/api/Task/Get_TaskTodoByTask", data: {
        "congviec_id": congviecID,
        "checklist_id": checklistid,
      });
      var data = response.data;
      if (data != null) {
        var tbs = List.castFrom(json.decode(data["data"]));
        for (var t in arrChecks) {
          t["tasks"] = tbs
              .where((element) => element["ChecklistID"] == t["ChecklistID"])
              .toList();
          for (var element in t["tasks"]) {
            if (element["anhThumb"] != null) {
              element["anhThumb"] =
                  Golbal.congty!.fileurl + element["anhThumb"];
            }
            if (element["Thanhviens"] != null) {
              element["Thanhviens"] = json.decode(element["Thanhviens"]);
            }
          }
        }
        checklists.value = arrChecks;
        isloadding.value = false;
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  void onToggle(checklist) {
    int idx = checklists.indexWhere(
        (element) => element["ChecklistID"] == checklist["ChecklistID"]);
    if (idx != -1) {
      if (checklists[idx]["isopen"] == null) {
        checklists[idx]["isopen"] = false;
      } else {
        checklists[idx]["isopen"] = !checklists[idx]["isopen"];
      }
      checklists.refresh();
    }
  }

  void onClickTask(task) {}
  void onCheckTask(task, v) {
    var idx = checklists
        .indexWhere((element) => element["ChecklistID"] == task["ChecklistID"]);
    if (idx != -1) {
      var idxt = checklists[idx]["tasks"]
          .indexWhere((element) => element["CongviecID"] == task["CongviecID"]);
      if (idxt != -1) {
        checklists[idx]["tasks"][idxt]["IsCheck"] = v;
        checklists.refresh();
        model.value = checklists[idx]["tasks"][idxt];
        addTodo();
      }
    }
  }

  Future<void> openModalChecklist(context,
      {Map<dynamic, dynamic>? checklist}) async {
    var breakRow = const SizedBox(height: 10);
    TextStyle sao = const TextStyle(
      color: Colors.red,
      fontSize: 13,
      fontWeight: FontWeight.w500,
    );
    if (checklist != null) {
      model.value = checklist;
    } else {
      model.value = {
        "DuanID": controller.task["DuanID"],
        "CongviecID": controller.task["CongviecID"],
        "TenChecklist": "",
        "Mota": "",
        "STT": checklists.length + 1,
        "Hienthi": true,
      };
    }

    var rs = await showSlidingBottomSheet(context, builder: (context) {
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
            child: KeyboardDismisser(
              child: Scaffold(
                backgroundColor: Colors.white,
                body: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: Form(
                    child: Column(
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const <Widget>[
                            Text(
                              "Cập nhật Checklist",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        breakRow,
                        breakRow,
                        Row(
                          children: [
                            Text("Tên checklist", style: Golbal.stylelabel),
                            Text(" (*)", style: sao),
                          ],
                        ),
                        breakRow,
                        TextFormField(
                          initialValue: model["TenChecklist"],
                          minLines: 2,
                          maxLines: 4,
                          decoration: Golbal.decoration,
                          style: Golbal.styleinput,
                          onChanged: (String txt) =>
                              model["TenChecklist"] = txt,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Vui lòng nhập tên checklist';
                            }
                            return null;
                          },
                        ),
                        breakRow,
                        Row(
                          children: [
                            Text("Mô tả", style: Golbal.stylelabel),
                          ],
                        ),
                        breakRow,
                        TextFormField(
                          initialValue: model["Mota"],
                          minLines: 2,
                          maxLines: 4,
                          decoration: Golbal.decoration,
                          style: Golbal.styleinput,
                          onChanged: (String txt) => model["Mota"] = txt,
                        ),
                        breakRow,
                        Row(
                          children: [
                            Text("STT", style: Golbal.stylelabel),
                          ],
                        ),
                        breakRow,
                        TextFormField(
                          initialValue:
                              (model["STT"] ?? (checklists.length + 1))
                                  .toString(),
                          decoration: Golbal.decoration,
                          keyboardType: TextInputType.number,
                          inputFormatters: [ThousandsFormatter()],
                          style: Golbal.styleinput,
                          onChanged: (String txt) => model["STT"] = txt,
                        ),
                        breakRow,
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 10.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Expanded(
                                child: ElevatedButton(
                                  style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.all<Color>(
                                      const Color(0xFFF2F2F2),
                                    ),
                                  ),
                                  onPressed: () {
                                    Navigator.of(context).pop(false);
                                  },
                                  child: const Text(
                                    "Hủy",
                                    maxLines: 1,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black54,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10.0),
                              Expanded(
                                child: ElevatedButton(
                                  style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.all<Color>(
                                      Golbal.appColor,
                                    ),
                                  ),
                                  onPressed: () {
                                    Navigator.of(context).pop(true);
                                  },
                                  child: const Text(
                                    "Lưu",
                                    maxLines: 1,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      );
    });

    if (rs == true) {
      addChecklist();
    }
  }

  void addChecklist() async {
    try {
      if (load.value) return;
      load.value = true;
      EasyLoading.show(status: "loading...");

      var body = {
        "user_id": Golbal.store.user["user_id"],
        "model": model,
      };
      Dio dio = Dio();
      dio.options.headers["Authorization"] = "Bearer ${Golbal.store.token}";
      dio.options.followRedirects = true;
      var response = await dio
          .put("${Golbal.congty!.api}/api/Task/Update_CheckLists", data: body);
      var data = response.data;
      load.value = false;
      if (data["err"] == "1") {
        EasyLoading.showError("Có lỗi xảy ra, vui lòng thử lại!");
        return;
      }
      initData(controller.task["CongviecID"]);
      EasyLoading.dismiss();
    } catch (e) {
      load.value = false;
      EasyLoading.showError("Có lỗi xảy ra!");
      if (kDebugMode) {
        print(e);
      }
    }
  }

  Future<void> deleteChecklist(context, item) async {
    showDialog(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text("Bạn có muốn xoá Checklist này không?"),
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
                    "ChecklistID": item["ChecklistID"],
                  };
                  Dio dio = Dio();
                  dio.options.headers["Authorization"] =
                      "Bearer ${Golbal.store.token}";
                  dio.options.followRedirects = true;
                  var response = await dio.put(
                      "${Golbal.congty!.api}/api/Task/Delete_CheckLists",
                      data: body);
                  var data = response.data;
                  if (data["err"] == "1") {
                    EasyLoading.showError(data["data"]);
                    return;
                  }
                  initData(controller.task["CongviecID"]);
                  EasyLoading.showSuccess("Xoá thành công");
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

  Future<void> openModalTodo(context,
      {Map<dynamic, dynamic>? checklist, Map<dynamic, dynamic>? todo}) async {
    var breakRow = const SizedBox(height: 10);
    TextStyle sao = const TextStyle(
      color: Colors.red,
      fontSize: 13,
      fontWeight: FontWeight.w500,
    );
    if (todo != null) {
      model.value = todo;
    } else {
      var cl = checklists.firstWhereOrNull(
          (e) => e["ChecklistID"] == checklist!["ChecklistID"]);
      model.value = {
        "DuanID": controller.task["DuanID"],
        "ChecklistID": cl!["ChecklistID"],
        "CongviecTen": "",
        "IsTodo": true,
        "focus": true,
        "Trangthai": 1,
        "ParentID": controller.task["CongviecID"],
        "Congty_ID": Golbal.store.user["congtyID"],
        "YeucauReview": true,
        "STT": cl!["tasks"].length + 1,
      };
    }

    var rs = await showSlidingBottomSheet(context, builder: (context) {
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
            child: KeyboardDismisser(
              child: Scaffold(
                backgroundColor: Colors.white,
                body: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: Form(
                    child: Column(
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const <Widget>[
                            Text(
                              "Cập nhật Công việc",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        breakRow,
                        breakRow,
                        Row(
                          children: [
                            Text("Tên Công việc", style: Golbal.stylelabel),
                            Text(" (*)", style: sao),
                          ],
                        ),
                        breakRow,
                        TextFormField(
                          initialValue: model["CongviecTen"],
                          minLines: 2,
                          maxLines: 4,
                          decoration: Golbal.decoration,
                          style: Golbal.styleinput,
                          onChanged: (String txt) => model["CongviecTen"] = txt,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Vui lòng nhập tên checklist';
                            }
                            return null;
                          },
                        ),
                        breakRow,
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 10.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Expanded(
                                child: ElevatedButton(
                                  style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.all<Color>(
                                      const Color(0xFFF2F2F2),
                                    ),
                                  ),
                                  onPressed: () {
                                    Navigator.of(context).pop(false);
                                  },
                                  child: const Text(
                                    "Hủy",
                                    maxLines: 1,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black54,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10.0),
                              Expanded(
                                child: ElevatedButton(
                                  style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.all<Color>(
                                      Golbal.appColor,
                                    ),
                                  ),
                                  onPressed: () {
                                    Navigator.of(context).pop(true);
                                  },
                                  child: const Text(
                                    "Lưu",
                                    maxLines: 1,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      );
    });

    if (rs == true) {
      addTodo();
    }
  }

  Future<void> deleteTodo(context, item) async {
    showDialog(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text("Bạn có muốn xoá Công việc này không?"),
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
                    "CongviecID": item["CongviecID"],
                  };
                  Dio dio = Dio();
                  dio.options.headers["Authorization"] =
                      "Bearer ${Golbal.store.token}";
                  dio.options.followRedirects = true;
                  var response = await dio.put(
                      "${Golbal.congty!.api}/api/Task/Delete_Todo",
                      data: body);
                  var data = response.data;
                  if (data["err"] == "1") {
                    EasyLoading.showError(data["data"]);
                    return;
                  }
                  initData(controller.task["CongviecID"]);
                  EasyLoading.showSuccess("Xoá thành công");
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

  void addTodo() async {
    try {
      if (load.value) return;
      load.value = true;
      EasyLoading.show(status: "loading...");

      var body = {
        "user_id": Golbal.store.user["user_id"],
        "model": model,
      };
      Dio dio = Dio();
      dio.options.headers["Authorization"] = "Bearer ${Golbal.store.token}";
      dio.options.followRedirects = true;
      var response = await dio.put("${Golbal.congty!.api}/api/Task/Update_Todo",
          data: body);
      var data = response.data;
      load.value = false;
      if (data["err"] == "1") {
        EasyLoading.showError("Có lỗi xảy ra, vui lòng thử lại!");
        return;
      }
      initData(controller.task["CongviecID"]);
      EasyLoading.dismiss();
    } catch (e) {
      load.value = false;
      EasyLoading.showError("Có lỗi xảy ra!");
      if (kDebugMode) {
        print(e);
      }
    }
  }

  @override
  void onInit() {
    super.onInit();
    if (controller.task.keys.isNotEmpty &&
        controller.task["CongviecID"] != null) {
      initData(controller.task["CongviecID"]);
    }
  }

  @override
  void onClose() {
    controller.dispose();
    super.onClose();
  }
}
