import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:soe/utils/golbal/golbal.dart';
import 'package:soe/views/task/comp/hometask/detail/checklist/checklistcontroller.dart';

import 'itemtaskcheck.dart';

class ItemCheckList extends StatelessWidget {
  final CheckListTaskController clcontroller =
      Get.put(CheckListTaskController());
  final dynamic item;
  final dynamic loadFile;
  final Function onClick;
  final Function onCheck;
  final Function()? onToggle;

  ItemCheckList(
      {Key? key,
      this.item,
      this.loadFile,
      required this.onClick,
      required this.onCheck,
      required this.onToggle})
      : super(key: key);

  //Function
  @override
  Widget build(BuildContext context) {
    bool isQuyen = clcontroller.controller.task["isgiaoviec"] == true ||
        (clcontroller.controller.task["isthuchien"] == true &&
            item["NguoiTao"] == Golbal.store.user["user_id"]);
    var tasks = List.castFrom(item["tasks"]);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.all(5),
          color: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          child: Row(
            children: [
              Expanded(
                child: InkWell(
                  onTap: onToggle,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(
                          item["isopen"] != false
                              ? Entypo.chevron_down
                              : Entypo.chevron_right,
                          color: Colors.black38,
                          size: 16),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          "${item["TenChecklist"] ?? ""} (${tasks.length})",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF045997),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (isQuyen) ...[
                const SizedBox(width: 10),
                InkWell(
                  onTap: () {
                    clcontroller.openModalChecklist(context, checklist: item);
                  },
                  child: const Icon(
                    Feather.edit,
                    color: Colors.black38,
                    size: 16,
                  ),
                ),
                const SizedBox(width: 10),
                InkWell(
                  onTap: () {
                    clcontroller.deleteChecklist(context, item);
                  },
                  child: const Icon(
                    Feather.trash,
                    color: Colors.black38,
                    size: 16,
                  ),
                ),
              ],
            ],
          ),
        ),
        if (item["isopen"] != false && tasks.isNotEmpty) ...[
          ListView.builder(
            shrinkWrap: true,
            padding: const EdgeInsets.symmetric(horizontal: 0.0),
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (ct, i) => ItemTaskCheck(
                task: tasks[i], onClick: onClick, onCheck: onCheck),
            itemCount: tasks.length,
          ),
        ],
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (isQuyen) ...[
              TextButton(
                onPressed: () {
                  clcontroller.openModalTodo(context, checklist: item);
                },
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: const <Widget>[
                    Icon(
                      Feather.plus_circle,
                      color: Colors.black38,
                      size: 16,
                    ),
                    SizedBox(width: 10),
                    Text("Thêm công việc Checklist"),
                  ],
                ),
              ),
            ],
          ],
        ),
      ],
    );
  }
}
