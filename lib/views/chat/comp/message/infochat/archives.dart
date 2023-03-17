import 'package:cached_network_image/cached_network_image.dart';
import 'package:fade_shimmer/fade_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:soe/utils/golbal/golbal.dart';
import 'package:soe/views/chat/comp/message/infochat/archivescontroller.dart';
import 'package:soe/views/component/compavarta.dart';

class Archives extends StatelessWidget {
  final ArchivesController controller = Get.put(ArchivesController());
  Archives({Key? key}) : super(key: key);

  Widget fileWidget(r, double w) {
    return Container(
      //margin: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.black12,
        ),
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: Container(
        child: r["IsImage"] == true
            ? Image(
                image: CachedNetworkImageProvider(
                  "${Golbal.congty!.fileurl}${r["duongDan"]}",
                ),
                width: w - 20,
                height: w - 70,
                fit: BoxFit.cover,
              )
            : Container(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: (r["loaiFile"] != null && r["loaiFile"] != "")
                          ? Image(
                              image: AssetImage(
                                  "assets/file/${r["loaiFile"].replaceAll('.', '')}.png"),
                              width: w - 20,
                              height: w - 100,
                              fit: BoxFit.contain,
                            )
                          : SizedBox(
                              width: w - 20,
                              height: w - 100,
                              child: const Center(
                                child: Icon(
                                  Feather.image,
                                  color: Colors.black45,
                                ),
                              ),
                            ),
                    ),
                    Text(
                      r["tenFile"] ?? "",
                      style: const TextStyle(fontSize: 14.0),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 5.0),
                    Row(
                      children: <Widget>[
                        if (r["dungLuong"] != null) ...[
                          Text(Golbal.formatBytes(r["dungLuong"]),
                              style: const TextStyle(
                                  fontSize: 13.0, color: Colors.black54))
                        ],
                      ],
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  Widget bindRow(item, i) {
    String group =
        Golbal.dayAgo(controller.datas[i]["groupngayNgui"], thu: true);
    return Container(
      margin: const EdgeInsets.only(bottom: 10.0),
      decoration: const BoxDecoration(
        color: Colors.white,
      ),
      child: Container(
        margin: const EdgeInsets.only(left: 15.0, right: 15.0, bottom: 15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              color: const Color(0xffffffff),
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 15.0),
              child: Text(
                group,
                style: TextStyle(
                    color: Golbal.appColor, fontWeight: FontWeight.bold),
              ),
            ),
            GridView.builder(
              padding: EdgeInsets.zero,
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                childAspectRatio: 0.90,
                crossAxisCount: 3,
                crossAxisSpacing: 15.0,
                mainAxisSpacing: 15.0,
              ),
              itemCount: item["files"].length,
              itemBuilder: (context, index) {
                var tm = item["files"][index];
                double w = MediaQuery.of(context).size.width / 2 - 50;
                return InkWell(
                  child: fileWidget(tm, w),
                  onTap: () {
                    Golbal.loadFile(tm["duongDan"]);
                  },
                );
              },
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
        backgroundColor: Colors.white,
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
                  leading: IconButton(
                    icon: Icon(
                      Ionicons.chevron_back_outline,
                      color: Colors.black.withOpacity(0.5),
                      size: 30,
                    ),
                    onPressed: () {
                      Get.back();
                    },
                  ),
                  title: const Text("Kho dữ liệu",
                      style: TextStyle(
                          color: Color(0xFF0186f8),
                          fontWeight: FontWeight.bold,
                          fontSize: 24.0)),
                  actions: const <Widget>[CompUserAvarta()],
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
                      () => controller.loading.value
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
                              ? Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      decoration: const BoxDecoration(
                                          color: Color(0xfff5f5f5)),
                                      child: ListView.builder(
                                        //controller: controller.scrollController,
                                        shrinkWrap: true,
                                        padding: EdgeInsets.zero,
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        itemBuilder: (context, index) {
                                          return bindRow(
                                              controller.datas[index], index);
                                        },
                                        itemCount: controller.datas.length,
                                      ),
                                    ),
                                  ],
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
