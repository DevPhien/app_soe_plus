import 'package:date_time_format/date_time_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:graphview/GraphView.dart' as gh;

import '../../../utils/golbal/golbal.dart';
import '../../component/use/avatar.dart';
import '../../component/use/inlineloadding.dart';
import '../../component/use/nodata.dart';
import '../controller/tientrinhcontroller.dart';

class TientrinhXyly extends StatelessWidget {
  final TienTrinhVanbanController controller =
      Get.put(TienTrinhVanbanController());
  TientrinhXyly({
    Key? key,
  }) : super(key: key);
//Function
  Widget dateWidget(String? d, Color cl) {
    return d == null
        ? const SizedBox.shrink()
        : Text(DateTimeFormat.format(DateTime.parse(d), format: 'd/m/y H:i'),
            style: TextStyle(color: cl, fontSize: 11));
  }

  Widget nodeWidget(node, BuildContext context) {
    var colors = {
      "xuly": const Color(0xFF2196f3),
      "phanphat": const Color(0xFFCAE2B0),
      "xemdebiet": const Color(0xFFCCADD7),
      "phoihop": const Color(0xFF8BCFFB),
      "hoanthanh": const Color(0xFF6dd230),
      "tralai": const Color(0xFFff0000),
    };
    var txtcolors = {
      "xuly": Colors.white,
      "phanphat": Colors.black87,
      "xemdebiet": Colors.white,
      "phoihop": Colors.white,
      "hoanthanh": Colors.white,
      "tralai": Colors.white,
    };
    return InkWell(
      onTap: () {
        if (node["Noidung"] != null || node["Noidungthuhoi"] != null) {
          controller.showNoidung(node);
        }
      },
      child: Stack(
        children: [
          Container(
            padding: const EdgeInsets.all(5),
            width: 120,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              boxShadow: [
                BoxShadow(
                    color: colors[node["status"]] ?? const Color(0xFF2196f3),
                    spreadRadius: 1),
              ],
            ),
            child: Column(
              children: [
                SizedBox(
                  width: 24,
                  height: 24,
                  child: UserAvarta(
                    user: node["sender"][0],
                    radius: 12,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  node["sender"][0]["fullName"] ?? "",
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: txtcolors[node["status"]] ?? Colors.white,
                      fontSize: 12),
                ),
                dateWidget(node["Ngaygui"] ?? "",
                    txtcolors[node["status"]] ?? Colors.white)
              ],
            ),
          ),
          if (node["Noidung"] != null)
            const Positioned(
              top: 5,
              right: 5,
              child: CircleAvatar(
                radius: 10,
                backgroundColor: Colors.white,
                child: Icon(
                  Icons.comment_outlined,
                  size: 10,
                  color: Colors.orange,
                ),
              ),
            ),
          if (node["Noidungthuhoi"] != null)
            const Positioned(
              top: 5,
              left: 5,
              child: CircleAvatar(
                radius: 10,
                backgroundColor: Colors.white,
                child: Icon(
                  Icons.refresh,
                  size: 10,
                  color: Colors.red,
                ),
              ),
            ),
        ],
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
            title: Text("Bảng theo dõi tiến trình xử lý",
                style: TextStyle(
                    color: Golbal.titleappColor, fontWeight: FontWeight.bold)),
            centerTitle: true,
            systemOverlayStyle: Golbal.systemUiOverlayStyle1,
            actions: [
              Obx(() => controller.isEmpty.value
                  ? const SizedBox.shrink()
                  : IconButton(
                      onPressed: controller.changeOrientation,
                      icon: const Icon(FontAwesome.sitemap)))
            ],
          ),
          body: Obx(() => controller.isloadding.value
              ? const InlineLoadding()
              : controller.isEmpty.value
                  ? const WidgetNoData(
                      icon: FontAwesome.sitemap,
                      txt: "Chưa có tiến trình xử lý nào",
                    )
                  : InteractiveViewer(
                      constrained: false,
                      boundaryMargin: const EdgeInsets.all(double.infinity),
                      minScale: 0.01,
                      maxScale: 5.6,
                      child: gh.GraphView(
                        graph: controller.graph,
                        algorithm: gh.BuchheimWalkerAlgorithm(
                            controller.builder,
                            gh.TreeEdgeRenderer(controller.builder)),
                        paint: Paint()
                          ..color = Colors.redAccent
                          ..strokeWidth = 1
                          ..style = PaintingStyle.stroke,
                        builder: (gh.Node node) {
                          // I can decide what widget should be shown here based on the id
                          return nodeWidget(node.key!.value, context);
                        },
                      ),
                    )),
        ));
  }
}
