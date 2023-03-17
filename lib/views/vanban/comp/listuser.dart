import 'package:debouncer_widget/debouncer_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:grouped_list/grouped_list.dart';

import '../../../utils/golbal/golbal.dart';
import '../../component/use/inlineloadding.dart';
import '../../component/use/itemuserchon.dart';
import '../../component/use/nodata.dart';
import '../controller/uservanbancontroller.dart';

class ListUserVanBan extends StatelessWidget {
  final UserVBController controller = Get.put(UserVBController());
  final bool? one;
  ListUserVanBan({
    Key? key,
    this.one,
  }) : super(key: key);
  Widget widgetListUser() {
    if (controller.users.isEmpty) {
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
      itemCount: controller.users.length,
      itemBuilder: (ct, i) => ItemUserChon(
          user: controller.users[i],
          one: one ?? false,
          onClick: controller.onChangeUser),
      separatorBuilder: (ct, i) => const Divider(height: 1),
    );
  }

  Widget widgetListGroupUser() {
    if (controller.groupusers.isEmpty) {
      return const SizedBox(
        height: 400,
        child: Center(
          child: WidgetNoData(
            txt: "Không có người dùng nào",
            icon: Feather.users,
          ),
        ),
      );
    }
    // return GroupedListView<dynamic, String>(
    //   elements: controller.groupusers,
    //   groupBy: (element) => element['tenPhongban'],
    //   groupSeparatorBuilder: (String groupByValue) => Text(groupByValue),
    //   groupHeaderBuilder: (dynamic element) => Container(
    //     padding: const EdgeInsets.all(10),
    //     color: const Color(0xFFeeeeee),
    //     child: Row(
    //       children: [
    //         Icon(Ionicons.people_outline, color: Golbal.titleColor),
    //         const SizedBox(width: 5.0),
    //         Expanded(
    //             child: Text(
    //           element['tenPhongban'] ?? "",
    //           style: TextStyle(
    //               fontWeight: FontWeight.bold, color: Golbal.titleColor),
    //         )),
    //       ],
    //     ),
    //   ),
    //   itemBuilder: (context, dynamic element) => ItemUserChon(
    //       user: element,
    //       one: one ?? false,
    //       onClick: controller.onChangeUserGroup),
    //   itemComparator: (item1, item2) =>
    //       item1['thutu'].compareTo(item2['thutu']), // optional
    //   useStickyGroupSeparators: true, // optional
    //   floatingHeader: false, // optional
    //   order: GroupedListOrder.ASC, // optional
    // );
    return ListView.builder(
      shrinkWrap: true,
      physics: const BouncingScrollPhysics(),
      itemCount: controller.groupusers.length,
      itemBuilder: (ct, i) {
        if (i == 0 ||
            controller.groupusers[i]["tenPhongban"] !=
                controller.groupusers[i - 1]["tenPhongban"]) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              controller.groupusers[i]["tenPhongban"] != null
                  ? Container(
                      color: const Color(0xFFeeeeee),
                      padding: const EdgeInsets.symmetric(
                          vertical: 15, horizontal: 20),
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "${controller.groupusers[i]["tenPhongban"] ?? ""}",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Golbal.titleColor),
                      ),
                    )
                  : const SizedBox(width: 0.0, height: 0.0),
              ItemUserChon(
                  user: controller.groupusers[i],
                  one: one ?? false,
                  onClick: controller.onChangeUserGroup),
            ],
          );
        }
        return ItemUserChon(
            user: controller.groupusers[i],
            one: one ?? false,
            onClick: controller.onChangeUserGroup);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          controller.closeUser();
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
                                  controller.onChonUser(true);
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
                                'Danh sách mặc định (${controller.users.length})')),
                        Obx(() => Tab(
                            text:
                                'DS Theo cơ cấu (${controller.groupusers.length})')),
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
                          : widgetListUser()),
                      Obx(() => controller.isloaddingGroup.value
                          ? const InlineLoadding()
                          : widgetListGroupUser())
                    ],
                  ),
                ))));
  }
}
