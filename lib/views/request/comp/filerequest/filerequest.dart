import 'package:cached_network_image/cached_network_image.dart';
import 'package:fade_shimmer/fade_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:soe/utils/golbal/golbal.dart';
import 'package:soe/views/component/compavarta.dart';
import 'package:soe/views/component/use/inlineloadding.dart';
import 'package:soe/views/request/comp/filerequest/filerequestcontroller.dart';

class FileRequest extends StatelessWidget {
  final FileRequestController controller = Get.put(FileRequestController());
  FileRequest({Key? key}) : super(key: key);

  Widget fileWidget(r, double w) {
    return Container(
      width: w,
      height: w - 50,
      margin: const EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 5.0),
      padding: const EdgeInsets.only(bottom: 5.0, top: 5.0),
      child: Center(
        child: r["IsImage"] == true
            ? Image(
                image: CachedNetworkImageProvider(
                  "${Golbal.congty!.fileurl}${r["Duongdan"]}",
                ),
                width: w - 20,
                height: w - 70,
                fit: BoxFit.contain,
              )
            : Image(
                image: AssetImage("assets/file/${r["Dinhdang"]}.png"),
                width: w - 20,
                height: w - 70,
                fit: BoxFit.contain,
              ),
      ),
    );
  }

  Widget gridWidget(context) {
    int gr = 2;
    if (MediaQuery.of(context).size.shortestSide > 600) {
      gr = 3;
    }
    return GridView.builder(
      padding: const EdgeInsets.symmetric(vertical: 20.0),
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          childAspectRatio: 0.90,
          crossAxisCount: gr,
          crossAxisSpacing: 15.0,
          mainAxisSpacing: 5.0),
      itemCount: controller.datas.length,
      itemBuilder: (context, index) {
        var tm = controller.datas[index];
        double w = MediaQuery.of(context).size.width / 2 - 50;
        return Column(
          children: <Widget>[
            InkWell(
              child: fileWidget(tm, w),
              onTap: () {
                Golbal.loadFile(tm["Duongdan"]);
              },
            ),
            Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 20.0, vertical: 10.0),
                child: Text(
                  "${tm["Tenfile"]}",
                  style: const TextStyle(fontSize: 14),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                )),
            const SizedBox(height: 5.0),
            Text(Golbal.timeAgo(tm["NgayTao"], ago: true),
                style: const TextStyle(fontSize: 11.0, color: Colors.black54)),
          ],
        );
      },
    );
  }

  Widget listWidget(context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(vertical: 20.0),
      itemCount: controller.datas.length,
      itemBuilder: (context, index) {
        var tm = controller.datas[index];
        return ListTile(
            onTap: () {
              Golbal.loadFile(tm["Duongdan"]);
            },
            leading: tm["IsImage"] == true
                ? Image(
                    image: CachedNetworkImageProvider(
                      "${Golbal.congty!.fileurl}${tm["Duongdan"]}",
                    ),
                    width: 48,
                    fit: BoxFit.contain,
                  )
                : Image(
                    image: AssetImage("assets/file/${tm["Dinhdang"]}.png"),
                    width: 48,
                    fit: BoxFit.contain,
                  ),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Expanded(
                        child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          tm["Tenfile"],
                          style: const TextStyle(fontSize: 14.0),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 5.0),
                        Row(
                          children: <Widget>[
                            if (tm["Dungluong"] != null) ...[
                              Text(Golbal.formatBytes(tm["Dungluong"]),
                                  style: const TextStyle(
                                      fontSize: 13.0, color: Colors.black54))
                            ],
                            const SizedBox(width: 5.0),
                            const Icon(EvilIcons.clock, size: 14.0),
                            const SizedBox(width: 2.0),
                            Text(
                              Golbal.timeAgo(tm["NgayTao"], ago: true),
                              style: const TextStyle(
                                fontSize: 13.0,
                                color: Colors.black54,
                              ),
                            )
                          ],
                        ),
                      ],
                    )),
                  ],
                ),
              ],
            ));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context)
          .copyWith(textScaleFactor: Golbal.textScaleFactor),
      child: Scaffold(
        backgroundColor: Colors.white,
        // appBar: AppBar(
        //   elevation: 0.0,
        //   backgroundColor: Colors.white,
        //   iconTheme: IconThemeData(color: Golbal.iconColor),
        //   titleSpacing: 0.0,
        //   centerTitle: true,
        //   title: Text("File", style: TextStyle(color: Golbal.appColor)),
        //   actions: [
        //     IconButton(
        //       icon: Icon(
        //           !controller.grid.value ? Feather.align_left : Feather.grid,
        //           color: Colors.white),
        //       onPressed: () {
        //         controller.setGrid();
        //       },
        //     ),
        //   ],
        // ),
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
                  title: const Text("File",
                      style: TextStyle(
                          color: Color(0xFF0186f8),
                          fontWeight: FontWeight.bold,
                          fontSize: 24.0)),
                  actions: <Widget>[
                    IconButton(
                        onPressed: () {
                          controller.setGrid();
                        },
                        icon: Icon(
                          controller.grid.value == true
                              ? Feather.grid
                              : Feather.list,
                          color: Colors.black45,
                        )),
                    const CompUserAvarta(),
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
                              ? controller.grid.value
                                  ? gridWidget(context)
                                  : listWidget(context)
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
