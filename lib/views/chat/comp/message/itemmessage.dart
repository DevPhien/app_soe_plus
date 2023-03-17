// ignore_for_file: deprecated_member_use

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:soe/utils/golbal/golbal.dart';
import 'package:soe/views/chat/comp/message/audiomessage.dart';
import 'package:soe/views/chat/comp/message/notifymessage.dart';
import 'package:soe/views/chat/controller/chatcontroller.dart';
import 'package:soe/views/chat/controller/message/messagecontroller.dart';
import 'package:flutter_reaction_button/flutter_reaction_button.dart';

import 'filemessage.dart';
import 'imagemessage.dart';
import 'textmessage.dart';
import 'videomessage.dart';

class ItemMessage extends StatelessWidget {
  final MessageController messageController = Get.put(MessageController());
  final ChatController chatController = Get.put(ChatController());

  final dynamic message;
  final int? index;
  ItemMessage({Key? key, this.message, this.index}) : super(key: key);

  Widget messageContent(message) {
    switch (message["loai"]) {
      case 0: //text
        return TextMessage(message: message);
      case 1: //image
        return ImageMessage(message: message);
      case 2: //file
        return FileMessage(message: message);
      case 3: //video
        return VideoMessage(message: message);
      case 4: //audio
        return AudioMessage(message: message);
      default:
        return const SizedBox();
    }
  }

  Widget messageParent(message) {
    if (message["ParentID"] == null ||
        message["ParentID"] == "" ||
        message["ParentComment"] == null) {
      return Container(
        width: 0.0,
      );
    }
    dynamic parentComment = message["ParentComment"];
    return Container(
      constraints: BoxConstraints(
        maxWidth: Golbal.screenSize.width - 80.0,
      ),
      margin: const EdgeInsets.only(bottom: 5.0),
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(width: 1.5, color: Colors.black.withOpacity(0.2)),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Transform.rotate(
            angle: 180 * pi / 180,
            child: Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: Icon(
                Entypo.quote,
                color: Colors.black.withOpacity(0.5),
                size: 16,
              ),
            ),
          ),
          Flexible(
            child: Container(
              constraints: const BoxConstraints(
                maxHeight: 100,
              ),
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    messageContent(parentComment),
                    const SizedBox(height: 2.0),
                    Text(
                      "${parentComment["fullName"] ?? ""}, ${parentComment["ngayGui"] ?? ""}",
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.black.withOpacity(0.5),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Color bgColor = Colors.transparent;
    switch (message["loai"]) {
      case 0: //text
        bgColor =
            message["IsMe"] ? const Color(0xFFdbf4fe) : const Color(0xFFf2f6f9);
        break;
      default:
        bgColor = Colors.transparent;
        break;
    }

    return message["loai"] == 5
        ? NotifyMessage(message: message)
        : Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: message["IsMe"]
                ? MainAxisAlignment.end
                : MainAxisAlignment.start,
            children: [
              if (message["sdate"])
                Container(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      const Expanded(
                        child: Divider(thickness: .5),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10.0,
                          vertical: 3.0,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.2),
                          borderRadius: const BorderRadius.all(
                            Radius.circular(20.0),
                          ),
                        ),
                        child: Text(
                          "${message["startdate"] ?? ""}",
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      const Expanded(
                        child: Divider(thickness: .5),
                      ),
                    ],
                  ),
                ),
              InkWell(
                onTap: () {
                  messageController.dismissKeybroad(context);
                },
                onLongPress: () {
                  messageController.popGroupActionMessage(context, message);
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10.0, vertical: 5.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: message["IsMe"]
                        ? MainAxisAlignment.end
                        : MainAxisAlignment.start,
                    children: <Widget>[
                      if (message["IsMe"] != true)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 5.0),
                          child: SizedBox(
                            width: 48,
                            height: 48,
                            child: message["showImage"]
                                ? chatController.renderAvarta(
                                    message, index, null, null)
                                : null,
                          ),
                        ),
                      Stack(
                        children: [
                          Container(
                            constraints: BoxConstraints(
                                maxWidth: Golbal.screenSize.width - 80.0),
                            child: Container(
                              decoration: BoxDecoration(
                                  color: bgColor,
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(10.0),
                                  )),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10.0, vertical: 5.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: message["IsMe"]
                                    ? CrossAxisAlignment.end
                                    : CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  message["showImage"]
                                      ? Text(
                                          message["fullName"] ?? "",
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold),
                                        )
                                      : Container(
                                          width: 0.0,
                                        ),
                                  messageParent(message),
                                  messageContent(message),
                                  const SizedBox(
                                    height: 2.0,
                                  ),
                                  Text(
                                    "${message["ngayGui"] ?? ''}",
                                    textAlign: TextAlign.right,
                                    style: const TextStyle(
                                      color: Colors.black45,
                                      fontSize: 10.0,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            padding: (message["IsMe"] != true ||
                                    (message["StickID"] != null &&
                                        message["StickID"] != 0))
                                ? const EdgeInsets.only(bottom: 15.0)
                                : const EdgeInsets.only(bottom: 0.0),
                          ),
                          if (message["IsMe"])
                            Positioned(
                                left: 0.0,
                                bottom: -5.0,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: ReactionButton(
                                    onReactionChanged: (id) {},
                                    reactions:
                                        messageController.facebookReactionsNull,
                                    initialReaction: messageController
                                        .facebookReactions
                                        .firstWhere(
                                      (e) =>
                                          e.id.toString() ==
                                          (message["StickID"] ?? 0).toString(),
                                      orElse: () => Reaction(
                                        id: 0,
                                        value: 0,
                                        icon: const Text(""),
                                      ),
                                    ),
                                  ),
                                ))
                          else
                            Positioned(
                              right: 0.0,
                              bottom: -5.0,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ReactionButton(
                                  onReactionChanged: (id) {
                                    messageController.updateStickByMessage(
                                        message, id.toString());
                                  },
                                  reactions:
                                      messageController.facebookReactions,
                                  initialReaction: messageController
                                      .facebookReactions
                                      .firstWhere(
                                    (e) =>
                                        e.id.toString() ==
                                        (message["StickID"] ?? 0).toString(),
                                    orElse: () => Reaction(
                                      id: 0,
                                      value: 0,
                                      icon: const Card(
                                        elevation: 4.0,
                                        shape: CircleBorder(),
                                        clipBehavior: Clip.antiAlias,
                                        child: CircleAvatar(
                                          backgroundColor: Color(0xffffffff),
                                          radius: 12,
                                          child: Icon(
                                            EvilIcons.like,
                                            color: Colors.black26,
                                            size: 20,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
  }
}
