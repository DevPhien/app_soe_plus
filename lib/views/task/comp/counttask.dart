import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../controller/taskcontroller.dart';

class CountTask extends StatelessWidget {
  final TaskController controller = Get.put(TaskController());

  CountTask({Key? key}) : super(key: key);
  //Function
  Widget countTask(String title, String ckey, int type) {
    return Obx(() => Container(
        margin: const EdgeInsets.only(left: 10),
        decoration: BoxDecoration(
            color: controller.typeVB.value == type
                ? const Color(0xFFCEF1D9)
                : const Color(0xFFEFF8FF),
            borderRadius: BorderRadius.circular(5)),
        width: 90,
        child: InkResponse(
          focusColor: Colors.transparent,
          hoverColor: Colors.transparent,
          highlightColor: Colors.transparent,
          onTap: () {
            controller.goTypeTask(type);
          },
          child: Stack(
            alignment: Alignment.center,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    "assets/doc.svg",
                    height: 32,
                  ),
                  const SizedBox(
                    height: 3,
                  ),
                  Text(
                    title,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                        fontSize: 15),
                  ),
                ],
              ),
              if (controller.countdata[ckey] != null &&
                  controller.countdata[ckey] > 0)
                Positioned(
                    top: 0,
                    left: 0,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 2, horizontal: 8),
                      decoration: const BoxDecoration(
                        color: Color(0xfffd5d19),
                      ),
                      child: Text(
                        "${controller.countdata[ckey] ?? ""}",
                        style:
                            const TextStyle(color: Colors.white, fontSize: 12),
                      ),
                    ))
            ],
          ),
        )));
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 70,
      child: Row(
        children: [
          Container(
              margin: const EdgeInsets.only(top: 5, left: 15, bottom: 5),
              decoration: BoxDecoration(
                  color: const Color(0xFF005A9E),
                  borderRadius: BorderRadius.circular(5)),
              width: 90,
              child: InkResponse(
                focusColor: Colors.transparent,
                hoverColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onTap: () {
                  controller.goTypeTask(-1);
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Tổng số",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    const SizedBox(
                      height: 3,
                    ),
                    Obx(() => Text(
                          "${controller.countdata["-1"] ?? ""}",
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: 18),
                        )),
                  ],
                ),
              )),
          Expanded(
            child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(vertical: 5.0),
              scrollDirection: Axis.horizontal,
              itemCount: controller.typeCongviecs.length,
              itemBuilder: (BuildContext context, int index) {
                var item = controller.typeCongviecs[index];
                return countTask(
                    item["title"].toString(),
                    item["id"].toString(),
                    int.tryParse(item["id"].toString()) ?? 1);
              },
            ),
          ),
          const SizedBox(width: 10)
        ],
      ),
    );
  }
}
