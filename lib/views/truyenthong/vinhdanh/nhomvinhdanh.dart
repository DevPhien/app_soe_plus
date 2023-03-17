import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'vinhdanhcontroller.dart';

class NhomVinhdanh extends StatelessWidget {
  final VinhdanhController controller = Get.put(VinhdanhController());

  NhomVinhdanh({Key? key}) : super(key: key);
  //Function
  Widget itemNhomTB(ct, i) {
    var nhom = controller.years[i];
    return Container(
        margin: const EdgeInsets.only(left: 10),
        decoration: BoxDecoration(
            color: controller.year == nhom["year"]
                ? const Color(0xFFCEF1D9)
                : const Color(0xFFEFF8FF),
            borderRadius: BorderRadius.circular(5)),
        width: 80,
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
                    nhom["year"].toString(),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
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

  Widget tongSo() {
    return InkWell(
      onTap: () {
        controller.goNhom();
      },
      child: Container(
        margin: const EdgeInsets.only(left: 10),
        decoration: BoxDecoration(
            color: const Color(0xFF005A9E),
            borderRadius: BorderRadius.circular(5)),
        width: 80,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text(
                  "Tổng số",
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 15),
                ),
              ],
            ),
            Positioned(
                top: 0,
                left: 0,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 2, horizontal: 8),
                  decoration: const BoxDecoration(
                    color: Color(0xfffd5d19),
                  ),
                  child: Text(
                    controller.tong.toString(),
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ))
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => SizedBox(
          height: 60,
          child: Row(
            children: [
              tongSo(),
              const SizedBox(width: 10),
              Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.all(0),
                  scrollDirection: Axis.horizontal,
                  itemCount: controller.years.length,
                  itemBuilder: itemNhomTB,
                ),
              ),
            ],
          ),
        ));
  }
}
