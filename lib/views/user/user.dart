import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../utils/golbal/golbal.dart';
import 'comp/userhome.dart';
import 'controller/usercontroller.dart';

class User extends StatelessWidget {
  User({Key? key}) : super(key: key);

  final UserController controller = Get.put(UserController());

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context)
          .copyWith(textScaleFactor: Golbal.textScaleFactor),
      child: Scaffold(
        backgroundColor: const Color(0xffffffff),
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.black45),
          backgroundColor: Colors.white,
          elevation: 0.0,
        ),
        body: Obx(() => (controller.datas.isNotEmpty)
            ? UserHome(user: controller.datas.value)
            : const SizedBox.shrink()),
      ),
    );
  }
}
