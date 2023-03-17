import 'package:fade_shimmer/fade_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:soe/utils/golbal/golbal.dart';
import 'package:soe/views/task/comp/hometask/detail/subtask/subtaskcontroller.dart';
import 'package:soe/views/task/comp/itemtask.dart';

class SubTask extends StatelessWidget {
  final SubTaskController controller = Get.put(SubTaskController());
  SubTask({Key? key}) : super(key: key);

  Widget itemBuilder(ct, i) =>
      ItemTask(task: controller.datas[i], onClick: controller.goTask);

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context)
          .copyWith(textScaleFactor: Golbal.textScaleFactor),
      child: Scaffold(
        backgroundColor: const Color(0xFFffffff),
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
                centerTitle: true,
                iconTheme: IconThemeData(color: Golbal.iconColor),
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "Công việc con",
                      style: TextStyle(
                        color: Golbal.appColor,
                      ),
                    ),
                  ],
                ),
                actions: <Widget>[
                  IconButton(
                    onPressed: () {
                      controller.addTask(
                          parentID: controller.task["CongviecID"]);
                    },
                    icon: const Icon(
                      MaterialIcons.playlist_add,
                      color: Colors.black54,
                    ),
                  ),
                ],
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
    );
  }
}
