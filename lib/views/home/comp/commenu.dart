import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_shimmer/flutter_shimmer.dart';
import 'package:get/get.dart';
import 'package:soe/utils/golbal/golbal.dart';

import '../controller/cmenucontroller.dart';

class HomeMenu extends StatelessWidget {
  final HomeMenuController controller = Get.put(HomeMenuController());

  HomeMenu({Key? key}) : super(key: key);

  Widget itemMenu(ct, i) {
    var item = controller.datas[i];
    return Container(
      width: 120 * Golbal.textScaleFactor,
      margin: const EdgeInsets.only(right: 20),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: const Color(0xffEFF8FF)),
      child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => controller.goMenu(item),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CachedNetworkImage(
                      imageUrl: item["Image"],
                      height: 40,
                    ),
                    const SizedBox(height: 5.0),
                    Text(
                      "${item["IsTypeModule"]}",
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 13),
                    ),
                  ],
                ),
                Positioned(
                    top: 15,
                    right: 30,
                    child: Obx(() =>
                        controller.countdata[item["Module_ID"]] != null &&
                                controller.countdata[item["Module_ID"]] > 0
                            ? CircleAvatar(
                                radius: 11.0,
                                backgroundColor: const Color(0xFFff601c),
                                child: Text(
                                  "${controller.countdata[item["Module_ID"]] < 100 ? controller.countdata[item["Module_ID"]] : '99+'}",
                                  style: const TextStyle(
                                      fontSize: 9.0, color: Colors.white),
                                  textAlign: TextAlign.center,
                                  overflow: TextOverflow.ellipsis,
                                ))
                            : const SizedBox.shrink()))
              ],
            ),
          )),
    );
  }

  Widget widgetMenu() {
    return Obx(
      () => controller.datas.isNotEmpty
          ? SizedBox(
              width: double.infinity,
              height: 120,
              child: ListView.builder(
                  itemBuilder: itemMenu,
                  physics: const BouncingScrollPhysics(),
                  itemCount: controller.datas.length,
                  padding: const EdgeInsets.only(top: 20, bottom: 0, left: 10),
                  scrollDirection: Axis.horizontal))
          : const PlayStoreShimmer(
              hasBottomFirstLine: false,
              hasBottomSecondLine: false,
            ),
    );
  }

  @override
  Widget build(context) {
    return Container(
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 5),
          Text(
            "Tính năng",
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
