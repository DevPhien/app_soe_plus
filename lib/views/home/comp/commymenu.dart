import 'package:flutter/material.dart';
import 'package:flutter_shimmer/flutter_shimmer.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:soe/utils/golbal/golbal.dart';

import '../controller/cmymenucontroller.dart';
import '../controller/homeappcontroller.dart';

class HomeMyMenu extends StatelessWidget {
  final HomeMyMenuController controller = Get.put(HomeMyMenuController());
  final HomeAppController homecontroller = Get.put(HomeAppController());
  HomeMyMenu({Key? key}) : super(key: key);

  Widget itemMenu(ct, i) {
    var item = controller.datas[i];
    return Container(
        padding: const EdgeInsets.all(0),
        width: 100 * Golbal.textScaleFactor,
        child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                controller.goMenu(item);
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Stack(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 20),
                        child: SvgPicture.network(
                          item["Icon"] ?? "",
                          height: 36,
                        ),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: const Color(0xfff5f5f5)),
                      ),
                      Obx(() => homecontroller.counthome[item["IsLink"]] !=
                                  null &&
                              homecontroller.counthome[item["IsLink"]] > 0
                          ? Positioned(
                              right: 10,
                              child: CircleAvatar(
                                radius: 10,
                                backgroundColor: Colors.red,
                                child: Text(
                                  homecontroller.counthome[item["IsLink"]] < 10
                                      ? homecontroller.counthome[item["IsLink"]]
                                          .toString()
                                      : "+9",
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 9),
                                ),
                              ))
                          : const SizedBox.shrink())
                    ],
                  ),
                  const SizedBox(height: 10.0),
                  Text(
                    "${item["Menu_App_Ten"]}",
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 13),
                  )
                ],
              ),
            )));
  }

  Widget widgetMenu() {
    return Obx(() => controller.datas.isNotEmpty
        ? SizedBox(
            width: double.infinity,
            height: 110 * Golbal.textScaleFactor,
            child: ListView.builder(
                itemBuilder: itemMenu,
                physics: const BouncingScrollPhysics(),
                itemCount: controller.datas.length,
                padding: const EdgeInsets.only(top: 10, bottom: 0, left: 0),
                scrollDirection: Axis.horizontal))
        : const PlayStoreShimmer(
            hasBottomFirstLine: false,
            hasBottomSecondLine: false,
          ));
  }

  @override
  Widget build(context) {
    return Container(
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Dành cho bạn",
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 17,
                color: Golbal.titleColor),
          ),
          widgetMenu(),
        ],
      ),
    );
  }
}
