import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../flutter_flow/flutter_flow_theme.dart';
import '../../component/use/avatar.dart';
import 'chitietlenhxecontroller.dart';

class Danhsachlaixe extends StatelessWidget {
  final ChitietLenhxeController controller = Get.put(ChitietLenhxeController());

  Danhsachlaixe({Key? key}) : super(key: key);

  //Function
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.black54),
        backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
        automaticallyImplyLeading: true,
        title: Text(
          "Chọn lái xe",
          style: FlutterFlowTheme.of(context).title2.override(
                color: const Color(0xFF0186f8),
                fontWeight: FontWeight.bold,
              ),
        ),
        centerTitle: false,
        elevation: 0,
      ),
      backgroundColor: const Color(0xFFEEEEEE),
      body: ListView.builder(
        itemBuilder: (ct, i) {
          var item = controller.dtlaixes[i];
          //print(item);
          return InkWell(
            onTap: () {
              Get.back(result: item);
            },
            child: Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(0, 10, 0, 0),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: FlutterFlowTheme.of(context).primaryBackground,
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(
                    color: FlutterFlowTheme.of(context).lineColor,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(10, 10, 10, 10),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding:
                            const EdgeInsetsDirectional.fromSTEB(0, 0, 10, 0),
                        child: UserAvarta(
                          user: item,
                        ),
                      ),
                      Expanded(
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  5, 0, 0, 0),
                              child: Text(
                                item["fullName"] ?? "",
                                style: FlutterFlowTheme.of(context).subtitle1,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  5, 5, 0, 0),
                              child: Text(
                                item["phone"] ?? "",
                                style: FlutterFlowTheme.of(context).bodyText2,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
        itemCount: controller.dtlaixes.length,
      ),
    );
  }
}
