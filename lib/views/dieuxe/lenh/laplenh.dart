import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:soe/utils/golbal/golbal.dart';
import 'package:soe/views/component/use/avatar.dart';

import '../../../flutter_flow/flutter_flow_theme.dart';
import '../../../flutter_flow/flutter_flow_widgets.dart';
import 'chitietlenhxecontroller.dart';

class FormLapLenhXe extends StatelessWidget {
  final ChitietLenhxeController controller = Get.put(ChitietLenhxeController());

  FormLapLenhXe({Key? key}) : super(key: key);
  Widget bindLaixe() {
    var laixe = controller.laixechon;
    return Obx(() {
      return Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(10, 10, 10, 10),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            if (laixe["NhanSu_ID"] == null)
              const SizedBox(
                height: 40,
              ),
            if (laixe["NhanSu_ID"] != null)
              Container(
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(10, 5, 10, 5),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                          padding:
                              const EdgeInsetsDirectional.fromSTEB(0, 0, 5, 0),
                          child: UserAvarta(
                            user: laixe,
                          )),
                      Text(
                        laixe["fullName"] ?? "",
                        style: FlutterFlowTheme.of(Get.context!)
                            .bodyText2
                            .override(
                              color: FlutterFlowTheme.of(Get.context!)
                                  .primaryBackground,
                              fontWeight: FontWeight.w300,
                            ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      );
    });
  }

  Widget bindXechon() {
    var xe = controller.xechon;
    return Obx(() {
      return Row(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (xe["Bienso"] == null)
            const SizedBox(
              height: 40,
            ),
          if (xe["Anhdaidien"] != null)
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 10, 0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  Golbal.congty!.fileurl + xe["Anhdaidien"],
                  width: 100,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          if (xe["Bienso"] != null)
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    xe["Bienso"] ?? "",
                    style: FlutterFlowTheme.of(Get.context!).subtitle1,
                  ),
                  Text(
                    '${xe["Sochongoi"] ?? ""} chỗ | ${xe["Loaixe"] ?? ""}',
                    style: FlutterFlowTheme.of(Get.context!).bodyText2.override(
                          fontWeight: FontWeight.w300,
                        ),
                  ),
                ],
              ),
            ),
        ],
      );
    });
  }

  //Function
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
          iconTheme: const IconThemeData(color: Colors.black54),
          automaticallyImplyLeading: true,
          title: Text(
            "Lập lệnh điều xe",
            style: FlutterFlowTheme.of(context).title2.override(
                  color: const Color(0xFF0186f8),
                  fontWeight: FontWeight.bold,
                ),
          ),
          centerTitle: false,
          elevation: 0,
        ),
        backgroundColor: const Color(0xFFEEEEEE),
        body: Obx(
          () => GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Padding(
                    padding:
                        const EdgeInsetsDirectional.fromSTEB(20, 20, 20, 20),
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SwitchListTile(
                            value: controller.isxecongty.value,
                            onChanged: (newValue) =>
                                controller.isxecongty.value = newValue,
                            title: Text(
                              'Xe công ty',
                              style: FlutterFlowTheme.of(context)
                                  .bodyText2
                                  .override(
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            dense: true,
                            controlAffinity: ListTileControlAffinity.trailing,
                          ),
                          if (controller.isxecongty.value == true)
                            Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  0, 10, 0, 0),
                              child: Text(
                                'Chọn xe',
                                style: FlutterFlowTheme.of(context).bodyText2,
                              ),
                            ),
                          if (controller.isxecongty.value == true)
                            Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  0, 10, 0, 0),
                              child: InkWell(
                                onTap: controller.chonxe,
                                child: Container(
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: FlutterFlowTheme.of(context)
                                        .secondaryBackground,
                                    borderRadius: BorderRadius.circular(5),
                                    border: Border.all(
                                      color: FlutterFlowTheme.of(context)
                                          .lineColor,
                                    ),
                                  ),
                                  child: Padding(
                                    padding:
                                        const EdgeInsetsDirectional.fromSTEB(
                                            10, 10, 10, 10),
                                    child: bindXechon(),
                                  ),
                                ),
                              ),
                            ),
                          if (controller.isxecongty.value == true)
                            Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  0, 10, 0, 0),
                              child: Text(
                                'Chọn lái xe',
                                style: FlutterFlowTheme.of(context).bodyText2,
                              ),
                            ),
                          if (controller.isxecongty.value)
                            Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  0, 10, 0, 0),
                              child: InkWell(
                                onTap: controller.chonlaixe,
                                child: Container(
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: FlutterFlowTheme.of(context)
                                        .secondaryBackground,
                                    borderRadius: BorderRadius.circular(5),
                                    border: Border.all(
                                      color: FlutterFlowTheme.of(context)
                                          .lineColor,
                                    ),
                                  ),
                                  child: bindLaixe(),
                                ),
                              ),
                            ),
                          if (controller.isxecongty.value == false)
                            Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  0, 10, 0, 0),
                              child: Text(
                                'Nhập thông tin xe ngoài',
                                style: FlutterFlowTheme.of(context).bodyText2,
                              ),
                            ),
                          if (controller.isxecongty.value == false)
                            Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  0, 10, 0, 0),
                              child: Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: FlutterFlowTheme.of(context)
                                      .secondaryBackground,
                                  borderRadius: BorderRadius.circular(5),
                                  border: Border.all(
                                    color:
                                        FlutterFlowTheme.of(context).lineColor,
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      10, 10, 10, 10),
                                  child: TextFormField(
                                    onChanged: (String s) {
                                      controller
                                          .modelduyet["LenhDX_DatXeNgoai"] = s;
                                    },
                                    autofocus: true,
                                    obscureText: false,
                                    decoration: InputDecoration(
                                      hintText: 'Nhập nội dung.....',
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
                                        .override(),
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
                  padding: const EdgeInsetsDirectional.fromSTEB(20, 10, 20, 25),
                  child: FFButtonWidget(
                    onPressed: controller.laplenh,
                    text: 'Gửi',
                    options: FFButtonOptions(
                      width: double.infinity,
                      height: 40,
                      color: FlutterFlowTheme.of(context).primaryColor,
                      textStyle:
                          FlutterFlowTheme.of(context).subtitle2.override(
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
        ));
  }
}
