import 'package:date_time_format/date_time_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';

import '../../../../utils/golbal/golbal.dart';
import '../../../component/use/avatar.dart';
import '../../../component/use/inlineloadding.dart';
import 'thuhoicontroller.dart';
import 'package:graphview/GraphView.dart' as gh;

class ThuhoiVanBan extends StatelessWidget {
  final ThuhoiVanbanController controller = Get.put(ThuhoiVanbanController());
  ThuhoiVanBan({
    Key? key,
  }) : super(key: key);

  Widget graphWidget() {
    return InteractiveViewer(
      constrained: false,
      boundaryMargin: const EdgeInsets.all(double.infinity),
      minScale: 0.01,
      maxScale: 5.6,
      child: gh.GraphView(
        graph: controller.graph,
        algorithm: gh.BuchheimWalkerAlgorithm(
            controller.builder, gh.TreeEdgeRenderer(controller.builder)),
        paint: Paint()
          ..color = Colors.redAccent
          ..strokeWidth = 1
          ..style = PaintingStyle.stroke,
        builder: (gh.Node node) {
          // I can decide what widget should be shown here based on the id
          return nodeWidget(node.key!.value);
        },
      ),
    );
  }

  Widget dateWidget(String? d, Color cl) {
    return d == null
        ? const SizedBox.shrink()
        : Text(DateTimeFormat.format(DateTime.parse(d), format: 'd/m/y H:i'),
            style: TextStyle(color: cl, fontSize: 11));
  }

  Widget nodeWidget(node) {
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
        controller.addUser(node);
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
                UserAvarta(
                  user: node["sender"][0],
                  radius: 12,
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
            Positioned(
              child: InkWell(
                onTap: () {
                  if (node["Noidung"] != null) {
                    EasyLoading.showToast(node["Noidung"] ?? '');
                  }
                },
                child: const CircleAvatar(
                  radius: 10,
                  backgroundColor: Colors.white,
                  child: Icon(
                    Icons.comment_outlined,
                    size: 10,
                    color: Colors.orange,
                  ),
                ),
              ),
              top: 5,
              right: 5,
            ),
          if (node["Noidungthuhoi"] != null)
            Positioned(
              child: InkWell(
                onTap: () {
                  if (node["Noidungthuhoi"] != null) {
                    EasyLoading.showToast(node["Noidungthuhoi"] ?? '');
                  }
                },
                child: const CircleAvatar(
                  radius: 10,
                  backgroundColor: Colors.white,
                  child: Icon(
                    Icons.refresh,
                    size: 10,
                    color: Colors.red,
                  ),
                ),
              ),
              top: 5,
              left: 5,
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var colors = {
      "xuly": const Color(0xFF2196f3),
      "phanphat": const Color(0xFFCAE2B0),
      "xemdebiet": const Color(0xFFCCADD7),
      "phoihop": const Color(0xFF8BCFFB),
      "hoanthanh": const Color(0xFF6dd230),
      "tralai": const Color(0xFFff0000),
    };
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
            title: Text("Thu hồi văn bản",
                style: TextStyle(
                    color: Golbal.titleappColor, fontWeight: FontWeight.bold)),
            centerTitle: true,
            systemOverlayStyle: Golbal.systemUiOverlayStyle1,
          ),
          body: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flexible(
                    child: Obx(() => controller.isloadding.value
                        ? const InlineLoadding()
                        : Container(
                            margin: const EdgeInsets.only(bottom: 10),
                            color: const Color(0xFFeeeeee),
                            child: graphWidget()))),
                Text("Người bị thu hồi", style: Golbal.stylelabel),
                const SizedBox(height: 10),
                Obx(() => controller.nodeUser.isEmpty
                    ? const SizedBox.shrink()
                    : SizedBox(
                        height: 64,
                        child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            shrinkWrap: true,
                            itemCount: controller.nodeUser.length,
                            itemBuilder: (ct, i) {
                              var element = controller.nodeUser[i];
                              var u = element["sender"][0];
                              return Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Chip(
                                  deleteIcon: const Icon(
                                    Ionicons.close,
                                    size: 16,
                                  ),
                                  onDeleted: () {
                                    controller.deleteUser(element);
                                  },
                                  backgroundColor: colors[element["status"]] ??
                                      const Color(0xFF2196f3),
                                  label: Text(
                                    u["fullName"] ?? "",
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black,
                                        fontSize: 12),
                                  ),
                                  avatar: UserAvarta(
                                    user: u,
                                    radius: 16,
                                  ),
                                ),
                              );
                            }),
                      )),
                const SizedBox(height: 10),
                Text("Nội dung", style: Golbal.stylelabel),
                const SizedBox(height: 10),
                TextFormField(
                  minLines: 5,
                  maxLines: 10,
                  decoration: Golbal.decoration,
                  style: Golbal.styleinput,
                  onChanged: (String txt) => controller.model["message"] = txt,
                ),
                const SizedBox(height: 10),
                Container(
                  width: 150,
                  height: 80,
                  padding: const EdgeInsets.all(20),
                  child: ElevatedButton(
                    onPressed: () {
                      controller.submit();
                    },
                    child: const Text("Gửi",
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
        )));
  }
}
