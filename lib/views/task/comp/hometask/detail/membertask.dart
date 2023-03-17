import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../component/use/avatar.dart';

class MemberTask extends StatelessWidget {
  final List<dynamic>? members;
  final bool showMore;

  const MemberTask({Key? key, required this.members, required this.showMore})
      : super(key: key);

  Widget listMemberWidget() {
    if (members == null || members!.isEmpty) {
      return const SizedBox.shrink();
    }
    int len = members!.length > 5 ? 5 : members!.length;
    int conlen = members!.length - len;
    return SizedBox(
      height: 30,
      child: Stack(
        children: List.generate(len, (index) {
          return Positioned(
              left: index * 18,
              child: UserAvarta(
                user: members![index],
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
                  style: const TextStyle(fontSize: 11, color: Colors.black),
                ),
              ),
            ),
          ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return listMemberWidget();
  }
}
