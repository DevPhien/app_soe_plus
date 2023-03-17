import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';

import '../../../../../component/use/inlineloadding.dart';
import 'checklistcontroller.dart';
import 'itemchecklist.dart';

class CheckListTask extends StatelessWidget {
  CheckListTask({Key? key}) : super(key: key);
  final CheckListTaskController cmcontroller =
      Get.put(CheckListTaskController());
  @override
  Widget build(BuildContext context) {
    bool isQuyen = cmcontroller.controller.task["isgiaoviec"] == true ||
        cmcontroller.controller.task["isthuchien"] == true;
    TextStyle label = const TextStyle(color: Colors.black87, fontSize: 13);
    return Obx(
      () => Container(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(MaterialCommunityIcons.format_list_checkbox,
                    size: 14),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    "CheckList (${cmcontroller.checklists.length})",
                    style: label,
                    textAlign: TextAlign.justify,
                  ),
                ),
                if (isQuyen)
                  IconButton(
                    onPressed: () {
                      cmcontroller.openModalChecklist(context);
                    },
                    icon: const Icon(Ionicons.add_circle_outline,
                        color: Colors.black54),
                  ),
              ],
            ),
            Container(
              decoration: const BoxDecoration(color: Colors.white),
              child: Column(
                children: <Widget>[
                  if (cmcontroller.isloadding.value) ...[
                    const InlineLoadding(),
                  ] else ...[
                    ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: cmcontroller.checklists.length,
                      itemBuilder: (ct, i) => ItemCheckList(
                        item: cmcontroller.checklists[i],
                        onClick: cmcontroller.onClickTask,
                        onCheck: cmcontroller.onCheckTask,
                        onToggle: () {
                          cmcontroller.onToggle(cmcontroller.checklists[i]);
                        },
                      ),
                    ),
                  ],
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
