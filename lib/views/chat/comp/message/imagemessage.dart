import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:soe/utils/golbal/golbal.dart';
import 'package:soe/views/chat/controller/message/messagecontroller.dart';

class ImageMessage extends StatelessWidget {
  final MessageController controller = Get.put(MessageController());

  final dynamic message;
  ImageMessage({Key? key, this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return message["files"] != null
        ? Stack(
            children: <Widget>[
              Container(
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(10.0)),
                constraints: const BoxConstraints(maxHeight: 250.0),
                padding: const EdgeInsets.all(2.0),
                child: Image.file(
                  message["file"],
                  fit: BoxFit.contain,
                ),
              ),
              message["compress"]
                  ? Container(
                      width: 0.0,
                    )
                  : Positioned.fill(
                      child: Center(
                        child: Container(
                          color: const Color.fromRGBO(0, 0, 0, 0.2),
                          padding: const EdgeInsets.all(10.0),
                          child: const CircularProgressIndicator(
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white70),
                          ),
                        ),
                      ),
                    )
            ],
          )
        : GestureDetector(
            onTap: () {
              // Navigator.of(context).push(MaterialPageRoute(
              //     fullscreenDialog: true,
              //     builder: (context) => ImagesViewPage(
              //         "${Golbal.congty!.fileurl}${message['duongDan'] ?? ''}",
              //         const [])));
              controller.loadFile(message["duongDan"]);
            },
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: const AlwaysScrollableScrollPhysics(),
              child: Container(
                constraints: BoxConstraints(
                    maxWidth: (MediaQuery.of(context).size.width - 70),
                    maxHeight: 250.0),
                padding: const EdgeInsets.all(0),
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(10.0),
                    child: Image(
                      image: CachedNetworkImageProvider(
                        "${Golbal.congty!.fileurl}${message['duongDan'] ?? ''}",
                      ),
                      fit: BoxFit.contain,
                    )),
              ),
            ),
          );
  }
}
