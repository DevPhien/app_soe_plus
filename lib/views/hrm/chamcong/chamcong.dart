import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';

import '../../../utils/golbal/golbal.dart';
import 'chamcongcontroller.dart';

class Chamcong extends StatelessWidget {
  final ChamcongController controller = Get.put(ChamcongController());

  Chamcong({Key? key}) : super(key: key);

  //Function
  Widget namWidget() {
    return Container(
        decoration: BoxDecoration(
            color: const Color(0xFF005A9E),
            borderRadius: BorderRadius.circular(5)),
        width: 80,
        child: InkResponse(
          focusColor: Colors.transparent,
          hoverColor: Colors.transparent,
          highlightColor: Colors.transparent,
          onTap: () {
            controller.openYear();
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Năm",
                style: TextStyle(color: Colors.white),
              ),
              const SizedBox(
                height: 3,
              ),
              Text(
                "${controller.year}",
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 18),
              ),
            ],
          ),
        ));
  }

  Widget itemThang(int i) {
    return Container(
        margin: const EdgeInsets.only(right: 5),
        decoration: BoxDecoration(
            color: controller.months[i] == controller.month.value
                ? const Color(0xFFFF8126)
                : ((controller.months[i] <= controller.cmonth &&
                            controller.year.value == controller.cyear) ||
                        controller.year.value < controller.cyear)
                    ? const Color(0xFF40B8EA)
                    : const Color(0xFFB9B7B7),
            borderRadius: BorderRadius.circular(5)),
        width: 80,
        child: InkResponse(
          focusColor: Colors.transparent,
          hoverColor: Colors.transparent,
          highlightColor: Colors.transparent,
          onTap: () {
            controller.setMonth(controller.months[i]);
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Tháng",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              const SizedBox(
                height: 3,
              ),
              Text(
                "${controller.months[i]}",
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 15),
              ),
            ],
          ),
        ));
  }

  Widget thuWidget() {
    const border = BorderSide(width: 1.0, color: Colors.white);
    return Row(
      children: controller.thus
          .map((e) => Expanded(
              child: Container(
                  decoration: BoxDecoration(
                      color: Golbal.appColor,
                      border: const Border(
                          left: border, top: border, bottom: border)),
                  height: 45,
                  child: Center(
                    child: Text(
                      e,
                      style: const TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ))))
          .toList(),
    );
  }

  Color renderColor(e) {
    if (e != null && e["Holiday"] != null) return Colors.red;
    if (e == null || controller.songaycong.value == "") return Colors.white;
    if (e["IsType"] == 1) return const Color(0xFF5CB85C);
    if (e["IsType"] == -1) return const Color(0xFFB9B7B7);
    return Colors.white;
  }

  Widget rowWidget(List item) {
    const border = BorderSide(width: 1.0, color: Color(0xFFeeeeee));
    return Row(
      children: item
          .map((e) => Expanded(
                  child: InkWell(
                onTap: e == null || e["Holiday"] == null
                    ? null
                    : () {
                        controller.showLydo(e["Holiday"]);
                      },
                child: Container(
                    decoration: BoxDecoration(
                        gradient: (e == null || e["IsType"] != 2)
                            ? null
                            : const LinearGradient(
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                                colors: [
                                    Color(0xFF5CB85C),
                                    Color(0xFF5CB85C),
                                    Color(0xFFB9B7B7)
                                  ],
                                stops: [
                                    0,
                                    0.5,
                                    0.5
                                  ]),
                        color: renderColor(e),
                        border: const Border(left: border, bottom: border)),
                    height: 45,
                    child: Center(
                      child: Text(
                        "${e != null ? e["day"] : ""}",
                        style: const TextStyle(
                            color: Colors.black87, fontWeight: FontWeight.w600),
                      ),
                    )),
              )))
          .toList(),
    );
  }

  Widget ngayWidget() {
    return Obx(() => Column(
        children:
            controller.days.map((element) => rowWidget(element)).toList()));
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
          title: Text("Bảng chấm công",
              style: TextStyle(
                  color: Golbal.titleappColor, fontWeight: FontWeight.bold)),
          centerTitle: false,
          systemOverlayStyle: Golbal.systemUiOverlayStyle1,
          actions: [
            IconButton(
                onPressed: () {
                  Get.toNamed("chamcongQR");
                },
                icon: const Icon(Icons.qr_code_2_outlined)),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Obx(() => SizedBox(
                    height: 60,
                    child: Row(children: [
                      namWidget(),
                      Expanded(
                          child: ListView.builder(
                        controller: controller.thangcontroller,
                        shrinkWrap: true,
                        itemBuilder: (ct, i) => Obx(() => itemThang(i)),
                        itemCount: controller.months.length,
                        physics: const BouncingScrollPhysics(),
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        scrollDirection: Axis.horizontal,
                      ))
                    ]),
                  )),
              const SizedBox(height: 10),
              Expanded(
                  child: Container(
                decoration: const BoxDecoration(
                    color: Colors.white,
                    border: Border(
                        right:
                            BorderSide(width: 1.0, color: Color(0xFFeeeeee)))),
                child: Column(
                  children: [
                    thuWidget(),
                    Expanded(child: ngayWidget()),
                  ],
                ),
              )),
              const SizedBox(height: 15),
              Row(children: [
                Icon(FontAwesome.calendar, color: Golbal.titleColor, size: 16),
                SizedBox(
                    width: 200,
                    child: Text(" Số ngày công trong tháng: ",
                        style: TextStyle(
                            color: Golbal.titleColor,
                            fontWeight: FontWeight.bold))),
                CircleAvatar(
                    backgroundColor: Colors.orange,
                    child: Obx(() => Text(controller.songaycongthang.toString(),
                        style: const TextStyle(color: Colors.white))))
              ]),
              const SizedBox(height: 10),
              Row(children: [
                Icon(FontAwesome.calendar_check_o,
                    color: Golbal.titleColor, size: 16),
                SizedBox(
                    width: 200,
                    child: Text(" Số ngày công của bạn: ",
                        style: TextStyle(
                            color: Golbal.titleColor,
                            fontWeight: FontWeight.bold))),
                CircleAvatar(
                    backgroundColor: Golbal.appColor,
                    child: Obx(() => Text(controller.songaycong.toString(),
                        style: const TextStyle(color: Colors.white))))
              ]),
              const SizedBox(height: 20),
              SafeArea(
                child: Wrap(
                  children: [
                    Container(
                        color: const Color(0xFF5CB85C), width: 16, height: 16),
                    const SizedBox(width: 5),
                    const Text("Đi làm",
                        style: TextStyle(
                            fontStyle: FontStyle.italic, fontSize: 13)),
                    const SizedBox(width: 15),
                    Container(
                        color: const Color(0xFFB9B7B7), width: 16, height: 16),
                    const SizedBox(width: 5),
                    const Text("Nghỉ làm",
                        style: TextStyle(
                            fontStyle: FontStyle.italic, fontSize: 13)),
                    const SizedBox(width: 15),
                    Container(
                        decoration: const BoxDecoration(
                            gradient: LinearGradient(
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                                colors: [
                              Color(0xFF5CB85C),
                              Color(0xFF5CB85C),
                              Color(0xFFB9B7B7)
                            ],
                                stops: [
                              0,
                              0.5,
                              0.5
                            ])),
                        width: 16,
                        height: 16),
                    const SizedBox(width: 5),
                    const Text("Làm 1/2",
                        style: TextStyle(
                            fontStyle: FontStyle.italic, fontSize: 13)),
                    const SizedBox(width: 15),
                    Container(color: Colors.red, width: 16, height: 16),
                    const SizedBox(width: 5),
                    const Text("Nghỉ",
                        style: TextStyle(
                            fontStyle: FontStyle.italic, fontSize: 13)),
                  ],
                ),
              ),
              const SizedBox(height: 20)
            ],
          ),
        ),
      ),
    );
  }
}
