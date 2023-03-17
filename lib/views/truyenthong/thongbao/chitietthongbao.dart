import 'package:date_time_format/date_time_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import '../../../utils/golbal/golbal.dart';
import '../../component/use/avatar.dart';
import 'controller/chitietthongbaocontroller.dart';
import 'controller/thongbaocontroller.dart';

class ChitietThongbao extends StatelessWidget {
  final ChitietThongbaoController controller =
      Get.put(ChitietThongbaoController());
  final ThongbaoController tbcontroller = Get.put(ThongbaoController());

  ChitietThongbao({Key? key}) : super(key: key);
  Widget fileWidget() {
    if (controller.thongbao["files"] == null) return const SizedBox.shrink();
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
              Text("File đính kèm (${controller.thongbao["files"].length})",
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Golbal.titleColor))
            ],
          ),
        ),
        ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.all(10),
            shrinkWrap: true,
            itemCount: controller.thongbao["files"].length,
            itemBuilder: (ct, i) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5.0),
                  child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          tbcontroller.loadFile(
                              controller.thongbao["files"][i]["Duongdan"]);
                        },
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image(
                                image: AssetImage(
                                    "assets/file/${controller.thongbao["files"][i]["Dinhdang"].toString().replaceAll('.', '')}.png"),
                                width: 16,
                                height: 16,
                                fit: BoxFit.contain),
                            const SizedBox(width: 5),
                            Expanded(
                                child: Text(
                                    "${controller.thongbao["files"][i]["Tenfile"]}",
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

  Widget infoDang() {
    if (controller.thongbao["nguoitao_ten"] == null) {
      return const SizedBox.shrink();
    }
    TextStyle label = const TextStyle(color: Colors.black87, fontSize: 13);
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 5.0),
        child: Row(children: [
          SizedBox(
            width: 40,
            height: 40,
            child: UserAvarta(user: {
              "anhThumb": controller.thongbao["nguoitao_anhThumb"],
              "ten": controller.thongbao["nguoitao_ten"]
            }),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Text("Đăng bởi: ",
                        style: TextStyle(fontSize: 13, color: Colors.black87)),
                    Expanded(
                        child: Text(
                            controller.thongbao["nguoitao_fullName"] ?? "",
                            style: const TextStyle(
                                fontSize: 13,
                                color: Colors.black87,
                                fontWeight: FontWeight.w600))),
                  ],
                ),
                const SizedBox(height: 5),
                if(controller.thongbao["Ngaygui"]!=null)
                Text(
                  DateTimeFormat.format(
                      DateTime.parse(controller.thongbao["Ngaygui"]),
                      format: 'H:i d/m/Y'),
                  style: label,
                )
              ],
            ),
          )
        ]));
  }

  Widget infoThongbao() {
    const breakRow = SizedBox(height: 10);
    return Container(
        padding: const EdgeInsets.all(10),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(
            controller.thongbao["Tieude"] ?? "",
            style: const TextStyle(
                fontWeight: FontWeight.bold, color: Colors.black),
          ),
          infoDang(),
          breakRow,
          if (controller.thongbao["Noidung"] != null) breakRow,
          if (controller.thongbao["Noidung"] != null)
            HtmlWidget(
              controller.thongbao["Noidung"] ?? "",
              textStyle: const TextStyle(fontSize: 14),
            ),
        ]));
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
          title: Text("Chi tiết thông báo",
              style: TextStyle(
                  color: Golbal.titleappColor, fontWeight: FontWeight.bold)),
          centerTitle: true,
          systemOverlayStyle: Golbal.systemUiOverlayStyle1,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Obx(() => infoThongbao()),
                Obx(() => fileWidget()),
                Obx(() =>controller.users.isEmpty?const SizedBox(height: 0):  Container(
                      padding: const EdgeInsets.all(20),
                      alignment: Alignment.centerRight,
                      child: TextButton.icon(
                          onPressed: controller.showLuotxem,
                          icon: const Icon(
                            Ionicons.eye_outline,
                            size: 16,
                          ),
                          label: Text("${controller.users.length} lượt xem")),
                    ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
