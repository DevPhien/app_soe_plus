import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';

import '../../../../utils/golbal/golbal.dart';
import 'calamcontroller.dart';

extension TimeOfDayConverter on TimeOfDay {
  String to24hours() {
    final hour = this.hour.toString().padLeft(2, "0");
    final min = minute.toString().padLeft(2, "0");
    return "$hour:$min";
  }
}

class CalamPage extends StatelessWidget {
  final CalamController controller = Get.put(CalamController());

  CalamPage({Key? key}) : super(key: key);

  void showModalAddCalamviec({model}) {
    var modelgx = {
      "maunen": "#ffffff",
      "mauchu": "#000000",
      "trangthai": true,
      "Congty_ID": Golbal.store.user["organization_id"],
    }.obs;
    if (model != null) {
      modelgx.value = model;
    }
    Get.to(
        () => Scaffold(
              appBar: AppBar(
                backgroundColor: Golbal.appColorD,
                elevation: 1.0,
                iconTheme: IconThemeData(color: Golbal.iconColor),
                title: Text("Cập nhật ca làm việc",
                    style: TextStyle(
                        color: Golbal.titleappColor,
                        fontWeight: FontWeight.bold)),
                centerTitle: true,
                systemOverlayStyle: Golbal.systemUiOverlayStyle1,
              ),
              body: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: formWidget(modelgx),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    width: 150,
                    height: 80,
                    padding: const EdgeInsets.all(20),
                    child: ElevatedButton(
                      onPressed: () {
                        controller.addCalamviec(modelgx);
                      },
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            const Color(0xFF2196f3)),
                      ),
                      child: const Text("Cập nhật",
                          style: TextStyle(color: Colors.white)),
                    ),
                  )
                ],
              ),
            ),
        fullscreenDialog: true);
  }

  Widget formWidget(model) {
    var arrColors = [
      "#aaaaaa",
      "#2a91d6",
      "#33c9dc",
      "#51b7ae",
      "#6fbf73",
      "#7a87d0",
      "#ffcd38",
      "#ff8b4e",
      "#d87777",
      "#f17ac7"
    ];
    var breakRow = const SizedBox(height: 10);
    final TextEditingController txtbatdau = TextEditingController(
        text: model["batdau"] == null
            ? ""
            : model["batdau"].toString().substring(0, 5));
    final TextEditingController txtketthuc = TextEditingController(
        text: model["ketthuc"] == null
            ? ""
            : model["ketthuc"].toString().substring(0, 5));
    return Form(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Tên ca làm việc", style: Golbal.stylelabel),
        breakRow,
        TextFormField(
          decoration: Golbal.decoration,
          initialValue: model["tenca"],
          style: Golbal.styleinput,
          onChanged: (String txt) => model["tenca"] = txt,
        ),
        breakRow,
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Bắt đầu", style: Golbal.stylelabel),
                TextField(
                  controller: txtbatdau,
                  decoration: const InputDecoration(
                    icon: Icon(Icons.timer), //icon of text field
                  ),
                  readOnly:
                      true, //set it true, so that user will not able to edit text
                  onTap: () async {
                    TimeOfDay? pickedTime = await showTimePicker(
                      initialTime: TimeOfDay.now(),
                      context: Get.context!,
                    );

                    if (pickedTime != null) {
                      txtbatdau.text = (pickedTime.to24hours());
                      model["batdau"] = txtbatdau.text;
                    }
                  },
                )
              ],
            )),
            Expanded(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Kết thúc", style: Golbal.stylelabel),
                TextField(
                  controller: txtketthuc,
                  decoration: const InputDecoration(
                    icon: Icon(Icons.timer), //icon of text field
                  ),
                  readOnly:
                      true, //set it true, so that user will not able to edit text
                  onTap: () async {
                    TimeOfDay? pickedTime = await showTimePicker(
                      initialTime: TimeOfDay.now(),
                      context: Get.context!,
                    );

                    if (pickedTime != null) {
                      txtketthuc.text = (pickedTime.to24hours());
                      model["ketthuc"] = txtketthuc.text;
                    }
                  },
                )
              ],
            )),
          ],
        ),
        breakRow,
        breakRow,
        Text("Chọn màu nền", style: Golbal.stylelabel),
        breakRow,
        Obx(() => Wrap(
            children: arrColors
                .map((e) => Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: InkWell(
                        onTap: () {
                          model["maunen"] = e;
                          model["mauchu"] = "#ffffff";
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: CircleAvatar(
                            backgroundColor: HexColor(e),
                            child: model["maunen"] == e
                                ? const Icon(Ionicons.checkmark_done,
                                    color: Colors.white)
                                : const SizedBox.shrink(),
                          ),
                        ),
                      ),
                    ))
                .toList())),
        breakRow,
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text("Kích hoạt", style: Golbal.stylelabel),
            const SizedBox(width: 5),
            Obx(() => Switch(
                  value: model["trangthai"] ?? true,
                  onChanged: (value) {
                    model["trangthai"] = value;
                  },
                )),
          ],
        )
      ],
    ));
  }

  void choiceItem(item) {
    Get.bottomSheet((BottomSheet(
        onClosing: () {},
        builder: (_) => Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Row(
                    children: const [
                      Icon(Icons.date_range_outlined),
                      SizedBox(width: 5),
                      Text(
                        "Chọn chức năng",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                      child: SingleChildScrollView(
                    child: Column(
                      children: [
                        ListTile(
                          onTap: () {
                            Get.back();
                            showModalAddCalamviec(model: item);
                          },
                          leading: const Icon(Icons.edit),
                          title: const Text("Chỉnh sửa ca làm việc"),
                        ),
                        ListTile(
                          onTap: () {
                            Get.back();
                            controller.delCalamviec(item);
                          },
                          leading: const Icon(FontAwesome.trash_o),
                          title: const Text("Xoá ca làm việc"),
                        ),
                      ],
                    ),
                  ))
                ],
              ),
            ))));
  }

  //Function
  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context)
          .copyWith(textScaleFactor: Golbal.textScaleFactor),
      child: Obx(() => Scaffold(
            backgroundColor: const Color(0xffffffff),
            appBar: AppBar(
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
              backgroundColor: Colors.white,
              iconTheme: IconThemeData(color: Golbal.appColor),
              titleSpacing: 0.0,
              centerTitle: true,
              title: Text("Ca làm việc",
                  style: TextStyle(
                      color: Golbal.titleappColor,
                      fontWeight: FontWeight.bold)),
              systemOverlayStyle: SystemUiOverlayStyle.light,
              actions: [
                IconButton(
                    onPressed: () {
                      showModalAddCalamviec();
                    },
                    icon: const Icon(Icons.add))
              ],
            ),
            body: ListView.builder(
                padding: const EdgeInsets.all(10),
                itemCount: controller.datas.length,
                itemBuilder: (ct, i) {
                  var item = controller.datas[i];
                  return Card(
                    color: item["trangthai"] != true
                        ? Colors.black38
                        : HexColor(item["maunen"]),
                    child: ListTile(
                      onTap: () {
                        choiceItem(item);
                      },
                      title: Text(item["tenca"],
                          style: TextStyle(color: HexColor(item["mauchu"]))),
                      subtitle: Text(
                          "${item["batdau"].toString().substring(0, 5)} - ${item["ketthuc"].toString().substring(0, 5)}",
                          style: TextStyle(color: HexColor(item["mauchu"]))),
                    ),
                  );
                }),
          )),
    );
  }
}
