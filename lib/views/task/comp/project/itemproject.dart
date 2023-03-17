// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:date_time_format/date_time_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:soe/views/task/comp/itemthanhvien.dart';
import 'package:soe/views/task/comp/project/statusproject.dart';

class ItemProject extends StatelessWidget {
  final project;
  final onClick;
  const ItemProject({Key? key, this.project, this.onClick}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color han = Colors.black87;
    if (project["ngayHanXL"] != null) {
      if (project["ngayHanXL"] < 0) {
        han = Colors.redAccent;
      }
    }
    return InkWell(
      onTap: () {
        onClick(project);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Wrap(
                    children: [
                      Text(
                        project["TenDuan"] ?? "",
                        style: TextStyle(
                          color: han,
                        ),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  if (project["NgayBatDau"] != null)
                    Row(
                      children: [
                        if (project["IsQH"] == true)
                          Icon(
                            AntDesign.clockcircle,
                            color: han,
                            size: 12,
                          ),
                        if (project["IsQH"] != true)
                          Icon(
                            AntDesign.clockcircleo,
                            color: han,
                            size: 12,
                          ),
                        const SizedBox(width: 5),
                        Text(
                          "${project["NgayBatDau"] != null ? DateTimeFormat.format(DateTime.parse(project["NgayBatDau"]), format: 'H:i d/m/Y').replaceAll("00:00", "") : ""} ${project["NgayKetThuc"] != null ? " - " + DateTimeFormat.format(DateTime.parse(project["NgayKetThuc"]), format: 'H:i d/m/Y').replaceAll("00:00", "") : ""}",
                          style: TextStyle(
                              color: han.withOpacity(0.5), fontSize: 12.0),
                        ),
                        const Spacer(),
                        const SizedBox(width: 5),
                        Column(
                          children: [
                            StatusProject(project: project),
                          ],
                        ),
                      ],
                    ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      if (project["Thanhviens"].isNotEmpty) ...[
                        Expanded(
                          child: ThanhVienTask(
                            thanhviens: project["Thanhviens"],
                            showMore: true,
                          ),
                        ),
                        Expanded(
                          child: Wrap(
                            children: [
                              Icon(
                                MaterialIcons.playlist_add_check,
                                size: 20,
                                color: Colors.black.withOpacity(0.5),
                              ),
                              const SizedBox(width: 5.0),
                              Text(
                                "${project["hoanthanh"]}/${project["socongviec"]}",
                                style: TextStyle(
                                  color: Colors.black.withOpacity(0.5),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Wrap(
                          children: [
                            Icon(
                              Feather.paperclip,
                              size: 14,
                              color: Colors.black.withOpacity(0.5),
                            ),
                            const SizedBox(width: 5.0),
                            Text(
                              "${project["files"]}",
                              style: TextStyle(
                                color: Colors.black.withOpacity(0.5),
                              ),
                            ),
                            const SizedBox(width: 5.0),
                            Icon(
                              Feather.message_circle,
                              size: 14,
                              color: Colors.black.withOpacity(0.5),
                            ),
                            const SizedBox(width: 5.0),
                            Text(
                              "${project["comments"]}",
                              style: TextStyle(
                                color: Colors.black.withOpacity(0.5),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
