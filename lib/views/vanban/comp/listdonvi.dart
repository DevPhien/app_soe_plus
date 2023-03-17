import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import '../../../utils/golbal/golbal.dart';
import '../../component/use/inlineloadding.dart';
import '../../component/use/itemdonvichon.dart';
import '../controller/donvicontroller.dart';

class ListDonvi extends StatelessWidget {
  final DonviController controller = Get.put(DonviController());
  ListDonvi({
    Key? key,
  }) : super(key: key);
  Widget widgetListDonvi() {
    return ListView.separated(
      itemCount: controller.donvis.length,
      itemBuilder: (ct, i) => ItemDonviChon(
          donvi: controller.donvis[i],
          one: false,
          onClick: controller.onChangeDonvi),
      separatorBuilder: (ct, i) => const Divider(height: 1),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
        data: MediaQuery.of(context)
            .copyWith(textScaleFactor: Golbal.textScaleFactor),
        child: Scaffold(
          backgroundColor: const Color(0xffffffff),
          appBar: AppBar(
            backgroundColor: Golbal.appColorD,
            elevation: 1.0,
            iconTheme: IconThemeData(color: Golbal.iconColor),
            title: Container(
              width: double.infinity,
              height: 40,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: const Color(0xFFf9f8f8),
                  border:
                      Border.all(color: const Color(0xffeeeeee), width: 1.0)),
              child: Center(
                child: TextField(
                  onSubmitted: controller.searchDonvi,
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.all(5),
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    border: InputBorder.none,
                    hintText: 'Tìm kiếm',
                    prefixIcon: Icon(Icons.search),
                  ),
                ),
              ),
            ),
            actions: [
              Obx(() => controller.isChon.value > 0
                  ? Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton.icon(
                        onPressed: () {
                          controller.onChonDonvi(true);
                        },
                        icon: const Icon(
                          Ionicons.checkbox_outline,
                          color: Colors.white,
                        ),
                        label: Text(
                            "Chọn (${controller.isChon.value.toString()})",
                            style: const TextStyle(color: Colors.white)),
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all<Color>(Golbal.appColor),
                        ),
                      ),
                    )
                  : const SizedBox.shrink())
            ],
            centerTitle: true,
            systemOverlayStyle: Golbal.systemUiOverlayStyle,
          ),
          body: Obx(() =>
              controller.donvis.isEmpty || controller.isloadding.value
                  ? const InlineLoadding()
                  : widgetListDonvi()),
        ));
  }
}
