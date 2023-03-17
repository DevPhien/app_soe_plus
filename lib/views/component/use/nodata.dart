import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';

class WidgetNoData extends StatelessWidget {
  final String? txt;
  final IconData? icon;
  const WidgetNoData({Key? key, this.txt, this.icon}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Icon(icon ?? MaterialCommunityIcons.database_remove,
                size: 64.0, color: Colors.black45),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
              child: Text(
                txt ?? "Dữ liệu không tồn tại trong hệ thống!",
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 18.0,fontWeight: FontWeight.bold,color: Colors.black),
              ),
            )
          ],
        ),
      ),
    );
  }
}
