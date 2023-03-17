import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';

import '../../../utils/golbal/golbal.dart';
import 'dangky/dangkylich.dart';
import 'hrmpagecontroller.dart';

class HRMPage extends StatelessWidget {
  final HRMController controller = Get.put(HRMController());

  HRMPage({Key? key}) : super(key: key);

  Widget cauhinhWidget() {
    return Column(
      children: [
        ListTile(
          onTap: () {
            Get.toNamed("/calam");
          },
          leading: const Icon(Ionicons.calendar_outline, color: Colors.blue),
          title: const Text("Cấu hình ca làm việc"),
          trailing: const Icon(Ionicons.chevron_forward_outline),
        ),
        const Divider(height: 1),
        ListTile(
          onTap: () {
            Get.toNamed("/diadiemlam");
          },
          leading: const Icon(Ionicons.home_outline, color: Colors.green),
          title: const Text("Địa điểm làm việc"),
          trailing: const Icon(Ionicons.chevron_forward_outline),
        ),
        const Divider(height: 1),
        const ListTile(
          leading: Icon(Feather.clock, color: Colors.pink),
          title: Text("Thiết lập ngày công"),
          trailing: Icon(Ionicons.chevron_forward_outline),
        ),
        const Divider(height: 1),
        const ListTile(
          leading: Icon(Ionicons.cog, color: Colors.orange),
          title: Text("Thiết lập chung"),
          trailing: Icon(Ionicons.chevron_forward_outline),
        ),
      ],
    );
  }

  Widget homeWidget() {
    switch (controller.pageIndex.value) {
      case 1:
        return DangkylichPage();
      case 2:
        return cauhinhWidget();
    }
    return Container();
  }

  //Function
  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context)
          .copyWith(textScaleFactor: Golbal.textScaleFactor),
      child: Obx(() => Scaffold(
          backgroundColor: const Color(0xffffffff),
          appBar: controller.pageIndex.value == 1
              ? null
              : AppBar(
                  leading: IconButton(
                    icon: Icon(
                      Ionicons.chevron_back_outline,
                      color: Colors.black.withOpacity(0.5),
                      size: 30,
                    ),
                    onPressed: () {
                      Get.back();
                    },
                  ),
                  backgroundColor: Colors.white,
                  iconTheme: IconThemeData(color: Golbal.appColor),
                  titleSpacing: 0.0,
                  centerTitle: true,
                  title: Text("HRM",
                      style: TextStyle(
                          color: Golbal.titleappColor,
                          fontWeight: FontWeight.bold)),
                  systemOverlayStyle: SystemUiOverlayStyle.light,
                ),
          body: homeWidget(),
          bottomNavigationBar: BottomNavigationBar(
            backgroundColor: Colors.white,
            items: const [
              BottomNavigationBarItem(
                  backgroundColor: Colors.white,
                  icon: Icon(AntDesign.home),
                  label: "Home"),
              BottomNavigationBarItem(
                  backgroundColor: Colors.white,
                  icon: Icon(MaterialCommunityIcons.calendar),
                  label: "Chấm công"),
              BottomNavigationBarItem(
                  backgroundColor: Colors.white,
                  icon: Icon(MaterialCommunityIcons.cog),
                  label: "Cấu hình"),
            ],
            currentIndex: controller.pageIndex.value,
            onTap: controller.onPageChanged,
            type: BottomNavigationBarType.fixed,
            fixedColor: const Color(0xFF0b72ff),
          ))),
    );
  }
}
