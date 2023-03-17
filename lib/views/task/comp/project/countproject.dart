import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:soe/views/task/comp/project/projectcontroller.dart';

class CountProject extends StatelessWidget {
  final ProjectController controller = Get.put(ProjectController());
  CountProject({Key? key}) : super(key: key);

  Widget countProject(context, String title, int ckey, int type) {
    return Obx(
      () => Container(
        margin: const EdgeInsets.only(left: 10.0),
        //padding: const EdgeInsets.symmetric(horizontal: 10.0),
        constraints: const BoxConstraints(
          minWidth: 90,
        ),
        decoration: BoxDecoration(
            color: (controller.typeP.value == type ||
                    (type == 999 &&
                        controller.typeP.value != 100 &&
                        // ignore: unrelated_type_equality_checks
                        controller.typeProjects.indexWhere(
                                (e) => e["id"] == controller.typeP.value) ==
                            -1))
                ? const Color(0xFFCEF1D9)
                : const Color(0xFFEFF8FF),
            borderRadius: BorderRadius.circular(5)),
        child: InkResponse(
          focusColor: Colors.transparent,
          hoverColor: Colors.transparent,
          highlightColor: Colors.transparent,
          onTap: () {
            controller.goTypeProject(context, type);
          },
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      "assets/doc.svg",
                      height: 32,
                    ),
                    const SizedBox(
                      height: 3,
                    ),
                    Text(
                      title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
              ),
              if (controller.countdatas[ckey] != null &&
                  controller.countdatas[ckey] > 0)
                Positioned(
                  top: 0,
                  left: 0,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: 2, horizontal: 8),
                    decoration: const BoxDecoration(
                      color: Color(0xfffd5d19),
                    ),
                    child: Text(
                      "${controller.countdatas[ckey] ?? ""}",
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 5.0),
      height: 70,
      child: Row(
        children: [
          Container(
            margin: const EdgeInsets.only(top: 5.0, left: 15.0, bottom: 5.0),
            constraints: const BoxConstraints(
              minWidth: 90,
            ),
            decoration: BoxDecoration(
              color: const Color(0xFF005A9E),
              borderRadius: BorderRadius.circular(5),
            ),
            //width: 90,
            child: InkResponse(
              focusColor: Colors.transparent,
              hoverColor: Colors.transparent,
              highlightColor: Colors.transparent,
              onTap: () {
                controller.goTypeProject(context, -1);
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const Text(
                      "Tổng số",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 3.0),
                    Obx(
                      () => Text(
                        "${controller.countdatas[-1] ?? ""}",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(vertical: 5.0),
              scrollDirection: Axis.horizontal,
              itemCount: controller.typeProjects.length,
              itemBuilder: (BuildContext context, int index) {
                var item = controller.typeProjects[index];
                return countProject(
                    context,
                    item["title"].toString(),
                    int.tryParse(item["id"].toString()) ?? 0,
                    int.tryParse(item["id"].toString()) ?? 1);
              },
            ),
          ),
          const SizedBox(width: 10)
        ],
      ),
    );
  }
}
