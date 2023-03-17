// ignore_for_file: must_be_immutable

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:soe/utils/golbal/golbal.dart';
import 'package:soe/views/chat/comp/message/infochat/itemmember.dart';
import 'package:soe/views/chat/controller/chatcontroller.dart';
import 'package:soe/views/chat/controller/message/infochatcontroller.dart';
import 'package:soe/views/component/use/inlineloadding.dart';
import 'package:flutter/cupertino.dart';

class InfoChat extends StatelessWidget {
  final InfoChatController infochatController = Get.put(InfoChatController());
  final ChatController chatController = Get.put(ChatController());
  InfoChat({Key? key}) : super(key: key);

  Widget itemMember(context, i) =>
      ItemMember(user: infochatController.members[i], index: i);

  Widget thumbContaint(dynamic chat) {
    return SizedBox(
      width: 80,
      height: 80,
      child: chatController.renderAvarta(chat, 1, 80, 18),
    );
  }

  Widget widgetInfo(context) {
    TextStyle stylelabel = const TextStyle(color: Colors.black, fontSize: 15.0);
    var breakRow = const SizedBox(height: 10);
    return Container(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        children: <Widget>[
          Row(
            children: [
              Text("Tên nhóm", style: stylelabel),
              Text(" (*)", style: infochatController.saoStyle)
            ],
          ),
          breakRow,
          Container(
            color: Colors.white,
            child: TextFormField(
              maxLines: null,
              decoration: Golbal.decoration,
              style: stylelabel,
              onChanged: (String txt) =>
                  infochatController.chat["tenNhom"] = txt,
              initialValue: infochatController.chat["tenNhom"],
              onSaved: (String? str) {
                infochatController.chat["tenNhom"] = str;
              },
              validator: (value) {
                if (value == null) {
                  return 'Vui lòng nhập tên nhóm';
                }
                return null;
              },
            ),
            // TextFormField(
            //   initialValue: infochatController.chat["tenNhom"],
            //   keyboardType: TextInputType.multiline,
            //   keyboardAppearance: Brightness.light,
            //   maxLines: null,
            //   decoration: InputDecoration(
            //     contentPadding:
            //         const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
            //     focusedBorder: UnderlineInputBorder(
            //       borderSide: BorderSide(
            //         width: 0.5,
            //         color: Golbal.appColor,
            //       ),
            //     ),
            //     hintText: "Đặt tên nhóm",
            //   ),
            //   onSaved: (String? str) {
            //     infochatController.chat["tenNhom"] = str;
            //   },
            //   validator: (value) {
            //     if (value == null) {
            //       return 'Vui lòng nhập tên nhóm';
            //     }
            //     return null;
            //   },
            // ),
          ),
        ],
      ),
    );
  }

  Widget widgetMember(context) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.only(top: 10.0, left: 5.0, right: 5.0),
          padding: const EdgeInsets.all(8),
          color: const Color(0xFFF9F8F8),
          child: Row(
            children: [
              const Icon(
                Feather.users,
                size: 14,
              ),
              const SizedBox(width: 5),
              Text(
                "Thành viên (${infochatController.members.length})",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Golbal.titleColor,
                ),
              ),
              if (infochatController.chat["chuNhom"] == true)
                Expanded(
                  child: InkWell(
                    onTap: () {
                      infochatController.openModalAddUserChatGroup(context);
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      mainAxisSize: MainAxisSize.max,
                      children: const <Widget>[
                        Icon(AntDesign.addusergroup),
                      ],
                    ),
                  ),
                )
              else
                const SizedBox(height: 0, width: 0),
            ],
          ),
        ),
        infochatController.members.isNotEmpty
            ? ListView.separated(
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: itemMember,
                itemCount: infochatController.members.length,
                separatorBuilder: (_, __) => const Divider(
                  height: 1,
                  color: Color(0xffeeeeee),
                ),
              )
            : !infochatController.loading.value
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Center(
                        child: Image.asset("assets/nochat.png"),
                      ),
                      const SizedBox(height: 10.0),
                      const Text(
                        "Hiện chưa có thành viên nào",
                        style: TextStyle(
                          color: Colors.black45,
                        ),
                      ),
                    ],
                  )
                : const InlineLoadding(),
      ],
    );
  }

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
                  child: thumbContaint(infochatController.chat),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10.0, bottom: 5.0),
                  child: Text(
                    "${infochatController.chat["fullName"] ?? ""}",
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
                    Navigator.of(context).pop();
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
                    infochatController.goSMS(infochatController.chat);
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
                    infochatController.callPhone(infochatController.chat);
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
                            "Ngày sinh nhật: ${infochatController.chat["ngaySinh"] ?? ""}",
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
                            "Biệt danh: ${infochatController.chat["nickName"] ?? ""}",
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
                                "${infochatController.chat["tenCongty"] ?? ""}",
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
                                "${infochatController.chat["tenPhongban"] ?? ""}",
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
                                "${infochatController.chat["tenChucVu"] ?? ""}",
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
                                  infochatController
                                      .callPhone(infochatController.chat);
                                },
                                child: Text(
                                  "${infochatController.chat["phone"] ?? ""}",
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
                                  infochatController.sendMail(
                                      "${infochatController.chat["mail"] ?? ""}");
                                },
                                child: Text(
                                  "${infochatController.chat["mail"] ?? ""}",
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
                                "${infochatController.chat["diaChi"] ?? ""}",
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
                        infochatController.chat["IsFaverites"] =
                            !(infochatController.chat["IsFaverites"] || false);
                        infochatController.setFaverites(
                            infochatController.chat["IsFaverites"]);
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
                        value: infochatController.chat["IsFaverites"] ?? true,
                        onChanged: (value) {
                          infochatController.setFaverites(value);
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
                          "Nhóm chung: ${infochatController.chat["countNhomChung"] ?? 0}",
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
          widgetImage(context),
        ],
      ),
    );
  }

  Widget widgetImage(context) {
    int gr = 4;
    return Padding(
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
                    Feather.image,
                  ),
                  SizedBox(width: 10.0),
                  Text(
                    "Ảnh/Video",
                    textAlign: TextAlign.center,
                    style:
                        TextStyle(fontWeight: FontWeight.w600, fontSize: 16.0),
                  ),
                ],
              ),
            ),
            Column(
              children: <Widget>[
                const Divider(thickness: .5),
                GridView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    childAspectRatio: 0.90,
                    crossAxisCount: gr,
                    crossAxisSpacing: 5.0,
                    mainAxisSpacing: 5.0,
                  ),
                  itemCount: infochatController.files.length,
                  itemBuilder: (context, index) {
                    var tm = infochatController.files[index];
                    double w = MediaQuery.of(context).size.width / 2 - 50;
                    return InkWell(
                      child: fileWidget(tm, w),
                      onTap: () {
                        Golbal.loadFile(tm["duongDan"]);
                      },
                    );
                  },
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                            Colors.grey.shade400,
                          ),
                        ),
                        onPressed: () {
                          infochatController.goArchives();
                        },
                        child: const Text(
                          "Xem tất cả",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget fileWidget(r, double w) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.black12,
        ),
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: Center(
        child: r["IsImage"] == true
            ? Image(
                image: CachedNetworkImageProvider(
                  "${Golbal.congty!.fileurl}${r["duongDan"]}",
                ),
                width: w - 20,
                height: w - 70,
                fit: BoxFit.cover,
              )
            : (r["loaiFile"] != null && r["loaiFile"] != "")
                ? Image(
                    image: AssetImage(
                        "assets/file/${r["loaiFile"].replaceAll('.', '')}.png"),
                    width: w - 20,
                    height: w - 100,
                    fit: BoxFit.contain,
                  )
                : SizedBox(
                    width: w - 20,
                    child: const Center(
                      child: Icon(
                        Feather.image,
                        color: Colors.black45,
                      ),
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
      child: Obx(
        () => infochatController.loading.value
            ? const Scaffold(
                backgroundColor: Colors.white,
                body: InlineLoadding(),
              )
            : Scaffold(
                backgroundColor: infochatController.chat["nhom"]
                    ? Colors.white
                    : const Color(0xFFf2f2f2),
                appBar: AppBar(
                  iconTheme: const IconThemeData(color: Colors.black45),
                  elevation: 0.0,
                  titleSpacing: 0.0,
                  backgroundColor: Colors.white,
                  title: Text(
                      infochatController.chat["nhom"]
                          ? "Thông tin nhóm"
                          : "Thông tin cá nhân",
                      style: const TextStyle(
                        color: Color(0xFF0186f8),
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                      )),
                  //systemOverlayStyle: SystemUiOverlayStyle.light,
                  actions: <Widget>[
                    if (infochatController.chat["chuNhom"] == true)
                      IconButton(
                        onPressed: () {
                          infochatController.saveChatGroup(context);
                        },
                        icon: const Icon(FontAwesome.save),
                      )
                    else
                      const SizedBox(
                        height: 0,
                        width: 0,
                      ),
                  ],
                  centerTitle: true,
                ),
                body: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Obx(
                    () => infochatController.loading.value &&
                            infochatController.chat.isEmpty
                        ? const InlineLoadding()
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              if (infochatController.chat["nhom"]) ...[
                                Form(
                                  key: infochatController.formKey,
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  child: Column(
                                    children: [
                                      Obx(() => widgetInfo(context)),
                                      Obx(() => widgetImage(context)),
                                      Obx(() => widgetMember(context)),
                                    ],
                                  ),
                                )
                              ] else ...[
                                widgetInfoUser(context),
                              ],
                            ],
                          ),
                  ),
                ),
              ),
      ),
    );
  }
}
