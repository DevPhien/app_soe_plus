import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:sliding_sheet/sliding_sheet.dart';
import 'package:soe/views/task/comp/hometask/detail/giahan/giahan.dart';
import 'package:soe/views/task/comp/hometask/detail/subtask/subtaskcontroller.dart';
import 'package:soe/views/task/controller/taskcontroller.dart';

import '../../../../../utils/golbal/golbal.dart';
import '../../../../component/use/avatar.dart';
import 'checklist/checklistcontroller.dart';
import 'comment/commenttakscontroller.dart';
import 'comment/inputcommentcontroller.dart';

class ChitietTaskController extends GetxController {
  TaskController controller = Get.put(TaskController());
  final sheetCtr = SheetController();
  var task = {}.obs;
  var getdata = {}.obs;
  var members = [].obs;
  var nguoigiaos = {}.obs;
  var nguoithuchiens = {}.obs;
  var isloadding = true.obs;
  var showInputComment = false.obs;
  ScrollController scrollController = ScrollController();
  var files = [].obs;
  var vanbans = [].obs;

  //Function
  void viewUser(context, mbs) async {
    List members = [...mbs];
    await showSlidingBottomSheet(context, builder: (context) {
      return SlidingSheetDialog(
        controller: sheetCtr,
        elevation: 8,
        cornerRadius: 16,
        snapSpec: const SnapSpec(
          snap: false,
          snappings: [0.7, 0.8, 0.9],
          positioning: SnapPositioning.relativeToAvailableSpace,
        ),
        headerBuilder: (c, s) => Material(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 20.0),
            child: Row(
              children: <Widget>[
                const Spacer(),
                Container(
                  margin: const EdgeInsets.only(top: 10.0),
                  width: 40,
                  height: 5,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color: const Color(0xFFdddddd),
                  ),
                ),
                const Spacer()
              ],
            ),
          ),
        ),
        builder: (context, state) {
          return SizedBox(
            height: MediaQuery.of(context).size.height * 0.9,
            child: Material(
              color: Colors.white,
              child: SafeArea(
                top: false,
                child: ListView.separated(
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(0.0),
                  separatorBuilder: (context, i) =>
                      const Divider(height: 1.0, thickness: 1),
                  itemCount: members.length,
                  shrinkWrap: true,
                  itemBuilder: (ct, i) => bindRowUser(members[i]),
                ),
              ),
            ),
          );
        },
      );
    });
  }

  Widget bindRowUser(r) {
    return ListTile(
      leading: SizedBox(
        width: 40,
        height: 40,
        child: UserAvarta(
          user: r,
          radius: 24,
        ),
      ),
      title: Text(
        r["fullName"] ?? "",
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      ),
      subtitle: Text(r["tenToChuc"] ?? ""),
    );
  }

  void goBack(isdel) {
    EasyLoading.dismiss();
    Get.back(result: {"task": task, "isdel": isdel});
  }

  Future<void> openEditTask(context) async {
    var rs = await Get.toNamed("addtask", arguments: {
      "title": "Cập nhật công việc",
      "CongviecID": task["CongviecID"],
      "dictionarys": controller.dictionarys,
      "duans": controller.duans,
    });
    if (rs == true) {
      getTask(false);
      //initFile();
      EasyLoading.showSuccess("Cập nhật thành công");
    }
  }

  void clickBody() {
    final InputCommentController ipcontroller =
        Get.put(InputCommentController());
    ipcontroller.emojiShowing.value = false;
  }

  void scroolBottom() {
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

  void moreAction(context) {
    List<Widget> list = [];
    if (task["isgiaoviec"] == true || task["isthuchien"] == true) {
      list.add(ListTile(
        leading: const Icon(
          Fontisto.prescription,
        ),
        onTap: () {
          Navigator.of(context).pop();
          goReport();
        },
        title: const Text("Báo cáo tiến độ"),
      ));
    }
    if ((task["isgiaoviec"] == true || task["isthuchien"] == true) &&
        task["IsDeadline"] == true) {
      list.add(ListTile(
        leading: const Icon(
          Fontisto.date,
        ),
        onTap: () {
          Navigator.of(context).pop();
          goGiahan();
        },
        title: const Text("Gia hạn xử lý"),
      ));
    }
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
    if (task["isgiaoviec"] == true || task["isthuchien"] == true) {
      list.add(ListTile(
        leading: const Icon(
          Octicons.tasklist,
        ),
        onTap: () {
          Navigator.of(context).pop();
          goSubTask();
        },
        title: const Text("Công việc con"),
      ));
    }
    if (task["quanly"] == true || task["tao"] == true) {
      list.add(ListTile(
        leading: const Icon(
          Feather.edit,
        ),
        onTap: () {
          Navigator.of(context).pop();
          openEditTask(context);
        },
        title: const Text("Chỉnh sửa"),
      ));
      list.add(ListTile(
        leading: const Icon(
          Feather.lock,
        ),
        onTap: () {
          Navigator.of(context).pop();
          lockTask();
        },
        title: Text(task["Trangthai"] != 3 ? "Đóng" : "Mở"),
      ));
      list.add(ListTile(
        leading: const Icon(
          Feather.trash,
        ),
        onTap: () {
          Navigator.of(context).pop();
          deleteTask(context);
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

  void giahan(context) async {
    await showSlidingBottomSheet(
      context,
      builder: (context) {
        return SlidingSheetDialog(
          controller: sheetCtr,
          elevation: 8,
          cornerRadius: 16,
          snapSpec: const SnapSpec(
            snap: false,
            snappings: [0.7, 0.8, 0.9],
            positioning: SnapPositioning.relativeToAvailableSpace,
          ),
          headerBuilder: (c, s) => Material(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
              child: Row(
                children: <Widget>[
                  const Spacer(),
                  Container(
                    margin: const EdgeInsets.only(top: 10.0),
                    width: 40,
                    height: 5,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      color: const Color(0xFFdddddd),
                    ),
                  ),
                  const Spacer()
                ],
              ),
            ),
          ),
          builder: (context, state) {
            return SizedBox(
              height: MediaQuery.of(context).size.height * 0.9,
              child: GiahanTask(),
            );
          },
        );
      },
    );
  }

  Future<void> goReport() async {
    var rs = await Get.toNamed("reporttask", arguments: task);
    if (rs == true) {
      getTask(false);
    }
    return;
  }

  Future<void> goGiahan() async {
    var rs = await Get.toNamed("giahantask", arguments: task);
    if (rs == true) {
      getTask(false);
    }
    return;
  }

  Future<void> goSubTask() async {
    Get.delete<SubTaskController>();
    var rs = await Get.toNamed("subtask", arguments: task);
    if (rs == true) {
      getTask(false);
    }
    return;
  }

  Future<void> goAtivity() async {
    var rs = await Get.toNamed("activitytask", arguments: task);
    return;
  }

  void lockTask() async {
    try {
      EasyLoading.show(status: "loading...");
      task["Trangthai"] = task["Trangthai"] == 3 ? 1 : 3;
      var body = {
        "user_id": Golbal.store.user["user_id"],
        "CongviecID": task["CongviecID"],
        "Trangthai": task["Trangthai"],
        "ch": false,
      };
      Dio dio = Dio();
      dio.options.headers["Authorization"] = "Bearer ${Golbal.store.token}";
      dio.options.followRedirects = true;
      var response = await dio
          .put("${Golbal.congty!.api}/api/Task/Update_StatusTask", data: body);
      var data = response.data;
      if (data["err"] == "1") {
        EasyLoading.showToast("Có lỗi xảy ra, vui lòng thử lại!");
        return;
      }
      EasyLoading.dismiss();
    } catch (e) {
      EasyLoading.dismiss();
      if (kDebugMode) {
        print(e);
      }
    }
  }

  Future<void> deleteTask(context) async {
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
                    "congviec_id": task["CongviecID"],
                  };
                  Dio dio = Dio();
                  dio.options.headers["Authorization"] =
                      "Bearer ${Golbal.store.token}";
                  dio.options.followRedirects = true;
                  var response = await dio.put(
                      "${Golbal.congty!.api}/api/Task/Delete_Task",
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

  @override
  void onInit() {
    super.onInit();
    initData();
  }

  void initData() {
    Get.delete<CheckListTaskController>();
    Get.delete<CommentTaskController>();
    Get.delete<InputCommentController>();
    getdata.value = Get.arguments;
    getTask(true);
  }

  void getTask(f) async {
    try {
      if (f) {
        isloadding.value = true;
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
      isloadding.value = false;
      if (data["err"] == 1) {
        EasyLoading.showError("Có lỗi xảy ra, vui lòng thử lại");
      }
      if (data != null) {
        var tbs = List.castFrom(json.decode(data["data"]));
        if (tbs.isNotEmpty) {
          if (tbs[0].isNotEmpty) {
            task.value = tbs[0][0];
          } else {
            EasyLoading.dismiss();
            Get.back(
                result: {"isdel": true, "message": "Công việc này đã bị xóa!"});
            return;
          }
          members.value = List.castFrom(tbs[1]).toList();
          task["Thanhviens"] = members;
          task["giaoviec"] = members.firstWhereOrNull((element) =>
              element["IsType"] != null && element["IsType"].toString() == "2");
          task["thuchien"] = members.firstWhereOrNull((element) =>
              element["IsType"] != null && element["IsType"].toString() == "1");
          task["theodoi"] = members
              .where((element) =>
                  element["IsType"] != null &&
                  element["IsType"].toString() == "0")
              .toList();

          task["IsHT"] = task["Trangthai"] == 4 || task["Trangthai"] == 7;
          // task["active"] = task["Trangthai"] == 1 ||
          //     task["Trangthai"] == 5 ||
          //     task["Trangthai"] == 6 ||
          //     task["Trangthai"] == 8;

          // task["isgiaoviec"] = task["giaoviec"] != null &&
          //     task["giaoviec"]["NhanSu_ID"] == Golbal.store.user["user_id"];
          // task["isthuchien"] = task["thuchien"] != null &&
          //     task["thuchien"]["NhanSu_ID"] == Golbal.store.user["user_id"];

          showInputComment.value = true; //task["active"];
          if (isloadding.value) isloadding.value = false;
          if (members.isNotEmpty) {
            nguoigiaos.value = members.firstWhere(
                (e) => e["IsType"] == 2 && e["IsActive"] == true,
                orElse: () => null);
            nguoithuchiens.value = members.firstWhere(
                (e) => e["IsType"] == 1 && e["IsActive"] == true,
                orElse: () => null);
          }

          var me = members.firstWhere(
              (e) =>
                  e["IsType"] == 2 &&
                  e["NhanSu_ID"] == Golbal.store.user["user_id"],
              orElse: () => null);
          if (me != null) {
            task["isgiaoviec"] = true;
          } else {
            task["isgiaoviec"] = false;
          }
          me = members.firstWhere(
              (e) =>
                  e["IsType"] == 1 &&
                  e["NhanSu_ID"] == Golbal.store.user["user_id"],
              orElse: () => null);
          if (me != null) {
            task["isthuchien"] = true;
          } else {
            task["isthuchien"] = false;
          }

          files.value = List.castFrom(tbs[2]).toList();
          vanbans.value = List.castFrom(tbs[8]).toList();
        }
      }
      EasyLoading.dismiss();
    } catch (e) {
      EasyLoading.dismiss();
      if (kDebugMode) {
        print(e);
      }
    }
  }

  @override
  void onClose() {
    Get.delete<CheckListTaskController>();
    Get.delete<CommentTaskController>();
    Get.delete<InputCommentController>();
    scrollController.dispose();
    super.onClose();
  }
}
