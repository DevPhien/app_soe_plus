import 'package:date_time_format/date_time_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:soe/utils/golbal/golbal.dart';
import 'package:soe/views/component/use/inlineloadding.dart';
import 'package:soe/views/request/comp/homerequest/detail/comment/commentrequest.dart';
import 'package:soe/views/request/comp/homerequest/detail/comment/inputcomment.dart';
import 'package:soe/views/request/comp/homerequest/detail/detailrequestcontroller.dart';
import 'package:soe/views/request/comp/homerequest/detail/form/inputcolumn.dart';
import 'package:soe/views/request/comp/homerequest/handlerequest.dart';
import 'package:soe/views/request/comp/homerequest/memberrequest.dart';
import 'package:soe/views/request/comp/homerequest/statusrequest.dart';
import 'package:soe/views/request/controller/requestcontroller.dart';

class DetailRequest extends StatelessWidget {
  final DetailRequestController controller = Get.put(DetailRequestController());
  final RequestController rqcontroller = Get.put(RequestController());
  DetailRequest({Key? key}) : super(key: key);

  Color renderColor(double td) {
    Color them = const Color(0xff6fbf73);
    if (td <= 30) {
      them = Colors.red;
    } else if (td <= 50) {
      them = Colors.orange;
    } else if (td <= 80) {
      them = Golbal.appColor;
    }
    return them;
  }

  Color uutienColor(int? td) {
    Color them = Colors.green;
    if (td == 2) {
      them = Colors.red;
    } else if (td == 1) {
      them = Colors.orange;
    } else if (td == 0) {
      them = Golbal.appColor;
    }
    return them;
  }

  Widget iconButtonBar(IconData icon, onClick) {
    return IconButton(
      onPressed: onClick,
      icon: Icon(icon),
    );
  }

  Widget displayNgay(request) {
    TextStyle label = TextStyle(
        color: request["IsQH"] == 1 ? Colors.red : Golbal.titleColor,
        fontSize: 13);
    String? ktngay = request["Dateline"] != null
        ? DateTimeFormat.format(DateTime.parse(request["Dateline"]),
                format: 'H:i d/m/Y')
            .replaceAll("00:00 ", "")
        : "";
    String? bdngay = request["Ngaylap"] != null
        ? DateTimeFormat.format(DateTime.parse(request["Ngaylap"]),
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

  Widget formDWidget(String? fid) {
    var fds = controller.formD.where((e) => e["IsParent_ID"] == fid).toList();
    if (fds.isEmpty) return const SizedBox.shrink();
    return Wrap(
        children: fds.map((e) => InputColumn(input: e, isview: true)).toList());
  }

  Widget infoRquest(context) {
    var request = controller.request;
    const breakRow = SizedBox(height: 10);
    TextStyle label = const TextStyle(color: Colors.black87, fontSize: 13);

    return Container(
      padding: const EdgeInsets.only(
          top: 15.0, bottom: 0.0, left: 15.0, right: 15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          //Title
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              if (request["Uutien"] != null && request["Uutien"] > 0) ...[
                const Icon(Icons.star, color: Colors.orange, size: 20.0),
                const SizedBox(width: 5.0),
              ],
              Expanded(
                child: Text(
                  request["Title"] ?? "",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Color(0xFF045997),
                  ),
                ),
              ),
              const SizedBox(width: 10.0),
              StatusRequest(request: request),
            ],
          ),
          breakRow,
          //Deadline
          if (request["IsQH"] == 1) ...[
            Wrap(
              children: [
                const Icon(AntDesign.clockcircle, color: Colors.red, size: 15),
                const SizedBox(width: 10),
                displayNgay(request),
              ],
            ),
          ] else ...[
            Wrap(
              children: [
                const Icon(AntDesign.clockcircleo,
                    color: Colors.black87, size: 15),
                const SizedBox(width: 10),
                displayNgay(request),
              ],
            ),
          ],
          breakRow,
          //FullName
          Wrap(
            children: [
              const Icon(Feather.user_plus, color: Colors.black87, size: 15),
              const SizedBox(width: 10),
              Text(request["fullName"] ?? "",
                  style: const TextStyle(
                      color: Colors.black87, fontWeight: FontWeight.w500)),
            ],
          ),
          breakRow,
          //Team đề xuất
          Wrap(
            children: [
              const Icon(Feather.tag, color: Colors.black87, size: 15),
              const SizedBox(width: 10),
              Text(request["Team_Name"] ?? "",
                  style: const TextStyle(color: Colors.black87)),
            ],
          ),
          breakRow,
          //Trạng thái xử lý
          Wrap(
            children: [
              const Icon(Feather.edit, color: Colors.black87, size: 15),
              const SizedBox(width: 10),
              HandleRequest(request: request),
            ],
          ),
          breakRow,
          //Deadline
          Container(
            padding: const EdgeInsets.symmetric(vertical: 5.0),
            child: Row(
              children: [
                if (request["Ngaycapnhat"] != null) ...[
                  Expanded(
                    child: Card(
                      margin: const EdgeInsets.only(right: 5.0),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(children: [
                          Container(
                            width: 36.0,
                            height: 36.0,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(25.0),
                              border: Border.all(
                                color: Colors.black54,
                                width: 1.0,
                              ),
                            ),
                            child: const Icon(
                                MaterialCommunityIcons.calendar_edit,
                                size: 18.0),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Ngày cập nhật", style: label),
                                const SizedBox(height: 5),
                                Text(
                                  DateTimeFormat.format(
                                          DateTime.parse(
                                              request["Ngaycapnhat"]),
                                          format: 'H:i d/m')
                                      .replaceAll("00:00 ", ""),
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          )
                        ]),
                      ),
                    ),
                  ),
                ],
                if (request["Dateline"] != null) ...[
                  Expanded(
                    child: Card(
                      color:
                          request["IsQH"] == true ? Colors.red : Colors.white,
                      margin: const EdgeInsets.only(left: 5.0),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(children: [
                          Container(
                            width: 36.0,
                            height: 36.0,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(25.0),
                              border: Border.all(
                                color: request["IsQH"] == true
                                    ? Colors.white
                                    : Colors.black54,
                                width: 1.0,
                              ),
                            ),
                            child: Icon(
                              MaterialCommunityIcons.calendar_clock,
                              size: 18.0,
                              color: request["IsQH"] == true
                                  ? Colors.white
                                  : Colors.black87,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Hạn xử lý",
                                  style: TextStyle(
                                    color: request["IsQH"] == true
                                        ? Colors.white
                                        : Colors.black87,
                                    fontSize: 13,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  DateTimeFormat.format(
                                          DateTime.parse(request["Dateline"]),
                                          format: 'H:i d/m')
                                      .replaceAll("00:00 ", ""),
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: request["IsQH"] == true
                                        ? Colors.white
                                        : Colors.black87,
                                  ),
                                ),
                              ],
                            ),
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
          Obx(() => formDWidget(null)),
          breakRow,
          //Người duyệt
          Container(
            padding: const EdgeInsets.symmetric(vertical: 5.0),
            width: double.infinity,
            child: Column(
              children: [
                Row(
                  children: <Widget>[
                    const Icon(Feather.users, color: Colors.black87, size: 15),
                    const SizedBox(width: 10),
                    Text(
                      "Người duyệt",
                      style: label,
                      textAlign: TextAlign.justify,
                    ),
                  ],
                ),
                breakRow,
                InkWell(
                  onTap: () {
                    rqcontroller.viewUser(context, request);
                  },
                  child: MemberRequest(
                    signs: request["Signs"] ?? [],
                    showMore: true,
                  ),
                ),
              ],
            ),
          ),
          breakRow,
          //Tiến độ
          Container(
            padding: const EdgeInsets.symmetric(vertical: 5.0),
            width: double.infinity,
            child: Column(
              children: [
                Row(
                  children: <Widget>[
                    const Icon(Fontisto.prescription,
                        color: Colors.black87, size: 15),
                    const SizedBox(width: 10),
                    Text(
                      "Tiến độ",
                      style: label,
                      textAlign: TextAlign.justify,
                    ),
                  ],
                ),
                breakRow,
                if (request["Tiendo"] != null)
                  Stack(
                    children: [
                      LinearPercentIndicator(
                        padding: EdgeInsets.zero,
                        backgroundColor:
                            request["Tiendo"] == null || request["Tiendo"] == 0
                                ? Colors.red
                                : const Color(0xffcccccc),
                        animation: true,
                        animationDuration: 1000,
                        lineHeight: 24.0,
                        percent: request["Tiendo"] / 100,
                        center: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            request["Tiendo"] != null && request["Tiendo"] > 0
                                ? Text(
                                    " ${request["Tiendo"].ceil()} %",
                                    style: TextStyle(
                                      color: (request["Tiendo"] != null &&
                                              request["Tiendo"] >= 60)
                                          ? Colors.white
                                          : Colors.black,
                                      fontSize: 12.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  )
                                : const SizedBox.shrink(),
                          ],
                        ),
                        barRadius: const Radius.circular(16),
                        progressColor: renderColor(request["Tiendo"]),
                      ),
                      if (request["Tiendo"] == null ||
                          request["Tiendo"] == 0) ...[
                        SizedBox(
                          height: 24.0,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                " ${request["Tiendo"].ceil()} %",
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
            ),
          ),
          breakRow,
          //Mức độ ưu tiên
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
                      "Mức độ ưu tiên",
                      style: label,
                      textAlign: TextAlign.justify,
                    ),
                    const SizedBox(width: 10),
                    Container(
                      padding: const EdgeInsets.all(5.0),
                      decoration: BoxDecoration(
                        color: uutienColor(request["Uutien"]),
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      child: Text(
                        request["Uutien"] == 0
                            ? "Bình thường"
                            : request["Uutien"] == 1
                                ? "Gấp"
                                : "Rất gấp",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12.0,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          breakRow,
          //Mô tả
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
                    // IconButton(
                    //   onPressed: () {},
                    //   icon: Icon(AntDesign.edit,
                    //       color: Golbal.appColor, size: 15),
                    //   tooltip: "Chỉnh sửa mô tả",
                    // ),
                  ],
                ),
                breakRow,
                SizedBox(
                  height: 100.0,
                  child: Card(
                    margin: EdgeInsets.zero,
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(
                                request["Mota"] ?? "Chưa có mô tả",
                                style: label,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
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
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context)
          .copyWith(textScaleFactor: Golbal.textScaleFactor),
      child: KeyboardDismisser(
        gestures: const [
          GestureType.onTap,
          GestureType.onPanUpdateDownDirection,
        ],
        child: Scaffold(
          backgroundColor: const Color(0xfff5f5f5),
          appBar: AppBar(
              backgroundColor: Golbal.appColorD,
              elevation: 1.0,
              iconTheme: IconThemeData(color: Golbal.iconColor),
              leading: IconButton(
                icon: Icon(
                  Ionicons.chevron_back_outline,
                  color: Colors.black.withOpacity(0.5),
                  size: 30,
                ),
                onPressed: () {
                  controller.goBack(false);
                },
              ),
              centerTitle: false,
              systemOverlayStyle: Golbal.systemUiOverlayStyle1,
              titleSpacing: 0,
              actions: <Widget>[
                //iconButtonBar(Feather.check_circle, null),
                //iconButtonBar(Fontisto.prescription, null),
                IconButton(
                  onPressed: () {
                    controller.scrollBottom();
                  },
                  icon: const Icon(FontAwesome.comment_o),
                ),
                //iconButtonBar(Icons.attach_file, null),
                iconButtonBar(Feather.clock, controller.goAtivity),
                IconButton(
                  onPressed: () {
                    controller.moreAction(context);
                  },
                  icon: const Icon(Feather.more_horizontal),
                ),
              ]),
          body: Obx(
            () => controller.loading.value
                ? const InlineLoadding()
                : Column(
                    children: <Widget>[
                      Expanded(
                        child: SingleChildScrollView(
                          controller: controller.scrollController,
                          child: Column(
                            children: <Widget>[
                              infoRquest(context),
                              const SizedBox(height: 10),
                              CommentRequest(),
                            ],
                          ),
                        ),
                      ),
                      if (controller.request["Title"] != null)
                        Obx(
                          () => controller.showInputComment.value
                              ? InputComment()
                              : const SizedBox.shrink(),
                        ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
