import 'package:date_time_format/date_time_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';

import '../../../flutter_flow/flutter_flow_theme.dart';
import '../../../flutter_flow/flutter_flow_widgets.dart';
import '../../../utils/golbal/golbal.dart';
import '../../component/use/avatar.dart';
import '../../component/use/inlineloadding.dart';
import '../dieuxecontroller.dart';
import 'chitietphieuxecontroller.dart';

class ChitietPhieuxe extends StatelessWidget {
  final ChitietPhieuxeController controller =
      Get.put(ChitietPhieuxeController());
  final DieuxeController dxcontroller = Get.put(DieuxeController());

  ChitietPhieuxe({Key? key}) : super(key: key);
  Widget noidungGui(data) {
    if (data["noidungNguoigui"] == null || data["noidungNguoigui"] == "") {
      return const SizedBox.shrink();
    }
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: const Color(0xFFDBF1FF)),
      padding: const EdgeInsets.all(10),
      child: Row(
        children: [
          UserAvarta(
            user: {
              "anhThumb": data["anhnguoigui"],
              "fullName": data["fullnameNguoigui"]
            },
            radius: 16,
          ),
          const SizedBox(width: 10),
          Expanded(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                data["fullnameNguoigui"] ?? "",
                style: FlutterFlowTheme.of(Get.context!).bodyText1,
              ),
              Text(
                data["noidungNguoigui"] ?? "",
                style: FlutterFlowTheme.of(Get.context!).bodyText2,
              ),
            ],
          ))
        ],
      ),
    );
  }

  Widget infoPhieu(context) {
    var data = controller.phieuxe;
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 10, 0),
                child: Icon(
                  Icons.insert_drive_file_sharp,
                  color: FlutterFlowTheme.of(context).secondaryText,
                  size: 16,
                ),
              ),
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 5, 0),
                child: Text(
                  'Số phiếu:',
                  style: FlutterFlowTheme.of(context).bodyText2.override(
                        fontWeight: FontWeight.normal,
                      ),
                ),
              ),
              Text(
                '${data["PhieuDX_Sophieu"]}',
                style: FlutterFlowTheme.of(context).bodyText1.override(
                      color: FlutterFlowTheme.of(context).backgroundComponents,
                    ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(0, 5, 0, 0),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 10, 0),
                  child: Icon(
                    Icons.date_range,
                    color: FlutterFlowTheme.of(context).secondaryText,
                    size: 16,
                  ),
                ),
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 5, 0),
                  child: Text(
                    'Ngày lập:',
                    style: FlutterFlowTheme.of(context).bodyText2.override(
                          fontWeight: FontWeight.normal,
                        ),
                  ),
                ),
                Text(
                  DateTimeFormat.format(DateTime.parse(data["PhieuDX_Ngaylap"]),
                      format: 'H:i d/m/Y'),
                  style: FlutterFlowTheme.of(context).bodyText1.override(
                        color:
                            FlutterFlowTheme.of(context).backgroundComponents,
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
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 10, 0),
                  child: Icon(
                    Icons.person,
                    color: FlutterFlowTheme.of(context).secondaryText,
                    size: 16,
                  ),
                ),
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 5, 0),
                  child: Text(
                    'Người đặt:',
                    style: FlutterFlowTheme.of(context).bodyText2.override(
                          fontWeight: FontWeight.normal,
                        ),
                  ),
                ),
                Text(
                  data["tennguoidatxe"] ?? "",
                  style: FlutterFlowTheme.of(context).bodyText1.override(
                        color:
                            FlutterFlowTheme.of(context).backgroundComponents,
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
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(20, 0, 10, 0),
                  child: UserAvarta(
                    user: {
                      "anhThumb": data["anhnguoidatxe"],
                      "ten": data["tennguoidatxe"]
                    },
                  ),
                ),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (data["chucvuNguoidatxe"] != null)
                        Text(
                          data["chucvuNguoidatxe"],
                          style:
                              FlutterFlowTheme.of(context).bodyText2.override(
                                    fontWeight: FontWeight.normal,
                                  ),
                        ),
                      if (data["phongbanNguoidatxe"] != null)
                        Padding(
                          padding:
                              const EdgeInsetsDirectional.fromSTEB(0, 5, 0, 0),
                          child: Text(
                            data["phongbanNguoidatxe"],
                            style:
                                FlutterFlowTheme.of(context).bodyText2.override(
                                      fontWeight: FontWeight.normal,
                                    ),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(0, 10, 0, 0),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 10, 0),
                  child: Icon(
                    Icons.pin_drop_rounded,
                    color: FlutterFlowTheme.of(context).secondaryText,
                    size: 16,
                  ),
                ),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding:
                            const EdgeInsetsDirectional.fromSTEB(0, 0, 10, 5),
                        child: Text(
                          'Nơi công tác:',
                          style:
                              FlutterFlowTheme.of(context).bodyText2.override(
                                    fontWeight: FontWeight.normal,
                                  ),
                        ),
                      ),
                      Text(
                        data["PhieuDX_Noicongtac"] ?? "",
                        style: FlutterFlowTheme.of(context).bodyText1.override(
                              color: const Color(0xFF045997),
                            ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (data["tennguoidungxe"] != null)
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(0, 5, 0, 0),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 10, 0),
                    child: Icon(
                      Icons.person_sharp,
                      color: FlutterFlowTheme.of(context).secondaryText,
                      size: 16,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 5, 0),
                    child: Text(
                      'Người sử dụng:',
                      style: FlutterFlowTheme.of(context).bodyText2.override(
                            fontWeight: FontWeight.normal,
                          ),
                    ),
                  ),
                  Text(
                    data["tennguoidungxe"] ?? "",
                    style: FlutterFlowTheme.of(context).bodyText1,
                  ),
                ],
              ),
            ),
          if (data["tennguoidungxe"] != null)
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(0, 5, 0, 0),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(20, 0, 10, 0),
                    child: UserAvarta(
                      user: {
                        "anhThumb": data["anhnguoisudung"],
                        "ten": data["tennguoidungxe"]
                      },
                    ),
                  ),
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          data["chucvuNguoidungxe"] ?? "",
                          style:
                              FlutterFlowTheme.of(context).bodyText2.override(
                                    fontWeight: FontWeight.normal,
                                  ),
                        ),
                        Padding(
                          padding:
                              const EdgeInsetsDirectional.fromSTEB(0, 5, 0, 0),
                          child: Text(
                            data["phongbanNguoidungxe"] ?? "",
                            style:
                                FlutterFlowTheme.of(context).bodyText2.override(
                                      fontWeight: FontWeight.normal,
                                    ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          Align(
            alignment: const AlignmentDirectional(-1, 0),
            child: Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(25, 10, 0, 0),
              child: Wrap(
                spacing: 0,
                runSpacing: 0,
                alignment: WrapAlignment.start,
                crossAxisAlignment: WrapCrossAlignment.start,
                direction: Axis.horizontal,
                runAlignment: WrapAlignment.start,
                verticalDirection: VerticalDirection.down,
                clipBehavior: Clip.none,
                children: [
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 5, 0),
                    child: Text(
                      'Ngày đi ',
                      style: FlutterFlowTheme.of(context).bodyText2.override(
                            fontWeight: FontWeight.normal,
                          ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 5, 0),
                    child: Text(
                      DateTimeFormat.format(
                          DateTime.parse(data["PhieuDX_FromDate"]),
                          format: 'H:i d/m/Y'),
                      style: FlutterFlowTheme.of(context).bodyText1,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 5, 0),
                    child: Text(
                      'Đến',
                      style: FlutterFlowTheme.of(context).bodyText2.override(
                            fontWeight: FontWeight.normal,
                          ),
                    ),
                  ),
                  Text(
                    DateTimeFormat.format(
                        DateTime.parse(data["PhieuDX_ToDate"]),
                        format: 'H:i d/m/Y'),
                    style: FlutterFlowTheme.of(context).bodyText1,
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(25, 5, 0, 0),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 5, 0),
                  child: Text(
                    'Số người: ',
                    style: FlutterFlowTheme.of(context).bodyText2.override(
                          fontWeight: FontWeight.normal,
                        ),
                  ),
                ),
                Text(
                  '${data["songuoisudung"] ?? ""}',
                  style: FlutterFlowTheme.of(context).bodyText1,
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(0, 10, 0, 0),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 10, 0),
                  child: Icon(
                    Icons.emoji_transportation_outlined,
                    color: FlutterFlowTheme.of(context).secondaryText,
                    size: 16,
                  ),
                ),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Hành trình:',
                        style: FlutterFlowTheme.of(context).bodyText1,
                      ),
                      Text(
                        data["PhieuDX_Hanhtrinh"] ?? "",
                        style: FlutterFlowTheme.of(context).bodyText2.override(
                              fontWeight: FontWeight.normal,
                            ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (data["PhieuDX_Lydo"] != null)
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(0, 10, 0, 0),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 10, 0),
                    child: Icon(
                      Icons.comment_sharp,
                      color: FlutterFlowTheme.of(context).secondaryText,
                      size: 16,
                    ),
                  ),
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Nội dung:',
                          style: FlutterFlowTheme.of(context).bodyText1,
                        ),
                        Text(
                          data["PhieuDX_Lydo"] ?? "",
                          style:
                              FlutterFlowTheme.of(context).bodyText2.override(
                                    fontWeight: FontWeight.normal,
                                  ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          if (data["PhieuDX_Ghichu"] != null)
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(0, 10, 0, 0),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 10, 0),
                    child: Icon(
                      Icons.edit_location_sharp,
                      color: FlutterFlowTheme.of(context).secondaryText,
                      size: 16,
                    ),
                  ),
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Ghi chú:',
                          style: FlutterFlowTheme.of(context).bodyText1,
                        ),
                        Text(
                          data["PhieuDX_Ghichu"] ?? "",
                          style:
                              FlutterFlowTheme.of(context).bodyText2.override(
                                    fontWeight: FontWeight.normal,
                                  ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          if (data["SoKm"] != null ||
              data["ChiphiXangxe"] != null ||
              data["VeCauduong"] != null)
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(0, 15, 0, 0),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 10, 0),
                    child: Icon(
                      Icons.info_outlined,
                      color: FlutterFlowTheme.of(context).secondaryText,
                      size: 16,
                    ),
                  ),
                  Text(
                    'Thông tin ước tính:',
                    style: FlutterFlowTheme.of(context).bodyText1,
                  ),
                ],
              ),
            ),
          if (data["SoKm"] != null ||
              data["ChiphiXangxe"] != null ||
              data["VeCauduong"] != null)
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(10, 10, 10, 10),
              child: Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: const Color(0xFFFDFFB1),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Padding(
                      padding:
                          const EdgeInsetsDirectional.fromSTEB(20, 20, 20, 0),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                0, 0, 5, 0),
                            child: Text(
                              'Số KM:',
                              style: FlutterFlowTheme.of(context)
                                  .bodyText2
                                  .override(
                                    fontWeight: FontWeight.w300,
                                  ),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              Golbal.formatNumber(data["SoKm"]),
                              style: FlutterFlowTheme.of(context).bodyText1,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding:
                          const EdgeInsetsDirectional.fromSTEB(20, 5, 20, 0),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                0, 0, 5, 0),
                            child: Text(
                              'Chi phí xăng xe:',
                              style: FlutterFlowTheme.of(context)
                                  .bodyText2
                                  .override(
                                    fontWeight: FontWeight.w300,
                                  ),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              Golbal.formatNumber(data["ChiphiXangxe"]),
                              style: FlutterFlowTheme.of(context).bodyText1,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding:
                          const EdgeInsetsDirectional.fromSTEB(20, 5, 20, 20),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                0, 0, 5, 0),
                            child: Text(
                              'Chi phí cầu đường:',
                              style: FlutterFlowTheme.of(context)
                                  .bodyText2
                                  .override(
                                    fontWeight: FontWeight.w300,
                                  ),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              Golbal.formatNumber(data["VeCauduong"]),
                              style: FlutterFlowTheme.of(context).bodyText1,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          noidungGui(data)
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
        data: MediaQuery.of(context)
            .copyWith(textScaleFactor: Golbal.textScaleFactor),
        child: Scaffold(
          backgroundColor: const Color(0xffffffff),
          appBar: AppBar(
            backgroundColor: Golbal.appColorD,
            elevation: 1.0,
            iconTheme: IconThemeData(color: Golbal.iconColor),
            leading: IconButton(
              onPressed: () {
                Get.back(result: controller.phieuxe);
              },
              icon: Icon(
                Ionicons.chevron_back_outline,
                color: Colors.black.withOpacity(0.5),
                size: 30,
              ),
            ),
            title: Text("Chi tiết phiếu điều xe",
                style: TextStyle(
                    color: Golbal.titleappColor, fontWeight: FontWeight.bold)),
            centerTitle: true,
            systemOverlayStyle: Golbal.systemUiOverlayStyle1,
            actions: [
              IconButton(
                  onPressed: controller.initLog,
                  icon: const Icon(Ionicons.time_outline))
            ],
          ),
          body: Obx(
            () => controller.isloadding.value
                ? const InlineLoadding()
                : GestureDetector(
                    onTap: () => FocusScope.of(context).unfocus(),
                    child: Padding(
                      padding:
                          const EdgeInsetsDirectional.fromSTEB(10, 10, 10, 10),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Expanded(
                            child: infoPhieu(context),
                          ),
                          Obx(() => controller.isUserDuyetPhieu.value == true
                              ? Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      30, 10, 30, 15),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Expanded(
                                        child: FFButtonWidget(
                                          onPressed: () async {
                                            controller.openDuyet(
                                                1, controller.phieuxe);
                                          },
                                          text: 'Duyệt',
                                          icon: const Icon(
                                            Icons.edit,
                                            size: 15,
                                          ),
                                          options: FFButtonOptions(
                                            height: 40,
                                            color: const Color(0xFF5CB85C),
                                            textStyle:
                                                FlutterFlowTheme.of(context)
                                                    .subtitle2
                                                    .override(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.normal,
                                                    ),
                                            borderSide: const BorderSide(
                                              color: Colors.transparent,
                                              width: 1,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(5),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        width: 30,
                                        decoration: BoxDecoration(
                                          color: FlutterFlowTheme.of(context)
                                              .secondaryBackground,
                                        ),
                                      ),
                                      Expanded(
                                        child: FFButtonWidget(
                                          onPressed: () async {
                                            controller.openDuyet(
                                                2, controller.phieuxe);
                                          },
                                          text: 'Trả lại',
                                          icon: const Icon(
                                            Icons.backspace_outlined,
                                            size: 15,
                                          ),
                                          options: FFButtonOptions(
                                            height: 40,
                                            color: const Color(0xFFFD0A0A),
                                            textStyle:
                                                FlutterFlowTheme.of(context)
                                                    .subtitle2
                                                    .override(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.normal,
                                                    ),
                                            borderSide: const BorderSide(
                                              color: Colors.transparent,
                                              width: 1,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(5),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : const SizedBox.shrink())
                        ],
                      ),
                    ),
                  ),
          ),
        ));
  }
}
