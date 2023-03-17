import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../../utils/golbal/golbal.dart';
import 'diadiemcontroller.dart';

class DiadiemlamPage extends StatelessWidget {
  final DiadiemlamController controller = Get.put(DiadiemlamController());
  final noSimbolInUSFormat = NumberFormat.currency(locale: "vi_VN", symbol: "");
  DiadiemlamPage({Key? key}) : super(key: key);

  void showModalAddCalamviec({model}) {
    var modelgx = {
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
                title: Text("Cập nhật địa điểm làm việc",
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
                        controller.addDiadiemlamviec(modelgx);
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
    var breakRow = const SizedBox(height: 10);
    return Form(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Tên địa điểm làm việc", style: Golbal.stylelabel),
        breakRow,
        TextFormField(
          decoration: Golbal.decoration,
          initialValue: model["tendiadiem"],
          style: Golbal.styleinput,
          onChanged: (String txt) => model["tendiadiem"] = txt,
        ),
        breakRow,
        Text("Địa chỉ", style: Golbal.stylelabel),
        breakRow,
        TextFormField(
          decoration: Golbal.decoration,
          maxLines: 3,
          initialValue: model["diachi"],
          style: Golbal.styleinput,
          onChanged: (String txt) => model["diachi"] = txt,
        ),
        breakRow,
        Text("Toạ độ", style: Golbal.stylelabel),
        breakRow,
        TextFormField(
          decoration: Golbal.decoration,
          initialValue: model["CheckinLatLong"],
          style: Golbal.styleinput,
          onChanged: (String txt) => model["CheckinLatLong"] = txt,
        ),
        breakRow,
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.map_outlined),
                const SizedBox(width: 5),
                Text("Bán kính cho phép (mét)", style: Golbal.stylelabel),
              ],
            ),
            breakRow,
            TextFormField(
              decoration: Golbal.decoration,
              inputFormatters: [
                CurrencyTextInputFormatter(locale: "vi", symbol: "")
              ],
              initialValue: model["bankinh"] == null
                  ? ""
                  : noSimbolInUSFormat.format(model["bankinh"]),
              keyboardType: TextInputType.number,
              style: Golbal.styleinput,
              onChanged: (String txt) =>
                  model["bankinh"] = txt.replaceAll(".", ""),
            )
          ],
        ),
        breakRow,
        Row(
          children: [
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
            ),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const Icon(Icons.qr_code_2_outlined),
                  const SizedBox(width: 5),
                  Text("Quét Qrcode", style: Golbal.stylelabel),
                  Obx(() => Switch(
                        value: model["qrcode"] ?? false,
                        onChanged: (value) {
                          model["qrcode"] = value;
                        },
                      )),
                ],
              ),
            )
          ],
        ),
        breakRow,
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
                          title: const Text("Chỉnh sửa địa điểm làm việc"),
                        ),
                        ListTile(
                          onTap: () {
                            Get.back();
                            controller.delDiadiemlamviec(item);
                          },
                          leading: const Icon(FontAwesome.trash_o),
                          title: const Text("Xoá địa điểm làm việc"),
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
              title: Text("Địa điểm làm việc",
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
            body: ListView.separated(
                padding: const EdgeInsets.symmetric(vertical: 10),
                itemCount: controller.datas.length,
                separatorBuilder: (ct, i) => const Divider(),
                itemBuilder: (ct, i) {
                  var item = controller.datas[i];
                  return ListTile(
                      onTap: () {
                        choiceItem(item);
                      },
                      leading: item["qrcode"] == true
                          ? const Icon(Icons.qr_code_2_outlined,
                              color: Colors.blue)
                          : const Icon(
                              Feather.map_pin,
                              color: Colors.red,
                            ),
                      title: Text(item["tendiadiem"],
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text(
                        "${item["diachi"]}",
                      ),
                      trailing: Column(
                        children: [
                          if (item["CheckinLatLong"] != "")
                            const Icon(
                              Icons.map_outlined,
                              color: Colors.orange,
                            ),
                          if (item["CheckinLatLong"] != "")
                            const SizedBox(height: 5),
                          if (item["bankinh"] != null)
                            Text(
                                "${noSimbolInUSFormat.format(item["bankinh"])}m",
                                style: const TextStyle(
                                    color: Colors.black38,
                                    fontStyle: FontStyle.italic)),
                        ],
                      ));
                }),
          )),
    );
  }
}
