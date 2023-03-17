import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UnknownRoutePage extends StatelessWidget {
  const UnknownRoutePage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    TextStyle buocStyle = const TextStyle(color: Colors.black87, fontSize: 20);
    TextStyle desStyle = TextStyle(color: Colors.grey[400], fontSize: 13);
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        color: Colors.white,
        padding: const EdgeInsets.all(20.0),
        child: Column(children: [
          Image.asset("assets/error.jpeg"),
          const SizedBox(height: 30.0),
          Text(
            "Không tìm thấy trang bạn chọn",
            style: buocStyle,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10.0),
          Text("Vui lòng click vào nút dưới đây để quay lại.",
              style: desStyle, textAlign: TextAlign.center),
          const SizedBox(height: 40.0),
          SizedBox(
            width: 150,
            child: ElevatedButton(
                style: ButtonStyle(
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ))),
                child: const Text(
                  "Quay lại",
                  style: TextStyle(color: Colors.white, fontSize: 16.0),
                ),
                onPressed: () {
                  Get.back();
                }),
          ),
        ]),
      ),
    );
  }
}
