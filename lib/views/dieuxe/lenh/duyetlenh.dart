import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../flutter_flow/flutter_flow_theme.dart';
import '../../../flutter_flow/flutter_flow_widgets.dart';
import '../../../utils/golbal/golbal.dart';
import '../../component/use/avatar.dart';
import 'chitietlenhxecontroller.dart';

class FormDuyetXe extends StatelessWidget {
  final ChitietLenhxeController controller = Get.put(ChitietLenhxeController());

  FormDuyetXe({Key? key}) : super(key: key);

  Widget chonUser() {
    return InkWell(
      onTap: () {
        FocusScope.of(Get.context!).unfocus();
        controller.controller.showUser();
      },
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(5),
            border: Border.all(color: const Color(0xFFcccccc), width: 1.0)),
        child: controller.controller.userduyet["fullName"] != null
            ? Chip(
                label: Text(
                  '${controller.controller.userduyet["fullName"]}',
                  style: const TextStyle(color: Colors.white, fontSize: 11),
                ),
                onDeleted: () {
                  controller.controller.userduyet.value = {};
                },
                avatar: UserAvarta(user: controller.controller.userduyet),
                backgroundColor: Golbal.appColor,
                deleteIconColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              )
            : const Text("Chọn người duyệt"),
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
          "Duyệt lệnh",
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
                      Text(
                        "Người duyệt cá nhân (Không theo quy trình)",
                        style: FlutterFlowTheme.of(context).bodyText2,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 10),
                      Obx(() => chonUser()),
                      const SizedBox(height: 10),
                      Padding(
                        padding:
                            const EdgeInsetsDirectional.fromSTEB(0, 10, 0, 0),
                        child: Text(
                          'Nội dung',
                          style: FlutterFlowTheme.of(context).bodyText2,
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
                                10, 10, 10, 10),
                            child: TextFormField(
                              autofocus: true,
                              obscureText: false,
                              onChanged: (String txt) {
                                controller.modelduyet["Noidung"] = txt;
                              },
                              decoration: InputDecoration(
                                hintText: 'Nhập nội dung duyệt...',
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
                              maxLines: 5,
                              keyboardType: TextInputType.multiline,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(20, 10, 20, 30),
              child: FFButtonWidget(
                onPressed: () async {
                  controller.controller.duyetlenh(controller.modelduyet);
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
