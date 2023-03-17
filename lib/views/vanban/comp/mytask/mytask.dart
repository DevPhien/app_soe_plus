import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:soe/utils/golbal/golbal.dart';

import '../../../component/use/inlineloadding.dart';
import '../../../component/use/nodata.dart';
import '../../controller/taskcontroller.dart';

class ListTask extends StatelessWidget {
  final TaskVBController controller = Get.put(TaskVBController());
  final bool isOne;
  ListTask({
    Key? key,
    required this.isOne,
  }) : super(key: key);

  Widget widgetTask(List dts) {
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
                        e["hasChild"]
                            ? InkWell(
                                onTap: () {
                                  controller.toogleTask(e);
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
                            : const SizedBox.shrink(),
                        const SizedBox(width: 5),
                        Expanded(
                            child: Padding(
                          padding: const EdgeInsets.only(top: 5),
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
                                  Expanded(
                                      child: Text(
                                    e["CongviecTen"],
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ))
                                ],
                              ),
                              if (e["open"] == true && e["Childs"] != null)
                                widgetTask(e["Childs"])
                            ],
                          ),
                        ))
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
                title: Text("Công việc",
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
              body: Obx(() => Column(
                    children: [
                      Expanded(
                          child: Obx(() => controller.isloadding.value
                              ? const InlineLoadding()
                              : controller.tasks.isEmpty
                                  ? const WidgetNoData(
                                      icon: FontAwesome.tasks,
                                      txt: "Chưa có công việc nào",
                                    )
                                  : SingleChildScrollView(
                                      child: widgetTask(controller.tasks)))),
                      const SizedBox(height: 10),
                      SafeArea(
                        child: Container(
                          decoration: const BoxDecoration(
                              border: Border(
                                  top: BorderSide(
                                      color: Color(0xFFeeeeee), width: 1.0))),
                          padding: const EdgeInsets.symmetric(
                              vertical: 5.0, horizontal: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              TextButton.icon(
                                  onPressed: () => controller.setPageIndex(1),
                                  icon: Icon(MaterialIcons.add_task,
                                      color: controller.pageIndex.value == 1
                                          ? Golbal.titleColor
                                          : Colors.black87),
                                  label: Text(
                                    "Tôi làm",
                                    style: TextStyle(
                                        color: controller.pageIndex.value == 1
                                            ? Golbal.titleColor
                                            : Colors.black87),
                                  )),
                              TextButton.icon(
                                  onPressed: () => controller.setPageIndex(2),
                                  icon: Icon(Octicons.tasklist,
                                      color: controller.pageIndex.value == 2
                                          ? Golbal.titleColor
                                          : Colors.black87),
                                  label: Text(
                                    "Tôi quản lý",
                                    style: TextStyle(
                                        color: controller.pageIndex.value == 2
                                            ? Golbal.titleColor
                                            : Colors.black87),
                                  )),
                            ],
                          ),
                        ),
                      )
                    ],
                  )),
            )));
  }
}
