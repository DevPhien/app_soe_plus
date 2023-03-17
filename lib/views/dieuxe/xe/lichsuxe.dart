import 'package:date_time_format/date_time_format.dart';
import 'package:fade_shimmer/fade_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';

import '../../../flutter_flow/flutter_flow_theme.dart';
import '../../component/use/avatar.dart';
import '../../component/use/inlineloadding.dart';
import '../../component/use/nodata.dart';
import '../comp/trangthaixe.dart';
import 'xecontroller.dart';

class Lichsuxe extends StatelessWidget {
  final XeController controller = Get.put(XeController());

  Lichsuxe({Key? key}) : super(key: key);

  Widget itemWidget(context, int i) {
    return InkWell(
      onTap: () async {
        Get.toNamed("/detaillenhcar", arguments: controller.hystorycars[i]);
      },
      child: Card(
        clipBehavior: Clip.antiAliasWithSaveLayer,
        color: Colors.white,
        elevation: 0,
        child: Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(10, 10, 10, 10),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 5),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TrangthaiXe(
                        tttask: controller.hystorycars[i], isphieu: false),
                    Text(
                      DateTimeFormat.format(
                          DateTime.parse(
                              controller.hystorycars[i]["LenhDX_FromDate"]),
                          format: 'H:i d/m/Y'),
                      style: FlutterFlowTheme.of(context).bodyText2.override(
                            fontWeight: FontWeight.normal,
                            fontStyle: FontStyle.italic,
                          ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(0, 5, 0, 0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Expanded(
                      child: Padding(
                        padding:
                            const EdgeInsetsDirectional.fromSTEB(0, 0, 10, 0),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                const Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      0, 0, 5, 0),
                                  child: Icon(
                                    Icons.car_repair,
                                    color: Color(0xFFF18636),
                                    size: 20,
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    controller.hystorycars[i]
                                            ["LenhDX_Noicongtac"] ??
                                        "",
                                    style: FlutterFlowTheme.of(context)
                                        .bodyText1
                                        .override(
                                          color: FlutterFlowTheme.of(context)
                                              .secondaryText,
                                        ),
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  0, 5, 0, 0),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Padding(
                                    padding:
                                        const EdgeInsetsDirectional.fromSTEB(
                                            0, 0, 5, 0),
                                    child: Icon(
                                      Icons.pin_drop,
                                      color: FlutterFlowTheme.of(context)
                                          .secondaryColor,
                                      size: 20,
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      controller.hystorycars[i]
                                              ["LenhDX_Hanhtrinh"] ??
                                          "",
                                      style: FlutterFlowTheme.of(context)
                                          .bodyText1
                                          .override(
                                            color: FlutterFlowTheme.of(context)
                                                .secondaryText,
                                          ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    UserAvarta(
                      user: {
                        "anhThumb": controller.hystorycars[i]
                            ["anhDaidien_nguoisudung"],
                        "ten": controller.hystorycars[i]["ten_nguoisudung"]
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget listLichsuWidget(context) {
    return ListView.builder(
      shrinkWrap: true,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      itemBuilder: (ct, i) => itemWidget(context, i),
      itemCount: controller.hystorycars.length,
    );
  }

  //Function
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
          iconTheme: const IconThemeData(color: Color(0xFF0186f8)),
          automaticallyImplyLeading: true,
          title: Text(
            (controller.car["Loaixe"] ?? "") +
                " - " +
                (controller.car["Bienso"] ?? ""),
            style: FlutterFlowTheme.of(context).title2.override(
                  color: const Color(0xFF0186f8),
                  fontWeight: FontWeight.bold,
                ),
          ),
          centerTitle: false,
          elevation: 0,
          actions: [
            IconButton(
                onPressed: controller.openDate,
                icon: const Icon(Icons.calendar_month_outlined))
          ],
        ),
        backgroundColor: const Color(0xFFEEEEEE),
        body: SafeArea(
            child: Obx(() => controller.isLoadding.value
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
                : Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Container(
                            height: 40,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                color: const Color(0xFFffffff),
                                border: Border.all(
                                    color: const Color(0xffeeeeee),
                                    width: 1.0)),
                            child: Center(
                              child: TextFormField(
                                textAlignVertical: TextAlignVertical.center,
                                initialValue: controller.options["s"],
                                onFieldSubmitted: controller.search,
                                decoration: const InputDecoration(
                                  contentPadding: EdgeInsets.all(5),
                                  focusedBorder: InputBorder.none,
                                  enabledBorder: InputBorder.none,
                                  border: InputBorder.none,
                                  hintText: 'Tìm kiếm',
                                  prefixIcon: Icon(Icons.search),
                                ),
                              ),
                            )),
                      ),
                      controller.hystorycars.isEmpty
                          ? const SizedBox(
                              height: 400,
                              child: Center(
                                child: WidgetNoData(
                                  txt: "Không có lệnh điều xe nào",
                                  icon: AntDesign.calendar,
                                ),
                              ),
                            )
                          : Expanded(child: listLichsuWidget(context)),
                      Obx(() => controller.loaddingmore.value
                          ? const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: InlineLoadding(),
                            )
                          : const SizedBox.shrink()),
                      Obx(() => !controller.loaddingmore.value &&
                              controller.isloaddingmore.value
                          ? Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextButton(
                                  onPressed: controller.onLoadmore,
                                  child: Text(
                                    "Xem thêm (${controller.hystorycars.length}/${controller.options["total"]})",
                                  )),
                            )
                          : const SizedBox.shrink()),
                    ],
                  ))));
  }
}
