import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:soe/utils/golbal/golbal.dart';

import '../../../component/use/inlineloadding.dart';
import '../../../component/use/nodata.dart';
import '../../controller/foldercontroller.dart';

class ListFolder extends StatelessWidget {
  final FolderController controller = Get.put(FolderController());
  final bool isOne;
  ListFolder({
    Key? key,
    required this.isOne,
  }) : super(key: key);

  Widget widgetFolder(List dts) {
    if (dts.isEmpty) return const SizedBox.shrink();
    return Container(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: dts
            .map((e) => InkWell(
                onTap: () => controller.toogleChon(e, isOne),
                child: Padding(
                    padding: const EdgeInsets.all(5),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: e["hasChild"]
                              ? InkWell(
                                  onTap: () {
                                    controller.toogleFolder(e);
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Icon(
                                      e["open"] == true
                                          ? AntDesign.down
                                          : AntDesign.right,
                                      size: 16,
                                    ),
                                  ))
                              : const InkWell(
                                  onTap: null,
                                  child: Padding(
                                    padding: EdgeInsets.all(5.0),
                                    child: Icon(
                                      AntDesign.right,
                                      size: 16,
                                      color: Colors.transparent,
                                    ),
                                  )),
                        ),
                        const SizedBox(width: 5),
                        Expanded(
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Checkbox(
                                      value: e["chon"],
                                      onChanged: (bool? vl) {
                                        controller.setChon(isOne, e, vl);
                                      }),
                                  const Icon(FontAwesome.folder,
                                      color: Colors.orange),
                                  const SizedBox(width: 5),
                                  Text(
                                    e["Name"],
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  )
                                ],
                              ),
                              if (e["open"] == true && e["Childs"] != null)
                                widgetFolder(e["Childs"])
                            ],
                          ),
                        )
                      ],
                    ))))
            .toList(),
      ),
    );
  }

  //Function
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          controller.back();
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
                title: Text("My Box",
                    style: TextStyle(
                        color: Golbal.titleappColor,
                        fontWeight: FontWeight.bold)),
                actions: [
                  IconButton(
                      onPressed: controller.saveChon,
                      icon: const Icon(Ionicons.save_outline))
                ],
                centerTitle: true,
                systemOverlayStyle: Golbal.systemUiOverlayStyle,
              ),
              body: Obx(() => controller.isloadding.value
                  ? const InlineLoadding()
                  : controller.foldes.isEmpty
                      ? const WidgetNoData(
                          icon: FontAwesome.folder_o,
                          txt: "Chưa có thư mục nào",
                        )
                      : SingleChildScrollView(
                          child: widgetFolder(controller.foldes))),
            )));
  }
}
