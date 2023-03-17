import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:soe/views/component/use/inlineloadding.dart';

import '../../controller/phonebook/phonebookcontroller.dart';
import 'itemphonebook.dart';

class PhoneBookCard extends StatelessWidget {
  final PhoneBookController controller = Get.put(PhoneBookController());

  PhoneBookCard({Key? key}) : super(key: key);

  Widget itemFavoritesCard(context, i) =>
      ItemPhoneBook(user: controller.phonebook_datas[i], index: i);

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => !controller.loading.value && controller.phonebook_datas.isNotEmpty
          ? ListView.separated(
              shrinkWrap: true,
              padding: const EdgeInsets.all(0),
              physics: const BouncingScrollPhysics(),
              itemBuilder: itemFavoritesCard,
              itemCount: controller.phonebook_datas.length,
              separatorBuilder: (_, __) => const Divider(
                height: 1,
                color: Color(0xffeeeeee),
              ),
            )
          : !controller.loading.value
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Center(
                      child: Image.asset("assets/nochat.png"),
                    ),
                    const SizedBox(height: 10.0),
                    const Text(
                      "Hiện chưa có người dùng nào",
                      style: TextStyle(
                        color: Colors.black45,
                      ),
                    ),
                  ],
                )
              : const InlineLoadding(),
    );
  }
}
