import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class StatusProject extends StatelessWidget {
  final dynamic project;

  const StatusProject({Key? key, this.project}) : super(key: key);
  Widget renderLable() {
    var arrTrangthais = [
      {
        "id": "0",
        "name": "Đang lập kế hoạch",
        "bg_color": "#bbbbbb",
        "text_color": "#FFFFFF"
      },
      {
        "id": "1",
        "name": "Đang thực hiện",
        "bg_color": "#2196f3",
        "text_color": "#FFFFFF"
      },
      {
        "id": "2",
        "name": "Hoàn thành",
        "bg_color": "#6dd230",
        "text_color": "#FFFFFF"
      },
      {
        "id": "3",
        "name": "Tạm dừng",
        "bg_color": "#f17ac7",
        "text_color": "#FFFFFF"
      },
      {
        "id": "4",
        "name": "Đóng",
        "bg_color": "#d87777",
        "text_color": "#FFFFFF"
      },
    ];
    String id =
        project["Trangthai"] != null ? project["Trangthai"].toString() : "0";
    var objTrangthai =
        arrTrangthais.firstWhere((element) => element["id"] == id);
    String name = objTrangthai["name"] ?? "";
    Widget label = Container(
      decoration: BoxDecoration(
          color: HexColor(objTrangthai["bg_color"].toString()),
          borderRadius: BorderRadius.circular(5.0)),
      padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
      child: Text(
        name,
        style: TextStyle(
            fontSize: 12.0,
            fontWeight: FontWeight.w500,
            color: HexColor(objTrangthai["text_color"].toString())),
        overflow: TextOverflow.ellipsis,
        textAlign: TextAlign.justify,
      ),
    );

    return label;
  }

  //Function
  @override
  Widget build(BuildContext context) {
    return renderLable();
  }
}
