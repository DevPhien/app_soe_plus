import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:expandable_group/expandable_group.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:soe/utils/golbal/golbal.dart';
import 'package:soe/views/component/compavarta.dart';
import 'package:soe/views/component/use/avatar.dart';
import 'package:soe/views/component/use/inlineloadding.dart';
import 'package:soe/views/request/comp/teamrequest/teamrequestcontroller.dart';
import 'package:soe/views/request/controller/requestcontroller.dart';

class TeamRequest extends StatelessWidget {
  final TeamRequestController controller = Get.put(TeamRequestController());
  final RequestController rqcontroller = Get.put(RequestController());
  TeamRequest({Key? key}) : super(key: key);

  final Color selectColor = Golbal.appColor;
  final Color unselectColor = const Color(0xFFffffff);
  final TextStyle selectStyle =
      const TextStyle(color: Color(0xFFffffff), fontSize: 15);
  final TextStyle unselectStyle =
      const TextStyle(color: Color(0xFF333333), fontSize: 15);
  final BorderSide border = const BorderSide(color: Color(0xFFdddddd));

  Widget tabarWidget() {
    BorderRadius border2 = const BorderRadius.only(
      topRight: Radius.circular(10.0),
      bottomRight: Radius.circular(10.0),
    );
    BorderRadius border3 = const BorderRadius.only(
      topRight: Radius.circular(10.0),
      bottomRight: Radius.circular(10.0),
    );
    if (controller.isCty.value == true || controller.isAllCty.value == true) {
      border2 = const BorderRadius.only(
        topRight: Radius.circular(0.0),
        bottomRight: Radius.circular(0.0),
      );
    }
    if (controller.isAllCty.value == true) {
      border3 = const BorderRadius.only(
        topRight: Radius.circular(0.0),
        bottomRight: Radius.circular(0.0),
      );
    }

    return SizedBox(
      width: double.infinity,
      child: Center(
        child: Column(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.all(5.0),
              color: Colors.white,
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        controller.setIndexCongviec(1);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: const Color(0xFFdddddd)),
                          color: controller.index.value == 1
                              ? selectColor
                              : unselectColor,
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(10.0),
                            bottomLeft: Radius.circular(10.0),
                          ),
                        ),
                        padding: const EdgeInsets.symmetric(
                          vertical: 10.0,
                          horizontal: 5.0,
                        ),
                        child: Text(
                          "Cá nhân",
                          textAlign: TextAlign.center,
                          style: controller.index.value == 1
                              ? selectStyle
                              : unselectStyle,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        controller.setIndexCongviec(2);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: const Color(0xFFdddddd)),
                          color: controller.index.value == 2
                              ? selectColor
                              : unselectColor,
                          borderRadius: border2,
                        ),
                        padding: const EdgeInsets.symmetric(
                          vertical: 10.0,
                          horizontal: 5.0,
                        ),
                        child: Text(
                          "Thành viên",
                          textAlign: TextAlign.center,
                          style: controller.index.value == 2
                              ? selectStyle
                              : unselectStyle,
                        ),
                      ),
                    ),
                  ),
                  if (controller.isCty.value == true) ...[
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          controller.setIndexCongviec(3);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: const Color(0xFFdddddd)),
                            color: controller.index.value == 3
                                ? selectColor
                                : unselectColor,
                            borderRadius: border3,
                          ),
                          padding: const EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 5.0),
                          child: Text(
                            "Team",
                            textAlign: TextAlign.center,
                            style: controller.index.value == 3
                                ? selectStyle
                                : unselectStyle,
                          ),
                        ),
                      ),
                    ),
                  ],
                  if (controller.isAllCty.value == true) ...[
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          controller.setIndexCongviec(4);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: const Color(0xFFdddddd)),
                            color: controller.index.value == 4
                                ? selectColor
                                : unselectColor,
                            borderRadius: const BorderRadius.only(
                              topRight: Radius.circular(10.0),
                              bottomRight: Radius.circular(10.0),
                            ),
                          ),
                          padding: const EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 5.0),
                          child: Text("Công ty",
                              textAlign: TextAlign.center,
                              style: controller.index.value == 4
                                  ? selectStyle
                                  : unselectStyle),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget cardViewWidget(context, int so, String text, Color cl) {
    return Card(
      child: Container(
        constraints: const BoxConstraints(minWidth: 100),
        color: cl,
        padding: const EdgeInsets.all(5.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("$so",
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 32,
                    color: Colors.white)),
            const SizedBox(height: 10),
            Text(
              text,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<ListTile> _buildItems(BuildContext context, List items) {
    return items.map(
      (d) {
        return ListTile(
          title: ExpandablePanel(
            header: Padding(
              padding: const EdgeInsets.symmetric(vertical: 5.0),
              child: ListTile(
                leading: SizedBox(
                    width: 48,
                    height: 48,
                    child: UserAvarta(
                        user: d,
                        radius: 24,
                        index: int.parse(d["STT"].toString()) % 3)),
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      d["fullName"] ?? "",
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16.0),
                    ),
                    const SizedBox(height: 2.0),
                    d["tenToChuc"] != null
                        ? Text(
                            d["tenToChuc"] ?? "",
                            style: const TextStyle(
                                fontSize: 12.0, color: Colors.black54),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          )
                        : Container(
                            width: 0.0,
                          ),
                    const SizedBox(height: 2.0),
                    d["tongso"] != null && d["tongso"] > 0
                        ? Text(
                            "${d["tongso"]} đề xuất",
                            style: TextStyle(
                                fontSize: 12.0, color: Golbal.appColor),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          )
                        : Container(
                            width: 0.0,
                          ),
                    const SizedBox(height: 2.0),
                    d["Tiendo"] == null || d["Tiendo"] == 0
                        ? Container(width: 0.0)
                        : Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5.0),
                            child: LinearPercentIndicator(
                              backgroundColor:
                                  d["Tiendo"] == null || d["Tiendo"] == 0
                                      ? Colors.red
                                      : const Color(0xfff5f5f5),
                              animation: true,
                              animationDuration: 1000,
                              lineHeight: 20.0,
                              percent: d["Tiendo"] / 100,
                              center: Row(
                                children: <Widget>[
                                  d["Tiendo"] != null && d["Tiendo"] > 0
                                      ? Text(" ${d["Tiendo"].ceil()} %",
                                          style: TextStyle(
                                              color: d["Tiendo"] != null &&
                                                      d["Tiendo"] > 60
                                                  ? Colors.white
                                                  : Colors.black,
                                              fontSize: 12.0,
                                              fontWeight: FontWeight.bold))
                                      : Container(width: 0),
                                ],
                              ),
                              barRadius: const Radius.circular(16),
                              progressColor:
                                  rqcontroller.renderColor(d["Tiendo"]),
                            ),
                          ),
                  ],
                ),
              ),
            ),
            collapsed: const SizedBox.shrink(),
            expanded: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              child: d["tongso"] == 0
                  ? const Center(
                      child: Text("Hiện chưa có đề xuất nào"),
                    )
                  : Column(
                      children: [
                        chartRow(context, d),
                        ElevatedButton(
                          onPressed: () {
                            controller.goMember(context, d);
                          },
                          child: Text(
                            "Xem tất cả ${d["tongso"]} đề xuất của ${d["ten"]}",
                            style: const TextStyle(
                              color: Colors.black54,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        )
                      ],
                    ),
            ),
          ),
        );
      },
    ).toList();
  }

  Widget chartRow(context, d) {
    const List<Color> colorList = [
      Color(0xFF74b9ff),
      Color(0xFFff8b4e),
      Color(0xFF33c9dc),
      Color(0xFF6dd230),
      Color(0xFFf17ac7)
    ];
    Map<String, double> dataMap = Map();
    dataMap.putIfAbsent(
        "Mới lập (${d["moilap"]})", () => double.parse(d["moilap"].toString()));
    dataMap.putIfAbsent(
        "Quá hạn (${d["quahan"]})", () => double.parse(d["quahan"].toString()));
    dataMap.putIfAbsent("Chờ Duyệt (${d["choduyet"]})",
        () => double.parse(d["choduyet"].toString()));
    dataMap.putIfAbsent("Hoàn thành (${d["sohoanthanh"]})",
        () => double.parse(d["sohoanthanh"].toString()));
    dataMap.putIfAbsent(
        "Từ chối (${d["tuchoi"]})", () => double.parse(d["tuchoi"].toString()));
    return PieChart(
      dataMap: dataMap,
      animationDuration: Duration(milliseconds: 800),
      chartLegendSpacing: 32.0,
      chartRadius: MediaQuery.of(context).size.width,
      colorList: colorList,
      chartType: ChartType.disc,
      legendOptions: const LegendOptions(
        showLegendsInRow: false,
        legendPosition: LegendPosition.right,
        showLegends: true,
        legendShape: BoxShape.circle,
        legendTextStyle: TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      chartValuesOptions: const ChartValuesOptions(
        showChartValueBackground: true,
        showChartValues: true,
        showChartValuesInPercentage: false,
        showChartValuesOutside: false,
      ),
    );
  }

  Widget chartCV(context) {
    const List<Color> colorList = [
      Color(0xFF74b9ff),
      Color(0xFFff8b4e),
      Color(0xFF33c9dc),
      Color(0xFF6dd230),
      Color(0xFFf17ac7)
    ];
    Map<String, double> dataMap = {};
    dataMap.putIfAbsent("Mới lập (${controller.countRequest["0"]})",
        () => double.parse(controller.countRequest["0"].toString()));
    dataMap.putIfAbsent("Quá hạn (${controller.countRequest["6"]})",
        () => double.parse(controller.countRequest["6"].toString()));
    dataMap.putIfAbsent("Chờ Duyệt (${controller.countRequestDi["1"]})",
        () => double.parse(controller.countRequestDi["1"].toString()));
    dataMap.putIfAbsent("Hoàn thành (${controller.countRequest["2"]})",
        () => double.parse(controller.countRequest["2"].toString()));
    dataMap.putIfAbsent("Từ chối (${controller.countRequest["-2"]})",
        () => double.parse(controller.countRequest["-2"].toString()));
    return PieChart(
      dataMap: dataMap,
      animationDuration: const Duration(milliseconds: 800),
      chartLegendSpacing: 32.0,
      chartRadius: MediaQuery.of(context).size.width,
      colorList: colorList,
      chartType: ChartType.disc,
      legendOptions: const LegendOptions(
        showLegendsInRow: false,
        legendPosition: LegendPosition.right,
        showLegends: true,
        legendShape: BoxShape.circle,
        legendTextStyle: TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      chartValuesOptions: const ChartValuesOptions(
        showChartValueBackground: true,
        showChartValues: true,
        showChartValuesInPercentage: false,
        showChartValuesOutside: false,
      ),
    );
  }

  Widget bindRow(context, d) {
    d["percent"] = d["Tiendo"] ?? 0.0;
    d["percent"] = double.tryParse(d["percent"].toString())!.ceilToDouble();
    Color them = const Color(0xff6fbf73);
    if (d["percent"] <= 30) {
      them = Colors.red;
    } else if (d["percent"] <= 50) {
      them = Colors.orange;
    } else if (d["percent"] <= 80) {
      them = Golbal.appColor;
    }
    return InkWell(
      onTap: () {
        controller.goMember(context, d);
      },
      child: Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            UserAvarta(user: d, index: d["STT"] % 3, radius: 40),
            const SizedBox(height: 10.0),
            Text(
              d["fullName"] ?? "",
              style:
                  const TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
            ),
            const SizedBox(height: 2.0),
            if (d["tenToChuc"] != null) ...[
              Text(
                d["tenToChuc"] ?? "",
                style: const TextStyle(fontSize: 12.0, color: Colors.black54),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              )
            ],
            const SizedBox(height: 8.0),
            if (d["tongso"] != null && d["tongso"] != 0) ...[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: LinearPercentIndicator(
                  backgroundColor: d["percent"] == null || d["percent"] == 0
                      ? Colors.red
                      : const Color(0xfff5f5f5),
                  animation: true,
                  animationDuration: 1000,
                  lineHeight: 20.0,
                  percent: d["percent"] / 100,
                  center: Row(
                    children: <Widget>[
                      if (d["percent"] != null && d["percent"] > 0) ...[
                        Text(
                          " ${d["percent"]} %",
                          style: TextStyle(
                            color: d["percent"] != null && d["percent"] > 60
                                ? Colors.white
                                : Colors.black,
                            fontSize: 10.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                      const Spacer(),
                      Text(
                        "${d["sohoanthanh"]}/${d["tongso"]}",
                        style: TextStyle(
                          color: d["percent"] == null ||
                                  d["percent"] == 0 ||
                                  d["percent"] == 100
                              ? Colors.white
                              : Colors.black,
                          fontSize: 10.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  barRadius: const Radius.circular(16),
                  progressColor: them,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget persionalWidget(context) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 15.0),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                cardViewWidget(context, controller.countRequest["100"],
                    "Tất cả", const Color(0xFF74b9ff)),
                cardViewWidget(context, controller.countRequest["1"],
                    "Chờ tôi duyệt", const Color(0xFF33c9dc)),
                cardViewWidget(context, controller.countRequest["4"],
                    "Tôi đã duyệt", const Color(0xFF2196f3)),
                cardViewWidget(context, controller.countRequest["2"],
                    "Hoàn thành", const Color(0xFF6dd230)),
                cardViewWidget(context, controller.countRequest["5"],
                    "Theo dõi", const Color(0xFF8a2be2)),
                cardViewWidget(context, controller.countRequestDi["1"],
                    "Đang chờ duyệt", const Color(0xFF33c9dc)),
                cardViewWidget(context, controller.countRequest["-2"],
                    "Đã từ chối", const Color(0xFFf17ac7)),
                cardViewWidget(context, controller.countRequest["6"],
                    "Đã quá hạn", const Color(0xFFff8b4e)),
              ],
            ),
          ),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height / 2,
          child: controller.countRequest["thuchien"] == 0
              ? const Center(
                  child: Text("Bạn chưa có công việc nào được thực hiện."))
              : Card(
                  child: chartCV(context),
                  margin: const EdgeInsets.all(15.0),
                ),
        ),
        // const SizedBox(height: 5.0)
      ],
    );
  }

  Widget teamWidget(context) {
    return Container(
      color: const Color(0xfff5f5f5),
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0.0),
            child: Row(
              children: [
                Expanded(
                    child: Card(
                  child: Container(
                    padding: const EdgeInsets.all(10.0),
                    width: 100,
                    child: Column(
                      children: [
                        Text("${controller.teams.length}",
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 32,
                                color: Color(0xFF3192d3))),
                        const Text("Team"),
                      ],
                    ),
                  ),
                )),
                Expanded(
                  child: Card(
                    child: Container(
                      padding: const EdgeInsets.all(10.0),
                      width: 100,
                      child: Column(
                        children: [
                          Text(
                            "${controller.soCV}",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 32,
                              color: Colors.green,
                            ),
                          ),
                          const Text("Đề xuất"),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                    child: Card(
                  child: Container(
                    padding: const EdgeInsets.all(10.0),
                    width: 100,
                    child: Column(
                      children: [
                        Text(
                          "${controller.tiendoTV}%",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 32,
                            color: rqcontroller.renderColor(
                              controller.tiendoTV.ceilToDouble(),
                            ),
                          ),
                        ),
                        const Text("Tiến độ"),
                      ],
                    ),
                  ),
                ))
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.all(15.0),
            color: Colors.white,
            child: ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              padding: const EdgeInsets.all(0.0),
              itemCount: controller.teams.length,
              itemBuilder: (ct, i) {
                var d = controller.teams[i];
                return ExpandableGroup(
                  isExpanded: false,
                  header: ListTile(
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          d["Team_Name"] ?? "",
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16.0),
                        ),
                        const SizedBox(height: 2.0),
                        Row(
                          children: [
                            if (d["soRQ"] != null && d["soRQ"] > 0) ...[
                              Text(
                                "${d["soRQ"]} đề xuất",
                                style: TextStyle(
                                    fontSize: 12.0, color: Golbal.appColor),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                            const SizedBox(width: 10.0),
                            if (d["soUser"] != null && d["soUser"] > 0) ...[
                              Text(
                                "${d["soUser"]} thành viên",
                                style: const TextStyle(
                                    fontSize: 12.0, color: Colors.orange),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ],
                        ),
                        const SizedBox(height: 2.0),
                        if (d["Tiendo"] != null && d["Tiendo"] != 0) ...[
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5.0),
                            child: LinearPercentIndicator(
                              backgroundColor:
                                  d["Tiendo"] == null || d["Tiendo"] == 0
                                      ? Colors.red
                                      : const Color(0xfff5f5f5),
                              animation: true,
                              animationDuration: 1000,
                              lineHeight: 20.0,
                              percent: d["Tiendo"] / 100,
                              center: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  d["Tiendo"] != null && d["Tiendo"] > 0
                                      ? Text(" ${d["Tiendo"].ceil()} %",
                                          style: TextStyle(
                                              color: d["Tiendo"] != null &&
                                                      d["Tiendo"] > 60
                                                  ? Colors.white
                                                  : Colors.black,
                                              fontSize: 12.0,
                                              fontWeight: FontWeight.bold))
                                      : Container(width: 0),
                                ],
                              ),
                              barRadius: const Radius.circular(16),
                              progressColor:
                                  rqcontroller.renderColor(d["Tiendo"]),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  items: _buildItems(
                      context, List.castFrom(d["Thanhviens"]).toList()),
                );
              },
            ),
          )
        ],
      ),
    );
  }

  Widget memberWidget(context) {
    Widget grl;
    if (!controller.isGrid.value) {
      grl = Container(
        color: Colors.white,
        margin: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
        child: ListView.separated(
          separatorBuilder: (ct, i) => const Divider(
            height: 1.0,
            thickness: 0.5,
          ),
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          padding: const EdgeInsets.only(top: 10.0),
          itemCount: controller.members.length,
          itemBuilder: (ct, i) {
            var d = controller.members[i];
            return ExpandablePanel(
              header: Padding(
                padding: const EdgeInsets.symmetric(vertical: 5.0),
                child: ListTile(
                  leading: SizedBox(
                    width: 48,
                    height: 48,
                    child: UserAvarta(user: d, index: d["STT"] % 3),
                  ),
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        d["fullName"] ?? "",
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16.0),
                      ),
                      const SizedBox(height: 2.0),
                      if (d["tenToChuc"] != null) ...[
                        Text(
                          d["tenToChuc"] ?? "",
                          style: const TextStyle(
                              fontSize: 12.0, color: Colors.black54),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                      const SizedBox(height: 2.0),
                      if (d["tongso"] != null && d["tongso"] > 0) ...[
                        Text(
                          "${d["tongso"]} đề xuất",
                          style:
                              TextStyle(fontSize: 12.0, color: Golbal.appColor),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                      const SizedBox(height: 2.0),
                      d["Tiendo"] == null || d["Tiendo"] == 0
                          ? Container(width: 0.0)
                          : Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 5.0),
                              child: LinearPercentIndicator(
                                backgroundColor:
                                    d["Tiendo"] == null || d["Tiendo"] == 0
                                        ? Colors.red
                                        : const Color(0xfff5f5f5),
                                animation: true,
                                animationDuration: 1000,
                                lineHeight: 20.0,
                                percent: d["Tiendo"] / 100,
                                center: Row(
                                  children: <Widget>[
                                    d["Tiendo"] != null && d["Tiendo"] > 0
                                        ? Text(" ${d["Tiendo"].ceil()} %",
                                            style: TextStyle(
                                                color: d["Tiendo"] != null &&
                                                        d["Tiendo"] > 60
                                                    ? Colors.white
                                                    : Colors.black,
                                                fontSize: 12.0,
                                                fontWeight: FontWeight.bold))
                                        : Container(width: 0),
                                  ],
                                ),
                                barRadius: const Radius.circular(16),
                                progressColor:
                                    rqcontroller.renderColor(d["Tiendo"]),
                              ),
                            ),
                    ],
                  ),
                ),
              ),
              collapsed: const SizedBox.shrink(),
              expanded: Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: d["tongso"] == 0
                    ? const Center(
                        child: Text("Hiện chưa có đề xuất nào"),
                      )
                    : Column(
                        children: [
                          chartRow(context, d),
                          ElevatedButton(
                            onPressed: () {
                              controller.goMember(context, d);
                            },
                            child: Text(
                              "Xem tất cả ${d["tongso"]} đề xuất của ${d["ten"]}",
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
              ),
            );
          },
        ),
      );
    } else {
      int col = 2;
      double chilratio = 1;
      if (MediaQuery.of(context).size.width >= 600) {
        if (MediaQuery.of(context).size.shortestSide >= 900) {
          col = 5;
          chilratio = 1.4;
        } else if (MediaQuery.of(context).size.shortestSide >= 700) {
          col = 4;
          chilratio = 1.4;
        } else {
          col = 3;
          chilratio = 1.3;
        }
      }
      grl = Container(
        color: const Color(0xfff5f5f5),
        child: (controller.members.isNotEmpty)
            ? GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                padding: const EdgeInsets.all(10.0),
                itemCount: controller.members.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  childAspectRatio: chilratio,
                  crossAxisCount: col,
                  crossAxisSpacing: 5.0,
                  mainAxisSpacing: 5.0,
                ),
                itemBuilder: (context, index) {
                  return bindRow(context, controller.members[index]);
                },
              )
            : const SizedBox.shrink(),
      );
    }
    return Column(
      children: [
        Container(
          color: const Color(0xfff5f5f5),
          padding: const EdgeInsets.all(10.0),
          child: Row(
            children: [
              Expanded(
                  child: Card(
                child: Container(
                  padding: const EdgeInsets.all(10.0),
                  width: 100,
                  child: Column(
                    children: [
                      Text("${controller.countTV}",
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 32,
                              color: Color(0xFF3192d3))),
                      const Text("Thành viên"),
                    ],
                  ),
                ),
              )),
              Expanded(
                child: Card(
                  child: Container(
                    padding: const EdgeInsets.all(10.0),
                    width: 100,
                    child: Column(
                      children: [
                        Text(
                          "${controller.soCV}",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 32,
                            color: Colors.green,
                          ),
                        ),
                        const Text("Đề xuất"),
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                  child: Card(
                child: Container(
                  padding: const EdgeInsets.all(10.0),
                  width: 100,
                  child: Column(
                    children: [
                      Text("${controller.tiendoTV}%",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 32,
                              color: rqcontroller.renderColor(
                                  controller.tiendoTV.ceilToDouble()))),
                      const Text("Tiến độ"),
                    ],
                  ),
                ),
              ))
            ],
          ),
        ),
        grl
      ],
    );
  }

  Widget homeWidget(context) {
    switch (controller.index.value) {
      case 1:
        return persionalWidget(context);
      case 3:
        return teamWidget(context);
      case 4:
        return Container();
    }
    return memberWidget(context);
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context)
          .copyWith(textScaleFactor: Golbal.textScaleFactor),
      child: NotificationListener<UserScrollNotification>(
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
                title: const Text(
                  "Team",
                  style: TextStyle(
                    color: Color(0xFF0186f8),
                    fontWeight: FontWeight.bold,
                    fontSize: 24.0,
                  ),
                ),
                actions: <Widget>[
                  IconButton(
                      onPressed: () {
                        controller.setGrid();
                      },
                      icon: Icon(
                        controller.isGrid.value == true
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
                  title: tabarWidget(),
                ),
              ),
              SliverList(
                delegate: SliverChildListDelegate([
                  if (!controller.loading.value) ...[
                    homeWidget(context),
                  ]
                ]),
              ),
              if (controller.loading.value) ...[
                const SliverFillRemaining(
                  child: InlineLoadding(),
                ),
              ],
              // if (!controller.loading.value && controller.datas.isEmpty) ...[
              //   SliverFillRemaining(
              //     child: SingleChildScrollView(
              //       child: Column(
              //         crossAxisAlignment: CrossAxisAlignment.center,
              //         mainAxisAlignment: MainAxisAlignment.center,
              //         children: <Widget>[
              //           Center(
              //             child: Lottie.network(
              //                 "https://assets10.lottiefiles.com/packages/lf20_fp7svyno.json"),
              //           ),
              //         ],
              //       ),
              //     ),
              //   ),
              // ],
            ],
          ),
        ),
      ),
    );
  }
}
