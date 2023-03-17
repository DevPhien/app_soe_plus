import 'package:date_time_format/date_time_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';

import '../../component/use/avatar.dart';
import '../controller/vanbanhomecontroller.dart';
import 'trangthaivanban.dart';

class ItemVanban extends StatelessWidget {
  final dynamic vanban;
  final bool isShowTrangthai;
  final int? pageIndex;

  const ItemVanban(
      {Key? key, this.vanban, required this.isShowTrangthai, this.pageIndex})
      : super(key: key);
  Widget loaiVanbanWWidget() {
    return Wrap(
      children: [
        if (isShowTrangthai && vanban["hanXuly"] == true)
          const Icon(
            Icons.flag,
            size: 14,
            color: Colors.red,
          ),
        if (isShowTrangthai && vanban["IsFlag"] == true)
          const Icon(
            Icons.star,
            size: 14,
            color: Colors.orange,
          ),
        Icon(
          vanban["denDiNoiBo"] == 0
              ? Octicons.reply
              : vanban["denDiNoiBo"] == 1
                  ? FontAwesome.share
                  : FontAwesome.refresh,
          size: 12,
          color: Colors.black54,
        )
      ],
    );
  }

  //Function
  @override
  Widget build(BuildContext context) {
    final HomeVanbanController controller = Get.put(HomeVanbanController());
    return InkWell(
      child: Container(
          decoration: BoxDecoration(
              border: vanban["FirstvanBanTrangthai_ID"] == "duthao"
                  ? const Border(
                      left: BorderSide(color: Color(0xFF2196f3), width: 2))
                  : null),
          padding: const EdgeInsets.all(10),
          child: Row(
            children: [
              UserAvarta(user: vanban),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            "${vanban["fullName"] ?? ""}",
                            style: const TextStyle(
                                color: Colors.black54,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                        vanban["ngayXuLy"] != null
                            ? Text(
                                DateTimeFormat.format(
                                    DateTime.parse(vanban["ngayXuLy"]),
                                    format: 'd/m/Y H:i'),
                                style: const TextStyle(
                                    fontSize: 13.0, color: Colors.black54))
                            : const SizedBox.shrink(),
                        const SizedBox(width: 10),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Text(vanban["trichYeuNoiDung"] ?? "",
                        style: TextStyle(
                            color: vanban["vanBanXemID"] != null ||
                                    pageIndex == null ||
                                    pageIndex != 1
                                ? Colors.black87
                                : Colors.blue,
                            fontWeight: FontWeight.bold)),
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        Expanded(
                          child: Wrap(direction: Axis.vertical, children: [
                            Wrap(
                              children: [
                                const Text("Số ký hiệu: ",
                                    style: TextStyle(
                                        fontSize: 13.0, color: Colors.black54)),
                                Text(
                                  "${vanban["soKyHieu"] ?? ""}",
                                  style: const TextStyle(
                                      color: Colors.black54,
                                      fontSize: 13.0,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            Wrap(
                              children: [
                                const Text("Ngày văn bản: ",
                                    style: TextStyle(
                                        fontSize: 13.0, color: Colors.black54)),
                                vanban["ngayVanBan"] == null
                                    ? const SizedBox.shrink()
                                    : Text(
                                        DateTimeFormat.format(
                                            DateTime.parse(
                                                vanban["ngayVanBan"]),
                                            format: 'd/m/Y'),
                                        style: const TextStyle(
                                            fontSize: 13.0,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black54))
                              ],
                            ),
                            if (isShowTrangthai &&
                                vanban["hanXulyNgay"] != null)
                              Wrap(
                                children: [
                                  Text("Hạn xử lý: ",
                                      style: TextStyle(
                                          fontSize: 13.0,
                                          color: vanban["isQuahan"] == true
                                              ? Colors.red
                                              : Colors.black54)),
                                  vanban["hanXulyNgay"] == null
                                      ? const SizedBox.shrink()
                                      : Text(
                                          DateTimeFormat.format(
                                              DateTime.parse(
                                                  vanban["hanXulyNgay"]),
                                              format: 'd/m/Y'),
                                          style: TextStyle(
                                              fontSize: 13.0,
                                              fontWeight: FontWeight.bold,
                                              color: vanban["isQuahan"] == true
                                                  ? Colors.red
                                                  : Colors.black54))
                                ],
                              ),
                          ]),
                        ),
                        const SizedBox(width: 5),
                        Column(
                          children: [
                            loaiVanbanWWidget(),
                            if (isShowTrangthai) const SizedBox(height: 5),
                            if (isShowTrangthai)
                              TrangthaiVanban(
                                ttvanban: {
                                  "id": vanban["vanBanTrangthai_ID"],
                                  "name": vanban["vanBanTrangthai_Ten"]
                                },
                              ),
                          ],
                        )
                      ],
                    )
                  ],
                ),
              )
            ],
          )),
      onTap: () {
        var vb = controller.datas.firstWhereOrNull(
            (element) => element["vanBanMasterID"] == vanban["vanBanMasterID"]);
        if (vb != null) {
          vb["vanBanXemID"] = true;
          controller.datas.refresh();
        }
        Get.toNamed("/detaildoc",
            arguments: vanban, parameters: {"pageIndex": pageIndex.toString()});
      },
    );
  }
}
