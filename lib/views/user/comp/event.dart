import 'package:circular_image/circular_image.dart';
import 'package:date_time_format/date_time_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:soe/utils/golbal/golbal.dart';
import 'package:soe/views/birthday/controller/birthdaycontroller.dart';
import 'package:soe/views/user/comp/popuser.dart';

class Event extends StatelessWidget {
  final BirthdayController controller = Get.put(BirthdayController());

  Event({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    void showInfo(user) {
      showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) => PopUser(user: user),
      );
    }

    Widget renderSinhNhatHomNay() {
      return Container(
        margin: const EdgeInsets.only(bottom: 10.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5.0),
          color: Colors.white,
        ),
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              "Sinh nhật vào hôm nay ${DateTimeFormat.format(DateTime.parse(DateTime.now().toIso8601String()), format: 'd/m/Y')}",
              style: const TextStyle(
                color: Color(0xFF0186f8),
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              width: double.infinity,
              height: 108.0,
              child: ListView.builder(
                padding: const EdgeInsets.only(top: 10.0),
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                itemCount: controller.birthtoday_datas.length,
                itemBuilder: (ct, i) {
                  var user = controller.birthtoday_datas[i];
                  return InkWell(
                    onTap: (() {
                      showInfo(user);
                    }),
                    child: Container(
                      padding: const EdgeInsets.only(right: 10.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(right: 10.0),
                            child: InkWell(
                              child:
                                  (user["hasImage"] != null && user["hasImage"])
                                      ? CircularImage(
                                          radius: 24,
                                          source: user["anhThumb"],
                                        )
                                      : CircleAvatar(
                                          backgroundColor: HexColor("#AFDFCF"),
                                          radius: 24,
                                          child: Text(
                                            "${(user['subten'] ?? '')}",
                                            style: TextStyle(
                                              fontSize: 20,
                                              color: HexColor('#ffffff'),
                                            ),
                                          ),
                                        ),
                            ),
                          ),
                          Container(
                            constraints: BoxConstraints(
                                maxWidth: Golbal.screenSize.width - 50),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  "${user["fullName"] ?? ''}",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  "${user["tenToChuc"] ?? ''}",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 13.0,
                                  ),
                                ),
                                // Text("Bước sang tuổi ${u["tuoi"] ?? ""}",
                                //     style: TextStyle(
                                //         fontSize: 12.0,
                                //         color: Colors.black45)),
                                // RaisedButton(
                                //   shape: RoundedRectangleBorder(
                                //       borderRadius: BorderRadius.circular(20)),
                                //   padding:
                                //       const EdgeInsets.symmetric(horizontal: 15.0),
                                //   textColor: Colors.white,
                                //   color: Color(0xFFf25369),
                                //   onPressed: () {
                                //     goChat(u);
                                //   },
                                //   child: Text("Gửi lời chúc"),
                                // )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      );
    }

    Widget renderSinhNhatGanDay() {
      return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(10.0),
          margin: const EdgeInsets.only(top: 0.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5.0),
            color: Colors.white,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const SizedBox(height: 5.0),
              const Text("Sinh nhật gần đây",
                  style: TextStyle(
                    color: Color(0xFF0186f8),
                    fontWeight: FontWeight.bold,
                  )),
              const SizedBox(height: 10.0),
              SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                      children: controller.birthganday_datas
                          .map((user) => InkWell(
                                  child: Container(
                                padding: const EdgeInsets.only(right: 20.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    InkWell(
                                      child: (user["hasImage"] != null &&
                                              user["hasImage"])
                                          ? CircularImage(
                                              radius: 24,
                                              source: user["anhThumb"],
                                            )
                                          : CircleAvatar(
                                              backgroundColor:
                                                  HexColor("#AFDFCF"),
                                              radius: 24,
                                              child: Text(
                                                "${(user['subten'] ?? '')}",
                                                style: TextStyle(
                                                  fontSize: 20,
                                                  color: HexColor('#ffffff'),
                                                ),
                                              ),
                                            ),
                                    ),
                                    SizedBox(height: 7.0),
                                    Text(
                                        "${BirthdayController.getDayName(user["ngaySinh"])}",
                                        style: TextStyle(
                                            fontSize: 12.0,
                                            color: Colors.black87)),
                                    SizedBox(height: 2.0),
                                    Text(
                                        "${DateTimeFormat.format(DateTime.parse(user["ngaySinh"]), format: 'd/m')}",
                                        style: TextStyle(
                                            fontSize: 12.0,
                                            color: Colors.black45)),
                                  ],
                                ),
                              )))
                          .toList()))

              //Divider(height: 1.0, thickness: 1)
            ],
          ));
    }

    Widget renderSinhNhatSapToi() {
      return Container(
          padding: const EdgeInsets.all(10.0),
          margin: const EdgeInsets.only(top: 10.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5.0),
            color: Colors.white,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const SizedBox(height: 10.0),
              const Text("Sinh nhật sắp tới",
                  style: TextStyle(
                    color: Color(0xFF0186f8),
                    fontWeight: FontWeight.bold,
                  )),
              ListView.builder(
                shrinkWrap: true,
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                physics: NeverScrollableScrollPhysics(),
                itemCount: controller.birthsaptoi_datas.length,
                itemBuilder: (ct, i) {
                  var user = controller.birthsaptoi_datas[i];
                  return InkWell(
                      child: Container(
                    padding: const EdgeInsets.only(bottom: 20.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(right: 10.0),
                          child: InkWell(
                            child:
                                (user["hasImage"] != null && user["hasImage"])
                                    ? CircularImage(
                                        radius: 24,
                                        source: user["anhThumb"],
                                      )
                                    : CircleAvatar(
                                        backgroundColor: HexColor("#AFDFCF"),
                                        radius: 24,
                                        child: Text(
                                          "${(user['subten'] ?? '')}",
                                          style: TextStyle(
                                            fontSize: 20,
                                            color: HexColor('#ffffff'),
                                          ),
                                        ),
                                      ),
                          ),
                        ),
                        Container(
                          constraints: BoxConstraints(
                              maxWidth: Golbal.screenSize.width - 50),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text("${user["fullName"]}",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      fontSize: 13.0,
                                      fontWeight: FontWeight.w600)),
                              SizedBox(height: 2.0),
                              Text("${user["tenToChuc"] ?? ""}",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 12.0,
                                  )),
                              SizedBox(height: 2.0),
                              Text(
                                  "${BirthdayController.getDayName(user["ngaySinh"])} (${DateTimeFormat.format(DateTime.parse(user["ngaySinh"]), format: 'd/m')})",
                                  style: TextStyle(
                                      fontSize: 12.0, color: Colors.black45)),
                            ],
                          ),
                        )
                      ],
                    ),
                  ));
                },
              ),
            ],
          ));
    }

    // Widget renderSinhNhatThang() {
    //   if (controller.birthtomonth_datas.length == 0) return Container(width: 0.0);
    //   var groups =
    //       groupBy(controller.birthtomonth_datas, (dynamic obj) => obj['miy']);
    //   List keys = groups.keys.toList();
    //   List values = groups.values.toList();
    //   return ListView.builder(
    //     shrinkWrap: true,
    //     itemCount: keys.length,
    //     physics: NeverScrollableScrollPhysics(),
    //     itemBuilder: (context, index) {
    //       List us = values[index];
    //       us.sort((a, b) => a["ngay"].compareTo(b["ngay"]));
    //       return Container(
    //         padding: const EdgeInsets.all(10.0),
    //         margin: const EdgeInsets.only(top: 10.0),
    //         decoration: BoxDecoration(
    //           borderRadius: BorderRadius.circular(5.0),
    //           color: Colors.white,
    //         ),
    //         child: Column(
    //           crossAxisAlignment: CrossAxisAlignment.start,
    //           children: <Widget>[
    //             Row(
    //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //               children: <Widget>[
    //                 Text("Tháng ${keys[index]}",
    //                     style: TextStyle(
    //                         color: Color(0xFF0186f8),
    //                         fontWeight: FontWeight.w600)),
    //                 Text("${us.length}",
    //                     style: TextStyle(
    //                         fontWeight: FontWeight.w600, color: Colors.black87)),
    //               ],
    //             ),
    //             ListView.separated(
    //               shrinkWrap: true,
    //               padding: const EdgeInsets.symmetric(vertical: 10.0),
    //               physics: BouncingScrollPhysics(),
    //               itemCount: us.length,
    //               separatorBuilder: (ct, i) => Divider(thickness: 1),
    //               itemBuilder: (ct, i) {
    //                 var u = us[i];
    //                 return InkWell(
    //                      onTap: (() {
    //                          showInfo(user);
    //                          }),
    //                     child: Padding(
    //                       padding: const EdgeInsets.symmetric(vertical: 5.0),
    //                       child: Row(
    //                         children: <Widget>[
    //                           InkWell(
    //                             child: (u["hasImage"] != null && u["hasImage"])
    //                                 ? CircularImage(
    //                                     radius: 24,
    //                                     source: u["anhThumb"],
    //                                   )
    //                                 : CircleAvatar(
    //                                     backgroundColor: HexColor("#AFDFCF"),
    //                                     radius: 24,
    //                                     child: Text(
    //                                       "${(u['subten'] ?? '')}",
    //                                       style: TextStyle(
    //                                         fontSize: 20,
    //                                         color: HexColor('#ffffff'),
    //                                       ),
    //                                     ),
    //                                   ),
    //                           ),
    //                           Expanded(
    //                             child: Padding(
    //                               padding: const EdgeInsets.symmetric(
    //                                   horizontal: 10.0),
    //                               child: Column(
    //                                 crossAxisAlignment: CrossAxisAlignment.start,
    //                                 mainAxisAlignment: MainAxisAlignment.center,
    //                                 children: <Widget>[
    //                                   Text("${us[i]["fullName"] ?? ""}",
    //                                       style: TextStyle(
    //                                           fontWeight: FontWeight.w600)),
    //                                   SizedBox(height: 5.0),
    //                                   Text(
    //                                       "${us[i]["phone"] ?? ""}${us[i]["phone"] != null && us[i]["tenChucVu"] != null ? " | " : ""}${us[i]["tenChucVu"] ?? ""}",
    //                                       style: TextStyle(fontSize: 12.0))
    //                                 ],
    //                               ),
    //                             ),
    //                           ),
    //                           Text(
    //                               "${DateTimeFormat.format(DateTime.parse(us[i]["ngaySinh"]), format: 'd/m')}",
    //                               style: TextStyle(
    //                                   fontSize: 13.0, color: Colors.black45)),
    //                         ],
    //                       ),
    //                     ));
    //               },
    //             )
    //           ],
    //         ),
    //       );
    //     },
    //   );
    // }

    Widget renderSinhNhatThangFast() {
      List months = controller.months;
      List users = controller.birthtomonthorther_datas.value
          .where((e) => e["miy"] == controller.month)
          .toList();
      return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(10.0),
          margin: const EdgeInsets.only(top: 10.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5.0),
            color: Colors.white,
          ),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                const SizedBox(height: 10.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      "Sinh nhật tháng ${controller.month}",
                      style: const TextStyle(
                        color: Color(0xFF0186f8),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text("${users.length}",
                        style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Colors.black87)),
                  ],
                ),
                const SizedBox(height: 10.0),
                SizedBox(
                    height: 70.0,
                    child: ListView.builder(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        scrollDirection: Axis.horizontal,
                        physics: const BouncingScrollPhysics(),
                        itemCount: months.length,
                        itemBuilder: (ct, i) {
                          return Material(
                              type: MaterialType.button,
                              elevation: 0.0,
                              color: Colors.transparent,
                              shadowColor: Colors.grey[50],
                              child: InkWell(
                                onTap: () {
                                  controller.goMonth(i);
                                  //controller.month = i + 1;
                                  //controller.monthStream.add(controller.month);
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5.0),
                                    color: controller.month == i + 1
                                        ? const Color(0xFF0186f8)
                                        : const Color(0xFFeeeeee),
                                  ),
                                  margin: const EdgeInsets.only(right: 10.0),
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 8.0, horizontal: 10),
                                  child: Align(
                                      alignment: Alignment.center,
                                      child: Text("Tháng ${i + 1}",
                                          style: TextStyle(
                                              color: controller.month == i + 1
                                                  ? Colors.white
                                                  : Colors.black87))),
                                ),
                              ));
                        })),
                ListView.separated(
                  shrinkWrap: true,
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  physics: const BouncingScrollPhysics(),
                  itemCount: users.length,
                  separatorBuilder: (ct, i) => const Divider(thickness: 1),
                  itemBuilder: (ct, i) {
                    var user = users[i];
                    return InkWell(
                        child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5.0),
                      child: Row(
                        children: <Widget>[
                          InkWell(
                            child:
                                (user["hasImage"] != null && user["hasImage"])
                                    ? CircularImage(
                                        radius: 24,
                                        source: user["anhThumb"],
                                      )
                                    : CircleAvatar(
                                        backgroundColor: HexColor("#AFDFCF"),
                                        radius: 24,
                                        child: Text(
                                          "${(user['subten'] ?? '')}",
                                          style: TextStyle(
                                            fontSize: 20,
                                            color: HexColor('#ffffff'),
                                          ),
                                        ),
                                      ),
                          ),
                          Expanded(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text("${user["fullName"] ?? ""}",
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w600)),
                                  const SizedBox(height: 5.0),
                                  Text(
                                      "${user["phone"] ?? ""}${user["phone"] != null && user["tenChucVu"] != null ? " | " : ""}${user["tenChucVu"] ?? ""}",
                                      style: TextStyle(fontSize: 12.0))
                                ],
                              ),
                            ),
                          ),
                          Text(
                              DateTimeFormat.format(
                                  DateTime.parse(user["ngaySinh"]),
                                  format: 'd/m'),
                              style: const TextStyle(
                                  fontSize: 13.0, color: Colors.black45)),
                        ],
                      ),
                    ));
                  },
                )
              ]));
    }

    return MediaQuery(
        data: MediaQuery.of(context)
            .copyWith(textScaleFactor: Golbal.textScaleFactor),
        child: Scaffold(
          backgroundColor: const Color(0xFFf2f2f2),
          appBar: AppBar(
            iconTheme: const IconThemeData(color: Colors.black45),
            elevation: 0.0,
            titleSpacing: 0.0,
            backgroundColor: Colors.white,
            title: const Text("Sinh nhật",
                style: TextStyle(
                  color: Color(0xFF0186f8),
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                )),
            systemOverlayStyle: SystemUiOverlayStyle.light,
          ),
          body: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Obx(() => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      if (controller.birthtoday_datas.isNotEmpty)
                        renderSinhNhatHomNay(),
                      if (controller.birthganday_datas.isNotEmpty)
                        renderSinhNhatGanDay(),
                      if (controller.birthsaptoi_datas.isNotEmpty)
                        renderSinhNhatSapToi(),
                      renderSinhNhatThangFast(),
                    ],
                  )),
            ),
          ),
        ));
  }
}
