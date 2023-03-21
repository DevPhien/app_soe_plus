import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:soe/views/chat/controller/chatcontroller.dart';
import 'package:soe/views/chat/controller/favorites/favoritescontroller.dart';

class ItemFavorites extends StatelessWidget {
  final ChatController chatController = Get.put(ChatController());
  final FavoritesController controller = Get.put(FavoritesController());

  final dynamic user;
  final int? index;
  ItemFavorites({Key? key, this.user, this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Map<DismissDirection, double> _dismissThresholds() {
      Map<DismissDirection, double> map = <DismissDirection, double>{};
      map.putIfAbsent(DismissDirection.horizontal, () => 0.5);
      return map;
    }

    return Dismissible(
      key: Key(user["NhanSu_ID"].toString()),
      direction: DismissDirection.horizontal,
      onDismissed: (DismissDirection direction) {
        controller.removeFavorites(user);
      },
      resizeDuration: null,
      dismissThresholds: _dismissThresholds(),
      background: Container(
        color: Colors.red,
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            const Expanded(
              child: Text(''),
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.white),
              onPressed: () {
                controller.removeFavorites(user);
              },
            ),
          ],
        ),
      ),
      child: InkWell(
        onTap: () {
          //chatController.goChat(user, true);
          controller.goInfoUser(user);
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
                opacity: 0.64,
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        chatController.goChat(user, true);
                      },
                      icon: const Icon(Feather.message_circle),
                      iconSize: 20,
                    ),
                    IconButton(
                      onPressed: () {
                        chatController.callPhoneFavorites(user);
                      },
                      icon: const Icon(Feather.phone),
                      iconSize: 20,
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
