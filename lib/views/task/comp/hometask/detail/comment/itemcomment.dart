import 'package:cached_network_image/cached_network_image.dart';
import 'package:date_time_format/date_time_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:flutter_link_previewer/flutter_link_previewer.dart';
import '../../../../../../utils/golbal/golbal.dart';
import '../../../../../component/use/avatar.dart';

class ItemCommentTask extends StatelessWidget {
  final dynamic item;
  final dynamic loadFile;

  const ItemCommentTask({Key? key, this.item, this.loadFile}) : super(key: key);
  Widget dateWidget(String? d) {
    return d == null
        ? const SizedBox.shrink()
        : Text(
            ", " +
                DateTimeFormat.format(DateTime.parse(d), format: 'd/m/y H:i'),
            style: const TextStyle(color: Colors.black54));
  }

  Widget htmlNoidung(String? nd) {
    if (nd != null && nd.contains("http")) {
      return LinkPreview(
        padding: const EdgeInsets.all(0),
        enableAnimation: true,
        onPreviewDataFetched: (data) {},
        text: nd,
        width: double.infinity,
        previewData: null,
      );
    }
    return HtmlWidget(nd ?? "");
  }

  Widget itemFile(fi) {
    if (fi["IsImage"].toString() == "1" && fi["Duongdan"] != null) {
      return Container(
        alignment: Alignment.topLeft,
        height: 120,
        child: CachedNetworkImage(
          imageUrl: Golbal.congty!.fileurl + fi["Duongdan"],
          fit: BoxFit.contain,
          width: 120,
        ),
      );
    } else if (fi["Duongdan"] != null) {
      return Container(
        width: Golbal.screenSize.width,
        height: 50.0,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5.0),
            border: Border.all(color: const Color(0xFFeeeeee)),
            color: const Color(0xFFffffff)),
        padding: const EdgeInsets.only(bottom: 5.0, top: 5.0),
        child: InkWell(
          onTap: () {
            Golbal.loadFile(fi["Duongdan"]);
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              InkWell(
                  onTap: () {
                    Golbal.loadFile(fi["Duongdan"]);
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 5.0, horizontal: 10.0),
                    child: Image(
                      image: AssetImage(
                          "assets/file/${fi['Dinhdang'].replaceAll('.', '')}.png"),
                      width: 32,
                      height: 32,
                      fit: BoxFit.contain,
                    ),
                  )),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 5.0),
                  child: Text(
                    "${fi["Tenfile"]} (${Golbal.formatBytes(fi["Dungluong"])})",
                    maxLines: 4,
                    textAlign: TextAlign.justify,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.black87,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }
    return Container();
  }

  Widget listFiles() {
    if (item["files"] == null) return const SizedBox.shrink();
    var mfiles = List.castFrom(item["files"]);
    return ListView.builder(
      scrollDirection: Axis.vertical,
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemBuilder: (ct, i) => itemFile(mfiles[i]),
      itemCount: mfiles.length,
    );
  }

  //Function
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          UserAvarta(
            user: item,
            radius: 24,
          ),
          const SizedBox(width: 10),
          Expanded(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(item["fullName"] ?? "",
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF045997))),
                  if (item["NgayTao"] != null) dateWidget(item["NgayTao"]),
                ],
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 10),
                padding:
                    const EdgeInsets.symmetric(vertical: 10.0, horizontal: 22),
                //width: double.infinity,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: item["NguoiTao"] == Golbal.store.user["user_id"]
                        ? const Color(0xFFDBF4FD)
                        : const Color(0xFFffffff)),
                child: htmlNoidung(item["Noidung"] ?? ""),
              ),
              listFiles()
            ],
          ))
        ],
      ),
    );
  }
}
