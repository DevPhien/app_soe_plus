import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';

import '../../utils/golbal/golbal.dart';
import '../component/compavarta.dart';
import 'comp/ccountdieuxe.dart';
import 'comp/dieuxehome.dart';
import 'comp/dieuxemoi.dart';
import 'dieuxecontroller.dart';
import 'xe/xe.dart';

class Dieuxe extends StatelessWidget {
  final DieuxeController controller = Get.put(DieuxeController());
  Dieuxe({Key? key}) : super(key: key);
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
              automaticallyImplyLeading: true,
              iconTheme: const IconThemeData(color: Color(0xFF0186f8)),
              backgroundColor: Colors.white,
              floating: true,
              pinned: true,
              snap: false,
              centerTitle: false,
              title: const Text("Lệnh điều xe",
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
                          suffixIcon: IconButton(
                              onPressed: controller.openDate,
                              icon: const Icon(Icons.calendar_month_outlined)),
                        ),
                      ),
                    )),
              ),
            ),
            // Other Sliver Widgets
            SliverList(
              delegate: SliverChildListDelegate([
                Obx(() => controller.pageIndex.value == 1 ||
                        controller.pageIndex.value == 2
                    ? CCountDieuxe()
                    : const SizedBox.shrink()),
                Obx(() => controller.pageIndex.value == 0
                    ? DieuxeDasboard()
                    : controller.pageIndex.value == 3
                        ? Listxe()
                        : DieuxeHome()),
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
        bottomNavigationBar: Obx(() => BottomNavigationBar(
              backgroundColor: Colors.white,
              items: const [
                BottomNavigationBarItem(
                    backgroundColor: Colors.white,
                    icon: Icon(AntDesign.home),
                    label: "Home"),
                BottomNavigationBarItem(
                    backgroundColor: Colors.white,
                    icon: Icon(MaterialCommunityIcons.calendar_clock),
                    label: "Chờ duyệt"),
                BottomNavigationBarItem(
                    backgroundColor: Colors.white,
                    icon: Icon(FontAwesome.file_o),
                    label: "Theo dõi"),
                BottomNavigationBarItem(
                    backgroundColor: Colors.white,
                    icon: Icon(AntDesign.car),
                    label: "Xe"),
              ],
              currentIndex: controller.pageIndex.value,
              onTap: controller.onPageChanged,
              type: BottomNavigationBarType.fixed,
              fixedColor: const Color(0xFF0b72ff),
              selectedFontSize: 12.0 * Golbal.textScaleFactor,
              unselectedFontSize: 12.0 * Golbal.textScaleFactor,
            )),
      ),
    );
  }
}
