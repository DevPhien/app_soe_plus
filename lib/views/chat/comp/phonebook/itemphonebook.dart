import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:soe/views/chat/controller/chatcontroller.dart';
import 'package:soe/views/chat/controller/phonebook/phonebookcontroller.dart';

class ItemPhoneBook extends StatelessWidget {
  final ChatController chatController = Get.put(ChatController());
  final PhoneBookController phonbookController = Get.put(PhoneBookController());

  final dynamic user;
  final int? index;
  ItemPhoneBook({Key? key, this.user, this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        //chatController.goChat(user, true);
        phonbookController.goInfoChat(user);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: Row(
          children: [
            chatController.renderAvarta(user, index, null, null),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user["fullName"],
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 5),
                    Opacity(
                      opacity: 0.64,
                      child: Text(
                        "${(user['phone'] ?? '')}",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Opacity(
                      opacity: 0.64,
                      child: Text(
                        "${(user['tenChucVu'] ?? '')}",
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Opacity(
              opacity: 0.5,
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {
                      phonbookController.callPhone(user);
                    },
                    icon: const Icon(Feather.phone),
                    iconSize: 20,
                  ),
                  IconButton(
                    onPressed: () {
                      chatController.goChat(user, true);
                    },
                    icon: const Icon(Feather.message_circle),
                    iconSize: 20,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
