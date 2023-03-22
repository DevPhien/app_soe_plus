import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_static_maps_controller/google_static_maps_controller.dart';

import '../../../utils/golbal/golbal.dart';
import '../../chat/comp/imageview.dart';
import 'checkincontroller.dart';

class Checkin extends StatelessWidget {
  final CheckinController controller = Get.put(CheckinController());

  Checkin({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    TextStyle lb = const TextStyle(color: Colors.black54);
    TextStyle ib =
        const TextStyle(color: Colors.black87, fontWeight: FontWeight.w600);
    print(controller.checkin);
    return MediaQuery(
      data: MediaQuery.of(context)
          .copyWith(textScaleFactor: Golbal.textScaleFactor),
      child: Scaffold(
        backgroundColor: const Color(0xffffffff),
        appBar: AppBar(
          backgroundColor: Golbal.appColorD,
          elevation: 0.0,
          iconTheme: IconThemeData(color: Golbal.iconColor),
          title: Text(
              "${controller.checkin["IsInOut"] == false ? "Check Out" : "Check in"} ${controller.checkin["Checkin_Tenca"]}",
              style: TextStyle(
                  color: Golbal.titleappColor, fontWeight: FontWeight.bold)),
          centerTitle: false,
          systemOverlayStyle: Golbal.systemUiOverlayStyle1,
          actions: [
            controller.checkin["IsCheckin"] == true &&
                    controller.checkin["NhanSu_ID"] ==
                        Golbal.store.user["user_id"] &&
                    controller.checkin["countCheck"] == 0 &&
                    controller.checkin["IsTimein"] == true &&
                    controller.checkin['IsInOut'] == true
                ? IconButton(
                    icon: const Icon(Icons.qr_code_2_outlined),
                    onPressed: controller.goQRView)
                : const SizedBox(width: 0.0, height: 0.0)
          ],
        ),
        body: SafeArea(
          child: Card(
            margin: const EdgeInsets.all(10.0),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: ListView(
                children: [
                  controller.checkin["FaceImage"] == null ||
                          controller.checkin["FaceImage"] == ""
                      ? Container(width: 0.0)
                      : InkWell(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                fullscreenDialog: true,
                                builder: (context) => ImagesViewPage(
                                    "${Golbal.congty!.fileurl}${controller.checkin["FaceImage"]}",
                                    const [])));
                          },
                          child: SizedBox(
                            height: 200,
                            child: Center(
                              child: CachedNetworkImage(
                                imageUrl:
                                    "${Golbal.congty!.fileurl}/${controller.checkin["FaceImage"]}",
                                errorWidget: (context, url, error) =>
                                    const SizedBox.shrink(),
                              ),
                            ),
                          ),
                        ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      SizedBox(
                          width: 100,
                          child: Text(
                            "Thời gian :",
                            style: lb,
                          )),
                      const SizedBox(width: 5),
                      Text(
                          Golbal.formatDate(
                              controller.checkin["GioCheckin"], "H:i"),
                          style: ib)
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      SizedBox(
                          width: 100,
                          child: Text(
                            "Thiết bị :",
                            style: lb,
                          )),
                      const SizedBox(width: 5),
                      Text("${controller.checkin["FromDivice"] ?? ""}",
                          style: ib)
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      SizedBox(
                          width: 100,
                          child: Text(
                            "IP :",
                            style: lb,
                          )),
                      const SizedBox(width: 5),
                      Text("${controller.checkin["FromIP"] ?? ""}", style: ib)
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      SizedBox(
                          width: 100,
                          child: Text(
                            "Wifi :",
                            style: lb,
                          )),
                      const SizedBox(width: 5),
                      Text("${controller.checkin["Wifi"] ?? ""}", style: ib)
                    ],
                  ),
                  controller.checkin["Lydo"] != null &&
                          controller.checkin["Lydo"] != ""
                      ? Column(
                          children: [
                            const SizedBox(height: 20),
                            Row(
                              children: [
                                SizedBox(
                                    width: 100,
                                    child: Text(
                                      "Lý do :",
                                      style: lb,
                                    )),
                                const SizedBox(width: 5),
                                Expanded(
                                    child: Text(controller.checkin["Lydo"],
                                        style: ib))
                              ],
                            ),
                            const SizedBox(height: 20),
                            Row(
                              children: [
                                SizedBox(
                                    width: 100,
                                    child: Text(
                                      "Trạng thái :",
                                      style: lb,
                                    )),
                                const SizedBox(width: 5),
                                Container(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 3.0,
                                      horizontal: 5.0,
                                    ),
                                    decoration: BoxDecoration(
                                      color:
                                          controller.checkin['IsDuyet'] == true
                                              ? Colors.green
                                              : Colors.orange,
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    child: Text(
                                        controller.checkin['IsDuyet'] == true
                                            ? "Đã duyệt"
                                            : "Chưa duyệt",
                                        style: const TextStyle(
                                            color: Colors.white, fontSize: 11)))
                              ],
                            ),
                          ],
                        )
                      : Container(width: 0.0),
                  const SizedBox(height: 20),
                  if (controller.lat == null)
                    Container(width: 0.0)
                  else
                    SizedBox(
                      width: double.infinity,
                      height: 200,
                      child: StaticMap(
                        width: double.infinity,
                        height: 240,
                        scaleToDevicePixelRatio: true,
                        googleApiKey: Golbal.googleApiKey,
                        markers: <Marker>[
                          Marker.custom(
                            anchor: MarkerAnchor.bottom,
                            icon: "",
                            locations: [
                              Location(controller.lat!, controller.lon!),
                            ],
                          )
                        ],
                      ),
                    )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
