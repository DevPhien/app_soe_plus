import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:soe/utils/golbal/golbal.dart';
import 'package:soe/views/chat/controller/messenger/chatcardcontroller.dart';
import 'roommates.dart';
import 'chatcard.dart';

class ChatHome extends StatelessWidget {
  final ChatCardController chatcardController = Get.put(ChatCardController());

  final bool? isscrool;
  ChatHome({Key? key, this.isscrool}) : super(key: key);

  @override
  Widget build(context) {
    return MediaQuery(
      data: MediaQuery.of(context)
          .copyWith(textScaleFactor: Golbal.textScaleFactor),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          automaticallyImplyLeading: false,
          title: Container(
            width: double.infinity,
            height: 40,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                color: const Color(0xFFf9f8f8),
                border: Border.all(color: const Color(0xffeeeeee), width: 1.0)),
            child: Center(
              child: TextField(
                textInputAction: TextInputAction.search,
                controller: chatcardController.searchController,
                onSubmitted: (String txt) {
                  chatcardController
                      .onSearch(chatcardController.searchController.text);
                },
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.all(5),
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  border: InputBorder.none,
                  hintText: 'Tìm kiếm',
                  prefixIcon: IconButton(
                    onPressed: () {
                      chatcardController
                          .onSearch(chatcardController.searchController.text);
                    },
                    icon: const Icon(Icons.search),
                  ),
                  //suffixIcon: Icon(AntDesign.filter)
                ),
              ),
            ),
          ),
        ),
        body: Column(
          children: [
            UserRoommates(),
            Expanded(
              child: ChatCard(),
            ),
          ],
        ),
      ),
    );
  }
}
