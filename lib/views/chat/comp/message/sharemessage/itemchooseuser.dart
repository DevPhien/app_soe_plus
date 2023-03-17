import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:soe/views/chat/controller/chatcontroller.dart';
import 'package:soe/views/chat/controller/message/sharemessagecontroller.dart';

class ItemChooseUser extends StatelessWidget {
  final ShareMessageController sharemessageController =
      Get.put(ShareMessageController());
  final ChatController chatController = Get.put(ChatController());
  final dynamic user;
  final Function onChecked;
  final int? index;

  ItemChooseUser({
    Key? key,
    this.user,
    required this.onChecked,
    this.index,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      onTap: () {
        if (user["isChecked"] == null) {
          user["isChecked"] = false;
        }
        user["isChecked"] = !(user["isChecked"] || false);
        onChecked(user, user["isChecked"]);
      },
      title: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
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
          ],
        ),
      ),
      trailing: Checkbox(
        tristate: false,
        activeColor: const Color(0xFF6dd230),
        value: user["isChecked"] ?? false,
        onChanged: (v) {
          onChecked(user, v);
        },
      ),
    );
  }
}
