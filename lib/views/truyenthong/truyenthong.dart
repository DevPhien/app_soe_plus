import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';

import '../../utils/golbal/golbal.dart';
import '../component/compavarta.dart';
import 'thongbao/thongbao.dart';
import 'tintuc/tintuc.dart';
import 'truyenthongcontroller.dart';
import 'vinhdanh/vinhdanh.dart';

class Truyenthong extends StatelessWidget {
  final TruyenthongController controller = Get.put(TruyenthongController());

  Truyenthong({Key? key}) : super(key: key);
  Widget bodyWidget() {
    if (!controller.isLoadding.value && controller.isActive.value) {
      if (controller.pageIndex.value == 1) {
        return TinTuc();
      } else if (controller.pageIndex.value == 2) {
        return ThongBao();
      } else if (controller.pageIndex.value == 3) {
        return Vinhdanh();
      }
    } else {
      if (controller.pageIndex.value == 1) {
        return ThongBao();
      }
    }

    return Container();
  }

  //Function
  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context)
          .copyWith(textScaleFactor: Golbal.textScaleFactor),
      child: Scaffold(
          backgroundColor: const Color(0xffffffff),
          appBar: AppBar(
            elevation: 0,
            automaticallyImplyLeading: false,
            backgroundColor: Colors.white,
            centerTitle: false,
            title: const Text("Truyền thông nội bộ",
                style: TextStyle(
                    color: Color(0xFF0186f8),
                    fontWeight: FontWeight.bold,
                    fontSize: 24.0)),
            actions: const <Widget>[CompUserAvarta()],
            systemOverlayStyle: Golbal.systemUiOverlayStyle1,
          ),
          body: Obx(() => bodyWidget()),
          bottomNavigationBar: Obx(
            () => BottomNavigationBar(
              backgroundColor: Colors.white,
              items: [
                const BottomNavigationBarItem(
                    backgroundColor: Colors.white,
                    icon: Icon(AntDesign.home),
                    label: "Home"),
                if (!controller.isLoadding.value &&
                    controller.isActive.value) ...[
                  const BottomNavigationBarItem(
                      backgroundColor: Colors.white,
                      icon: Icon(FontAwesome.newspaper_o),
                      label: "Bản tin"),
                ],
                BottomNavigationBarItem(
                    backgroundColor: Colors.white,
                    icon: controller.isActive.value
                        ? const Icon(AntDesign.notification)
                        : const Icon(FontAwesome.newspaper_o),
                    label: "Thông báo"),
                if (!controller.isLoadding.value &&
                    controller.isActive.value) ...[
                  const BottomNavigationBarItem(
                      backgroundColor: Colors.white,
                      icon: Icon(Entypo.medal),
                      label: "Vinh danh")
                ],
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
