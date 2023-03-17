import 'package:date_time_format/date_time_format.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:soe/utils/golbal/golbal.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../../component/use/avatar.dart';
import '../controller/csinhnhatcontroller.dart';

class HomeSinhNhat extends StatelessWidget {
  final HomeSinhNhatController controller = Get.put(HomeSinhNhatController());

  HomeSinhNhat({Key? key}) : super(key: key);

  Widget itemMenu(ct, i) {
    var u = controller.datas[i];
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5.0),
      child: Row(
        children: <Widget>[
          UserAvarta(
            user: u,
            radius: 20,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Text("${u["fullName"] ?? ""}",
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                    Text(
                        " (${DateTimeFormat.format(DateTime.parse(u["ngaySinh"]), format: 'd/m')})",
                        style: const TextStyle(
                            fontSize: 13.0, color: Colors.black54))
                  ],
                ),
                Text(
                    "${u["phone"] ?? ""}${u["phone"] != null && u["tenChucVu"] != null ? " | " : ""}${u["tenChucVu"] ?? ""}",
                    style: const TextStyle(fontSize: 13.0))
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget widgetMenu() {
    return SizedBox(
      width: double.infinity,
      height: 80 * Golbal.textScaleFactor,
      child: Obx(() => controller.datas.isNotEmpty
          ? ListView.builder(
              itemBuilder: itemMenu,
              physics: const BouncingScrollPhysics(),
              itemCount: controller.datas.length,
              padding: const EdgeInsets.only(top: 10, bottom: 0, left: 10),
              scrollDirection: Axis.horizontal)
          : Container()),
    );
  }

  @override
  Widget build(context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 5),
          Text(
            "Truyền thông/Sự kiện",
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 17,
                color: Golbal.titleColor),
          ),
          InkWell(
            onTap: () {
              Get.toNamed("event");
            },
            child: Row(
              children: [
                Stack(
                  children: [
                    Align(
                      alignment: Alignment.topCenter,
                      child: Image.asset("assets/CMSN.png",
                          fit: BoxFit.contain, height: 48.0),
                    ),
                    Positioned(
                      top: 0.0,
                      right: 0.0,
                      child: SpinKitRipple(
                          size: 20.0,
                          duration: const Duration(milliseconds: 1200),
                          color: Colors.red.withOpacity(1)),
                    )
                  ],
                ),
                Expanded(child: widgetMenu()),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
