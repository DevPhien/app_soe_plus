import 'package:date_time_format/date_time_format.dart';
import 'package:fade_shimmer/fade_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';

import '../../../utils/golbal/golbal.dart';
import '../../component/use/nodata.dart';
import 'nhomthongbao.dart';
import 'controller/thongbaocontroller.dart';

class ThongBao extends StatelessWidget {
  final ThongbaoController controller = Get.put(ThongbaoController());

  ThongBao({Key? key}) : super(key: key);
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
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Ionicons.star,
                color: tb["IsHot"] == true ? Colors.orange : Colors.transparent,
                size: 16),
            SizedBox(
              width: 8,
              height: 13,
              child: Padding(
                padding: const EdgeInsets.only(top: 5),
                child: CircleAvatar(
                  radius: 4,
                  backgroundColor: tb["IsRead"] == false
                      ? const Color(0xFF086FE8)
                      : const Color(0xFFB9B7B7),
                ),
              ),
            ),
            const SizedBox(width: 5),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    tb["Tieude"] ?? "",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: tb["IsRead"] == false
                            ? const Color(0xFF086FE8)
                            : Colors.black87),
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      const Icon(
                        AntDesign.calendar,
                        size: 16,
                      ),
                      const SizedBox(width: 5),
                      Text(
                          DateTimeFormat.format(DateTime.parse(tb["NgayDuyet"]),
                              format: 'd/m/Y H:i'),
                          style: const TextStyle(
                              fontSize: 13.0, color: Colors.black54)),
                      const SizedBox(width: 10),
                      Expanded(child: fileWidget(tb["files"]))
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget bodyWidget() {
    return Column(
      children: [
        Container(
          width: double.infinity,
          height: 40,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              color: const Color(0xFFf9f8f8),
              border: Border.all(color: const Color(0xffeeeeee), width: 1.0)),
          child: Center(
            child: TextField(
              onSubmitted: controller.search,
              decoration: const InputDecoration(
                  contentPadding: EdgeInsets.all(5),
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  border: InputBorder.none,
                  hintText: 'Tìm kiếm',
                  prefixIcon: Icon(Icons.search),
                  suffixIcon: Icon(AntDesign.filter)),
            ),
          ),
        ),
        NhomThongBao(),
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
              : ListView.builder(
                  shrinkWrap: true,
                  padding: const EdgeInsets.all(15),
                  physics: const BouncingScrollPhysics(),
                  itemBuilder: itemBuilder,
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
