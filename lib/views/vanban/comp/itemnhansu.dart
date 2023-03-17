import 'package:date_time_format/date_time_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';

import '../../component/use/avatar.dart';

class ItemUser extends StatelessWidget {
  final dynamic user;

  const ItemUser({Key? key, this.user}) : super(key: key);
  Widget dateWidget() {
    String? d = user["ngayXem"];
    return d == null
        ? const SizedBox.shrink()
        : Column(
            children: [
              const Icon(Ionicons.checkmark_done_outline, color: Colors.green),
              Text(
                  DateTimeFormat.format(DateTime.parse(d), format: 'd/m/y H:i'),
                  style: const TextStyle(color: Colors.black87,fontSize: 12))
            ],
          );
  }

  //Function
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: UserAvarta(user: user),
      title: Text(user["fullName"],
          style: const TextStyle(
              fontWeight: FontWeight.bold, color: Colors.black87)),
      subtitle: Text(
        "${user["tenPhongban"] ?? ""}",
        overflow: TextOverflow.ellipsis,
        maxLines: 2,
        textAlign: TextAlign.left,
      ),
      trailing: dateWidget(),
    );
  }
}
