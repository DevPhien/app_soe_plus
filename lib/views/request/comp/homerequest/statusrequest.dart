import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class StatusRequest extends StatelessWidget {
  final dynamic request;

  const StatusRequest({Key? key, this.request}) : super(key: key);
  Widget renderLable() {
    var arrTrangthais = [
      {
        "id": "-2",
        "name": "Từ chối",
        "bg_color": "#ff8b4e",
        "text_color": "#FFFFFF"
      },
      {
        "id": "-1",
        "name": "Bị hủy",
        "bg_color": "#ff8b4e",
        "text_color": "#FFFFFF"
      },
      {
        "id": "0",
        "name": "Mới lập",
        "bg_color": "#bbbbbb",
        "text_color": "#FFFFFF"
      },
      {
        "id": "1",
        "name": "Chờ duyệt",
        "bg_color": "#33c9dc",
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
        "name": "Thu hồi",
        "bg_color": "#f17ac7",
        "text_color": "#FFFFFF"
      },
      {
        "id": "4",
        "name": "Đã phê duyệt",
        "bg_color": "#04D215",
        "text_color": "#FFFFFF"
      },
      {
        "id": "5",
        "name": "Theo dõi",
        "bg_color": "#33c9dc",
        "text_color": "#FFFFFF"
      },
      {
        "id": "6",
        "name": "Đã quá hạn",
        "bg_color": "#ffa500",
        "text_color": "#FFFFFF"
      },
      {
        "id": "7",
        "name": "Đã lập",
        "bg_color": "#ff8b4e",
        "text_color": "#FFFFFF"
      },
      {
        "id": "8",
        "name": "Quản lý",
        "bg_color": "#51b7ae",
        "text_color": "#FFFFFF"
      },
      {
        "id": "9",
        "name": "Xử lý gấp",
        "bg_color": "#F2A93B",
        "text_color": "#FFFFFF"
      },
      {
        "id": "10",
        "name": "Đã tạo công việc",
        "bg_color": "#51b7ae",
        "text_color": "#FFFFFF"
      },
      {
        "id": "11",
        "name": "Thực hiện quá hạn",
        "bg_color": "#51b7ae",
        "text_color": "#FFFFFF"
      },
      {
        "id": "12",
        "name": "Hoàn thành quá hạn",
        "bg_color": "#51b7ae",
        "text_color": "#FFFFFF"
      },
      {
        "id": "13",
        "name": "Phê duyệt đúng hạn",
        "bg_color": "#51b7ae",
        "text_color": "#FFFFFF"
      },
      {
        "id": "14",
        "name": "Hoàn thành đúng hạn",
        "bg_color": "#51b7ae",
        "text_color": "#FFFFFF"
      },
      {
        "id": "15",
        "name": "Đã gia hạn duyệt",
        "bg_color": "#51b7ae",
        "text_color": "#FFFFFF"
      },
      {
        "id": "16",
        "name": "Đề xuất đang thực hiện",
        "bg_color": "#51b7ae",
        "text_color": "#FFFFFF"
      },
      {
        "id": "17",
        "name": "Đề xuất chờ người lập đánh giá",
        "bg_color": "#33c9dc",
        "text_color": "#FFFFFF"
      },
      {
        "id": "18",
        "name": "Đề xuất đã đánh giá",
        "bg_color": "#6dd230",
        "text_color": "#FFFFFF"
      },
      {
        "id": "19",
        "name": "Đề xuất tạm dừng thực hiện",
        "bg_color": "#51b7ae",
        "text_color": "#FFFFFF"
      },
      {
        "id": "100",
        "name": "Tất cả",
        "bg_color": "#51b7ae",
        "text_color": "#FFFFFF"
      },
      {
        "id": "101",
        "name": "Tất cả đánh giá",
        "bg_color": "#51b7ae",
        "text_color": "#FFFFFF"
      },
    ];
    String id =
        request["Trangthai"] != null ? request["Trangthai"].toString() : "0";
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
