import 'package:carousel_indicator/carousel_indicator.dart';
import 'package:date_time_format/date_time_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';

import '../../../utils/golbal/golbal.dart';
import '../controller/cthongbaocontroller.dart';

class HomeThongBao extends StatelessWidget {
  final HomeThongBaoController controller = Get.put(HomeThongBaoController());

  HomeThongBao({Key? key}) : super(key: key);

  Widget widgetThongbao() {
    return SizedBox(
      width: double.infinity,
      height: 86 * Golbal.textScaleFactor,
      child: Obx(() => Column(
            children: [
              Expanded(
                child: controller.datas.isNotEmpty
                    ? PageView(
                        onPageChanged: (index) {
                          controller.pageIndex.value = index;
                        },
                        children: controller.datas
                            .map((tb) => InkWell(
                                onTap: () {
                                  controller.goDetailThongbao(tb);
                                },
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 5, horizontal: 10),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "${tb["Tieude"]}",
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 15,
                                            color: Colors.white),
                                      ),
                                      const SizedBox(height: 5.0),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 8.0),
                                        child: Text(
                                            DateTimeFormat.format(
                                                DateTime.parse(tb["NgayTao"]),
                                                format: 'd/m/Y H:i'),
                                            style: const TextStyle(
                                                color: Colors.white70,
                                                fontSize: 13)),
                                      )
                                    ],
                                  ),
                                )))
                            .toList(),
                      )
                    : Container(),
              ),
              if (controller.datas.isNotEmpty)
                Obx(() => Padding(
                      padding: const EdgeInsets.only(bottom: 5),
                      child: CarouselIndicator(
                        width: 8,
                        height: 8,
                        cornerRadius: 8,
                        count: controller.datas.length,
                        index: controller.pageIndex.value,
                      ),
                    )),
            ],
          )),
    );
  }

  @override
  Widget build(context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      decoration: const BoxDecoration(color: Color(0xFF0078D4)),
      child: Row(
        children: [
          SpinKitFadingCube(
              size: 20.0,
              duration: const Duration(milliseconds: 2000),
              color: Colors.white.withOpacity(1)),
          const SizedBox(width: 10),
          Expanded(child: widgetThongbao()),
          const SizedBox(width: 10),
        ],
      ),
    );
  }
}
