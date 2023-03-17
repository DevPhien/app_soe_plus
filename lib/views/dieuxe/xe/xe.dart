import 'package:fade_shimmer/fade_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:soe/utils/golbal/golbal.dart';

import '../../../flutter_flow/flutter_flow_theme.dart';
import '../../component/use/nodata.dart';
import 'xecontroller.dart';

class Listxe extends StatelessWidget {
  final XeController controller = Get.put(XeController());

  Listxe({Key? key}) : super(key: key);

  Widget itemCar(ct, i) {
    var item = controller.cars[i];
    Color bgColor = const Color(0xFFBBBBBB);
    Color txtColor = const Color(0xFF57636C);
    if (item["on_off"] == false) {
      bgColor = const Color(0xFFFD0A0A);
      txtColor = Colors.white;
    } else if (item["TrangthaiXe"] == "Đang đi") {
      bgColor = const Color(0xFF6DD230);
      txtColor = Colors.white;
    } else if (item["TrangthaiXe"] == "Đã được đặt") {
      bgColor = const Color(0xFFF18636);
      txtColor = Colors.white;
    }
    return InkWell(
      onTap: () async {
        controller.goCar(item);
      },
      child: Card(
        clipBehavior: Clip.antiAliasWithSaveLayer,
        color: bgColor,
        elevation: 0,
        child: Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(10, 10, 10, 10),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                    Golbal.congty!.fileurl + (item["Anhdaidien"] ?? ""),
                    width: MediaQuery.of(ct).size.width,
                    height: 80,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(0, 5, 0, 0),
                child: Text(
                  item["Bienso"] ?? "",
                  style: TextStyle(
                    color: FlutterFlowTheme.of(ct).primaryBtnText,
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                  ),
                ),
              ),
              Text(
                item["Loaixe"] ?? "",
                style: FlutterFlowTheme.of(ct)
                    .subtitle2
                    .override(fontWeight: FontWeight.normal, color: txtColor),
              ),
              Text(
                '${item["Sochongoi"] ?? ""} chỗ | ${item["Namsanxuat"] ?? ""}',
                style: FlutterFlowTheme.of(ct)
                    .bodyText2
                    .override(fontWeight: FontWeight.w600, color: txtColor),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget gridCar() {
    return GridView.builder(
        shrinkWrap: true,
        itemCount: controller.cars.length,
        padding: EdgeInsets.zero,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 5,
          mainAxisSpacing: 5,
          childAspectRatio: 1,
        ),
        scrollDirection: Axis.vertical,
        itemBuilder: (ct, i) => itemCar(ct, i));
  }

  //Function
  @override
  Widget build(BuildContext context) {
    return Obx(() => controller.isLoadding.value
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
        : controller.cars.isEmpty
            ? SizedBox(
                height: 400,
                child: Center(
                  child: Obx(() => const WidgetNoData(
                        txt: "Không có xe nào",
                        icon: AntDesign.calendar,
                      )),
                ),
              )
            : Padding(
                padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
                child: gridCar(),
              ));
  }
}
