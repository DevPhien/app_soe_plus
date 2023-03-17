import 'package:debouncer_widget/debouncer_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:soe/utils/golbal/golbal.dart';
import 'package:soe/views/component/phongban/itemphongbanchon.dart';
import 'package:soe/views/component/phongban/phongbancontroller.dart';
import 'package:soe/views/component/use/inlineloadding.dart';
import 'package:soe/views/component/use/nodata.dart';

class ListPhongban extends StatelessWidget {
  final PhongbanController controller = Get.put(PhongbanController());
  final bool? one;
  ListPhongban({
    Key? key,
    this.one,
  }) : super(key: key);
  Widget widgetListPhongban() {
    if (controller.phongbans.isEmpty) {
      return const SizedBox(
        height: 400,
        child: Center(
          child: WidgetNoData(
            txt: "Không có người dùng nào",
            icon: EvilIcons.user,
          ),
        ),
      );
    }
    return ListView.separated(
      itemCount: controller.phongbans.length,
      itemBuilder: (ct, i) => ItemPhongbanChon(
          phongban: controller.phongbans[i],
          one: one ?? false,
          onClick: controller.onChangePhongban),
      separatorBuilder: (ct, i) => const Divider(height: 1),
    );
  }

  Widget widgetListGroupPhongban() {
    if (controller.groupphongbans.isEmpty) {
      return const SizedBox(
        height: 400,
        child: Center(
          child: WidgetNoData(
            txt: "Không có phòng ban nào",
            icon: Feather.users,
          ),
        ),
      );
    }
    return GroupedListView<dynamic, String>(
      elements: controller.groupphongbans,
      groupBy: (element) => element['tenCongty'],
      groupSeparatorBuilder: (String groupByValue) => Text(groupByValue),
      groupHeaderBuilder: (dynamic element) => Container(
        padding: const EdgeInsets.all(10),
        color: const Color(0xFFeeeeee),
        child: Row(
          children: [
            Icon(FontAwesome.building_o, color: Golbal.titleColor),
            const SizedBox(width: 5.0),
            Expanded(
                child: Text(
              element['tenCongty'] ?? "",
              style: TextStyle(
                  fontWeight: FontWeight.bold, color: Golbal.titleColor),
            )),
          ],
        ),
      ),
      itemBuilder: (context, dynamic element) => ItemPhongbanChon(
          phongban: element,
          one: one ?? false,
          onClick: controller.onChangePhongbanGroup),
      itemComparator: (item1, item2) =>
          item1['thutu'].compareTo(item2['thutu']), // optional
      useStickyGroupSeparators: true, // optional
      floatingHeader: false, // optional
      order: GroupedListOrder.ASC, // optional
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          controller.closePhongban();
          return true;
        },
        child: MediaQuery(
            data: MediaQuery.of(context)
                .copyWith(textScaleFactor: Golbal.textScaleFactor),
            child: DefaultTabController(
                length: 2,
                child: Scaffold(
                  backgroundColor: const Color(0xffffffff),
                  appBar: AppBar(
                    backgroundColor: Golbal.appColorD,
                    elevation: 1.0,
                    iconTheme: IconThemeData(color: Golbal.iconColor),
                    title: Container(
                      width: double.infinity,
                      height: 40,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          color: const Color(0xFFf9f8f8),
                          border: Border.all(
                              color: const Color(0xffeeeeee), width: 1.0)),
                      child: Center(
                          child: Debouncer(
                        action: () {
                          controller.search();
                        },
                        builder: (newContext, _) => TextField(
                          onChanged: (String? s) {
                            controller.s = s ?? "";
                            Debouncer.execute(newContext);
                          },
                          onSubmitted: (String? s) {
                            controller.search(ss: s);
                          },
                          decoration: const InputDecoration(
                            contentPadding: EdgeInsets.all(5),
                            focusedBorder: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            border: InputBorder.none,
                            hintText: 'Tìm kiếm',
                            prefixIcon: Icon(Icons.search),
                          ),
                        ),
                      )),
                    ),
                    actions: [
                      Obx(() => controller.isChon.value > 0
                          ? Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ElevatedButton.icon(
                                onPressed: () {
                                  controller.onChonPhongban(true);
                                },
                                icon: const Icon(
                                  Ionicons.checkbox_outline,
                                  color: Colors.white,
                                ),
                                label: Text(
                                    "Chọn (${controller.isChon.value.toString()})",
                                    style:
                                        const TextStyle(color: Colors.white)),
                                style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Golbal.appColor),
                                ),
                              ),
                            )
                          : const SizedBox.shrink())
                    ],
                    bottom: TabBar(
                      tabs: [
                        Obx(() => Tab(
                            text:
                                'Danh sách mặc định (${controller.phongbans.length})')),
                        Obx(() => Tab(
                            text:
                                'DS Theo cơ cấu (${controller.groupphongbans.length})')),
                      ],
                      labelColor: Golbal.titleColor,
                      indicatorColor: Golbal.titleColor,
                      unselectedLabelColor: Colors.black87,
                    ),
                    centerTitle: true,
                    systemOverlayStyle: Golbal.systemUiOverlayStyle,
                  ),
                  body: TabBarView(
                    children: [
                      Obx(() => controller.isloadding.value
                          ? const InlineLoadding()
                          : widgetListPhongban()),
                      Obx(() => controller.isloaddingGroup.value
                          ? const InlineLoadding()
                          : widgetListGroupPhongban())
                    ],
                  ),
                ))));
  }
}
