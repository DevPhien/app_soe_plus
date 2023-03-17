import 'package:date_time_format/date_time_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';

import '../../utils/golbal/golbal.dart';
import '../component/use/avatar.dart';
import '../component/use/inlineloadding.dart';
import 'comp/itembutton.dart';
import 'controller/chitietvanbancontroller.dart';

class ChitietVanban extends StatelessWidget {
  final ChitietVanbanController controller = Get.put(ChitietVanbanController());

  ChitietVanban({Key? key}) : super(key: key);
  Widget itemButton(String title, IconData icon, int idx) =>
      Obx(() => Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: idx == controller.index.value
                    ? Colors.orange
                    : const Color(0xFF40B8EA)),
            margin: const EdgeInsets.only(right: 10, top: 5),
            child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    controller.setIndex(idx);
                  },
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(icon, color: Colors.white),
                        const SizedBox(height: 5.0),
                        Text(
                          title,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                              color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                )),
          ));
  Widget buttonTop() => Wrap(children: [
        itemButton("Ý kiến/Chỉ đạo", Entypo.new_message, 1),
        itemButton("Nhân sự nhận", FontAwesome.users, 2),
        itemButton("Tiến trình xử lý", FontAwesome.sitemap, 3),
      ]);
  Widget dateWidget(String? d, TextStyle style, {String? fm}) {
    return d == null
        ? const SizedBox.shrink()
        : Text(DateTimeFormat.format(DateTime.parse(d), format: fm ?? 'd/m/Y'),
            style: style);
  }

  Widget noidungFollow() {
    if (controller.vanban["Noidungfollow"] == null ||
        controller.vanban["Noidungfollow"] == "") {
      return const SizedBox.shrink();
    }
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: const Color(0xFFDBF1FF)),
      padding: const EdgeInsets.all(10),
      child: Row(
        children: [
          UserAvarta(
            user: Get.arguments != null && Get.arguments["anhThumb"] != null
                ? Get.arguments
                : controller.vanban,
            radius: 16,
          ),
          const SizedBox(width: 10),
          Expanded(child: Text(controller.vanban["Noidungfollow"] ?? ""))
        ],
      ),
    );
  }

  Widget vanbanGoc() {
    TextStyle titleFile =
        const TextStyle(color: Color(0xFF045997), fontWeight: FontWeight.w500);
    return Wrap(children: [
      if (controller.vanban["tailieuTen"] != null)
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Text(
            "Văn bản gốc:",
            style: titleFile,
          ),
        ),
      if (controller.vanban["tailieuTen"] != null)
        Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: const Color(0xFFEFECEC)),
          child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  controller.loadFile(controller.vanban["tailieuPath"]);
                },
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image(
                          image: AssetImage(
                              "assets/file/${controller.vanban["tailieuLoai"].toString().toLowerCase().replaceAll('.', '')}.png"),
                          width: 24,
                          height: 24,
                          fit: BoxFit.contain),
                      Expanded(
                          child: Text("${controller.vanban["tailieuTen"]}",
                              maxLines: 3,
                              textAlign: TextAlign.left,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                  color: Color(0xffFD5D19),
                                  fontWeight: FontWeight.bold)))
                    ],
                  ),
                ),
              )),
        )
    ]);
  }

  Widget vanbanDinhkem() {
    TextStyle titleFile =
        const TextStyle(color: Color(0xFF045997), fontWeight: FontWeight.w500);
    return Wrap(children: [
      if (controller.tailieus.isNotEmpty)
        Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Text(
              "File đính kèm khác:",
              style: titleFile,
            )),
      if (controller.tailieus.isNotEmpty)
        Wrap(
          children: controller.tailieus
              .map((tl) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5.0),
                    child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () {
                            controller.loadFile(tl["tailieuPath"]);
                          },
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image(
                                  image: AssetImage(
                                      "assets/file/${tl["tailieuLoai"].toString().toLowerCase().replaceAll('.', '')}.png"),
                                  width: 24,
                                  height: 24,
                                  fit: BoxFit.contain),
                              Expanded(
                                  child: Text("${tl["tailieuTen"]}",
                                      maxLines: 3,
                                      textAlign: TextAlign.left,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                          color: Colors.black87,
                                          fontWeight: FontWeight.w500)))
                            ],
                          ),
                        )),
                  ))
              .toList(),
        )
    ]);
  }

  Widget noidunghoanthanhs() {
    TextStyle titleFile =
        const TextStyle(color: Color(0xFF045997), fontWeight: FontWeight.w500);
    return Wrap(children: [
      if (controller.hoanthanhs.isNotEmpty)
        Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Text(
              "Nội dung xác nhận hoàn thành:",
              style: titleFile,
            )),
      if (controller.hoanthanhs.isNotEmpty)
        Wrap(
          children: controller.hoanthanhs
              .map((tl) => Container(
                    margin: const EdgeInsets.symmetric(vertical: 5.0),
                    decoration: BoxDecoration(
                        color: const Color(0xFF5CB85C),
                        borderRadius: BorderRadius.circular(10)),
                    padding: const EdgeInsets.symmetric(
                        vertical: 10.0, horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(children: [
                          if (tl["ten"] != null)
                            UserAvarta(
                              user: tl,
                              radius: 16,
                            ),
                          const SizedBox(width: 10),
                          Expanded(
                              child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              dateWidget(
                                  tl["ngayTai"],
                                  const TextStyle(
                                      color: Colors.white, fontSize: 13),
                                  fm: "d/m/Y H:i"),
                              const SizedBox(height: 5),
                              Text(
                                tl["Noidung"] ?? "",
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 13),
                              ),
                              const SizedBox(height: 5),
                              if (tl["tailieuPath"] != null)
                                Material(
                                    color: Colors.transparent,
                                    child: InkWell(
                                      onTap: () {
                                        controller.loadFile(tl["tailieuPath"]);
                                      },
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Image(
                                              image: AssetImage(
                                                  "assets/file/${tl["tailieuLoai"].toString().replaceAll('.', '')}.png"),
                                              width: 16,
                                              height: 16,
                                              fit: BoxFit.contain),
                                          const SizedBox(width: 10),
                                          Expanded(
                                              child: Text("${tl["tailieuTen"]}",
                                                  maxLines: 1,
                                                  textAlign: TextAlign.left,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 13,
                                                  )))
                                        ],
                                      ),
                                    )),
                            ],
                          ))
                        ])
                      ],
                    ),
                  ))
              .toList(),
        )
    ]);
  }

  Widget vanbanLienQuan() {
    TextStyle titleFile =
        const TextStyle(color: Color(0xFF045997), fontWeight: FontWeight.w500);
    return Wrap(children: [
      if (controller.vanbanlienquans.isNotEmpty)
        Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Text(
              "Văn bản liên quan:",
              style: titleFile,
            )),
      if (controller.vanbanlienquans.isNotEmpty)
        Wrap(
          children: controller.vanbanlienquans
              .map((tl) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5.0),
                    child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () {
                            controller.loadFile(tl["tailieuPath"]);
                          },
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image(
                                  image: AssetImage(
                                      "assets/file/${tl["tailieuLoai"].toString().toLowerCase().replaceAll('.', '')}.png"),
                                  width: 24,
                                  height: 24,
                                  fit: BoxFit.contain),
                              Expanded(
                                  child: Text("${tl["tailieuTen"]}",
                                      maxLines: 3,
                                      textAlign: TextAlign.left,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                          color: Colors.black87,
                                          fontWeight: FontWeight.w500)))
                            ],
                          ),
                        )),
                  ))
              .toList(),
        )
    ]);
  }

  Widget vanbanDuthao() {
    TextStyle titleFile =
        const TextStyle(color: Color(0xFF045997), fontWeight: FontWeight.w500);
    return Wrap(children: [
      if (controller.vanbanduthaos.isNotEmpty)
        Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Text(
              "Văn bản dự thảo đã duyệt:",
              style: titleFile,
            )),
      if (controller.vanbanduthaos.isNotEmpty)
        Wrap(
          children: controller.vanbanduthaos
              .map((tl) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5.0),
                    child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () {
                            controller.loadFile(tl["tailieuPath"]);
                          },
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image(
                                  image: AssetImage(
                                      "assets/file/${tl["tailieuLoai"].toString().replaceAll('.', '')}.png"),
                                  width: 24,
                                  height: 24,
                                  fit: BoxFit.contain),
                              Expanded(
                                  child: Text("${tl["tailieuTen"]}",
                                      maxLines: 3,
                                      textAlign: TextAlign.left,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                          color: Colors.black87,
                                          fontWeight: FontWeight.w500)))
                            ],
                          ),
                        )),
                  ))
              .toList(),
        )
    ]);
  }

  Widget infoVanban() {
    const breakRow = SizedBox(height: 10);
    const breakbeetRow = SizedBox(width: 10);
    TextStyle label = const TextStyle(color: Colors.black87, fontSize: 14);
    TextStyle title =
        const TextStyle(color: Colors.black, fontWeight: FontWeight.bold);
    return Container(
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            controller.vanban["trichYeuNoiDung"] ?? "",
            style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Color(0xFF045997)),
          ),
          breakRow,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  "Số/Ký hiệu",
                  style: label,
                ),
              ),
              breakbeetRow,
              Text(
                "Ngày văn bản",
                style: label,
              ),
            ],
          ),
          breakRow,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                  child: Text(
                controller.vanban["soKyHieu"] ?? "",
                style: title,
              )),
              breakbeetRow,
              dateWidget(controller.vanban["ngayVanBan"], title),
            ],
          ),
          breakRow,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                  child: Text(
                "Thuộc nhóm",
                style: label,
              )),
              breakbeetRow,
              Text(
                "Số vào sổ",
                style: label,
              ),
            ],
          ),
          breakRow,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                  child: Text(
                controller.vanban["tenNhom"] ?? "",
                style: title,
              )),
              breakbeetRow,
              Text(
                (controller.vanban["soVaoSo"] ?? "")
                    .toString()
                    .replaceAll(".0", ""),
                style: title,
              ),
            ],
          ),
          breakRow,
          Text(
            "Nơi ban hành",
            style: label,
          ),
          breakRow,
          Text(
            "${controller.vanban["noiBanHanh"] ?? ""}",
            style: title,
          ),
          breakRow,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                  child: Text(
                "Lĩnh vực",
                style: label,
              )),
              breakbeetRow,
              Text(
                "Ngày đến",
                style: label,
              ),
            ],
          ),
          breakRow,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                  child: Text(
                controller.vanban["tenLinhVuc"] ?? "",
                style: title,
              )),
              breakbeetRow,
              dateWidget(controller.vanban["ngayDen"], title),
            ],
          ),
          vanbanGoc(),
          vanbanDinhkem(),
          vanbanLienQuan(),
          vanbanDuthao(),
          noidungFollow(),
          noidunghoanthanhs()
        ],
      ),
    );
  }

  Widget bodyVanban() {
    return Expanded(
        child: SingleChildScrollView(
            child: Column(
      children: [buttonTop(), Obx(() => infoVanban())],
    )));
  }

  Widget bootmVanban() {
    return SafeArea(
        child: Obx(() => controller.buttonkey.isEmpty
            ? const SizedBox.shrink()
            : ItemButton(
                vanban: controller.vanban,
                buttonkey: List.castFrom(controller.buttonkey))));
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
          title: Text("Chi tiết văn bản",
              style: TextStyle(
                  color: Golbal.titleappColor, fontWeight: FontWeight.bold)),
          centerTitle: true,
          systemOverlayStyle: Golbal.systemUiOverlayStyle1,
        ),
        body: Obx(
          () => controller.isloaddingVB.value
              ? const InlineLoadding()
              : Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [bodyVanban(), bootmVanban()],
                  )),
        ),
      ),
    );
  }
}
