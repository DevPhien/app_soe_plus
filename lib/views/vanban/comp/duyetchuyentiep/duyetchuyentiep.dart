import 'package:date_time_format/date_time_format.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';

import '../../../../utils/golbal/golbal.dart';
import '../../../component/use/avatar.dart';
import '../../controller/chitietvanbancontroller.dart';
import 'duyetchuyentiepcontroller.dart';

class DuyetChuyenTiepVanBan extends StatelessWidget {
  final DuyetChuyenTiepVanbanController controller =
      Get.put(DuyetChuyenTiepVanbanController());
  final ChitietVanbanController vbcontroller =
      Get.put(ChitietVanbanController());
  DuyetChuyenTiepVanBan({
    Key? key,
  }) : super(key: key);

  Widget chonUser(List users) {
    return InkWell(
      onTap: () {
        FocusScope.of(Get.context!).unfocus();
        controller.showUser();
      },
      child: Container(
        height: 55,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            border: Border.all(color: const Color(0xFFcccccc), width: 1.0)),
        child: ListView.builder(
          itemBuilder: (ct, i) => Container(
            margin: const EdgeInsets.only(right: 5),
            child: Chip(
              label: Text(
                '${users[i]["fullName"]}',
                style: const TextStyle(color: Colors.white, fontSize: 11),
              ),
              avatar: UserAvarta(user: users[i]),
              backgroundColor: Golbal.appColor,
              onDeleted: () {
                controller.deleUser(i);
              },
              deleteIcon: const Icon(
                Ionicons.close_circle_outline,
                size: 20,
              ),
              deleteIconColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            ),
          ),
          itemCount: users.length,
          scrollDirection: Axis.horizontal,
        ),
      ),
    );
  }

  Widget inputDate(dynamic sdate, String mkey) {
    return InkWell(
      onTap: () {
        FocusScope.of(Get.context!).unfocus();
        controller.openDate(mkey);
      },
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            border: Border.all(color: const Color(0xFFcccccc), width: 1.0)),
        child: Row(
          children: [
            Expanded(
                child: Text(
                    sdate == null
                        ? ""
                        : DateTimeFormat.format(DateTime.parse(sdate),
                            format: 'd/m/Y'),
                    style: Golbal.styleinput)),
            const SizedBox(width: 10),
            const Icon(
              Fontisto.date,
              color: Colors.black54,
            )
          ],
        ),
      ),
    );
  }

  Widget listFile() {
    return Obx(() => ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: controller.files.value.length,
        itemBuilder: (ct, i) {
          PlatformFile file = controller.files.value[i];
          return Card(
            elevation: 0,
            color: const Color(0xFFf5f5f5),
            child: ListTile(
              leading: Image(
                  image: AssetImage(
                      "assets/file/${file.extension!.replaceAll('.', '')}.png"),
                  width: 24,
                  height: 24,
                  fit: BoxFit.contain),
              title: Text(file.name),
              trailing: TextButton(
                  onPressed: () {
                    controller.deleteFile(i);
                  },
                  child: const Icon(
                    Ionicons.trash_outline,
                    color: Colors.black54,
                    size: 16,
                  )),
            ),
          );
        }));
  }

  Widget vanbanGoc() {
    TextStyle titleFile =
        const TextStyle(color: Color(0xFF045997), fontWeight: FontWeight.w500);
    return Obx(() => Wrap(children: [
          if (controller.vanbangockys.isNotEmpty)
            Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: RichText(
                  text: TextSpan(
                    text: 'Văn bản gốc ',
                    style: titleFile,
                    children: const <TextSpan>[
                      TextSpan(
                          text: '(click vào văn bản cần ký)',
                          style: TextStyle(
                              fontSize: 13, fontStyle: FontStyle.italic)),
                    ],
                  ),
                )),
          if (controller.vanbangockys.isNotEmpty)
            Wrap(
              children: controller.vanbangockys
                  .map((tl) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5.0),
                        child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () {
                                controller.openWebview(tl, 0);
                              },
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Image(
                                      image: AssetImage(
                                          "assets/file/${tl["tailieuLoai"].toString().replaceAll('.', '')}.png"),
                                      width: 24,
                                      height: 24,
                                      fit: BoxFit.contain),
                                  Flexible(
                                      child: Text("${tl["tailieuTen"]}",
                                          maxLines: 1,
                                          textAlign: TextAlign.left,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                              color: Colors.black87,
                                              fontWeight: FontWeight.w500))),
                                  if (tl["Sign"] == true)
                                    const Icon(Icons.check, color: Colors.green)
                                ],
                              ),
                            )),
                      ))
                  .toList(),
            )
        ]));
  }

  Widget vanbanDinhkem() {
    TextStyle titleFile =
        const TextStyle(color: Color(0xFF045997), fontWeight: FontWeight.w500);
    return Obx(() => Wrap(children: [
          if (controller.vanbandinhkemkys.isNotEmpty)
            Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: RichText(
                  text: TextSpan(
                    text: 'Chèn chữ ký cho File đính kèm khác:',
                    style: titleFile,
                  ),
                )),
          if (controller.vanbandinhkemkys.isNotEmpty)
            Wrap(
              children: controller.vanbandinhkemkys
                  .map((tl) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5.0),
                        child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () {
                                controller.openWebview(tl, 1);
                              },
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Image(
                                      image: AssetImage(
                                          "assets/file/${tl["tailieuLoai"].toString().replaceAll('.', '')}.png"),
                                      width: 24,
                                      height: 24,
                                      fit: BoxFit.contain),
                                  Flexible(
                                      child: Text("${tl["tailieuTen"]}",
                                          maxLines: 1,
                                          textAlign: TextAlign.left,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                              color: Colors.black87,
                                              fontWeight: FontWeight.w500))),
                                  if (tl["Sign"] == true)
                                    const Icon(Icons.check, color: Colors.green)
                                ],
                              ),
                            )),
                      ))
                  .toList(),
            )
        ]));
  }

  Widget formWidget() {
    var breakRow = const SizedBox(height: 10);
    return Form(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Người nhận", style: Golbal.stylelabel),
        breakRow,
        Obx(() => chonUser(controller.receiver)),
        breakRow,
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Ưu tiên", style: Golbal.stylelabel),
                Obx(() => Switch(
                      value: controller.model["is_flag"] ?? true,
                      onChanged: (value) {
                        controller.model["is_flag"] = value;
                      },
                    )),
              ],
            )),
            Expanded(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Xác nhận ký nháy", style: Golbal.stylelabel),
                Obx(() => Switch(
                      value: controller.model["Kynhay"] ?? true,
                      onChanged: (value) {
                        controller.model["Kynhay"] = value;
                      },
                    )),
              ],
            )),
          ],
        ),
        breakRow,
        Text("Nội dung", style: Golbal.stylelabel),
        breakRow,
        TextFormField(
          minLines: 5,
          maxLines: 10,
          decoration: Golbal.decoration,
          style: Golbal.styleinput,
          onChanged: (String txt) => controller.model["message"] = txt,
        ),
        breakRow,
        Text("Ngày xử lý", style: Golbal.stylelabel),
        breakRow,
        Obx(() => inputDate(controller.model["handle_date"], "handle_date")),
        breakRow,
        Row(
          children: [
            Text("File đính kèm", style: Golbal.stylelabel),
            const SizedBox(width: 10),
            SizedBox(
              height: 36,
              child: OutlinedButton(
                onPressed: () {
                  controller.openFile();
                },
                child: const Icon(
                  Ionicons.attach_outline,
                ),
              ),
            )
          ],
        ),
        breakRow,
        listFile(),
        vanbanGoc(),
        vanbanDinhkem(),
      ],
    ));
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
        data: MediaQuery.of(context)
            .copyWith(textScaleFactor: Golbal.textScaleFactor),
        child: DefaultTabController(
            length: 2,
            child: KeyboardDismisser(
                child: Scaffold(
              backgroundColor: const Color(0xffffffff),
              appBar: AppBar(
                backgroundColor: Golbal.appColorD,
                elevation: 1.0,
                iconTheme: IconThemeData(color: Golbal.iconColor),
                title: Text("Duyệt chuyển tiếp",
                    style: TextStyle(
                        color: Golbal.titleappColor,
                        fontWeight: FontWeight.bold)),
                centerTitle: true,
                systemOverlayStyle: Golbal.systemUiOverlayStyle1,
              ),
              body: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    Expanded(child: SingleChildScrollView(child: formWidget())),
                    const SizedBox(height: 10),
                    Container(
                      width: 150,
                      height: 80,
                      padding: const EdgeInsets.all(20),
                      child: ElevatedButton(
                        onPressed: () {
                          controller.submit();
                        },
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              const Color(0xFF2196f3)),
                        ),
                        child: const Text("Gửi",
                            style: TextStyle(color: Colors.white)),
                      ),
                    )
                  ],
                ),
              ),
            ))));
  }
}
