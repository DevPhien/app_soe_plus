import 'package:fade_shimmer/fade_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:soe/utils/golbal/golbal.dart';
import 'package:soe/views/component/use/avatar.dart';
import 'package:soe/views/task/comp/hometask/detail/giahan/giahancontroller.dart';

class GiahanTask extends StatelessWidget {
  final GiahanTaskController controller = Get.put(GiahanTaskController());
  GiahanTask({Key? key}) : super(key: key);

  Widget bindRow(context, item, i) {
    bool isdelete = item["Dongy"] == null &&
        item["Nguoigiahan"] == Golbal.store.user["user_id"];
    return Container(
        padding: const EdgeInsets.fromLTRB(15.0, 15.0, 15.0, 5.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              width: 48,
              height: 48,
              child: UserAvarta(user: {
                "fullName": item["fullNameNguoigui"],
                "ten": item["tenNguoigui"],
                "anhThumb": item["anhThumbNguoigui"],
              }),
            ),
            const SizedBox(width: 15.0),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Expanded(
                          child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            item["fullNameNguoigui"] ?? "",
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 15.0),
                          ),
                          const SizedBox(height: 5.0),
                          Row(
                            children: <Widget>[
                              Chip(
                                  labelPadding: const EdgeInsets.all(0),
                                  avatar: const Icon(
                                      MaterialCommunityIcons
                                          .calendar_month_outline,
                                      color: Colors.white,
                                      size: 14),
                                  label: Text(
                                      item["HanxulyCu"] != null
                                          ? Golbal.formatDate(
                                              item["HanxulyCu"], "d/m/Y",
                                              nam: true)
                                          : "Chưa chọn",
                                      style: const TextStyle(
                                          fontSize: 11.0, color: Colors.white)),
                                  backgroundColor: const Color(0xFFff8b4e)),
                              const SizedBox(width: 5.0),
                              item["Dongy"] == true
                                  ? Chip(
                                      labelPadding: const EdgeInsets.all(0),
                                      avatar: const Icon(
                                          MaterialCommunityIcons.calendar_clock,
                                          color: Colors.white,
                                          size: 14),
                                      label: Text(
                                          item["HanxulyMoi"] != null
                                              ? Golbal.formatDate(
                                                  item["HanxulyMoi"], "d/m/Y",
                                                  nam: true)
                                              : "Chưa chọn",
                                          style: const TextStyle(
                                              fontSize: 11.0,
                                              color: Colors.white)),
                                      backgroundColor: const Color(0xff6fbf73))
                                  : const SizedBox.shrink(),
                            ],
                          ),
                          const SizedBox(height: 5.0),
                          Text(item["Lydo"] ?? "",
                              style: const TextStyle(
                                  fontWeight: FontWeight.normal,
                                  fontSize: 14.0,
                                  color: Colors.black87)),
                          const SizedBox(height: 5.0),
                          if (item["Dongy"] == null &&
                              controller.task["quanly"] == true &&
                              controller.task["YeucauReview"] == true) ...[
                            Row(
                              children: <Widget>[
                                TextButton(
                                  onPressed: () {
                                    controller.funreview(context, item, false);
                                  },
                                  child: const Text(
                                    "Không đồng ý",
                                    style: TextStyle(
                                        color: Colors.red, fontSize: 13.0),
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    controller.funreview(context, item, true);
                                  },
                                  child: Text(
                                    "Đồng ý",
                                    style: TextStyle(
                                        color: Golbal.appColor, fontSize: 13.0),
                                  ),
                                )
                              ],
                            ),
                          ],
                        ],
                      )),
                      const SizedBox(width: 10.0),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          const SizedBox(height: 5.0),
                          Text(
                            item["Ngaygiahan"] != null
                                ? Golbal.timeAgo(item["Ngaygiahan"].toString())
                                : "",
                            style: const TextStyle(
                                fontSize: 12.0, color: Colors.black54),
                          ),
                          const SizedBox(height: 15.0),
                          renderTypeTT(item),
                          if (isdelete) ...[
                            IconButton(
                              icon: const Icon(EvilIcons.trash),
                              onPressed: () {
                                //deleteGiahan(r);
                              },
                            ),
                          ],
                        ],
                      )
                    ],
                  ),
                  if (item["Dongy"] != null &&
                      item["Nguoiduyet"] != item["Nguoigiahan"]) ...[
                    //bindReview(r),
                  ],
                ],
              ),
            ),
          ],
        ));
  }

  Widget renderTypeTT(d) {
    bool? tt = d["Dongy"];
    switch (tt) {
      case true:
        return Container(
          decoration: BoxDecoration(
              color: Golbal.appColor,
              borderRadius: BorderRadius.circular(30.0)),
          padding: const EdgeInsets.symmetric(vertical: 3.0, horizontal: 5.0),
          child: const Text(
            "Đã duyệt",
            style: TextStyle(color: Colors.white, fontSize: 10.0),
          ),
        );
      case false:
        return Container(
          decoration: BoxDecoration(
              color: Colors.red, borderRadius: BorderRadius.circular(30.0)),
          padding: const EdgeInsets.symmetric(vertical: 3.0, horizontal: 5.0),
          child: const Text(
            "Không duyệt",
            style: TextStyle(color: Colors.white, fontSize: 10.0),
          ),
        );
    }
    return Container(
      decoration: BoxDecoration(
          color: Golbal.appColor, borderRadius: BorderRadius.circular(30.0)),
      padding: const EdgeInsets.symmetric(vertical: 3.0, horizontal: 5.0),
      child: const Text(
        "Đợi duyệt",
        style: TextStyle(color: Colors.white, fontSize: 10.0),
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
        floatingActionButton: Obx(
          () => controller.isGiahan.value == true
              ? FloatingActionButton(
                  backgroundColor: Colors.orange,
                  heroTag: "giahan",
                  onPressed: () {
                    controller.openModelGiahan(context);
                  },
                  child: const Icon(
                    Feather.clock,
                  ),
                )
              : const SizedBox.shrink(),
        ),
        body: Obx(
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
                      "Gia hạn công việc",
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
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 16),
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
                                      context, controller.datas[index], index);
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
    );
  }
}
