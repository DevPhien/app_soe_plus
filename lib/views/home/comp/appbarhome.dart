import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../utils/golbal/golbal.dart';
import '../../component/use/avatar.dart';

class AppBarHome extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  const AppBarHome({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(context) {
    return AppBar(
      elevation: 0.0,
      titleSpacing: 10.0,
      backgroundColor: Colors.white,
      title: Text(title,
          style: const TextStyle(
              color: Color(0xFF0186f8),
              fontWeight: FontWeight.bold,
              fontSize: 24.0)),
      actions: <Widget>[
        InkWell(
          onTap: () {
            Get.toNamed("user");
          },
          child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: UserAvarta(user: {
                "ten": Golbal.store.user["fname"],
                "fullName": Golbal.store.user["FullName"],
                "anhThumb": Golbal.store.user["Avartar"]
              }, radius: 20, color: const Color(0xFFAFDFCF))),
        )
      ],
      centerTitle: false,
      systemOverlayStyle: SystemUiOverlayStyle.dark,
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => const Size.fromHeight(56);
}
