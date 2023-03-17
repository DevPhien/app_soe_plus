import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:soe/utils/golbal/golbal.dart';
import 'package:soe/views/component/use/avatar.dart';
import 'package:soe/views/task/comp/project/detail/comment/commentprojectcontroller.dart';

class ItemCommentProject extends StatelessWidget {
  final CommentProjectController controller =
      Get.put(CommentProjectController());
  final dynamic item;
  ItemCommentProject({Key? key, this.item}) : super(key: key);

  Widget renderHtmlContentNoti(String content) {
    content = content.replaceAll("&nbsp;", " ");
    List<String> contents = (content).toString().split("</user>");
    if (contents.isEmpty) {
      return Text(
        Golbal.removeAllHtmlTags(content),
        style: const TextStyle(fontSize: 13.0),
        maxLines: 3,
        overflow: TextOverflow.ellipsis,
        textAlign: TextAlign.justify,
      );
    }
    List<TextSpan> wgs = [];
    for (var content in contents) {
      int st = content.indexOf("<user>");
      if (st != -1) {
        try {
          wgs.add(TextSpan(
            text: content.substring(0, st),
          ));
          wgs.add(TextSpan(
            text: content.substring(st + 6),
            style:
                TextStyle(fontWeight: FontWeight.w600, color: Golbal.appColor),
          ));
        } catch (e) {}
      } else {
        wgs.add(TextSpan(
          text: Golbal.removeAllHtmlTags(content),
          style:
              const TextStyle(fontWeight: FontWeight.w400, color: Colors.black),
        ));
      }
    }
    return RichText(
        text: TextSpan(
      style: const TextStyle(color: Colors.black54),
      children: wgs,
    ));
  }

  Widget renderFile(r) {
    if (r["files"] == null || r["files"].length == 0) {
      return Container(width: 0.0);
    }
    return ListView.builder(
      scrollDirection: Axis.vertical,
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: r["files"].length,
      itemBuilder: (c, i) => Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5.0),
            border: Border.all(color: const Color(0xFFeeeeee)),
            color: const Color(0xFFf9f9f9)),
        margin: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 5.0),
        padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
        child: InkWell(
            onTap: () {
              Golbal.loadFile(r["files"][i]["Duongdan"]);
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                InkWell(
                  onTap: () {
                    Golbal.loadFile(r["files"][i]["Duongdan"]);
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 5.0, horizontal: 5.0),
                    child: Image(
                        image: AssetImage(
                            "assets/file/${r["files"][i]["Dinhdang"].toString().replaceAll('.', '')}.png"),
                        width: 24,
                        height: 24,
                        fit: BoxFit.contain),
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 5.0),
                    child: Text(
                      "${r["files"][i]["Tenfile"]} (${Golbal.formatBytes(r["files"][i]["Dungluong"])})",
                      maxLines: 2,
                      textAlign: TextAlign.justify,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 12.0,
                        color: Colors.black87,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ),
              ],
            )),
      ),
    );
  }

  Widget bindQuote(context, quote) {
    Widget chatWg = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Container(
          margin: const EdgeInsets.only(bottom: 5.0),
          decoration: BoxDecoration(
            color: const Color(0xFFffffff),
            border: Border.all(color: const Color(0xFFf5f5f5), width: 0.5),
            borderRadius: const BorderRadius.all(Radius.circular(10.0)),
          ),
          padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Expanded(
                    child: Text(
                      quote["fullName"] ?? "",
                      style: const TextStyle(
                          fontWeight: FontWeight.w600, fontSize: 13.0),
                    ),
                  ),
                  const SizedBox(width: 5.0),
                  Text(
                    Golbal.timeAgo(quote["NgayTao"]),
                    style: const TextStyle(
                        color: Color(0xffaaaaaa), fontSize: 12.0),
                  ),
                ],
              ),
              const SizedBox(height: 2.0),
              if (quote["tenToChuc"] != null) ...[
                Text(
                  quote["tenToChuc"] ?? "",
                  style: const TextStyle(fontSize: 11.0, color: Colors.black54),
                )
              ],
              if (quote["Noidung"].toString().trim() != "") ...[
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 5.0),
                  child: Text(
                    quote["Noidung"] ?? "",
                    textAlign: TextAlign.justify,
                    style: const TextStyle(fontSize: 13.0),
                  ),
                )
              ],
              renderFile(quote),
            ],
          ),
        ),
      ],
    );
    return InkWell(
      onTap: () {
        controller.dismissKeybroad(context);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 5.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
              margin: const EdgeInsets.only(right: 10.0),
              child: UserAvarta(
                user: item,
                radius: 24,
              ),
            ),
            Expanded(child: chatWg),
          ],
        ),
      ),
    );
  }

  void doNothing(BuildContext context) {}

  @override
  Widget build(BuildContext context) {
    dynamic quote;
    if (item["ParentID"] != null) {
      quote = controller.comments.firstWhere(
          (element) => element["RequestComment_ID"] == item["ParentID"],
          orElse: () => null);
    }
    Widget chatWg = Column(
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
            color: item["IsMe"]
                ? const Color(0xFFdbf4fe)
                : const Color(0xFFffffff),
            border: Border.all(color: const Color(0xFFf5f5f5), width: 0.5),
            borderRadius: const BorderRadius.all(Radius.circular(10.0)),
          ),
          padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              if (quote != null) ...[
                Card(
                  margin: const EdgeInsets.only(top: 10, bottom: 10),
                  elevation: 0,
                  color: const Color(0xFFdbf4fe),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Expanded(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              const Icon(Octicons.quote,
                                  color: Colors.black26, size: 16),
                              Expanded(child: bindQuote(context, quote)),
                            ],
                          ),
                        ),
                        const SizedBox(width: 5.0),
                        const Align(
                          alignment: Alignment.bottomRight,
                          child: Icon(
                            Entypo.quote,
                            color: Colors.black26,
                            size: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
              Row(
                children: <Widget>[
                  Expanded(
                      child: Text(
                    item["fullName"] ?? "",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  )),
                  const SizedBox(width: 5.0),
                  Text(Golbal.timeAgo(item["NgayTao"]),
                      style: const TextStyle(
                          color: Color(0xffaaaaaa), fontSize: 12.0))
                ],
              ),
              const SizedBox(height: 2.0),
              if (item["tenToChuc"] != null) ...[
                Text(
                  item["tenToChuc"] ?? "",
                  style: const TextStyle(fontSize: 11.0, color: Colors.black54),
                ),
              ],
              if (item["Noidung"].toString().trim() != "") ...[
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 5.0),
                  child: renderHtmlContentNoti(item["Noidung"] ?? ""),
                )
              ],
              renderFile(item),
            ],
          ),
        ),
      ],
    );
    return Column(
      children: <Widget>[
        InkWell(
          onLongPress: () {
            controller.popGroupAction(context, item);
          },
          onTap: () {
            controller.dismissKeybroad(context);
          },
          child: Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 5.0, vertical: 5.0),
                  margin: const EdgeInsets.only(right: 10.0),
                  child: UserAvarta(
                    user: item,
                    radius: 24,
                  ),
                ),
                if (item["IsMe"]) ...[
                  Expanded(
                    child: Slidable(
                      key: const ValueKey(0),
                      endActionPane: ActionPane(
                        motion: const ScrollMotion(),
                        children: [
                          SlidableAction(
                            onPressed: (context) {
                              controller.showQuote(context, item);
                            },
                            backgroundColor: const Color(0xFF925CB1),
                            foregroundColor: Colors.white,
                            icon: Entypo.quote,
                            label: 'Trả lời',
                          ),
                          SlidableAction(
                            onPressed: (context) {
                              controller.delete(context, item);
                            },
                            backgroundColor: const Color(0xFFFE4A49),
                            foregroundColor: Colors.white,
                            icon: Icons.delete,
                            label: 'Xóa',
                          ),
                        ],
                      ),
                      child: chatWg,
                    ),
                  ),
                ] else ...[
                  Expanded(
                    child: chatWg,
                  ),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }
}
