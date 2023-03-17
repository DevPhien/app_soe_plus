import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:soe/utils/golbal/golbal.dart';
import 'package:soe/views/request/comp/filerequest/filerequest.dart';
import 'package:soe/views/request/comp/homerequest/homerequest.dart';
import 'package:soe/views/request/comp/teamrequest/teamrequest.dart';
import 'package:soe/views/request/controller/requestcontroller.dart';

class Request extends StatelessWidget {
  final RequestController controller = Get.put(RequestController());
  Request({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context)
          .copyWith(textScaleFactor: Golbal.textScaleFactor),
      child: Scaffold(
          backgroundColor: const Color(0xffffffff),
          body: Obx(
            () => PageView(
              children: <Widget>[
                if (controller.pageIndex.value == 1) ...[
                  HomeRequest(),
                ] else if (controller.pageIndex.value == 2) ...[
                  TeamRequest(),
                ] else if (controller.pageIndex.value == 3) ...[
                  FileRequest(),
                ]
              ],
            ),
          ),
          bottomNavigationBar: Obx(
            () => !controller.showFab.value
                ? const SizedBox.shrink()
                : BottomNavigationBar(
                    backgroundColor: Colors.white,
                    items: const [
                      BottomNavigationBarItem(
                          backgroundColor: Colors.white,
                          icon: Icon(AntDesign.home),
                          label: "Home"),
                      BottomNavigationBarItem(
                          backgroundColor: Colors.white,
                          icon: Icon(MaterialCommunityIcons.format_list_checks),
                          label: "Đễ xuất"),
                      BottomNavigationBarItem(
                          backgroundColor: Colors.white,
                          icon: Icon(
                              MaterialCommunityIcons.text_box_check_outline),
                          label: "Team"),
                      BottomNavigationBarItem(
                          backgroundColor: Colors.white,
                          icon: Icon(Feather.file_text),
                          label: "File"),
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
