import 'package:cached_network_image/cached_network_image.dart';
import 'package:date_time_format/date_time_format.dart';
import 'package:fade_shimmer/fade_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';

import '../../../utils/golbal/golbal.dart';
import '../../component/use/nodata.dart';
import 'controller/tintuccontroller.dart';

class TinTuc extends StatelessWidget {
  final TintucController controller = Get.put(TintucController());

  TinTuc({Key? key}) : super(key: key);

  Widget itemBuilder(ct, i) {
    var item = controller.datas[i];
    //print(item);
    return InkWell(
      onTap: () {
        controller.goTintuc(item);
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Text(
              item["Tieude"] ?? "",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(
            height: 5.0,
          ),
          if (item["Hinhanh"] != null)
            CachedNetworkImage(
              imageUrl: Golbal.congty!.fileurl + item["Hinhanh"],
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
              fit: BoxFit.fitWidth,
              height: 250,
            ),
          const SizedBox(
            height: 5.0,
          ),
          Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 5.0),
              child: Text(
                item["Mota"] ?? "",
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontWeight: FontWeight.normal),
              )),
          Row(
            children: [
              Text(
                  DateTimeFormat.format(DateTime.parse(item["NgayDuyet"]),
                      format: 'd/m/Y H:i'),
                  style:
                      const TextStyle(fontSize: 13.0, color: Colors.black45)),
              const SizedBox(width: 5),
              if (item["TenNhom"] != null)
                const Text("|",
                    style: TextStyle(fontSize: 13.0, color: Colors.black45)),
              const SizedBox(width: 5),
              if (item["TenNhom"] != null)
                Text(item["TenNhom"] ?? "",
                    style:
                        const TextStyle(fontSize: 13.0, color: Colors.black45)),
              if (item["TenNhom"] != null) const SizedBox(width: 5),
              const Spacer(),
              if (item["IsHot"] == true)
                const Icon(Ionicons.bookmark_sharp, size: 16, color: Colors.red)
            ],
          )
        ],
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
        //NhomTinTuc(),
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
                      txt: "Không có tin tức nào",
                    ),
                  ),
                )
              : ListView.separated(
                  shrinkWrap: true,
                  padding: const EdgeInsets.all(15),
                  physics: const BouncingScrollPhysics(),
                  itemBuilder: itemBuilder,
                  itemCount: controller.datas.length,
                  separatorBuilder: (_, __) => const Divider()),
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
