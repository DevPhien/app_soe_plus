import 'package:circular_image/circular_image.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:soe/utils/golbal/golbal.dart';

class MemberRequest extends StatelessWidget {
  final List<dynamic>? signs;
  final bool showMore;

  const MemberRequest({Key? key, required this.signs, required this.showMore})
      : super(key: key);

  Color signColor(String d, bool cl) {
    Color them = Colors.black38;
    if (cl) return Colors.red;
    if (d == "1") return const Color(0xFF6dd230);
    if (d == "2") return const Color(0xFF0078d4);
    if (d == "3") return Colors.blueAccent;
    if (d == "-1") return Colors.orange;
    return them;
  }

  String renderText(String? name) {
    if (name == null) return "";
    name = name.trim();
    int i = name.lastIndexOf(" ");
    try {
      if (name.length <= i + 2) {
        return name;
      }
      return name.substring(i + 1, i + 2).toUpperCase();
    } catch (e) {
      return name;
    }
  }

  Widget itemBuilder(item, i, ras, bor) {
    String anh = item["anhThumb"] ?? "";
    String name = item["ten"] ?? "";
    //bool active = (item["IsType"] == "4" || item["IsSign"] != "0");
    Color color = item["IsType"] == "4"
        ? Colors.indigo
        : signColor(item["IsSign"] ?? "0", item["IsClose"] ?? false);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 2.0),
      child: Stack(
        children: [
          if (anh.isNotEmpty)
            CircleAvatar(
              radius: ras ?? 24,
              backgroundColor: color,
              child: CircularImage(
                radius: (ras ?? 24) - 2,
                source: Golbal.congty!.fileurl + anh,
                badgeBgColor: color,
                borderColor: color,
              ),
            )
          else
            CircleAvatar(
              radius: ras ?? 24,
              backgroundColor: color,
              child: CircleAvatar(
                backgroundColor: HexColor(Golbal.randomColors[(i ?? 0) % 7]),
                radius: (ras ?? 24) - 2,
                child: Text(
                  renderText(name),
                  style: TextStyle(
                    fontSize: 16,
                    color: HexColor('#ffffff'),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget listMemberWidget() {
    return SizedBox(
      height: 35,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: signs!
            .map(
              (si) => Container(
                child: ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemCount: si["users"].length,
                  itemBuilder: (ct, i) =>
                      itemBuilder(si["users"][i], i, 15.0, 3.0),
                ),
                height: 46.0,
                padding: const EdgeInsets.only(top: 5.0),
              ),
            )
            .toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return listMemberWidget();
  }
}
