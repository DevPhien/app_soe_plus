import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';

import '../../../utils/golbal/golbal.dart';
import 'phieuluongcontroller.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class Phieuluong extends StatelessWidget {
  final PhieuluongController controller = Get.put(PhieuluongController());

  Phieuluong({Key? key}) : super(key: key);

  //Function

  Widget itemNam(int i) {
    return Container(
        margin: const EdgeInsets.only(right: 5),
        decoration: BoxDecoration(
            color: controller.years[i] == controller.year.value
                ? const Color(0xFFFF8126)
                : const Color(0xFF40B8EA),
            borderRadius: BorderRadius.circular(5)),
        width: 80,
        child: InkResponse(
          focusColor: Colors.transparent,
          hoverColor: Colors.transparent,
          highlightColor: Colors.transparent,
          onTap: () {
            controller.setYear(controller.years[i]);
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Năm",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              const SizedBox(
                height: 3,
              ),
              Text(
                "${controller.years[i]}",
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 15),
              ),
            ],
          ),
        ));
  }

  Widget itemThang(m) {
    return Container(
      margin: const EdgeInsets.all(5),
      decoration: BoxDecoration(
          color: controller.year.value == controller.cyear &&
                  controller.cmonth == m["month"]
              ? const Color(0xFFCEF1D9)
              : ((controller.year.value == controller.cyear &&
                          controller.cmonth > m["month"]) ||
                      controller.year.value < controller.cyear)
                  ? const Color(0xFFEFF8FF)
                  : const Color(0xFFD9D9D9),
          borderRadius: BorderRadius.circular(5)),
      width: Golbal.screenSize.width > 720
          ? Golbal.screenSize.width / 4 - 30
          : Golbal.screenSize.width / 3 - 20,
      height: 70,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Tháng ${m["month"]}",
            style: TextStyle(
              color: Golbal.titleColor,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            "${m["luonghienthi"] ?? "Chưa tính"}",
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: m["luonghienthi"] == "Chưa tính"
                    ? Colors.black26
                    : Colors.black87,
                fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget chartThang() {
    if (controller.months.isEmpty) return const SizedBox.shrink();
    var achart = charts.Series<dynamic, String>(
      id: 'Luong',
      colorFn: (dynamic obj, __) =>
          charts.Color.fromHex(code: obj["color"] ?? "#cccccc"),
      domainFn: (dynamic obj, _) => "T${obj["month"]}",
      measureFn: (dynamic obj, _) =>
          obj["luong"] == null ? 0 : obj["luong"] / 1000000,
      data: controller.months,
    );
    return SizedBox(
      width: MediaQuery.of(Get.context!).size.width,
      height: 300,
      child: charts.BarChart(
        [achart],
        animate: true,
      ),
    );
  }

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
          title: InkWell(
            //onTap: controller.randomluong,
            child: Text("Phiếu lương tháng",
                style: TextStyle(
                    color: Golbal.titleappColor, fontWeight: FontWeight.bold)),
          ),
          centerTitle: false,
          systemOverlayStyle: Golbal.systemUiOverlayStyle1,
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 60,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemBuilder: (ct, i) => Obx(() => itemNam(i)),
                  itemCount: controller.years.length,
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 0),
                  scrollDirection: Axis.horizontal,
                ),
              ),
              const SizedBox(height: 10),
              Expanded(
                  child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Obx(() => Wrap(
                        alignment: WrapAlignment.center,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: controller.months
                            .map((element) => itemThang(element))
                            .toList())),
                    Obx(() => controller.tongluong.value != "0"
                        ? chartThang()
                        : const SizedBox.shrink())
                  ],
                ),
              )),
              const SizedBox(height: 10),
              Obx(() => controller.tongluong.value != "0"
                  ? Row(
                      children: [
                        const Icon(FontAwesome.hand_o_right,
                            color: Color(0xFFFD5D19)),
                        const SizedBox(width: 5),
                        Expanded(
                            child: Text(
                                "Tổng thu nhập của bạn đến thời điểm hiện tại trong năm",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Golbal.titleColor)))
                      ],
                    )
                  : const SizedBox.shrink()),
              Obx(() => controller.tongluong.value != "0"
                  ? SafeArea(
                      child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Obx(() => Center(
                                child: Text(controller.tongluong.value,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFFFD5D19),
                                        fontSize: 32)),
                              ))))
                  : const SizedBox.shrink()),
            ],
          ),
        ),
      ),
    );
  }
}
