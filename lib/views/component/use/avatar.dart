import 'dart:math';

import 'package:circular_image/circular_image.dart';
import 'package:flutter/material.dart';
import 'package:soe/utils/golbal/golbal.dart';

class UserAvarta extends StatelessWidget {
  final dynamic user;
  final double? radius;
  final int? index;
  final Color? color;

  const UserAvarta({Key? key, this.user, this.radius, this.index, this.color})
      : super(key: key);

  Widget itemBuilder(ct, i) => Container();
  //Function
  @override
  Widget build(BuildContext context) {
    if (user == null) return const SizedBox.shrink();
    if (user["anhThumb"] != null &&
        user["anhThumb"].toString().trim() != "" &&
        !user["anhThumb"].toString().contains("noavatar.jpg") &&
        user["anhThumb"].toString().contains(".")) {
      if (!user["anhThumb"].toString().contains("http")) {
        return SizedBox(
          width: (radius ?? 20) * 2,
          height: (radius ?? 20) * 2,
          child: CircularImage(
            radius: radius ?? 20,
            source: Golbal.congty!.fileurl + user["anhThumb"],
          ),
        );
      } else {
        return SizedBox(
          width: (radius ?? 20) * 2,
          height: (radius ?? 20) * 2,
          child: CircularImage(
            radius: radius ?? 20,
            source: user["anhThumb"],
          ),
        );
      }
    }
    String fname =
        (user["ten"] ?? user["fullName"] ?? " ").toString().substring(0, 1);
    Color? acolor = color;
    if (color == null) {
      List<Color> colors = [
        const Color(0xFF9A97EC),
        const Color(0xFFCAE2B0),
        const Color(0xFFF8E69A),
        const Color(0xFFAFDFCF)
      ];
      int randomNumber = 0;
      if (index != null) {
        randomNumber = index! % 4;
      } else {
        var random = Random();
        randomNumber = random.nextInt(4);
      }
      acolor = colors[randomNumber];
    }
    return SizedBox(
        width: (radius ?? 20) * 2,
        height: (radius ?? 20) * 2,
        child: CircleAvatar(
          radius: radius ?? 20,
          backgroundColor: acolor,
          child: Text(fname, style: const TextStyle(color: Colors.white)),
        ));
  }
}
