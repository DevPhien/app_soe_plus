import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:soe/views/task/comp/project/project.dart';

import '../../utils/golbal/golbal.dart';
import '../component/compavarta.dart';
import 'comp/counttask.dart';
import 'comp/taskhome.dart';
import 'controller/taskcontroller.dart';

class Task extends StatelessWidget {
  final TaskController controller = Get.put(TaskController());

  Task({Key? key}) : super(key: key);
  //Function
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
                  TaskHome(),
                ] else if (controller.pageIndex.value == 2) ...[
                  Project(),
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
                          icon: Icon(MaterialCommunityIcons.playlist_check),
                          label: "Công việc"),
                      BottomNavigationBarItem(
                          backgroundColor: Colors.white,
                          icon: Icon(MaterialCommunityIcons.view_list_outline),
                          label: "Dự án"),
                      // BottomNavigationBarItem(
                      //     backgroundColor: Colors.white,
                      //     icon: Icon(AntDesign.appstore_o),
                      //     label: "Khác")
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
