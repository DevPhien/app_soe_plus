import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'controller/tintuccontroller.dart';

class NhomTinTuc extends StatelessWidget {
  final TintucController controller = Get.put(TintucController());

  NhomTinTuc({Key? key}) : super(key: key);
  //Function
  Widget itemNhomTB(ct, i) {
    var nhom = controller.datanhoms[i];
    return Container(
        margin: const EdgeInsets.only(left: 10),
        decoration: BoxDecoration(
            color: controller.nhom["LoaiTT_ID"] == nhom["LoaiTT_ID"]
                ? const Color(0xFFCEF1D9)
                : const Color(0xFFEFF8FF),
            borderRadius: BorderRadius.circular(5)),
        width: 100,
        child: InkResponse(
          focusColor: Colors.transparent,
          hoverColor: Colors.transparent,
          highlightColor: Colors.transparent,
          onTap: () {
            controller.goNhom(typenhom: nhom);
          },
          child: Stack(
            alignment: Alignment.center,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    nhom["TenLoai"],
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                        fontSize: 15),
                  ),
                ],
              ),
              if (nhom["count"] != null && nhom["count"] > 0)
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
                        nhom["count"] ?? "",
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
          child: ListView.builder(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 15),
            scrollDirection: Axis.horizontal,
            itemCount: controller.datanhoms.length,
            itemBuilder: itemNhomTB,
          ),
        ));
  }
}
