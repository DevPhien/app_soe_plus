import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';

import '../../utils/golbal/golbal.dart';
import '../component/compavarta.dart';
import 'comp/CCountVanban.dart';
import 'comp/vanbanhome.dart';
import 'controller/vanbanhomecontroller.dart';

class Vanban extends StatelessWidget {
  final HomeVanbanController controller = Get.put(HomeVanbanController());

  Vanban({Key? key}) : super(key: key);
  //Function
  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context)
          .copyWith(textScaleFactor: Golbal.textScaleFactor),
      child: Scaffold(
          backgroundColor: const Color(0xffffffff),
          body: NotificationListener<ScrollEndNotification>(
              onNotification: (scrollEnd) {
                final metrics = scrollEnd.metrics;
                if (metrics.axisDirection == AxisDirection.down &&
                    metrics.atEdge) {
                  bool isTop = metrics.pixels == 0;
                  if (isTop) {
                  } else {
                    controller.onLoadmore();
                  }
                }
                return true;
              },
              child: CustomScrollView(
                controller: controller.vbController,
                slivers: [
                  SliverAppBar(
                    automaticallyImplyLeading: false,
                    backgroundColor: Colors.white,
                    floating: true,
                    pinned: true,
                    snap: false,
                    centerTitle: false,
                    title: const Text("Văn bản",
                        style: TextStyle(
                            color: Color(0xFF0186f8),
                            fontWeight: FontWeight.bold,
                            fontSize: 24.0)),
                    actions: const <Widget>[CompUserAvarta()],
                    systemOverlayStyle: Golbal.systemUiOverlayStyle1,
                    bottom: AppBar(
                      elevation: 0,
                      backgroundColor: Colors.white,
                      automaticallyImplyLeading: false,
                      title: Container(
                        width: double.infinity,
                        height: 40,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            color: const Color(0xFFf9f8f8),
                            border: Border.all(
                                color: const Color(0xffeeeeee), width: 1.0)),
                        child: Center(
                          child: TextField(
                            onSubmitted: controller.search,
                            decoration: InputDecoration(
                                contentPadding: const EdgeInsets.all(5),
                                focusedBorder: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                border: InputBorder.none,
                                hintText: 'Tìm kiếm',
                                prefixIcon: const Icon(Icons.search),
                                suffixIcon: Obx(() => InkWell(
                                    onTap: controller.goFilterAdv,
                                    child: Icon(AntDesign.filter,
                                        color: controller.isSearchAdv.value
                                            ? Golbal.appColor
                                            : Colors.black54)))),
                          ),
                        ),
                      ),
                    ),
                  ),
                  // Other Sliver Widgets
                  SliverList(
                    delegate: SliverChildListDelegate([
                      Obx(() => controller.isSearchAdv.value == true
                          ? Padding(
                              padding: const EdgeInsets.only(
                                  left: 30, top: 10, right: 20),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Kết quả tìm kiếm",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Golbal.titleColor,
                                          fontSize: 18)),
                                  TextButton(
                                      onPressed: controller.clearAdv,
                                      child: const Text("Xoá kết quả",
                                          style:
                                              TextStyle(color: Colors.orange)))
                                ],
                              ),
                            )
                          : CCountVanban()),
                      Obx(() => controller.pageIndex.value != 0
                          ? VanbanHome()
                          : const SizedBox.shrink()),
                    ]),
                  ),
                ],
              )),
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
                    icon: Icon(MaterialCommunityIcons.email_receive_outline),
                    label: "Nhận"),
                BottomNavigationBarItem(
                    backgroundColor: Colors.white,
                    icon: Icon(MaterialCommunityIcons.email_send_outline),
                    label: "Gửi"),
                BottomNavigationBarItem(
                    backgroundColor: Colors.white,
                    icon: Icon(Ionicons.ios_file_tray_stacked_outline),
                    label: "Tủ số hoá")
              ],
              currentIndex: controller.pageIndex.value,
              onTap: controller.onPageChanged,
              type: BottomNavigationBarType.fixed,
              fixedColor: const Color(0xFF0b72ff),
            ),
          )),
    );
  }
}
