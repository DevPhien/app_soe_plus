import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:soe/utils/golbal/golbal.dart';
import 'package:soe/views/request/comp/homerequest/detail/detailrequestcontroller.dart';
import 'package:soe/views/request/comp/homerequest/detail/form/inputdatatype.dart';

class InputColumn extends StatelessWidget {
  final DetailRequestController controller = Get.put(DetailRequestController());
  final dynamic input;
  final bool? isview;
  InputColumn({Key? key, this.input, this.isview}) : super(key: key);

  Widget tableWidget(d, dynamic sttrows) {
    Widget childW = const SizedBox.shrink();
    var fds = controller.formD
        .where((e) => e["IsParent_ID"] == d["FormD_ID"])
        .toList();
    if (fds.isEmpty) {
      return const SizedBox.shrink();
    }
    List heads = fds.where((x) => x["STTRow"] == null).toList();
    List rows = fds.where((x) => x["STTRow"] != null).toList();
    if (sttrows.length == 0) {
      sttrows.add(0);
    }
    var table = DataTable(
      dataRowHeight: 80,
      horizontalMargin: 0,
      columnSpacing: 10,
      headingTextStyle: TextStyle(color: Golbal.appColor),
      columns:
          heads.map((td) => DataColumn(label: Text(td["TenTruong"]))).toList()
            ..insert(0, const DataColumn(label: Text(""))),
      rows: List.castFrom(sttrows)
          .map(
            (tr) => DataRow(
              cells: rows
                  .where((x) => x["STTRow"] == tr)
                  .map(
                    (e) => DataCell(
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: InputDataType(input: e),
                        constraints: const BoxConstraints(minWidth: 150),
                      ),
                    ),
                  )
                  .toList()
                ..insert(
                  0,
                  DataCell(
                    sttrows.length > 1
                        ? IconButton(
                            icon: const Icon(EvilIcons.trash),
                            onPressed: () {
                              sttrows.remove(tr);
                              controller.formD
                                  .removeWhere((e) => e["STTRow"] == tr);
                              controller.ctrrows.add(sttrows);
                            },
                          )
                        : const SizedBox.shrink(),
                  ),
                ),
            ),
          )
          .toList(),
    );
    childW = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                "${d["TenTruong"] ?? ""}",
                style: const TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.blue),
              ),
            ),
            IconButton(
              icon: Icon(
                AntDesign.pluscircleo,
                color: Golbal.appColor,
                size: 16,
              ),
              onPressed: () {
                controller.addRowInTable(sttrows, heads);
              },
            ),
          ],
        ),
        SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Container(child: table),
          ),
        ),
      ],
    );
    return childW;
  }

  Widget inputColumn() {
    if (input["IsLength"] == null || input["IsLength"] == 0) {
      input["IsLength"] = 500;
    }
    if (input["IsLabel"] == true &&
        input["KieuTruong"] != "checkbox" &&
        input["KieuTruong"] != "radio") {
      if (input["IsType"] == 3) {
        //Table
        return StreamBuilder<List<int>>(
          stream: controller.ctrrows.stream,
          builder: (context, AsyncSnapshot<List<int>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting ||
                !snapshot.hasData) {
              var sttrows = controller.formD
                  .where((e) => e["IsParent_ID"] == input["FormD_ID"])
                  .map((e) => int.tryParse((e["STTRow"] ?? 0).toString()))
                  .toSet()
                  .toList();
              sttrows.sort();
              return tableWidget(input, sttrows);
            } else {
              return tableWidget(input, snapshot.data!);
            }
          },
        );
      }
    }
    return InputDataType(input: input, isview: isview);
  }

  @override
  Widget build(BuildContext context) {
    TextStyle sao = const TextStyle(
      color: Colors.red,
      fontSize: 13,
      fontWeight: FontWeight.w500,
    );
    Widget breakRow = const SizedBox(height: 10.0);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        if (input["IsType"] != 3 && input["TenTruong"] != null) ...[
          Row(
            children: [
              if (input["IsLabel"] == true) ...[
                Text(
                  "${input["TenTruong"] ?? ""}",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                )
              ] else ...[
                Text(
                  "${input["TenTruong"] ?? ""}",
                  style: Golbal.stylelabel,
                ),
              ],
              if (isview != true && input["IsRequired"] == true) ...[
                Text(" (*)", style: sao),
              ],
            ],
          ),
        ],
        breakRow,
        inputColumn(),
        breakRow,
      ],
    );
  }
}
