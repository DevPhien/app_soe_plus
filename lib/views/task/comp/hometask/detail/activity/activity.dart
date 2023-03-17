import 'package:fade_shimmer/fade_shimmer.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:soe/utils/golbal/golbal.dart';
import 'package:soe/views/component/use/avatar.dart';
import 'package:soe/views/task/comp/hometask/detail/activity/activitycontroller.dart';

class AtivityTask extends StatelessWidget {
  final ActivityTaskController controller = Get.put(ActivityTaskController());
  AtivityTask({Key? key}) : super(key: key);

  Widget renderHtmlContentNoti(String content) {
    List<String> contents = (content).toString().split("</soe>");
    if (contents.isEmpty) {
      return Text(
        Golbal.removeAllHtmlTags(content),
        style: const TextStyle(fontSize: 13.0),
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
                fontWeight: FontWeight.bold, fontSize: 13, color: Colors.black),
          ));
        } catch (e) {
          if (kDebugMode) {
            print(e);
          }
        }
      } else {
        wgs.add(TextSpan(
          text: Golbal.removeAllHtmlTags(content),
          style: const TextStyle(
              fontWeight: FontWeight.w600, fontSize: 13, color: Colors.black),
        ));
      }
    }
    return RichText(
      text: TextSpan(
        style: const TextStyle(color: Colors.black54),
        children: wgs,
      ),
    );
  }

  Widget bindRow(n, i) {
    Widget cr = const CircleAvatar(
      backgroundColor: Color(0xFFeeeeee),
      radius: 12.0,
      child: Icon(
        EvilIcons.comment,
        size: 16,
        color: Colors.black87,
      ),
    );
    switch (n["IsType"]) {
      case 5: //Tạo mới Task
        cr = const CircleAvatar(
          backgroundColor: Color(0xFF33c9dc),
          radius: 12.0,
          child: Icon(
            MaterialCommunityIcons.playlist_plus,
            size: 16,
            color: Colors.white,
          ),
        );
        break;
      case 6:
        cr = const CircleAvatar(
          backgroundColor: Color(0xFFff8b4e),
          radius: 12.0,
          child: Icon(
            Feather.info,
            size: 16,
            color: Colors.white,
          ),
        );
        break;
      case 7:
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
      case 8:
        cr = const CircleAvatar(
          backgroundColor: Color(0xFF6fbf73),
          radius: 12.0,
          child: Icon(
            Entypo.attachment,
            size: 16,
            color: Colors.white,
          ),
        );
        break;
    }
    Widget nd = Text(
      Golbal.removeAllHtmlTags(n["Noidung"] ?? ""),
      style: const TextStyle(fontSize: 13.0),
      maxLines: 3,
      overflow: TextOverflow.ellipsis,
      textAlign: TextAlign.justify,
    );
    String content = n["Noidung"] ?? "";
    nd = renderHtmlContentNoti(content);
    Widget widgetNoti = ListTile(
      leading: Stack(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 5.0),
            child: SizedBox(
              width: 48,
              height: 48,
              child: UserAvarta(user: n),
            ),
          ),
          Positioned(
            bottom: 0.0,
            right: 0.0,
            child: cr,
          )
        ],
      ),
      title: nd,
      trailing: Text(
        Golbal.timeAgo(n["NgayTao"]),
        style: const TextStyle(color: Colors.black45, fontSize: 12.0),
      ),
    );
    String group = Golbal.dayAgo(n["NgayTao"], thu: true);
    Color col = const Color(0xffffffff);
    if (i == 0) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            color: col,
            width: double.infinity,
            padding: const EdgeInsets.all(10.0),
            child: Text(
              group,
              style: TextStyle(
                  color: Golbal.appColor, fontWeight: FontWeight.bold),
            ),
          ),
          widgetNoti
        ],
      );
    } else {
      String groupold =
          Golbal.dayAgo(controller.datas[i - 1]["NgayTao"], thu: true);
      if (group != groupold) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              color: col,
              width: double.infinity,
              padding: const EdgeInsets.all(10.0),
              child: Text(
                group,
                style: TextStyle(
                    color: Golbal.appColor, fontWeight: FontWeight.bold),
              ),
            ),
            widgetNoti,
          ],
        );
      }
    }
    return widgetNoti;
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context)
          .copyWith(textScaleFactor: Golbal.textScaleFactor),
      child: Scaffold(
        backgroundColor: const Color(0xFFffffff),
        body: NotificationListener<UserScrollNotification>(
          onNotification: (scrollInfo) {
            if (scrollInfo.metrics.axisDirection == AxisDirection.down) {
              if (scrollInfo.metrics.pixels ==
                      scrollInfo.metrics.maxScrollExtent &&
                  controller.datas.length < controller.countdata.value) {
                controller.onLoadmore();
              }
              if (scrollInfo.direction == ScrollDirection.reverse) {
                if (controller.showFab.value) {
                  controller.showFab.value = false;
                }
              } else if (scrollInfo.direction == ScrollDirection.forward) {
                if (!controller.showFab.value) {
                  controller.showFab.value = true;
                }
              }
            }
            return true;
          },
          child: Obx(
            () => CustomScrollView(
              controller: controller.scrollController,
              slivers: [
                SliverAppBar(
                  automaticallyImplyLeading: true,
                  backgroundColor: Colors.white,
                  floating: true,
                  pinned: true,
                  snap: false,
                  centerTitle: false,
                  iconTheme: IconThemeData(color: Golbal.iconColor),
                  title: Row(
                    children: <Widget>[
                      Text(
                        "Hoạt động",
                        style: TextStyle(
                          color: Golbal.appColor,
                        ),
                      ),
                    ],
                  ),
                  actions: const <Widget>[],
                  systemOverlayStyle: Golbal.systemUiOverlayStyle1,
                ),
                SliverList(
                  delegate: SliverChildListDelegate([
                    Obx(
                      () => controller.loading.value == true
                          ? ListView.separated(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (_, i) {
                                final delay = (i * 300);
                                return Container(
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(8)),
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 16),
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
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
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
                          : controller.datas.isNotEmpty
                              ? ListView.builder(
                                  //controller: controller.scrollController,
                                  shrinkWrap: true,
                                  padding: EdgeInsets.zero,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemBuilder: (context, index) {
                                    return bindRow(
                                        controller.datas[index], index);
                                  },
                                  itemCount: controller.datas.length,
                                )
                              : const SizedBox.shrink(),
                    ),
                  ]),
                ),
                if (!controller.loading.value && controller.datas.isEmpty) ...[
                  SliverFillRemaining(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Center(
                            child: Lottie.network(
                                "https://assets10.lottiefiles.com/packages/lf20_fp7svyno.json"),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
