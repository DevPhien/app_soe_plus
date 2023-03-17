import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';

class ItemDonviChon extends StatelessWidget {
  final dynamic donvi;
  final bool one;
  final dynamic onClick;

  const ItemDonviChon(
      {Key? key, this.donvi, required this.one, required this.onClick})
      : super(key: key);

  //Function
  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        onClick(one, donvi, !(donvi["chon"] ?? false));
      },
      key: Key(donvi["Congty_ID"]),
      leading: const Icon(Ionicons.folder_outline),
      title: Text(donvi["tenCongty"],
          style: const TextStyle(
              fontWeight: FontWeight.w500, color: Colors.black87)),
      trailing: Checkbox(
          value: donvi["chon"] ?? false,
          onChanged: (v) {
            onClick(one, donvi, v);
          }),
    );
  }
}
