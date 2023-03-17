import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../flutter_flow/flutter_flow_theme.dart';
import '../../../flutter_flow/flutter_flow_widgets.dart';
import 'chitietlenhxecontroller.dart';

class FormHoanthanhlenh extends StatelessWidget {
  final ChitietLenhxeController controller = Get.put(ChitietLenhxeController());

  FormHoanthanhlenh({Key? key}) : super(key: key);

  //Function
  @override
  Widget build(BuildContext context) {
    List checkListItems = [
      {
        "id": 0,
        "title": "Tốt",
      },
      {
        "id": 1,
        "title": "Trung bình",
      },
      {
        "id": 2,
        "title": "Chưa tốt",
      },
    ];
    return Scaffold(
      appBar: AppBar(
        backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
        iconTheme: const IconThemeData(color: Color(0xFF0186f8)),
        automaticallyImplyLeading: true,
        title: Text(
          "Hoàn thành lệnh",
          style: FlutterFlowTheme.of(context).title2.override(
                color: const Color(0xFF0186f8),
                fontWeight: FontWeight.bold,
              ),
        ),
        centerTitle: false,
        elevation: 0,
      ),
      backgroundColor: const Color(0xFFEEEEEE),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(20, 20, 20, 20),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding:
                            const EdgeInsetsDirectional.fromSTEB(0, 10, 0, 0),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  0, 0, 5, 0),
                              child: Icon(
                                Icons.directions_boat_rounded,
                                color:
                                    FlutterFlowTheme.of(context).primaryColor,
                                size: 16,
                              ),
                            ),
                            Expanded(
                              child: Text(
                                'Số KM xác nhận',
                                style: FlutterFlowTheme.of(context).bodyText2,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding:
                            const EdgeInsetsDirectional.fromSTEB(0, 10, 0, 0),
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: FlutterFlowTheme.of(context)
                                .secondaryBackground,
                            borderRadius: BorderRadius.circular(5),
                            border: Border.all(
                              color: FlutterFlowTheme.of(context).lineColor,
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                10, 5, 10, 5),
                            child: TextFormField(
                              inputFormatters: [
                                CurrencyTextInputFormatter(
                                    locale: "vi", symbol: "KM")
                              ],
                              onChanged: (String txt) {
                                controller.modelduyet["km_xacnhan"] = txt;
                              },
                              autofocus: true,
                              obscureText: false,
                              decoration: InputDecoration(
                                hintStyle: FlutterFlowTheme.of(context)
                                    .bodyText2
                                    .override(
                                      fontWeight: FontWeight.w300,
                                    ),
                                enabledBorder: const UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Color(0x00000000),
                                    width: 1,
                                  ),
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(4.0),
                                    topRight: Radius.circular(4.0),
                                  ),
                                ),
                                focusedBorder: const UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Color(0x00000000),
                                    width: 1,
                                  ),
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(4.0),
                                    topRight: Radius.circular(4.0),
                                  ),
                                ),
                              ),
                              style: FlutterFlowTheme.of(context)
                                  .bodyText2
                                  .override(
                                    fontWeight: FontWeight.w300,
                                  ),
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                      signed: true, decimal: true),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding:
                            const EdgeInsetsDirectional.fromSTEB(0, 10, 0, 0),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            const Padding(
                              padding:
                                  EdgeInsetsDirectional.fromSTEB(0, 0, 5, 0),
                              child: Icon(
                                Icons.monetization_on_outlined,
                                color: Color(0xFFFF8126),
                                size: 16,
                              ),
                            ),
                            Text(
                              'Phí cầu đường xác nhận',
                              style: FlutterFlowTheme.of(context).bodyText2,
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding:
                            const EdgeInsetsDirectional.fromSTEB(0, 10, 0, 0),
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: FlutterFlowTheme.of(context)
                                .secondaryBackground,
                            borderRadius: BorderRadius.circular(5),
                            border: Border.all(
                              color: FlutterFlowTheme.of(context).lineColor,
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                10, 5, 10, 5),
                            child: TextFormField(
                              autofocus: true,
                              obscureText: false,
                              inputFormatters: [
                                CurrencyTextInputFormatter(locale: "vi")
                              ],
                              onChanged: (String txt) {
                                controller.modelduyet["phicauduong"] = txt;
                              },
                              decoration: InputDecoration(
                                hintStyle: FlutterFlowTheme.of(context)
                                    .bodyText2
                                    .override(
                                      fontWeight: FontWeight.w300,
                                    ),
                                enabledBorder: const UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Color(0x00000000),
                                    width: 1,
                                  ),
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(4.0),
                                    topRight: Radius.circular(4.0),
                                  ),
                                ),
                                focusedBorder: const UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Color(0x00000000),
                                    width: 1,
                                  ),
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(4.0),
                                    topRight: Radius.circular(4.0),
                                  ),
                                ),
                              ),
                              style: FlutterFlowTheme.of(context)
                                  .bodyText2
                                  .override(
                                    fontWeight: FontWeight.w300,
                                  ),
                              maxLines: 1,
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                      signed: true, decimal: true),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding:
                            const EdgeInsetsDirectional.fromSTEB(0, 10, 0, 0),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            const Padding(
                              padding:
                                  EdgeInsetsDirectional.fromSTEB(0, 0, 5, 0),
                              child: Icon(
                                Icons.local_gas_station,
                                color: Color(0xFFF32132),
                                size: 16,
                              ),
                            ),
                            Expanded(
                              child: Text(
                                'Xăng xe xác nhận',
                                style: FlutterFlowTheme.of(context).bodyText2,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding:
                            const EdgeInsetsDirectional.fromSTEB(0, 10, 0, 0),
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: FlutterFlowTheme.of(context)
                                .secondaryBackground,
                            borderRadius: BorderRadius.circular(5),
                            border: Border.all(
                              color: FlutterFlowTheme.of(context).lineColor,
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                10, 5, 10, 5),
                            child: TextFormField(
                              autofocus: true,
                              obscureText: false,
                              inputFormatters: [
                                CurrencyTextInputFormatter(locale: "vi")
                              ],
                              onChanged: (String txt) {
                                controller.modelduyet["xangxe"] = txt;
                              },
                              decoration: InputDecoration(
                                hintStyle: FlutterFlowTheme.of(context)
                                    .bodyText2
                                    .override(
                                      fontWeight: FontWeight.w300,
                                    ),
                                enabledBorder: const UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Color(0x00000000),
                                    width: 1,
                                  ),
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(4.0),
                                    topRight: Radius.circular(4.0),
                                  ),
                                ),
                                focusedBorder: const UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Color(0x00000000),
                                    width: 1,
                                  ),
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(4.0),
                                    topRight: Radius.circular(4.0),
                                  ),
                                ),
                              ),
                              style: FlutterFlowTheme.of(context)
                                  .bodyText2
                                  .override(
                                    fontWeight: FontWeight.w300,
                                  ),
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                      signed: true, decimal: true),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding:
                            const EdgeInsetsDirectional.fromSTEB(0, 10, 0, 0),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            const Padding(
                              padding:
                                  EdgeInsetsDirectional.fromSTEB(0, 0, 5, 0),
                              child: Icon(
                                Icons.rate_review,
                                color: Color(0xFF6DD230),
                                size: 16,
                              ),
                            ),
                            Expanded(
                              child: Text(
                                'Đánh giá',
                                style: FlutterFlowTheme.of(context).bodyText2,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding:
                            const EdgeInsetsDirectional.fromSTEB(0, 10, 0, 0),
                        child: Column(
                          children: List.generate(
                            checkListItems.length,
                            (index) => Obx(() => CheckboxListTile(
                                  controlAffinity:
                                      ListTileControlAffinity.leading,
                                  contentPadding: EdgeInsets.zero,
                                  dense: true,
                                  title: Text(
                                    checkListItems[index]["title"] ?? "",
                                  ),
                                  value: checkListItems[index]["id"] ==
                                      controller.danhgia.value,
                                  onChanged: (value) {
                                    controller.danhgia.value = index;
                                    controller.modelduyet["danhgia"] = index;
                                  },
                                )),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(20, 10, 20, 30),
              child: FFButtonWidget(
                onPressed: () async {
                  controller.controller.hoanthanhlenh(controller.modelduyet);
                },
                text: 'Gửi',
                options: FFButtonOptions(
                  width: double.infinity,
                  height: 40,
                  color: FlutterFlowTheme.of(context).primaryColor,
                  textStyle: FlutterFlowTheme.of(context).subtitle2.override(
                        color: Colors.white,
                        fontWeight: FontWeight.normal,
                      ),
                  borderSide: const BorderSide(
                    color: Colors.transparent,
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
