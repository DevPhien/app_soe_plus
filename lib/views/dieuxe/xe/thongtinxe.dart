import 'package:auto_size_text/auto_size_text.dart';
import 'package:date_time_format/date_time_format.dart';
import 'package:fade_shimmer/fade_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:soe/utils/golbal/golbal.dart';

import '../../../flutter_flow/flutter_flow_theme.dart';
import '../../component/use/nodata.dart';
import 'xecontroller.dart';

class Thontinxe extends StatelessWidget {
  final XeController controller = Get.put(XeController());

  Thontinxe({Key? key}) : super(key: key);

  Widget infoxe(context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          if (controller.car["Anhdaidien"] != null)
            Image.network(
              Golbal.congty!.fileurl + controller.car["Anhdaidien"],
              width: MediaQuery.of(context).size.width,
              height: 240,
              fit: BoxFit.cover,
            ),
          if (controller.car["khauhao"] != null &&
              controller.car["khauhao"] != "0.0")
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(10, 10, 10, 10),
              child: LinearPercentIndicator(
                percent:
                    double.parse((controller.car["khauhao"] ?? 0).toString()),
                width: MediaQuery.of(context).size.width * 0.9,
                lineHeight: 24,
                animation: true,
                progressColor: const Color(0xFF6DD230),
                backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
                barRadius: const Radius.circular(40),
                padding: EdgeInsets.zero,
              ),
            ),
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(0, 20, 0, 12),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 8),
                      child: Text(
                        'Tình trạng',
                        style: FlutterFlowTheme.of(context).bodyText2,
                      ),
                    ),
                    Text(
                      '${controller.car["khauhao"] ?? 0}%',
                      style: FlutterFlowTheme.of(context).title1,
                    ),
                  ],
                ),
                Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 8),
                      child: Text(
                        'Đã đi',
                        style: FlutterFlowTheme.of(context).bodyText2,
                      ),
                    ),
                    Text(
                      "${Golbal.formatNumber(controller.car["totalKm"])} KM",
                      style: FlutterFlowTheme.of(context).title1.override(
                            color: const Color(0xFFFF8126),
                          ),
                    ),
                  ],
                ),
                Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 8),
                      child: Text(
                        'Trạng thái',
                        style: FlutterFlowTheme.of(context).bodyText2,
                      ),
                    ),
                    Text(
                      controller.car["TenTrangthai"] ?? "",
                      style: FlutterFlowTheme.of(context).title1.override(
                            color: const Color(0xFF045997),
                          ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          if (controller.car["LenhDX_FromDate"] != null)
            InkWell(
              onTap: () {
                Get.toNamed("/detaillenhcar", arguments: {
                  "LenhDX_ID": controller.car["LenhDX_ID"] ??
                      controller.car["LenhDX_ID1"]
                });
              },
              child: Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(16, 0, 16, 0),
                child: Container(
                  width: double.infinity,
                  height: 70,
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    boxShadow: const [
                      BoxShadow(
                        blurRadius: 4,
                        color: Color(0x43000000),
                        offset: Offset(0, 2),
                      )
                    ],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Padding(
                        padding:
                            const EdgeInsetsDirectional.fromSTEB(12, 0, 0, 0),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 50,
                              height: 50,
                              clipBehavior: Clip.antiAlias,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                              ),
                              child: Image.network(
                                'https://cdn-icons-png.flaticon.com/512/235/235861.png?w=360',
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(
                              12, 0, 16, 0),
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    controller.car["fullName_nguoisudung"] ??
                                        "",
                                    textAlign: TextAlign.start,
                                    style: FlutterFlowTheme.of(context)
                                        .bodyText2
                                        .override(
                                          color: FlutterFlowTheme.of(context)
                                              .primaryBtnText,
                                          fontWeight: FontWeight.normal,
                                        ),
                                  ),
                                  Text(
                                    DateTimeFormat.format(
                                        DateTime.parse(
                                            controller.car["LenhDX_FromDate"]),
                                        format: 'H:m'),
                                    textAlign: TextAlign.end,
                                    style: FlutterFlowTheme.of(context)
                                        .bodyText2
                                        .override(
                                          color: FlutterFlowTheme.of(context)
                                              .primaryBtnText,
                                          fontWeight: FontWeight.normal,
                                        ),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    0, 4, 0, 0),
                                child: Text(
                                  controller.car["LenhDX_Hanhtrinh"] ?? "",
                                  style: FlutterFlowTheme.of(context)
                                      .bodyText1
                                      .override(
                                        color: FlutterFlowTheme.of(context)
                                            .secondaryBackground,
                                      ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(8, 8, 8, 0),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(8, 8, 8, 8),
                    child: InkWell(
                      onTap: () async {
                        controller.goinfoCar(controller.car);
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.4,
                        height: 150,
                        decoration: BoxDecoration(
                          color: FlutterFlowTheme.of(context).tertiary400,
                          boxShadow: const [
                            BoxShadow(
                              blurRadius: 4,
                              color: Color(0x37000000),
                              offset: Offset(0, 1),
                            )
                          ],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            const Padding(
                              padding:
                                  EdgeInsetsDirectional.fromSTEB(0, 16, 0, 0),
                              child: Icon(
                                Icons.info_rounded,
                                color: Colors.white,
                                size: 44,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  0, 8, 0, 0),
                              child: AutoSizeText(
                                'Thông tin',
                                textAlign: TextAlign.center,
                                style: FlutterFlowTheme.of(context)
                                    .subtitle1
                                    .override(
                                      color: Colors.white,
                                    ),
                              ),
                            ),
                            const Expanded(
                              child: Padding(
                                padding:
                                    EdgeInsetsDirectional.fromSTEB(8, 4, 8, 0),
                                child: Text(
                                  'Xem thông tin xe',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Color(0xB3FFFFFF),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(8, 8, 8, 8),
                    child: InkWell(
                      onTap: () async {
                        controller.gohistoryCar(controller.car);
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.4,
                        height: 150,
                        decoration: BoxDecoration(
                          color: const Color(0xFF045997),
                          boxShadow: const [
                            BoxShadow(
                              blurRadius: 3,
                              color: Color(0x39000000),
                              offset: Offset(0, 1),
                            )
                          ],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Padding(
                              padding:
                                  EdgeInsetsDirectional.fromSTEB(0, 16, 0, 0),
                              child: Icon(
                                Icons.electric_car,
                                color: Colors.white,
                                size: 44,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  0, 8, 0, 0),
                              child: AutoSizeText(
                                'Lịch sử',
                                textAlign: TextAlign.center,
                                style: FlutterFlowTheme.of(context)
                                    .subtitle1
                                    .override(
                                      color: Colors.white,
                                    ),
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    8, 4, 8, 0),
                                child: Text(
                                  'Đã đặt ${controller.car["totalLanDatxe"] ?? 0} lần',
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    color: Color(0xB3FFFFFF),
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
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
        ),
        backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
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
                : controller.car.isEmpty
                    ? SizedBox(
                        height: 400,
                        child: Center(
                          child: Obx(() => const WidgetNoData(
                                txt: "Không có xe nào",
                                icon: AntDesign.calendar,
                              )),
                        ),
                      )
                    : infoxe(context))));
  }
}
