import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'controller/thongbaocontroller.dart';

class NhomThongBao extends StatelessWidget {
  final ThongbaoController controller = Get.put(ThongbaoController());

  NhomThongBao({Key? key}) : super(key: key);
  //Function
  Widget itemNhomTB(ct, i) {
    var nhom = controller.datanhoms[i];
    return Container(
        margin: const EdgeInsets.only(left: 10),
        decoration: BoxDecoration(
            color: nhom["LoaiTB_ID"] == null
                ? const Color(0xFF005A9E)
                : controller.nhom["LoaiTB_ID"] == nhom["LoaiTB_ID"]
                    ? const Color(0xFFCEF1D9)
                    : const Color(0xFFEFF8FF),
            borderRadius: BorderRadius.circular(5)),
        width: nhom["LoaiTB_ID"] == null ? 100 : 120,
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
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: nhom["LoaiTB_ID"] == null
                            ? Colors.white
                            : Colors.black87,
                        fontSize: 15),
                  ),
                ],
              ),
              if (nhom["CountTB"] != null && nhom["CountTB"] > 0)
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
                        nhom["CountTB"].toString(),
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
