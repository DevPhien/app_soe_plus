import 'package:date_time_format/date_time_format.dart';
import 'package:flutter/material.dart';

import '../../../utils/golbal/golbal.dart';
import '../../component/use/avatar.dart';

class ItemYkien extends StatelessWidget {
  final dynamic user;
  final dynamic loadFile;

  const ItemYkien({Key? key, this.user, this.loadFile}) : super(key: key);
  Widget dateWidget(String? d) {
    if (d == null) {
      return const SizedBox.shrink();
    } else {
      return Text(
          ", ${DateTimeFormat.format(DateTime.parse(d), format: 'd/m/y H:i')}",
          style: const TextStyle(color: Colors.black87));
    }
  }

  //Function
  @override
  Widget build(BuildContext context) {
    if (user["nhansu"] == null) {
      return const SizedBox.shrink();
    }
    var u = user["nhansu"][0];
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          UserAvarta(
            user: u,
            radius: 24,
          ),
          const SizedBox(width: 10),
          Expanded(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(u["gioiTinh"] == "0" ? "Ông " : "Bà "),
                  Flexible(
                    child: Text(u["fullName"] ?? "",
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black87)),
                  ),
                  if (user["Ngaygui"] != null) dateWidget(user["Ngaygui"]),
                ],
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 5),
                padding:
                    const EdgeInsets.symmetric(vertical: 10.0, horizontal: 22),
                width: double.infinity,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: u["NhanSu_ID"] == Golbal.store.user["user_id"]
                        ? const Color(0xFFDBF1FF)
                        : const Color(0xFFf5f5f5)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(user["Noidung"] ?? "",
                        style: const TextStyle(
                            color: Colors.black87, fontSize: 13)),
                    if (user["tailieus"] != null)
                      Column(
                        children: List.castFrom(user["tailieus"]).map((tl) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5.0),
                            child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  onTap: () {
                                    loadFile(tl["tailieuPath"] ?? "");
                                  },
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      if (tl["tailieuLoai"] != null)
                                        Image(
                                            image: AssetImage(
                                                "assets/file/${tl["tailieuLoai"].toString().replaceAll('.', '')}.png"),
                                            width: 20,
                                            height: 20,
                                            fit: BoxFit.contain),
                                      const SizedBox(width: 5),
                                      Expanded(
                                          child: Text(tl["tailieuTen"] ?? "",
                                              maxLines: 2,
                                              textAlign: TextAlign.left,
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(
                                                  color: Colors.black87,
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w500)))
                                    ],
                                  ),
                                )),
                          );
                        }).toList(),
                      ),
                    if (user["Ngaythuhoi"] != null)
                      Text(
                        "Thu hồi ngày: ${DateTimeFormat.format(DateTime.parse(user["Ngaythuhoi"]), format: 'd/m/y H:i')}",
                        style: const TextStyle(color: Colors.red, fontSize: 13),
                      ),
                    if (user["Ngaythuhoi"] != null)
                      Text("Nội dung: ${user["Noidungthuhoi"] ?? ""}",
                          style:
                              const TextStyle(color: Colors.red, fontSize: 13)),
                  ],
                ),
              ),
            ],
          ))
        ],
      ),
    );
  }
}
