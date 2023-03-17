import 'package:date_time_picker/date_time_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import '../../../../utils/golbal/golbal.dart';
import '../../component/use/avatar.dart';
import 'adlichcontroller.dart';

class AddLich extends StatelessWidget {
  final AddLichController controller = Get.put(AddLichController());
  AddLich({Key? key}) : super(key: key);

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
              margin: EdgeInsets.zero,
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
              margin: EdgeInsets.zero,
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
          //Nội dung
          Row(
            children: [
              Text("Nội dung", style: Golbal.stylelabel),
              Text(" (*)", style: sao),
            ],
          ),
          breakRow,
          Obx(
            () => TextFormField(
              initialValue: controller.model["Noidung"],
              minLines: 2,
              maxLines: 4,
              decoration: Golbal.decoration,
              style: Golbal.styleinput,
              onChanged: (String txt) => controller.model["Noidung"] = txt,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Vui lòng nhập nội dung';
                }
                return null;
              },
            ),
          ),
          //Thời gian
          breakRow,
          Row(
            children: [
              Text("Ngày bắt đầu", style: Golbal.stylelabel),
              Text(" (*)", style: sao),
            ],
          ),
          breakRow,
          Obx(
            () => DateTimePicker(
              type: DateTimePickerType.dateTimeSeparate,
              dateMask: 'dd/MM/yyyy',
              initialValue:
                  controller.datetimeString(controller.model["BatdauNgay"]),
              firstDate: DateTime(2000),
              lastDate: DateTime(2100),
              icon: const Icon(Icons.event),
              use24HourFormat: true,
              style: Golbal.styleinput,
              onChanged: (val) {
                controller.setValue("BatdauNgay", val);
              },
              validator: (val) {
                return null;
              },
              onSaved: (val) {
                controller.setValue("BatdauNgay", val);
              },
            ),
          ),
          breakRow,
          Row(
            children: [
              Text("Ngày kết thúc", style: Golbal.stylelabel),
              Text(" (*)", style: sao),
            ],
          ),
          breakRow,
          Obx(
            () => DateTimePicker(
              type: DateTimePickerType.dateTimeSeparate,
              dateMask: 'dd/MM/yyyy',
              initialValue:
                  controller.datetimeString(controller.model["KethucNgay"]),
              firstDate: DateTime(2000),
              lastDate: DateTime(2100),
              icon: const Icon(Icons.event),
              use24HourFormat: true,
              style: Golbal.styleinput,
              onChanged: (val) {
                controller.setValue("KethucNgay", val);
              },
              validator: (val) {
                return null;
              },
              onSaved: (val) {
                controller.setValue("KethucNgay", val);
              },
            ),
          ),
          breakRow,
          //Chủ trì
          Text("Người chủ trì", style: Golbal.stylelabel),
          breakRow,
          Obx(() => chooseUser(
              controller.chutris, 1, const Color(0xFF2196f3), Colors.white)),
          breakRow,
          //Tham dự
          Text("Người tham dự", style: Golbal.stylelabel),
          breakRow,
          Obx(() => chooseUser(
              controller.thamgias, 2, const Color(0xFF00bcd4), Colors.white)),
          breakRow,
          //Phòng họp
          Row(
            children: [
              Text("Phòng họp", style: Golbal.stylelabel),
              Text(" (*)", style: sao),
            ],
          ),
          breakRow,
          Obx(
            () => fileCategory(
              "Chọn phòng họp",
              controller.phonghops,
              "phonghops",
              "Diadiem_ID",
              "Diadiem_Ten",
              "Diadiem_ID",
              true,
              true,
            ),
          ),
          breakRow,
          //Số người tham dự
          Text("Số người tham dự", style: Golbal.stylelabel),
          breakRow,
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.only(bottom: 5.0),
                  color: Colors.white,
                  child: Obx(
                    () => TextFormField(
                      initialValue:
                          controller.model["Songuoithamdu"].toString(),
                      keyboardAppearance: Brightness.light,
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly
                      ],
                      decoration: Golbal.decoration,
                      style: Golbal.styleinput,
                      onSaved: (String? str) {
                        controller.model["Songuoithamdu"] = str;
                      },
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Obx(
                  () => ListTile(
                    onTap: () {
                      controller.model["IsImportant"] =
                          !(controller.model["IsImportant"] ?? false);
                      controller.setValue(
                          "IsImportant", controller.model["IsImportant"]);
                    },
                    title: Text(
                      "Lịch quan trọng",
                      style: Golbal.styleinput,
                    ),
                    leading: Checkbox(
                      tristate: false,
                      value: controller.model["IsImportant"] ?? false,
                      onChanged: (val) {
                        controller.setValue("IsImportant", val);
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
          breakRow,
          //Hình thức họp
          Text("Hình thức họp", style: Golbal.stylelabel),
          breakRow,
          Obx(
            () => Row(
              children: [0, 1]
                  .map(
                    (int index) => Expanded(
                      child: RadioListTile<int>(
                        selected: controller.model["Kieulich"] ==
                            (controller.model["Kieulich"] ?? 0),
                        value: index,
                        groupValue: controller.model["Kieulich"],
                        title: Text(
                          index == 1 ? "Họp trực tuyến" : "Họp bình thường",
                          style: Golbal.styleinput,
                        ),
                        onChanged: (int? value) {
                          if (value != null) {
                            controller.model["Kieulich"] = value;
                          }
                        },
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
          breakRow,
          //Kiểu lặp
          Row(
            children: [
              Text("Kiểu lặp", style: Golbal.stylelabel),
            ],
          ),
          breakRow,
          Obx(
            () => fileCategory(
              "Chọn kiểu lặp",
              controller.kieulaps,
              "kieulaps",
              "Laplich",
              "Laplich_Ten",
              "Laplich",
              true,
              false,
            ),
          ),
          if (controller.model["Laplich"] != null &&
              controller.model["Laplich"] != 0) ...[
            breakRow,
            Row(
              children: <Widget>[
                Expanded(
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Text(
                            "Số ${controller.kieulaps.firstWhere((e) => e["Laplich"] == controller.model["Laplich"], orElse: () => {
                                  "donvi": ""
                                })["donvi"]} lặp",
                            style: Golbal.stylelabel,
                          ),
                        ],
                      ),
                      breakRow,
                      Container(
                        padding: const EdgeInsets.only(bottom: 5.0),
                        color: Colors.white,
                        child: Obx(
                          () => TextFormField(
                            initialValue: controller.model["Solap"].toString(),
                            keyboardAppearance: Brightness.light,
                            keyboardType: TextInputType.number,
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            decoration: Golbal.decoration,
                            style: Golbal.styleinput,
                            onSaved: (String? str) {
                              controller.model["Solap"] = str;
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Text(
                            "Số lần lặp",
                            style: Golbal.stylelabel,
                          ),
                        ],
                      ),
                      breakRow,
                      Container(
                        padding: const EdgeInsets.only(bottom: 5.0),
                        color: Colors.white,
                        child: Obx(
                          () => TextFormField(
                            initialValue:
                                controller.model["Solanlap"].toString(),
                            keyboardAppearance: Brightness.light,
                            keyboardType: TextInputType.number,
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            decoration: Golbal.decoration,
                            style: Golbal.styleinput,
                            onSaved: (String? str) {
                              controller.model["Solanlap"] = str;
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],

          breakRow,
          //Người được mời
          Row(
            children: [
              Text("Người được mời", style: Golbal.stylelabel),
            ],
          ),
          breakRow,
          Obx(
            () => TextFormField(
              initialValue: controller.model["Thamdu"],
              minLines: 2,
              maxLines: 4,
              decoration: Golbal.decoration,
              style: Golbal.styleinput,
              onChanged: (String txt) => controller.model["Thamdu"] = txt,
            ),
          ),
          breakRow,
          //Tham dự
          Text("Phòng ban tham gia", style: Golbal.stylelabel),
          breakRow,
          Obx(() => choosePhongban(
              controller.phongbans, 1, const Color(0xFF00bcd4), Colors.white)),
          breakRow,
          //Chuẩn bị
          Row(
            children: [
              Text("Chuẩn bị", style: Golbal.stylelabel),
            ],
          ),
          breakRow,
          Obx(
            () => TextFormField(
              initialValue: controller.model["Chuanbi"],
              minLines: 2,
              maxLines: 4,
              decoration: Golbal.decoration,
              style: Golbal.styleinput,
              onChanged: (String txt) => controller.model["Chuanbi"] = txt,
            ),
          ),
          breakRow,
          //Ghi chú
          Row(
            children: [
              Text("ghi chú", style: Golbal.stylelabel),
            ],
          ),
          breakRow,
          Obx(
            () => TextFormField(
              initialValue: controller.model["Ghichu"],
              minLines: 2,
              maxLines: 4,
              decoration: Golbal.decoration,
              style: Golbal.styleinput,
              onChanged: (String txt) => controller.model["Ghichu"] = txt,
            ),
          ),
          breakRow,
          breakRow,
          //File đính kèm
          Row(
            children: [
              const Spacer(),
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
          if (controller.filesDA.isNotEmpty) ...[
            Obx(() => listFileDA()),
          ],
          if (controller.files.value.isNotEmpty) ...[
            Obx(() => listFile()),
          ],
        ],
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
              () => (controller.loading.value == true)
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
                              controller.saveCalendar();
                            },
                            child: const Text("Cập nhật",
                                style: TextStyle(color: Colors.white)),
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  const Color(0xFF2196f3)),
                            ),
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
