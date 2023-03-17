import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/chatcontroller.dart';

class ItemChat extends StatelessWidget {
  final dynamic chat;
  final int? index;
  final ChatController chatController = Get.put(ChatController());

  ItemChat({Key? key, this.chat, this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        chatController.goChat(chat, false);
      },
      onLongPress: () {
        chatController.popGroupActionChat(context, chat);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Row(
          children: [
            //thumbContaint(chat),
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
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Opacity(
                  opacity: 0.64,
                  child: Text(chat["ngayGui"]),
                ),
                if (chat["chuaDoc"] != null && chat["chuaDoc"] > 0)
                  CircleAvatar(
                      radius: 10.0,
                      backgroundColor: Colors.red,
                      child: Text(
                        "${chat["chuaDoc"]}",
                        style: const TextStyle(
                          fontSize: 11.0,
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                      ))
              ],
            ),
          ],
        ),
      ),
    );
  }
}
