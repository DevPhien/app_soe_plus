import 'package:date_time_format/date_time_format.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:soe/views/component/use/avatar.dart';

import '../../../flutter_flow/flutter_flow_theme.dart';
import 'trangthaixe.dart';

class ItemDieuxe extends StatelessWidget {
  final dynamic data;
  final Function? loadFile;
  final bool isChon;
  final Function? onClick;

  const ItemDieuxe(
      {Key? key, this.data, this.loadFile, this.onClick, required this.isChon})
      : super(key: key);

  //Function
  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
        decoration: BoxDecoration(
          color: FlutterFlowTheme.of(context).secondaryBackground,
        ),
        child: Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(10, 10, 10, 10),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  // Text(
                  //   DateTimeFormat.format(DateTime.parse(data["Ngaygui"]),
                  //       format: 'd/m/Y'),
                  //   style: FlutterFlowTheme.of(context).bodyText2,
                  // ),
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(0, 5, 0, 0),
                    child: UserAvarta(
                      user: {
                        "anhThumb": data["anhnguoigui"],
                        "ten": data["tennguoigui"]
                      },
                    ),
                  ),
                ],
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(10, 0, 10, 0),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                0, 0, 5, 0),
                            child: Icon(
                              Icons.insert_drive_file_rounded,
                              color: FlutterFlowTheme.of(context).secondaryText,
                              size: 16,
                            ),
                          ),
                          Text(
                            'Số phiếu: ',
                            style:
                                FlutterFlowTheme.of(context).subtitle2.override(
                                      fontWeight: FontWeight.w300,
                                    ),
                          ),
                          Expanded(
                            child: Text(
                              data["PhieuDX_Sophieu"] ?? "",
                              style: FlutterFlowTheme.of(context)
                                  .bodyText1
                                  .override(
                                    color: const Color(0xFFFD5D19),
                                  ),
                            ),
                          ),
                          TrangthaiXe(tttask: data, isphieu: true)
                        ],
                      ),
                      Padding(
                        padding:
                            const EdgeInsetsDirectional.fromSTEB(0, 5, 0, 0),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  0, 0, 5, 0),
                              child: Icon(
                                Icons.pin_drop_sharp,
                                color:
                                    FlutterFlowTheme.of(context).secondaryText,
                                size: 16,
                              ),
                            ),
                            Expanded(
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
                                  Text(
                                    'Địa chỉ: ',
                                    style: FlutterFlowTheme.of(context)
                                        .subtitle2
                                        .override(
                                          fontWeight: FontWeight.w300,
                                        ),
                                  ),
                                  Text(
                                    data["PhieuDX_Noicongtac"] ?? "",
                                    style: FlutterFlowTheme.of(context)
                                        .bodyText1
                                        .override(
                                          color: const Color(0xFF045997),
                                          fontWeight: FontWeight.w500,
                                        ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (data["tennguoisd"] != null)
                        Padding(
                          padding:
                              const EdgeInsetsDirectional.fromSTEB(0, 5, 0, 0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    0, 0, 5, 0),
                                child: Icon(
                                  Icons.person,
                                  color: FlutterFlowTheme.of(context)
                                      .secondaryText,
                                  size: 16,
                                ),
                              ),
                              Text(
                                'Người sử dụng: ',
                                style: FlutterFlowTheme.of(context)
                                    .subtitle2
                                    .override(
                                      fontWeight: FontWeight.w300,
                                    ),
                              ),
                            ],
                          ),
                        ),
                      if (data["tennguoisd"] != null)
                        Padding(
                          padding:
                              const EdgeInsetsDirectional.fromSTEB(0, 5, 0, 0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    0, 0, 10, 0),
                                child: UserAvarta(
                                  user: {
                                    "anhThumb": data["anhnguoisd"],
                                    "ten": data["tennguoisd"]
                                  },
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      data["fullnamenguoisd"] ?? "",
                                      style: FlutterFlowTheme.of(context)
                                          .bodyText1,
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      data["chucvunguoisd"] ?? "",
                                      style: FlutterFlowTheme.of(context)
                                          .bodyText2
                                          .override(
                                            fontWeight: FontWeight.normal,
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      if (data["PhieuDX_FromDate"] != null)
                        Padding(
                          padding:
                              const EdgeInsetsDirectional.fromSTEB(0, 5, 0, 0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    0, 0, 5, 0),
                                child: Icon(
                                  Icons.update,
                                  color: FlutterFlowTheme.of(context)
                                      .secondaryText,
                                  size: 16,
                                ),
                              ),
                              Text(
                                'Ngày đi: ',
                                style: FlutterFlowTheme.of(context)
                                    .bodyText2
                                    .override(
                                      fontWeight: FontWeight.w300,
                                    ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      5, 0, 5, 0),
                                  child: Text(
                                    DateTimeFormat.format(
                                        DateTime.parse(
                                            data["PhieuDX_FromDate"]),
                                        format: 'H:i d/m/Y'),
                                    style:
                                        FlutterFlowTheme.of(context).bodyText1,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      if (data["PhieuDX_ToDate"] != null)
                        Padding(
                          padding:
                              const EdgeInsetsDirectional.fromSTEB(0, 5, 0, 0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    0, 0, 5, 0),
                                child: Icon(
                                  Icons.update,
                                  color: FlutterFlowTheme.of(context)
                                      .secondaryText,
                                  size: 16,
                                ),
                              ),
                              Text(
                                'Ngày về: ',
                                style: FlutterFlowTheme.of(context)
                                    .bodyText2
                                    .override(
                                      fontWeight: FontWeight.w300,
                                    ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      5, 0, 5, 0),
                                  child: Text(
                                    DateTimeFormat.format(
                                        DateTime.parse(data["PhieuDX_ToDate"]),
                                        format: 'H:i d/m/Y'),
                                    style:
                                        FlutterFlowTheme.of(context).bodyText1,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      Padding(
                        padding:
                            const EdgeInsetsDirectional.fromSTEB(0, 5, 0, 0),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  0, 0, 5, 0),
                              child: Icon(
                                Icons.supervised_user_circle_outlined,
                                color:
                                    FlutterFlowTheme.of(context).secondaryText,
                                size: 16,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  0, 0, 5, 0),
                              child: Text(
                                'Số người đi:',
                                style: FlutterFlowTheme.of(context)
                                    .bodyText2
                                    .override(
                                      fontWeight: FontWeight.w300,
                                    ),
                              ),
                            ),
                            Text(
                              "${data["songuoisudung"] ?? ""}",
                              style: FlutterFlowTheme.of(context).bodyText1,
                            ),
                          ],
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
      onTap: () {
        Get.toNamed("/detailphieucar", arguments: data);
      },
    );
  }
}
