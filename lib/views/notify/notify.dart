import 'package:circular_image/circular_image.dart';
import 'package:date_time_format/date_time_format.dart';
import 'package:fade_shimmer/fade_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:soe/views/component/use/avatar.dart';

import '../../utils/golbal/golbal.dart';
import '../component/use/nodata.dart';
import 'notifycontroller.dart';

class Noty extends StatelessWidget {
  final NotyController controller = Get.put(NotyController());
  Noty({Key? key}) : super(key: key);
  //Function
  Widget renderHtmlContentNoti(String? content) {
    List<String> contents = (content ?? "").toString().split("</soe>");
    if (contents.isEmpty) {
      return Text(
        Golbal.removeAllHtmlTags(content ?? ""),
        style: const TextStyle(fontSize: 13.0),
        maxLines: 3,
        overflow: TextOverflow.ellipsis,
        textAlign: TextAlign.justify,
      );
    }
    List<TextSpan> wgs = [];
    for (var content in contents) {
      int st = content.indexOf("<soe>");
      if (st != -1) {
        try {
          wgs.add(TextSpan(
            text: content.substring(0, st),
          ));
          wgs.add(TextSpan(
            text: content.substring(st + 5),
            style: const TextStyle(
                fontWeight: FontWeight.w600, color: Colors.black),
          ));
        } catch (e) {}
      } else {
        wgs.add(TextSpan(
          text: Golbal.removeAllHtmlTags(content),
          style:
              const TextStyle(fontWeight: FontWeight.w600, color: Colors.black),
        ));
      }
    }
    return RichText(
        text: TextSpan(
      style: const TextStyle(color: Colors.black54),
      children: wgs,
    ));
  }

  Map<DismissDirection, double> _dismissThresholds() {
    Map<DismissDirection, double> map = <DismissDirection, double>{};
    map.putIfAbsent(DismissDirection.horizontal, () => 0.5);
    return map;
  }

  Widget itemNoty(int i) {
    var n = controller.datas[i];
    Widget nd = Text(
      Golbal.removeAllHtmlTags(n["noiDung"] ?? ""),
      style: const TextStyle(fontSize: 13.0),
      maxLines: 3,
      overflow: TextOverflow.ellipsis,
      textAlign: TextAlign.justify,
    );
    Widget cr = CircleAvatar(
      backgroundColor: Golbal.titleColor,
      radius: 12.0,
      backgroundImage: const AssetImage("assets/logoso.png"),
    );
    switch (n["loai"]) {
      case 0: //Văn bản
        cr = const CircleAvatar(
          backgroundColor: Color(0xff549e96),
          radius: 12.0,
          child: Icon(
            AntDesign.inbox,
            size: 13,
            color: Colors.white,
          ),
        );
        break;
      case 1: //Chat
        cr = const CircleAvatar(
          backgroundColor: Color(0xFF7e4ca9),
          radius: 12.0,
          child: Icon(
            AntDesign.message1,
            size: 13,
            color: Colors.white,
          ),
        );
        break;
      case 5:
        cr = const CircleAvatar(
          backgroundColor: Color(0xFF07bdb2),
          radius: 12.0,
          child: Icon(
            AntDesign.car,
            size: 13,
            color: Colors.white,
          ),
        );

        break;
      case 6:
        cr = const CircleAvatar(
          backgroundColor: Color(0xffab2b05),
          radius: 12.0,
          child: Icon(
            FontAwesome.dollar,
            size: 13,
            color: Colors.white,
          ),
        );

        break;
      case 3: //Lịch
        cr = const CircleAvatar(
          backgroundColor: Color(0xFFaf9b2d),
          radius: 12.0,
          child: Icon(
            AntDesign.calendar,
            size: 13,
            color: Colors.white,
          ),
        );
        break;
      case 2: //Thông báo
        cr = const CircleAvatar(
          backgroundColor: Color(0xfff95821),
          radius: 12.0,
          child: Icon(
            Entypo.bell,
            size: 13,
            color: Colors.white,
          ),
        );
        break;
      case 12: //Văn phòng phẩm
        cr = const CircleAvatar(
          backgroundColor: Color(0xff4286f5),
          radius: 12.0,
          child: Icon(
            Entypo.book,
            size: 13,
            color: Colors.white,
          ),
        );
        break;
      case 7: //Đồng phục
        cr = const CircleAvatar(
          backgroundColor: Color(0xfff5389f),
          radius: 12.0,
          child: Icon(
            Entypo.user,
            size: 13,
            color: Colors.white,
          ),
        );
        break;
      case 9: //Tin tức
        cr = const CircleAvatar(
          backgroundColor: Color(0xfff95821),
          radius: 12.0,
          child: Icon(
            Entypo.news,
            size: 13,
            color: Colors.white,
          ),
        );
        break;
      case 13: //Đề xuất
        cr = const CircleAvatar(
          backgroundColor: Color(0xff6a5b94),
          radius: 12.0,
          child: Icon(
            Feather.send,
            size: 13,
            color: Colors.white,
          ),
        );
        break;
      case 10: //Dự án
      case 11: //Công việc
      case 14: //Công việc
        cr = const CircleAvatar(
          backgroundColor: Color(0xff0186f7),
          radius: 12.0,
          child: Icon(
            Octicons.tasklist,
            size: 13,
            color: Colors.white,
          ),
        );
        break;
    }
    String content = n["noiDungNoti"] ?? n["noiDung"] ?? "";
    nd = renderHtmlContentNoti(content);
    Widget widgetNoti = Dismissible(
        key: Key(n["sendHubID"].toString()),
        direction: DismissDirection.endToStart,
        onDismissed: (DismissDirection direction) {
          controller.delNotification(n);
        },
        resizeDuration: null,
        dismissThresholds: _dismissThresholds(),
        background: Container(
          color: Colors.red,
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.delete, color: Colors.white),
                onPressed: () {
                  controller.delNotification(n);
                },
              ),
            ],
          ),
        ),
        child: Container(
            color: n["doc"] == true ? Colors.white : const Color(0xFFedf2fa),
            child: ListTile(
                onTap: () {
                  controller.goNotification(n);
                },
                leading: Stack(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(right: 5.0),
                      child: SizedBox(
                        width: 48,
                        height: 48,
                        child: UserAvarta(user: n, radius: 24),
                      ),
                    ),
                    Positioned(
                      bottom: 0.0,
                      right: 0.0,
                      child: cr,
                    )
                  ],
                ),
                title: Text(
                  n["tieuDe"],
                  style: TextStyle(
                      fontSize: 13.0,
                      fontWeight: n["doc"] == true
                          ? FontWeight.normal
                          : FontWeight.w700),
                ),
                subtitle: nd,
                trailing: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    const Icon(Feather.more_horizontal, color: Colors.black45),
                    Text(
                        DateTimeFormat.format(DateTime.parse(n["ngayGui"]),
                            format: 'd/m/Y H:i'),
                        style: const TextStyle(
                            color: Colors.black45, fontSize: 12.0))
                  ],
                ))));
    if (i == 0 || controller.datas[i - 1]["Ngay"] != n["Ngay"]) {
      return Column(children: [
        Container(
          padding: const EdgeInsets.all(10),
          color: const Color(0xFFF9F8F8),
          child: Row(
            children: [
              Expanded(
                  child: Text(
                "Ngày ${n['Ngay'] ?? ""}",
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: Golbal.titleColor),
              )),
              if (n["IsToday"] == true)
                Wrap(
                  children: [
                    SpinKitRipple(
                        size: 20.0,
                        duration: const Duration(milliseconds: 1200),
                        color: Colors.red.withOpacity(1)),
                    const Text("Hôm nay",
                        style: TextStyle(color: Color(0xFFFD5D19)))
                  ],
                ),
            ],
          ),
        ),
        widgetNoti,
      ]);
    }
    return widgetNoti;
  }

  Widget notyHome() {
    return Obx(() => controller.isLoadding.value
        ? ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (_, i) {
              final delay = (i * 300);
              return Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8)),
                margin: const EdgeInsets.symmetric(horizontal: 16),
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    FadeShimmer.round(
                      size: 60,
                      fadeTheme: FadeTheme.light,
                      millisecondsDelay: delay,
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        FadeShimmer(
                          height: 8,
                          width: 150,
                          radius: 4,
                          millisecondsDelay: delay,
                          fadeTheme: FadeTheme.light,
                        ),
                        const SizedBox(
                          height: 6,
                        ),
                        FadeShimmer(
                            height: 8,
                            millisecondsDelay: delay,
                            width: 170,
                            radius: 4,
                            fadeTheme: FadeTheme.light)
                      ],
                    )
                  ],
                ),
              );
            },
            itemCount: 20,
            separatorBuilder: (_, __) => const Divider(
              height: 1,
              color: Color(0xffeeeeee),
            ),
          )
        : controller.datas.isEmpty
            ? const SizedBox(
                height: 400,
                child: Center(
                  child: WidgetNoData(
                    txt: "Không có thông báo nào",
                    icon: Octicons.bell,
                  ),
                ),
              )
            : Padding(
                padding: const EdgeInsets.only(top: 10),
                child: ListView.builder(
                    padding: const EdgeInsets.all(0),
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: controller.datas.length,
                    itemBuilder: (ct, i) {
                      return itemNoty(i);
                    }),
              ));
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
        data: MediaQuery.of(context)
            .copyWith(textScaleFactor: Golbal.textScaleFactor),
        child: Scaffold(
          backgroundColor: const Color(0xffffffff),
          body: NotificationListener<ScrollEndNotification>(
            onNotification: (scrollEnd) {
              final metrics = scrollEnd.metrics;
              if (metrics.atEdge) {
                bool isTop = metrics.pixels == 0;
                if (isTop) {
                } else {
                  controller.onLoadmore();
                }
              }
              return true;
            },
            child: CustomScrollView(
              slivers: [
                SliverAppBar(
                  automaticallyImplyLeading: false,
                  backgroundColor: Colors.white,
                  floating: true,
                  pinned: true,
                  snap: false,
                  centerTitle: false,
                  title: Obx(() => Text(
                      "Thông báo - Notify (${controller.countTB})",
                      style: const TextStyle(
                          color: Color(0xFF0186f8),
                          fontWeight: FontWeight.bold,
                          fontSize: 24.0))),
                  actions: <Widget>[
                    InkWell(
                      onTap: () {
                        Get.toNamed("user");
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CircularImage(
                          radius: 20,
                          source: Golbal.store.user["Avartar"] ?? "",
                        ),
                      ),
                    )
                  ],
                  systemOverlayStyle: Golbal.systemUiOverlayStyle1,
                  bottom: AppBar(
                    elevation: 0,
                    backgroundColor: Colors.white,
                    automaticallyImplyLeading: false,
                    title: Container(
                      width: double.infinity,
                      height: 40,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          color: const Color(0xFFf9f8f8),
                          border: Border.all(
                              color: const Color(0xffeeeeee), width: 1.0)),
                      child: Center(
                        child: TextField(
                          onSubmitted: controller.search,
                          decoration: const InputDecoration(
                              contentPadding: EdgeInsets.all(5),
                              focusedBorder: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              border: InputBorder.none,
                              hintText: 'Tìm kiếm',
                              prefixIcon: Icon(Icons.search),
                              suffixIcon: Icon(AntDesign.filter)),
                        ),
                      ),
                    ),
                  ),
                ),
                // Other Sliver Widgets
                SliverList(
                  delegate: SliverChildListDelegate([
                    //CCountNoty(),
                    notyHome(),
                  ]),
                ),
              ],
            ),
          ),
        ));
  }
}
