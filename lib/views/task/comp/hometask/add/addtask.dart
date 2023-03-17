import 'package:date_time_format/date_time_format.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:pattern_formatter/pattern_formatter.dart';

import '../../../../../utils/golbal/golbal.dart';
import '../../../../component/use/avatar.dart';
import '../../../../component/use/mohinh/caymohinh.dart';
import 'addtaskcontroller.dart';

class AddTask extends StatelessWidget {
  final AddTaskController controller = Get.put(AddTaskController());
  AddTask({Key? key}) : super(key: key);

  Widget formWidget() {
    var breakRow = const SizedBox(height: 10);
    TextStyle sao = const TextStyle(
      color: Colors.red,
      fontSize: 13,
      fontWeight: FontWeight.w500,
    );
    return Form(
      key: controller.formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text("Tên công việc", style: Golbal.stylelabel),
              Text(" (*)", style: sao),
            ],
          ),
          breakRow,
          Obx(
            () => TextFormField(
              initialValue: controller.model["CongviecTen"],
              minLines: 2,
              maxLines: 4,
              decoration: Golbal.decoration,
              style: Golbal.styleinput,
              onChanged: (String txt) => controller.model["CongviecTen"] = txt,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Vui lòng nhập tên công việc';
                }
                return null;
              },
            ),
          ),
          breakRow,
          Text("Thời gian", style: Golbal.stylelabel),
          breakRow,
          ngaycongviecWidget(),
          breakRow,
          Text("Thuộc dự án", style: Golbal.stylelabel),
          breakRow,
          Obx(() => fileCategory("Chọn dự án", controller.duans, "duans",
              "DuanID", "TenDuan", "DuanID", true, true)),
          breakRow,
          Text("Nhóm", style: Golbal.stylelabel),
          breakRow,
          Obx(() => fileCategory(
              "Chọn nhóm",
              controller.nhomscongviecs,
              "nhomscongviecs",
              "NhomCongviecID",
              "Tennhom",
              "NhomCongviecID",
              true,
              true)),
          breakRow,
          Text("Người giao", style: Golbal.stylelabel),
          breakRow,
          Obx(() => chooseUser(
              controller.giaoviecs, 1, const Color(0xFF2196f3), Colors.white)),
          breakRow,
          Text("Người thực hiện", style: Golbal.stylelabel),
          breakRow,
          Obx(() => chooseUser(
              controller.thuchiens, 2, const Color(0xFF00bcd4), Colors.white)),
          breakRow,
          Text("Người theo dõi", style: Golbal.stylelabel),
          breakRow,
          Obx(() => chooseUser(
              controller.theodois, 3, const Color(0xFFCCADD7), Colors.white)),
          breakRow,
          Obx(
            () => Row(
              children: [
                Checkbox(
                    tristate: false,
                    value: controller.model["YeucauReview"] ?? false,
                    onChanged: (val) {
                      controller.setValue("YeucauReview", val);
                    }),
                InkWell(
                    onTap: (() {
                      controller.model["YeucauReview"] =
                          !(controller.model["YeucauReview"] ?? false);
                    }),
                    child: Text("Có đánh giá", style: Golbal.stylelabel)),
                const Spacer(),
                Checkbox(
                    tristate: false,
                    value: controller.model["IsDeadline"] ?? false,
                    onChanged: (val) {
                      controller.setValue("IsDeadline", val);
                    }),
                InkWell(
                    onTap: (() {
                      controller.model["IsDeadline"] =
                          !(controller.model["IsDeadline"] ?? false);
                    }),
                    child: Text("Có hạn xử lý", style: Golbal.stylelabel)),
                const Spacer(),
                Checkbox(
                    tristate: false,
                    value: controller.model["Uutien"] ?? false,
                    onChanged: (val) {
                      controller.setValue("Uutien", val);
                    }),
                InkWell(
                    onTap: (() {
                      controller.model["Uutien"] =
                          !(controller.model["Uutien"] ?? false);
                    }),
                    child: Text("Ưu tiên", style: Golbal.stylelabel))
              ],
            ),
          ),
          breakRow,
          Text("Trọng số", style: Golbal.stylelabel),
          breakRow,
          Obx(() => fileCategory("Chọn trọng số", controller.trongsos,
              "trongsos", "TrongsoMa", "TrongsoTen", "Trongso", true, false)),
          breakRow,
          Text("Trạng thái", style: Golbal.stylelabel),
          breakRow,
          Obx(() => fileCategory(
              "Chọn trạng thái",
              controller.ttcongviecs,
              "ttcongviecs",
              "TrangthaiID",
              "TrangthaiTen",
              "Trangthai",
              true,
              false)),
          breakRow,
          breakRow,
          Row(
            children: [
              Text("STT", style: Golbal.stylelabel),
              const SizedBox(width: 10),
              SizedBox(
                width: 100,
                child: TextFormField(
                  initialValue: controller.model["STT"].toString(),
                  decoration: Golbal.decoration,
                  keyboardType: TextInputType.number,
                  inputFormatters: [ThousandsFormatter()],
                  style: Golbal.styleinput,
                  onChanged: (String txt) => controller.model["STT"] = txt,
                ),
              ),
              const Spacer(),
              const SizedBox(width: 10),
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
          breakRow,
          ExpansionTile(
              leading: const Icon(
                Ionicons.information_circle_outline,
              ),
              title: const Text(
                "Thông tin khác",
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
              expandedCrossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Mô tả", style: Golbal.stylelabel),
                breakRow,
                Obx(
                  () => TextFormField(
                    initialValue: controller.model["Mota"],
                    minLines: 3,
                    maxLines: 54,
                    decoration: Golbal.decoration,
                    style: Golbal.styleinput,
                    onChanged: (String txt) => controller.model["Mota"] = txt,
                  ),
                ),
                breakRow,
                Text("Mục tiêu", style: Golbal.stylelabel),
                breakRow,
                Obx(
                  () => TextFormField(
                    initialValue: controller.model["Muctieu"],
                    minLines: 3,
                    maxLines: 54,
                    decoration: Golbal.decoration,
                    style: Golbal.styleinput,
                    onChanged: (String txt) =>
                        controller.model["Muctieu"] = txt,
                  ),
                ),
                breakRow,
                Text("Khó khăn, vướng mắc", style: Golbal.stylelabel),
                breakRow,
                Obx(
                  () => TextFormField(
                    initialValue: controller.model["Khokhan"],
                    minLines: 3,
                    maxLines: 54,
                    decoration: Golbal.decoration,
                    style: Golbal.styleinput,
                    onChanged: (String txt) =>
                        controller.model["Khokhan"] = txt,
                  ),
                ),
                breakRow,
                Text("Đề xuất", style: Golbal.stylelabel),
                breakRow,
                Obx(
                  () => TextFormField(
                    initialValue: controller.model["Dexuat"],
                    minLines: 3,
                    maxLines: 54,
                    decoration: Golbal.decoration,
                    style: Golbal.styleinput,
                    onChanged: (String txt) => controller.model["Dexuat"] = txt,
                  ),
                ),
                breakRow,
                Text("Công việc của phòng", style: Golbal.stylelabel),
                breakRow,
                //chonPhong(),
                Obx(() => choosePhongban(controller.phongbans, 1,
                    const Color(0xFF00bcd4), Colors.white)),
                breakRow,
                Text("Kích hoạt bảo mật", style: Golbal.stylelabel),
                breakRow,
                Obx(() => Switch(
                      value: controller.model["Baomat"] ?? false,
                      onChanged: (value) {
                        controller.model["Baomat"] = value;
                      },
                    )),
              ])
        ],
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

  Widget choosePhongban(
      List phongbans, int loai, Color bgColor, Color textColor) {
    return InkWell(
      onTap: () {
        FocusScope.of(Get.context!).unfocus();
        controller.showPhongban(loai);
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
                '${phongbans[i]["tenPhongban"]}',
                style: TextStyle(color: textColor, fontSize: 11),
              ),
              backgroundColor: bgColor,
              onDeleted: () {
                controller.delePhongban(i, loai);
              },
              deleteIcon: const Icon(
                Ionicons.close_circle_outline,
                size: 20,
              ),
              deleteIconColor: textColor,
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            ),
          ),
          itemCount: phongbans.length,
          scrollDirection: Axis.horizontal,
        ),
      ),
    );
  }

  Widget chonPhong() {
    return InkWell(
      onTap: () {
        showModalPhong();
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
              child: Obx(() => controller.model["tenPhongbanen"] == null
                  ? const SizedBox.shrink()
                  : Text(controller.model["tenPhongbanen"])),
            ),
            const Icon(Ionicons.chevron_down, color: Colors.black38)
          ],
        ),
      ),
    );
  }

  Future<void> showModalPhong() async {
    FocusScope.of(Get.context!).unfocus();
    var rs = await showCupertinoModalBottomSheet(
      context: Get.context!,
      builder: (context) => Container(
        color: Colors.white,
        height: MediaQuery.of(context).size.height * 0.8,
        child: CayMohinh(isone: true),
      ),
    );
    if (rs != null) {
      controller.model["Phongban_ID"] = rs["Phongban_ID"];
      controller.model["tenPhongbanen"] = rs["tenPhongbanen"];
    }
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

  Widget ngaycongviecWidget() {
    return InkWell(
        onTap: controller.chonDate,
        child: Container(
          width: double.infinity,
          height: 45,
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              border: Border.all(color: const Color(0xFFcccccc), width: 1.0)),
          child: Row(
            children: [
              Obx(
                () => controller.model["NgayBatDau"] != null
                    ? Text(
                        DateTimeFormat.format(
                            DateTime.parse(controller.model["NgayBatDau"]!),
                            format: 'd/m/Y'),
                        style: Golbal.styleinput)
                    : const SizedBox.shrink(),
              ),
              Obx(() => controller.model["NgayBatDau"] != null ||
                      controller.model["NgayKetThuc"] != null
                  ? const Text(" - ")
                  : const SizedBox.shrink()),
              Obx(
                () => controller.model["NgayKetThuc"] != null
                    ? Text(
                        DateTimeFormat.format(
                            DateTime.parse(controller.model["NgayKetThuc"]!),
                            format: 'd/m/Y'),
                        style: Golbal.styleinput)
                    : const SizedBox.shrink(),
              ),
              const Spacer(),
              const Icon(FontAwesome.calendar_check_o, color: Colors.black38)
            ],
          ),
        ));
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
              child: Obx(() => ListView.separated(
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
                  )),
            ),
          ],
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
                        Obx(
                          () => Expanded(
                            child: SingleChildScrollView(
                              child: formWidget(),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Container(
                          width: 150,
                          height: 80,
                          padding: const EdgeInsets.all(20),
                          child: ElevatedButton(
                            onPressed: controller.saveTask,
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
