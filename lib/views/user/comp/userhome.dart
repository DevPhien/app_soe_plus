import 'package:circular_image/circular_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:image_picker/image_picker.dart';
import 'package:soe/views/user/controller/usercontroller.dart';

class UserHome extends StatelessWidget {
  final UserController controller = Get.put(UserController());

  // ignore: prefer_typing_uninitialized_variables
  final user;

  UserHome({Key? key, this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      children: <Widget>[
        Align(
          alignment: Alignment.center,
          child: Stack(
            children: [
              InkWell(
                child: (user["hasImage"] != null && user["hasImage"])
                    ? CircularImage(
                        radius: 64,
                        source: user["anhThumb"],
                      )
                    : CircleAvatar(
                        backgroundColor: HexColor("#AFDFCF"),
                        radius: 64,
                        child: Text(
                          "${(user['subten'] ?? '')}",
                          style: TextStyle(
                            fontSize: 30,
                            color: HexColor('#ffffff'),
                          ),
                        ),
                      ),
              ),
              Positioned(
                top: 2,
                right: 2,
                child: Container(
                  height: 32,
                  width: 32,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.black26),
                    color: Colors.white,
                  ),
                  child: IconButton(
                    onPressed: () {
                      controller.onImageButtonPressed(ImageSource.gallery);
                    },
                    icon: const Icon(
                      Feather.edit,
                      color: Colors.black,
                      size: 14,
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 8,
                right: 8,
                child: Container(
                  height: 22,
                  width: 22,
                  decoration: BoxDecoration(
                    color: Colors.green,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Theme.of(context).scaffoldBackgroundColor,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 10.0, bottom: 5.0),
          child: Text(
            "${user["fullName"] ?? ''}",
            textAlign: TextAlign.center,
            style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20.0,
                color: Colors.black87),
          ),
        ),
        (user["phone"] != null)
            ? Text(
                "${user["phone"] ?? ''}",
                style: const TextStyle(fontSize: 14.0, color: Colors.black54),
                textAlign: TextAlign.center,
              )
            : Container(width: 0.0),
        const SizedBox(height: 2.0),
        Text(
          "${user["tenChucVu"] ?? ''}",
          style: const TextStyle(fontSize: 14.0, color: Colors.black54),
          textAlign: TextAlign.center,
        ),
        user["tenPhongban"] != null
            ? Text(
                "${user["tenPhongban"] ?? ''}",
                style: const TextStyle(fontSize: 14.0, color: Colors.black54),
                textAlign: TextAlign.center,
              )
            : Container(width: 0.0),
        Padding(
            padding: const EdgeInsets.only(
                left: 15.0, right: 15.0, top: 3.0, bottom: 20.0),
            child: Text(
              "${user["tenCongty"] ?? ''}",
              textAlign: TextAlign.center,
              style: const TextStyle(
                  fontWeight: FontWeight.bold, color: Colors.black54),
            )),
        InkWell(
          onTap: (() {
            controller.goInfo(context, user);
          }),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              children: const <Widget>[
                Icon(
                  Feather.info,
                  color: Colors.blue,
                ),
                SizedBox(width: 10.0),
                Expanded(
                  child: Text(
                    "Thông tin cá nhân",
                    style:
                        TextStyle(fontWeight: FontWeight.w400, fontSize: 16.0),
                  ),
                ),
                Icon(
                  AntDesign.right,
                  color: Colors.black26,
                )
              ],
            ),
          ),
        ),
        const Divider(height: 1.0, thickness: 1),
        InkWell(
          onTap: (() {
            controller.goSWitchUser(context);
          }),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              children: const <Widget>[
                Icon(
                  Feather.user_plus,
                  color: Colors.blue,
                ),
                SizedBox(width: 10.0),
                Expanded(
                  child: Text(
                    "Chọn tài khoản khác",
                    style:
                        TextStyle(fontWeight: FontWeight.w400, fontSize: 16.0),
                  ),
                ),
                Icon(
                  AntDesign.right,
                  color: Colors.black26,
                )
              ],
            ),
          ),
        ),
        const Divider(height: 1.0, thickness: 1),
        InkWell(
          onTap: (() {
            controller.doiMK(context);
          }),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              children: const <Widget>[
                Icon(
                  AntDesign.copyright,
                  color: Colors.amber,
                ),
                SizedBox(width: 10.0),
                Expanded(
                  child: Text(
                    "Đổi mật khẩu",
                    style:
                        TextStyle(fontWeight: FontWeight.w400, fontSize: 16.0),
                  ),
                ),
                Icon(
                  AntDesign.right,
                  color: Colors.black26,
                )
              ],
            ),
          ),
        ),
        const Divider(height: 1.0, thickness: 1),
        InkWell(
          onTap: (() {
            controller.goBirthday(context);
          }),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              children: const <Widget>[
                Icon(
                  FontAwesome.birthday_cake,
                  color: Colors.pink,
                ),
                SizedBox(width: 10.0),
                Expanded(
                  child: Text(
                    "Sự kiện",
                    style:
                        TextStyle(fontWeight: FontWeight.w400, fontSize: 16.0),
                  ),
                ),
                Icon(
                  AntDesign.right,
                  color: Colors.black26,
                )
              ],
            ),
          ),
        ),
        const Divider(height: 1.0, thickness: 1),
        InkWell(
          onTap: (() {
            controller.goInfoSmartOffice(context);
          }),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              children: const <Widget>[
                Icon(
                  AntDesign.copyright,
                  color: Colors.green,
                ),
                SizedBox(width: 10.0),
                Expanded(
                  child: Text(
                    "Thông tin về Smart Office",
                    style:
                        TextStyle(fontWeight: FontWeight.w400, fontSize: 16.0),
                  ),
                ),
                Icon(
                  AntDesign.right,
                  color: Colors.black26,
                )
              ],
            ),
          ),
        ),
        const Divider(height: 1.0, thickness: 1),
        InkWell(
          onTap: (() {
            controller.logout(context);
          }),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              children: const <Widget>[
                Icon(
                  MaterialCommunityIcons.logout,
                  color: Colors.red,
                ),
                SizedBox(width: 10.0),
                Text(
                  "Đăng xuất",
                  style: TextStyle(fontWeight: FontWeight.w400, fontSize: 16.0),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
