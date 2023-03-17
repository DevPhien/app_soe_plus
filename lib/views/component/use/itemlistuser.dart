import 'package:flutter/material.dart';
import 'package:soe/utils/golbal/golbal.dart';

import '../../component/use/avatar.dart';

class ItemListUser extends StatelessWidget {
  final List<dynamic>? users;

  const ItemListUser({Key? key, required this.users}) : super(key: key);

  //Function
  @override
  Widget build(BuildContext context) {
    if (users == null || users!.isEmpty) return const SizedBox.shrink();
    int len = users!.length;
    return SizedBox(
      height: len > 2 ? 72 : 36,
      width: len > 1 ? 72 : 36,
      child: Stack(children: [
        if (len > 3)
          Positioned(
            child: CircleAvatar(
              radius: 16,
              child: Text(
                (len - 3).toString(),
                style: const TextStyle(fontSize: 11),
              ),
              backgroundColor: Golbal.appColor,
            ),
            left: 32,
            top: 32,
          ),
        Positioned(
          child: UserAvarta(
            user: users![0],
            radius: 16,
          ),
          left: 0,
          top: 0,
        ),
        if (len > 1)
          Positioned(
            child: UserAvarta(
              user: users![1],
              radius: 16,
            ),
            left: len > 2 ? 0 : 32,
            top: len > 2 ? 32 : 0,
          ),
        if (len > 2)
          Positioned(
            child: UserAvarta(
              user: users![2],
              radius: 16,
            ),
            left: 32,
            top: 0,
          ),
      ]),
    );
  }
}
