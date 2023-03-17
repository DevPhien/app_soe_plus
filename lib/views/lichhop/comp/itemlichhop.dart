import 'package:date_time_format/date_time_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';

import '../../component/use/avatar.dart';

class ItemLichhop extends StatelessWidget {
  final dynamic data;
  final Function? loadFile;
  final Function? goDetail;
  final bool isChon;
  final Function? onChonlich;
  final Function? initLichtrung;
  final Function? gomeeting;

  const ItemLichhop(
      {Key? key,
      this.data,
      this.loadFile,
      this.goDetail,
      this.onChonlich,
      required this.isChon,
      this.initLichtrung,
      this.gomeeting})
      : super(key: key);
  Widget listThamduWidget() {
    if (data["nguoithamdus"] == null) return const SizedBox.shrink();
    int len = data["nguoithamdus"].length > 5 ? 5 : data["nguoithamdus"].length;
    int conlen = 0;
    if (data["songuoithamdu"] != null && data["songuoithamdu"] > 0) {
      conlen = data["songuoithamdu"] - len;
    }
    return SizedBox(
        height: 36,
        child: Stack(
            children: List.generate(len, (index) {
          return Positioned(
              left: index * 18,
              child: UserAvarta(
                user: data["nguoithamdus"][index],
                radius: 14,
                index: index,
              ));
        })
              ..addIf(
                  (conlen > 0),
                  Positioned(
                      left: (len + 1) * 16,
                      child: CircleAvatar(
                        backgroundColor: const Color(0xFFeeeeee),
                        radius: 16,
                        child: Text(
                          "+$conlen",
                          style: const TextStyle(
                              fontSize: 11, color: Colors.black),
                        ),
                      )))));
  }

  Widget fileWidget() {
    if (data["files"] == null) return const SizedBox.shrink();
    return ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.all(0),
        shrinkWrap: true,
        itemCount: data["files"].length,
        itemBuilder: (ct, i) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 5.0),
              child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      loadFile!(data["files"][i]["Duongdan"]);
                    },
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image(
                            image: AssetImage(
                                "assets/file/${data["files"][i]["Dinhdang"].toString().replaceAll('.', '')}.png"),
                            width: 16,
                            height: 16,
                            fit: BoxFit.contain),
                        const SizedBox(width: 5),
                        Expanded(
                            child: Text("${data["files"][i]["Tenfile"]}",
                                maxLines: 1,
                                textAlign: TextAlign.left,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                    color: Colors.black87,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500)))
                      ],
                    ),
                  )),
            ));
  }

  Widget displayNgay() {
    String bdngay = DateTimeFormat.format(DateTime.parse(data["BatdauNgay"]),
        format: 'H:i');
    String ktngay = DateTimeFormat.format(DateTime.parse(data["KethucNgay"]),
        format: 'H:i');
    return Text(
      "$bdngay${ktngay == "00:00" ? '' : ' - $ktngay'}",
      style: const TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 13,
        color: Color(0xFF086FE8),
      ),
    );
  }

  //Function
  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
          decoration: BoxDecoration(
              color: data["Chon"] == true
                  ? const Color(0xFFEFF8FF)
                  : data["IsCurrent"] == true
                      ? const Color(0xFFFEFAEF)
                      : Colors.white),
          padding: const EdgeInsets.all(10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Column(
                children: [
                  displayNgay(),
                  const SizedBox(height: 5),
                  CircleAvatar(
                    backgroundColor: Colors.orange,
                    child: Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: UserAvarta(user: {
                        "anhThumb": data["Chutri_Thumb"],
                        "ten": data["Chutri_Ten1"].toString().toUpperCase()
                      }),
                    ),
                  ),
                  const SizedBox(height: 3.0),
                  CircleAvatar(
                    radius: 3,
                    backgroundColor: DateTime.parse(data["KethucNgay"])
                                .compareTo(DateTime.now()) <
                            0
                        ? const Color(0xFFb9b7b7)
                        : const Color(0xFF07AC8E),
                  ),
                  if (data["IsImportant"] == true)
                    const Padding(
                      padding: EdgeInsets.only(top: 5),
                      child: Icon(Icons.star, color: Colors.red, size: 16),
                    ),
                  if (data["isTrunglich"] == true)
                    InkWell(
                      onTap: () {
                        initLichtrung!(data);
                      },
                      child: const Padding(
                        padding: EdgeInsets.only(top: 5),
                        child: Icon(Icons.flag, color: Colors.orange, size: 16),
                      ),
                    ),
                  if (isChon == true)
                    SizedBox(
                        width: 100,
                        height: 60,
                        child: Checkbox(
                            value: data["Chon"] ?? false,
                            onChanged: (v) {
                              if (onChonlich != null) {
                                onChonlich!(data, v);
                              }
                            })),
                ],
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(data["Noidung"] ?? "",
                        style: const TextStyle(
                            color: Colors.black87,
                            fontWeight: FontWeight.bold)),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(child: listThamduWidget()),
                        if (data["Kieulich"] == 1)
                          InkWell(
                            onTap: () {
                              if (gomeeting != null) gomeeting!(data);
                            },
                            child: const Padding(
                              padding: EdgeInsets.only(top: 5),
                              child: Icon(FontAwesome.video_camera,
                                  color: Color(0xFF0086f9), size: 16),
                            ),
                          )
                      ],
                    ),
                    if (data["Diadiem_Ten"] != null) const SizedBox(height: 5),
                    if (data["Diadiem_Ten"] != null)
                      Row(
                        children: [
                          const Icon(
                            Feather.map_pin,
                            color: Colors.black54,
                            size: 12,
                          ),
                          const SizedBox(width: 5),
                          Expanded(
                              child: Text(
                            data["Diadiem_Ten"] ?? "",
                            style: const TextStyle(
                                color: Colors.black87, fontSize: 13),
                          ))
                        ],
                      ),
                    if (data["Chuanbi"] != null) const SizedBox(height: 5),
                    if (data["Chuanbi"] != null)
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(
                            Feather.tag,
                            color: Colors.black54,
                            size: 12,
                          ),
                          const SizedBox(width: 5),
                          Expanded(
                              child: Text(
                            data["Chuanbi"] ?? "",
                            style: const TextStyle(
                                color: Colors.black87, fontSize: 13),
                          ))
                        ],
                      ),
                    fileWidget()
                  ],
                ),
              ),
              const SizedBox(width: 10),
            ],
          )),
      onTap: () {
        // Get.toNamed("/detailcalendar", arguments: data);
        goDetail!(data);
      },
    );
  }
}
