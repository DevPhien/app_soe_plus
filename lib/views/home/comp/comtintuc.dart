import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:soe/utils/golbal/golbal.dart';

import '../controller/ctintuccontroller.dart';

class HomeTintuc extends StatelessWidget {
  final HomeTintucController controller = Get.put(HomeTintucController());

  HomeTintuc({Key? key}) : super(key: key);

  Widget itemMenu(ct, i) {
    var item = controller.datas[i];
    return InkWell(
      onTap: () {
        controller.goDetail(item);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 5.0),
        width: 250,
        child: Card(
          margin: const EdgeInsets.only(bottom: 10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5.0),
          ),
          child: Column(
            children: [
              if (item["Hinhanh"] != null)
                CachedNetworkImage(
                  imageUrl: item["Hinhanh"] ?? "",
                  imageBuilder: (context, imageProvider) => Container(
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(5),
                          topRight: Radius.circular(5)),
                      image: DecorationImage(
                        image: imageProvider,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  fit: BoxFit.cover,
                  height: 150,
                ),
              const SizedBox(
                height: 5.0,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  item["Tieude"] ?? "",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5.0),
                  child: Text(
                    item["Mota"] ?? "",
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.normal),
                  ))
            ],
          ),
        ),
      ),
    );
  }

  Widget widgetData() {
    return SizedBox(
      width: double.infinity,
      height: (Golbal.textScaleFactor > 1 ? 300 : 260) * Golbal.textScaleFactor,
      child: Obx(() => controller.datas.isNotEmpty
          ? ListView.builder(
              itemBuilder: itemMenu,
              physics: const BouncingScrollPhysics(),
              itemCount: controller.datas.length,
              padding: const EdgeInsets.only(top: 0, bottom: 0, left: 10),
              scrollDirection: Axis.horizontal)
          : Container()),
    );
  }

  @override
  Widget build(context) {
    return Container(
      padding: const EdgeInsets.only(bottom: 5),
      child: widgetData(),
    );
  }
}
