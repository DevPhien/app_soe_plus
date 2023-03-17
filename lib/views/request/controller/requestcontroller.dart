import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:sliding_sheet/sliding_sheet.dart';
import 'package:soe/utils/golbal/golbal.dart';
import 'package:soe/views/component/use/avatar.dart';

class RequestController extends GetxController {
  ScrollController scrollController = ScrollController();
  final searchController = TextEditingController();
  final sheetCtr = SheetController();
  RxInt pageIndex = (1).obs;
  RxBool loading = true.obs;
  RxBool showFab = true.obs;
  RxInt typeRQ = (100).obs;
  var datas = [].obs;
  var countdata = (0).obs;
  var countdatas = {}.obs;
  var lastdata = false.obs;
  var isSearchAdv = false.obs;
  var dictionarys = [].obs;

  bool isWeb = kIsWeb;
  var loaddingmore = false;

  Map<String, dynamic> options = {
    "p": 1,
    "pz": 20,
    "s": null,
    "sort": 7,
    "Trangthai": 100,
    "start_date": null,
    "end_date": null,
    "start_finishdate": null,
    "end_finishdate": null,
    "IsIn": true,
    "IsOut": false,
    "IsMe": false,
    "IsQH": -1,
    "IsStatus": -100,
    "congtys": null,
    "teams": null,
    "forms": null,
  };

  //Declare
  Widget renderLableSign(r) {
    String d = r["IsSign"].toString();
    bool cl = r["IsClose"] ?? false;
    if (d == "0") return Container(width: 0.0);
    String name = "";
    switch (d) {
      case "1":
        name = "Chấp thuận";
        break;
      case "2":
        name = "Chuyển tiếp";
        break;
      case "3":
        name = "Skip";
        break;
      case "-1":
        name = "Từ chối";
        break;
    }
    Widget label = Container(
      decoration: BoxDecoration(
          color: signColor(d, cl), borderRadius: BorderRadius.circular(5.0)),
      padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
      child: Text(
        name,
        style: const TextStyle(
            fontSize: 12.0, color: Colors.white, fontWeight: FontWeight.w500),
        overflow: TextOverflow.ellipsis,
        textAlign: TextAlign.justify,
      ),
    );
    return label;
  }

  Widget renderLableSignLog(r) {
    String d = r["IsType"].toString();
    if (d == "0" || d == "null") return Container(width: 0.0);
    String name = "";
    switch (d) {
      case "1":
        name = "Chấp thuận";
        break;
      case "2":
        name = "Chuyển tiếp";
        break;
      case "3":
        name = "Skip";
        break;
      case "-1":
        name = "Từ chối";
        break;
    }
    if (name == "") return Container(width: 0.0);
    Widget label = Container(
      decoration: BoxDecoration(
          color: signColor(d, false), borderRadius: BorderRadius.circular(5.0)),
      padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
      child: Text(
        name,
        style: const TextStyle(
          fontSize: 12.0,
          color: Colors.white,
          fontWeight: FontWeight.w500,
        ),
        overflow: TextOverflow.ellipsis,
        textAlign: TextAlign.justify,
      ),
    );
    return label;
  }

  Widget renderTrangthaiRQ(d, {double? fs, bool? xl}) {
    fs ??= 10.0;
    double pad = Golbal.textScaleFactor > 1.0 ? 8.0 : 5.0;
    int? tt = int.tryParse(d["Trangthai"].toString());
    switch (tt) {
      case 0:
        return Container(
          decoration: BoxDecoration(
              color: const Color(0xFFeeeeee),
              borderRadius: BorderRadius.circular(30.0)),
          padding: EdgeInsets.symmetric(vertical: pad, horizontal: pad),
          child: Text(
            "Mới lập",
            style: TextStyle(color: Colors.black87, fontSize: fs),
          ),
        );
      case 1:
        return Container(
          decoration: BoxDecoration(
              color: Golbal.appColor,
              borderRadius: BorderRadius.circular(30.0)),
          padding: EdgeInsets.symmetric(vertical: pad, horizontal: pad),
          child: Text(
            "Chờ duyệt",
            style: TextStyle(color: Colors.white, fontSize: fs),
          ),
        );
      case 3:
        return Container(
          decoration: BoxDecoration(
              color: const Color(0xFFf17ac7),
              borderRadius: BorderRadius.circular(30.0)),
          padding: EdgeInsets.symmetric(vertical: pad, horizontal: pad),
          child: Text(
            "Thu hồi",
            style: TextStyle(color: Colors.white, fontSize: fs),
          ),
        );
      case -1:
        return Container(
          decoration: BoxDecoration(
              color: const Color(0xFF5bc0de),
              borderRadius: BorderRadius.circular(30.0)),
          padding: EdgeInsets.symmetric(vertical: pad, horizontal: pad),
          child: Text(
            "Huỷ",
            style: TextStyle(color: Colors.white, fontSize: fs),
          ),
        );
      case 2:
        if (xl == true && d["TrangthaiXL"] == 2 || d["TrangthaiXL"] == 3) {
          return renderTrangthaiRQXL(d);
        }
        return Container(
          decoration: BoxDecoration(
              color: const Color(0xff6fbf73),
              borderRadius: BorderRadius.circular(30.0)),
          padding: EdgeInsets.symmetric(vertical: pad, horizontal: pad),
          child: Text(
            "Hoàn thành",
            style: TextStyle(color: Colors.white, fontSize: fs),
          ),
        );
      case -2:
        return Container(
          decoration: BoxDecoration(
              color: Colors.red, borderRadius: BorderRadius.circular(30.0)),
          padding: EdgeInsets.symmetric(vertical: pad, horizontal: pad),
          child: Text(
            "Bị từ chối",
            style: TextStyle(color: Colors.white, fontSize: fs),
          ),
        );
    }
    return Container(
      width: 0.0,
    );
  }

  Widget renderTrangthaiRQXL(d, {double? fs}) {
    fs ??= 10.0;
    double pad = Golbal.textScaleFactor > 1.0 ? 8.0 : 5.0;
    int? tt = int.tryParse(d["TrangthaiXL"].toString());
    switch (tt) {
      case 0:
        return Container(
          decoration: BoxDecoration(
              color: const Color(0xFFeeeeee),
              borderRadius: BorderRadius.circular(10.0)),
          padding: EdgeInsets.symmetric(vertical: pad, horizontal: pad),
          child: Text(
            "Đang đợi xử lý",
            style: TextStyle(color: Colors.black87, fontSize: fs),
          ),
        );
      case 1:
        return Container(
          decoration: BoxDecoration(
              color: const Color(0xFF2196f3),
              borderRadius: BorderRadius.circular(10.0)),
          padding: EdgeInsets.symmetric(vertical: pad, horizontal: pad),
          child: Text(
            "Đang được xử lý",
            style: TextStyle(color: Colors.white, fontSize: fs),
          ),
        );
      case 2:
        return Container(
          decoration: BoxDecoration(
              color: const Color(0xFFf17ac7),
              borderRadius: BorderRadius.circular(10.0)),
          padding: EdgeInsets.symmetric(vertical: pad, horizontal: pad),
          child: Text(
            "Chờ đánh giá",
            style: TextStyle(color: Colors.white, fontSize: fs),
          ),
        );
      case 3:
        return Container(
          decoration: BoxDecoration(
              color: const Color(0xff6fbf73),
              borderRadius: BorderRadius.circular(30.0)),
          padding: EdgeInsets.symmetric(vertical: pad, horizontal: pad),
          child: Text(
            "Hoàn thành",
            style: TextStyle(color: Colors.white, fontSize: fs),
          ),
        );
      case 4:
        return Container(
          decoration: BoxDecoration(
              color: Colors.red, borderRadius: BorderRadius.circular(30.0)),
          padding: EdgeInsets.symmetric(vertical: pad, horizontal: pad),
          child: Text(
            "Đã dừng xử lý",
            style: TextStyle(color: Colors.white, fontSize: fs),
          ),
        );
    }
    return Container(
      width: 0.0,
    );
  }

  Color signColor(String d, bool cl) {
    Color them = Colors.black38;
    if (cl) return Colors.red;
    if (d == "1") return const Color(0xFF6dd230);
    if (d == "2") return const Color(0xFF0078d4);
    if (d == "3") return Colors.blueAccent;
    if (d == "-1") return Colors.orange;
    return them;
  }

  Color renderColor(double td) {
    Color them = const Color(0xff6fbf73);
    if (td <= 30) {
      them = Colors.red;
    } else if (td <= 50) {
      them = Colors.orange;
    } else if (td <= 80) {
      them = Golbal.appColor;
    }
    return them;
  }

  void resetOpition() {
    options["s"] = null;
    options["sort"] = 7;
    options["Trangthai"] = 100;
    options["start_date"] = null;
    options["end_date"] = null;
    options["start_finishdate"] = null;
    options["end_finishdate"] = null;
    options["IsIn"] = true;
    options["IsOut"] = false;
    options["IsMe"] = false;
    options["IsQH"] = -1;
    options["IsStatus"] = -100;
    options["congtys"] = null;
    options["teams"] = null;
    options["forms"] = null;
  }

  var typeRequests = [
    {"id": 0, "title": "Dự thảo"},
    {"id": 1, "title": "Chờ duyệt"},
    {"id": 4, "title": "Đã duyệt"},
    {"id": -2, "title": "Từ chối"},
    {"id": 2, "title": "Hoàn thành"},
    {"id": 6, "title": "Quá hạn"},
    {"id": 999, "title": "Khác"},
  ];

  void viewUser(context, cv) async {
    List sigs = [...cv["Signs"]];
    List members = [...cv["Thanhviens"]];
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
                  padding: const EdgeInsets.all(0.0),
                  separatorBuilder: (context, i) =>
                      const Divider(height: 1.0, thickness: 1),
                  itemCount: sigs.length,
                  shrinkWrap: true,
                  itemBuilder: (ct, i) {
                    List tvs = [...members]
                        .where((e) =>
                            e["RequestSign_ID"] == sigs[i]["RequestSign_ID"])
                        .toList();
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (tvs.isNotEmpty) ...[
                          Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 20),
                            child: Text(
                              "${sigs[i]["GroupName"]} (${sigs[i]["IsTypeDuyet"].toString() == "0" ? "Duyệt 1 trong nhiều" : sigs[i]["IsTypeDuyet"].toString() == "1" ? "Duyệt tuần tự" : "Duyệt ngẫu nhiên"})",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Golbal.appColor),
                            ),
                          ),
                          ListView.separated(
                            physics: const NeverScrollableScrollPhysics(),
                            padding: const EdgeInsets.all(0.0),
                            separatorBuilder: (context, i) =>
                                const Divider(height: 1.0, thickness: 1),
                            itemCount: tvs.length,
                            shrinkWrap: true,
                            itemBuilder: (ct, i) => bindRowUser(tvs[i]),
                          ),
                        ],
                      ],
                    );
                  },
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
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[renderLableSign(r)],
      ),
    );
  }

  //function Filter
  void onPageChanged(int p) {
    switch (p) {
      case 0:
        Get.back();
        break;
      // case 1:
      //   initRequest(true);
      //   break;
      // case 2:
      //   Get.toNamed("teamrequest");
      //   break;
    }
    //datas.clear();
    pageIndex.value = p;
    // if (datas.isNotEmpty) {
    //   scrollController.animateTo(0,
    //       duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
    // }
  }

  Future<void> onLoadmore() {
    if (loaddingmore || lastdata.value == true) return Future.value(null);
    loaddingmore = true;
    options["p"] = int.parse(options["p"].toString()) + 1;
    EasyLoading.show(
      status: "Đang tải trang ${options["p"]}",
    );
    initRequest(false);
    return Future.value(null);
  }

  void search(String s) {
    loading.value = true;
    datas.clear();
    options["s"] = s;
    options["p"] = 1;
    initRequest(false);
  }

  Future<void> goFilterAdv() async {
    var rs = await Get.toNamed("filterrequest", arguments: options);
    if (rs == null) return;
    if (rs != null && rs.keys.length > 0) {
      isSearchAdv.value = true;
      for (var k in rs.keys) {
        options[k] = rs[k];
      }
    } else {
      isSearchAdv.value = false;
      resetOpition();
    }
    scrollController.animateTo(0,
        duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
    loading.value = true;
    datas.clear();
    options["p"] = 1;
    initRequest(false);
  }

  void clearAdv() {
    isSearchAdv.value = false;
    resetOpition();
    scrollController.animateTo(0,
        duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
    loading.value = true;
    datas.clear();
    options["p"] = 1;
    initRequest(true);
  }

  //Function
  void goTypeRequest(context, type) async {
    if (type == 999) {
      showBarModalBottomSheet(
        expand: true,
        context: context,
        backgroundColor: Colors.white,
        builder: (context) => Container(
          padding: const EdgeInsets.symmetric(vertical: 10.0),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        color: const Color(0xFFeeeeee),
                        padding: const EdgeInsets.symmetric(
                            vertical: 15, horizontal: 20),
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Phê duyệt đề xuất",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Golbal.titleColor,
                          ),
                        ),
                      ),
                      ListTile(
                        iconColor: typeRQ.value == 13
                            ? Golbal.appColor
                            : Colors.black54,
                        textColor: typeRQ.value == 13
                            ? Golbal.appColor
                            : Colors.black54,
                        leading: const Icon(
                            MaterialCommunityIcons.send_check_outline),
                        title: Row(
                          children: [
                            Text("Phê duyệt đúng hạn (${countdatas[13]})"),
                          ],
                        ),
                        onTap: () {
                          Navigator.of(context).pop();
                          goTypeRequest(context, 13);
                        },
                      ),
                      const Divider(height: 1),
                      ListTile(
                        iconColor: typeRQ.value == 14
                            ? Golbal.appColor
                            : Colors.black54,
                        textColor: typeRQ.value == 14
                            ? Golbal.appColor
                            : Colors.black54,
                        leading: const Icon(Feather.check_square),
                        title: Row(
                          children: [
                            Text("Hoàn thành đúng hạn (${countdatas[14]})"),
                          ],
                        ),
                        onTap: () {
                          Navigator.of(context).pop();
                          goTypeRequest(context, 14);
                        },
                      ),
                      const Divider(height: 1),
                      ListTile(
                        iconColor: typeRQ.value == 11
                            ? Golbal.appColor
                            : Colors.black54,
                        textColor: typeRQ.value == 11
                            ? Golbal.appColor
                            : Colors.black54,
                        leading: const Icon(
                            MaterialCommunityIcons.send_clock_outline),
                        title: Row(
                          children: [
                            Text("Chờ duyệt quá hạn (${countdatas[11]})"),
                          ],
                        ),
                        onTap: () {
                          Navigator.of(context).pop();
                          goTypeRequest(context, 11);
                        },
                      ),
                      const Divider(height: 1),
                      ListTile(
                        iconColor: typeRQ.value == 12
                            ? Golbal.appColor
                            : Colors.black54,
                        textColor: typeRQ.value == 12
                            ? Golbal.appColor
                            : Colors.black54,
                        leading: const Icon(
                            MaterialCommunityIcons.clock_check_outline),
                        title: Row(
                          children: [
                            Text("Hoàn thành quá hạn (${countdatas[12]})"),
                          ],
                        ),
                        onTap: () {
                          Navigator.of(context).pop();
                          goTypeRequest(context, 12);
                        },
                      ),
                      const Divider(height: 1),
                      ListTile(
                        iconColor: typeRQ.value == 9
                            ? Golbal.appColor
                            : Colors.black54,
                        textColor: typeRQ.value == 9
                            ? Golbal.appColor
                            : Colors.black54,
                        leading: const Icon(Entypo.flash),
                        title: Row(
                          children: [
                            Text("Xử lý gấp (${countdatas[9]})"),
                          ],
                        ),
                        onTap: () {
                          Navigator.of(context).pop();
                          goTypeRequest(context, 9);
                        },
                      ),
                      const Divider(height: 1),
                      ListTile(
                        iconColor: typeRQ.value == 10
                            ? Golbal.appColor
                            : Colors.black54,
                        textColor: typeRQ.value == 10
                            ? Golbal.appColor
                            : Colors.black54,
                        leading: const Icon(MaterialIcons.add_task),
                        title: Row(
                          children: [
                            Text("Tạo công việc (${countdatas[10]})"),
                          ],
                        ),
                        onTap: () {
                          Navigator.of(context).pop();
                          goTypeRequest(context, 10);
                        },
                      ),
                      const Divider(height: 1),
                      ListTile(
                        iconColor: typeRQ.value == 15
                            ? Golbal.appColor
                            : Colors.black54,
                        textColor: typeRQ.value == 15
                            ? Golbal.appColor
                            : Colors.black54,
                        leading: const Icon(Feather.clock),
                        title: Row(
                          children: [
                            Text("Gia hạn duyệt (${countdatas[15]})"),
                          ],
                        ),
                        onTap: () {
                          Navigator.of(context).pop();
                          goTypeRequest(context, 15);
                        },
                      ),
                      const Divider(height: 1),
                      ListTile(
                        iconColor: typeRQ.value == 8
                            ? Golbal.appColor
                            : Colors.black54,
                        textColor: typeRQ.value == 8
                            ? Golbal.appColor
                            : Colors.black54,
                        leading: const Icon(SimpleLineIcons.briefcase),
                        title: Row(
                          children: [
                            Text("Quản lý (${countdatas[8]})"),
                          ],
                        ),
                        onTap: () {
                          Navigator.of(context).pop();
                          goTypeRequest(context, 8);
                        },
                      ),
                      const Divider(height: 1),
                      ListTile(
                        iconColor: typeRQ.value == 5
                            ? Golbal.appColor
                            : Colors.black54,
                        textColor: typeRQ.value == 5
                            ? Golbal.appColor
                            : Colors.black54,
                        leading: const Icon(Feather.eye),
                        title: Row(
                          children: [
                            Text("Theo dõi (${countdatas[5]})"),
                          ],
                        ),
                        onTap: () {
                          Navigator.of(context).pop();
                          goTypeRequest(context, 5);
                        },
                      ),
                      const Divider(height: 1),
                      Container(
                        color: const Color(0xFFeeeeee),
                        padding: const EdgeInsets.symmetric(
                            vertical: 15, horizontal: 20),
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Xử lý đề xuất",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Golbal.titleColor,
                          ),
                        ),
                      ),
                      ListTile(
                        iconColor: typeRQ.value == 16
                            ? Golbal.appColor
                            : Colors.black54,
                        textColor: typeRQ.value == 16
                            ? Golbal.appColor
                            : Colors.black54,
                        leading: const Icon(Entypo.laptop),
                        title: Row(
                          children: [
                            Text("Đang thực hiện (${countdatas[16]})"),
                          ],
                        ),
                        onTap: () {
                          Navigator.of(context).pop();
                          goTypeRequest(context, 16);
                        },
                      ),
                      const Divider(height: 1),
                      ListTile(
                        iconColor: typeRQ.value == 17
                            ? Golbal.appColor
                            : Colors.black54,
                        textColor: typeRQ.value == 17
                            ? Golbal.appColor
                            : Colors.black54,
                        leading: const Icon(MaterialIcons.preview),
                        title: Row(
                          children: [
                            Text("Chờ đánh giá (${countdatas[17]})"),
                          ],
                        ),
                        onTap: () {
                          Navigator.of(context).pop();
                          goTypeRequest(context, 17);
                        },
                      ),
                      const Divider(height: 1),
                      ListTile(
                        iconColor: typeRQ.value == 18
                            ? Golbal.appColor
                            : Colors.black54,
                        textColor: typeRQ.value == 18
                            ? Golbal.appColor
                            : Colors.black54,
                        leading: const Icon(Feather.check),
                        title: Row(
                          children: [
                            Text("Đã đánh giá (${countdatas[18]})"),
                          ],
                        ),
                        onTap: () {
                          Navigator.of(context).pop();
                          goTypeRequest(context, 18);
                        },
                      ),
                      const Divider(height: 1),
                      ListTile(
                        iconColor: typeRQ.value == 19
                            ? Golbal.appColor
                            : Colors.black54,
                        textColor: typeRQ.value == 19
                            ? Golbal.appColor
                            : Colors.black54,
                        leading: const Icon(Entypo.stopwatch),
                        title: Row(
                          children: [
                            Text("Tạm dừng (${countdatas[19]})"),
                          ],
                        ),
                        onTap: () {
                          Navigator.of(context).pop();
                          goTypeRequest(context, 19);
                        },
                      ),
                      const Divider(height: 1),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    } else {
      typeRQ.value = type;
      options["s"] = null;
      options["p"] = 1;
      lastdata.value = false;
      initRequest(true);
    }
  }

  Future<void> openAddRequest() async {
    var rs = await Get.toNamed("addrequest", arguments: {
      "title": "Thêm đề xuất",
      "STT": countdatas[0],
      "dictionarys": dictionarys,
    });
    if (rs == true) {
      initRequest(true);
      countRequest();
      EasyLoading.showSuccess("Cập nhật thành công");
    }
  }

  Future<void> goRequest(request) async {
    var rs = await Get.toNamed("detailrequest", arguments: request);
    if (rs != null && rs["request"] != null) {
      if (rs["isdel"] == true) {
        int idx = datas.indexWhere(
            (e) => e["RequestMaster_ID"] == rs["request"]["RequestMaster_ID"]);
        if (idx != -1) {
          datas.removeAt(idx);
          countRequest();
          EasyLoading.showSuccess("Xóa thành công");
        }
      } else {
        int idx = datas.indexWhere(
            (e) => e["RequestMaster_ID"] == rs["request"]["RequestMaster_ID"]);
        if (idx != -1) {
          datas[idx] = rs["request"];
        }
      }
    }
    return;
  }

  void getRequest(request) async {
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
        request = tbs[0][0];
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

        //formD.value = tbs[1];

        int idx = datas.indexWhere(
            (e) => e["RequestMaster_ID"] == request["RequestMaster_ID"]);
        if (idx != -1) {
          datas[idx] = request;
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  Future<void> openEditRquest() async {}

  @override
  void onInit() {
    super.onInit();
    initOne();
  }

  void initOne() {
    initRequest(true);
    countRequest();
    initDictionary();
    initSetting();
  }

  void initRequest(f) async {
    try {
      if (f) {
        loading.value = true;
      }
      var body = {
        "user_id": Golbal.store.user["user_id"],
        "p": options["p"],
        "pz": options["pz"],
        "s": options["s"],
        "sort": options["sort"],
        "Trangthai": typeRQ.value,
        "start_date": options["start_date"],
        "end_date": options["end_date"],
        "start_finishdate": options["start_finishdate"],
        "end_finishdate": options["end_finishdate"],
        "yeucaureview": options["yeucaureview"],
        "isdeadline": options["isdeadline"],
        "IsIn": options["IsIn"],
        "IsOut": options["IsOut"],
        "IsMe": options["IsMe"],
        "Form_ID": options["Form_ID"],
        "IsQH": options["IsQH"],
        "IsStatus": options["IsStatus"],
        "congtys": options["congtys"],
        "teams": options["teams"],
        "forms": options["forms"],
      };
      String url = "Request/Get_RequestByMe";
      Dio dio = Dio();
      dio.options.headers["Authorization"] = "Bearer ${Golbal.store.token}";
      dio.options.followRedirects = true;
      var response =
          await dio.post("${Golbal.congty!.api}/api/$url", data: body);
      var data = response.data;
      if (data != null) {
        var tbs = List.castFrom(json.decode(data["data"]));
        if (tbs[0].isNotEmpty) {
          for (var element in tbs[0]) {
            if (element["Tiendo"] == null) {
              element["Tiendo"] = 0.0;
            }
            List users = [];
            if (element["Thanhviens"] != null) {
              element["Thanhviens"] = json.decode(element["Thanhviens"]);
              users = element["Thanhviens"];
            }
            if (element["Signs"] != null) {
              element["Signs"] = json.decode(element["Signs"]);
              element["Signs"].forEach((si) {
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
                        .where(
                            (e) => e["RequestSign_ID"] == si["RequestSign_ID"])
                        .toList();
                  }
                }
              });
            }
          }
          if (f) {
            datas.value = tbs[0];
          } else {
            datas.addAll(tbs[0]);
          }
          //print(tbs);
        } else {
          if (loaddingmore) {
            lastdata.value = true;
            EasyLoading.showToast("Bạn đã xem hết đề xuất rồi!");
          } else {
            datas.value = [];
          }
        }
        if (tbs[1].isNotEmpty) {
          countdata.value = tbs[1][0]["c"];
        }
        if (loaddingmore) {
          loaddingmore = false;
        }
      } else {
        lastdata.value = true;
        EasyLoading.showToast("Bạn đã xem hết đề xuất rồi!");
      }
      if (loading.value) {
        loading.value = false;
      }
      EasyLoading.dismiss();
    } catch (e) {
      loading.value = false;
      if (kDebugMode) {
        print(e);
      }
      EasyLoading.dismiss();
    }
  }

  void countRequest() async {
    try {
      var body = {
        "user_id": Golbal.store.user["user_id"],
        "s": options["s"],
        "start_date": options["start_date"],
        "end_date": options["end_date"],
        "start_finishdate": options["start_finishdate"],
        "end_finishdate": options["end_finishdate"],
        "IsIn": options["IsIn"],
        "IsOut": options["IsOut"],
        "IsMe": options["IsMe"],
        "Form_ID": options["Form_ID"],
        "IsQH": options["IsQH"],
        "IsStatus": options["IsStatus"],
        "congtys": options["congtys"],
        "teams": options["teams"],
        "forms": options["forms"],
      };
      String url = "Request/Get_CountRequestByMe";
      Dio dio = Dio();
      dio.options.headers["Authorization"] = "Bearer ${Golbal.store.token}";
      dio.options.followRedirects = true;
      var response =
          await dio.post("${Golbal.congty!.api}/api/$url", data: body);
      var data = response.data;
      if (data != null) {
        var tbs = List.castFrom(json.decode(data["data"]));
        if (tbs[0].isNotEmpty) {
          var obj = {};
          for (var tb in tbs[0]) {
            if (tb["count"] != null) {
              obj[tb["Trangthai"]] = tb["count"];
            }
          }
          countdatas.value = obj;
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  void initDictionary() async {
    try {
      var body = {
        "user_id": Golbal.store.user["user_id"],
      };
      String url = "Request/Get_RequestDictionary";
      Dio dio = Dio();
      dio.options.headers["Authorization"] = "Bearer ${Golbal.store.token}";
      dio.options.followRedirects = true;
      var response =
          await dio.post("${Golbal.congty!.api}/api/$url", data: body);
      var data = response.data;
      if (data != null) {
        var tbs = List.castFrom(json.decode(data["data"]));
        dictionarys.value = tbs;
      } else {
        dictionarys.value = [];
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  void initSetting() async {
    Golbal.store.device = {
      "Device_Name": "Web",
      "Device_No": Golbal.store.tokencmd,
      "IsVerifySign": 1,
      "Device_Type": 0,
      "TokenCMID": Golbal.store.tokencmd,
      "user_id": Golbal.store.user["user_id"],
      "Congty_ID": Golbal.congty!.congtyID,
    };
    try {
      var body = {
        "user_id": Golbal.store.user["user_id"],
        "Device_No": Golbal.store.tokencmd,
      };
      String url = "Request/Get_Device";
      Dio dio = Dio();
      dio.options.headers["Authorization"] = "Bearer ${Golbal.store.token}";
      dio.options.followRedirects = true;
      var response =
          await dio.post("${Golbal.congty!.api}/api/$url", data: body);
      var data = response.data;
      if (data != null) {
        var tbs = List.castFrom(json.decode(data["data"]));
        if (tbs[0].isNotEmpty) {
          Golbal.store.device = tbs[0][0];
        }
        if (tbs[1].isNotEmpty) {
          Golbal.store.settingRequest = tbs[1][0];
        }
      } else {
        Golbal.store.device = {};
        Golbal.store.settingRequest = {};
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }
}
