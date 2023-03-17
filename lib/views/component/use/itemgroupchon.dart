import 'package:flutter/material.dart';

import 'itemlistuser.dart';

class ItemGroupVanbanChon extends StatelessWidget {
  final dynamic donvi;
  final bool one;
  final dynamic onClick;

  const ItemGroupVanbanChon(
      {Key? key, this.donvi, required this.one, required this.onClick})
      : super(key: key);

  //Function
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onClick(one, donvi, !(donvi["chon"] ?? false));
      },
      child: Container(
        padding: const EdgeInsets.all(10),
        child: Row(
          children: [
            ItemListUser(
              users: donvi["nguoichucnangs"],
            ),
            const SizedBox(width: 5),
            Expanded(
                child: Text(donvi["NhomChucnang_Ten"],
                    style: const TextStyle(
                        fontWeight: FontWeight.w500, color: Colors.black87))),
            const SizedBox(width: 5),
            Checkbox(
                value: donvi["chon"] ?? false,
                onChanged: (v) {
                  onClick(one, donvi, v);
                }),
          ],
        ),
      ),
    );
  }
}
