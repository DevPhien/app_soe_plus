import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../utils/golbal/golbal.dart';
import 'use/avatar.dart';

class CompUserAvarta extends StatelessWidget {
  const CompUserAvarta({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return InkWell(
      onTap: () {
        Get.toNamed("user");
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: UserAvarta(user: {
          "ten": Golbal.store.user["fname"],
          "fullName": Golbal.store.user["FullName"],
          "anhThumb": Golbal.store.user["Avartar"]
        }, radius: 20, color: const Color(0xFFAFDFCF)),
      ),
    );
  }
}
