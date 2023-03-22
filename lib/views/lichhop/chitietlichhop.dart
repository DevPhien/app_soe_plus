import 'package:date_time_format/date_time_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';

import '../../utils/golbal/golbal.dart';
import '../component/use/avatar.dart';
import '../component/use/inlineloadding.dart';
import 'chitietlichhopcontroller.dart';
import 'lichhopcontroller.dart';

class ChitietLichhop extends StatelessWidget {
  final ChitietLichhopController controller =
      Get.put(ChitietLichhopController());
  final LichHopController lichcontroller = Get.put(LichHopController());

  ChitietLichhop({Key? key}) : super(key: key);
  Widget fileWidget() {
    if (controller.lichhop["files"] == null) return const SizedBox.shrink();
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.only(top: 10),
          padding: const EdgeInsets.all(8),
          color: const Color(0xFFF9F8F8),
          child: Row(
            children: [
              const Icon(Ionicons.attach_outline),
              const SizedBox(width: 5),
              Text("File đính kèm (${controller.lichhop["files"].length})",
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Golbal.titleColor))
            ],
          ),
        ),
        ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.all(10),
            shrinkWrap: true,
            itemCount: controller.lichhop["files"].length,
            itemBuilder: (ct, i) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5.0),
                  child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          lichcontroller.loadFile(
                              controller.lichhop["files"][i]["Duongdan"]);
                        },
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image(
                                image: AssetImage(
                                    "assets/file/${controller.lichhop["files"][i]["Dinhdang"].toString().replaceAll('.', '')}.png"),
                                width: 16,
                                height: 16,
                                fit: BoxFit.contain),
                            const SizedBox(width: 5),
                            Expanded(
                                child: Text(
                                    "${controller.lichhop["files"][i]["Tenfile"]}",
                                    maxLines: 1,
                                    textAlign: TextAlign.left,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                        color: Color(0xFFFD5D19),
                                        fontSize: 13,
                                        fontWeight: FontWeight.w500)))
                          ],
                        ),
                      )),
                )),
      ],
    );
  }

  Widget dateWidget(u) {
    DateTime? d = DateTime.tryParse(u["NgayView"].toString());
    return d == null
        ? const SizedBox.shrink()
        : Column(
            children: [
              const Icon(Ionicons.checkmark_done_outline, color: Colors.green),
              Text(DateTimeFormat.format(d, format: 'd/m/y H:i'),
                  style: const TextStyle(color: Colors.black87, fontSize: 12))
            ],
          );
  }

  Widget thamdusWidget() {
    if (controller.lichhop["nguoithamdus"] == null) {
      return const SizedBox.shrink();
    }
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.only(top: 10),
          padding: const EdgeInsets.all(8),
          color: const Color(0xFFF9F8F8),
          child: Row(
            children: [
              const Icon(
                Feather.users,
                size: 14,
              ),
              const SizedBox(width: 5),
              Text("Tham dự (${controller.lichhop["nguoithamdus"].length})",
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Golbal.titleColor))
            ],
          ),
        ),
        ListView.separated(
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.all(10),
            shrinkWrap: true,
            itemCount: controller.lichhop["nguoithamdus"].length,
            separatorBuilder: (ct, i) => const Divider(),
            itemBuilder: (ct, i) {
              var u = controller.lichhop["nguoithamdus"][i];
              return Row(
                children: [
                  UserAvarta(user: {
                    "anhThumb": u["anhThumb"],
                    "ten": u["ten"].toString().toUpperCase(),
                  }),
                  const SizedBox(width: 10),
                  Expanded(
                      child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        u["fullName"] ?? "",
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        u["tenChucVu"] ?? "",
                        style: const TextStyle(fontSize: 13),
                      ),
                      if (u["IsThamGia"] != true &&
                          u["IsThamGia"] != "true" &&
                          u["Lydo"] != null)
                        Padding(
                            padding: const EdgeInsets.only(top: 5),
                            child: Text("Lý do không tham gia: ${u["Lydo"]}",
                                style: const TextStyle(
                                  color: Colors.red,
                                  fontStyle: FontStyle.italic,
                                  fontSize: 13,
                                )))
                    ],
                  )),
                  const SizedBox(width: 10),
                  Column(
                    children: [
                      dateWidget(u),
                      const SizedBox(height: 5),
                      if (u["IsThamGia"] == "false" || u["IsThamGia"] == false)
                        const CircleAvatar(
                            radius: 3, backgroundColor: Colors.red)
                    ],
                  )
                ],
              );
            }),
      ],
    );
  }

  Widget chuTri() {
    if (controller.lichhop["Chutri_Ten"] == null) {
      return const SizedBox.shrink();
    }
    return Column(
      children: [
        const SizedBox(height: 5),
        Container(
          padding: const EdgeInsets.all(8),
          color: const Color(0xFFF9F8F8),
          child: Row(
            children: [
              const Icon(EvilIcons.user),
              const SizedBox(width: 5),
              Text("Chủ trì:",
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Golbal.titleColor))
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: Colors.orange,
                child: Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: UserAvarta(user: {
                    "anhThumb": controller.lichhop["Chutri_Thumb"],
                    "ten": controller.lichhop["Chutri_Ten1"]
                        .toString()
                        .toUpperCase()
                  }),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Wrap(
                    children: [
                      Text(controller.lichhop["Chutri_gioiTinh"] == 0
                          ? "Ông"
                          : "Bà"),
                      const SizedBox(width: 5),
                      Text(
                        controller.lichhop["Chutri_FullName"] ?? "",
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    controller.lichhop["Chutri_TenChucvu"] ?? "",
                    style: const TextStyle(fontSize: 13),
                  ),
                  if (controller.lichhop["Chutri_IsThamGia"] != true &&
                      controller.lichhop["Chutri_Lydo"] != null)
                    Padding(
                        padding: const EdgeInsets.only(top: 5),
                        child: Text(
                            "Lý do không tham gia: ${controller.lichhop["Chutri_Lydo"]}",
                            style: const TextStyle(
                              color: Colors.red,
                              fontStyle: FontStyle.italic,
                              fontSize: 13,
                            )))
                ],
              )),
              const SizedBox(width: 10),
              Column(
                children: [
                  dateWidget(
                      {"NgayView": controller.lichhop["Chutri_NgayView"]}),
                  const SizedBox(height: 5),
                ],
              )
            ],
          ),
        ),
      ],
    );
  }

  Widget displayNgay() {
    TextStyle label = const TextStyle(color: Colors.black87, fontSize: 13);
    String ktngay = DateTimeFormat.format(
        DateTime.parse(controller.lichhop["KethucNgay"]),
        format: 'H:i d/m/Y');
    String bdngay = DateTimeFormat.format(
        DateTime.parse(controller.lichhop["BatdauNgay"]),
        format: 'H:i d/m${ktngay.contains("00:00") ? '/Y' : ''}');
    return Text(
      "$bdngay${ktngay.contains("00:00") ? '' : ' - $ktngay'}",
      style: label,
    );
  }

  Widget infoLich() {
    const breakRow = SizedBox(height: 10);
    TextStyle label = const TextStyle(color: Colors.black87, fontSize: 13);
    return Container(
        padding: const EdgeInsets.all(10),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(
            controller.lichhop["Noidung"] ?? "",
            style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Color(0xFF045997)),
          ),
          breakRow,
          if (controller.lichhop["BatdauNgay"] != null)
            Row(children: [
              const Icon(
                Feather.calendar,
                size: 14,
              ),
              const SizedBox(width: 5.0),
              Expanded(
                child: displayNgay(),
              )
            ]),
          if (controller.lichhop["Diadiem_Ten"] != null) breakRow,
          if (controller.lichhop["Diadiem_Ten"] != null)
            Row(children: [
              const Icon(
                Feather.map_pin,
                size: 14,
              ),
              const SizedBox(width: 5.0),
              Expanded(
                child: Text(
                  controller.lichhop["Diadiem_Ten"] ?? "",
                  style: label,
                ),
              )
            ]),
          if (controller.lichhop["Chuanbi"] != null) breakRow,
          if (controller.lichhop["Chuanbi"] != null)
            Row(children: [
              const Icon(
                Feather.tag,
                size: 14,
              ),
              const SizedBox(width: 5.0),
              Expanded(
                child: Text(
                  controller.lichhop["Chuanbi"] ?? "",
                  style: label,
                ),
              )
            ]),
          //
          if (controller.lichhop["Thamdu"] != null) breakRow,
          if (controller.lichhop["Thamdu"] != null)
            Wrap(children: [
              const Icon(
                Feather.user,
                size: 14,
              ),
              const SizedBox(width: 5.0),
              Text(
                "Người được mời: ${controller.lichhop["Thamdu"] ?? ""}",
                style: label,
              ),
            ]),
        ]));
  }

  Widget buttonLich() {
    DateTime? ngay = DateTime.tryParse(controller.lichhop["BatdauNgay"]);
    bool isconhan = ngay!.compareTo(DateTime.now()) >= 0;
    return Padding(
      padding: const EdgeInsets.all(0),
      child: Wrap(
        direction: Axis.vertical,
        children: [
          if (controller.lichhop["IsCancel"] == true)
            Container(
              width: Golbal.screenSize.width - 50,
              height: 70,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: ElevatedButton.icon(
                icon: const Icon(FontAwesome.calendar_times_o),
                onPressed: () {
                  controller.huyLich(controller.lichhop);
                },
                label: const Text("Huỷ lịch",
                    style: TextStyle(color: Colors.white)),
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(const Color(0xFFFD0A0A)),
                ),
              ),
            ),
          if (isconhan &&
              (controller.lichhop["IsThamGia"] == true ||
                  controller.lichhop["IsThamGia"] == "true"))
            Container(
              width: Golbal.screenSize.width - 50,
              height: 70,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: ElevatedButton.icon(
                icon: const Icon(Feather.user_x),
                onPressed: () {
                  controller.thamgia(controller.lichhop, false);
                },
                label: const Text("Xác nhận không tham gia",
                    style: TextStyle(color: Colors.white)),
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.orange),
                ),
              ),
            ),
          if (isconhan &&
              (controller.lichhop["IsThamGia"] == false ||
                  controller.lichhop["IsThamGia"] == "false"))
            Container(
              width: Golbal.screenSize.width - 50,
              height: 70,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: ElevatedButton.icon(
                icon: const Icon(Feather.user_check),
                onPressed: () {
                  controller.thamgia(controller.lichhop, true);
                },
                label: const Text("Xác nhận tham gia",
                    style: TextStyle(color: Colors.white)),
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.green),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget chiChuWWidget() {
    if (controller.lichhop["Ghichu"] == null ||
        controller.lichhop["Ghichu"] == "") {
      return const SizedBox.shrink();
    }
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.only(top: 10),
          padding: const EdgeInsets.all(8),
          color: const Color(0xFFF9F8F8),
          child: Row(
            children: [
              const Icon(
                Icons.edit,
                size: 12,
              ),
              const SizedBox(width: 5),
              Text("Ghi chú",
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Golbal.titleColor))
            ],
          ),
        ),
        Container(
            margin: const EdgeInsets.all(10),
            width: double.infinity,
            decoration: BoxDecoration(
                color: const Color(0xFFFDFFB1),
                borderRadius: BorderRadius.circular(20)),
            padding: const EdgeInsets.all(10),
            child: Text(
              controller.lichhop["Ghichu"],
              style: const TextStyle(
                fontSize: 13,
                color: Color(0xFF045997),
              ),
            )),
      ],
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
            leading: IconButton(
              onPressed: () {
                Get.back(result: controller.lichhop);
              },
              icon: Icon(
                Ionicons.chevron_back_outline,
                color: Colors.black.withOpacity(0.5),
                size: 30,
              ),
            ),
            title: Text("Chi tiết lịch họp",
                style: TextStyle(
                    color: Golbal.titleappColor, fontWeight: FontWeight.bold)),
            centerTitle: true,
            systemOverlayStyle: Golbal.systemUiOverlayStyle1,
            actions: [
              Obx(
                () => (controller.lichhop["IsEdit"] == true)
                    ? IconButton(
                        onPressed: () {
                          controller.openEdit(context, controller.lichhop);
                        },
                        icon: const Icon(Icons.edit))
                    : const SizedBox.shrink(),
              ),
            ],
          ),
          body: Obx(
            () => controller.isloadding.value
                ? const InlineLoadding()
                : SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Obx(() => infoLich()),
                          Obx(() => chuTri()),
                          Obx(() => thamdusWidget()),
                          Obx(() => fileWidget()),
                          Obx(() => chiChuWWidget()),
                          Obx(() => controller.isloadding.value != true
                              ? buttonLich()
                              : const SizedBox.shrink()),
                          if (controller.lichhop["Kieulich"] == 1)
                            Container(
                              width: Golbal.screenSize.width - 50,
                              margin: const EdgeInsets.only(bottom: 10),
                              height: 70,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                              child: ElevatedButton.icon(
                                icon: const Icon(FontAwesome.video_camera),
                                onPressed: () {
                                  controller.gomeeting(controller.lichhop);
                                },
                                label: const Text("Tham gia họp trực tuyến",
                                    style: TextStyle(color: Colors.white)),
                                style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Golbal.appColor),
                                ),
                              ),
                            )
                        ],
                      ),
                    ),
                  ),
          ),
        ));
  }
}
