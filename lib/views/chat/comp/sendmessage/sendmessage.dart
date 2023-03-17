import 'package:circular_image/circular_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:soe/plugin/emoji_picker/emoji_picker.dart';
import 'package:soe/utils/golbal/golbal.dart';
import 'package:soe/views/chat/comp/message/sharemessage/itemchooseuser.dart';
import 'package:soe/views/chat/comp/sendmessage/sendmessagecontroller.dart';

class SendMessage extends StatelessWidget {
  final SendMessageController controller = Get.put(SendMessageController());
  SendMessage({Key? key}) : super(key: key);

  Widget itemChooseUser(context, i) => ItemChooseUser(
        user: controller.userdatas[i],
        onChecked: controller.checkedUser,
        index: i,
      );

  Widget bindEmoij(context) {
    if (!controller.isEmoij.value ||
        MediaQuery.of(context).viewInsets.bottom > 0) {
      return Container(
        width: 0.0,
      );
    }
    return Container(
      decoration: const BoxDecoration(
          border:
              Border(top: BorderSide(width: 0.5, color: Color(0xFFcccccc)))),
      padding: const EdgeInsets.only(top: 5.0),
      margin: const EdgeInsets.only(top: 5.0),
      child: EmojiPicker(
        bgColor: Colors.white,
        rows: 5,
        columns: 9,
        selectedCategory: Category.SMILEYS,
        numRecommended: 10,
        onEmojiSelected: (emoji, category) {
          controller.setEmoij(emoji);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(
        textScaleFactor: Golbal.textScaleFactor,
      ),
      child: Scaffold(
        backgroundColor: const Color(0xffffffff),
        appBar: AppBar(
          backgroundColor: Golbal.appColorD,
          elevation: 1.0,
          iconTheme: IconThemeData(color: Golbal.iconColor),
          title: Text(
            "Soạn tin nhắn",
            style: TextStyle(
              color: Golbal.titleappColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
          systemOverlayStyle: Golbal.systemUiOverlayStyle1,
          titleSpacing: 0,
        ),
        body: Column(
          children: <Widget>[
            AppBar(
              elevation: 0,
              backgroundColor: Colors.white,
              automaticallyImplyLeading: false,
              title: Container(
                width: double.infinity,
                height: 40,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: const Color(0xFFf9f8f8),
                    border:
                        Border.all(color: const Color(0xffeeeeee), width: 1.0)),
                child: Center(
                  child: TextField(
                    textInputAction: TextInputAction.search,
                    controller: controller.searchController,
                    onSubmitted: (String txt) {
                      controller.onSearch(txt);
                    },
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.all(5),
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      border: InputBorder.none,
                      hintText: 'Tìm kiếm',
                      prefixIcon: IconButton(
                        onPressed: () {
                          controller.onSearch(controller.searchController.text);
                        },
                        icon: const Icon(Icons.search),
                      ),
                      //suffixIcon: Icon(AntDesign.filter)
                    ),
                  ),
                ),
              ),
            ),
            Obx(
              () => ExpansionTile(
                title: Text(
                  "Đã chọn (${controller.chons.length})",
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Golbal.appColor),
                ),
                children: [
                  Container(
                    constraints: const BoxConstraints(
                      maxHeight: 150.0,
                    ),
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: Wrap(
                        children: controller.chons.map((u) {
                          return Container(
                              margin: const EdgeInsets.only(
                                  right: 5.0, bottom: 5.0),
                              child: Chip(
                                onDeleted: () {
                                  controller.checkedUser(u, false);
                                },
                                deleteIcon: const Icon(
                                  Icons.cancel,
                                  color: Colors.black45,
                                ),
                                label: Text(u["fullName"]),
                                avatar: Stack(
                                  children: [
                                    if (u["hasImage"])
                                      CircularImage(
                                        radius: 24,
                                        source: Golbal.congty!.fileurl +
                                            u["anhThumb"],
                                      )
                                    else
                                      CircleAvatar(
                                        backgroundColor: HexColor(u['bgColor']),
                                        radius: 24,
                                        child: Text(
                                          "${u['subten']}",
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: HexColor('#ffffff'),
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ));
                        }).toList(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Obx(
              () => Expanded(
                child: ListView.separated(
                  shrinkWrap: true,
                  padding: EdgeInsets.zero,
                  physics: const AlwaysScrollableScrollPhysics(),
                  itemBuilder: itemChooseUser,
                  itemCount: controller.userdatas.length,
                  separatorBuilder: (_, __) => const Divider(
                    height: 1,
                    color: Color(0xffeeeeee),
                  ),
                ),
              ),
            ),
            Obx(
              () => Container(
                decoration: const BoxDecoration(
                    color: Colors.white,
                    border: Border(
                        top: BorderSide(color: Color(0xFFcccccc), width: 1.0))),
                padding: const EdgeInsets.only(top: 5.0, bottom: 5.0),
                child: SafeArea(
                  child: Column(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          IconButton(
                            onPressed: () {
                              controller.showEmoij(context);
                            },
                            icon: Icon(Icons.insert_emoticon,
                                color: controller.isEmoij.value
                                    ? Golbal.appColor
                                    : Colors.black38),
                          ),
                          Container(
                            child: !controller.send.value
                                ? InkWell(
                                    onTap: () {
                                      controller.pickDocument(context);
                                    },
                                    child: const Padding(
                                      padding: EdgeInsets.only(right: 10.0),
                                      child: Icon(Icons.attach_file,
                                          color: Colors.black38),
                                    ))
                                : const SizedBox(
                                    width: 0.0,
                                    height: 0.0,
                                  ),
                          ),
                          Expanded(
                            child: ConstrainedBox(
                              constraints: const BoxConstraints(
                                maxHeight: 250.0,
                              ),
                              child: SingleChildScrollView(
                                scrollDirection: Axis.vertical,
                                reverse: true,
                                child: TextField(
                                  keyboardAppearance: Brightness.light,
                                  textInputAction: TextInputAction.newline,
                                  focusNode: controller.focus,
                                  controller: controller.textController.value,
                                  maxLines: null,
                                  //keyboardType: TextInputType.multiline,
                                  onChanged: (String txt) {
                                    controller.changeText(txt);
                                  },
                                  onSubmitted: (String txt) {
                                    controller.sendSMS();
                                  },
                                  decoration: const InputDecoration(
                                    isDense: true,
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(40.0)),
                                      borderSide:
                                          BorderSide(color: Color(0xFFdddddd)),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(40.0)),
                                      borderSide:
                                          BorderSide(color: Color(0xFFdddddd)),
                                    ),
                                    contentPadding: EdgeInsets.symmetric(
                                        vertical: 10.0, horizontal: 15.0),
                                    hintText: 'Tin nhắn',
                                    hintStyle: TextStyle(fontSize: 13.0),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 5.0),
                          controller.send.value
                              ? IconButton(
                                  onPressed: () {
                                    controller.sendSMS();
                                  },
                                  icon: const Icon(Icons.send,
                                      color: Color(0xFF0b72ff)),
                                )
                              : Container(
                                  width: 0.0,
                                ),
                          !controller.send.value
                              ? InkWell(
                                  onTap: () {
                                    controller.initMultiPickUp();
                                  },
                                  child: const Padding(
                                    padding: EdgeInsets.only(right: 8.0),
                                    child: Icon(
                                      EvilIcons.image,
                                      color: Colors.black38,
                                      size: 32,
                                    ),
                                  ))
                              : Container(
                                  width: 0.0,
                                )
                        ],
                      ),
                      Obx(() => bindEmoij(context)),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
