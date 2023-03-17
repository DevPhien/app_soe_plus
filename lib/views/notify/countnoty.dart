import 'package:date_time_format/date_time_format.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'notifycontroller.dart';

class CCountNoty extends StatelessWidget {
  final NotyController controller = Get.put(NotyController());

  CCountNoty({Key? key}) : super(key: key);
  //Function
  Widget itemTuan(int i) {
    return Obx(() => Container(
        margin: const EdgeInsets.only(right: 5),
        decoration: BoxDecoration(
            color:
                controller.nhomnotys[i]["WeekNo"] == controller.nhom["WeekNo"]
                    ? const Color(0xFFFF8126)
                    : controller.nhomnotys[i]["IsCurrentWeek"] == true
                        ? const Color(0xFFCEF1D9)
                        : const Color(0xFFEFF8FF),
            borderRadius: BorderRadius.circular(5)),
        width: 100,
        child: InkResponse(
          focusColor: Colors.transparent,
          hoverColor: Colors.transparent,
          highlightColor: Colors.transparent,
          onTap: () {
            controller.goNhom(controller.nhomnotys[i]);
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Tuần ${controller.nhomnotys[i]["WeekNo"]}",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: controller.nhomnotys[i]["WeekNo"] ==
                            controller.nhom["WeekNo"]
                        ? Colors.white
                        : Colors.black87,
                    fontSize: 15),
              ),
              const SizedBox(
                height: 3,
              ),
              Text(
                "${DateTimeFormat.format(DateTime.parse(controller.nhomnotys[i]["WeekStartDate"]), format: 'd/m')}-${DateTimeFormat.format(DateTime.parse(controller.nhomnotys[i]["WeekEndDate"]), format: 'd/m/y')}",
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 11,
                    color: controller.nhomnotys[i]["WeekNo"] ==
                            controller.nhom["WeekNo"]
                        ? Colors.white
                        : Colors.black54),
              ),
            ],
          ),
        )));
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => Container(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          height: 60,
          child: Row(
            children: [
              Container(
                  decoration: BoxDecoration(
                      color: const Color(0xFF005A9E),
                      borderRadius: BorderRadius.circular(5)),
                  width: 80,
                  child: InkResponse(
                    focusColor: Colors.transparent,
                    hoverColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    onTap: () {},
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text(
                          "Tất cả",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                        SizedBox(
                          height: 3,
                        ),
                        Text(
                          "",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: 18),
                        ),
                      ],
                    ),
                  )),
              Expanded(
                  child: controller.nhomnotys.isEmpty
                      ? const SizedBox.shrink()
                      : ListView.builder(
                          shrinkWrap: true,
                          itemBuilder: (ct, i) => itemTuan(i),
                          itemCount: controller.nhomnotys.length,
                          physics: const BouncingScrollPhysics(),
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          scrollDirection: Axis.horizontal,
                        )),
            ],
          ),
        ));
  }
}
