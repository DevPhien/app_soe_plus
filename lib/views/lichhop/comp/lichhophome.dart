import 'package:date_time_format/date_time_format.dart';
import 'package:fade_shimmer/fade_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:grouped_list/grouped_list.dart';

import '../../../utils/golbal/golbal.dart';
import '../../component/use/nodata.dart';
import '../lichhopcontroller.dart';
import 'itemlichhop.dart';

class LichhopHome extends StatelessWidget {
  final LichHopController controller = Get.put(LichHopController());

  LichhopHome({Key? key}) : super(key: key);

  Widget itemBuilder(ct, ele) => ele["IsLast"] == true
      ? Wrap(
          children: [
            ItemLichhop(
              key: Key(ele["LichhopTuan_ID"]),
              data: ele,
              loadFile: controller.loadFile,
              goDetail: controller.goDetail,
              onChonlich:
                  controller.pageIndex.value == 3 ? controller.openChon : null,
              initLichtrung: controller.pageIndex.value == 3
                  ? controller.initLichtrung
                  : null,
              isChon: controller.pageIndex.value == 3,
              gomeeting: controller.gomeeting,
            ),
            ghichuTuan()
          ],
        )
      : ItemLichhop(
          key: Key(ele["LichhopTuan_ID"]),
          data: ele,
          onChonlich:
              controller.pageIndex.value == 3 ? controller.openChon : null,
          initLichtrung:
              controller.pageIndex.value == 3 ? controller.initLichtrung : null,
          loadFile: controller.loadFile,
          goDetail: controller.goDetail,
          isChon: controller.pageIndex.value == 3,
          gomeeting: controller.gomeeting,
        );
  Widget ghichuTuan() {
    return Obx(() => controller.ghichu.value == ""
        ? const SizedBox.shrink()
        : Container(
            margin: const EdgeInsets.all(10),
            width: double.infinity,
            decoration: BoxDecoration(
                color: const Color(0xFFFDFFB1),
                borderRadius: BorderRadius.circular(20)),
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                const Icon(Ionicons.information_circle_outline,
                    color: Color(0xFF045997)),
                const SizedBox(width: 5),
                Expanded(
                    child: Text(
                  controller.ghichu.value,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Color(0xFF045997),
                  ),
                )),
              ],
            )));
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
                    txt: "Không có lịch họp nào",
                    icon: AntDesign.calendar,
                  ),
                ),
              )
            : Padding(
                padding: const EdgeInsets.only(top: 10),
                child: GroupedListView<dynamic, String>(
                  padding: const EdgeInsets.all(0),
                  shrinkWrap: true,
                  elements: controller.datas,
                  groupBy: (element) => element['Day'],
                  groupSeparatorBuilder: (String groupByValue) =>
                      Text(groupByValue),
                  groupHeaderBuilder: (dynamic element) => Container(
                    padding: const EdgeInsets.all(10),
                    color: const Color(0xFFF9F8F8),
                    child: Row(
                      children: [
                        Expanded(
                            child: Text(
                          element['day_name'] ?? "",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Golbal.titleColor),
                        )),
                        if (element["IsToday"] == true)
                          Wrap(
                            children: [
                              SpinKitRipple(
                                  size: 20.0,
                                  duration: const Duration(milliseconds: 1200),
                                  color: Colors.red.withOpacity(1)),
                              const Text("Hôm nay",
                                  style: TextStyle(color: Color(0xFFFD5D19)))
                            ],
                          ),
                        if (element["IsToday"] != true)
                          Text(
                            DateTimeFormat.format(
                                DateTime.parse(element["Day"]),
                                format: 'd/m/Y'),
                            style: TextStyle(
                                fontWeight: FontWeight.normal,
                                color: Golbal.titleColor,
                                fontSize: 12),
                          )
                      ],
                    ),
                  ),
                  itemBuilder: itemBuilder,
                  itemComparator: (item1, item2) => item1['BatdauNgay']
                      .compareTo(item2['BatdauNgay']), // optional
                  useStickyGroupSeparators: true, // optional
                  floatingHeader: false, // optional
                  order: GroupedListOrder.ASC, // optional
                ),
              ));
  }
}
