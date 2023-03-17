import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class TrangthaiXe extends StatelessWidget {
  final dynamic tttask;
  final bool isphieu;

  const TrangthaiXe({Key? key, this.tttask, required this.isphieu})
      : super(key: key);
  Widget renderLableVanban() {
    var arrTrangthais = [];
    if (isphieu) {
      arrTrangthais = [
        {
          "id": "duthao",
          "name": "Dự thảo",
          "bg_color": "#f2f4f6",
          "text_color": "#000000"
        },
        {
          "id": "choduyet",
          "name": "Chờ duyệt",
          "bg_color": "#2196f3",
          "text_color": "#FFFFFF"
        },
        {
          "id": "daduyet",
          "name": "Đã duyệt",
          "bg_color": "#6dd230",
          "text_color": "#FFFFFF"
        },
        {
          "id": "tralai",
          "name": "Trả lại",
          "bg_color": "#ff0000",
          "text_color": "#FFFFFF"
        },
        {
          "id": "huylenh",
          "name": "Huỷ lệnh",
          "bg_color": "#ff0000",
          "text_color": "#FFFFFF"
        }
      ];
    } else {
      arrTrangthais = [
        {
          "id": "duyetphieu",
          "name": "Duyệt phiếu",
          "bg_color": "#f2f4f6",
          "text_color": "#333333"
        },
        {
          "id": "laplenh",
          "name": "Lập lệnh",
          "bg_color": "#ade7d4",
          "text_color": "#333333"
        },
        {
          "id": "huylenh",
          "name": "Huỷ lệnh",
          "bg_color": "#ff0000",
          "text_color": "#FFFFFF"
        },
        {
          "id": "tralai",
          "name": "Trả lại",
          "bg_color": "#ff0000",
          "text_color": "#FFFFFF"
        },
        {
          "id": "lenhthay",
          "name": "Lệnh thay",
          "bg_color": "#9fb5ca",
          "text_color": "#FFFFFF"
        },
        {
          "id": "choduyet",
          "name": "Chờ duyệt",
          "bg_color": "#6dbeff",
          "text_color": "#FFFFFF"
        },
        {
          "id": "lenhbithay",
          "name": "Lệnh bị thay",
          "bg_color": "#ff8d00",
          "text_color": "#FFFFFF"
        },
        {
          "id": "chohoanthanh",
          "name": "Chờ hoàn thành",
          "bg_color": "#2196f3",
          "text_color": "#FFFFFF"
        },
        {
          "id": "hoanthanh",
          "name": "Hoàn thành",
          "bg_color": "#6dd230",
          "text_color": "#FFFFFF"
        }
      ];
    }
    String? id = tttask[isphieu ? "PhieuDX_Trangthai" : "LenhDX_Trangthai"];
    var objTrangthai = arrTrangthais
        .firstWhere((element) => element["id"] == id, orElse: () => null);
    if (objTrangthai == null) {
      return const SizedBox.shrink();
    }
    String name = objTrangthai["name"] ?? "";
    Widget label = Container(
      decoration: BoxDecoration(
          color: HexColor(objTrangthai["bg_color"].toString()),
          borderRadius: BorderRadius.circular(5.0)),
      padding: const EdgeInsets.symmetric(vertical: 3.0, horizontal: 5.0),
      child: Text(
        name,
        style: TextStyle(
            fontSize: 13.0,
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
