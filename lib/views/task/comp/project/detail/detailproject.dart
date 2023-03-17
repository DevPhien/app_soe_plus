import 'package:date_time_format/date_time_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';
import 'package:soe/utils/golbal/golbal.dart';
import 'package:soe/views/component/use/inlineloadding.dart';
import 'package:soe/views/task/comp/itemthanhvien.dart';
import 'package:soe/views/task/comp/project/detail/comment/commentproject.dart';
import 'package:soe/views/task/comp/project/detail/comment/inputcommentproject.dart';
import 'package:soe/views/task/comp/project/detail/detailprojectcontroller.dart';
import 'package:soe/views/task/comp/project/statusproject.dart';

class DetailProject extends StatelessWidget {
  final DetailProjectController controller = Get.put(DetailProjectController());
  DetailProject({Key? key}) : super(key: key);

  Widget infoProject(context) {
    var project = controller.project;
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
              if (project["Uutien"] != null && project["Uutien"] > 0) ...[
                const Icon(Icons.star, color: Colors.orange, size: 20.0),
                const SizedBox(width: 5.0),
              ],
              Expanded(
                child: Text(
                  project["TenDuan"] ?? "",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Color(0xFF045997),
                  ),
                ),
              ),
              const SizedBox(width: 10.0),
              if (project.isNotEmpty) ...[
                StatusProject(project: project),
              ]
            ],
          ),
          breakRow,
          //Deadline
          if (project["IsQH"] == true) ...[
            Wrap(
              children: [
                const Icon(AntDesign.clockcircle, color: Colors.red, size: 15),
                const SizedBox(width: 10),
                displayNgay(project),
              ],
            ),
          ] else ...[
            Wrap(
              children: [
                const Icon(AntDesign.clockcircleo,
                    color: Colors.black87, size: 15),
                const SizedBox(width: 10),
                displayNgay(project),
              ],
            ),
          ],
          breakRow,
          //FullName
          Wrap(
            children: [
              const Icon(Feather.user_plus, color: Colors.black87, size: 15),
              const SizedBox(width: 10),
              Text(project["TenNguoiTao"] ?? "",
                  style: const TextStyle(
                      color: Colors.black87, fontWeight: FontWeight.w500)),
            ],
          ),
          breakRow,
          //Nhóm dự án
          if (project["TenNhomDuan"] != null &&
              project["TenNhomDuan"] != "") ...[
            Wrap(
              children: [
                const Icon(Feather.tag, color: Colors.black87, size: 15),
                const SizedBox(width: 10),
                Text(project["TenNhomDuan"] ?? "",
                    style: const TextStyle(color: Colors.black87)),
              ],
            ),
            breakRow,
          ],
          Container(
            padding: const EdgeInsets.symmetric(vertical: 5.0),
            child: Row(
              children: [
                if (project["Ngaycapnhat"] != null) ...[
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
                                              project["Ngaycapnhat"]),
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
                if (project["NgayKetThuc"] != null) ...[
                  Expanded(
                    child: Card(
                      color:
                          project["IsQH"] == true ? Colors.red : Colors.white,
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
                                color: project["IsQH"] == true
                                    ? Colors.white
                                    : Colors.black54,
                                width: 1.0,
                              ),
                            ),
                            child: Icon(
                              MaterialCommunityIcons.calendar_clock,
                              size: 18.0,
                              color: project["IsQH"] == true
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
                                    color: project["IsQH"] == true
                                        ? Colors.white
                                        : Colors.black87,
                                    fontSize: 13,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  DateTimeFormat.format(
                                          DateTime.parse(
                                              project["NgayKetThuc"]),
                                          format: 'H:i d/m')
                                      .replaceAll("00:00 ", ""),
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: project["IsQH"] == true
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
          //Thành viên quản trị
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
                      "Thành viên quản trị",
                      style: label,
                      textAlign: TextAlign.justify,
                    ),
                  ],
                ),
                breakRow,
                InkWell(
                  onTap: () {
                    controller.viewUser(
                        context, controller.quantris, "Thành viên quản trị");
                  },
                  child: ThanhVienTask(
                    thanhviens: controller.quantris,
                    showMore: true,
                  ),
                ),
              ],
            ),
          ),
          breakRow,
          //Thành viên tham gia
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
                      "Thành viên tham gia",
                      style: label,
                      textAlign: TextAlign.justify,
                    ),
                  ],
                ),
                breakRow,
                InkWell(
                  onTap: () {
                    controller.viewUser(
                        context, controller.thamgias, "Thành viên tham gia");
                  },
                  child: ThanhVienTask(
                    thanhviens: controller.thamgias,
                    showMore: true,
                  ),
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
                                project["Mota"] ?? "Chưa có mô tả",
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

  Widget displayNgay(project) {
    TextStyle label = TextStyle(
        color: project["IsQH"] == true ? Colors.red : Golbal.titleColor,
        fontSize: 13);
    String? ktngay = project["NgayKetThuc"] != null
        ? DateTimeFormat.format(DateTime.parse(project["NgayKetThuc"]),
                format: 'H:i d/m/Y')
            .replaceAll("00:00 ", "")
        : "";
    String? bdngay = project["NgayBatDau"] != null
        ? DateTimeFormat.format(DateTime.parse(project["NgayBatDau"]),
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

  Widget iconButtonBar(IconData icon, onClick) {
    return IconButton(
      onPressed: onClick,
      icon: Icon(icon),
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
              iconButtonBar(Fontisto.prescription, controller.goTask),
              IconButton(
                onPressed: () {
                  controller.scrollBottom();
                },
                icon: const Icon(FontAwesome.comment_o),
              ),
              // //iconButtonBar(Icons.attach_file, null),
              // iconButtonBar(Feather.clock, controller.goAtivity),
              IconButton(
                onPressed: () {
                  controller.moreAction(context);
                },
                icon: const Icon(Feather.more_horizontal),
              ),
            ],
          ),
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
                              infoProject(context),
                              const SizedBox(height: 10),
                              CommentProject(),
                            ],
                          ),
                        ),
                      ),
                      InputCommentProject(),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
