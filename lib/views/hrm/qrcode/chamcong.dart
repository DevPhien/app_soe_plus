import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:soe/flutter_flow/flutter_flow_util.dart';
import 'package:soe/utils/golbal/golbal.dart';
import 'package:soe/views/component/use/inlineloadding.dart';
import 'chamcongcontroller.dart';

class ChamCongQRPage extends StatelessWidget {
  final ChamCongQRController controller = Get.put(ChamCongQRController());
  ChamCongQRPage({Key? key}) : super(key: key);

  Widget _buildEventList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (BuildContext context, int index) {
        var cv = controller.selectedEvents[index];
        if (cv["IsLe"] == true) {
          return Container(
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(width: 1.0, color: Colors.black12),
              ),
            ),
            padding:
                const EdgeInsets.symmetric(horizontal: 0.0, vertical: 10.0),
            child: ListTile(
              leading: CachedNetworkImage(
                imageUrl: "${Golbal.congty!.fileurl}/${cv["IsImage"]}",
                width: 48,
                height: 48,
                fit: BoxFit.fill,
                errorWidget: (context, url, error) => const SizedBox.shrink(),
              ),
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(cv['Lydo'].toString(),
                      style: const TextStyle(fontWeight: FontWeight.bold))
                ],
              ),
            ),
          );
        }
        return Container(
          decoration: BoxDecoration(
            color:
                cv["IsInOut"] == false ? const Color(0xFFfaebd7) : Colors.white,
            border: const Border(
              bottom: BorderSide(width: 1.0, color: Colors.black12),
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 10.0),
          child: ListTile(
              onTap: () {
                controller.goQRView(cv);
              },
              leading: cv['CheckinNhanSu_ID'] != null &&
                      cv["FaceImage"] != null &&
                      cv["FaceImage"] != ""
                  ? CachedNetworkImage(
                      imageUrl: "${Golbal.congty!.fileurl}/${cv["FaceImage"]}",
                      width: 48,
                      height: 48,
                      fit: BoxFit.cover,
                      errorWidget: (context, url, error) =>
                          const SizedBox.shrink(),
                    )
                  : const Icon(FontAwesome.qrcode, size: 48),
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(cv['Checkin_Tenca'].toString(),
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: cv['CheckinNhanSu_ID'] != null ||
                                  cv["IsCheckin"] == false ||
                                  cv["IsTimein"] == false
                              ? Colors.black54
                              : Golbal.appColor,
                          fontSize: 15)),
                  const SizedBox(height: 5.0),
                  cv["GioCheckin"] != null
                      ? Text(
                          "${cv["IsWork"] == 1 || cv["IsWork"] == 5 ? "Check in" : "Gửi"} lúc : ${Golbal.formatDate(cv["GioCheckin"], "H:i")}",
                          style:
                              TextStyle(color: Golbal.appColor, fontSize: 13),
                        )
                      : Row(
                          children: [
                            Text(cv['GioBatdau'].toString().substring(0, 5),
                                style: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14,
                                    color: Colors.black54)),
                            const Text(" - ",
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14,
                                    color: Colors.black54)),
                            Text(cv['GioKetthuc'].toString().substring(0, 5),
                                style: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14,
                                    color: Colors.black54))
                          ],
                        ),
                  const SizedBox(height: 5.0),
                  cv["FullName"] != null
                      ? Text(
                          "${cv["FullName"]}",
                          style: const TextStyle(
                              fontSize: 13, fontWeight: FontWeight.w500),
                        )
                      : const SizedBox(width: 0.0, height: 0.0)
                ],
              ),
              trailing: renderTrainning(cv)),
        );
      },
      itemCount: controller.selectedEvents.length,
    );
  }

  Widget _buildEventNull() {
    String date = DateFormat("yyyy-MM-dd").format(controller.date);
    String now = DateFormat("yyyy-MM-dd").format(DateTime.now());
    bool today = (date == now);
    bool future = (controller.date > DateTime.now());

    if (today) {
      return InkWell(
        onTap: () => {Get.toNamed("dkcalamviec")},
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: const <Widget>[
            Text("Vui lòng click đăng ký lịch làm việc."),
          ],
        ),
      );
    } else {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          if (future) ...[
            const Text("Vẫn chưa đến ngày check in."),
          ] else ...[
            const Text("Không có dữ liệu check in."),
          ],
          const SizedBox(width: 5.0),
          const Icon(
            Fontisto.smiley,
            color: Colors.orange,
            size: 18.0,
          ),
        ],
      );
    }
  }

  //Function
  Widget namWidget() {
    return Container(
        decoration: BoxDecoration(
            color: const Color(0xFF005A9E),
            borderRadius: BorderRadius.circular(5)),
        width: 80,
        child: InkResponse(
          focusColor: Colors.transparent,
          hoverColor: Colors.transparent,
          highlightColor: Colors.transparent,
          onTap: () {
            controller.openYear();
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Năm",
                style: TextStyle(color: Colors.white),
              ),
              const SizedBox(
                height: 3,
              ),
              Text(
                "${controller.year}",
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 18),
              ),
            ],
          ),
        ));
  }

  Widget itemThang(int i) {
    return Container(
        margin: const EdgeInsets.only(right: 5),
        decoration: BoxDecoration(
            color: controller.months[i] == controller.month.value
                ? const Color(0xFFFF8126)
                : ((controller.months[i] <= controller.cmonth &&
                            controller.year.value == controller.cyear) ||
                        controller.year.value < controller.cyear)
                    ? const Color(0xFF40B8EA)
                    : const Color(0xFFB9B7B7),
            borderRadius: BorderRadius.circular(5)),
        width: 80,
        child: InkResponse(
          focusColor: Colors.transparent,
          hoverColor: Colors.transparent,
          highlightColor: Colors.transparent,
          onTap: () {
            controller.setMonth(controller.months[i]);
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Tháng",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              const SizedBox(
                height: 3,
              ),
              Text(
                "${controller.months[i]}",
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 15),
              ),
            ],
          ),
        ));
  }

  Widget thuWidget() {
    const border = BorderSide(width: 1.0, color: Colors.white);
    return Row(
      children: controller.thus
          .map((e) => Expanded(
              child: Container(
                  decoration: BoxDecoration(
                      color: Golbal.appColor,
                      border: const Border(
                          left: border, top: border, bottom: border)),
                  height: 45,
                  child: Center(
                    child: Text(
                      e,
                      style: const TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ))))
          .toList(),
    );
  }

  Color renderColor(e) {
    if (e != null &&
        DateTime.tryParse(e["date"].toString())!.day == controller.date.day) {
      return Colors.orange;
    }
    if (e != null && e["Holiday"] != null) return Colors.red;
    if (e == null || controller.songaycong.value == "") return Colors.white;
    if (e["IsType"] == 1) return const Color(0xFF5CB85C);
    if (e["IsType"] == -1) return const Color(0xFFB9B7B7);
    return Colors.white;
  }

  Widget rowWidget(List item) {
    const border = BorderSide(width: 1.0, color: Color(0xFFeeeeee));
    return Row(
      children: item
          .map((e) => Expanded(
                  child: InkWell(
                onTap: e == null || e["Holiday"] == null
                    ? () {
                        controller.goDay(e);
                      }
                    : () {
                        controller.showLydo(e["Holiday"]);
                      },
                child: Container(
                    decoration: BoxDecoration(
                        gradient: (e == null || e["IsType"] != 2)
                            ? null
                            : const LinearGradient(
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                                colors: [
                                    Color(0xFF5CB85C),
                                    Color(0xFF5CB85C),
                                    Color(0xFFB9B7B7)
                                  ],
                                stops: [
                                    0,
                                    0.5,
                                    0.5
                                  ]),
                        color: renderColor(e),
                        border: const Border(left: border, bottom: border)),
                    height: 45,
                    child: Center(
                      child: Text(
                        "${e != null ? e["day"] : ""}",
                        style: const TextStyle(
                            color: Colors.black87, fontWeight: FontWeight.w600),
                      ),
                    )),
              )))
          .toList(),
    );
  }

  Widget ngayWidget() {
    return Obx(() => Column(
        children:
            controller.days.map((element) => rowWidget(element)).toList()));
  }

  Widget renderTrainning(cv) {
    if (cv['CheckinNhanSu_ID'] != null) {
      switch (cv["IsWork"]) {
        case 1: //Đi làm
          return Container(
              padding: const EdgeInsets.symmetric(
                vertical: 3.0,
                horizontal: 5.0,
              ),
              decoration: BoxDecoration(
                color: cv['IsInOut'] == true ? Colors.green : Golbal.appColor,
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Text(cv['IsInOut'] == true ? "Vào" : "Ra",
                  style: const TextStyle(color: Colors.white, fontSize: 11)));
        case 2: //Nghỉ làm
          return Container(
              padding: const EdgeInsets.symmetric(
                vertical: 3.0,
                horizontal: 5.0,
              ),
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: const Text("Nghỉ làm",
                  style: TextStyle(color: Colors.white, fontSize: 11)));
        case 3: //Nghỉ phép
          return Container(
              padding: const EdgeInsets.symmetric(
                vertical: 3.0,
                horizontal: 5.0,
              ),
              decoration: BoxDecoration(
                color: Colors.orangeAccent,
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: const Text("Nghỉ phép",
                  style: TextStyle(color: Colors.white, fontSize: 11)));
        case 4: //Đi công tác
          return Container(
              padding: const EdgeInsets.symmetric(
                vertical: 3.0,
                horizontal: 5.0,
              ),
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: const Text("Công tác",
                  style: TextStyle(color: Colors.white, fontSize: 11)));
        case 5: //Làm online
          return Container(
              padding: const EdgeInsets.symmetric(
                vertical: 3.0,
                horizontal: 5.0,
              ),
              decoration: BoxDecoration(
                color: Colors.lightGreen,
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: const Text("Làm Online",
                  style: TextStyle(color: Colors.white, fontSize: 11)));
        case 6: //Xin đến muộn
          return Container(
              padding: const EdgeInsets.symmetric(
                vertical: 3.0,
                horizontal: 5.0,
              ),
              decoration: BoxDecoration(
                color: Colors.orange,
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: const Text("Đến muộn",
                  style: TextStyle(color: Colors.white, fontSize: 11)));
      }
      return Container(
          padding: const EdgeInsets.symmetric(
            vertical: 3.0,
            horizontal: 5.0,
          ),
          decoration: BoxDecoration(
            color: cv['CheckinNhanSu_ID'] != null
                ? cv['GioCheckin'] == null
                    ? Colors.red
                    : Colors.green
                : cv["IsCheckin"] == false || cv["IsTimein"] == false
                    ? Colors.black26
                    : Colors.orange,
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Text(
              cv['CheckinNhanSu_ID'] != null
                  ? cv['GioCheckin'] == null
                      ? "Nghỉ"
                      : "Đi làm"
                  : "Chưa check in",
              style: const TextStyle(color: Colors.white, fontSize: 11)));
    }
    return Container(
        padding: const EdgeInsets.symmetric(
          vertical: 3.0,
          horizontal: 5.0,
        ),
        decoration: BoxDecoration(
          color: cv["IsCheckin"] == false || cv["IsTimein"] == false
              ? Colors.black26
              : Colors.orange,
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: const Text("Chưa check in",
            style: TextStyle(color: Colors.white, fontSize: 11)));
  }

  Widget bodyWidget() {
    return Obx(
      () => controller.loading.value
          ? const InlineLoadding()
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    Obx(() => SizedBox(
                          height: 60,
                          child: Row(children: [
                            namWidget(),
                            Expanded(
                                child: ListView.builder(
                              controller: controller.thangcontroller,
                              shrinkWrap: true,
                              itemBuilder: (ct, i) => Obx(() => itemThang(i)),
                              itemCount: controller.months.length,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 5),
                              scrollDirection: Axis.horizontal,
                            ))
                          ]),
                        )),
                    const SizedBox(height: 10),
                    thuWidget(),
                    ngayWidget(),
                    const SizedBox(height: 15),
                    Row(
                      children: [
                        Icon(FontAwesome.calendar_check_o,
                            color: Golbal.titleColor, size: 16),
                        const SizedBox(width: 10),
                        Text("Ngày công cá nhân",
                            style: TextStyle(
                                color: Golbal.titleColor,
                                fontWeight: FontWeight.bold)),
                        const Spacer(),
                        CircleAvatar(
                            backgroundColor: Golbal.appColor,
                            child: Obx(() => Text(
                                (controller.songaycong).toString(),
                                style: const TextStyle(color: Colors.white)))),
                        const SizedBox(width: 10),
                        CircleAvatar(
                            backgroundColor: Colors.orange,
                            child: Obx(() => Text(
                                controller.songaycongthang.toString(),
                                style: const TextStyle(color: Colors.white))))
                      ],
                    ),
                    const SizedBox(height: 15),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                              color: const Color(0xFF5CB85C),
                              width: 16,
                              height: 16),
                          const SizedBox(width: 5),
                          const Text("Đi làm",
                              style: TextStyle(
                                  fontStyle: FontStyle.italic, fontSize: 13)),
                          const SizedBox(width: 15),
                          Container(
                              color: const Color(0xFFB9B7B7),
                              width: 16,
                              height: 16),
                          const SizedBox(width: 5),
                          const Text("Nghỉ làm",
                              style: TextStyle(
                                  fontStyle: FontStyle.italic, fontSize: 13)),
                          const SizedBox(width: 15),
                          Container(
                              decoration: const BoxDecoration(
                                  gradient: LinearGradient(
                                      begin: Alignment.centerLeft,
                                      end: Alignment.centerRight,
                                      colors: [
                                    Color(0xFF5CB85C),
                                    Color(0xFF5CB85C),
                                    Color(0xFFB9B7B7)
                                  ],
                                      stops: [
                                    0,
                                    0.5,
                                    0.5
                                  ])),
                              width: 16,
                              height: 16),
                          const SizedBox(width: 5),
                          const Text("Làm 1/2",
                              style: TextStyle(
                                  fontStyle: FontStyle.italic, fontSize: 13)),
                          const SizedBox(width: 15),
                          Container(color: Colors.red, width: 16, height: 16),
                          const SizedBox(width: 5),
                          const Text("Nghỉ",
                              style: TextStyle(
                                  fontStyle: FontStyle.italic, fontSize: 13)),
                        ],
                      ),
                    ),
                    const SizedBox(height: 15),
                    Row(
                      children: <Widget>[
                        Icon(FontAwesome.calendar_check_o,
                            color: Golbal.titleColor, size: 16),
                        const SizedBox(width: 10),
                        Text("Tổng ngày phép trong năm",
                            style: TextStyle(
                                color: Golbal.titleColor,
                                fontWeight: FontWeight.bold)),
                        const Spacer(),
                        CircleAvatar(
                            backgroundColor: Colors.orange,
                            child: Obx(() => Text(
                                controller.soNgayPhep.toString(),
                                style: const TextStyle(color: Colors.white)))),
                      ],
                    ),
                    const SizedBox(height: 15),
                    Row(
                      children: <Widget>[
                        Icon(FontAwesome.calendar_check_o,
                            color: Golbal.titleColor, size: 16),
                        const SizedBox(width: 10),
                        Text("Số ngày đã nghỉ phép",
                            style: TextStyle(
                                color: Golbal.titleColor,
                                fontWeight: FontWeight.bold)),
                        const Spacer(),
                        CircleAvatar(
                            backgroundColor: Golbal.appColor,
                            child: Obx(() => Text(
                                (controller.soNgayDaNghi).toString(),
                                style: const TextStyle(color: Colors.white)))),
                      ],
                    ),
                    const SizedBox(height: 15),
                    Row(
                      children: [
                        Icon(FontAwesome.calendar,
                            color: Golbal.titleColor, size: 16),
                        const SizedBox(width: 10),
                        Expanded(
                            child: Obx(() => Text(
                                  "Dữ liệu Checkin ${controller.isType.value == 0 ? "cá nhân" : "công ty"} ngày ${controller.today.value}",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Golbal.titleColor),
                                ))),
                      ],
                    ),
                    const SizedBox(height: 20),
                    controller.selectedEvents.isNotEmpty
                        ? _buildEventList()
                        : _buildEventNull(),
                  ],
                ),
              ),
            ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
        data: MediaQuery.of(context)
            .copyWith(textScaleFactor: Golbal.textScaleFactor),
        child: Scaffold(
            appBar: AppBar(
              elevation: 0.0,
              leading: IconButton(
                icon: Icon(
                  Ionicons.chevron_back_outline,
                  color: Colors.black.withOpacity(0.5),
                  size: 30,
                ),
                onPressed: () {
                  Get.back();
                },
              ),
              backgroundColor: Colors.white,
              iconTheme: IconThemeData(color: Golbal.appColor),
              titleSpacing: 0.0,
              centerTitle: true,
              title: Text("Chấm công",
                  style: TextStyle(
                      color: Golbal.titleappColor,
                      fontWeight: FontWeight.bold)),
              systemOverlayStyle: SystemUiOverlayStyle.light,
              actions: [
                IconButton(
                    tooltip: "Nhận diện khuôn mặt",
                    onPressed: controller.goFace,
                    icon: const Icon(Icons.face_outlined)),
                IconButton(
                    onPressed: controller.toogleType,
                    icon: const Icon(Icons.qr_code_2)),
                IconButton(
                    tooltip: "Cấu hình ca làm việc",
                    onPressed: () {
                      Get.toNamed("/hrm");
                    },
                    icon: const Icon(Icons.date_range)),
              ],
            ),
            body: bodyWidget()));
  }
}
