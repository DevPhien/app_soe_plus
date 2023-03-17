import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:soe/utils/golbal/golbal.dart';
import 'package:soe/views/component/use/avatar.dart';

import '../lichfiltercontroller.dart';

class FilterLich extends StatelessWidget {
  final FilterLichController controller = Get.put(FilterLichController());
  FilterLich({
    Key? key,
  }) : super(key: key);
  //Function

  Widget itemPhong(item) {
    return ListTile(
      onTap: () {
        controller.setPhonghop(item);
      },
      title: Text(item["Diadiem_Ten"]),
      trailing: item["chon"] == true
          ? Icon(Feather.check, color: Golbal.appColor)
          : null,
    );
  }

  Widget phonghop() {
    return Obx(() => ExpansionTile(
          leading: const Icon(MaterialCommunityIcons.google_classroom),
          title: const Text(
            "Chọn phòng họp",
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          ),
          children: controller.phonghops.map((e) => itemPhong(e)).toList(),
        ));
  }

  Widget itemCongty(item) {
    return ListTile(
      onTap: () {
        controller.setCongty(item);
      },
      title: Text(item["tenCongty"]),
      trailing: item["chon"] == true
          ? Icon(Feather.check, color: Golbal.appColor)
          : null,
    );
  }

  Widget congty() {
    return Obx(() => ExpansionTile(
          leading: const Icon(FontAwesome.building_o),
          title: const Text(
            "Chọn đơn vị",
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          ),
          children: controller.congtys.map((e) => itemCongty(e)).toList(),
        ));
  }

  Widget itemLanhdao(item) {
    return ListTile(
      onTap: () {
        controller.setLanhdao(item);
      },
      leading: UserAvarta(user: item),
      title: Text(item["fullName"]),
      trailing: item["chon"] == true
          ? Icon(Feather.check, color: Golbal.appColor)
          : null,
    );
  }

  Widget lanhdao() {
    return Obx(() => ExpansionTile(
          leading: const Icon(FontAwesome.user_circle),
          title: const Text(
            "Chọn lãnh đạo",
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          ),
          children: controller.lanhdaos.map((e) => itemLanhdao(e)).toList(),
        ));
  }

  Widget itemTrangthai(item) {
    return ListTile(
      title: Text(item["text"]),
      trailing: item["chon"] == true
          ? Icon(Feather.check, color: Golbal.appColor)
          : null,
      onTap: () {
        controller.setTrangthai(item);
      },
    );
  }

  Widget trangthai() {
    return Obx(() => ExpansionTile(
          leading: const Icon(FontAwesome.user_circle),
          title: const Text(
            "Chọn loại lịch",
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          ),
          children: controller.trangthais.map((e) => itemTrangthai(e)).toList(),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          return true;
        },
        child: MediaQuery(
            data: MediaQuery.of(context)
                .copyWith(textScaleFactor: Golbal.textScaleFactor),
            child: Scaffold(
              backgroundColor: const Color(0xffffffff),
              appBar: AppBar(
                backgroundColor: Golbal.appColorD,
                elevation: 1.0,
                iconTheme: IconThemeData(color: Golbal.iconColor),
                title: Text("Lọc kết quả",
                    style: TextStyle(
                        color: Golbal.titleappColor,
                        fontWeight: FontWeight.bold)),
                centerTitle: true,
                actions: [
                  IconButton(
                      onPressed: controller.clearAdv,
                      icon: const Icon(Ionicons.refresh_circle_outline))
                ],
                systemOverlayStyle: Golbal.systemUiOverlayStyle,
              ),
              body: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                      child: SingleChildScrollView(
                    child: Column(
                      children: [
                        congty(),
                        phonghop(),
                        Obx(() => controller.model["pageIndex"] == 1
                            ? lanhdao()
                            : const SizedBox.shrink()),
                        Obx(() => controller.model["pageIndex"] == 2
                            ? trangthai()
                            : const SizedBox.shrink())
                      ],
                    ),
                  )),
                  const SizedBox(height: 20),
                  SafeArea(
                    child: Center(
                      child: Container(
                        width: Golbal.screenSize.width - 50,
                        height: 70,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        child: ElevatedButton.icon(
                          icon: const Icon(Feather.search),
                          onPressed: () {
                            controller.apDung();
                          },
                          label: const Text("Áp dụng",
                              style: TextStyle(color: Colors.white)),
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                                Golbal.appColor),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )));
  }
}
