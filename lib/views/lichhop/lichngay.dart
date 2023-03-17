import 'package:date_time_format/date_time_format.dart';
import 'package:fade_shimmer/fade_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';

import '../../../utils/golbal/golbal.dart';
import '../component/use/nodata.dart';
import 'comp/itemlichhop.dart';
import 'lichngaycontroller.dart';

class LichhopNgay extends StatelessWidget {
  final LichHopNgayController controller = Get.put(LichHopNgayController());

  LichhopNgay({Key? key}) : super(key: key);

  Widget itemBuilder(ct, idx) {
    var ele = controller.datas[idx];
    var ilich = ItemLichhop(
      key: Key(ele["LichhopTuan_ID"]),
      data: ele,
      onChonlich: null,
      loadFile: controller.loadFile,
      goDetail: controller.goDetail,
      gomeeting: controller.gomeeting,
      isChon: false,
    );
    return ele["IsLast"] == true
        ? Wrap(
            children: [ilich, ghichuTuan()],
          )
        : ilich;
  }

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

  Widget listLichNgay() {
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
                    txt: "Không có lịch họp nào trong ngày",
                    icon: AntDesign.calendar,
                  ),
                ),
              )
            : Padding(
                padding: const EdgeInsets.only(top: 10),
                child: ListView.builder(
                  padding: const EdgeInsets.all(0),
                  shrinkWrap: true,
                  itemBuilder: itemBuilder,
                  itemCount: controller.datas.length,
                ),
              ));
  }

  //Function
  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context)
          .copyWith(textScaleFactor: Golbal.textScaleFactor),
      child: Scaffold(
          backgroundColor: const Color(0xffffffff),
          appBar: AppBar(
            backgroundColor: Golbal.appColorD,
            elevation: 0.0,
            iconTheme: IconThemeData(color: Golbal.iconColor),
            title: Text("Danh sách lịch",
                style: TextStyle(
                    color: Golbal.titleappColor, fontWeight: FontWeight.bold)),
            centerTitle: false,
            systemOverlayStyle: Golbal.systemUiOverlayStyle1,
          ),
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                SingleChildScrollView(
                    child: Obx(() => Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 15),
                          decoration: BoxDecoration(
                              color: const Color(0xFF005A9E),
                              borderRadius: BorderRadius.circular(5)),
                          child: Row(children: [
                            SpinKitRipple(
                                size: 40.0,
                                duration: const Duration(milliseconds: 2000),
                                color: Colors.orange.withOpacity(1)),
                            Expanded(
                              child: Column(children: [
                                const Text(
                                  "LỊCH CƠ QUAN NGÀY",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  "Thứ ${DateTime.now().weekday + 1} (${DateTimeFormat.format(DateTime.now(), format: 'd/m/Y')})",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                      color: Colors.white),
                                ),
                              ]),
                            ),
                            const SizedBox(height: 5),
                            CircleAvatar(
                              backgroundColor: Colors.white,
                              child: Text(
                                controller.datas.length.toString(),
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFFFD0A0A)),
                              ),
                            )
                          ]),
                        ))),
                Expanded(child: listLichNgay())
              ],
            ),
          )),
    );
  }
}
