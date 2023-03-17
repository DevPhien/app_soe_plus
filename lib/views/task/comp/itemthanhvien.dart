import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../component/use/avatar.dart';

class ThanhVienTask extends StatelessWidget {
  final List<dynamic>? thanhviens;
  final bool showMore;

  const ThanhVienTask(
      {Key? key, required this.thanhviens, required this.showMore})
      : super(key: key);
  //Function
  Widget listthanhvienWidget() {
    if (thanhviens == null || thanhviens!.isEmpty) {
      return const SizedBox.shrink();
    }
    int len = thanhviens!.length > 5 ? 5 : thanhviens!.length;
    int conlen = thanhviens!.length - len;
    return SizedBox(
        height: 36,
        child: Stack(
            children: List.generate(len, (index) {
          return Positioned(
              left: index * 18,
              child: UserAvarta(
                user: thanhviens![index],
                radius: 14,
                index: index,
              ));
        })
              ..addIf(
                  (conlen > 0 && showMore),
                  Positioned(
                      left: (len + 1) * 16,
                      child: CircleAvatar(
                        backgroundColor: const Color(0xFFeeeeee),
                        radius: 16,
                        child: Text(
                          "+$conlen",
                          style: const TextStyle(
                              fontSize: 11, color: Colors.black),
                        ),
                      )))));
  }

  @override
  Widget build(BuildContext context) {
    return listthanhvienWidget();
  }
}
