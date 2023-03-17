import 'package:date_time_format/date_time_format.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';

import '../../../../utils/golbal/golbal.dart';
import '../../../component/use/avatar.dart';
import 'chuyendichdanhcontroller.dart';

class ChuyenDichDanhVanBan extends StatelessWidget {
  final ChuyenDichDanhVanbanController controller =
      Get.put(ChuyenDichDanhVanbanController());
  ChuyenDichDanhVanBan({
    Key? key,
  }) : super(key: key);

  Widget chonUser(List users, int loai, Color bgColor, Color textColor) {
    return InkWell(
      onTap: () {
        FocusScope.of(Get.context!).unfocus();
        controller.showUser(loai);
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
                style: TextStyle(color: textColor, fontSize: 11),
              ),
              avatar: UserAvarta(user: users[i]),
              backgroundColor: bgColor,
              onDeleted: () {
                controller.deleUser(i, loai);
              },
              deleteIcon: const Icon(
                Ionicons.close_circle_outline,
                size: 20,
              ),
              deleteIconColor: textColor,
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
    return Container(
        padding: const EdgeInsets.all(10),
        child: Obx(() => ListView.builder(
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
                        )),
                  ),
                ),
              );
            })));
  }

  Widget formWidget() {
    var breakRow = const SizedBox(height: 10);
    return Form(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Chủ trì", style: Golbal.stylelabel),
        breakRow,
        Obx(() => chonUser(
            controller.handlers, 1, const Color(0xFF2196f3), Colors.white)),
        breakRow,
        Text("Phối hợp", style: Golbal.stylelabel),
        breakRow,
        Obx(() => chonUser(
            controller.trackers, 2, const Color(0xFF8BCFFB), Colors.black87)),
        breakRow,
        Text("Xem để biết", style: Golbal.stylelabel),
        breakRow,
        Obx(() => chonUser(
            controller.viewers, 3, const Color(0xFFCCADD7), Colors.white)),
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
        listFile()
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
                title: Text("Chuyển đích danh cá nhân",
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
