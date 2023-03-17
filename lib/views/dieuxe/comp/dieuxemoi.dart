import 'package:fade_shimmer/fade_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:grouped_list/grouped_list.dart';

import '../../../utils/golbal/golbal.dart';
import '../../component/use/nodata.dart';
import '../dieuxecontroller.dart';
import 'itemlenhdieuxe.dart';

class DieuxeDasboard extends StatelessWidget {
  final DieuxeController controller = Get.put(DieuxeController());

  DieuxeDasboard({Key? key}) : super(key: key);

  Widget itemLenhBuilder(ct, ele) => Container(
        decoration: const BoxDecoration(
          border: Border(
            top: BorderSide(width: 1.0, color: Colors.black12),
          ),
        ),
        child: ItemLenhDieuxe(
          key: Key(ele["LenhDX_ID"]),
          data: ele,
          onClick: null,
          loadFile: controller.loadFile,
          isChon: controller.pageIndex.value == 3,
        ),
      );

  Widget groupLenh() {
    return GroupedListView<dynamic, String>(
        padding: const EdgeInsets.all(0),
        shrinkWrap: true,
        elements: controller.datas,
        groupBy: (element) => element["isLenhDangdienra"].toString(),
        groupSeparatorBuilder: (String groupByValue) => Text(groupByValue),
        groupHeaderBuilder: (dynamic element) => Container(
              padding: const EdgeInsets.all(10),
              color: element["isLenhDangdienra"]
                  ? Golbal.appColor
                  : const Color(0xFFF9F8F8),
              child: Row(
                children: [
                  Icon(
                      element["isLenhDangdienra"]
                          ? FontAwesome.clock_o
                          : FontAwesome.calendar_check_o,
                      size: 16,
                      color: element["isLenhDangdienra"]
                          ? Colors.white
                          : Golbal.titleColor),
                  const SizedBox(width: 5),
                  Expanded(
                      child: Text(
                    element["isLenhDangdienra"]
                        ? "Lệnh mới"
                        : "Lệnh chờ hoàn thành",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: element["isLenhDangdienra"]
                            ? Colors.white
                            : Golbal.titleColor),
                  )),
                ],
              ),
            ),
        itemBuilder: itemLenhBuilder,
        itemComparator: (item1, item2) => item2['LenhDX_FromDate']
            .compareTo(item1['LenhDX_FromDate']), // optional
        useStickyGroupSeparators: true, // optional
        floatingHeader: false, // optional
        order: GroupedListOrder.DESC // optional
        );
  }

  //Function
  @override
  Widget build(BuildContext context) {
    return Obx(() => controller.isLoadding.value
        ? ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (_, i) {
              final delay = (i * 300);
              return Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8)),
                margin: const EdgeInsets.symmetric(horizontal: 16),
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    FadeShimmer.round(
                      size: 60,
                      fadeTheme: FadeTheme.light,
                      millisecondsDelay: delay,
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        FadeShimmer(
                          height: 8,
                          width: 150,
                          radius: 4,
                          millisecondsDelay: delay,
                          fadeTheme: FadeTheme.light,
                        ),
                        const SizedBox(
                          height: 6,
                        ),
                        FadeShimmer(
                            height: 8,
                            millisecondsDelay: delay,
                            width: 170,
                            radius: 4,
                            fadeTheme: FadeTheme.light)
                      ],
                    )
                  ],
                ),
              );
            },
            itemCount: 20,
            separatorBuilder: (_, __) => const Divider(
              height: 1,
              color: Color(0xffeeeeee),
            ),
          )
        : controller.datas.isEmpty
            ? const SizedBox(
                height: 400,
                child: Center(
                  child: WidgetNoData(
                    txt: "Không có lệnh điều xe nào",
                    icon: AntDesign.calendar,
                  ),
                ),
              )
            : Padding(
                padding: const EdgeInsets.only(top: 10),
                child: groupLenh(),
              ));
  }
}
