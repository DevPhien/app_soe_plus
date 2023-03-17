import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:soe/utils/golbal/golbal.dart';
import 'package:soe/views/chat/controller/message/messagecontroller.dart';
import 'package:url_launcher/url_launcher.dart';

class FileMessage extends StatelessWidget {
  final dynamic message;
  const FileMessage({Key? key, this.message}) : super(key: key);

  Future<void> openFile(String fPath, String name) async {
    // EasyLoading.show(status: 'Đang tải file ...');
    final filePath = "${Golbal.congty!.fileurl}/Viewer/Index?url=$fPath";
    // final result = await OpenAppFile.open(filePath);
    // EasyLoading.dismiss();

    try {
      final Uri _url = Uri.parse(filePath);
      if (await canLaunchUrl(_url)) {
        await launchUrl(_url);
      } else {}
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    final MessageController controller = Get.put(MessageController());

    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5.0),
          border: Border.all(color: const Color(0xFFeeeeee)),
          color: const Color(0xFFf9f9f9)),
      child: InkWell(
        onTap: () {
          //openFile(message["duongDan"], message["tenFile"]);
          controller.loadFile(message["duongDan"]);
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
              child: Image(
                image: AssetImage(
                    "assets/file/${message["loaiFile"].toString().replaceAll('.', '')}.png"),
                width: 24,
                height: 24,
                fit: BoxFit.contain,
              ),
            ),
            Flexible(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 5.0),
                child: Text(
                  "${message["tenFile"]} ${message["dungLuong"] != null ? " (" + Golbal.formatBytes(message["dungLuong"] ?? 0) + ")" : ""}",
                  maxLines: 3,
                  textAlign: TextAlign.left,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.black87,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
