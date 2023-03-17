import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';
import 'package:lottie/lottie.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';
import 'package:soe/utils/golbal/golbal.dart';
import 'package:soe/views/component/dialog.dart';
import 'package:soe/views/component/use/avatar.dart';
import 'package:soe/views/component/use/inlineloadding.dart';
import 'package:soe/views/task/comp/hometask/detail/report/inputreport.dart';
import 'package:soe/views/task/comp/hometask/detail/report/inputreportcontroller.dart';
import 'package:soe/views/task/comp/hometask/detail/report/reportcontroller.dart';

class ReportTask extends StatelessWidget {
  final ReportTaskController controller = Get.put(ReportTaskController());
  final InputReportController ipcontroller = Get.put(InputReportController());
  ReportTask({Key? key}) : super(key: key);

  Widget bindRow(context, item) {
    List reviews = [];
    if (item["reviews"] != null) {
      try {
        reviews = List.castFrom(item["reviews"]);
      } catch (e) {}
    }
    bool isdelete = item["Trangthai"] == 0 &&
        item["NguoiTao"] == Golbal.store.user["user_id"];
    return Container(
      padding: const EdgeInsets.all(15.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            width: 48,
            height: 48,
            child: UserAvarta(user: item),
          ),
          const SizedBox(width: 15.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            item["fullName"] ?? "",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 15.0),
                          ),
                          Text(item["tenToChuc"] ?? "",
                              style: const TextStyle(
                                  fontWeight: FontWeight.normal,
                                  fontSize: 12.0,
                                  color: Colors.black54)),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10.0),
                    Column(
                      children: <Widget>[
                        Text(
                          item["NgayBaocao"] != null
                              ? Golbal.timeAgo(item["NgayBaocao"].toString())
                              : "",
                          style: const TextStyle(
                              fontSize: 12.0, color: Colors.black54),
                        ),
                        const SizedBox(height: 5.0),
                        if (controller.task["YeucauReview"] == true) ...[
                          renderTypeBaocao(item),
                        ],
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 5.0),
                Text(item["Noidung"] ?? "",
                    style: const TextStyle(
                        fontWeight: FontWeight.normal,
                        fontSize: 14.0,
                        color: Colors.black87)),
                const SizedBox(height: 10.0),
                Stack(
                  children: [
                    LinearPercentIndicator(
                      padding: EdgeInsets.zero,
                      backgroundColor:
                          item["Tiendo"] == null || item["Tiendo"] == 0
                              ? Colors.red
                              : const Color(0xfff5f5f5),
                      animation: true,
                      animationDuration: 1000,
                      lineHeight: 18.0,
                      percent: item["Tiendo"] / 100,
                      center: Text(
                        " ${item["Tiendo"].ceil()} %",
                        style: TextStyle(
                          color: item["Tiendo"] != null && item["Tiendo"] >= 60
                              ? Colors.white
                              : Colors.black54,
                          fontSize: 10.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      barRadius: const Radius.circular(10),
                      progressColor: Golbal.renderColor(item["Tiendo"]),
                    ),
                    if (item["Tiendo"] == null || item["Tiendo"] == 0) ...[
                      SizedBox(
                        height: 18.0,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              " ${item["Tiendo"].ceil()} %",
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      )
                    ]
                  ],
                ),
                renderFile(item, true),
                if (isdelete) ...[
                  Align(
                    alignment: Alignment.centerRight,
                    child: IconButton(
                      icon: const Icon(EvilIcons.trash),
                      onPressed: () {
                        controller.deleteReport(context, item);
                      },
                    ),
                  ),
                ],
                if (item["Trangthai"] != 0 ||
                    controller.task["isgiaoviec"] != true ||
                    controller.task["YeucauReview"] != true) ...[
                  ListView.builder(
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: reviews.length,
                      itemBuilder: (ct, j) => bindReview(reviews[j]))
                ] else ...[
                  Row(
                    children: <Widget>[
                      TextButton(
                        onPressed: () {
                          funreview(context, item, false);
                        },
                        child: const Text(
                          "Yêu cầu làm lại",
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: 13.0,
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          funreview(context, item, true);
                        },
                        child: Text(
                          "Đồng ý",
                          style: TextStyle(
                            color: Golbal.appColor,
                            fontSize: 13.0,
                          ),
                        ),
                      )
                    ],
                  )
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget renderTypeBaocao(d) {
    int tt = d["Trangthai"];
    switch (tt) {
      case 1:
        return Container(
          decoration: BoxDecoration(
              color: const Color(0xFF51b7ae),
              borderRadius: BorderRadius.circular(30.0)),
          padding: const EdgeInsets.symmetric(vertical: 3.0, horizontal: 5.0),
          child: const Text(
            "Đã review",
            style: TextStyle(color: Colors.white, fontSize: 10.0),
          ),
        );
      case 2:
        return Container(
          decoration: BoxDecoration(
              color: Colors.red, borderRadius: BorderRadius.circular(30.0)),
          padding: const EdgeInsets.symmetric(vertical: 3.0, horizontal: 5.0),
          child: const Text(
            "Y/c báo cáo lại",
            style: TextStyle(color: Colors.white, fontSize: 10.0),
          ),
        );
      case 0:
        return Container(
          decoration: BoxDecoration(
              color: const Color(0xFF33c9dc),
              borderRadius: BorderRadius.circular(30.0)),
          padding: const EdgeInsets.symmetric(vertical: 3.0, horizontal: 5.0),
          child: const Text(
            "Đợi Review",
            style: TextStyle(color: Colors.white, fontSize: 10.0),
          ),
        );
    }
    return Container(
      width: 0.0,
    );
  }

  Widget renderFile(r, bool f) {
    if (r["files"] == null || r["files"].length == 0) {
      return Container(width: 0.0);
    }
    return Container(
      constraints: BoxConstraints(
        maxHeight: r["files"].length * 60.0,
      ),
      child: ListView.builder(
        scrollDirection: Axis.vertical,
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: r["files"].length,
        itemBuilder: (c, i) => Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5.0),
              border: Border.all(color: const Color(0xFFeeeeee)),
              color: f ? const Color(0xFFf9f9f9) : const Color(0xFFffffff)),
          margin: const EdgeInsets.symmetric(vertical: 5.0),
          padding: const EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 5.0),
          child: InkWell(
            onTap: () {
              Golbal.loadFile(r["files"][i]["Duongdan"]);
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                InkWell(
                    onTap: () {
                      Golbal.loadFile(r["files"][i]["Duongdan"]);
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 5.0, horizontal: 5.0),
                      child: Image(
                          image: AssetImage(
                              "assets/file/${r["files"][i]["Dinhdang"].toString().replaceAll('.', '')}.png"),
                          width: 24,
                          height: 24,
                          fit: BoxFit.contain),
                    )),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 5.0),
                    child: Text(
                      "${r["files"][i]["Tenfile"]} (${Golbal.formatBytes(r["files"][i]["Dungluong"])})",
                      maxLines: 2,
                      textAlign: TextAlign.justify,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 12.0,
                        color: Colors.black87,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget bindReview(r) {
    if (r["Tiendo"] != null) {
      r["Tiendo"] = double.parse(r["Tiendo"].toString());
    }

    return Container(
        margin: const EdgeInsets.symmetric(vertical: 5.0),
        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 5.0),
        decoration: BoxDecoration(
            color: const Color(0xFFf5f5f5),
            borderRadius: BorderRadius.circular(20.0)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              width: 32,
              height: 32,
              child: UserAvarta(user: r),
            ),
            const SizedBox(width: 10.0),
            Expanded(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  r["fullName"] ?? "",
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 14.0),
                ),
                Text(r["tenToChuc"] ?? "",
                    style: const TextStyle(
                        fontWeight: FontWeight.normal,
                        fontSize: 12.0,
                        color: Colors.black54)),
                const SizedBox(height: 5.0),
                Text(
                  r["NgayReview"] != null
                      ? Golbal.timeAgo(r["NgayReview"].toString())
                      : "",
                  style: const TextStyle(fontSize: 11.0, color: Colors.black54),
                ),
                const SizedBox(height: 5.0),
                Text(r["Noidung"] ?? "",
                    style: const TextStyle(
                        fontWeight: FontWeight.normal,
                        fontSize: 13.0,
                        color: Colors.black87)),
                r["Tiendo"] == null || r["Tiendo"] == 0
                    ? Container(width: 0.0)
                    : const SizedBox(height: 10.0),
                if (r["Tiendo"] == null || r["Tiendo"] == 0) ...[
                  const SizedBox.shrink(),
                ] else ...[
                  Stack(
                    children: [
                      LinearPercentIndicator(
                        backgroundColor: r["Tiendo"] == null || r["Tiendo"] == 0
                            ? Colors.red
                            : const Color(0xfff5f5f5),
                        animation: true,
                        animationDuration: 1000,
                        lineHeight: 18.0,
                        percent: r["Tiendo"] / 100,
                        center: Text(
                          " ${r["Tiendo"]} %",
                          style: TextStyle(
                            color: r["Tiendo"] != null && r["Tiendo"] >= 60
                                ? Colors.white
                                : Colors.black,
                            fontSize: 10.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        barRadius: const Radius.circular(10),
                        progressColor: Golbal.renderColor(r["Tiendo"]),
                      ),
                      if (r["Tiendo"] == null || r["Tiendo"] == 0) ...[
                        SizedBox(
                          height: 18.0,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                " ${r["Tiendo"].ceil()} %",
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        )
                      ]
                    ],
                  ),
                ],
                r["Danhgia"] == null || r["Danhgia"] == 0
                    ? Container(width: 0.0)
                    : const SizedBox(height: 5.0),
                if (r["Danhgia"] != null) ...[
                  RatingBar.builder(
                    initialRating: double.parse(r["Danhgia"]),
                    minRating: 1,
                    direction: Axis.horizontal,
                    allowHalfRating: true,
                    itemCount: 5,
                    itemSize: 30,
                    itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                    itemBuilder: (context, _) => const Icon(
                      Icons.star,
                      color: Colors.amber,
                    ),
                    onRatingUpdate: (v) {},
                    ignoreGestures: true,
                  )
                ],
                if (r["files"] != null) ...[
                  renderFile(r, false),
                ],
              ],
            )),
          ],
        ));
  }

  Future<void> funreview(context, bc, bool f) async {
    controller.isReview.value = true;
    var rv = {
      "BaocaoID": bc["BaocaoID"],
      "DuanID": controller.task["DuanID"],
      "CongviecID": controller.task["CongviecID"],
      "Noidung": controller.textController.text,
      "IsType": f ? 1 : 2,
      "Tiendo": bc["Tiendo"],
      "NguoiReview": Golbal.store.user["user_id"],
      "NgayReview": DateTime.now().toIso8601String(),
      "Danhgia": 0.0,
    };
    controller.isReview.value = false;
    var rs = await Animateddialogbox.showScaleAlertBox(
      context: context,
      firstButton: MaterialButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(40),
        ),
        color: Colors.white,
        child: const Text('Huỷ'),
        padding: const EdgeInsets.symmetric(horizontal: 50.0),
        onPressed: () {
          Navigator.of(context).pop(false);
        },
      ),
      secondButton: MaterialButton(
        // OPTIONAL BUTTON
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(40),
        ),
        color: Golbal.appColor,
        padding: const EdgeInsets.symmetric(horizontal: 30.0),
        child: const Text(
          'Gửi review',
          style: TextStyle(color: Colors.white),
        ),
        onPressed: () {
          Navigator.of(context).pop(true);
        },
      ),
      icon: Container(width: 0.0), // IF YOU WANT TO ADD ICON
      yourWidget: StatefulBuilder(
        builder: (context, setState) {
          return Container(
            width: double.maxFinite,
            constraints:
                BoxConstraints(maxHeight: Golbal.screenSize.height * 0.8),
            child: SingleChildScrollView(
              child: Obx(
                () => Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        const Spacer(),
                        Text(
                          f ? "Đánh giá công việc" : "Yêu cầu báo cáo lại",
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const Spacer(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            IconButton(
                                icon: const Icon(Feather.image,
                                    color: Colors.black38),
                                onPressed: () {
                                  controller.openFileImage();
                                }),
                            IconButton(
                                icon: const Icon(Icons.attach_file,
                                    color: Colors.black38),
                                onPressed: () {
                                  controller.openFile();
                                })
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 15.0),
                    ConstrainedBox(
                      constraints: const BoxConstraints(
                        maxHeight: 250.0,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            reverse: true,
                            child: TextField(
                              controller: controller.textController,
                              keyboardAppearance: Brightness.light,
                              textInputAction: TextInputAction.newline,
                              maxLines: null,
                              minLines: 5,
                              onChanged: (String txt) {
                                rv["Noidung"] = txt;
                              },
                              decoration: const InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Color(0xFFdddddd)),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Color(0xFFdddddd)),
                                ),
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 10.0, horizontal: 15.0),
                                filled: true,
                                fillColor: Colors.white,
                                hintText: 'Nội dung Review',
                                hintStyle: TextStyle(fontSize: 13.0),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 5.0),
                    Row(
                      children: [
                        const Text("Tiến độ (%)"),
                        const SizedBox(width: 10.0),
                        Expanded(
                          child: TextFormField(
                            initialValue: "${rv["Tiendo"] ?? ""}",
                            keyboardAppearance: Brightness.light,
                            keyboardType: TextInputType.number,
                            onChanged: (String txt) {
                              rv["Tiendo"] = txt;
                            },
                            decoration: const InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Color(0xFFdddddd)),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Color(0xFFdddddd)),
                              ),
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 10.0, horizontal: 15.0),
                              filled: true,
                              fillColor: Colors.white,
                              hintText: 'Tiến độ',
                              hintStyle: TextStyle(fontSize: 13.0),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20.0),
                    Obx(
                      () => RatingBar.builder(
                        initialRating: controller.danhgia.value,
                        minRating: 1,
                        direction: Axis.horizontal,
                        allowHalfRating: true,
                        itemCount: 5,
                        //itemSize: 35,
                        itemPadding:
                            const EdgeInsets.symmetric(horizontal: 4.0),
                        itemBuilder: (context, _) => const Icon(
                          Icons.star,
                          color: Colors.amber,
                        ),
                        onRatingUpdate: (v) {
                          rv["Danhgia"] = v;
                        },
                      ),
                    ),
                    const SizedBox(height: 5.0),
                    if (controller.images.value.isNotEmpty) ...[
                      listImage(),
                    ],
                    if (controller.files.value.isNotEmpty) ...[
                      listFile(),
                    ],
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
    if (rs == true) {
      controller.sendding.value = false;
      controller.sendReview(bc, rv);
    } else {
      controller.images.value = [];
      controller.files.value = [];
    }
  }

  Widget listFile() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 0.0),
      constraints: BoxConstraints(
        maxHeight: controller.files.value.length * 60,
      ),
      child: Obx(
        () => ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: controller.files.value.length,
          itemBuilder: (ct, i) {
            PlatformFile file = controller.files.value[i];
            return Card(
              margin: const EdgeInsets.only(bottom: 5.0),
              elevation: 0,
              color: const Color(0xFFf5f5f5),
              child: ListTile(
                leading: Image(
                  image: AssetImage(
                      "assets/file/${file.extension!.replaceAll('.', '')}.png"),
                  width: 24,
                  height: 24,
                  fit: BoxFit.contain,
                ),
                title: Text(file.name),
                trailing: SizedBox(
                  width: 30,
                  child: TextButton(
                    onPressed: () {
                      controller.deleteFile(i);
                    },
                    child: const Icon(
                      Ionicons.trash_outline,
                      color: Colors.black54,
                      size: 16,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget listImage() {
    return Container(
      color: const Color(0xFFcccccc),
      constraints: const BoxConstraints(maxHeight: 300),
      child: ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: controller.images.value.length,
        itemBuilder: (ct, i) {
          XFile file = controller.images.value[i];
          return Card(
            elevation: 0,
            color: const Color(0xFFf5f5f5),
            child: ListTile(
              leading: Image(
                  image: AssetImage(
                      "assets/file/${file.name.split('.').last}.png"),
                  width: 24,
                  height: 24,
                  fit: BoxFit.contain),
              title: Text(file.name),
              trailing: SizedBox(
                width: 30,
                child: TextButton(
                    onPressed: () {
                      controller.deleteImage(i);
                    },
                    child: const Icon(
                      Ionicons.trash_outline,
                      color: Colors.black54,
                      size: 16,
                    )),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget progressWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        SleekCircularSlider(
            min: 0,
            max: 100,
            initialValue: ipcontroller.report["TiendoDexuat"] ??
                ipcontroller.tiendoDexuat.value,
            appearance: CircularSliderAppearance(
                size: Golbal.screenSize.width - 150,
                customWidths: CustomSliderWidths(
                    trackWidth: 40 * Golbal.textScaleFactor,
                    progressBarWidth: 40 * Golbal.textScaleFactor),
                customColors: CustomSliderColors(
                    trackColor: const Color(0xFFaaaaaa),
                    progressBarColor: const Color(0xFF59d05d))),
            onChange: (double value) {
              ipcontroller.tiendoDexuat.value = value;
              ipcontroller.report["TiendoDexuat"] =
                  ipcontroller.tiendoDexuat.value;
            }),
        const Text("Tiến độ hiện tại của công việc",
            style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 10.0),
        Container(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            children: <Widget>[
              Expanded(
                  child: SizedBox(
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                      const Color(0xffeeeeee),
                    ),
                  ),
                  onPressed: () {
                    ipcontroller.showProgress.value = false;
                  },
                  child: const Text(
                    "Huỷ",
                    style: TextStyle(color: Colors.black87, fontSize: 16.0),
                  ),
                ),
                height: 50.0,
              )),
              const SizedBox(width: 20.0),
              Expanded(
                  child: SizedBox(
                height: 50.0,
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                      const Color(0xff0186f8),
                    ),
                  ),
                  onPressed: () {
                    ipcontroller.showProgress.value = false;
                    ipcontroller.report["TiendoDexuat"] =
                        ipcontroller.tiendoDexuat.value;
                  },
                  child: const Text(
                    "Cập nhật",
                    style: TextStyle(color: Colors.white, fontSize: 16.0),
                  ),
                ),
              )),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context)
          .copyWith(textScaleFactor: Golbal.textScaleFactor),
      child: KeyboardDismisser(
        gestures: const [
          GestureType.onTap,
          GestureType.onPanUpdateDownDirection,
        ],
        child: Scaffold(
          backgroundColor: const Color(0xFFffffff),
          appBar: AppBar(
            automaticallyImplyLeading: true,
            backgroundColor: Golbal.appColorD,
            elevation: 1.0,
            iconTheme: IconThemeData(color: Golbal.iconColor),
            centerTitle: false,
            title: Row(
              children: <Widget>[
                Text(
                  "Báo cáo công việc",
                  style: TextStyle(
                    color: Golbal.appColor,
                  ),
                ),
              ],
            ),
            systemOverlayStyle: Golbal.systemUiOverlayStyle1,
            titleSpacing: 0,
          ),
          body: GestureDetector(
            onTap: controller.clickBody,
            child: Obx(
              () => controller.loading.value
                  ? const InlineLoadding()
                  : Column(
                      children: [
                        if (ipcontroller.showProgress.value == true) ...[
                          Expanded(child: progressWidget()),
                        ] else ...[
                          Expanded(
                            child: (controller.loading.value != true &&
                                    controller.datas.isEmpty)
                                ? Center(
                                    child: SingleChildScrollView(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          Center(
                                            child: Lottie.network(
                                                "https://assets10.lottiefiles.com/packages/lf20_fp7svyno.json"),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                : SingleChildScrollView(
                                    controller: controller.scrollController,
                                    child: Column(
                                      children: [
                                        ListView.builder(
                                          //controller: controller.scrollController,
                                          shrinkWrap: true,
                                          padding: EdgeInsets.zero,
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          itemBuilder: (context, index) {
                                            return Obx(() => bindRow(context,
                                                controller.datas[index]));
                                          },
                                          itemCount: controller.datas.length,
                                        ),
                                      ],
                                    ),
                                  ),
                          ),
                        ],
                        InputReport(),
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
