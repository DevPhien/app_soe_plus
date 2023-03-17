import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:soe/views/chat/controller/favorites/favoritescontroller.dart';

import '../../utils/golbal/golbal.dart';
import 'comp/phonebook/phonebookhome.dart';
import 'controller/chatcontroller.dart';
import 'comp/messenger/chathome.dart';
import 'comp/favorites/favoriteshome.dart';
import 'comp/chatgroup/chatgrouphome.dart';

class Chat extends StatefulWidget {
  const Chat({Key? key}) : super(key: key);

  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> with WidgetsBindingObserver {
  final ChatController chatController = Get.put(ChatController());
  final FavoritesController favoritesController =
      Get.put(FavoritesController());

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
    initSocket();
  }

  void initSocket() {
    var u = {
      "user_id": Golbal.store.user["user_id"],
      "FullName": Golbal.store.user["FullName"],
      "fname": Golbal.store.user["fname"],
      "Avartar": Golbal.store.user["Avartar"],
      "socketid": Golbal.socket.id,
    };
    Golbal.socket.emit('connectsocket', u);
    //connect
    Golbal.socket
        .on('countUsers', (data) => chatController.initSocketConnected(data));
    //chat
    Golbal.socket
        .on('getAddChat', (data) => chatController.initSocketDataChat(data));
    Golbal.socket
        .on('getDelChat', (data) => chatController.initSocketDataChat(data));

    Golbal.socket.on(
        'getSendMessage', (data) => chatController.initSocketDataMessage(data));
    Golbal.socket.on(
        'getEditMessage', (data) => chatController.initSocketDataMessage(data));
    Golbal.socket.on(
        'getDelMessage', (data) => chatController.initSocketDataMessage(data));
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context)
          .copyWith(textScaleFactor: Golbal.textScaleFactor),
      child: Scaffold(
        backgroundColor: const Color(0xffffffff),
        appBar: AppBar(
          automaticallyImplyLeading: false,
          elevation: 0.0,
          backgroundColor: Colors.white,
          iconTheme: const IconThemeData(color: Colors.white),
          titleSpacing: 0.0,
          title: Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 15.0),
                child: Obx(
                  () => Text(
                    (chatController.pageIndex.value == 1)
                        ? "Chat nội bộ"
                        : (chatController.pageIndex.value == 2)
                            ? "Yêu thích"
                            : (chatController.pageIndex.value == 3)
                                ? "Danh bạ"
                                : (chatController.pageIndex.value == 4)
                                    ? "Danh sách nhóm"
                                    : "Chat",
                    textAlign: TextAlign.left,
                    style: const TextStyle(
                      color: Color(0xFF0186f8),
                      fontWeight: FontWeight.bold,
                      fontSize: 24.0,
                    ),
                  ),
                ),
              ),
            ],
          ),
          actions: <Widget>[
            Obx(
              () => Row(
                children: [
                  IconButton(
                    onPressed: () {
                      chatController.goSendMessage();
                    },
                    icon: const Icon(
                      Feather.edit,
                      size: 22,
                      color: Color(0xFF0186f8),
                    ),
                  ),
                  if (chatController.pageIndex.value == 2) ...[
                    IconButton(
                      onPressed: () {
                        favoritesController.openModalAddFavorites(context);
                      },
                      icon: const Icon(
                        MaterialCommunityIcons.account_plus_outline,
                        size: 30,
                        color: Color(0xFF0186f8),
                      ),
                    )
                  ] else if (chatController.pageIndex.value != 2) ...[
                    IconButton(
                      onPressed: () {
                        chatController.openModalAddChatGroup(context);
                      },
                      icon: const Icon(
                        MaterialCommunityIcons.account_multiple_plus_outline,
                        size: 30,
                        color: Color(0xFF0186f8),
                      ),
                    )
                  ] else ...[
                    const SizedBox.shrink(),
                  ]
                ],
              ),
            ),
          ],
        ),
        body: NotificationListener<ScrollEndNotification>(
          onNotification: (scrollEnd) {
            final metrics = scrollEnd.metrics;
            if (metrics.atEdge) {
              bool isTop = metrics.pixels == 0;
              if (isTop) {
              } else {
                //chatController.onLoadmore();
              }
            }
            return true;
          },
          child: PageView(
            children: <Widget>[
              Obx(() => chatController.pageIndex.value == 1
                  ? ChatHome()
                  : chatController.pageIndex.value == 2
                      ? FavoritesHome()
                      : chatController.pageIndex.value == 3
                          ? const PhoneBookHome()
                          : chatController.pageIndex.value == 4
                              ? ChatGroupHome()
                              : const SizedBox.shrink()),
            ],
          ),
        ),
        bottomNavigationBar: Obx(
          () => BottomNavigationBar(
            backgroundColor: Colors.white,
            items: const [
              BottomNavigationBarItem(
                  backgroundColor: Colors.white,
                  icon: Icon(AntDesign.home),
                  label: "Home"),
              BottomNavigationBarItem(
                  backgroundColor: Colors.white,
                  icon: Icon(Ionicons.chatbubbles_outline),
                  label: "Tin nhắn"),
              BottomNavigationBarItem(
                  backgroundColor: Colors.white,
                  icon: Icon(Feather.star),
                  label: "Yêu thích"),
              BottomNavigationBarItem(
                  backgroundColor: Colors.white,
                  icon: Icon(AntDesign.idcard),
                  label: "Danh bạ"),
              BottomNavigationBarItem(
                  backgroundColor: Colors.white,
                  icon: Icon(FontAwesome.users),
                  label: "Nhóm")
            ],
            currentIndex: chatController.pageIndex.value,
            onTap: chatController.onPageChanged,
            type: BottomNavigationBarType.fixed,
            fixedColor: const Color(0xFF0b72ff),
          ),
        ),
      ),
    );
  }
}
