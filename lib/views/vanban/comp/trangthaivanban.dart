import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class TrangthaiVanban extends StatelessWidget {
  final dynamic ttvanban;

  const TrangthaiVanban({Key? key, this.ttvanban}) : super(key: key);
  Widget renderLableVanban() {
    var arrTrangthais = [
      {
        "vanBanTrangthai_ID": "chodongdau",
        "bg_color": "#d87777",
        "text_color": "#FFFFFF"
      },
      {
        "vanBanTrangthai_ID": "chopheduyet",
        "bg_color": "#2196f3",
        "text_color": "#FFFFFF"
      },
      {
        "vanBanTrangthai_ID": "choxacnhanhoanthanh",
        "bg_color": "#ff8b4e",
        "text_color": "#FFFFFF"
      },
      {
        "vanBanTrangthai_ID": "dadongdau",
        "bg_color": "#51b7ae",
        "text_color": "#FFFFFF"
      },
      {
        "vanBanTrangthai_ID": "duthao",
        "bg_color": "#ffc107",
        "text_color": "#FFFFFF"
      },
      {
        "vanBanTrangthai_ID": "hoanthanh",
        "bg_color": "#6dd230",
        "text_color": "#FFFFFF"
      },
      {
        "vanBanTrangthai_ID": "luutru",
        "bg_color": "#f17ac7",
        "text_color": "#FFFFFF"
      },
      {
        "vanBanTrangthai_ID": "phanphat",
        "vanBanTrangthai_Ten": "Phân phát",
        "bg_color": "#CAE2B0",
        "text_color": "#ffffff"
      },
      {
        "vanBanTrangthai_ID": "phathanh",
        "bg_color": "NULL",
        "text_color": "NULL"
      },
      {
        "vanBanTrangthai_ID": "phoihop",
        "bg_color": "#8BCFFB",
        "text_color": "#FFFFFF"
      },
      {
        "vanBanTrangthai_ID": "sohoa",
        "bg_color": "#f2f4f6",
        "text_color": "#72777a"
      },
      {
        "vanBanTrangthai_ID": "tralai",
        "vanBanTrangthai_Ten": "Trả lại",
        "bg_color": "#FF0000",
        "text_color": "#FFFFFF"
      },
      {
        "vanBanTrangthai_ID": "xemdebiet",
        "vanBanTrangthai_Ten": "Xem để biết",
        "bg_color": "#CCADD7",
        "text_color": "#FFFFFF"
      },
      {
        "vanBanTrangthai_ID": "xulychinh",
        "vanBanTrangthai_Ten": "Chờ xử lý",
        "bg_color": "#2196f3",
        "text_color": "#FFFFFF"
      }
    ];
    String id = ttvanban["id"];
    String name = ttvanban["name"];
    var objTrangthai = arrTrangthais
        .firstWhere((element) => element["vanBanTrangthai_ID"] == id);
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
