import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:soe/utils/golbal/golbal.dart';
import 'package:soe/views/chat/controller/chatcontroller.dart';
import 'package:soe/views/chat/controller/message/infochatcontroller.dart';

class ItemMember extends StatelessWidget {
  final ChatController chatController = Get.put(ChatController());
  final InfoChatController infoController = Get.put(InfoChatController());

  final dynamic user;
  final int? index;
  ItemMember({Key? key, this.user, this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Map<DismissDirection, double> _dismissThresholds() {
      Map<DismissDirection, double> map = <DismissDirection, double>{};
      map.putIfAbsent(DismissDirection.horizontal, () => 0.5);
      return map;
    }

    return infoController.chat["chuNhom"] == true &&
            user["NhanSu_ID"] != Golbal.store.user["user_id"]
        ? Dismissible(
            key: Key(user["NhanSu_ID"].toString()),
            direction: DismissDirection.horizontal,
            onDismissed: (DismissDirection direction) {
              infoController.removeMember(user, context);
            },
            resizeDuration: null,
            dismissThresholds: _dismissThresholds(),
            background: Container(
              color: Colors.red,
              padding: const EdgeInsets.all(16.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.white),
                    onPressed: () {
                      infoController.removeMember(user, context);
                    },
                  ),
                  const Text(
                    "Xóa",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                ],
              ),
            ),
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
                            "${user["fullName"]} ${(user["chuNhom"] ?? false) ? "(Trưởng nhóm)" : ""}",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w500),
                          ),
                          const SizedBox(height: 8),
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
          )
        : Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
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
                          "${user["fullName"]} ${(user["chuNhom"] ?? false) ? "(Trưởng nhóm)" : ""}",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(height: 8),
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
          );
  }
}
