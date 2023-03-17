import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';

import '../../../../utils/golbal/golbal.dart';
import 'tralaicontroller.dart';

class TralaiVanBan extends StatelessWidget {
  final TralaiVanbanController controller =
      Get.put(TralaiVanbanController());
  TralaiVanBan({
    Key? key,
  }) : super(key: key);

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
            })));
  }

  Widget formWidget() {
    var breakRow = const SizedBox(height: 10);
    return Form(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
        child: KeyboardDismisser(
                child: Scaffold(
              backgroundColor: const Color(0xffffffff),
              appBar: AppBar(
                backgroundColor: Golbal.appColorD,
                elevation: 1.0,
                iconTheme: IconThemeData(color: Golbal.iconColor),
                title: Text("Chuyển trả lại",
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
                        child: const Text("Gửi",
                            style: TextStyle(color: Colors.white)),
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              const Color(0xFF2196f3)),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            )));
  }
}
