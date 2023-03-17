import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:soe/views/chat/comp/itemchat.dart';
import 'package:soe/views/chat/controller/chatgroup/chatgroupcontroller.dart';
import 'package:soe/views/component/use/inlineloadding.dart';

class ChatGroupCard extends StatelessWidget {
  final ChatGroupController chatgroupcardController =
      Get.put(ChatGroupController());
  Widget itemChatCard(context, i) =>
      ItemChat(chat: chatgroupcardController.datas[i]);

  ChatGroupCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => !chatgroupcardController.loading.value &&
              chatgroupcardController.datas.isNotEmpty
          ? ListView.separated(
              shrinkWrap: true,
              padding: const EdgeInsets.all(0),
              physics: const BouncingScrollPhysics(),
              itemBuilder: itemChatCard,
              itemCount: chatgroupcardController.datas.length,
              separatorBuilder: (_, __) => const Divider(
                height: 1,
                color: Color(0xffeeeeee),
              ),
            )
          : !chatgroupcardController.loading.value
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Center(
                      child: Image.asset("assets/nochat.png"),
                    ),
                    const SizedBox(height: 10.0),
                    const Text(
                      "Hiện chưa có cuộc thoại nào",
                      style: TextStyle(
                        color: Colors.black45,
                      ),
                    ),
                  ],
                )
              : const InlineLoadding(),
    );
  }
}
