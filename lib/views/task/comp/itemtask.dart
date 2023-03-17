import 'package:date_time_format/date_time_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';

import 'itemthanhvien.dart';
import 'trangthaitask.dart';

class ItemTask extends StatelessWidget {
  final dynamic task;
  final Function onClick;

  const ItemTask({Key? key, this.task, required this.onClick})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onClick(task);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (task["IsHT"] == 1)
              const Icon(MaterialCommunityIcons.check_circle,
                  color: Color(0xFF04D215)),
            if (task["IsHT"] != 1)
              const Icon(MaterialCommunityIcons.checkbox_blank_circle_outline,
                  color: Colors.black38),
            const SizedBox(width: 10),
            Expanded(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(task["CongviecTen"] ?? "",
                    style: TextStyle(
                        color: task["IsHT"] == 1
                            ? const Color(0xFF04D215)
                            : Colors.black87,
                        decoration: task["IsHT"] == 1
                            ? TextDecoration.lineThrough
                            : TextDecoration.none)),
                const SizedBox(height: 5),
                Row(
                  children: [
                    if (task["NgayBatDau"] != null) ...[
                      if (task["IsQH"] == 1)
                        const Icon(AntDesign.clockcircle,
                            color: Colors.red, size: 12),
                      if (task["IsQH"] != 1)
                        const Icon(AntDesign.clockcircleo,
                            color: Colors.black38, size: 12),
                      const SizedBox(width: 5),
                      Text(
                          DateTimeFormat.format(
                                  DateTime.parse(task["NgayBatDau"]),
                                  format: 'd/m/Y H:i')
                              .replaceAll("00:00", ""),
                          style: TextStyle(
                              fontSize: 13.0,
                              color: task["IsQH"] == 1
                                  ? Colors.red
                                  : Colors.black54)),
                    ],
                    const Spacer(),
                    const SizedBox(width: 5),
                    Column(
                      children: [
                        TrangthaiTask(tttask: task),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                Row(
                  children: [
                    Expanded(
                      child: ThanhVienTask(
                        thanhviens: task["Thanhviens"],
                        showMore: true,
                      ),
                    ),
                    if (task["Uutien"] == true) ...[
                      Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 0.0),
                          child: const Icon(Icons.star, color: Colors.orange))
                    ],
                    if (task["Baomat"] == true) ...[
                      const SizedBox(width: 10),
                      Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 0.0),
                          child: const Icon(Feather.flag, color: Colors.red))
                    ],
                  ],
                ),
              ],
            )),
          ],
        ),
      ),
    );
  }
}
