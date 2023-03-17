import 'package:fade_shimmer/fade_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:soe/views/component/use/avatar.dart';

import '../../../utils/golbal/golbal.dart';
import '../../component/use/nodata.dart';
import 'nhomvinhdanh.dart';
import 'vinhdanhcontroller.dart';

class Vinhdanh extends StatelessWidget {
  final VinhdanhController controller = Get.put(VinhdanhController());

  Vinhdanh({Key? key}) : super(key: key);
  Widget fileWidget(List? files) {
    if (files == null || files.isEmpty) return const SizedBox.shrink();
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Icon(
          Entypo.attachment,
          size: 15,
        ),
        const SizedBox(width: 5),
        if (files.length > 1)
          CircleAvatar(
            radius: 8,
            backgroundColor: Colors.red,
            child: Text(
              files.length.toString(),
              style: const TextStyle(color: Colors.white, fontSize: 13),
            ),
          ),
        if (files.length == 1)
          Expanded(
            child: Text(
              files[0]["Tenfile"],
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 13,
                  color: Golbal.titleColor),
            ),
          )
      ],
    );
  }

  Widget itemBuilder(ct, i) {
    var tb = controller.datas[i];
    return InkWell(
      onTap: () {
        controller.goThongbao(tb);
      },
      child: Container(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            SizedBox(
              width: 160,
              height: 160,
              child: Stack(
                alignment: AlignmentDirectional.center,
                children: [
                  Positioned(
                    child: CircleAvatar(
                      radius: 47,
                      backgroundColor: const Color(0xFF005A9E),
                      child: Padding(
                        padding: const EdgeInsets.all(1.0),
                        child: UserAvarta(
                          user: tb,
                          radius: 45,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: 160,
                    height: 160,
                    decoration: const BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage("assets/BoxVinhdanh.png"))),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 5),
            Text(tb["Tieude"]??"",
                style: const TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.black87)),
            const SizedBox(height: 5),
            Row(
              children: [
                const SizedBox(child: Text("Họ và tên: "), width: 100),
                Expanded(
                    child: Text(tb["fullName"]??"",
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black54))),
              ],
            ),
            const SizedBox(height: 5),
            Row(
               crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(child: Text("Chức vụ: "), width: 100),
                Expanded(
                    child: Text(tb["tenChucVu"]??"",
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black54))),
              ],
            ),
            const SizedBox(height: 5),
            Row(
               crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(child: Text("Phòng: "), width: 100),
                Expanded(
                    child: Text(tb["tenTochuc"]??"",
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black54))),
              ],
            ),
            const SizedBox(height: 5),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(child: Text("Đơn vị: "), width: 100),
                Expanded(
                    child: Text(tb["tenCongty"]??"",
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black54))),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget bodyWidget() {
    return Column(
      children: [
       const SizedBox(height: 10),
        NhomVinhdanh(),
        Expanded(child: listWidget())
      ],
    );
  }

  Widget listWidget() {
    return Obx(
      () => controller.isLoadding.value
          ? ListView.separated(
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(),
              itemBuilder: (_, i) {
                final delay = (i * 300);
                return Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8)),
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      FadeShimmer.round(
                        size: 60,
                        fadeTheme: FadeTheme.light,
                        millisecondsDelay: delay,
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          FadeShimmer(
                            height: 8,
                            width: 150,
                            radius: 4,
                            millisecondsDelay: delay,
                            fadeTheme: FadeTheme.light,
                          ),
                          const SizedBox(
                            height: 6,
                          ),
                          FadeShimmer(
                              height: 8,
                              millisecondsDelay: delay,
                              width: 170,
                              radius: 4,
                              fadeTheme: FadeTheme.light)
                        ],
                      )
                    ],
                  ),
                );
              },
              itemCount: 20,
              separatorBuilder: (_, __) => const Divider(
                height: 1,
                color: Color(0xffeeeeee),
              ),
            )
          : controller.datas.isEmpty
              ? const SizedBox(
                  height: 400,
                  child: Center(
                    child: WidgetNoData(
                      txt: "Không có thông báo nào",
                    ),
                  ),
                )
              : ListView.separated(
                  shrinkWrap: true,
                  padding: const EdgeInsets.all(15),
                  physics: const BouncingScrollPhysics(),
                  itemBuilder: itemBuilder,
                  separatorBuilder: (ct, i) => const Divider(
                    height: 1,
                  ),
                  itemCount: controller.datas.length,
                ),
    );
  }

  //Function
  @override
  Widget build(BuildContext context) {
    return MediaQuery(
        data: MediaQuery.of(context)
            .copyWith(textScaleFactor: Golbal.textScaleFactor),
        child: Scaffold(
            backgroundColor: const Color(0xffffffff), body: bodyWidget()));
  }
}
