import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class TrangthaiTask extends StatelessWidget {
  final dynamic tttask;

  const TrangthaiTask({Key? key, this.tttask}) : super(key: key);
  Widget renderLableVanban() {
    if (tttask["giahan"] != null && tttask["giahan"] > 0) {
      Widget label = Container(
        decoration: BoxDecoration(
            color: HexColor("#F2A93B"),
            borderRadius: BorderRadius.circular(5.0)),
        padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
        child: Text(
          "Xin gia hạn",
          style: TextStyle(
              fontSize: 12.0,
              fontWeight: FontWeight.w500,
              color: HexColor("#FFFFFF")),
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.justify,
        ),
      );
      return label;
    }
    var arrTrangthais = [
      {
        "id": "0",
        "name": "Chưa bắt đầu",
        "bg_color": "#bbbbbb",
        "text_color": "#FFFFFF"
      },
      {
        "id": "1",
        "name": "Đang làm",
        "bg_color": "#2196f3",
        "text_color": "#FFFFFF"
      },
      {
        "id": "2",
        "name": "Tạm ngừng",
        "bg_color": "#d87777",
        "text_color": "#FFFFFF"
      },
      {
        "id": "3",
        "name": "Đã đóng",
        "bg_color": "#d87777",
        "text_color": "#FFFFFF"
      },
      {
        "id": "4",
        "name": "HT đúng hạn",
        "bg_color": "#04D215",
        "text_color": "#FFFFFF"
      },
      {
        "id": "5",
        "name": "Chờ đánh giá",
        "bg_color": "#33c9dc",
        "text_color": "#FFFFFF"
      },
      {
        "id": "6",
        "name": "Bị trả lại",
        "bg_color": "#ffa500",
        "text_color": "#FFFFFF"
      },
      {
        "id": "7",
        "name": "HT sau hạn",
        "bg_color": "#ff8b4e",
        "text_color": "#FFFFFF"
      },
      {
        "id": "8",
        "name": "Đã đánh giá",
        "bg_color": "#51b7ae",
        "text_color": "#FFFFFF"
      },
    ];
    String id = tttask["Trangthai"].toString();
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
    return renderLableVanban();
  }
}
