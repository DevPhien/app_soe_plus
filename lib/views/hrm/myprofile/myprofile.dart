import 'package:cached_network_image/cached_network_image.dart';
import 'package:date_time_format/date_time_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:soe/views/component/use/inlineloadding.dart';

import '../../../utils/golbal/golbal.dart';
import 'myprofilecontroller.dart';

class Myprofile extends StatelessWidget {
  final MyprofileController controller = Get.put(MyprofileController());

  Myprofile({Key? key}) : super(key: key);

  Widget infoWidget() {
    const labelStyle = TextStyle(
      color: Colors.black54,
    );
    const textStyle =
        TextStyle(color: Colors.black87, fontWeight: FontWeight.w500);
    const headStyle =
        TextStyle(color: Colors.black87, fontWeight: FontWeight.bold);
    const cline = SizedBox(height: 10);
    const rline = SizedBox(width: 20);
    var profile = controller.data;
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Spacer(),
              if (Golbal.store.user["Avartar"] != null)
                CachedNetworkImage(
                    imageUrl: Golbal.store.user["Avartar"],
                    imageBuilder: (context, imageProvider) => Container(
                          width: 70,
                          height: 65,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4),
                              image: DecorationImage(
                                image: imageProvider,
                                fit: BoxFit.cover,
                              )),
                        )),
              if (Golbal.store.user["Avartar"] == null)
                Container(
                    width: 70,
                    height: 65,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        color: Golbal.appColor),
                    child: Center(
                      child: Text(Golbal.store.user["fname"] ?? "",
                          style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold)),
                    )),
              const SizedBox(width: 20),
              Column(
                children: [
                  Text(controller.data["fullName"] ?? "",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Golbal.titleColor,
                          fontSize: 20)),
                  const SizedBox(height: 10),
                  Text(controller.data["tenChucVu"] ?? "",
                      style: const TextStyle(
                        color: Colors.black54,
                      ))
                ],
              ),
              const Spacer()
            ],
          ),
          cline,
          cline,
          const Text("1. Thông tin cá nhân", style: headStyle),
          cline,
          Wrap(children: [
            rline,
            const Icon(FontAwesome.calendar, color: Colors.black54, size: 16),
            const SizedBox(width: 10),
            const Text("Ngày sinh: ", style: labelStyle),
            if (profile["Ngaysinh"] != null)
              Text(
                  DateTimeFormat.format(DateTime.parse(profile["Ngaysinh"]),
                      format: 'd/m/Y'),
                  style: textStyle),
          ]),
          cline,
          Wrap(children: [
            rline,
            const Icon(Feather.map_pin, color: Colors.black54, size: 16),
            const SizedBox(width: 10),
            const Text("Nơi sinh: ", style: labelStyle),
            Text(profile["Tai"] ?? "", style: textStyle),
          ]),
          cline,
          Wrap(children: [
            rline,
            const Icon(Feather.phone, color: Colors.black54, size: 16),
            const SizedBox(width: 10),
            const Text("Điện thoại: ", style: labelStyle),
            Text(profile["Didong"] ?? "", style: textStyle),
          ]),
          cline,
          Wrap(children: [
            rline,
            const Icon(Fontisto.email, color: Colors.black54, size: 16),
            const SizedBox(width: 10),
            const Text("Email: ", style: labelStyle),
            Text(profile["Email"] ?? "", style: textStyle),
          ]),
          cline,
          Padding(
            padding: const EdgeInsets.only(left: 20),
            child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Icon(MaterialCommunityIcons.warehouse,
                  color: Colors.black54, size: 16),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Chỗ ở hiện tại: ", style: labelStyle),
                      const SizedBox(height: 5),
                      Text(profile["NoioHientai"] ?? "", style: textStyle),
                    ]),
              )
            ]),
          ),
          cline,
          Padding(
            padding: const EdgeInsets.only(left: 20),
            child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Icon(FontAwesome.address_card_o,
                  color: Colors.black54, size: 16),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Chứng thực cá nhân: ", style: labelStyle),
                      const SizedBox(height: 5),
                      Text(
                          "${(profile["SoChungthuc"] ?? "") + (profile["NgayChungthuc"] != null ? DateTimeFormat.format(DateTime.parse(profile["NgayChungthuc"]), format: ' | d/m/Y') : "") + " | " + (profile["NoicapChungthuc"] ?? "")}",
                          style: textStyle),
                    ]),
              )
            ]),
          ),
          cline,
          Wrap(children: [
            rline,
            const Icon(Fontisto.qrcode, color: Colors.black54, size: 16),
            const SizedBox(width: 10),
            const Text("Mã số thuế cá nhân: ", style: labelStyle),
            Text(profile["Masothue"] ?? "", style: textStyle),
          ]),
          cline,
          Wrap(children: [
            rline,
            const Icon(Feather.user, color: Colors.black54, size: 16),
            const SizedBox(width: 10),
            const Text("Dân tộc: ", style: labelStyle),
            Text(profile["Dantoc"] ?? "", style: textStyle),
          ]),
          cline,
          Wrap(children: [
            rline,
            const Icon(Feather.heart, color: Colors.black54, size: 16),
            const SizedBox(width: 10),
            const Text("Tình trạng: ", style: labelStyle),
            Text(profile["Tinhtranghonnhan"] ?? "", style: textStyle),
          ]),
          cline,
          cline,
          const Text("2. Học vấn", style: headStyle),
          cline,
          Wrap(children: [
            rline,
            const Text("Trình độ: ", style: labelStyle),
            Text(profile["Trinhdochuyenmon"] ?? "", style: textStyle),
          ]),
          cline,
          Wrap(children: [
            rline,
            const Text("Nơi đào tạo: ", style: labelStyle),
            Text(profile["Noidaotao"] ?? "", style: textStyle),
          ]),
          cline,
          Wrap(children: [
            rline,
            const Text("Chuyên ngành: ", style: labelStyle),
            Text(profile["Chuyennganh"] ?? "", style: textStyle),
          ]),
          cline,
          Wrap(children: [
            rline,
            const Text("Năm tốt nghiệp: ", style: labelStyle),
            Text("${profile["Namtotnghiep"] ?? ""}", style: textStyle),
          ]),
          cline,
          cline,
          const Text("3. Đang làm việc tại", style: headStyle),
          cline,
          Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            rline,
            const Text("Đơn vị: ", style: labelStyle),
            Expanded(
                child: Text("${profile["tenCongty"] ?? ""}", style: textStyle)),
          ]),
          cline,
          Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            rline,
            const Text("Phòng ban: ", style: labelStyle),
            Expanded(
                child: Text("${profile["tenToChuc"] ?? ""}", style: textStyle)),
          ]),
          cline,
          Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            rline,
            const Text("Chức vụ: ", style: labelStyle),
            Expanded(
                child: Text("${profile["tenChucVu"] ?? ""}", style: textStyle)),
          ]),
          cline,
          Wrap(children: [
            rline,
            const Text("Ngày vào công ty: ", style: labelStyle),
            if (profile["NgayvaoCongty"] != null)
              Text(
                  DateTimeFormat.format(
                      DateTime.parse(profile["NgayvaoCongty"]),
                      format: 'd/m/Y'),
                  style: textStyle),
          ]),
          cline,
          Wrap(children: [
            rline,
            const Text("Cấp nhân sự: ", style: labelStyle),
            Text("${profile["CapNhansu"] ?? ""}", style: textStyle),
          ]),
          cline,
          Wrap(children: [
            rline,
            const Text("Mã nhân sự: ", style: labelStyle),
            Text("${profile["MaNhansu"] ?? ""}", style: textStyle),
          ]),
          cline,
          Wrap(children: [
            rline,
            const Text("Mã chấm công: ", style: labelStyle),
            Text("${profile["MaChamcong"] ?? ""}", style: textStyle),
          ]),
        ],
      ),
    );
  }

  //Function
  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context)
          .copyWith(textScaleFactor: Golbal.textScaleFactor),
      child: Scaffold(
          backgroundColor: const Color(0xffffffff),
          appBar: AppBar(
            backgroundColor: Golbal.appColorD,
            elevation: 0.0,
            iconTheme: IconThemeData(color: Golbal.iconColor),
            title: Text("Hồ sơ của tôi",
                style: TextStyle(
                    color: Golbal.titleappColor, fontWeight: FontWeight.bold)),
            centerTitle: false,
            systemOverlayStyle: Golbal.systemUiOverlayStyle1,
          ),
          body: Obx(() => controller.isLoadding.value
              ? const InlineLoadding()
              : Padding(
                  padding: const EdgeInsets.all(20),
                  child: infoWidget(),
                ))),
    );
  }
}
