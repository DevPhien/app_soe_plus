import 'package:fade_shimmer/fade_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:soe/utils/golbal/golbal.dart';
import 'package:soe/views/component/use/avatar.dart';
import 'package:soe/views/request/comp/teamrequest/requestmembercontroller.dart';
import 'package:soe/views/request/controller/requestcontroller.dart';

class RequestMember extends StatelessWidget {
  final RequestMemberController controller = Get.put(RequestMemberController());
  final RequestController rqcontroller = Get.put(RequestController());
  RequestMember({Key? key}) : super(key: key);

  Widget bindRow(context, d) {
    Color han = Colors.black26;
    if (d["SoNgayHan"] != null) {
      if (d["SoNgayHan"] == 0) {
        han = Colors.orange;
      } else if (d["SoNgayHan"] < 0) {
        han = Colors.redAccent;
      }
    }
    List sigs = d["Signs"];
    Widget widgetUutien = const SizedBox(width: 5.0);
    if (d["Uutien"] == 1) {
      widgetUutien = Container(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 0.0),
          child: const Icon(Icons.star, color: Colors.orange));
    } else if (d["Uutien"] == 2) {
      widgetUutien = Container(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 0.0),
          child: Wrap(
            children: const [
              Icon(Icons.star, color: Colors.red),
              Icon(Icons.star, color: Colors.red)
            ],
          ));
    }
    return InkWell(
      onTap: () {
        rqcontroller.goRequest(d);
      },
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(
                  top: d["Uutien"] == 0 ? 0 : 15, left: 5.0, right: 5.0),
              child: d["Trangthai"] == 2
                  ? const Icon(AntDesign.checkcircle,
                      color: Color(0xFF6dd230), size: 20.0)
                  : const Icon(MaterialIcons.radio_button_unchecked,
                      color: Colors.black38, size: 22.0),
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              "${d["Title"] ?? ""}",
                              style: TextStyle(
                                  color: d["IsCheck"] == true
                                      ? const Color(0xFF6dd230)
                                      : Colors.black87,
                                  decoration: d["IsCheck"] == true
                                      ? TextDecoration.lineThrough
                                      : TextDecoration.none),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 5.0),
                            Row(children: [
                              Wrap(children: [
                                Icon(
                                  AntDesign.clockcircle,
                                  color: han,
                                  size: 12.0,
                                )
                              ]),
                              const SizedBox(width: 5.0),
                              Text(
                                "${d["Ngaylap"] != null ? Golbal.formatDate(d["Ngaylap"], "H:i d/m/Y") : ""} ${d["Dateline"] != null ? " - " + Golbal.formatDate(d["Dateline"], "H:i d/m/Y") : ""}",
                                style: TextStyle(color: han, fontSize: 12.0),
                              ),
                              const SizedBox(width: 5.0),
                            ]),
                          ],
                        ),
                      ),
                      Column(
                        children: [
                          rqcontroller.renderTrangthaiRQ(d),
                          widgetUutien,
                        ],
                      )
                    ],
                  ),
                  SizedBox(
                    height: 50,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: sigs
                          .map(
                            (si) => Container(
                              margin: const EdgeInsets.only(right: 20.0),
                              child: InkWell(
                                onTap: () {
                                  rqcontroller.viewUser(context, d);
                                },
                                child: Container(
                                  child: ListView.builder(
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    scrollDirection: Axis.horizontal,
                                    itemCount: si["users"].length,
                                    itemBuilder: (ct, i) => Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 2.0),
                                      child: UserAvarta(
                                        user: si["users"][i],
                                        radius: 15,
                                        color: rqcontroller.signColor(
                                          si["users"][i]["IsSign"],
                                          si["users"][i]["IsClose"],
                                        ),
                                      ),
                                    ),
                                  ),
                                  height: 46.0,
                                  padding: const EdgeInsets.only(top: 5.0),
                                ),
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ),
                ],
              ),
            ),
          ],
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
        backgroundColor: const Color(0xfff5f5f5),
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
                  automaticallyImplyLeading: false,
                  backgroundColor: Colors.white,
                  floating: true,
                  pinned: true,
                  snap: false,
                  centerTitle: false,
                  title: Row(
                    children: <Widget>[
                      IconButton(
                        onPressed: () {
                          Get.back();
                        },
                        icon: const Icon(
                          Feather.arrow_left,
                          color: Colors.black45,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        "Đề xuất của ${controller.user["ten"]} (${controller.user["tongso"]})",
                        style: TextStyle(
                          color: Golbal.appColor,
                        ),
                      ),
                    ],
                  ),
                  actions: const <Widget>[],
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
                          textInputAction: TextInputAction.search,
                          controller: controller.searchController,
                          onSubmitted: (txt) {
                            controller.search(txt);
                          },
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.all(5),
                            focusedBorder: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            border: InputBorder.none,
                            hintText: 'Tìm kiếm',
                            prefixIcon: IconButton(
                              onPressed: () {
                                controller
                                    .search(controller.searchController.text);
                              },
                              icon: const Icon(Icons.search),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
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
                                    return Card(
                                        child: bindRow(
                                            context, controller.datas[index]));
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
