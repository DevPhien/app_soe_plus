import 'package:badges/badges.dart' as bd;
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../flutter_flow/flutter_flow_theme.dart';
import '../../../flutter_flow/flutter_flow_widgets.dart';
import '../dieuxecontroller.dart';

class CCountDieuxe extends StatelessWidget {
  final DieuxeController controller = Get.put(DieuxeController());

  CCountDieuxe({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return // Generated code for this Nutlenh Widget...
        Container(
      padding: const EdgeInsetsDirectional.fromSTEB(0, 10, 15, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(10, 0, 10, 0),
              child: bd.Badge(
                badgeContent: Obx(() => Text(
                      "${controller.countdata["totalPhieu"] ?? 0}",
                      textAlign: TextAlign.start,
                      style: FlutterFlowTheme.of(context).bodyText1.override(
                            color: Colors.white,
                          ),
                    )),
                showBadge: true,
                badgeStyle: bd.BadgeStyle(
                  shape: bd.BadgeShape.circle,
                  badgeColor: FlutterFlowTheme.of(context).tertiaryColor,
                  elevation: 0,
                  padding: const EdgeInsetsDirectional.fromSTEB(8, 8, 8, 8),
                ),
                position: bd.BadgePosition.topEnd(),
                badgeAnimation: const bd.BadgeAnimation.rotation(
                  curve: Curves.fastOutSlowIn,
                  toAnimate: true,
                ),
                child: Obx(() => FFButtonWidget(
                      onPressed: () {
                        controller.toogleDieuxe(true);
                      },
                      text: 'Phiếu đặt',
                      icon: const Icon(
                        Icons.file_copy_sharp,
                        size: 15,
                      ),
                      options: FFButtonOptions(
                        width: double.infinity,
                        height: 40,
                        color: controller.isPhieu.value
                            ? const Color(0xFF045997)
                            : const Color(0xFFeeeeee),
                        textStyle:
                            FlutterFlowTheme.of(context).subtitle2.override(
                                  color: controller.isPhieu.value
                                      ? Colors.white
                                      : Colors.black87,
                                  fontWeight: FontWeight.w300,
                                ),
                        borderSide: const BorderSide(
                          color: Colors.transparent,
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(5),
                      ),
                    )),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(10, 0, 0, 0),
              child: bd.Badge(
                badgeContent: Obx(
                  () => Text("${controller.countdata["totalLenh"] ?? 0}",
                      textAlign: TextAlign.start,
                      style: FlutterFlowTheme.of(context).bodyText1.override(
                            color: Colors.white,
                          )),
                ),
                showBadge: true,
                badgeStyle: bd.BadgeStyle(
                  shape: bd.BadgeShape.circle,
                  badgeColor: FlutterFlowTheme.of(context).tertiaryColor,
                  elevation: 0,
                  padding: const EdgeInsetsDirectional.fromSTEB(8, 8, 8, 8),
                ),
                position: bd.BadgePosition.topEnd(),
                badgeAnimation: const bd.BadgeAnimation.rotation(
                  curve: Curves.fastOutSlowIn,
                  toAnimate: true,
                ),
                child: Obx(
                  () => FFButtonWidget(
                      onPressed: () {
                        controller.toogleDieuxe(false);
                      },
                      text: 'Lệnh điều',
                      icon: const Icon(
                        Icons.file_copy_sharp,
                        size: 15,
                      ),
                      options: FFButtonOptions(
                        width: double.infinity,
                        height: 40,
                        color: !controller.isPhieu.value
                            ? const Color(0xFF045997)
                            : const Color(0xFFeeeeee),
                        textStyle:
                            FlutterFlowTheme.of(context).subtitle2.override(
                                  color: !controller.isPhieu.value
                                      ? Colors.white
                                      : Colors.black87,
                                  fontWeight: FontWeight.w300,
                                ),
                        borderSide: const BorderSide(
                          color: Colors.transparent,
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(5),
                      )),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
