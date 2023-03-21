// ignore_for_file: must_be_immutable, unnecessary_null_comparison

import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:soe/utils/golbal/golbal.dart';
import 'package:flutter/cupertino.dart';

import '../../../../component/use/avatar.dart';
import '../../../../component/use/inlineloadding.dart';
import '../../../controller/message/infousercontroller.dart';

class InfoUser extends StatelessWidget {
  final InfoUserController infoUserController = Get.put(InfoUserController());
  InfoUser({Key? key}) : super(key: key);

  // Widget thumbContaint(dynamic chat) {
  //   return SizedBox(
  //     width: 80,
  //     height: 80,
  //     child: renderAvarta(chat, 1, 80, 18),
  //   );
  // }

  Widget widgetInfoUser(context) {
    return Container(
      alignment: Alignment.topCenter,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.center,
                  //child: thumbContaint(infoUserController.user),
                  child: UserAvarta(user: infoUserController.user, radius: 60),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10.0, bottom: 5.0),
                  child: Text(
                    "${infoUserController.user["fullName"] ?? ""}",
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20.0,
                        color: Colors.black87),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: () {
                    infoUserController.goChat(infoUserController.user);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5.0),
                      color: Colors.white,
                    ),
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      children: <Widget>[
                        Icon(
                          Ionicons.chatbubbles_outline,
                          color: Golbal.appColor,
                        ),
                        const SizedBox(width: 10.0),
                        const Text(
                          "Nhắn tin",
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    infoUserController.goSMS(infoUserController.user);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5.0),
                      color: Colors.white,
                    ),
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      children: <Widget>[
                        Icon(
                          AntDesign.message1,
                          color: Golbal.appColor,
                        ),
                        const SizedBox(width: 10.0),
                        const Text(
                          "Gửi SMS",
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    infoUserController.callPhone(infoUserController.user);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5.0),
                      color: Colors.white,
                    ),
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      children: <Widget>[
                        Icon(
                          Feather.phone_call,
                          color: Golbal.appColor,
                        ),
                        const SizedBox(width: 10.0),
                        const Text(
                          "Gọi điện",
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.only(left: 10.0, right: 10.0, bottom: 10.0),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 5.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5.0),
                color: Colors.white,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10.0,
                      vertical: 5.0,
                    ),
                    child: Row(
                      children: <Widget>[
                        const Icon(
                          FontAwesome.birthday_cake,
                          color: Colors.pink,
                        ),
                        const SizedBox(width: 10.0),
                        Expanded(
                          child: Text(
                            "Ngày sinh nhật: ${infoUserController.user["ngaySinh"] ?? ""}",
                            style: const TextStyle(
                                fontWeight: FontWeight.w400, fontSize: 16.0),
                          ),
                        )
                      ],
                    ),
                  ),
                  const Divider(thickness: .5),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10.0,
                      vertical: 5.0,
                    ),
                    child: Row(
                      children: <Widget>[
                        const Icon(Entypo.cog),
                        const SizedBox(width: 10.0),
                        Expanded(
                          child: Text(
                            "Biệt danh: ${infoUserController.user["nickName"] ?? ""}",
                            style: const TextStyle(
                                fontWeight: FontWeight.w400, fontSize: 16.0),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              left: 10.0,
              right: 10.0,
              bottom: 10.0,
            ),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5.0),
                color: Colors.white,
              ),
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10.0,
                      vertical: 5.0,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const <Widget>[
                        Icon(
                          FontAwesome.building_o,
                        ),
                        SizedBox(width: 10.0),
                        Text(
                          "Công tác tại",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 16.0),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    children: <Widget>[
                      const Divider(thickness: .5),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            const Text(
                              "• Tên đơn vị: ",
                              style: TextStyle(
                                  fontWeight: FontWeight.w400, fontSize: 16.0),
                            ),
                            Expanded(
                              child: Text(
                                "${infoUserController.user["tenCongty"] ?? ""}",
                                style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16.0),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            const Text(
                              "• Phòng ban: ",
                              style: TextStyle(
                                  fontWeight: FontWeight.w400, fontSize: 16.0),
                            ),
                            Expanded(
                              child: Text(
                                "${infoUserController.user["tenPhongban"] ?? ""}",
                                style: const TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 16.0),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 0.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            const Text(
                              "• Chức vụ: ",
                              style: TextStyle(
                                  fontWeight: FontWeight.w400, fontSize: 16.0),
                            ),
                            Expanded(
                              child: Text(
                                "${infoUserController.user["tenChucVu"] ?? ""}",
                                style: const TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 16.0),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              left: 10.0,
              right: 10.0,
              bottom: 10.0,
            ),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 5.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5.0),
                color: Colors.white,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10.0,
                      vertical: 5.0,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const <Widget>[
                        Icon(
                          AntDesign.contacts,
                        ),
                        SizedBox(width: 10.0),
                        Text(
                          "Thông tin liên hệ",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 16.0),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    children: <Widget>[
                      const Divider(thickness: .5),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10.0,
                          vertical: 5.0,
                        ),
                        child: Row(
                          children: <Widget>[
                            const Icon(Feather.phone),
                            const SizedBox(width: 10.0),
                            const Text(
                              "Điện thoại: ",
                              style: TextStyle(
                                  fontWeight: FontWeight.w400, fontSize: 16.0),
                            ),
                            Expanded(
                              child: InkWell(
                                onTap: () {
                                  infoUserController
                                      .callPhone(infoUserController.user);
                                },
                                child: Text(
                                  "${infoUserController.user["phone"] ?? ""}",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16.0),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Divider(thickness: .5),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10.0,
                          vertical: 5.0,
                        ),
                        child: Row(
                          children: <Widget>[
                            const Icon(Feather.mail),
                            const SizedBox(width: 10.0),
                            const Text(
                              "Email: ",
                              style: TextStyle(
                                  fontWeight: FontWeight.w400, fontSize: 16.0),
                            ),
                            Expanded(
                              child: InkWell(
                                onTap: () {
                                  infoUserController.sendMail(
                                      "${infoUserController.user["mail"] ?? ""}");
                                },
                                child: Text(
                                  "${infoUserController.user["mail"] ?? ""}",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 16.0),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Divider(thickness: .5),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10.0,
                          vertical: 5.0,
                        ),
                        child: Row(
                          children: <Widget>[
                            const Icon(Ionicons.location_outline),
                            const SizedBox(width: 10.0),
                            const Text(
                              "Địa chỉ: ",
                              style: TextStyle(
                                  fontWeight: FontWeight.w400, fontSize: 16.0),
                            ),
                            Expanded(
                              child: Text(
                                "${infoUserController.user["diaChi"] ?? ""}",
                                style: const TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 16.0),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              left: 10.0,
              right: 10.0,
              bottom: 10.0,
            ),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5.0),
                color: Colors.white,
              ),
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10.0,
                      vertical: 0,
                    ),
                    child: ListTile(
                      contentPadding: EdgeInsets.zero,
                      onTap: () {
                        infoUserController.user["IsFaverites"] =
                            !(infoUserController.user["IsFaverites"] || false);
                        infoUserController.setFaverites(
                            infoUserController.user["IsFaverites"]);
                      },
                      // leading: Icon(AntDesign.staro,
                      //     color: Golbal.appColor),
                      title: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: const <Widget>[
                          Icon(
                            AntDesign.staro,
                            color: Colors.orange,
                          ),
                          SizedBox(width: 10.0),
                          Text(
                            "Đánh dấu yêu thích",
                            style: TextStyle(
                                fontWeight: FontWeight.w400, fontSize: 16.0),
                          ),
                        ],
                      ),
                      trailing: CupertinoSwitch(
                        value: infoUserController.user["IsFaverites"] ?? true,
                        onChanged: (value) {
                          infoUserController.setFaverites(value);
                        },
                      ),
                    ),
                  ),
                  const Divider(thickness: .5),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10.0,
                      vertical: 5.0,
                    ),
                    child: Row(
                      children: <Widget>[
                        const Icon(FontAwesome.users),
                        const SizedBox(width: 10.0),
                        Text(
                          "Nhóm chung: ${infoUserController.user["countNhomChung"] ?? 0}",
                          style: const TextStyle(
                              fontWeight: FontWeight.w400, fontSize: 16.0),
                        ),
                      ],
                    ),
                  ),
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
      child: Obx(
        () => infoUserController.loading.value
            ? const Scaffold(
                backgroundColor: Colors.white,
                body: InlineLoadding(),
              )
            : Scaffold(
                backgroundColor: const Color(0xFFf2f2f2),
                appBar: AppBar(
                  iconTheme: const IconThemeData(color: Colors.black45),
                  elevation: 0.0,
                  titleSpacing: 0.0,
                  backgroundColor: Colors.white,
                  title: const Text(
                    "Thông tin cá nhân",
                    style: TextStyle(
                      color: Color(0xFF0186f8),
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  //systemOverlayStyle: SystemUiOverlayStyle.light,
                  centerTitle: true,
                ),
                body: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Obx(
                    () => infoUserController.loading.value &&
                            infoUserController.user == null
                        ? const InlineLoadding()
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              widgetInfoUser(context),
                            ],
                          ),
                  ),
                ),
              ),
      ),
    );
  }
}
