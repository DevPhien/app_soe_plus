import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import "package:collection/collection.dart";
import 'package:get/get.dart';
import 'package:sliding_sheet/sliding_sheet.dart';
import 'package:soe/utils/golbal/golbal.dart';
import 'package:soe/views/component/use/avatar.dart';
import 'package:soe/views/component/use/inlineloadding.dart';
import 'package:soe/views/request/comp/homerequest/detail/activity/activitycontroller.dart';
import 'package:soe/views/request/controller/requestcontroller.dart';

class Activity extends StatelessWidget {
  final ActivityController controller = Get.put(ActivityController());
  final RequestController rqcontroller = Get.put(RequestController());
  Activity({Key? key}) : super(key: key);

  final double hsize = 16.0;

  Widget timelineWidget(context) {
    var qts = groupBy(controller.charts, (dynamic obj) => obj['QTName'])
        .entries
        .toList();
    return ListView.builder(
      itemCount: qts.length,
      itemBuilder: (ct, i) {
        var qt = qts[i];
        var signs = qt.value;
        return Container(
          margin: const EdgeInsets.only(bottom: 20.0),
          child: ExpandablePanel(
            header: Container(
                color: const Color(0xFF6dd230),
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(qt.key,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white)),
                    ),
                    if (signs[0]["IsHideQT"] == true) ...[
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        padding: const EdgeInsets.symmetric(
                            vertical: 5.0, horizontal: 8.0),
                        child: const Text(
                          "Đã huỷ",
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.white,
                          ),
                        ),
                      )
                    ],
                  ],
                )),
            collapsed: ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: signs.length,
                itemBuilder: (ct, i) {
                  var sign = signs[i];
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: Container(
                                decoration: BoxDecoration(
                                  color: const Color(0xFFfaebd7),
                                  borderRadius: BorderRadius.circular(30.0),
                                ),
                                margin: const EdgeInsets.all(10.0),
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  "${sign["GroupName"]}",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                )),
                          ),
                          Container(
                              decoration: BoxDecoration(
                                color: sign["IsTypeDuyet"] == 0
                                    ? const Color(0xFF33c9dc)
                                    : sign["IsTypeDuyet"] == 1
                                        ? const Color(0xFFff8b4e)
                                        : const Color(0xFF8a2be2),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              margin: const EdgeInsets.all(10.0),
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                sign["IsTypeDuyet"] == 0
                                    ? "1 người duyệt"
                                    : sign["IsTypeDuyet"] == 1
                                        ? "Duyệt lần lượt"
                                        : "Duyệt ngẫu nhiên",
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 11,
                                    color: Colors.white),
                              )),
                        ],
                      ),
                      // MemberRequest(
                      //   signs: sign,
                      //   showMore: true,
                      // ),
                      signUserWidget(context, sign),
                    ],
                  );
                }),
            expanded: const SizedBox.shrink(),
          ),
        );
      },
    );
  }

  Future viewUser(context, members) async {
    await showSlidingBottomSheet(context, builder: (context) {
      return SlidingSheetDialog(
        elevation: 8,
        cornerRadius: 16,
        snapSpec: const SnapSpec(
          snap: false,
          snappings: [0.9],
          positioning: SnapPositioning.relativeToAvailableSpace,
        ),
        headerBuilder: (c, s) => Material(
            color: Colors.white,
            child: Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: Row(
                  children: <Widget>[
                    const Spacer(),
                    Container(
                      margin: const EdgeInsets.only(top: 10.0),
                      width: 40,
                      height: 5,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        color: const Color(0xFFdddddd),
                      ),
                    ),
                    const Spacer()
                  ],
                ))),
        builder: (context, state) {
          return Material(
            color: Colors.white,
            child: SafeArea(
              top: false,
              child: ListView.separated(
                  padding: const EdgeInsets.all(0.0),
                  separatorBuilder: (context, i) =>
                      const Divider(height: 1.0, thickness: 1),
                  itemCount: members.length,
                  shrinkWrap: true,
                  itemBuilder: (ct, i) => bindRowUser(members[i])),
            ),
          );
        },
      );
    });
  }

  Widget bindRowUser(r) {
    return ListTile(
      leading: SizedBox(
        width: 40,
        height: 40,
        child: UserAvarta(
          user: r,
          radius: 24,
        ),
      ),
      title: Text(
        r["fullName"] ?? "",
        style:
            const TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
      ),
      subtitle: Text(r["tenToChuc"] ?? ""),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[rqcontroller.renderLableSign(r)],
      ),
    );
  }

  Widget signUserWidget(context, si) {
    List users = List.castFrom(si["Thanhviens"]).toList();
    Widget memberWG = const SizedBox.shrink();
    if (si["IsTypeDuyet"].toString() == "0") {
      if (si["USign"] != null && si["USign"].length > 0) {
        List ss = List.castFrom(si["USign"]).toList();
        if (si["USign"].length > 1) {
          var us = users.where((e) => e["IsSign"].toString() == "0").toList();
          memberWG = InkWell(
            onTap: () {
              viewUser(context, us);
            },
            child: Container(
              margin: const EdgeInsets.only(left: 20.0),
              child: ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemCount: us.length,
                itemBuilder: (ct, i) => Container(
                  padding: const EdgeInsets.symmetric(horizontal: 2.0),
                  child: UserAvarta(
                    user: us[i],
                    radius: 24,
                    color: rqcontroller.signColor(
                        us[i]["IsSign"].toString(), us[i]["IsClose"]),
                  ),
                ),
              ),
              height: 46.0,
            ),
          );
          users = ss;
        } else {
          users.insertAll(0, ss);
        }
      }
    }
    return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(0.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: users.length,
              itemBuilder: (ct, i) {
                var u = users[i];
                return Container(
                  padding: const EdgeInsets.only(bottom: 20.0),
                  child: IntrinsicHeight(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 120,
                          child: Stack(children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Center(
                                  child: UserAvarta(
                                    user: u,
                                    radius: 24,
                                    color: rqcontroller.signColor(
                                        u["IsSign"].toString(), u["IsClose"]),
                                  ),
                                  // Api.renderAvarTa(
                                  //     u["anhThumb"], u["ten"],
                                  //     ras: 36,
                                  //     active:
                                  //         u["IsSign"].toString() !=
                                  //             "0",
                                  //     bor: 3.0,
                                  //     co: _utility.signColor(
                                  //         u["IsSign"].toString(),
                                  //         u["IsClose"])),
                                ),
                                if (u["SignDate"] != null) ...[
                                  Container(
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF6dd230),
                                      borderRadius: BorderRadius.circular(20.0),
                                    ),
                                    margin: const EdgeInsets.all(5.0),
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      Golbal.formatDate(
                                          u["SignDate"], "H:i d/m/Y"),
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                        fontSize: 11,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                            u["IsSign"] == 0
                                ? Container(width: 0.0)
                                : Positioned(
                                    bottom: 40.0,
                                    right: 0,
                                    child: Icon(
                                      u["IsSign"] == 1
                                          ? Icons.check_circle
                                          : u["IsSign"] == 2
                                              ? Icons.play_circle_fill
                                              : Icons.stop_circle_outlined,
                                      color: rqcontroller.signColor(
                                          u["IsSign"].toString(), false),
                                    ),
                                  ),
                          ]),
                        ),
                        const SizedBox(width: 10.0),
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(10.0),
                            decoration: BoxDecoration(
                                border:
                                    Border.all(color: const Color(0xffdddddd)),
                                borderRadius: BorderRadius.circular(5.0)),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "${u["fullName"]}",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: rqcontroller.signColor(
                                        u["IsSign"].toString(), u["IsClose"]),
                                  ),
                                ),
                                Text(u["tenChucVu"] ?? "",
                                    style: const TextStyle(
                                        fontSize: 13, color: Colors.black54)),
                                Text(u["tenToChuc"] ?? "",
                                    style: const TextStyle(
                                        fontSize: 13, color: Colors.black54)),
                                if (u["SignContent"] != null &&
                                    u["SignContent"] != "") ...[
                                  Text(
                                      Golbal.removeAllHtmlTags(
                                          u["SignContent"] ?? ""),
                                      style: const TextStyle(
                                        fontSize: 14.0,
                                      ),
                                      textAlign: TextAlign.justify)
                                ],
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            memberWG
          ],
        ));
  }

  Widget bindRowLog(log) {
    return ListTile(
      leading: SizedBox(
        width: 48,
        child: UserAvarta(
          user: log,
          radius: 24,
        ),
      ),
      title: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Wrap(children: [
            Text(
              log["fullName"].toString(),
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16.0,
              ),
            ),
            Text(
              " (${Golbal.formatDate(log["NgayTao"].toString(), "H:i d/m/Y")})",
              style: const TextStyle(
                fontSize: 13.0,
                color: Color(0xFF999999),
              ),
              textAlign: TextAlign.justify,
            ),
          ]),
          Text(
            "${log["tenChucVu"] ?? ""}",
            style: TextStyle(fontSize: hsize - 3, color: Colors.black38),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            "${log["tenToChuc"] ?? ""}",
            style: TextStyle(fontSize: hsize - 3, color: Colors.black54),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          if (log["Noidung"] != null && log["Noidung"] != "") ...[
            Text(
              Golbal.removeAllHtmlTags(log["Noidung"] ?? ""),
              style: const TextStyle(
                fontSize: 14.0,
              ),
              textAlign: TextAlign.justify,
            ),
          ],
        ],
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[rqcontroller.renderLableSignLog(log)],
      ),
    );
  }

  Widget bindRowView(log) {
    return ListTile(
      leading: SizedBox(
        width: 48,
        // child: Golbal.renderAvarTa(log["anhThumb"], log["ten"],
        //     ras: 18, active: log["IsActive"], co: Colors.orange, bor: 3.0),
        child: UserAvarta(user: log, radius: 24, color: Colors.orange),
      ),
      trailing: log["NgayXemCuoi"] != null
          ? Text(Golbal.formatDate(log["NgayXemCuoi"].toString(), "H:i d/m/Y"),
              style: const TextStyle(fontSize: 13.0, color: Color(0xFF999999)),
              textAlign: TextAlign.justify)
          : Container(
              margin: const EdgeInsets.only(top: 8.0),
              padding:
                  const EdgeInsets.symmetric(horizontal: 10.0, vertical: 3.0),
              decoration: BoxDecoration(
                  color: Colors.red, borderRadius: BorderRadius.circular(10.0)),
              child: const Text(
                "Chưa xem",
                style: TextStyle(color: Colors.white, fontSize: 11.0),
              ),
            ),
      title: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            log["fullName"].toString(),
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
          ),
          Text(
            "${log["tenChucVu"] ?? ""}",
            style: TextStyle(fontSize: hsize - 3, color: Colors.black38),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            "${log["tenToChuc"] ?? ""}",
            style: TextStyle(fontSize: hsize - 3, color: Colors.black54),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget scaffoldTab(context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 1.0,
          titleSpacing: 0.0,
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(color: Golbal.iconColor),
          title: const Text(
            "Theo dõi",
            style: TextStyle(
              color: Color(0xFF0186f8),
            ),
          ),
          bottom: TabBar(
            indicatorColor: const Color(0xFF0186f8),
            labelColor: const Color(0xFF0186f8),
            unselectedLabelColor: const Color(0xFF0186f8),
            tabs: [
              const Tab(text: "Quy trình"),
              Tab(text: "Lịch sử (${controller.logs.length})"),
              Tab(text: "Người xem (${controller.views.length})")
            ],
          ),
          centerTitle: true,
        ),
        body: SafeArea(
          child: TabBarView(
            children: [
              if (controller.loading.value == true) ...[
                const InlineLoadding(),
              ] else ...[
                Container(
                  padding: const EdgeInsets.all(20.0),
                  child: timelineWidget(context),
                ),
              ],
              ListView.separated(
                itemCount: controller.logs.length,
                separatorBuilder: (c, i) => const Divider(thickness: 1),
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                itemBuilder: (c, i) => bindRowLog(controller.logs[i]),
              ),
              ListView.separated(
                itemCount: controller.views.length,
                separatorBuilder: (c, i) => const Divider(thickness: 1),
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                itemBuilder: (c, i) => bindRowView(controller.views[i]),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context)
          .copyWith(textScaleFactor: Golbal.textScaleFactor),
      child: Scaffold(
        backgroundColor: const Color(0xFFffffff),
        body: Obx(() => scaffoldTab(context)),
      ),
    );
  }
}
