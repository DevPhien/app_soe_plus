// ignore_for_file: prefer_typing_uninitialized_variables, unnecessary_null_comparison, invalid_use_of_protected_member

import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';
import 'package:soe/plugin/emoji_picker/emoji_picker.dart';
import 'package:soe/utils/golbal/golbal.dart';
import 'package:soe/views/chat/comp/message/audiomessage.dart';
import 'package:soe/views/chat/comp/message/filemessage.dart';
import 'package:soe/views/chat/comp/message/imagemessage.dart';
import 'package:soe/views/chat/comp/message/textmessage.dart';
import 'package:soe/views/chat/comp/message/videomessage.dart';
import 'package:soe/views/chat/controller/chatcontroller.dart';
import 'package:soe/views/chat/controller/message/messagecontroller.dart';
import 'package:rxdart/rxdart.dart';
import 'package:soe/views/component/use/inlineloadding.dart';

import 'itemmessage.dart';

class Message extends StatefulWidget {
  const Message({Key? key}) : super(key: key);

  @override
  State<Message> createState() => _MessageState();
}

class _MessageState extends State<Message>
    with WidgetsBindingObserver, TickerProviderStateMixin {
  final ChatController chatController = Get.put(ChatController());
  final MessageController messageController = Get.put(MessageController());
  final StreamController<String> _streamController = StreamController();

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    _streamController.stream
        .debounceTime(const Duration(milliseconds: 400))
        .listen((s) => onTyping(s));
    super.initState();
    initSocket();
    chatController.openDetail.value = true;
    messageController.page.value = 1;
    messageController.pagex.value = 1;
    messageController.perpage.value = 50;
    messageController.perpagex.value = 50;
    messageController.initMessage();
    messageController.focus.addListener(_onFocusChange);
    messageController.scrollController.addListener(scrollListener);
  }

  void initSocket() {
    if (messageController.chat["ChatID"] != null) {
      Golbal.socket.on(
          'typing', (data) => messageController.initSocketDataMessage(data));
      Golbal.socket.on('getSendMessage',
          (data) => messageController.initSocketDataMessage(data));
      Golbal.socket.on('getEditMessage',
          (data) => messageController.initSocketDataMessage(data));
      Golbal.socket.on('getDelMessage',
          (data) => messageController.initSocketDataMessage(data));
      Golbal.socket.on(
          'getStick', (data) => messageController.initSocketDataMessage(data));
    }
  }

  void scrollListener() {
    if (!messageController.loading.value) {
      if (messageController.scrollController.position.pixels < -100 &&
          messageController.perpage.value <
              messageController.count_message.value) {
        messageController.loading.value = true;
        messageController.perpage.value = messageController.perpagex.value *
            (messageController.pagex.value += 1);
        Future.delayed(const Duration(milliseconds: 500), () {
          messageController.loadMessage(false);
        });
      }
    }
  }

  Future<void> _keyboardToggled() async {
    if (mounted) {
      EdgeInsets edgeInsets = MediaQuery.of(context).viewInsets;
      while (mounted && MediaQuery.of(context).viewInsets == edgeInsets) {
        await Future.delayed(const Duration(milliseconds: 10));
      }
    }
    return;
  }

  Future<void> _onFocusChange() async {
    await Future.any([
      Future.delayed(const Duration(milliseconds: 300)),
      _keyboardToggled(),
    ]);
    if (messageController.focus.hasFocus &&
        messageController.scrollController != null) {
      messageController.scroolBottom();
    }
  }

  void onTyping(s) {
    if (messageController.controllers.text.isEmpty ||
        messageController.controllers.text.length > 2) {
      messageController.typing.value = false;
      var u = {
        "user_id": Golbal.store.user["user_id"],
        "nguoiGui": Golbal.store.user["user_id"],
        "FullName": Golbal.store.user["FullName"],
        "fname": Golbal.store.user["fname"],
        "Avartar": Golbal.store.user["Avartar"],
        "ChatID": messageController.chat["ChatID"],
        "typing": false,
        "event": "typing",
        "socketid": Golbal.socket.id,
      };
      Golbal.socket.emit('sendData', u);
    } else {
      messageController.streamTypeController.add(false);
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    messageController.focus.removeListener(_onFocusChange);
    _streamController.close();
    messageController.streamTypeController.close();
    messageController.scrollController.removeListener(scrollListener);
    //messageController.scrollController.dispose();
    chatController.openDetail.value = false;
    super.dispose();
  }

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

  Widget quote() {
    if (!messageController.isQuate.value ||
        MediaQuery.of(context).viewInsets.bottom > 0) {
      return Container(
        width: 0.0,
      );
    }
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Transform.rotate(
            angle: 180 * pi / 180,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Icon(
                Entypo.quote,
                color: Colors.black.withOpacity(0.5),
                size: 16,
              ),
            ),
          ),
          Expanded(
            flex: 1,
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
                    messageContent(messageController.messageQuate),
                    const SizedBox(height: 2.0),
                    Text(
                      "${messageController.messageQuate["fullName"] ?? ""}, ${messageController.messageQuate["ngayGui"] ?? ""}",
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
          InkWell(
            onTap: () {
              messageController.hideQuate(context);
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Icon(
                Icons.close,
                color: Colors.black.withOpacity(0.5),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget bindEmoij() {
    if (!messageController.isEmoij.value ||
        MediaQuery.of(context).viewInsets.bottom > 0) {
      return Container(
        width: 0.0,
      );
    }
    return Container(
      decoration: const BoxDecoration(
          border:
              Border(top: BorderSide(width: 0.5, color: Color(0xFFcccccc)))),
      padding: const EdgeInsets.only(top: 5.0),
      margin: const EdgeInsets.only(top: 5.0),
      child: EmojiPicker(
        bgColor: Colors.white,
        rows: 5,
        columns: 9,
        selectedCategory: Category.SMILEYS,
        numRecommended: 10,
        onEmojiSelected: (emoji, category) {
          setState(() {
            messageController.send.value = true;
            messageController.controllers = TextEditingController(
                text: messageController.controllers.text + emoji.emoji!);
          });
        },
      ),
    );
  }

  Widget thumbContaint(dynamic chat) {
    return SizedBox(
      width: 40,
      height: 40,
      child: chatController.renderAvarta(chat, 1, 40, 12),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
        data: MediaQuery.of(context)
            .copyWith(textScaleFactor: Golbal.textScaleFactor),
        child: KeyboardDismisser(
          gestures: const [
            GestureType.onTap,
            GestureType.onPanUpdateDownDirection,
          ],
          child: Obx(
            () => Scaffold(
              key: messageController.scaffoldKey,
              backgroundColor: const Color(0xFFffffff),
              appBar: AppBar(
                backgroundColor: Colors.white,
                iconTheme: const IconThemeData(color: Colors.black45),
                titleSpacing: 0.0,
                elevation: 1.0,
                title: messageController.loading.value
                    ? null
                    : messageController.chat["nhom"] == true
                        ? InkWell(
                            onTap: () {
                              messageController
                                  .goInfoChat(messageController.chat);
                            },
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    messageController.chat["tenNhom"] ?? "",
                                    style: TextStyle(
                                      color: Golbal.appColor,
                                      fontSize: 16.0,
                                    ),
                                  ),
                                  Row(
                                    children: <Widget>[
                                      const Icon(
                                        FontAwesome.users,
                                        size: 13.0,
                                      ),
                                      Container(
                                        margin: const EdgeInsets.symmetric(
                                            horizontal: 5.0),
                                        child: Text(
                                          "${messageController.chat["countmb"]} thành viên",
                                          style: const TextStyle(
                                            color: Colors.black,
                                            fontSize: 13.0,
                                          ),
                                        ),
                                      )
                                    ],
                                  )
                                ]),
                          )
                        : InkWell(
                            onTap: () {
                              messageController
                                  .goInfoChat(messageController.chat);
                            },
                            child: Row(
                              children: <Widget>[
                                thumbContaint(messageController.chat),
                                Expanded(
                                  child: Container(
                                      margin: const EdgeInsets.only(left: 10.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "${messageController.chat["chatName"] ?? ""}",
                                            style: TextStyle(
                                              color: Golbal.appColor,
                                              fontSize: 16.0,
                                            ),
                                          ),
                                          if (messageController
                                                  .chat['isOnline'] ??
                                              false)
                                            const Text(
                                              "Trực tuyến",
                                              style: TextStyle(
                                                color: Colors.black45,
                                                fontSize: 12.0,
                                              ),
                                            )
                                          else if (messageController
                                                  .chat['lastOnline'] !=
                                              null)
                                            Text(
                                              "${messageController.chat["lastOnline"] ?? ""}",
                                              style: const TextStyle(
                                                color: Colors.black45,
                                                fontSize: 12.0,
                                              ),
                                            )
                                        ],
                                      )),
                                )
                              ],
                            ),
                          ),
                centerTitle: false,
                actions: <Widget>[
                  IconButton(
                    icon: const Icon(
                      Feather.phone,
                    ),
                    onPressed: () {
                      chatController.callPhone(messageController.chat);
                    },
                  ),
                  IconButton(
                    icon: const Icon(
                      AntDesign.videocamera,
                    ),
                    onPressed: chatController.callVideo,
                  ),
                ],
              ),
              body: Column(
                children: <Widget>[
                  const SizedBox(height: 5.0),
                  Expanded(
                    child: !messageController.loading.value &&
                            messageController.message_datas.isNotEmpty
                        ? ListView.builder(
                            key: const Key("lchats"),
                            controller: messageController.scrollController,
                            //reverse: true,
                            shrinkWrap: true,
                            //physics: const ScrollPhysics(),
                            itemCount: messageController.message_datas.length,
                            itemBuilder: (BuildContext context, int index) =>
                                ItemMessage(
                              message: messageController.message_datas[index],
                              index: index,
                            ),
                          )
                        : !messageController.loading.value
                            ? Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Center(
                                    child: Image.asset("assets/nochat.png"),
                                  ),
                                  const SizedBox(height: 10.0),
                                  const Text("Chưa có tin nhắn nào.",
                                      style: TextStyle(
                                          color: Colors.black45,
                                          fontWeight: FontWeight.bold)),
                                  const SizedBox(height: 5.0),
                                  const Text("Hãy bắt đầu cuộc trò chuyện.",
                                      style: TextStyle(color: Colors.black45))
                                ],
                              )
                            : const InlineLoadding(),
                  ),
                  StreamBuilder<bool>(
                      stream: messageController.streamTypeController.stream,
                      builder: (context, AsyncSnapshot<bool> snapshot) {
                        if (snapshot.hasData &&
                            snapshot.data! &&
                            messageController.user_id.value !=
                                Golbal.store.user["user_id"]) {
                          return Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Row(
                                children: <Widget>[
                                  // Text("${ten ?? ''}",
                                  //     style: TextStyle(
                                  //         color: appColor,
                                  //         fontWeight: FontWeight.bold)),
                                  Text("Đang soạn tin",
                                      style: TextStyle(
                                        color: Golbal.appColor,
                                      )),
                                  const SpinKitThreeBounce(
                                    color: Color(0xFFcccccc),
                                    size: 24.0,
                                  )
                                ],
                              ));
                        }
                        return Container(width: 0.0);
                      }),
                  Container(
                    decoration: const BoxDecoration(
                        color: Colors.white,
                        border: Border(
                            top: BorderSide(
                                color: Color(0xFFcccccc), width: 1.0))),
                    padding: const EdgeInsets.only(top: 5.0, bottom: 5.0),
                    child: SafeArea(
                      child: Column(
                        children: <Widget>[
                          quote(),
                          Row(
                            children: <Widget>[
                              IconButton(
                                onPressed: () {
                                  messageController.showEmoij(context);
                                },
                                icon: Icon(Icons.insert_emoticon,
                                    color: messageController.isEmoij.value
                                        ? Golbal.appColor
                                        : Colors.black38),
                              ),
                              Container(
                                child: !messageController.send.value
                                    ? InkWell(
                                        onTap: () {
                                          messageController
                                              .pickDocument(context);
                                        },
                                        child: const Padding(
                                          padding: EdgeInsets.only(right: 10.0),
                                          child: Icon(Icons.attach_file,
                                              color: Colors.black38),
                                        ))
                                    : const SizedBox(
                                        width: 0.0,
                                        height: 0.0,
                                      ),
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
                                          keyboardAppearance: Brightness.light,
                                          textInputAction:
                                              TextInputAction.newline,
                                          focusNode: messageController.focus,
                                          controller:
                                              messageController.controllers,
                                          maxLines: null,
                                          //keyboardType: TextInputType.multiline,
                                          onChanged: (String txt) {
                                            if (messageController
                                                    .typing.value ==
                                                false) {
                                              messageController.typing.value =
                                                  true;
                                              var u = {
                                                "user_id": Golbal
                                                    .store.user["user_id"],
                                                "nguoiGui": Golbal
                                                    .store.user["user_id"],
                                                "FullName": Golbal
                                                    .store.user["FullName"],
                                                "fname":
                                                    Golbal.store.user["fname"],
                                                "Avartar": Golbal
                                                    .store.user["Avartar"],
                                                "ChatID": messageController
                                                    .chat["ChatID"],
                                                "typing": true,
                                                "event": "typing",
                                                "socketid": Golbal.socket.id,
                                              };
                                              Golbal.socket.emit('sendData', u);
                                            }
                                            _streamController.add(txt);
                                            if (txt != null && txt != "") {
                                              messageController.send.value =
                                                  true;
                                            } else {
                                              messageController.send.value =
                                                  false;
                                            }
                                          },
                                          onSubmitted: (String txt) {
                                            messageController.sendSMS();
                                          },
                                          decoration: const InputDecoration(
                                            isDense: true,
                                            enabledBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(40.0)),
                                              borderSide: BorderSide(
                                                  color: Color(0xFFdddddd)),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(40.0)),
                                              borderSide: BorderSide(
                                                  color: Color(0xFFdddddd)),
                                            ),
                                            contentPadding:
                                                EdgeInsets.symmetric(
                                                    vertical: 10.0,
                                                    horizontal: 15.0),
                                            hintText: 'Tin nhắn',
                                            hintStyle:
                                                TextStyle(fontSize: 13.0),
                                          ),
                                        ))),
                              ),
                              const SizedBox(width: 5.0),
                              messageController.send.value
                                  ? IconButton(
                                      onPressed: () {
                                        messageController.sendSMS();
                                      },
                                      icon: const Icon(Icons.send,
                                          color: Color(0xFF0b72ff)),
                                    )
                                  : Container(
                                      width: 0.0,
                                    ),
                              !messageController.send.value
                                  ? InkWell(
                                      onTap: () {
                                        messageController
                                            .initMultiPickUp(mounted);
                                      },
                                      child: const Padding(
                                        padding: EdgeInsets.only(right: 8.0),
                                        child: Icon(
                                          EvilIcons.image,
                                          color: Colors.black38,
                                          size: 32,
                                        ),
                                      ))
                                  : Container(
                                      width: 0.0,
                                    )
                            ],
                          ),
                          bindEmoij(),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
