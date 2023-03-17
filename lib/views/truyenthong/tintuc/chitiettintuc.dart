import 'package:date_time_format/date_time_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import '../../../utils/golbal/golbal.dart';
import '../../component/use/inlineloadding.dart';
import '../../component/webview/webview.dart';
import 'controller/chitiettintuccontroller.dart';
import 'controller/tintuccontroller.dart';

class ChitietTintuc extends StatelessWidget {
  final ChitietTintucController controller = Get.put(ChitietTintucController());
  final TintucController tbcontroller = Get.put(TintucController());

  ChitietTintuc({Key? key}) : super(key: key);

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

  Widget infoTintuc() {
    const breakRow = SizedBox(height: 10);
    return Container(
        padding: const EdgeInsets.all(10),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(
            controller.tintuc["Tieude"] ?? "",
            style: const TextStyle(
                fontWeight: FontWeight.bold, color: Colors.black),
          ),
          breakRow,
          Text(
            DateTimeFormat.format(DateTime.parse(controller.tintuc["Ngaygui"]),
                format: 'H:i d/m/Y'),
            style: const TextStyle(color: Colors.black54, fontSize: 13),
          ),
          breakRow,
          if (controller.tintuc["Noidung"] != null) breakRow,
          if (controller.tintuc["Noidung"] != null)
            HtmlWidget(
              controller.tintuc["Noidung"] ?? "",
              textStyle: const TextStyle(fontSize: 14),
            ),
        ]));
  }

  Widget noiDung() {
    String title =
        "<h3 style='padding:0px;margin:0;font-size:35pt'>${controller.tintuc["Tieude"]}</h3>";
    String spdate =
        "<div style='color:#888;font-size:25pt;margin-bottom:20px;margin-top:5px'>${DateTimeFormat.format(DateTime.parse(controller.tintuc["Ngaygui"]), format: 'H:i d/m/Y')}</div>";
    String html =
        "<style>*{max-width:100%!important;font-size:30pt}img{max-width:100%!important}img{height:auto!important}body{padding:20px;font-family:arial}</style><body>$title$spdate${controller.tintuc["Noidung"]}</body>";
    return WebViewHTMLMobile(html: html);
  }

  Widget bodyWidget() {
    if (controller.isWebview.value) {
      return noiDung();
    }
    return SingleChildScrollView(
      child: Obx(() => infoTintuc()),
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
            title: InkWell(
              onTap: () {
                controller.isWebview.value = !controller.isWebview.value;
              },
              child: Text("Chi tiết tin tức",
                  style: TextStyle(
                      color: Golbal.titleappColor,
                      fontWeight: FontWeight.bold)),
            ),
            centerTitle: true,
            systemOverlayStyle: Golbal.systemUiOverlayStyle1,
          ),
          body: Column(
            children: [
              Expanded(
                  child: Obx(() => controller.isLoadding.value
                      ? const InlineLoadding()
                      : bodyWidget())),
              // const SizedBox(height: 10),
              // SafeArea(
              //     child: Container(
              //   padding: const EdgeInsets.all(10),
              //   child: Row(
              //     children: [
              //       InkWell(
              //         child: Column(children: []),
              //       )
              //     ],
              //   ),
              // ))
            ],
          )),
    );
  }
}
