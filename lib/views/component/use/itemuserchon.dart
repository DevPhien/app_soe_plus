import 'package:flutter/material.dart';

import '../../component/use/avatar.dart';

class ItemUserChon extends StatelessWidget {
  final dynamic user;
  final bool one;
  final dynamic onClick;

  const ItemUserChon(
      {Key? key, this.user, required this.one, required this.onClick})
      : super(key: key);

  //Function
  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        onClick(one, user, !(user["chon"] ?? false));
      },
      key: Key(user["NhanSu_ID"]),
      leading: UserAvarta(user: user),
      title: Text(user["fullName"],
          style: const TextStyle(
              fontWeight: FontWeight.bold, color: Colors.black87)),
      subtitle: Wrap(
        children: [
          Text(
            "${user["tenPhongban"] ?? ""}",
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
            textAlign: TextAlign.left,
          ),
          Text(
            " | ${user["tenChucVu"] ?? ""}",
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
            textAlign: TextAlign.left,
          )
        ],
      ),
      trailing: Checkbox(
          value: user["chon"] ?? false,
          onChanged: (v) {
            onClick(one, user, v);
          }),
    );
  }
}
