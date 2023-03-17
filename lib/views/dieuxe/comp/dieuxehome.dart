import 'package:date_time_format/date_time_format.dart';
import 'package:fade_shimmer/fade_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:soe/views/component/use/inlineloadding.dart';

import '../../../utils/golbal/golbal.dart';
import '../../component/use/nodata.dart';
import '../dieuxecontroller.dart';
import 'itemdieuxe.dart';
import 'itemlenhdieuxe.dart';

class DieuxeHome extends StatelessWidget {
  final DieuxeController controller = Get.put(DieuxeController());

  DieuxeHome({Key? key}) : super(key: key);

  Widget itemPhieuBuilder(ct, ele) {
    var container = Container(
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(width: 1.0, color: Colors.black12),
        ),
      ),
      child: ItemDieuxe(
        key: Key(ele["PhieuDX_ID"]),
        data: ele,
        onClick: null,
        loadFile: controller.loadFile,
        isChon: controller.pageIndex.value == 3,
      ),
    );
    return container;
  }

  Widget groupPhieu() {
    return GroupedListView<dynamic, String>(
      padding: const EdgeInsets.all(0),
      shrinkWrap: true,
      elements: controller.datas,
      groupBy: (element) => DateTimeFormat.format(
          DateTime.parse(element["PhieuDX_FromDate"]),
          format: 'Y/m/d'),
      groupSeparatorBuilder: (String groupByValue) => Text(groupByValue),
      groupHeaderBuilder: (dynamic element) => Container(
        padding: const EdgeInsets.all(10),
        color: const Color(0xFFF9F8F8),
        child: Row(
          children: [
            Expanded(
              child: Text(
                "Ngày ${DateTimeFormat.format(DateTime.parse(element["PhieuDX_FromDate"]), format: 'd/m/Y')}",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Golbal.titleColor,
                ),
              ),
            ),
            Text(
              Golbal.getDayName(element['PhieuDX_FromDate'] ?? ""),
              style: TextStyle(
                  fontWeight: FontWeight.w400, color: Golbal.titleColor),
            )
          ],
        ),
      ),
      itemBuilder: itemPhieuBuilder, // optional
      useStickyGroupSeparators: true, // optional
      floatingHeader: false, // optional
      itemComparator: (item1, item2) =>
          DateTime.parse(item1['PhieuDX_FromDate'])
              .compareTo(DateTime.parse(item2['PhieuDX_FromDate'])),
      order: GroupedListOrder.DESC, // optional
    );
  }

  Widget itemLenhBuilder(ct, ele) {
    var container = Container(
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

    return container;
  }

  Widget groupLenh() {
    return GroupedListView<dynamic, String>(
      padding: const EdgeInsets.all(0),
      shrinkWrap: true,
      elements: controller.datas,
      groupBy: (element) => DateTimeFormat.format(
          DateTime.parse(element["LenhDX_FromDate"]),
          format: 'Y/m/d'),
      groupSeparatorBuilder: (String groupByValue) => Text(groupByValue),
      groupHeaderBuilder: (dynamic element) => Container(
        padding: const EdgeInsets.all(10),
        color: const Color(0xFFF9F8F8),
        child: Row(
          children: [
            Expanded(
                child: Text(
              "Ngày ${DateTimeFormat.format(DateTime.parse(element["LenhDX_FromDate"]), format: 'd/m/Y')}",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Golbal.titleColor,
              ),
            )),
            Text(
              Golbal.getDayName(element['LenhDX_FromDate'] ?? ""),
              style: TextStyle(
                  fontWeight: FontWeight.w400, color: Golbal.titleColor),
            ),
          ],
        ),
      ),
      itemBuilder: itemLenhBuilder,
      useStickyGroupSeparators: true, // optional
      floatingHeader: false, // optional
      itemComparator: (item1, item2) => DateTime.parse(item1['LenhDX_FromDate'])
          .compareTo(DateTime.parse(item2['LenhDX_FromDate'])),
      order: GroupedListOrder.DESC, // optional
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
            ? SizedBox(
                height: 400,
                child: Center(
                  child: Obx(() => WidgetNoData(
                        txt:
                            "Không có ${controller.isPhieu.value ? "phiếu" : "lệnh"} điều xe nào",
                        icon: AntDesign.calendar,
                      )),
                ),
              )
            : Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child:
                        controller.isPhieu.value ? groupPhieu() : groupLenh(),
                  ),
                  Obx(() => controller.loaddingmore.value
                      ? const InlineLoadding()
                      : const SizedBox.shrink()),
                  Obx(() => controller.isloaddingmore.value
                      ? Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextButton(
                              onPressed: controller.onLoadmore,
                              child: Text(
                                "Xem thêm (${controller.datas.length}/${controller.isPhieu.value ? controller.countdata["totalPhieu"] : controller.countdata["totalLenh"]})",
                              )),
                        )
                      : const SizedBox.shrink()),
                ],
              ));
  }
}
