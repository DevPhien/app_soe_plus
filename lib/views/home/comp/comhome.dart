import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/homeappcontroller.dart';
import 'commenu.dart';
import 'commymenu.dart';
import 'comsinhnhat.dart';
import 'comthongbao.dart';
import 'comtintuc.dart';

class CompHome extends StatelessWidget {
  CompHome({Key? key}) : super(key: key);
  final HomeAppController homecontroller = Get.put(HomeAppController());

  @override
  Widget build(context) {
    return RefreshIndicator(
      onRefresh: homecontroller.onrefersh,
      child: Obx(
        () => ListView(
          children: [
            HomeThongBao(),
            HomeMenu(),
            HomeMyMenu(),
            HomeSinhNhat(),
            if (!homecontroller.isLoadding.value &&
                homecontroller.isActive.value) ...[
              HomeTintuc(),
            ],
          ],
        ),
      ),
    );
  }
}
