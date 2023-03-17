// ignore_for_file: unnecessary_null_comparison

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart' as fou;
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:soe/utils/golbal/golbal.dart';
import 'package:soe/views/component/use/avatar.dart';
import 'package:soe/views/request/comp/homerequest/detail/comment/commentrequestcontroller.dart';
import 'package:soe/views/request/comp/homerequest/detail/detailrequestcontroller.dart';
import 'inputcommentcontroller.dart';

class InputComment extends StatelessWidget {
  final InputCommentController controller = Get.put(InputCommentController());
  final CommentRequestController cmcontroller =
      Get.put(CommentRequestController());
  final DetailRequestController rqcontroller =
      Get.put(DetailRequestController());
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
                    )),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget listImage() {
    return Container(
      color: const Color(0xFFcccccc),
      constraints: const BoxConstraints(maxHeight: 300),
      child: ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: controller.images.value.length,
        itemBuilder: (ct, i) {
          XFile file = controller.images.value[i];
          return Card(
            elevation: 0,
            color: const Color(0xFFf5f5f5),
            child: ListTile(
              leading: Image(
                  image: AssetImage(
                      "assets/file/${file.name.split('.').last}.png"),
                  width: 24,
                  height: 24,
                  fit: BoxFit.contain),
              title: Text(file.name),
              trailing: SizedBox(
                width: 30,
                child: TextButton(
                    onPressed: () {
                      controller.deleteImage(i);
                    },
                    child: const Icon(
                      Ionicons.trash_outline,
                      color: Colors.black54,
                      size: 16,
                    )),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget renderFile(r) {
    if (r["files"] == null || r["files"].length == 0) {
      return Container(width: 0.0);
    }
    return ListView.builder(
      scrollDirection: Axis.vertical,
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: r["files"].length,
      itemBuilder: (c, i) => Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5.0),
            border: Border.all(color: const Color(0xFFeeeeee)),
            color: const Color(0xFFf9f9f9)),
        margin: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 5.0),
        padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
        child: InkWell(
            onTap: () {
              Golbal.loadFile(r["files"][i]["Duongdan"]);
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                InkWell(
                  onTap: () {
                    Golbal.loadFile(r["files"][i]["Duongdan"]);
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 5.0, horizontal: 5.0),
                    child: Image(
                        image: AssetImage(
                            "assets/file/${r["files"][i]["Dinhdang"].toString().replaceAll('.', '')}.png"),
                        width: 24,
                        height: 24,
                        fit: BoxFit.contain),
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 5.0),
                    child: Text(
                      "${r["files"][i]["Tenfile"]} (${Golbal.formatBytes(r["files"][i]["Dungluong"])})",
                      maxLines: 2,
                      textAlign: TextAlign.justify,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 12.0,
                        color: Colors.black87,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ),
              ],
            )),
      ),
    );
  }

  Widget quoteWidget(context) {
    return Card(
      elevation: 0,
      color: const Color(0xffdddddd),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            const Icon(Octicons.quote, color: Colors.black26, size: 16),
            Expanded(child: bindQuote(context, cmcontroller.quote)),
            Column(
              children: <Widget>[
                IconButton(
                  icon: const Icon(AntDesign.closecircle, color: Colors.white),
                  onPressed: () {
                    cmcontroller.clearQuote();
                  },
                ),
                const Align(
                  alignment: Alignment.bottomRight,
                  child: Icon(
                    Entypo.quote,
                    color: Colors.black26,
                    size: 16,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget bindQuote(context, quote) {
    Widget chatWg = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Container(
          margin: const EdgeInsets.only(bottom: 5.0),
          decoration: BoxDecoration(
            color: const Color(0xFFffffff),
            border: Border.all(color: const Color(0xFFf5f5f5), width: 0.5),
            borderRadius: const BorderRadius.all(Radius.circular(10.0)),
          ),
          padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Expanded(
                    child: Text(
                      quote["fullName"] ?? "",
                      style: const TextStyle(
                          fontWeight: FontWeight.w600, fontSize: 13.0),
                    ),
                  ),
                  const SizedBox(width: 5.0),
                  Text(
                    Golbal.timeAgo(quote["NgayTao"]),
                    style: const TextStyle(
                        color: Color(0xffaaaaaa), fontSize: 12.0),
                  ),
                ],
              ),
              const SizedBox(height: 2.0),
              if (quote["tenToChuc"] != null) ...[
                Text(
                  quote["tenToChuc"] ?? "",
                  style: const TextStyle(fontSize: 11.0, color: Colors.black54),
                )
              ],
              if (quote["Noidung"].toString().trim() != "") ...[
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 5.0),
                  child: Text(
                    quote["Noidung"] ?? "",
                    textAlign: TextAlign.justify,
                    style: const TextStyle(fontSize: 13.0),
                  ),
                )
              ],
              renderFile(quote),
            ],
          ),
        ),
      ],
    );
    return InkWell(
      onTap: () {
        cmcontroller.dismissKeybroad(context);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 5.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
              margin: const EdgeInsets.only(right: 10.0),
              child: UserAvarta(
                user: cmcontroller.quote,
                radius: 24,
              ),
            ),
            Expanded(child: chatWg),
          ],
        ),
      ),
    );
  }

  Widget inputWidget() {
    return Container(
      color: Colors.white,
      child: Row(
        children: <Widget>[
          // if (controller.showmoreFile.value) ...[

          // ] else ...[
          //   Stack(
          //     children: [
          //       Material(
          //         color: Colors.transparent,
          //         child: IconButton(
          //           onPressed: () {
          //             controller.showmoreFile.value = true;
          //           },
          //           icon: const Icon(
          //             Ionicons.add_circle_outline,
          //             color: Colors.black54,
          //           ),
          //         ),
          //       ),
          //       if (controller.files.value.isNotEmpty)
          //         Positioned(
          //           right: 0,
          //           child: CircleAvatar(
          //             child: Text(
          //               controller.files.value.length.toString(),
          //               style: const TextStyle(
          //                 color: Colors.white,
          //                 fontSize: 11,
          //               ),
          //             ),
          //             backgroundColor: Colors.red,
          //             radius: 8,
          //           ),
          //         ),
          //     ],
          //   ),
          // ],
          Material(
            color: Colors.transparent,
            child: IconButton(
              onPressed: () {
                controller.emojiShowing.value = !controller.emojiShowing.value;
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
                  icon: const Icon(Icons.attach_file_outlined,
                      color: Colors.black38),
                ),
              ),
              if (controller.files.value.isNotEmpty) ...[
                Positioned(
                  right: 0,
                  child: CircleAvatar(
                    child: Text(controller.files.value.length.toString(),
                        style:
                            const TextStyle(color: Colors.white, fontSize: 11)),
                    backgroundColor: Colors.red,
                    radius: 8,
                  ),
                ),
              ],
            ],
          ),
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
              onPressed: () {
                //controller.initMultiPickUp(mounted);
                controller.openFileImage();
              },
              icon: const Icon(
                EvilIcons.image,
                color: Colors.black38,
                size: 32,
              ),
            ),
          ),
          Material(
            color: Colors.transparent,
            child: IconButton(
              onPressed: () {
                controller.sendMessage();
              },
              icon: Icon(
                Icons.send,
                color: controller.isSend.value
                    ? const Color(0xFF0b72ff)
                    : Colors.black38,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buttonWidget(context) {
    double hh = 36 * Golbal.textScaleFactor;
    if (rqcontroller.request["IsTao"] == false &&
        rqcontroller.request["IsFun"] == false &&
        rqcontroller.request["IsXL"] == false) {
      return const SizedBox.shrink();
    }
    List<Widget> butons = [];
    if (rqcontroller.request["IsTao"] == true &&
        rqcontroller.request["Trangthai"] == 1 &&
        rqcontroller.request["IsFun"] == false) {
      butons.add(Expanded(
        child: ElevatedButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(
              Colors.orange,
            ),
          ),
          onPressed: () {
            rqcontroller.openSendRequest(context, "Thu hồi", 3);
          },
          child: const Text(
            "Thu hồi",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ));
    } else if (rqcontroller.request["IsXL"] == true &&
        rqcontroller.request["Trangthai"] == 2) {
      if (rqcontroller.request["TrangthaiXL"] == 0) {
        butons.add(const SizedBox(width: 10));
        butons.add(Expanded(
          child: ElevatedButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(
                Golbal.appColor,
              ),
            ),
            onPressed: () {
              rqcontroller.taojob();
            },
            child: const Text(
              "Tạo nhiệm vụ",
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ));
        butons.add(const SizedBox(width: 10));
        butons.add(Expanded(
          child: ElevatedButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(
                const Color(0xFF6dd230),
              ),
            ),
            onPressed: () {
              rqcontroller.openUpdateXLRequest(context, "Gửi đánh giá", 2);
            },
            child: const Text(
              "Gửi đánh giá",
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ));
        butons.add(const SizedBox(width: 10));
        butons.add(Expanded(
          child: ElevatedButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(
                Colors.red,
              ),
            ),
            onPressed: () {
              rqcontroller.openUpdateXLRequest(context, "Dừng xử lý", 4);
            },
            child: const Text(
              "Dừng xử lý",
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ));
      } else if (rqcontroller.request["TrangthaiXL"] == 4) {
        butons.add(const SizedBox(width: 10));
        butons.add(Expanded(
          child: ElevatedButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(
                Golbal.appColor,
              ),
            ),
            onPressed: () {
              rqcontroller.taojob();
            },
            child: const Text(
              "Tạo nhiệm vụ",
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ));
        butons.add(const SizedBox(width: 10));
        butons.add(Expanded(
          child: ElevatedButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(
                const Color(0xFF6dd230),
              ),
            ),
            onPressed: () {
              rqcontroller.openUpdateXLRequest(context, "Xử lý tiếp", 1);
            },
            child: const Text(
              "Xử lý tiếp",
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ));
      } else {
        if (rqcontroller.request["TrangthaiXL"] != 2) {
          butons.add(const SizedBox(width: 10));
          butons.add(Expanded(
            child: ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                  Golbal.appColor,
                ),
              ),
              onPressed: () {
                rqcontroller.taojob();
              },
              child: const Text(
                "Tạo nhiệm vụ",
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ));
          butons.add(const SizedBox(width: 10));
          butons.add(Expanded(
            child: ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                  const Color(0xFF6dd230),
                ),
              ),
              onPressed: () {
                rqcontroller.openUpdateXLRequest(context, "Gửi đánh giá", 2);
              },
              child: const Text(
                "Gửi đánh giá",
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ));
          butons.add(const SizedBox(width: 10));
          butons.add(Expanded(
            child: ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                  Colors.red,
                ),
              ),
              onPressed: () {
                rqcontroller.openUpdateXLRequest(context, "Dừng xử lý", 4);
              },
              child: const Text(
                "Dừng xử lý",
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ));
        } else if (rqcontroller.request["TrangthaiXL"] != 3 &&
            rqcontroller.request["IsTao"] == true) {
          butons.add(Expanded(
            child: ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                  const Color(0xFF6dd230),
                ),
              ),
              onPressed: () {
                rqcontroller.openUpdateXLRequest(context, "Đánh giá đề xuất", 2,
                    IsDG: true);
              },
              child: const Text(
                "Đánh giá đề xuất",
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ));
        }
      }
    } else if (rqcontroller.request["TrangthaiXL"] != 3 &&
        rqcontroller.request["Trangthai"] == 2 &&
        rqcontroller.request["IsTao"] == true) {
      butons.add(Expanded(
        child: ElevatedButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(
              const Color(0xFF6dd230),
            ),
          ),
          onPressed: () {
            rqcontroller.openUpdateXLRequest(context, "Đánh giá đề xuất", 2,
                IsDG: true);
          },
          child: const Text(
            "Đánh giá đề xuất",
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ));
    } else if (rqcontroller.request["IsTao"] == true &&
        rqcontroller.request["IsFun"] == true) {
      butons.add(const SizedBox(width: 10));
      butons.add(Expanded(
        child: ElevatedButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(
              const Color(0xFF2196f3),
            ),
          ),
          onPressed: () {
            rqcontroller.openSendRequest(context, "Gửi", null);
          },
          child: const Text(
            "Gửi",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ));
      butons.add(const SizedBox(width: 10));
      if (rqcontroller.request["Trangthai"] > 0) {
        butons.add(Expanded(
          child: ElevatedButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(
                Colors.orange,
              ),
            ),
            onPressed: () {
              rqcontroller.cancelRequest(context);
            },
            child: Text(
              rqcontroller.request["Trangthai"] == -1 ? "Bỏ huỷ" : "Huỷ",
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ));
      }
      butons.add(const SizedBox(width: 10));
      butons.add(Expanded(
        child: ElevatedButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(
              Colors.red,
            ),
          ),
          onPressed: () {
            rqcontroller.deleteRequest(context);
          },
          child: const Text(
            "Xoá",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ));
    } else if (!rqcontroller.request["IsTao"] == true &&
        rqcontroller.request["Trangthai"] == 1 &&
        rqcontroller.request["IsFun"] == true) {
      butons.add(const SizedBox(width: 10));
      butons.add(Expanded(
        child: ElevatedButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(
              const Color(0xFF2196f3),
            ),
          ),
          onPressed: () {
            rqcontroller.openSendRequest(context, "Chấp thuận", 1);
          },
          child: const Text(
            "Chấp thuận",
            maxLines: 1,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ));
      butons.add(const SizedBox(width: 10));
      butons.add(Expanded(
        child: ElevatedButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(
              const Color(0xFFf44336),
            ),
          ),
          onPressed: () {
            rqcontroller.openSendRequest(context, "Từ chối", -1);
          },
          child: const Text(
            "Từ chối",
            maxLines: 1,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ));
      if (rqcontroller.request["soky"] - rqcontroller.request["daky"] != 1) {
        butons.add(const SizedBox(width: 10));
        butons.add(Expanded(
          child: ElevatedButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(
                const Color(0xFF4caf50),
              ),
            ),
            onPressed: () {
              rqcontroller.openSendRequest(context, "Chuyển tiếp", 2);
            },
            child: const Text(
              "Chuyển tiếp",
              maxLines: 1,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ));
      }
    }
    return Container(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: butons,
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFffffff),
      child: SafeArea(
        child: Obx(
          () => Column(
            children: [
              if (controller.images.value.isNotEmpty) ...[
                Obx(() => listImage()),
              ],
              if (controller.files.value.isNotEmpty) ...[
                Obx(() => listFile()),
              ],
              if (cmcontroller.quote.isNotEmpty) ...[
                Obx(() => quoteWidget(context)),
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
              Obx(() => buttonWidget(context)),
            ],
          ),
        ),
      ),
    );
  }
}
