import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';

import '../controller/chitietvanbancontroller.dart';

class ItemButton extends StatelessWidget {
  final dynamic vanban;
  final List<String> buttonkey;
  const ItemButton({Key? key, this.vanban, required this.buttonkey})
      : super(key: key);
  //Function
  @override
  Widget build(BuildContext context) {
    final ChitietVanbanController controller =
        Get.put(ChitietVanbanController());
    List buttons = [
      {
        "key": "1",
        "title": "Trình phê duyệt",
        "icon": FontAwesome.share_square_o,
      },
      {
        "key": "2",
        "title": "Duyệt chuyển tiếp",
        "icon": Feather.user_check,
      },
      {
        "key": "3",
        "title": "Duyệt phát hành",
        "icon": MaterialCommunityIcons.clipboard_check_outline,
      },
      {
        "key": "4",
        "title": "Chuyển cá nhân",
        "icon": Feather.user_check,
      },
      {
        "key": "8",
        "title": "Chuyển đóng dấu",
        "icon": MaterialCommunityIcons.email_send_outline,
      },
      {
        "key": "9",
        "title": "Phân phát",
        "icon": FontAwesome.send_o,
      },
      {
        "key": "9.1",
        "title": "Phân phát",
        "icon": FontAwesome.send_o,
      },
      {
        "key": "10",
        "title": "Xác nhận hoàn thành",
        "icon": MaterialCommunityIcons.account_edit_outline,
      },
      {
        "key": "11",
        "title": "Xác nhận",
        "icon": Feather.check_circle,
      },
      {
        "key": "12",
        "title": "Trả lại",
        "icon": SimpleLineIcons.action_undo,
      },
      {
        "key": "13",
        "title": "Chuyển đóng dấu/vào sổ",
        "icon": Feather.arrow_right_circle,
      },
      // {
      //   "key": "5",
      //   "title": "Chuyển theo quy trình",
      //   "icon": Ionicons.ios_git_network_outline,
      // },
      {
        "key": "6",
        "title": "Duyệt theo quy trình",
        "icon": FontAwesome.check_circle,
      },
      {
        "key": "14",
        "title": "Liên kết công việc",
        "icon": SimpleLineIcons.tag,
      },
      {
        "key": "15",
        "title": "Copy vào Mybox",
        "icon": SimpleLineIcons.social_dropbox,
      },
      {
        "key": "16",
        "title": "Link vào Mybox",
        "icon": Feather.link,
      },
      {
        "key": "17",
        "title": "Xoá",
        "icon": Ionicons.trash_outline,
      },
      {
        "key": "18",
        "title": "Thu hồi",
        "icon": Ionicons.refresh,
      },
    ]
        .where(
            (element) => buttonkey.indexWhere((b) => b == element["key"]) != -1)
        .toList();
    int maxlen = buttons.length > 3 ? 3 : buttons.length;
    List<Widget> butWidget = [];
    if (buttonkey.contains("9.1")) {
      int idx = buttons.indexWhere((element) => element["key"] == "9");
      if (idx != -1) {
        buttons.removeAt(idx);
      }
    }
    for (var but in buttons.take(maxlen)) {
      butWidget.add(TextButton(
          onPressed: () {
            controller.clickButtonVanban(but["key"]);
          },
          child: Column(
            children: [
              Expanded(
                  child: Icon(
                but["icon"],
                color: Colors.black54,
              )),
              const SizedBox(height: 5),
              Text(but["title"], style: const TextStyle(color: Colors.black54))
            ],
          )));
    }
    var otherButtons = buttons.skip(maxlen).toList();
    return Container(
      padding: const EdgeInsets.all(5),
      height: 70,
      width: double.infinity,
      child: Row(
        children: [
          Expanded(
              child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemBuilder: (ct, i) => butWidget[i],
            itemCount: butWidget.length,
          )),
          if (otherButtons.isNotEmpty) const SizedBox(width: 5.0),
          if (otherButtons.isNotEmpty)
            TextButton(
                onPressed: () => {controller.showMoreButton(otherButtons)},
                child: Column(
                  children: const [
                    Expanded(
                        child: Icon(
                      Ionicons.ellipsis_horizontal,
                      color: Colors.black54,
                    )),
                    SizedBox(height: 5),
                    Text(
                      "Khác",
                      style: TextStyle(color: Colors.black54),
                    )
                  ],
                ))
        ],
      ),
    );
  }
}
