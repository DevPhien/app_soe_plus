import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';

import '../../../../utils/golbal/golbal.dart';
import 'dangkylichcontroller.dart';

class DangkylichPage extends StatelessWidget {
  final DangkylichController controller = Get.put(DangkylichController());

  DangkylichPage({Key? key}) : super(key: key);

  Color renderColor(e) {
    if (e["chon"] == true) return Colors.brown;
    if (e["maunen"] != null) {
      return HexColor(e["maunen"]);
    }
    return const Color(0xFFB9B7B7);
  }

  Widget thuWidget() {
    const border = BorderSide(width: 1.0, color: Colors.white);
    return Row(
      children: controller.thuvis
          .map((e) => Expanded(
              child: Container(
                  decoration: BoxDecoration(
                      color: Golbal.appColor,
                      border: const Border(
                          left: border, top: border, bottom: border)),
                  height: 45,
                  child: Center(
                    child: Text(
                      e,
                      style: const TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ))))
          .toList(),
    );
  }

  Widget rowWidget(List item) {
    const border = BorderSide(width: 1.0, color: Color(0xFFeeeeee));
    return Row(
      children: item
          .map((e) => Expanded(
                  child: InkWell(
                onLongPress: () {
                  controller.chonAllItem(item, e);
                },
                onTap: () {
                  if (e["dayngay"] != null) controller.chonItem(e);
                },
                child: Container(
                    decoration: BoxDecoration(
                        color: renderColor(e),
                        border: const Border(left: border, bottom: border)),
                    height: 45,
                    child: Stack(
                      children: [
                        Center(
                          child: Column(
                            children: [
                              const SizedBox(height: 4),
                              Text(
                                "${e["dayngay"] ?? ""}",
                                style: TextStyle(
                                    color: e["mauchu"] != null
                                        ? HexColor(e["mauchu"])
                                        : Colors.black87,
                                    fontWeight: FontWeight.w600),
                              ),
                              if (e["tenca"] != null)
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        top: 4, left: 1, right: 1),
                                    child: Text(e["tenca"],
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            color: e["mauchu"] != null
                                                ? HexColor(e["mauchu"])
                                                : Colors.black87,
                                            fontSize: 11)),
                                  ),
                                ),
                              const SizedBox(height: 4),
                            ],
                          ),
                        ),
                        if (e["chon"] == true)
                          const Center(
                              child: Icon(Icons.check_circle,
                                  color: Colors.yellow))
                      ],
                    )),
              )))
          .toList(),
    );
  }

  Widget ngayWidget() {
    return Obx(() => Column(
        children:
            controller.dtngays.map((element) => rowWidget(element)).toList()));
  }

  void configCalamviec() {
    Get.bottomSheet((BottomSheet(
        onClosing: () {},
        enableDrag: false,
        builder: (_) => Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Row(
                    children: const [
                      Icon(Icons.date_range_outlined),
                      SizedBox(width: 5),
                      Text(
                        "Cập nhật ca làm việc",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                      child: SingleChildScrollView(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const Text(
                            "Chọn ca làm",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 10),
                          Center(
                            child: Obx(() => Wrap(
                                  children: controller.calams
                                      .map((item) => SizedBox(
                                            width: 100,
                                            child: Card(
                                              color: item["chon"] == true
                                                  ? Colors.red
                                                  : HexColor(item["maunen"]),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 5),
                                                child: ListTile(
                                                  onTap: () {
                                                    controller.chonca(item);
                                                  },
                                                  title: Text(
                                                    item["tenca"],
                                                    style: TextStyle(
                                                        color: HexColor(
                                                            item["mauchu"])),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                  subtitle: Text(
                                                      "${item["batdau"].toString().substring(0, 5)} - ${item["ketthuc"].toString().substring(0, 5)}",
                                                      style: TextStyle(
                                                          color: HexColor(
                                                              item["mauchu"]),
                                                          fontSize: 11),
                                                      textAlign:
                                                          TextAlign.center),
                                                ),
                                              ),
                                            ),
                                          ))
                                      .toList(),
                                )),
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            "Chọn địa điểm làm",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 10),
                          Obx(() => ListView.separated(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              itemCount: controller.diadiems.length,
                              separatorBuilder: (ct, i) => const Divider(),
                              itemBuilder: (ct, i) {
                                var item = controller.diadiems[i];
                                return ListTile(
                                    onTap: () {
                                      controller.chondiadien(item);
                                    },
                                    leading: item["qrcode"] == true
                                        ? const Icon(Icons.qr_code_2_outlined,
                                            color: Colors.blue)
                                        : const Icon(
                                            Feather.map_pin,
                                            color: Colors.red,
                                          ),
                                    title: Text(item["tendiadiem"],
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold)),
                                    subtitle: Text(
                                      "${item["diachi"]}",
                                    ),
                                    trailing: Column(
                                      children: [
                                        if (item["chon"] == true)
                                          const Icon(
                                            Icons.check,
                                            color: Colors.green,
                                          ),
                                      ],
                                    ));
                              })),
                          const SizedBox(height: 10),
                          Center(
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              child: ElevatedButton(
                                onPressed: () {
                                  controller.addDkylamviec();
                                },
                                style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          const Color(0xFF2196f3)),
                                ),
                                child: const Text("Cập nhật",
                                    style: TextStyle(color: Colors.white)),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ))
                ],
              ),
            ))));
  }

  void showAction() {
    controller.openca();
    var item = controller.thongtinca;
    Get.bottomSheet((BottomSheet(
        onClosing: () {},
        builder: (_) => Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Row(
                    children: const [
                      Icon(Icons.date_range_outlined),
                      SizedBox(width: 5),
                      Text(
                        "Chọn chức năng",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                      child: SingleChildScrollView(
                    child: Column(
                      children: [
                        ListTile(
                          onTap: () {
                            Get.back();
                            configCalamviec();
                          },
                          leading: const Icon(Icons.edit),
                          title: const Text("Cập nhật ca làm việc"),
                        ),
                        ListTile(
                          onTap: () {
                            Get.back();
                            controller.delCa();
                          },
                          leading: const Icon(FontAwesome.trash_o),
                          title: const Text("Xoá ca làm việc"),
                        ),
                        // ListTile(
                        //   onTap: () {
                        //     Get.back();
                        //   },
                        //   leading: const Icon(FontAwesome.pencil_square_o),
                        //   title: const Text("Xin nghỉ"),
                        // ),
                        // ListTile(
                        //   onTap: () {
                        //     Get.back();
                        //   },
                        //   leading: const Icon(FontAwesome.qrcode),
                        //   title: const Text("Xin check in"),
                        // ),
                        if (item["tenca"] != null) const Divider(),
                        if (item["tenca"] != null)
                          Row(
                            children: const [
                              Icon(Icons.info_outline),
                              SizedBox(width: 5),
                              Text(
                                "Thông tin ca",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        if (item["tenca"] != null) const SizedBox(height: 10),
                        if (item["tenca"] != null)
                          Align(
                              alignment: Alignment.centerLeft,
                              child: Card(
                                color: HexColor(item["maunen"] ?? "#ffffff"),
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Column(
                                    children: [
                                      Text(item["tenca"] ?? "",
                                          style: TextStyle(
                                              color: HexColor(
                                                  item["mauchu"] ?? "#000000"),
                                              fontSize: 13,
                                              fontWeight: FontWeight.bold)),
                                      const SizedBox(height: 5),
                                      if (item["batdau"] != null &&
                                          item["batdau"].toString().length > 5)
                                        Text(
                                            "${item["batdau"].toString().substring(0, 5)} - ${item["ketthuc"].toString().substring(0, 5)}",
                                            style: TextStyle(
                                                color: HexColor(
                                                    item["mauchu"] ??
                                                        "#000000"),
                                                fontSize: 11),
                                            textAlign: TextAlign.center)
                                    ],
                                  ),
                                ),
                              )),
                        if (item["tendiadiem"] != null &&
                            item["tendiadiem"] != "")
                          ListTile(
                            leading: item["qrcode"] == true
                                ? const Icon(Icons.qr_code_2_outlined,
                                    color: Colors.blue)
                                : const Icon(
                                    Feather.map_pin,
                                    color: Colors.red,
                                  ),
                            title: Text(item["tendiadiem"] ?? "",
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold)),
                            subtitle: Text(
                              "${item["diachi"] ?? ""}",
                            ),
                          )
                      ],
                    ),
                  ))
                ],
              ),
            ))));
  }

  //Function
  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context)
          .copyWith(textScaleFactor: Golbal.textScaleFactor),
      child: Scaffold(
          backgroundColor: const Color(0xffffffff),
          appBar: AppBar(
            leading: IconButton(
              icon: Icon(
                Ionicons.chevron_back_outline,
                color: Colors.black.withOpacity(0.5),
                size: 30,
              ),
              onPressed: () {
                Get.back();
              },
            ),
            backgroundColor: Colors.white,
            iconTheme: IconThemeData(color: Golbal.appColor),
            titleSpacing: 0.0,
            centerTitle: true,
            title: Obx(() => Row(
                  children: [
                    TextButton(
                        onPressed: () {
                          controller.nextThang(false);
                        },
                        child:
                            const Icon(Ionicons.chevron_back_circle_outline)),
                    Text("Tháng ${controller.thang}/${controller.nam}",
                        style: TextStyle(
                            color: Golbal.titleappColor,
                            fontWeight: FontWeight.bold)),
                    TextButton(
                        onPressed: () {
                          controller.nextThang(true);
                        },
                        child: const Icon(
                            Ionicons.chevron_forward_circle_outline)),
                  ],
                )),
            actions: [
              Obx(() => controller.showAction.value
                  ? IconButton(
                      onPressed: showAction, icon: const Icon(Icons.send))
                  : const SizedBox.shrink())
            ],
            systemOverlayStyle: SystemUiOverlayStyle.light,
          ),
          body: Column(
            children: [
              thuWidget(),
              Expanded(child: SingleChildScrollView(child: ngayWidget()))
            ],
          )),
    );
  }
}
