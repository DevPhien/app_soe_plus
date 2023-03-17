import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:soe/utils/golbal/golbal.dart';
import 'package:soe/views/chat/comp/message/audiomessage.dart';
import 'package:soe/views/chat/comp/message/filemessage.dart';
import 'package:soe/views/chat/comp/message/imagemessage.dart';
import 'package:soe/views/chat/comp/message/sharemessage/itemchoosechat.dart';
import 'package:soe/views/chat/comp/message/sharemessage/itemchooseuser.dart';
import 'package:soe/views/chat/comp/message/textmessage.dart';
import 'package:soe/views/chat/comp/message/videomessage.dart';
import 'package:soe/views/chat/controller/message/sharemessagecontroller.dart';
import 'package:soe/views/component/use/inlineloadding.dart';

class ShareMessage extends StatelessWidget {
  final ShareMessageController sharemessageController =
      Get.put(ShareMessageController());
  ShareMessage({Key? key}) : super(key: key);

  Widget itemChooseChat(context, i) => ItemChooseChat(
        chat: sharemessageController.chatdatas[i],
        onChecked: sharemessageController.checkedChat,
        index: i,
      );
  Widget itemChooseUser(context, i) => ItemChooseUser(
        user: sharemessageController.userdatas[i],
        onChecked: sharemessageController.checkedUser,
        index: i,
      );

  Widget messageContent(message) {
    switch (message["loai"]) {
      case 0: //text
        return TextMessage(message: message);
      case 1: //image
        return ImageMessage(message: message);
      case 2: //file
        return FileMessage(message: message);
      case 3: //video
        return VideoMessage(message: message);
      case 4: //audio
        return AudioMessage(message: message);
      default:
        return const SizedBox();
    }
  }

  Widget widgetForm() {
    TextStyle stylelabel = const TextStyle(color: Colors.black, fontSize: 15.0);
    TextStyle saoStyle = const TextStyle(color: Colors.red);
    var breakRow = const SizedBox(height: 10);
    return Form(
      key: sharemessageController.formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: [
              Text("Nội dung chia sẻ", style: stylelabel),
              Text(" (*)", style: saoStyle),
            ],
          ),
          if (sharemessageController.message["loai"] != 0)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                breakRow,
                Container(
                  constraints:
                      BoxConstraints(maxWidth: Golbal.screenSize.width - 80.0),
                  child: Container(
                    decoration: const BoxDecoration(
                        color: Color(0xFFdbf4fe),
                        borderRadius: BorderRadius.all(
                          Radius.circular(10.0),
                        )),
                    padding: sharemessageController.message["loai"] != 1
                        ? const EdgeInsets.symmetric(
                            horizontal: 10.0, vertical: 5.0)
                        : EdgeInsets.zero,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        messageContent(sharemessageController.message),
                        const SizedBox(
                          height: 2.0,
                        ),
                      ],
                    ),
                  ),
                ),
                breakRow,
                Text("Lời nhắn", style: stylelabel),
              ],
            ),
          breakRow,
          Column(
            children: [
              TextFormField(
                maxLines: null,
                decoration: Golbal.decoration,
                style: stylelabel,
                onChanged: (String txt) =>
                    sharemessageController.message["noiDung"] = txt,
                initialValue: sharemessageController.message["noiDung"],
                onSaved: (String? str) {
                  sharemessageController.message["noiDung"] = str;
                },
              ),
            ],
          ),
          breakRow,
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
                  controller: sharemessageController.searchController,
                  onSubmitted: (String txt) {
                    sharemessageController.onSearch(txt);
                  },
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.all(5),
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    border: InputBorder.none,
                    hintText: 'Tìm kiếm cuộc hội thoại, người dùng',
                    prefixIcon: IconButton(
                      onPressed: () {
                        sharemessageController.onSearch(
                            sharemessageController.searchController.text);
                      },
                      icon: const Icon(Icons.search),
                    ),
                    //suffixIcon: Icon(AntDesign.filter)
                  ),
                ),
              ),
            ),
          ),
          if (sharemessageController.chatdatas.isNotEmpty)
            Column(
              children: [
                Obx(
                  () => Container(
                    color: const Color(0xFFF9F8F8),
                    child: ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10.0, vertical: 5.0),
                        child: Row(
                          children: [
                            const Icon(
                              Ionicons.ios_chatbubbles_outline,
                              size: 16,
                            ),
                            const SizedBox(width: 5),
                            Text(
                              "Cuộc hội thoại (${sharemessageController.chatdatas.length})",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Golbal.titleColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                      trailing: Checkbox(
                        tristate: false,
                        activeColor: const Color(0xFF6dd230),
                        value: sharemessageController.isCheckedAllChat.value,
                        onChanged: (v) {
                          v ??= false;
                          sharemessageController.onCheckedAllChat(v);
                        },
                      ),
                    ),
                  ),
                ),
                Obx(
                  () => ListView.separated(
                    shrinkWrap: true,
                    padding: EdgeInsets.zero,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: itemChooseChat,
                    itemCount: sharemessageController.chatdatas.length,
                    separatorBuilder: (_, __) => const Divider(
                      height: 1,
                      color: Color(0xffeeeeee),
                    ),
                  ),
                ),
                Obx(
                  () => Container(
                    color: const Color(0xFFF9F8F8),
                    child: ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10.0, vertical: 5.0),
                        child: Row(
                          children: [
                            const Icon(
                              Feather.users,
                              size: 20,
                            ),
                            const SizedBox(width: 5),
                            Text(
                              "Người dùng khác (${sharemessageController.userdatas.length})",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Golbal.titleColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                      trailing: Checkbox(
                        tristate: false,
                        activeColor: const Color(0xFF6dd230),
                        value: sharemessageController.isCheckedAllUser.value,
                        onChanged: (v) {
                          v ??= false;
                          sharemessageController.onCheckedAllUser(v);
                        },
                      ),
                    ),
                  ),
                ),
                Obx(
                  () => ListView.separated(
                    shrinkWrap: true,
                    padding: EdgeInsets.zero,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: itemChooseUser,
                    itemCount: sharemessageController.userdatas.length,
                    separatorBuilder: (_, __) => const Divider(
                      height: 1,
                      color: Color(0xffeeeeee),
                    ),
                  ),
                ),
              ],
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
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.black45),
          elevation: 0.0,
          titleSpacing: 0.0,
          backgroundColor: Colors.white,
          title: const Text("Chia sẻ tin nhắn",
              style: TextStyle(
                color: Color(0xFF0186f8),
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              )),
          //systemOverlayStyle: SystemUiOverlayStyle.light,
          actions: <Widget>[
            IconButton(
              onPressed: () {
                sharemessageController.shareMessage(context);
              },
              icon: const Icon(Entypo.forward),
            ),
          ],
          centerTitle: true,
        ),
        body: Obx(
          () => sharemessageController.loading.value
              ? const InlineLoadding()
              : Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
                          child: Obx(() => widgetForm()),
                        ),
                      ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}
