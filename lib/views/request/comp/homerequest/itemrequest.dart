import 'package:date_time_format/date_time_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:soe/views/request/comp/homerequest/memberrequest.dart';
import 'package:soe/views/request/comp/homerequest/statusrequest.dart';
import 'package:soe/views/request/controller/requestcontroller.dart';

class ItemRequest extends StatelessWidget {
  final RequestController controller = Get.put(RequestController());
  final dynamic request;
  final Function onClick;
  ItemRequest({
    Key? key,
    this.request,
    required this.onClick,
  }) : super(key: key);

  Widget widgetUutien(request) {
    var text = "Gấp";
    Color color = const Color(0xFFf17ac7);
    if (request["Uutien"] == 1) {
      text = "Gấp";
      color = const Color(0xFFf17ac7);
    } else if (request["Uutien"] == 2) {
      text = "Rất Gấp";
      color = Colors.red;
    }
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(10.0),
      ),
      padding: const EdgeInsets.symmetric(
        vertical: 3.0,
        horizontal: 10.0,
      ),
      margin: const EdgeInsets.only(right: 5.0),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 10,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Color bgColor = Colors.transparent;
    Color han = Colors.black87;
    Color bgleft = Colors.transparent;
    if (request["Trangthai"].toString() == "2") {
      bgColor = const Color(0xFFF1F8E8);
    }
    if (request["SoNgayHan"] != null) {
      if (request["SoNgayHan"] == 0) {
        han = Colors.orange;
        bgleft = Colors.orange;
      } else if (request["SoNgayHan"] < 0) {
        han = Colors.redAccent;
        bgleft = Colors.redAccent;
      }
    }

    return InkWell(
      onTap: () {
        controller.goRequest(request);
      },
      child: Container(
        decoration: BoxDecoration(
          color: bgColor,
          border: Border(
            left: BorderSide(
              width: 2.0,
              color: bgleft,
            ),
          ),
        ),
        padding: const EdgeInsets.all(10.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 5.0, right: 10.0),
              // padding: EdgeInsets.only(
              //     top: request["Uutien"] == 0 ? 0 : 15, left: 5.0, right: 5.0),
              child: request["Trangthai"] == 2
                  ? const Icon(AntDesign.checkcircle,
                      color: Color(0xFF6dd230), size: 20.0)
                  : const Icon(MaterialIcons.radio_button_unchecked,
                      color: Colors.black38, size: 22.0),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Wrap(
                    children: [
                      if (request["Uutien"] == 1 || request["Uutien"] == 2)
                        widgetUutien(request),
                      Text(
                        request["Title"] ?? "",
                        style: TextStyle(
                          color: han,
                        ),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  if (request["Ngaylap"] != null)
                    Row(
                      children: [
                        Expanded(
                          child: Wrap(
                            children: [
                              if (request["IsQH"] == true)
                                Icon(
                                  AntDesign.clockcircle,
                                  color: han,
                                  size: 12,
                                ),
                              if (request["IsQH"] != true)
                                Icon(
                                  AntDesign.clockcircleo,
                                  color: han,
                                  size: 12,
                                ),
                              const SizedBox(width: 5),
                              Text(
                                "${request["Ngaylap"] != null ? DateTimeFormat.format(DateTime.parse(request["Ngaylap"]), format: 'H:i d/m/Y').replaceAll("00:00", "") : ""} ${request["Dateline"] != null ? " - " + DateTimeFormat.format(DateTime.parse(request["Dateline"]), format: 'H:i d/m/Y').replaceAll("00:00", "") : ""}",
                                style: TextStyle(
                                    color: han.withOpacity(0.5),
                                    fontSize: 12.0),
                              ),
                            ],
                          ),
                        ),
                        //onst Spacer(),
                        const SizedBox(width: 5),
                        Column(
                          children: [
                            StatusRequest(request: request),
                          ],
                        ),
                      ],
                    ),
                  const SizedBox(height: 5),
                  if (request["Signs"].isNotEmpty) ...[
                    MemberRequest(
                      signs: request["Signs"],
                      showMore: true,
                    ),
                  ],
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
