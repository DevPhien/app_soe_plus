import 'package:debouncer_widget/debouncer_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:soe/views/component/use/inlineloadding.dart';

import '../../../../utils/golbal/golbal.dart';
import 'caymohinhcontroller.dart';

class CayMohinh extends StatelessWidget {
  CayMohinh({Key? key, required this.isone}) : super(key: key);
  final bool isone;
  final CaymohinhController controller = Get.put(CaymohinhController());
  //Function
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                border: Border.all(color: const Color(0xffeeeeee), width: 1.0)),
            child: Center(
                child: Debouncer(
              action: () {
                controller.search();
              },
              builder: (newContext, _) => TextField(
                onChanged: (String? s) {
                  controller.s = s ?? "";
                  Debouncer.execute(newContext);
                },
                onSubmitted: (String? s) {
                  controller.search(ss: s);
                },
                decoration: const InputDecoration(
                  contentPadding: EdgeInsets.all(5),
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  border: InputBorder.none,
                  hintText: 'Tìm kiếm',
                  prefixIcon: Icon(Icons.search),
                ),
              ),
            )),
          ),
          actions: const [
            // Obx(() => controller.isChon.value > 0
            //     ? Padding(
            //         padding: const EdgeInsets.all(8.0),
            //         child: ElevatedButton.icon(
            //           onPressed: () {
            //             controller.onChonUser(true);
            //           },
            //           icon: const Icon(
            //             Ionicons.checkbox_outline,
            //             color: Colors.white,
            //           ),
            //           label: Text("Chọn (${controller.isChon.value.toString()})",
            //               style: const TextStyle(color: Colors.white)),
            //           style: ButtonStyle(
            //             backgroundColor:
            //                 MaterialStateProperty.all<Color>(Golbal.appColor),
            //           ),
            //         ),
            //       )
            //     : const SizedBox.shrink())
          ],
          centerTitle: true,
          systemOverlayStyle: Golbal.systemUiOverlayStyle,
        ),
        body: Obx(() => controller.isloadding.value
            ? const InlineLoadding()
            : GroupedListView<dynamic, String>(
                elements: controller.mohinhs,
                groupBy: (element) => element['Congty_ID'],
                groupSeparatorBuilder: (String groupByValue) =>
                    Text(groupByValue),
                groupHeaderBuilder: (dynamic element) => Container(
                  padding: const EdgeInsets.all(10),
                  color: const Color(0xFFeeeeee),
                  child: Row(
                    children: [
                      Icon(Ionicons.people_outline, color: Golbal.titleColor),
                      const SizedBox(width: 5.0),
                      Expanded(
                          child: Text(
                        element['tenCongty'] ?? "",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Golbal.titleColor),
                      )),
                    ],
                  ),
                ),
                itemBuilder: (context, dynamic element) => ListTile(
                  onTap: () {
                    controller.chonPB(element);
                  },
                  title: Text(element["tenPhongban"] ?? ""),
                  trailing: element["chon"] == true
                      ? const Icon(Ionicons.checkmark_done_outline,
                          color: Colors.green)
                      : null,
                ),
                itemComparator: (item1, item2) => item1['thutuCongty']
                    .compareTo(item2['thutuCongty']), // optional
                useStickyGroupSeparators: true, // optional
                floatingHeader: false, // optional
                order: GroupedListOrder.ASC, // optional
              )));
  }
}
