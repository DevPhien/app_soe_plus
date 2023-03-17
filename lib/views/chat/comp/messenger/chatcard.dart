import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:soe/views/chat/comp/itemchat.dart';
import 'package:soe/views/chat/controller/messenger/chatcardcontroller.dart';
import 'package:soe/views/component/use/inlineloadding.dart';

class ChatCard extends StatelessWidget {
  final ChatCardController chatcardController = Get.put(ChatCardController());

  Widget itemChatCard(context, i) =>
      ItemChat(chat: chatcardController.datas[i], index: i);

  ChatCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => !chatcardController.loading.value &&
              chatcardController.datas.isNotEmpty
          ? ListView.separated(
              shrinkWrap: true,
              padding: const EdgeInsets.all(0),
              physics: const BouncingScrollPhysics(),
              itemBuilder: itemChatCard,
              itemCount: chatcardController.datas.length,
              separatorBuilder: (_, __) => const Divider(
                height: 1,
                color: Color(0xffeeeeee),
              ),
            )
          : !chatcardController.loading.value
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Center(
                      child: Image.asset("assets/nochat.png"),
                    ),
                    const SizedBox(height: 10.0),
                    const Text(
                      "Hiện chưa có cuộc hội thoại nào",
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
