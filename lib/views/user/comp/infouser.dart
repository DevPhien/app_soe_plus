// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:circular_image/circular_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:hexcolor/hexcolor.dart';

import '../../../utils/golbal/golbal.dart';

class InfoUser extends StatelessWidget {
  final user;

  const InfoUser({Key? key, this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
        data: MediaQuery.of(context)
            .copyWith(textScaleFactor: Golbal.textScaleFactor),
        child: Scaffold(
          backgroundColor: const Color(0xFFffffff),
          appBar: AppBar(
            title: const Text(
              "Thông tin cá nhân",
              style: TextStyle(
                  color: Color(0xFF0186f8), fontWeight: FontWeight.bold),
            ),
            iconTheme: const IconThemeData(color: Colors.black45),
            backgroundColor: Colors.white,
            elevation: 0.0,
          ),
          body: ListView(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
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
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  children: <Widget>[
                    const Icon(
                      MaterialCommunityIcons.account_key_outline,
                      color: Colors.blue,
                    ),
                    const SizedBox(width: 10.0),
                    const Expanded(
                      child: Text(
                        "Mã đăng nhập",
                        style: TextStyle(
                            fontWeight: FontWeight.w400, fontSize: 16.0),
                      ),
                    ),
                    Text(
                      "${user["tenTruyCap"] ?? ""}",
                      style: const TextStyle(
                          fontSize: 14.0,
                          color: Colors.black87,
                          fontWeight: FontWeight.w500),
                      textAlign: TextAlign.center,
                    )
                  ],
                ),
              ),
              const Divider(height: 1.0, thickness: 1),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  children: <Widget>[
                    const Icon(
                      MaterialCommunityIcons.cellphone,
                      color: Colors.purple,
                    ),
                    const SizedBox(width: 10.0),
                    const Expanded(
                      child: Text(
                        "Mobile",
                        style: TextStyle(
                            fontWeight: FontWeight.w400, fontSize: 16.0),
                      ),
                    ),
                    Text(
                      "${user["phone"] ?? ""}",
                      style: const TextStyle(
                          fontSize: 14.0,
                          color: Colors.black87,
                          fontWeight: FontWeight.w500),
                      textAlign: TextAlign.center,
                    )
                  ],
                ),
              ),
              const Divider(height: 1.0, thickness: 1),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  children: <Widget>[
                    const Icon(
                      Fontisto.email,
                      color: Colors.teal,
                    ),
                    const SizedBox(width: 10.0),
                    const Expanded(
                      child: Text(
                        "Email",
                        style: TextStyle(
                            fontWeight: FontWeight.w400, fontSize: 16.0),
                      ),
                    ),
                    Text(
                      user["mail"] ?? "",
                      style: const TextStyle(
                          fontSize: 14.0,
                          color: Colors.black87,
                          fontWeight: FontWeight.w500),
                      textAlign: TextAlign.center,
                    )
                  ],
                ),
              ),
              const Divider(height: 1.0, thickness: 1),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  children: <Widget>[
                    const Icon(
                      AntDesign.calendar,
                      color: Colors.pink,
                    ),
                    const SizedBox(width: 10.0),
                    const Expanded(
                      child: Text(
                        "Ngày sinh",
                        style: TextStyle(
                            fontWeight: FontWeight.w400, fontSize: 16.0),
                      ),
                    ),
                    user["ngaySinh"] != null
                        ? Text(
                            "${user["ngaySinh"] ?? ''}",
                            style: const TextStyle(
                                fontSize: 14.0,
                                color: Colors.black87,
                                fontWeight: FontWeight.w500),
                            textAlign: TextAlign.center,
                          )
                        : Container(width: 0.0)
                  ],
                ),
              ),
              const Divider(height: 1.0, thickness: 1),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  children: <Widget>[
                    const Icon(
                      EvilIcons.location,
                      color: Colors.orange,
                    ),
                    const SizedBox(width: 10.0),
                    const Text(
                      "Địa chỉ",
                      style: TextStyle(
                          fontWeight: FontWeight.w400, fontSize: 16.0),
                    ),
                    const SizedBox(width: 5.0),
                    Expanded(
                      child: Text(
                        "${user["diaChi"] ?? ""}",
                        style: const TextStyle(
                            fontSize: 14.0,
                            color: Colors.black87,
                            fontWeight: FontWeight.w500),
                        textAlign: TextAlign.right,
                      ),
                    )
                  ],
                ),
              ),
              const Divider(height: 1.0, thickness: 1),
            ],
          ),
        ));
  }
}
