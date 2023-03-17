import 'package:date_time_format/date_time_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:soe/utils/golbal/golbal.dart';
import 'package:soe/views/task/comp/project/filter/filterprojectcontroller.dart';

class FilterProject extends StatelessWidget {
  final FilterProjectController controller = Get.put(FilterProjectController());
  FilterProject({Key? key}) : super(key: key);

  Widget tileRQ(IconData icon, String title, RxList<dynamic> datas, String id,
      String name, String key, bool isOne) {
    var chons = datas.where((p0) => p0["chon"] == true).toList();
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: <
        Widget>[
      ListTile(
        onTap: () {
          showModalFilterRequest(title, datas, id, name, key, isOne);
        },
        leading: Icon(icon),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        trailing: const Icon(Feather.chevron_right),
      ),
      if (chons.isNotEmpty)
        InkWell(
          onTap: () {
            showModalFilterRequest(title, datas, id, name, key, isOne);
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
                          deleteIcon:
                              const Icon(Ionicons.close, color: Colors.black54),
                          backgroundColor: const Color(0xFFEFF8FF),
                          label: Text(e[name]),
                        ),
                      ))
                  .toList(),
            ),
          ),
        ),
    ]);
  }

  Widget createdateRQ() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          onTap: controller.chonCreateDate,
          leading: const Icon(Feather.calendar),
          title: const Text("Ngày lập",
              style: TextStyle(fontWeight: FontWeight.bold)),
          trailing: const Icon(Feather.chevron_right),
        ),
        if (controller.startCreateDate.value != null ||
            controller.endCreateDate.value != null)
          Padding(
            padding: const EdgeInsets.only(left: 70, top: 20, bottom: 20),
            child: Wrap(
              children: [
                Obx(
                  () => controller.startCreateDate.value != null
                      ? Text(
                          DateTimeFormat.format(
                              DateTime.parse(controller.startCreateDate.value!
                                  .toIso8601String()),
                              format: 'd/m/Y'),
                          style: TextStyle(
                            color: Golbal.appColor,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      : const SizedBox.shrink(),
                ),
                const Text(" - "),
                Obx(
                  () => controller.endCreateDate.value != null
                      ? Text(
                          DateTimeFormat.format(
                              DateTime.parse(controller.endCreateDate.value!
                                  .toIso8601String()),
                              format: 'd/m/Y'),
                          style: TextStyle(
                            color: Golbal.appColor,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      : const SizedBox.shrink(),
                ),
              ],
            ),
          ),
      ],
    );
  }

  void showModalFilterRequest(
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

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
        data: MediaQuery.of(context)
            .copyWith(textScaleFactor: Golbal.textScaleFactor),
        child: Scaffold(
          backgroundColor: const Color(0xffffffff),
          appBar: AppBar(
            backgroundColor: Golbal.appColorD,
            elevation: 1.0,
            iconTheme: IconThemeData(color: Golbal.iconColor),
            title: Text(
              "Lọc kết quả",
              style: TextStyle(
                color: Golbal.titleappColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            centerTitle: true,
            actions: [
              IconButton(
                onPressed: controller.clearAdv,
                icon: const Icon(Ionicons.refresh_circle_outline),
              ),
            ],
          ),
          body: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        Obx(
                          () => tileRQ(
                            FontAwesome.building_o,
                            "Chọn đơn vị",
                            controller.congtys,
                            "Congty_ID",
                            "tenCongty",
                            "congtys",
                            false,
                          ),
                        ),
                        const Divider(height: 1),
                        Obx(
                          () => tileRQ(
                            Feather.tag,
                            "Chọn nhóm dự án",
                            controller.nhoms,
                            "NhomDuanID",
                            "TenNhomDuan",
                            "nhoms",
                            false,
                          ),
                        ),
                        const Divider(height: 1),
                        Obx(
                          () => tileRQ(
                            Feather.tag,
                            "Chọn nhóm trạng thái",
                            controller.status,
                            "Trangthai",
                            "title",
                            "status",
                            false,
                          ),
                        ),
                        const Divider(height: 1),
                        Obx(() => createdateRQ()),
                        const Divider(height: 1),
                        Container(
                            color: const Color(0xFFeeeeee),
                            padding: const EdgeInsets.symmetric(
                                vertical: 15, horizontal: 20),
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Sắp xếp đề xuất",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Golbal.titleColor),
                            )),
                        Obx(
                          () => tileRQ(
                            MaterialIcons.sort_by_alpha,
                            "Sắp xếp theo",
                            controller.sortProjects,
                            "value",
                            "text",
                            "type",
                            true,
                          ),
                        ),
                        const Divider(height: 1),
                      ],
                    ),
                  ),
                ),
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
                          backgroundColor:
                              MaterialStateProperty.all<Color>(Golbal.appColor),
                        ),
                      ),
                    ),
                  ),
                ),
              ]),
        ));
  }
}
