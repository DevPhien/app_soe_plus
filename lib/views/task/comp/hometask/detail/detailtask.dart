import 'package:date_time_format/date_time_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:soe/views/component/use/avatar.dart';
import 'package:soe/views/task/comp/hometask/detail/membertask.dart';

import '../../../../../utils/golbal/golbal.dart';
import '../../../../component/use/inlineloadding.dart';
import '../../itemthanhvien.dart';
import '../../trangthaitask.dart';
import 'checklist/checklist.dart';
import 'comment/commenttask.dart';
import 'comment/inputcomment.dart';
import 'detailtaskcontroller.dart';

class ChitietTask extends StatelessWidget {
  final ChitietTaskController controller = Get.put(ChitietTaskController());
  ChitietTask({Key? key}) : super(key: key);

  Widget displayNgay(task) {
    TextStyle label = TextStyle(
        color: task["IsQH"] == 1 ? Colors.red : Golbal.titleColor,
        fontSize: 13);
    String? ktngay = task["NgayKetThuc"] != null
        ? DateTimeFormat.format(DateTime.parse(task["NgayKetThuc"]),
                format: 'H:i d/m/Y')
            .replaceAll("00:00 ", "")
        : "";
    String? bdngay = task["NgayBatDau"] != null
        ? DateTimeFormat.format(DateTime.parse(task["NgayBatDau"]),
                format:
                    'H:i d/m${ktngay == "" || ktngay.contains("00:00") ? '/Y' : ''}')
            .replaceAll("00:00 ", "")
        : "";
    return Text(
      "$bdngay${(ktngay == "" || ktngay.contains("00:00")) ? '' : ' - $ktngay'}",
      style: label,
    );
  }

  Widget fileWidget() {
    return Container(
      margin: const EdgeInsets.only(top: 10.0),
      height: 50.0 * controller.files.length,
      child: ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: controller.files.length,
        itemBuilder: (c, i) => Container(
          width: Golbal.screenSize.width,
          height: 50.0,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5.0),
              border: Border.all(color: const Color(0xFFeeeeee)),
              color: const Color(0xFFffffff)),
          padding: const EdgeInsets.only(bottom: 5.0, top: 5.0),
          child: InkWell(
            onTap: () {
              Golbal.loadFile(controller.files[i]["Duongdan"]);
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                InkWell(
                    onTap: () {
                      Golbal.loadFile(controller.files[i]["Duongdan"]);
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 5.0, horizontal: 10.0),
                      child: Image(
                        image: AssetImage(
                            "assets/file/${controller.files[i]['Dinhdang'].replaceAll('.', '')}.png"),
                        width: 32,
                        height: 32,
                        fit: BoxFit.contain,
                      ),
                    )),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 5.0),
                    child: Text(
                      "${controller.files[i]["Tenfile"]} (${Golbal.formatBytes(controller.files[i]["Dungluong"])})",
                      maxLines: 4,
                      textAlign: TextAlign.justify,
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
        ),
      ),
    );
  }

  Widget vanbanWidget() {
    return Container(
      margin: const EdgeInsets.only(top: 10.0),
      height: 50.0 * controller.vanbans.length,
      child: ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: controller.vanbans.length,
        itemBuilder: (c, i) => Container(
          width: Golbal.screenSize.width,
          height: 50.0,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5.0),
              border: Border.all(color: const Color(0xFFeeeeee)),
              color: const Color(0xFFffffff)),
          padding: const EdgeInsets.only(bottom: 5.0, top: 5.0),
          child: InkWell(
            onTap: () {
              Golbal.loadFile(controller.vanbans[i]["tailieuPath"]);
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                InkWell(
                    onTap: () {
                      Golbal.loadFile(controller.vanbans[i]["tailieuPath"]);
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 5.0, horizontal: 10.0),
                      child: Image(
                        image: AssetImage(
                            "assets/file/${controller.vanbans[i]['tailieuLoai'].replaceAll('.', '')}.png"),
                        width: 32,
                        height: 32,
                        fit: BoxFit.contain,
                      ),
                    )),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 5.0),
                    child: Text(
                      "${controller.vanbans[i]["tailieuTen"]} (${Golbal.formatBytes(controller.vanbans[i]["tailieuSize"])})",
                      maxLines: 4,
                      textAlign: TextAlign.justify,
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
        ),
      ),
    );
  }

  Widget infoTask(context) {
    var task = controller.task;
    const breakRow = SizedBox(height: 10);
    TextStyle label = const TextStyle(color: Colors.black87, fontSize: 13);

    return Container(
      padding: const EdgeInsets.only(
          top: 15.0, bottom: 0.0, left: 15.0, right: 15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (task["Uutien"] == true) ...[
                const Icon(Icons.star, color: Colors.orange, size: 20.0),
                const SizedBox(width: 5.0),
              ],
              if (task["Uutien"] == true) ...[
                const Icon(Feather.flag, color: Colors.red, size: 20.0),
                const SizedBox(width: 5.0),
              ],
              Expanded(
                child: Text(
                  task["CongviecTen"] ?? "",
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Color(0xFF045997)),
                ),
              ),
              const SizedBox(width: 10.0),
              if (task.isNotEmpty) ...[
                TrangthaiTask(tttask: task),
              ]
            ],
          ),
          breakRow,
          Wrap(
            children: [
              if (task["IsQH"] == 1) ...[
                const Icon(AntDesign.clockcircle, color: Colors.red, size: 15)
              ] else ...[
                Icon(AntDesign.clockcircleo,
                    color: Golbal.titleColor, size: 15),
              ],
              const SizedBox(width: 10),
              displayNgay(task),
              const SizedBox(width: 10),
              Text("Tạo bởi: ", style: label),
              Text(task["TenNguoiTao"] ?? "",
                  style: TextStyle(
                      color: Golbal.titleColor, fontWeight: FontWeight.w500)),
            ],
          ),
          if (task["TenDuan"] != null) ...[
            breakRow,
            Wrap(
              children: <Widget>[
                const Icon(Feather.tag, size: 15),
                const SizedBox(width: 10),
                Text(
                  task["TenDuan"] ?? "",
                  style: const TextStyle(fontWeight: FontWeight.w400),
                ),
              ],
            ),
          ],
          if (task["CongviecCha"] != null) ...[
            breakRow,
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Icon(EvilIcons.tag),
                Expanded(
                  child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 4.0, horizontal: 5.0),
                      child: RichText(
                        text: TextSpan(
                          text: 'Công việc cha: ',
                          style: const TextStyle(
                            color: Colors.black54,
                          ),
                          children: <TextSpan>[
                            TextSpan(
                                text: '${task["CongviecCha"] ?? ""}',
                                style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  color: Golbal.titleColor,
                                )),
                          ],
                        ),
                      )),
                ),
              ],
            ),
          ],
          breakRow,
          Container(
            padding: const EdgeInsets.symmetric(vertical: 5.0),
            child: Row(
              children: [
                if (task["giaoviec"] != null) ...[
                  Expanded(
                    child: Card(
                      margin: const EdgeInsets.only(right: 5.0),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(children: [
                          UserAvarta(user: controller.nguoigiaos),
                          const SizedBox(width: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Người giao", style: label),
                              const SizedBox(height: 5),
                              Text(controller.nguoigiaos["ten"] ?? "",
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500))
                            ],
                          )
                        ]),
                      ),
                    ),
                  ),
                ],
                if (task["thuchien"] != null) ...[
                  Expanded(
                    child: Card(
                      margin: const EdgeInsets.only(left: 5.0),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(children: [
                          UserAvarta(
                            user: controller.nguoithuchiens,
                          ),
                          const SizedBox(width: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Thực hiện", style: label),
                              const SizedBox(height: 5),
                              Text(controller.nguoithuchiens["ten"] ?? "",
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500))
                            ],
                          )
                        ]),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
          breakRow,
          //Người theo dõi
          Container(
            padding: const EdgeInsets.symmetric(vertical: 5.0),
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: <Widget>[
                    const Icon(Feather.users, color: Colors.black87, size: 15),
                    const SizedBox(width: 10),
                    Text(
                      "Người theo dõi",
                      style: label,
                      textAlign: TextAlign.justify,
                    ),
                  ],
                ),
                breakRow,
                InkWell(
                  onTap: () {
                    controller.viewUser(context, task["theodoi"] ?? []);
                  },
                  child: MemberTask(
                    members: task["theodoi"] ?? [],
                    showMore: true,
                  ),
                ),
              ],
            ),
          ),
          breakRow,
          Row(
            children: [
              if (task["Ngaycapnhattiendo"] != null) ...[
                Expanded(
                  child: Card(
                    margin: task["NgayKetThuc"] != null
                        ? const EdgeInsets.only(right: 5.0)
                        : EdgeInsets.zero,
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(children: [
                        const Icon(Fontisto.date),
                        const SizedBox(width: 10),
                        Expanded(
                            child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Ngày cập nhật", style: label),
                            const SizedBox(height: 5),
                            Text(
                                DateTimeFormat.format(
                                    DateTime.parse(task["Ngaycapnhattiendo"]),
                                    format: 'H:i d/m'),
                                style: const TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w500))
                          ],
                        ))
                      ]),
                    ),
                  ),
                ),
              ],
              if (task["NgayKetThuc"] != null) ...[
                Expanded(
                  child: Card(
                    margin: task["Ngaycapnhattiendo"] != null
                        ? const EdgeInsets.only(left: 5.0)
                        : EdgeInsets.zero,
                    color: task["IsQH"] == 1 ? Colors.red : Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(children: [
                        Icon(MaterialCommunityIcons.update,
                            color: task["IsQH"] == 1
                                ? Colors.white
                                : Colors.black87),
                        const SizedBox(width: 10),
                        Expanded(
                            child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Hạn xử lý",
                                style: TextStyle(
                                    color: task["IsQH"] == 1
                                        ? Colors.white
                                        : Colors.black87,
                                    fontSize: 13)),
                            const SizedBox(height: 5),
                            Text(
                                DateTimeFormat.format(
                                    DateTime.parse(task["NgayKetThuc"]),
                                    format: 'd/m'),
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: task["IsQH"] == 1
                                        ? Colors.white
                                        : Colors.black87))
                          ],
                        ))
                      ]),
                    ),
                  ),
                ),
              ],
            ],
          ),
          breakRow,
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 5.0),
            child: Row(
              children: <Widget>[
                const Icon(Fontisto.prescription, size: 14),
                const SizedBox(width: 10),
                Text(
                  "Tiến độ",
                  style: label,
                  textAlign: TextAlign.justify,
                ),
                task["Danhgia"] != null
                    ? RatingBar.builder(
                        initialRating: task["Danhgia"],
                        minRating: 1,
                        direction: Axis.horizontal,
                        allowHalfRating: true,
                        ignoreGestures: true,
                        itemCount: 5,
                        itemSize: 20,
                        itemPadding:
                            const EdgeInsets.symmetric(horizontal: 2.0),
                        onRatingUpdate: (v) {},
                        itemBuilder: (context, _) => const Icon(
                          Icons.star,
                          color: Colors.amber,
                        ),
                      )
                    : Container(width: 0.0),
              ],
            ),
          ),
          if (task["Tiendo"] == null || task["Tiendo"] == 0) ...[
            Container(
              margin: const EdgeInsets.only(top: 5),
              width: double.infinity,
              child: Card(
                margin: EdgeInsets.zero,
                elevation: 0,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    children: [
                      const Icon(Fontisto.prescription),
                      const SizedBox(height: 10),
                      const Text("Chưa có thông tin cập nhật tiến độ",
                          style: TextStyle(color: Colors.black54)),
                      // const SizedBox(height: 10),
                      // if (task["isthuchien"] == true)
                      //   TextButton.icon(
                      //     icon: const Icon(Ionicons.add_circle_outline),
                      //     label: const Text("Click vào đây để cập nhật"),
                      //     onPressed: () {},
                      //   )
                    ],
                  ),
                ),
              ),
            )
          ] else ...[
            Stack(
              children: [
                LinearPercentIndicator(
                  padding: EdgeInsets.zero,
                  backgroundColor: task["Tiendo"] == null || task["Tiendo"] == 0
                      ? Colors.red
                      : const Color(0xffcccccc),
                  animation: true,
                  animationDuration: 1000,
                  lineHeight: 24.0,
                  barRadius: const Radius.circular(10),
                  percent: task["Tiendo"] / 100,
                  center: task["Tiendo"] != null && task["Tiendo"] > 0
                      ? Text(" ${task["Tiendo"].ceil()} %",
                          style: TextStyle(
                              color:
                                  task["Tiendo"] != null && task["Tiendo"] >= 60
                                      ? Colors.white
                                      : Colors.black,
                              fontSize: 12.0,
                              fontWeight: FontWeight.bold))
                      : const SizedBox.shrink(),
                  progressColor: Golbal.renderColor(task["Tiendo"]),
                ),
                if (task["Tiendo"] == null || task["Tiendo"] == 0) ...[
                  SizedBox(
                    height: 24.0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          " ${task["Tiendo"].ceil()} %",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  )
                ]
              ],
            ),
          ],
          if (task["Trongso"] != null) ...[
            breakRow,
            Container(
              padding: const EdgeInsets.symmetric(vertical: 5.0),
              width: double.infinity,
              child: Column(
                children: [
                  Row(
                    children: <Widget>[
                      const Icon(Feather.flag, color: Colors.black87, size: 15),
                      const SizedBox(width: 10),
                      Text(
                        "Trọng số",
                        style: label,
                        textAlign: TextAlign.justify,
                      ),
                      const SizedBox(width: 10),
                      CircleAvatar(
                        radius: 12.0,
                        backgroundColor: Golbal.trongColor(task["Trongso"]),
                        child: Text(
                          "${task["Trongso"]}",
                          style: const TextStyle(
                              color: Colors.white, fontSize: 12.0),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
          breakRow,
          Container(
            padding: const EdgeInsets.symmetric(vertical: 5.0),
            width: double.infinity,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Wrap(
                      children: [
                        const Icon(Feather.file_text,
                            color: Colors.black87, size: 15),
                        const SizedBox(width: 10),
                        Text(
                          "Mô tả",
                          style: label,
                          textAlign: TextAlign.justify,
                        ),
                      ],
                    ),
                  ],
                ),
                breakRow,
                SizedBox(
                  width: double.infinity,
                  child: Card(
                    margin: EdgeInsets.zero,
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: task["Mota"] != null && task["Mota"] != ""
                          ? Text(task["Mota"])
                          : Column(
                              children: const [
                                // const Icon(Feather.edit),
                                // const SizedBox(height: 10),
                                // if (task["isthuchien"] == true ||
                                //     task["isgiaoviec"] == true)
                                //   TextButton.icon(
                                //     icon:
                                //         const Icon(Ionicons.add_circle_outline),
                                //     label: const Text("Thêm mô tả"),
                                //     onPressed: () {},
                                //   ),
                                // if (task["isthuchien"] != true &&
                                //     task["isgiaoviec"] != true)
                                Text("Chưa có thông tin mô tả",
                                    style: TextStyle(color: Colors.black54)),
                              ],
                            ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          breakRow,
          // văn bản liên quan
          Obx(
            () => SizedBox(
              width: double.infinity,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Wrap(
                        children: [
                          const Icon(Feather.paperclip,
                              color: Colors.black87, size: 15),
                          const SizedBox(width: 10),
                          Text(
                            "Văn bản liên quan (${controller.vanbans.length})",
                            style: label,
                            textAlign: TextAlign.justify,
                          ),
                        ],
                      ),
                    ],
                  ),
                  if (controller.vanbans.isNotEmpty) ...[
                    vanbanWidget(),
                    breakRow,
                  ],
                ],
              ),
            ),
          ),
          breakRow,
          //Đính kèm
          Obx(
            () => SizedBox(
              width: double.infinity,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Wrap(
                        children: [
                          const Icon(Feather.paperclip,
                              color: Colors.black87, size: 15),
                          const SizedBox(width: 10),
                          Text(
                            "Đính kèm (${controller.files.length})",
                            style: label,
                            textAlign: TextAlign.justify,
                          ),
                        ],
                      ),
                    ],
                  ),
                  if (controller.files.isNotEmpty) ...[
                    fileWidget(),
                    breakRow,
                  ],
                ],
              ),
            ),
          ),
          breakRow,
        ],
      ),
    );
  }

  Widget iconButtonBar(IconData icon, onClick) {
    return IconButton(onPressed: onClick, icon: Icon(icon));
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context)
          .copyWith(textScaleFactor: Golbal.textScaleFactor),
      child: KeyboardDismisser(
          child: Scaffold(
        backgroundColor: const Color(0xfff5f5f5),
        appBar: AppBar(
            backgroundColor: Golbal.appColorD,
            elevation: 1.0,
            iconTheme: IconThemeData(color: Golbal.iconColor),
            leading: IconButton(
              onPressed: () {
                Get.back(result: {"task": controller.task, "isdel": false});
              },
              icon: Icon(
                Ionicons.chevron_back_outline,
                color: Colors.black.withOpacity(0.5),
                size: 30,
              ),
            ),
            centerTitle: false,
            systemOverlayStyle: Golbal.systemUiOverlayStyle1,
            title: Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Obx(
                () => ThanhVienTask(
                  thanhviens: controller.task["Thanhviens"],
                  showMore: false,
                ),
              ),
            ),
            titleSpacing: 0,
            actions: <Widget>[
              iconButtonBar(Fontisto.prescription, controller.goReport),
              iconButtonBar(FontAwesome.comment_o, controller.scroolBottom),
              //iconButtonBar(Icons.attach_file, null),
              iconButtonBar(Feather.clock, controller.goAtivity),
              IconButton(
                onPressed: () {
                  controller.moreAction(context);
                },
                icon: const Icon(Feather.more_horizontal),
              ),
            ]),
        body: GestureDetector(
          onTap: controller.clickBody,
          child: Obx(
            () => controller.isloadding.value
                ? const InlineLoadding()
                : Column(
                    children: [
                      Expanded(
                          child: SingleChildScrollView(
                        controller: controller.scrollController,
                        child: Column(
                          children: [
                            Obx(() => infoTask(context)),
                            CheckListTask(),
                            CommentTask(),
                          ],
                        ),
                      )),
                      Obx(
                        () => controller.showInputComment.value
                            ? InputComment()
                            : const SizedBox.shrink(),
                      )
                    ],
                  ),
          ),
        ),
      )),
    );
  }
}
