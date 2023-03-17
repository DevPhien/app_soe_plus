import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:soe/views/component/use/inlineloadding.dart';

import '../../controller/favorites/favoritescontroller.dart';
import 'itemfavorites.dart';

class FavoritesCard extends StatelessWidget {
  final FavoritesController controller = Get.put(FavoritesController());

  FavoritesCard({Key? key}) : super(key: key);

  Widget itemFavoritesCard(context, i) =>
      ItemFavorites(user: controller.datas[i]);

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => !controller.loading.value && controller.datas.isNotEmpty
          ? ListView.separated(
              shrinkWrap: true,
              padding: const EdgeInsets.all(0),
              physics: const BouncingScrollPhysics(),
              itemBuilder: itemFavoritesCard,
              itemCount: controller.datas.length,
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
                      "Hiện chưa có người yêu thích nào",
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
