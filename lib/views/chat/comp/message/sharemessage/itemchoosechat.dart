import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:soe/views/chat/controller/chatcontroller.dart';
import 'package:soe/views/chat/controller/message/sharemessagecontroller.dart';

class ItemChooseChat extends StatelessWidget {
  final ShareMessageController sharemessageController =
      Get.put(ShareMessageController());
  final ChatController chatController = Get.put(ChatController());
  final dynamic chat;
  final Function onChecked;
  final int? index;

  ItemChooseChat({
    Key? key,
    this.chat,
    required this.onChecked,
    this.index,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      onTap: () {
        if (chat["isChecked"] == null) {
          chat["isChecked"] = false;
        }
        chat["isChecked"] = !(chat["isChecked"] || false);
        onChecked(chat, chat["isChecked"]);
      },
      title: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            chatController.renderAvarta(chat, index, null, null),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      chat["chatName"] ?? "",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 8),
                    Opacity(
                      opacity: (chat["chuaDoc"] != null && chat["chuaDoc"] > 0)
                          ? 1
                          : 0.64,
                      child: Text(
                        chat["desnoiDung"] ?? "",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      trailing: Checkbox(
        tristate: false,
        activeColor: const Color(0xFF6dd230),
        value: chat["isChecked"] ?? false,
        onChanged: (v) {
          onChecked(chat, v);
        },
      ),
    );
  }
}
