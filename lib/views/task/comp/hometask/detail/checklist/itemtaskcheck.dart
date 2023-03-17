import 'package:date_time_format/date_time_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:soe/utils/golbal/golbal.dart';
import 'package:soe/views/task/comp/hometask/detail/checklist/checklistcontroller.dart';

import '../../../itemthanhvien.dart';

class ItemTaskCheck extends StatelessWidget {
  final CheckListTaskController clcontroller =
      Get.put(CheckListTaskController());
  final dynamic task;
  final Function onClick;
  final Function onCheck;

  ItemTaskCheck(
      {Key? key, this.task, required this.onClick, required this.onCheck})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    bool isQuyen = clcontroller.controller.task["isgiaoviec"] == true ||
        (clcontroller.controller.task["isthuchien"] == true &&
            task["NguoiTao"] == Golbal.store.user["user_id"]);
    var thanhviens = [
      {
        "anhThumb": task["anhThumb"],
        "ten": task["ten"],
        "fullName": task["fullName"]
      },
    ];
    if (task["ten_ngcheck"] != null) {
      thanhviens.add({
        "anhThumb": task["anhThumb_ngcheck"],
        "ten": task["ten_ngcheck"],
        "fullName": task["fullName_ngcheck"]
      });
    }
    return InkWell(
      onTap: () {
        onClick(task);
      },
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Align(
            alignment: Alignment.topLeft,
            child: Checkbox(
              value: task["IsCheck"],
              activeColor: const Color(0xFF04D215),
              onChanged: (v) {
                onCheck(task, v);
              },
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(task["CongviecTen"] ?? "",
                    style: TextStyle(
                        color: task["IsCheck"] == true
                            ? const Color(0xFF04D215)
                            : Colors.black87,
                        decoration: task["IsCheck"] == true
                            ? TextDecoration.lineThrough
                            : TextDecoration.none)),
                const SizedBox(height: 5),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                      child: ThanhVienTask(
                        thanhviens: thanhviens,
                        showMore: true,
                      ),
                    ),
                    if (task["Uutien"] == true) ...[
                      Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 0.0, horizontal: 0.0),
                        child: const Icon(Icons.star, color: Colors.orange),
                      ),
                    ],
                    if (task["NgayTao"] != null) ...[
                      Row(
                        children: [
                          if (task["IsQH"] == 1)
                            const Icon(AntDesign.clockcircle,
                                color: Colors.red, size: 12),
                          if (task["IsQH"] != 1)
                            const Icon(AntDesign.clockcircleo,
                                color: Colors.black38, size: 12),
                          const SizedBox(width: 5),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 10.0),
                            child: Text(
                              DateTimeFormat.format(
                                      DateTime.parse(task["NgayTao"]),
                                      format: 'd/m/Y H:i')
                                  .replaceAll("00:00", ""),
                              style: TextStyle(
                                  fontSize: 13.0,
                                  color: task["IsQH"] == 1
                                      ? Colors.red
                                      : Colors.black54),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
          if (isQuyen) ...[
            const SizedBox(width: 10),
            Row(
              children: [
                const SizedBox(width: 10),
                InkWell(
                  onTap: () {
                    clcontroller.openModalTodo(context, todo: task);
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
                    clcontroller.deleteTodo(context, task);
                  },
                  child: const Icon(
                    Feather.trash,
                    color: Colors.black38,
                    size: 16,
                  ),
                ),
              ],
            ),
            const SizedBox(width: 15),
          ],
        ],
      ),
    );
  }
}
