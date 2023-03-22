import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:soe/utils/golbal/golbal.dart';

import '../../../flutter_flow/flutter_flow_theme.dart';
import 'chitietlenhxecontroller.dart';

class Danhsachxe extends StatelessWidget {
  final ChitietLenhxeController controller = Get.put(ChitietLenhxeController());

  Danhsachxe({Key? key}) : super(key: key);

  //Function
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
        automaticallyImplyLeading: true,
        iconTheme: const IconThemeData(color: Colors.black54),
        title: Text(
          "Chọn xe",
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
          var item = controller.dtxes[i];
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
                  color: FlutterFlowTheme.of(context).secondaryBackground,
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
                      if (item["Anhdaidien"] != null &&
                          item["Anhdaidien"] != "")
                        Padding(
                          padding:
                              const EdgeInsetsDirectional.fromSTEB(0, 0, 10, 0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.network(
                              Golbal.congty!.fileurl +
                                  (item["Anhdaidien"] ?? ""),
                              width: 100,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      Expanded(
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item["Bienso"] ?? "",
                              style: FlutterFlowTheme.of(context).subtitle1,
                            ),
                            Text(
                              '${item["Sochongoi"] ?? ""} chỗ | ${item["Loaixe"] ?? ""}',
                              style: FlutterFlowTheme.of(context)
                                  .bodyText2
                                  .override(
                                    fontWeight: FontWeight.w300,
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
        itemCount: controller.dtxes.length,
      ),
    );
  }
}
