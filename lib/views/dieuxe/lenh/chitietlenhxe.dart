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
import 'chitietlenhxecontroller.dart';

class ChitietLenhxe extends StatelessWidget {
  final ChitietLenhxeController controller = Get.put(ChitietLenhxeController());
  final DieuxeController dxcontroller = Get.put(DieuxeController());

  ChitietLenhxe({Key? key}) : super(key: key);

  Widget infoLenh(context) {
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
                  'Số lệnh:',
                  style: FlutterFlowTheme.of(context).bodyText2.override(
                        fontWeight: FontWeight.normal,
                      ),
                ),
              ),
              Text(
                data["LenhDX_So"] ?? "",
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
                  DateTimeFormat.format(DateTime.parse(data["LenhDX_Ngaylap"]),
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
                  data["fullnameNguoidatxe"] ?? "",
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
                      "ten": data["fullnameNguoidatxe"]
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
                            const EdgeInsetsDirectional.fromSTEB(0, 0, 10, 0),
                        child: Text(
                          'Nơi công tác:',
                          style:
                              FlutterFlowTheme.of(context).bodyText2.override(
                                    fontWeight: FontWeight.normal,
                                  ),
                        ),
                      ),
                      Text(
                        data["LenhDX_Noicongtac"] ?? "",
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
          if (data["fullnameNguoisudung"] != null)
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
                    data["fullnameNguoisudung"] ?? "",
                    style: FlutterFlowTheme.of(context).bodyText1,
                  ),
                ],
              ),
            ),
          if (data["fullnameNguoisudung"] != null)
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
                        "ten": data["fullnameNguoisudung"]
                      },
                    ),
                  ),
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (data["chucvuNguoisudung"] != null)
                          Text(
                            data["chucvuNguoisudung"] ?? "",
                            style:
                                FlutterFlowTheme.of(context).bodyText2.override(
                                      fontSize: 13,
                                      fontWeight: FontWeight.normal,
                                    ),
                          ),
                        if (data["phongbanNguoisudung"] != null)
                          Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                0, 5, 0, 0),
                            child: Text(
                              data["phongbanNguoisudung"] ?? "",
                              style: FlutterFlowTheme.of(context)
                                  .bodyText2
                                  .override(
                                    fontSize: 13,
                                    fontWeight: FontWeight.normal,
                                  ),
                            ),
                          ),
                        if (data["Nguoisudung_View"] == true)
                          Text(
                            "Đã xem ngày (${DateTimeFormat.format(DateTime.parse(data["Nguoisudung_View_Date"]), format: 'H:i d/m/Y')})",
                            style:
                                FlutterFlowTheme.of(context).bodyText2.override(
                                      fontSize: 13,
                                      color: Colors.black54,
                                      fontStyle: FontStyle.italic,
                                      fontWeight: FontWeight.normal,
                                    ),
                          )
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
                          DateTime.parse(data["LenhDX_FromDate"]),
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
                    DateTimeFormat.format(DateTime.parse(data["LenhDX_ToDate"]),
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
          Align(
            alignment: const AlignmentDirectional(-1, 0),
            child: Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(0, 5, 0, 0),
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
                    child: Icon(
                      Icons.directions_car,
                      color: FlutterFlowTheme.of(context).secondaryText,
                      size: 16,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 5, 0),
                    child: Text(
                      'Xe đi:',
                      style: FlutterFlowTheme.of(context).bodyText2.override(
                            fontWeight: FontWeight.normal,
                          ),
                    ),
                  ),
                  Text(
                    data["LenhDX_Bienso"] ?? "",
                    style: FlutterFlowTheme.of(context).bodyText1,
                  ),
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(5, 0, 0, 0),
                    child: Text(
                      '${data["LenhDX_Chongoi"] ?? ""} chỗ, ${data["LenhDX_Loaixe"] ?? ""}',
                      style: FlutterFlowTheme.of(context).bodyText2.override(
                            fontWeight: FontWeight.normal,
                          ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (data["fullNameNguoilaixe"] != null)
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(0, 5, 0, 0),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 5, 0),
                    child: Icon(
                      Icons.location_history,
                      color: FlutterFlowTheme.of(context).secondaryText,
                      size: 16,
                    ),
                  ),
                  Text(
                    'Lái xe:',
                    style: FlutterFlowTheme.of(context).bodyText2.override(
                          fontWeight: FontWeight.normal,
                        ),
                  ),
                ],
              ),
            ),
          if (data["fullNameNguoilaixe"] != null)
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(0, 5, 0, 0),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(20, 0, 10, 0),
                    child: UserAvarta(
                      user: {
                        "anhThumb": data["anhnguoilaixe"],
                        "ten": data["fullNameNguoilaixe"]
                      },
                    ),
                  ),
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          data["fullNameNguoilaixe"] ?? "",
                          style:
                              FlutterFlowTheme.of(context).bodyText1.override(
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                        if (data["LenhDX_Dienthoai"] != null)
                          Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                0, 5, 0, 0),
                            child: Text(
                              data["LenhDX_Dienthoai"] ?? "",
                              style: FlutterFlowTheme.of(context)
                                  .bodyText2
                                  .override(
                                    fontWeight: FontWeight.normal,
                                  ),
                            ),
                          ),
                        if (data["Laixe_View"] == true)
                          Text(
                            "Đã xem ngày (${DateTimeFormat.format(DateTime.parse(data["Laixe_View_Date"]), format: 'H:i d/m/Y')})",
                            style:
                                FlutterFlowTheme.of(context).bodyText2.override(
                                      fontSize: 13,
                                      color: Colors.black54,
                                      fontStyle: FontStyle.italic,
                                      fontWeight: FontWeight.normal,
                                    ),
                          )
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
                        data["LenhDX_Hanhtrinh"] ?? "",
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
          if (data["LenhDX_Lydo"] != null)
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
                          data["LenhDX_Lydo"] ?? "",
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
          if (data["LenhDX_Ghichu"] != null)
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
                          data["LenhDX_Ghichu"] ?? "",
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
          if (data["LenhDX_Kmdukien"] != null ||
              data["LenhDX_XangxeDukien"] != null ||
              data["LenhDX_VeCauduongdukien"] != null)
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(0, 5, 0, 0),
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
          if (data["LenhDX_Kmdukien"] != null ||
              data["LenhDX_XangxeDukien"] != null ||
              data["LenhDX_VeCauduongdukien"] != null)
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
                              Golbal.formatNumber(data["LenhDX_Kmdukien"]),
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
                              Golbal.formatNumber(data["LenhDX_XangxeDukien"]),
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
                              Golbal.formatNumber(
                                  data["LenhDX_VeCauduongdukien"]),
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
          if (data["LenhDX_KmXacnhan"] != null ||
              data["LenhDX_Xangxe"] != null ||
              data["LenhDX_VeCauduong"] != null)
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(0, 5, 0, 0),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 10, 0),
                    child: Icon(
                      Icons.fact_check_outlined,
                      color: FlutterFlowTheme.of(context).secondaryText,
                      size: 16,
                    ),
                  ),
                  Text(
                    'Thông tin xác nhận:',
                    style: FlutterFlowTheme.of(context).bodyText1,
                  ),
                ],
              ),
            ),
          if (data["LenhDX_KmXacnhan"] != null ||
              data["LenhDX_Xangxe"] != null ||
              data["LenhDX_VeCauduong"] != null)
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(10, 10, 10, 10),
              child: Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: const Color(0xFFCEF1D9),
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
                              Golbal.formatNumber(data["LenhDX_KmXacnhan"]),
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
                              Golbal.formatNumber(data["LenhDX_Xangxe"]),
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
                              Golbal.formatNumber(data["LenhDX_VeCauduong"]),
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

  Widget noidungGui(data) {
    if (data["noidungNguoigui"] == null || data["noidungNguoigui"] == "") {
      return const SizedBox.shrink();
    }
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color:
              data["TrangthaiXe"] == 3 ? Colors.red : const Color(0xFFDBF1FF)),
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
                style: FlutterFlowTheme.of(Get.context!).bodyText1.override(
                    color:
                        data["TrangthaiXe"] == 3 ? Colors.white : Colors.black),
              ),
              Text(
                data["noidungNguoigui"] ?? "",
                style: FlutterFlowTheme.of(Get.context!).bodyText2.override(
                    color: data["TrangthaiXe"] == 3
                        ? Colors.white70
                        : Colors.black54),
              ),
              if (data["TrangthaiXe"] == 3 && data["LenhDX_Ghichu"] != null)
                Text(
                  "- ${data["LenhDX_Ghichu"] ?? ""}",
                  style: FlutterFlowTheme.of(Get.context!).bodyText2.override(
                      color: Colors.white,
                      fontWeight: FontWeight.normal,
                      fontSize: 13),
                ),
            ],
          )),
          if (data["TrangthaiXe"] == 3)
            const Icon(MaterialCommunityIcons.car_info, color: Colors.white)
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
            title: Text("Chi tiết lệnh điều xe",
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
                            child: infoLenh(context),
                          ),
                          Obx(() => controller.isUserDuyetLenh.value
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
                              : controller.isUserHoanthanh.value
                                  ? Padding(
                                      padding:
                                          const EdgeInsetsDirectional.fromSTEB(
                                              10, 10, 10, 15),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          Expanded(
                                            child: FFButtonWidget(
                                              onPressed: () async {
                                                controller.openDuyet(
                                                    5, controller.phieuxe);
                                              },
                                              text: 'Cập nhật Trạng thái',
                                              icon: const Icon(
                                                AntDesign.car,
                                                size: 15,
                                              ),
                                              options: FFButtonOptions(
                                                height: 40,
                                                color: Golbal.titleColor,
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
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .secondaryBackground,
                                            ),
                                          ),
                                          Expanded(
                                            child: FFButtonWidget(
                                              onPressed: () async {
                                                controller.openDuyet(
                                                    3, controller.phieuxe);
                                              },
                                              text: 'Hoàn thành lệnh',
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
                                        ],
                                      ),
                                    )
                                  : controller.isUserLapLenh.value == true
                                      ? Padding(
                                          padding: const EdgeInsetsDirectional
                                              .fromSTEB(10, 10, 10, 15),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              Expanded(
                                                child: FFButtonWidget(
                                                  onPressed: () async {
                                                    controller.openDuyet(
                                                        4, controller.phieuxe);
                                                  },
                                                  text: 'Lập lệnh',
                                                  icon: const Icon(
                                                    Icons.edit,
                                                    size: 15,
                                                  ),
                                                  options: FFButtonOptions(
                                                    height: 40,
                                                    color:
                                                        const Color(0xFF5CB85C),
                                                    textStyle: FlutterFlowTheme
                                                            .of(context)
                                                        .subtitle2
                                                        .override(
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.normal,
                                                        ),
                                                    borderSide:
                                                        const BorderSide(
                                                      color: Colors.transparent,
                                                      width: 1,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5),
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                width: 30,
                                                decoration: BoxDecoration(
                                                  color: FlutterFlowTheme.of(
                                                          context)
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
                                                    color:
                                                        const Color(0xFFFD0A0A),
                                                    textStyle: FlutterFlowTheme
                                                            .of(context)
                                                        .subtitle2
                                                        .override(
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.normal,
                                                        ),
                                                    borderSide:
                                                        const BorderSide(
                                                      color: Colors.transparent,
                                                      width: 1,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        )
                                      : const SizedBox.shrink()),
                        ],
                      ),
                    ),
                  ),
          ),
        ));
  }
}
