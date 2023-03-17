import 'package:fade_shimmer/fade_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../component/use/nodata.dart';
import '../controller/vanbanhomecontroller.dart';
import 'itemvanban.dart';

class VanbanHome extends StatelessWidget {
  final HomeVanbanController controller = Get.put(HomeVanbanController());

  VanbanHome({Key? key}) : super(key: key);

  Widget itemBuilder(ct, i) => ItemVanban(
      key: Key(controller.datas[i]["vanBanMasterID"]),
      vanban: controller.datas[i],
      pageIndex: controller.pageIndex.value,
      isShowTrangthai: controller.pageIndex.value == 1);
  //Function
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => controller.isLoadding.value
          ? ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
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
                      txt: "Không có văn bản nào",
                    ),
                  ),
                )
              : ListView.separated(
                  shrinkWrap: true,
                  padding: const EdgeInsets.all(15),
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: itemBuilder,
                  itemCount: controller.datas.length,
                  separatorBuilder: (_, __) => const Divider(
                        height: 1,
                        color: Color(0xffeeeeee),
                      )),
    );
  }
}
