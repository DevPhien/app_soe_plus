import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:soe/views/chat/comp/phonebook/itemphonebook.dart';
import 'package:soe/views/chat/controller/phonebook/phonebookcontroller.dart';

import '../../../../utils/golbal/golbal.dart';
import 'userleaders.dart';

class PhoneBookHome extends StatefulWidget {
  final bool? isscrool;
  const PhoneBookHome({Key? key, this.isscrool}) : super(key: key);

  @override
  State<PhoneBookHome> createState() => _PhoneBookHomeState();
}

class _PhoneBookHomeState extends State<PhoneBookHome>
    with SingleTickerProviderStateMixin {
  final PhoneBookController controller = Get.put(PhoneBookController());

  Widget itemPhoneBook(context, i) =>
      ItemPhoneBook(user: controller.phonebook_datas[i], index: i);

  Widget itemTree(context, i) =>
      ItemPhoneBook(user: controller.tree_datas[i], index: i);

  @override
  void initState() {
    super.initState();
    controller.tabController = TabController(vsync: this, length: 2);
  }

  @override
  void dispose() {
    controller.tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                controller: controller.searchController,
                onSubmitted: (String txt) {
                  controller.onSearch(txt);
                },
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.all(5),
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  border: InputBorder.none,
                  hintText: 'Tìm kiếm',
                  prefixIcon: IconButton(
                    onPressed: () {
                      controller.onSearch(controller.searchController.text);
                    },
                    icon: const Icon(Icons.search),
                  ),
                  //suffixIcon: Icon(AntDesign.filter)
                ),
              ),
            ),
          ),
        ),
        body: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              Obx(
                () => SliverAppBar(
                  backgroundColor: Colors.white,
                  expandedHeight:
                      controller.userleader_datas.isEmpty ? 0.0 : 160.0,
                  elevation: 0.5,
                  floating: true,
                  automaticallyImplyLeading: false,
                  pinned: true,
                  flexibleSpace: FlexibleSpaceBar(
                    background: Column(
                      children: <Widget>[
                        UserLeader(),
                      ],
                    ),
                  ),
                  bottom: PreferredSize(
                    preferredSize: const Size.fromHeight(43.0),
                    child: Container(
                      width: double.infinity,
                      color: Colors.white,
                      child: Column(
                        children: [
                          Center(
                            child: TabBar(
                              controller: controller.tabController,
                              tabs: [
                                Tab(
                                  height: 35.0,
                                  child: Stack(
                                    children: <Widget>[
                                      const SizedBox(
                                        width: double.infinity,
                                        child: Padding(
                                          padding: EdgeInsets.only(top: 12.0),
                                          child: Text(
                                            "TẤT CẢ",
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                        height: 40.0,
                                      ),
                                      Positioned(
                                          right: 0.0,
                                          top: 7.0,
                                          child: CircleAvatar(
                                              radius: 12.0,
                                              backgroundColor: Colors.orange,
                                              child: Text(
                                                "${controller.phonebook_datas.length}",
                                                style: const TextStyle(
                                                    fontSize: 9.0,
                                                    color: Colors.white),
                                                textAlign: TextAlign.center,
                                                overflow: TextOverflow.ellipsis,
                                              )))
                                    ],
                                  ),
                                ),
                                const Tab(
                                  height: 35.0,
                                  text: "THEO PHÒNG BAN",
                                ),
                              ],
                              indicatorColor: Golbal.appColor,
                              labelColor: Golbal.appColor,
                              unselectedLabelColor: Colors.black54,
                              //isScrollable: true,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ];
          },
          body: Obx(
            () => TabBarView(
              controller: controller.tabController,
              children: [
                controller.phonebook_datas.isNotEmpty
                    ? Scrollbar(
                        child: ListView.builder(
                          physics: const BouncingScrollPhysics(),
                          padding: const EdgeInsets.all(0.0),
                          itemBuilder: itemPhoneBook,
                          itemCount: controller.phonebook_datas.length,
                        ),
                      )
                    : const SizedBox.shrink(),
                controller.tree_datas.isNotEmpty
                    ? Scrollbar(
                        child: ListView.builder(
                          shrinkWrap: true,
                          physics: const BouncingScrollPhysics(),
                          itemCount: controller.tree_datas.length,
                          itemBuilder: (ct, i) {
                            if (i == 0 ||
                                controller.tree_datas[i]["tenCongty"] !=
                                    controller.tree_datas[i - 1]["tenCongty"]) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Divider(height: 1),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20.0, vertical: 10.0),
                                    child: Text(
                                      "${controller.tree_datas[i]["tenCongty"] ?? ""}",
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black87),
                                      textAlign: TextAlign.left,
                                    ),
                                  ),
                                  controller.tree_datas[i]["tenPhongban"] !=
                                          null
                                      ? Container(
                                          color: const Color(0xFFeeeeee),
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 15, horizontal: 20),
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            "${controller.tree_datas[i]["tenPhongban"] ?? ""}",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Golbal.titleColor),
                                          ),
                                        )
                                      : const SizedBox(width: 0.0, height: 0.0),
                                  itemTree(controller.tree_datas[i], i),
                                ],
                              );
                            }
                            if (i == 0 ||
                                controller.tree_datas[i]["tenPhongban"] !=
                                    controller.tree_datas[i - 1]
                                        ["tenPhongban"]) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  controller.tree_datas[i]["tenPhongban"] !=
                                          null
                                      ? Container(
                                          color: const Color(0xFFeeeeee),
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 15, horizontal: 20),
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            "${controller.tree_datas[i]["tenPhongban"] ?? ""}",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Golbal.titleColor),
                                          ),
                                        )
                                      // Container(
                                      //     padding: const EdgeInsets.symmetric(
                                      //         horizontal: 10.0, vertical: 5.0),
                                      //     child: Text(
                                      //       "${controller.tree_datas[i]["tenPhongban"] ?? ""}",
                                      //       style: TextStyle(
                                      //           fontWeight: FontWeight.bold,
                                      //           color: Golbal.appColor),
                                      //     ),
                                      //   )
                                      : const SizedBox(width: 0.0, height: 0.0),
                                  itemTree(controller.tree_datas[i], i),
                                ],
                              );
                            }
                            return itemTree(controller.tree_datas[i], i);
                          },
                        ),
                      )
                    : const SizedBox.shrink(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
