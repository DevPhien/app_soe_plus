import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart' as fou;
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:soe/utils/golbal/golbal.dart';
import 'inputcommentcontroller.dart';

class InputComment extends StatelessWidget {
  final InputCommentController controller = Get.put(InputCommentController());
  InputComment({Key? key}) : super(key: key);

  Widget listFile() {
    return Container(
      color: const Color(0xFFcccccc),
      constraints: const BoxConstraints(maxHeight: 300),
      child: ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: controller.files.value.length,
        itemBuilder: (ct, i) {
          PlatformFile file = controller.files.value[i];
          return Card(
            elevation: 0,
            color: const Color(0xFFf5f5f5),
            child: ListTile(
              leading: Image(
                  image: AssetImage(
                      "assets/file/${file.extension!.replaceAll('.', '')}.png"),
                  width: 24,
                  height: 24,
                  fit: BoxFit.contain),
              title: Text(file.name),
              trailing: SizedBox(
                width: 30,
                child: TextButton(
                  onPressed: () {
                    controller.deleteFile(i);
                  },
                  child: const Icon(
                    Ionicons.trash_outline,
                    color: Colors.black54,
                    size: 16,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget inputWidget() {
    return Container(
      color: Colors.white,
      child: Row(
        children: [
          if (controller.showmoreFile.value) ...[
            Material(
              color: Colors.transparent,
              child: IconButton(
                onPressed: () {
                  controller.emojiShowing.value =
                      !controller.emojiShowing.value;
                },
                icon: Icon(
                  SimpleLineIcons.emotsmile,
                  color: controller.emojiShowing.value
                      ? Golbal.appColor
                      : Colors.black38,
                ),
              ),
            ),
            Stack(
              children: [
                Material(
                  color: Colors.transparent,
                  child: IconButton(
                    onPressed: controller.openFile,
                    icon: const Icon(
                      Icons.attach_file_outlined,
                      color: Colors.black54,
                    ),
                  ),
                ),
                if (controller.files.value.isNotEmpty)
                  Positioned(
                    right: 0,
                    child: CircleAvatar(
                      child: Text(controller.files.value.length.toString(),
                          style: const TextStyle(
                              color: Colors.white, fontSize: 11)),
                      backgroundColor: Colors.red,
                      radius: 8,
                    ),
                  )
              ],
            ),
          ],
          if (!controller.showmoreFile.value) ...[
            Stack(
              children: [
                Material(
                  color: Colors.transparent,
                  child: IconButton(
                    onPressed: () {
                      controller.showmoreFile.value = true;
                    },
                    icon: const Icon(
                      Ionicons.add_circle_outline,
                      color: Colors.black54,
                    ),
                  ),
                ),
                if (controller.files.value.isNotEmpty) ...[
                  Positioned(
                    right: 0,
                    child: CircleAvatar(
                      child: Text(controller.files.value.length.toString(),
                          style: const TextStyle(
                              color: Colors.white, fontSize: 11)),
                      backgroundColor: Colors.red,
                      radius: 8,
                    ),
                  ),
                ],
              ],
            ),
          ],
          Expanded(
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxHeight: 250.0,
              ),
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                reverse: true,
                child: TextField(
                  controller: controller.textcontroller,
                  keyboardAppearance: Brightness.light,
                  textInputAction: TextInputAction.newline,
                  //focusNode: controller.focus,
                  maxLines: null,
                  onChanged: (String txt) {
                    controller.changeInput(txt);
                  },
                  style: const TextStyle(color: Colors.black87),
                  onSubmitted: (String txt) {
                    controller.sendMessage();
                  },
                  decoration: const InputDecoration(
                    isDense: true,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(40.0)),
                      borderSide: BorderSide(color: Color(0xFFdddddd)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(40.0)),
                      borderSide: BorderSide(color: Color(0xFFdddddd)),
                    ),
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
                    hintText: 'Nội dung bình luận',
                    hintStyle: TextStyle(fontSize: 13.0),
                  ),
                ),
              ),
            ),
          ),
          Material(
            color: Colors.transparent,
            child: IconButton(
              onPressed: controller.openFileImage,
              icon: const Icon(
                EvilIcons.image,
                color: Colors.black54,
                size: 32,
              ),
            ),
          ),
          Material(
            color: Colors.transparent,
            child: IconButton(
                onPressed: controller.sendMessage,
                icon: Icon(
                  Icons.send,
                  color: controller.isSend.value
                      ? Golbal.appColor
                      : Colors.black38,
                )),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFffffff),
      child: SafeArea(
        child: Obx(
          () => Column(
            children: [
              if (controller.files.value.isNotEmpty) ...[
                Obx(() => listFile()),
              ],
              const Divider(height: 1),
              Obx(() => inputWidget()),
              Offstage(
                offstage: !controller.emojiShowing.value,
                child: SizedBox(
                  height: 250,
                  child: EmojiPicker(
                    onEmojiSelected: (Category? category, Emoji emoji) {
                      controller.onEmojiSelected(emoji);
                    },
                    onBackspacePressed: controller.onBackspacePressed,
                    config: Config(
                      columns: 9,
                      // Issue: https://github.com/flutter/flutter/issues/28894
                      emojiSizeMax: 24 *
                          (fou.defaultTargetPlatform == TargetPlatform.iOS
                              ? 1.30
                              : 1.0),
                      verticalSpacing: 0,
                      horizontalSpacing: 0,
                      gridPadding: EdgeInsets.zero,
                      initCategory: Category.RECENT,
                      bgColor: const Color(0xFFF2F2F2),
                      indicatorColor: Colors.blue,
                      iconColor: Colors.grey,
                      iconColorSelected: Colors.blue,
                      //progressIndicatorColor: Colors.blue,
                      backspaceColor: Colors.blue,
                      skinToneDialogBgColor: Colors.white,
                      skinToneIndicatorColor: Colors.grey,
                      enableSkinTones: true,
                      showRecentsTab: true,
                      recentsLimit: 28,
                      replaceEmojiOnLimitExceed: false,
                      noRecents: const Text(
                        'No Recents',
                        style: TextStyle(fontSize: 20, color: Colors.black26),
                        textAlign: TextAlign.center,
                      ),
                      tabIndicatorAnimDuration: kTabScrollDuration,
                      categoryIcons: const CategoryIcons(),
                      buttonMode: ButtonMode.MATERIAL,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
