import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';

import '../../utils/golbal/golbal.dart';
import '../component/compavarta.dart';
import 'comp/ccountlichhop.dart';
import 'comp/lichhophome.dart';
import 'lichhopcontroller.dart';

class Lichhop extends StatelessWidget {
  final LichHopController controller = Get.put(LichHopController());
  Lichhop({Key? key}) : super(key: key);
  //Function
  Widget chonLichDuyetWWidget() {
    return Row(
      children: [
        IconButton(
            onPressed: controller.closeChon,
            icon: Icon(
              Ionicons.close,
              color: Golbal.titleColor,
            )),
        const SizedBox(width: 5.0),
        Expanded(
            child: Text(
          "Đã chọn ${controller.solichchon.value}",
          style: TextStyle(
              color: Golbal.titleColor,
              fontWeight: FontWeight.bold,
              fontSize: 20),
        )),
        const SizedBox(width: 5.0),
        Obx(() => Checkbox(
            value: controller.chonall.value,
            onChanged: controller.changeChonAll))
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context)
          .copyWith(textScaleFactor: Golbal.textScaleFactor),
      child: Scaffold(
          backgroundColor: const Color(0xffffffff),
          body: CustomScrollView(
            slivers: [
              SliverAppBar(
                automaticallyImplyLeading: false,
                backgroundColor: Colors.white,
                floating: true,
                pinned: true,
                snap: false,
                centerTitle: false,
                title: const Text("Lịch họp tuần",
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
                  title: Obx(
                    () => controller.solichchon.value == 0
                        ? Container(
                            width: double.infinity,
                            height: 40,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                color: const Color(0xFFf9f8f8),
                                border: Border.all(
                                    color: const Color(0xffeeeeee),
                                    width: 1.0)),
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
                            ))
                        : chonLichDuyetWWidget(),
                  ),
                ),
              ),
              // Other Sliver Widgets
              SliverList(
                delegate: SliverChildListDelegate([
                  CCountLichhop(),
                  Obx(() => controller.pageIndex.value != 0
                      ? LichhopHome()
                      : const SizedBox.shrink()),
                  Obx(() => controller.loaddingmore.value == true
                      ? const Center(
                          child: Padding(
                          padding: EdgeInsets.all(20.0),
                          child: CupertinoActivityIndicator(),
                        ))
                      : const SizedBox.shrink()),
                ]),
              ),
            ],
          ),
          bottomNavigationBar: Obx(
            () => controller.solichchon.value > 0
                ? SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      child: Row(
                        children: [
                          Expanded(
                              child: SizedBox(
                            height: 40,
                            child: ElevatedButton.icon(
                              icon: const Icon(FontAwesome.close),
                              onPressed: () {
                                controller.tralich();
                              },
                              label: const Text("Trả lại",
                                  style: TextStyle(color: Colors.white)),
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        const Color(0xFFFD0A0A)),
                              ),
                            ),
                          )),
                          const SizedBox(width: 10),
                          Expanded(
                              child: SizedBox(
                            height: 40,
                            child: ElevatedButton.icon(
                              icon: const Icon(FontAwesome.calendar_check_o),
                              onPressed: controller.duyetlich,
                              label: const Text("Duyệt lịch",
                                  style: TextStyle(color: Colors.white)),
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Golbal.appColor),
                              ),
                            ),
                          ))
                        ],
                      ),
                    ),
                  )
                : controller.quyen["Calendar_Duyetlich"] == null
                    ? const SizedBox.shrink()
                    : BottomNavigationBar(
                        backgroundColor: Colors.white,
                        items: [
                          const BottomNavigationBarItem(
                              backgroundColor: Colors.white,
                              icon: Icon(AntDesign.home),
                              label: "Home"),
                          const BottomNavigationBarItem(
                              backgroundColor: Colors.white,
                              icon: Icon(FontAwesome.calendar),
                              label: "Lịch chung"),
                          const BottomNavigationBarItem(
                              backgroundColor: Colors.white,
                              icon: Icon(FontAwesome.user_o),
                              label: "Cá nhân"),
                          if (controller.quyen["Calendar_Duyetlich"] == true)
                            const BottomNavigationBarItem(
                                backgroundColor: Colors.white,
                                icon:
                                    Icon(MaterialCommunityIcons.calendar_clock),
                                label: "Chờ duyệt"),
                          // const BottomNavigationBarItem(
                          //     backgroundColor: Colors.white,
                          //     icon: Icon(Ionicons.ellipsis_horizontal_outline),
                          //     label: "Khác")
                        ],
                        currentIndex: controller.pageIndex.value,
                        onTap: controller.onPageChanged,
                        type: BottomNavigationBarType.fixed,
                        fixedColor: const Color(0xFF0b72ff),
                        selectedFontSize: 12.0 * Golbal.textScaleFactor,
                        unselectedFontSize: 12.0 * Golbal.textScaleFactor,
                      ),
          )),
    );
  }
}
