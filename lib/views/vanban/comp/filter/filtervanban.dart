import 'package:date_time_format/date_time_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:soe/utils/golbal/golbal.dart';

import 'filtervanabancontroller.dart';

class FilterVanban extends StatelessWidget {
  final FilterVanbanController controller = Get.put(FilterVanbanController());
  FilterVanban({
    Key? key,
  }) : super(key: key);

  Widget fileVB(IconData icon, String title, RxList<dynamic> datas, String id,
      String name, String key, bool isOne) {
    var chons = datas.where((p0) => p0["chon"] == true).toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          onTap: () {
            showModalFilterVanban(title, datas, id, name, key, isOne);
          },
          leading: Icon(icon),
          title:
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          trailing: const Icon(Feather.chevron_right),
        ),
        if (chons.isNotEmpty)
          InkWell(
              onTap: () {
                showModalFilterVanban(title, datas, id, name, key, isOne);
              },
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                child: Wrap(
                  children: chons
                      .map((e) => Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 2, horizontal: 5),
                            child: Chip(
                              onDeleted: () {
                                controller.deleChon(datas, e, id);
                              },
                              deleteIcon: const Icon(Ionicons.close,
                                  color: Colors.black54),
                              backgroundColor: const Color(0xFFEFF8FF),
                              label: Text(e[name]),
                            ),
                          ))
                      .toList(),
                ),
              ))
      ],
    );
  }

  void showModalFilterVanban(
      String title, datas, String id, String name, String key, bool isOne) {
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
            const SizedBox(height: 10),
            Expanded(
              child: Obx(() => ListView.separated(
                    shrinkWrap: true,
                    itemBuilder: (ct, i) {
                      return Material(
                          color: Colors.transparent,
                          child: ListTile(
                            onTap: () {
                              controller.chonFilter(datas, i, isOne);
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

  Widget ngayVB() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          onTap: controller.chonDate,
          leading: const Icon(Feather.calendar),
          title: const Text("Ngày văn bản",
              style: TextStyle(fontWeight: FontWeight.bold)),
          trailing: const Icon(Feather.chevron_right),
        ),
        if (controller.startDate.value != null ||
            controller.endDate.value != null)
          Padding(
            padding: const EdgeInsets.only(left: 70, top: 20, bottom: 20),
            child: Wrap(
              children: [
                Obx(
                  () => controller.startDate.value != null
                      ? Text(
                          DateTimeFormat.format(
                              DateTime.parse(controller.startDate.value!
                                  .toIso8601String()),
                              format: 'd/m/Y'),
                          style: TextStyle(
                              color: Golbal.appColor,
                              fontWeight: FontWeight.bold))
                      : const SizedBox.shrink(),
                ),
                const Text(" - "),
                Obx(
                  () => controller.endDate.value != null
                      ? Text(
                          DateTimeFormat.format(
                              DateTime.parse(
                                  controller.endDate.value!.toIso8601String()),
                              format: 'd/m/Y'),
                          style: TextStyle(
                              color: Golbal.appColor,
                              fontWeight: FontWeight.bold))
                      : const SizedBox.shrink(),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget tukhoaVB() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          onTap: () {
            controller.showTukhoa.value = !controller.showTukhoa.value;
          },
          leading: const Icon(Feather.tag),
          title: const Text("Từ khoá",
              style: TextStyle(fontWeight: FontWeight.bold)),
          trailing: const Icon(Feather.chevron_right),
        ),
        Obx(() => controller.showTukhoa.value
            ? Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  autofocus: true,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Color(0xFFcccccc), width: 1.0)),
                    enabledBorder: const OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Color(0xFFcccccc), width: 1.0)),
                    hintText: 'Nhập từ khoá',
                    hintStyle: const TextStyle(
                      color: Color(0xFFcccccc),
                    ),
                    fillColor: const Color(0xFFcccccc),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                          color: Color(0xFFcccccc), width: 1.0),
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                  ),
                  style: Golbal.styleinput,
                  onChanged: (String txt) => controller.s = txt,
                ),
              )
            : const SizedBox.shrink())
      ],
    );
  }

  //Function
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          return true;
        },
        child: MediaQuery(
            data: MediaQuery.of(context)
                .copyWith(textScaleFactor: Golbal.textScaleFactor),
            child: Scaffold(
              backgroundColor: const Color(0xffffffff),
              appBar: AppBar(
                backgroundColor: Golbal.appColorD,
                elevation: 1.0,
                iconTheme: IconThemeData(color: Golbal.iconColor),
                title: Text("Lọc kết quả",
                    style: TextStyle(
                        color: Golbal.titleappColor,
                        fontWeight: FontWeight.bold)),
                centerTitle: true,
                actions: [
                  IconButton(
                      onPressed: controller.clearAdv,
                      icon: const Icon(Ionicons.refresh_circle_outline))
                ],
                systemOverlayStyle: Golbal.systemUiOverlayStyle,
              ),
              body: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                      child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Obx(() => fileVB(
                            Feather.file_text,
                            "Chọn nhóm văn bản",
                            controller.nhoms,
                            "NhomvanbanID",
                            "tenNhom",
                            "groups",
                            false)),
                        const Divider(
                          height: 1,
                        ),
                        Obx(() => fileVB(
                            Feather.filter,
                            "Chọn trạng thái văn bản",
                            controller.trangthais,
                            "vanBanTrangthai_ID",
                            "vanBanTrangthai_Ten",
                            "status",
                            false)),
                        const Divider(
                          height: 1,
                        ),
                        Obx(() => ngayVB()),
                        const Divider(
                          height: 1,
                        ),
                        Obx(() => fileVB(
                            Feather.map_pin,
                            "Chọn nơi ban hành",
                            controller.noibanhanhs,
                            "noiBanHanhID",
                            "tenNoiBanHanh",
                            "fields",
                            false)),
                        const Divider(
                          height: 1,
                        ),
                        Obx(() => fileVB(
                            Feather.user,
                            "Chọn người gửi văn bản",
                            controller.nguoiguis,
                            "NhanSu_ID",
                            "fullName",
                            "senders",
                            false)),
                        const Divider(
                          height: 1,
                        ),
                        Obx(() => fileVB(
                            Feather.tag,
                            "Chọn lĩnh vực văn bản",
                            controller.linhvucs,
                            "linhvucID",
                            "tenLinhVuc",
                            "fields",
                            false)),
                        const Divider(
                          height: 1,
                        ),
                        Obx(() => fileVB(
                            Feather.tag,
                            "Chọn loại văn bản",
                            controller.arrTypes,
                            "value",
                            "text",
                            "type",
                            true)),
                        const Divider(
                          height: 1,
                        ),
                        tukhoaVB(),
                        const SizedBox(height: 10),
                        Container(
                            color: const Color(0xFFeeeeee),
                            padding: const EdgeInsets.symmetric(
                                vertical: 15, horizontal: 20),
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Sắp xếp văn bản",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Golbal.titleColor),
                            )),
                        Obx(() => fileVB(
                            MaterialIcons.sort_by_alpha,
                            "Sắp xếp theo",
                            controller.arrSorts,
                            "value",
                            "text",
                            "type",
                            true)),
                        const Divider(
                          height: 1,
                        ),
                      ],
                    ),
                  )),
                  const SizedBox(height: 20),
                  SafeArea(
                    child: Center(
                      child: Container(
                        width: Golbal.screenSize.width - 50,
                        height: 70,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        child: ElevatedButton.icon(
                          icon: const Icon(Feather.search),
                          onPressed: () {
                            controller.apDung();
                          },
                          label: const Text("Áp dụng",
                              style: TextStyle(color: Colors.white)),
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                                Golbal.appColor),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )));
  }
}
