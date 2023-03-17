import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../controller/vanbanhomecontroller.dart';

class CCountVanban extends StatelessWidget {
  final HomeVanbanController controller = Get.put(HomeVanbanController());

  CCountVanban({Key? key}) : super(key: key);
  //Function
  Widget countVB(String title, String ckey,int type) {
    return Container(
        margin: const EdgeInsets.only(left: 10),
        decoration: BoxDecoration(
            color:controller.typeVB.value==type?const Color(0xFFCEF1D9): const Color(0xFFEFF8FF),
            borderRadius: BorderRadius.circular(5)),
        width: 100,
        child: InkResponse(
          focusColor: Colors.transparent,
          hoverColor: Colors.transparent,
          highlightColor: Colors.transparent,
          onTap: () {
            controller.goTypeVanban(type);
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
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => SizedBox(
          height: 80,
          child: ListView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 15),
            scrollDirection: Axis.horizontal,
            children: [
              Container(
                  decoration: BoxDecoration(
                      color: const Color(0xFF005A9E),
                      borderRadius: BorderRadius.circular(5)),
                  width: 100,
                  child: InkResponse(
                    focusColor: Colors.transparent,
                    hoverColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    onTap: () {
                      controller.goTypeVanban(0);
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
                        Text(
                          "${controller.countdata["vball"] ?? ""}",
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: 18),
                        ),
                      ],
                    ),
                  )),
              countVB("Đến", "vbden",1),
              countVB("Đi", "vbdi",2),
              countVB("Nội bộ", "vbnoibo",3),
              if (controller.pageIndex.value == 1) countVB("Chờ xử lý", "vbxl",4),
              if (controller.pageIndex.value == 1) countVB("Chưa đọc", "vbcd",5),
              if (controller.pageIndex.value == 1) countVB("Quá hạn", "vbqh",6),
            ],
          ),
        ));
  }
}
