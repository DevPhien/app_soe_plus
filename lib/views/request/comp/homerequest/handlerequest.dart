import 'package:flutter/material.dart';
import 'package:soe/utils/golbal/golbal.dart';

class HandleRequest extends StatelessWidget {
  final dynamic request;
  const HandleRequest({Key? key, this.request}) : super(key: key);

  Widget renderLable() {
    Widget handle = const SizedBox.shrink();
    double fs = 10.0;
    double pad = Golbal.textScaleFactor > 1.0 ? 8.0 : 5.0;
    int? tt = int.tryParse(request["TrangthaiXL"].toString());
    switch (tt) {
      case 0:
        return Container(
          decoration: BoxDecoration(
              color: const Color(0xFFeeeeee),
              borderRadius: BorderRadius.circular(10.0)),
          padding: EdgeInsets.symmetric(vertical: pad, horizontal: pad),
          child: Text(
            "Đang đợi xử lý",
            style: TextStyle(color: Colors.black87, fontSize: fs),
          ),
        );
      case 1:
        return Container(
          decoration: BoxDecoration(
              color: const Color(0xFF2196f3),
              borderRadius: BorderRadius.circular(10.0)),
          padding: EdgeInsets.symmetric(vertical: pad, horizontal: pad),
          child: Text(
            "Đang được xử lý",
            style: TextStyle(color: Colors.white, fontSize: fs),
          ),
        );
      case 2:
        return Container(
          decoration: BoxDecoration(
              color: const Color(0xFFf17ac7),
              borderRadius: BorderRadius.circular(10.0)),
          padding: EdgeInsets.symmetric(vertical: pad, horizontal: pad),
          child: Text(
            "Chờ đánh giá",
            style: TextStyle(color: Colors.white, fontSize: fs),
          ),
        );
      case 3:
        return Container(
          decoration: BoxDecoration(
              color: const Color(0xff6fbf73),
              borderRadius: BorderRadius.circular(30.0)),
          padding: EdgeInsets.symmetric(vertical: pad, horizontal: pad),
          child: Text(
            "Hoàn thành",
            style: TextStyle(color: Colors.white, fontSize: fs),
          ),
        );
      case 4:
        return Container(
          decoration: BoxDecoration(
              color: Colors.red, borderRadius: BorderRadius.circular(30.0)),
          padding: EdgeInsets.symmetric(vertical: pad, horizontal: pad),
          child: Text(
            "Đã dừng xử lý",
            style: TextStyle(color: Colors.white, fontSize: fs),
          ),
        );
    }
    return handle;
  }

  @override
  Widget build(BuildContext context) {
    return renderLable();
  }
}
