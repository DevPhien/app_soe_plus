import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:soe/utils/golbal/golbal.dart';
import 'package:soe/views/component/use/avatar.dart';
import 'package:soe/views/request/comp/homerequest/add/addrequestcontroller.dart';
import 'package:soe/views/request/comp/homerequest/add/form/inputcolumn.dart';
import 'package:soe/views/request/comp/homerequest/memberrequest.dart';

class AddRequest extends StatelessWidget {
  final AddRequestController controller = Get.put(AddRequestController());
  AddRequest({Key? key}) : super(key: key);

  Widget formWidget() {
    var breakRow = const SizedBox(height: 10.0);
    TextStyle sao = const TextStyle(
      color: Colors.red,
      fontSize: 13,
      fontWeight: FontWeight.w500,
    );
    return Form(
      key: controller.formKey,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        //Loại đề xuất
        Row(
          children: [
            Text("Loại đề xuất", style: Golbal.stylelabel),
            Text(" (*)", style: sao),
          ],
        ),
        breakRow,
        Obx(
          () => fileCategory(
            "Chọn loại đề xuất",
            controller.loaidxs,
            "loaidxs",
            "Form_ID",
            "Form_Name",
            "Form_ID",
            true,
            true,
          ),
        ),
        breakRow,
        //Tên đề xuất
        Row(
          children: [
            Text("Tên đề xuất", style: Golbal.stylelabel),
            Text(" (*)", style: sao),
          ],
        ),
        breakRow,
        Obx(
          () => TextFormField(
            initialValue: controller.model["Title"],
            minLines: 2,
            maxLines: 4,
            maxLength: 500,
            decoration: Golbal.decoration,
            style: Golbal.styleinput,
            onChanged: (String txt) {
              controller.model["Title"] = txt;
            },
            validator: (value) {
              if (value!.isEmpty) {
                return 'Vui lòng nhập tên đề xuất';
              }
              return null;
            },
          ),
        ),
        breakRow,
        //FormD
        Obx(() => formDWidget(null)),
        //Mức độ ưu tiên
        Row(
          children: [
            Text("Mức độ ưu tiên", style: Golbal.stylelabel),
          ],
        ),
        breakRow,
        Obx(
          () => fileCategory(
            "Chọn mức độ",
            controller.mucdodxs,
            "mucdodxs",
            "Uutien",
            "TenUutien",
            "Uutien",
            true,
            false,
          ),
        ),
        breakRow,
        //đề xuất thuộc team
        Row(
          children: [
            Text("Thuộc Team", style: Golbal.stylelabel),
          ],
        ),
        breakRow,
        Obx(
          () => fileCategory(
            "Đề xuất thuộc Team",
            controller.teamdxs,
            "teamdxs",
            "Team_ID",
            "Team_Name",
            "Team_ID",
            true,
            true,
          ),
        ),
        breakRow,
        //Hạn xử lý
        Obx(
          () => controller.model["Form_ID"] != null
              ? Row(
                  children: <Widget>[
                    Expanded(
                        child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text("Ngày lập", style: Golbal.stylelabel),
                        breakRow,
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(
                              color: const Color(0xFFcccccc),
                              width: 1.0,
                            ),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10.0, vertical: 15.0),
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  child: Text(
                                    Golbal.formatDate(
                                        controller.model["Ngaylap"],
                                        "H:i d/m/Y",
                                        nam: true),
                                    style: Golbal.styleinput,
                                  ),
                                ),
                                const Icon(
                                  Feather.calendar,
                                  size: 18.0,
                                )
                              ],
                            ),
                          ),
                        )
                      ],
                    )),
                    const SizedBox(width: 20.0),
                    Expanded(
                        child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text("Hạn xử lý", style: Golbal.stylelabel),
                        breakRow,
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(
                              color: const Color(0xFFcccccc),
                              width: 1.0,
                            ),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10.0, vertical: 15.0),
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                child: Text(
                                  Golbal.formatDate(
                                      controller.model["Dateline"], "H:i d/m/Y",
                                      nam: true),
                                  style: Golbal.styleinput,
                                  textAlign: TextAlign.start,
                                ),
                              ),
                              const Icon(
                                Feather.calendar,
                                size: 18.0,
                              )
                            ],
                          ),
                        ),
                      ],
                    ))
                  ],
                )
              : DateTimePicker(
                  type: DateTimePickerType.dateTimeSeparate,
                  dateMask: 'dd/MM/yyyy',
                  initialValue:
                      controller.datetimeString(controller.model["Dateline"]),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2100),
                  icon: const Icon(Icons.event),
                  dateLabelText: 'Hạn xử lý',
                  timeLabelText: "Giờ",
                  use24HourFormat: true,
                  style: Golbal.styleinput,
                  onChanged: (val) {
                    controller.setValue("Dateline", val);
                  },
                  validator: (val) {
                    return null;
                  },
                  onSaved: (val) {
                    controller.setValue("Dateline", val);
                  },
                ),
        ),
        breakRow,
        // Mô tả
        Row(
          children: [
            Text("Mô tả", style: Golbal.stylelabel),
          ],
        ),
        breakRow,
        Obx(
          () => TextFormField(
            initialValue: controller.model["Mota"],
            minLines: 2,
            maxLines: 4,
            keyboardAppearance: Brightness.light,
            decoration: Golbal.decoration,
            style: Golbal.styleinput,
            onChanged: (String str) {
              controller.model["Mota"] = str;
            },
          ),
        ),
        breakRow,
        //Người duyệt
        Obx(
          () => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (controller.signusers.isNotEmpty) ...[
                Row(
                  children: [
                    Text("Người duyệt", style: Golbal.stylelabel),
                    Text(" (*)", style: sao),
                  ],
                ),
                breakRow,
                MemberRequest(
                  signs: controller.signusers,
                  showMore: true,
                ),
              ] else if (controller.model["IsChangeQT"] == true &&
                  controller.model["Form_ID"] != null) ...[
                breakRow,
                ListTile(
                  onTap: () {
                    controller.model["IsChangedQT"] =
                        !(controller.model["IsChangedQT"] || false);
                  },
                  title: Text(
                    "Thiết lập lại quy trình",
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      color: Golbal.appColor,
                      fontSize: 14.0,
                    ),
                  ),
                  leading: Checkbox(
                    tristate: false,
                    activeColor: const Color(0xFF6dd230),
                    value: controller.model["IsChangedQT"] ?? false,
                    onChanged: (v) {
                      controller.model["IsChangedQT"] = v;
                    },
                  ),
                ),
              ] else if (controller.model["IsChangeQT"] == false ||
                  controller.model["Form_ID"] == null) ...[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //Loại quy trình duyệt
                    Row(
                      children: [
                        Text("Quy trình duyệt", style: Golbal.stylelabel),
                      ],
                    ),
                    breakRow,
                    Obx(
                      () => fileCategory(
                        "Chọn loại trình duyệt",
                        controller.loaiqts,
                        "loaiqts",
                        "IsQuytrinhduyet",
                        "QT_Name",
                        "IsQuytrinhduyet",
                        true,
                        false,
                      ),
                    ),
                    breakRow,
                    Row(
                      children: [
                        Text("Người duyệt", style: Golbal.stylelabel),
                        Text(" (*)", style: sao),
                      ],
                    ),
                    breakRow,
                    Obx(
                      () => chooseUser(
                        controller.nguoiduyets,
                        2,
                        const Color(0xFF00bcd4),
                        Colors.white,
                      ),
                    ),
                  ],
                ),
              ]
            ],
          ),
        ),
        breakRow,
        //Người quản lý
        Row(
          children: [
            Text("Người quản lý", style: Golbal.stylelabel),
          ],
        ),
        breakRow,
        Obx(
          () => chooseUser(
            controller.nguoiquanlys,
            1,
            const Color(0xFF00bcd4),
            Colors.white,
          ),
        ),
        breakRow,
        //Người theo dõi
        Row(
          children: [
            Text("Người theo dõi", style: Golbal.stylelabel),
          ],
        ),
        breakRow,
        Obx(
          () => chooseUser(
            controller.nguoiheodois,
            0,
            const Color(0xFF00bcd4),
            Colors.white,
          ),
        ),
        breakRow,
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text("File đính kèm", style: Golbal.stylelabel),
            const SizedBox(width: 10),
            SizedBox(
              height: 36,
              child: OutlinedButton(
                onPressed: () {
                  controller.openFile();
                },
                child: const Icon(
                  Ionicons.attach_outline,
                ),
              ),
            )
          ],
        ),
        breakRow,
        listFileDA(),
        listFile(),
      ]),
    );
  }

  Widget formDWidget(String? fid) {
    var fds = controller.formD.where((e) => e["IsParent_ID"] == fid).toList();
    if (fds.isEmpty) return const SizedBox.shrink();
    return Wrap(children: fds.map((e) => InputColumn(input: e)).toList());
  }

  Widget fileCategory(String title, RxList<dynamic> datas, String dictionary,
      String id, String name, String key, bool isOne, bool isSearch) {
    controller.defaultDataChon(datas, id, key);
    return InkWell(
      onTap: () {
        FocusScope.of(Get.context!).unfocus();
        showModalCategory(
            title, datas, dictionary, id, name, key, isOne, isSearch);
      },
      child: Container(
        height: 55,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            border: Border.all(color: const Color(0xFFcccccc), width: 1.0)),
        child: Row(
          children: [
            Expanded(
              child: Text(
                datas.firstWhere((e) => e[id] == controller.model[key],
                        orElse: () => {name: ""})[name] ??
                    "",
                style: Golbal.styleinput,
              ),
            ),
            const Icon(Ionicons.chevron_down, color: Colors.black38)
          ],
        ),
      ),
    );
  }

  Future<void> showModalCategory(String title, datas, String dictionary,
      String id, String name, String key, bool isOne, bool isSearch) async {
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
                      controller.searchData(txt, datas, dictionary, name);
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
              child: Obx(
                () => ListView.separated(
                  shrinkWrap: true,
                  itemBuilder: (ct, i) {
                    return Material(
                        color: Colors.transparent,
                        child: ListTile(
                          onTap: () {
                            controller.chooseFilter(datas, i, id, key, isOne);
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
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget chooseUser(List users, int loai, Color bgColor, Color textColor) {
    return InkWell(
      onTap: () {
        FocusScope.of(Get.context!).unfocus();
        controller.showUser(loai);
      },
      child: Container(
        height: 55,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            border: Border.all(color: const Color(0xFFcccccc), width: 1.0)),
        child: ListView.builder(
          itemBuilder: (ct, i) => Container(
            margin: const EdgeInsets.only(right: 5),
            child: Chip(
              label: Text(
                '${users[i]["fullName"]}',
                style: TextStyle(color: textColor, fontSize: 11),
              ),
              avatar: UserAvarta(user: users[i]),
              backgroundColor: bgColor,
              onDeleted: () {
                controller.deleUser(i, loai);
              },
              deleteIcon: const Icon(
                Ionicons.close_circle_outline,
                size: 20,
              ),
              deleteIconColor: textColor,
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            ),
          ),
          itemCount: users.length,
          scrollDirection: Axis.horizontal,
        ),
      ),
    );
  }

  Future<void> showQuytrinh() async {
    // var rs = await showMaterialModalBottomSheet(
    //     context: context,
    //     backgroundColor: Colors.white,
    //     builder: (context) => Container(
    //           height: Golbal.screenSize.height / 2,
    //           padding: const EdgeInsets.all(10.0),
    //           child: ListView.builder(
    //             shrinkWrap: true,
    //             padding: const EdgeInsets.all(5.0),
    //             itemCount: qtdataSource.length,
    //             itemBuilder: (ct, i) {
    //               return ListTile(
    //                 onTap: () {
    //                   var fo = qtdataSource[i];
    //                   Navigator.of(context).pop(fo);
    //                 },
    //                 leading: controller.model["IsQuytrinhduyet"] ==
    //                         qtdataSource[i]["value"]
    //                     ? Icon(AntDesign.check, color: Colors.indigo)
    //                     : Container(width: 0.0, height: 0.0),
    //                 title: Text(
    //                   "${qtdataSource[i]["text"]}",
    //                 ),
    //               );
    //             },
    //           ),
    //         ));
    // if (rs != null) {
    //   controller.model["IsQuytrinhduyet"] = rs["value"];
    //   controller.model["QT_Name"] = rs["text"];
    // }
  }

  Widget listFileDA() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 0.0),
      constraints: BoxConstraints(
        maxHeight: controller.filesDA.length * 60,
      ),
      child: Obx(
        () => ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: controller.filesDA.length,
          itemBuilder: (ct, i) {
            var file = controller.filesDA[i];
            return Card(
              margin: const EdgeInsets.only(bottom: 5.0),
              elevation: 0,
              color: const Color(0xFFf5f5f5),
              child: ListTile(
                leading: Image(
                  image: AssetImage(
                      "assets/file/${file["Dinhdang"].replaceAll('.', '')}.png"),
                  width: 24,
                  height: 24,
                  fit: BoxFit.contain,
                ),
                title: Text(file["Tenfile"]),
                trailing: SizedBox(
                  width: 30,
                  child: TextButton(
                    onPressed: () {
                      controller.deleteFileDA(i);
                    },
                    child: const Icon(
                      Ionicons.trash_outline,
                      color: Colors.black54,
                      size: 16,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget listFile() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 0.0),
      constraints: BoxConstraints(
        maxHeight: controller.files.value.length * 60,
      ),
      child: Obx(
        () => ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: controller.files.value.length,
          itemBuilder: (ct, i) {
            PlatformFile file = controller.files.value[i];
            return Card(
              margin: const EdgeInsets.only(bottom: 5.0),
              elevation: 0,
              color: const Color(0xFFf5f5f5),
              child: ListTile(
                leading: Image(
                  image: AssetImage(
                      "assets/file/${file.extension!.replaceAll('.', '')}.png"),
                  width: 24,
                  height: 24,
                  fit: BoxFit.contain,
                ),
                title: Text(file.name),
                trailing: SizedBox(
                  width: 30,
                  child: TextButton(
                    onPressed: () {
                      controller.deleteFile(i);
                    },
                    child: const Icon(
                      Ionicons.trash_outline,
                      color: Colors.black54,
                      size: 16,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context)
          .copyWith(textScaleFactor: Golbal.textScaleFactor),
      child: KeyboardDismisser(
        child: Scaffold(
          backgroundColor: const Color(0xffffffff),
          appBar: AppBar(
            backgroundColor: Golbal.appColorD,
            elevation: 1.0,
            iconTheme: IconThemeData(color: Golbal.iconColor),
            // leading: IconButton(
            //   icon: Icon(
            //     Ionicons.close,
            //     color: Colors.black.withOpacity(0.5),
            //   ),
            //   onPressed: () {
            //     controller.goBack(true);
            //   },
            // ),
            title: Text(controller.getdata["title"] ?? "",
                style: TextStyle(
                    color: Golbal.titleappColor, fontWeight: FontWeight.bold)),
            centerTitle: true,
            systemOverlayStyle: Golbal.systemUiOverlayStyle1,
            titleSpacing: 0,
          ),
          body: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Obx(
              () => controller.loading.value == true
                  ? const SizedBox.shrink()
                  : Column(
                      children: [
                        Expanded(
                          child: SingleChildScrollView(
                            child: formWidget(),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Container(
                          width: 150,
                          height: 80,
                          padding: const EdgeInsets.all(20),
                          child: ElevatedButton(
                            onPressed: () {
                              controller.saveRequest();
                            },
                            child: const Text("Cập nhật",
                                style: TextStyle(color: Colors.white)),
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  const Color(0xFF2196f3)),
                            ),
                          ),
                        )
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
