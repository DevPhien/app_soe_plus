import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:soe/utils/golbal/golbal.dart';
import 'package:soe/views/chat/controller/chatcontroller.dart';
import 'package:soe/views/chat/controller/phonebook/phonebookcontroller.dart';

class UserLeader extends StatelessWidget {
  final ChatController chatController = Get.put(ChatController());
  final PhoneBookController controller = Get.put(PhoneBookController());

  UserLeader({Key? key}) : super(key: key);

  Widget itemUserLeaders(context, i) {
    var item = controller.userleader_datas[i];
    return Container(
      padding: const EdgeInsets.all(0),
      width: 85 * Golbal.textScaleFactor,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            chatController.goChat(item, true);
          },
          child: Stack(
            alignment: Alignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    chatController.renderAvarta(item, i, null, null),
                    const SizedBox(height: 5.0),
                    Text(
                      "${item["fullName"]}",
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget widgetUserLeaders() {
    return Obx(
      () => controller.userleader_datas.isNotEmpty
          ? SizedBox(
              width: double.infinity,
              height: 90,
              child: ListView.builder(
                  itemBuilder: itemUserLeaders,
                  physics: const BouncingScrollPhysics(),
                  itemCount: controller.userleader_datas.length,
                  padding: const EdgeInsets.only(top: 0, bottom: 0, left: 0),
                  scrollDirection: Axis.horizontal))
          : Container(
              height: 0,
            ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Ban lãnh đạo",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          widgetUserLeaders(),
          const Divider(height: 1),
        ],
      ),
    );
  }
}
