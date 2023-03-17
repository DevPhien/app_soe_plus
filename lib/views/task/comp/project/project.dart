import 'package:fade_shimmer/fade_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:soe/utils/golbal/golbal.dart';
import 'package:soe/views/component/compavarta.dart';
import 'package:soe/views/task/comp/project/countproject.dart';
import 'package:soe/views/task/comp/project/itemproject.dart';
import 'package:soe/views/task/comp/project/projectcontroller.dart';

class Project extends StatelessWidget {
  final ProjectController controller = Get.put(ProjectController());
  Project({Key? key}) : super(key: key);

  Widget itemBuilder(ct, i) =>
      ItemProject(project: controller.datas[i], onClick: controller.goProject);

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
                  title: const Text("Dự án",
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
                            suffixIcon: Obx(
                              () => InkWell(
                                onTap: controller.goFilterAdv,
                                child: Icon(
                                  AntDesign.filter,
                                  color: controller.isSearchAdv.value
                                      ? Golbal.appColor
                                      : Colors.black54,
                                ),
                              ),
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
                      () => controller.isSearchAdv.value == true
                          ? Padding(
                              padding: const EdgeInsets.only(
                                  left: 30, top: 10, right: 20),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Kết quả tìm kiếm",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Golbal.titleColor,
                                          fontSize: 18)),
                                  TextButton(
                                    onPressed: controller.clearAdv,
                                    child: const Text(
                                      "Xoá kết quả",
                                      style: TextStyle(color: Colors.orange),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : CountProject(),
                    ),
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
                              ? ListView.builder(
                                  shrinkWrap: true,
                                  padding: EdgeInsets.zero,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemBuilder: itemBuilder,
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
        floatingActionButton: Obx(
          () => AnimatedSlide(
              duration: const Duration(milliseconds: 300),
              offset:
                  controller.showFab.value ? Offset.zero : const Offset(0, 2),
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 300),
                opacity: controller.showFab.value ? 1 : 0,
                child: FloatingActionButton(
                  child: const Icon(
                    Entypo.add_to_list,
                    color: Colors.white,
                    size: 24,
                  ),
                  backgroundColor: Golbal.appColor,
                  tooltip: 'Thêm mới dự án',
                  onPressed: controller.openAddProject,
                ),
              )),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      ),
    );
  }
}
