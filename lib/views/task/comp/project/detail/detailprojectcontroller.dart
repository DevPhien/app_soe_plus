import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:sliding_sheet/sliding_sheet.dart';
import 'package:soe/utils/golbal/golbal.dart';
import 'package:soe/views/component/use/avatar.dart';
import 'package:soe/views/task/comp/project/projectcontroller.dart';

class DetailProjectController extends GetxController {
  final ProjectController controller = Get.put(ProjectController());
  ScrollController scrollController = ScrollController();
  final sheetCtr = SheetController();
  //Delcare
  var loading = true.obs;
  var project = {}.obs;
  var quantris = [].obs;
  var thamgias = [].obs;
  var files = [].obs;

  //Function
  void goBack(isdel) {
    //Navigator.of(context).pop();
    Get.back(result: {"project": project, "isdel": isdel});
  }

  void viewUser(context, users, title) async {
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 20),
                      child: Text(
                        title,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Golbal.appColor),
                      ),
                    ),
                    Expanded(
                      child: ListView.separated(
                        physics: const AlwaysScrollableScrollPhysics(),
                        padding: const EdgeInsets.all(0.0),
                        separatorBuilder: (context, i) =>
                            const Divider(height: 1.0, thickness: 1),
                        itemCount: users.length,
                        shrinkWrap: true,
                        itemBuilder: (ct, i) => bindRowUser(users[i]),
                      ),
                    )
                  ],
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

  void moreAction(context) {
    List<Widget> list = [];
    list.add(ListTile(
      leading: const Icon(
        Fontisto.prescription,
      ),
      onTap: () {
        Navigator.of(context).pop();
        goTask();
      },
      title: const Text("Công việc dự án"),
    ));
    if (project["IsMe"] == true || project["isquantri"] == true) {
      list.add(ListTile(
        leading: const Icon(
          Feather.edit,
        ),
        onTap: () {
          Navigator.of(context).pop();
          openEditProject(context);
        },
        title: const Text("Chỉnh sửa"),
      ));
      list.add(ListTile(
        leading: const Icon(
          Feather.trash,
        ),
        onTap: () {
          Navigator.of(context).pop();
          deleteProject(context);
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

  void goTask() async {
    var rs = await Get.toNamed("taskproject", arguments: project);
    if (rs == true) {}
  }

  Future<void> openEditProject(context) async {
    var rs = await Get.toNamed("addproject", arguments: {
      "title": "Cập nhật dự án",
      "DuanID": project["DuanID"],
      "dictionarys": controller.dictionarys,
    });
    if (rs == true) {
      getProject(false);
      EasyLoading.showSuccess("Cập nhật thành công");
    }
  }

  Future<void> deleteProject(context) async {
    showDialog(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text("Bạn có muốn xoá Dự án này không?"),
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
                    "ids": [project["DuanID"]],
                  };
                  Dio dio = Dio();
                  dio.options.headers["Authorization"] =
                      "Bearer ${Golbal.store.token}";
                  dio.options.followRedirects = true;
                  var response = await dio.put(
                      "${Golbal.congty!.api}/api/Task/Delete_Project",
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

  //Init
  @override
  void onInit() {
    super.onInit();
    initData();
  }

  void initData() {
    project.value = Get.arguments;
    loading.value = false;
    getProject(true);
  }

  void getProject(f) async {
    try {
      if (f) {
        EasyLoading.show(status: "loading...");
      }
      var body = {
        "user_id": Golbal.store.user["user_id"],
        "DuanID": project["DuanID"],
      };
      Dio dio = Dio();
      dio.options.headers["Authorization"] = "Bearer ${Golbal.store.token}";
      dio.options.followRedirects = true;
      var response = await dio
          .post("${Golbal.congty!.api}/api/Task/Project_Edit", data: body);
      var data = response.data;
      if (data["err"] == "1") {
        EasyLoading.showToast("Có lỗi xảy ra, vui lòng thử lại!");
        return;
      }
      if (data != null) {
        var tbs = List.castFrom(json.decode(data["data"]));
        if (tbs[0].isNotEmpty) {
          project.value = tbs[0][0];
          if (project["NgayTao"] != null && project["NgayTao"] != "") {
            project["NgayTao"] = DateTime.parse(project["NgayTao"]);
          } else {
            project["NgayTao"] = DateTime.now();
          }
          if (project["Thanhviens"] != null && project["Thanhviens"] != "") {
            project["Thanhviens"] = json.decode(project["Thanhviens"]);
          } else {
            project["Thanhviens"] = [];
          }
        } else {
          EasyLoading.dismiss();
          Get.back(result: {"isDel": true, "message": "Dữ án này đã bị xóa!"});
          return;
        }
        quantris.value = List.castFrom(tbs[1]).toList();
        thamgias.value = List.castFrom(tbs[2]).toList();
        // phongbans.value = List.castFrom(tbs[3]).toList();
        files.value = List.castFrom(tbs[4]).toList();
        var me = quantris.firstWhere(
            (e) => e["NhanSu_ID"] == Golbal.store.user["user_id"],
            orElse: () => null);
        if (me != null) {
          project["isquantri"] = true;
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
}
