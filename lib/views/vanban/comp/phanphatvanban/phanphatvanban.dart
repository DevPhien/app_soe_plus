import 'package:date_time_format/date_time_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';

import '../../../../utils/golbal/golbal.dart';
import '../../../component/use/avatar.dart';
import 'phanphatvanbancontroller.dart';

class PhanPhatVanBan extends StatelessWidget {
  final PhanPhatVanBanController controller =
      Get.put(PhanPhatVanBanController());
  PhanPhatVanBan({
    Key? key,
  }) : super(key: key);

  Widget chonUser(List users, Color bgColor, Color textColor) {
    return InkWell(
      onTap: () {
        FocusScope.of(Get.context!).unfocus();
        controller.showUser();
      },
      child: Container(
        height: 55,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            border: Border.all(color: const Color(0xFFcccccc), width: 1.0)),
        child: ListView.builder(
          itemBuilder: (ct, i) => Container(
            margin: const EdgeInsets.only(right: 5),
            child: Chip(
              label: Text(
                '${users[i]["fullName"]}',
                style: TextStyle(color: textColor, fontSize: 11),
              ),
              avatar: UserAvarta(user: users[i]),
              backgroundColor: bgColor,
              onDeleted: () {
                controller.deleUser(i);
              },
              deleteIcon: const Icon(
                Ionicons.close_circle_outline,
                size: 20,
              ),
              deleteIconColor: textColor,
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            ),
          ),
          itemCount: users.length,
          scrollDirection: Axis.horizontal,
        ),
      ),
    );
  }

  Widget chonDonvi(List donvis) {
    return InkWell(
      onTap: () {
        controller.showDonvi();
      },
      child: Container(
        height: 55,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            border: Border.all(color: const Color(0xFFcccccc), width: 1.0)),
        child: ListView.builder(
          itemBuilder: (ct, i) => Container(
            margin: const EdgeInsets.only(right: 5),
            child: Chip(
              label: Text(
                '${donvis[i]["tenCongty"]}',
                style: const TextStyle(color: Colors.white, fontSize: 11),
              ),
              backgroundColor: Golbal.appColor,
              onDeleted: () {
                controller.deleDonvi(i);
              },
              deleteIcon: const Icon(
                Ionicons.close_circle_outline,
                size: 20,
              ),
              deleteIconColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            ),
          ),
          itemCount: donvis.length,
          scrollDirection: Axis.horizontal,
        ),
      ),
    );
  }

  Widget chonGroup(List donvis) {
    return InkWell(
      onTap: () {
        controller.showGroup();
      },
      child: Container(
        height: 55,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            border: Border.all(color: const Color(0xFFcccccc), width: 1.0)),
        child: ListView.builder(
          itemBuilder: (ct, i) => Container(
            margin: const EdgeInsets.only(right: 5),
            child: Chip(
              label: Text(
                '${donvis[i]["NhomChucnang_Ten"]}',
                style: const TextStyle(color: Colors.white, fontSize: 11),
              ),
              backgroundColor: Golbal.appColor,
              onDeleted: () {
                controller.deleGroup(i);
              },
              deleteIcon: const Icon(
                Ionicons.close_circle_outline,
                size: 20,
              ),
              deleteIconColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            ),
          ),
          itemCount: donvis.length,
          scrollDirection: Axis.horizontal,
        ),
      ),
    );
  }

  Widget inputDate(dynamic sdate, String mkey) {
    return InkWell(
      onTap: () {
        FocusScope.of(Get.context!).unfocus();
        controller.openDate(mkey);
      },
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            border: Border.all(color: const Color(0xFFcccccc), width: 1.0)),
        child: Row(
          children: [
            Expanded(
                child: Text(
                    sdate == null
                        ? ""
                        : DateTimeFormat.format(DateTime.parse(sdate),
                            format: 'd/m/Y'),
                    style: Golbal.styleinput)),
            const SizedBox(width: 10),
            const Icon(
              Fontisto.date,
              color: Colors.black54,
            )
          ],
        ),
      ),
    );
  }

  Widget formWidget() {
    var breakRow = const SizedBox(height: 10);
    return Form(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Đơn vị nhận (Gửi toàn bộ công ty)", style: Golbal.stylelabel),
        breakRow,
        Obx(() => chonDonvi(controller.orgids)),
        breakRow,
        if (controller.butkey.value == "9.1")
          Text("Nhóm nhận (Gửi đến nhóm đã tạo)", style: Golbal.stylelabel),
        if (controller.butkey.value == "9.1") breakRow,
        if (controller.butkey.value == "9.1")
          Obx(() => chonGroup(controller.publishgroupids)),
        breakRow,
        Text("Người nhận khác (Gửi đích danh)", style: Golbal.stylelabel),
        breakRow,
        Obx(() => chonUser(
            controller.userids, const Color(0xFFCCADD7), Colors.white)),
        breakRow,
        Text("Nội dung", style: Golbal.stylelabel),
        breakRow,
        TextFormField(
          minLines: 5,
          maxLines: 10,
          decoration: Golbal.decoration,
          style: Golbal.styleinput,
          onChanged: (String txt) => controller.model["message"] = txt,
        ),
      ],
    ));
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
        data: MediaQuery.of(context)
            .copyWith(textScaleFactor: Golbal.textScaleFactor),
        child: KeyboardDismisser(
            child: Scaffold(
          backgroundColor: const Color(0xffffffff),
          appBar: AppBar(
            backgroundColor: Golbal.appColorD,
            elevation: 1.0,
            iconTheme: IconThemeData(color: Golbal.iconColor),
            title: Text("Phân phát văn bản",
                style: TextStyle(
                    color: Golbal.titleappColor, fontWeight: FontWeight.bold)),
            centerTitle: true,
            systemOverlayStyle: Golbal.systemUiOverlayStyle1,
          ),
          body: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                Expanded(child: SingleChildScrollView(child: formWidget())),
                const SizedBox(height: 10),
                Container(
                  width: 150,
                  height: 80,
                  padding: const EdgeInsets.all(20),
                  child: ElevatedButton(
                    onPressed: () {
                      controller.submit();
                    },
                    child: const Text("Gửi",
                        style: TextStyle(color: Colors.white)),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                          const Color(0xFF2196f3)),
                    ),
                  ),
                )
              ],
            ),
          ),
        )));
  }
}
