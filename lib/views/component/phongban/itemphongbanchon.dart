import 'package:flutter/material.dart';

class ItemPhongbanChon extends StatelessWidget {
  final dynamic phongban;
  final bool one;
  final dynamic onClick;

  const ItemPhongbanChon(
      {Key? key, this.phongban, required this.one, required this.onClick})
      : super(key: key);

  //Function
  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        onClick(one, phongban, !(phongban["chon"] ?? false));
      },
      key: Key(phongban["Phongban_ID"]),
      title: Text(phongban["tenPhongban"],
          style: const TextStyle(
              fontWeight: FontWeight.bold, color: Colors.black87)),
      trailing: Checkbox(
        value: phongban["chon"] ?? false,
        onChanged: (v) {
          onClick(one, phongban, v);
        },
      ),
    );
  }
}
