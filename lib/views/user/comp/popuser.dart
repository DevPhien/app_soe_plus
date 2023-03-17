// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:circular_image/circular_image.dart';
import 'package:date_time_format/date_time_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:lottie/lottie.dart';
import 'package:soe/utils/golbal/golbal.dart';
import 'package:url_launcher/url_launcher.dart';

class PopUser extends StatelessWidget {
  final user;

  const PopUser({Key? key, this.user}) : super(key: key);

  initCall(String phone) async {
    if (phone == "") return;
    try {
      final url = Uri(
        scheme: 'tel',
        path: phone,
      );
      if (await canLaunchUrl(url)) {
        await launchUrl(url);
      } else {
        EasyLoading.showInfo("Không thể gọi điện cho số này");
      }
    } catch (e) {
      EasyLoading.showInfo("Không thể gọi điện cho số này");
    }
  }

  initSMS(String phone) async {
    if (phone == "") return;
    try {
      final url = Uri(
        scheme: 'sms',
        path: phone,
      );
      if (await canLaunchUrl(url)) {
        await launchUrl(url);
      } else {
        EasyLoading.showInfo("Không thể gửi tin nhắn cho số này");
      }
    } catch (e) {
      EasyLoading.showInfo("Không thể gửi tin nhắnn cho số này");
    }
  }

  // goChat(c, context) async {
  //   Navigator.of(context).pop();
  //   await Navigator.of(context, rootNavigator: true).push(new MaterialPageRoute(
  //       builder: (context) => new MessagePage(data: c, type: true)));
  // }

  @override
  Widget build(BuildContext context) {
    bool sn = Golbal.checkNgay(user["ngaySinh"]);
    return Dialog(
        //elevation: 0.0,
        backgroundColor: Colors.transparent,
        child: SizedBox(
            width:
                Golbal.screenSize.width > 720 ? 720 : Golbal.screenSize.width,
            height: user["mail"] != null ? 380 : 360,
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(5.0)),
              ),
              child: Stack(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Container(
                        height: 150,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(5.0),
                              topRight: Radius.circular(5.0),
                            ),
                            image: DecorationImage(
                                image: AssetImage(
                                  "assets/img/${sn ? "Backgr_CMSN" : "Backgr"}.jpg",
                                ),
                                fit: BoxFit.cover)),
                        child: Align(
                          alignment: Alignment.center,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              InkWell(
                                child: (user["hasImage"] != null &&
                                        user["hasImage"])
                                    ? CircularImage(
                                        radius: 24,
                                        source: user["anhThumb"],
                                      )
                                    : CircleAvatar(
                                        backgroundColor: HexColor("#AFDFCF"),
                                        radius: 24,
                                        child: Text(
                                          "${(user['subten'] ?? '')}",
                                          style: TextStyle(
                                            fontSize: 20,
                                            color: HexColor('#ffffff'),
                                          ),
                                        ),
                                      ),
                              ),
                              const SizedBox(height: 10.0),
                              Text("${user["fullName"]}",
                                  style: const TextStyle(
                                      fontSize: 16.0,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold)),
                              Text("${user["tenTruyCap"]}",
                                  style: const TextStyle(
                                      fontSize: 12.0,
                                      color: Colors.white70,
                                      fontWeight: FontWeight.w500)),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        child: SingleChildScrollView(
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 20.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                const SizedBox(height: 20.0),
                                Row(
                                  children: <Widget>[
                                    const SizedBox(
                                        width: 80,
                                        child: Text(
                                          "Năm sinh:",
                                          style: TextStyle(
                                              fontSize: 14.0,
                                              color: Colors.black45),
                                        )),
                                    Expanded(
                                      child: Text(
                                        DateTimeFormat.format(
                                            DateTime.parse(user["ngaySinh"]),
                                            format: 'd/m/Y'),
                                        style: const TextStyle(fontSize: 14.0),
                                      ),
                                    )
                                  ],
                                ),
                                const SizedBox(height: 10.0),
                                Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      const SizedBox(
                                          width: 80,
                                          child: Text(
                                            "Phòng ban:",
                                            style: TextStyle(
                                                fontSize: 14.0,
                                                color: Colors.black45),
                                          )),
                                      Expanded(
                                          child: Text(
                                        "${user["tenToChuc"] ?? ""}",
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(fontSize: 14.0),
                                      ))
                                    ]),
                                const SizedBox(height: 10.0),
                                Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      const SizedBox(
                                          width: 80,
                                          child: Text(
                                            "Chức vụ:",
                                            style: TextStyle(
                                                fontSize: 14.0,
                                                color: Colors.black45),
                                          )),
                                      Expanded(
                                          child: Text(
                                        "${user["tenChucVu"] ?? ""}",
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(fontSize: 14.0),
                                      ))
                                    ]),
                                const SizedBox(height: 10.0),
                                Row(children: <Widget>[
                                  const SizedBox(
                                      width: 80,
                                      child: Text(
                                        "Điện thoại:",
                                        style: TextStyle(
                                            fontSize: 14.0,
                                            color: Colors.black45),
                                      )),
                                  Expanded(
                                      child: Text(
                                    "${user["phone"] ?? ""}",
                                    style: const TextStyle(fontSize: 14.0),
                                  ))
                                ]),
                                const SizedBox(height: 10.0),
                                user["mail"] != null
                                    ? Row(children: <Widget>[
                                        const SizedBox(
                                            width: 80,
                                            child: Text(
                                              "Email:",
                                              style: TextStyle(
                                                  fontSize: 14.0,
                                                  color: Colors.black45),
                                            )),
                                        Expanded(
                                            child: Text(
                                          "${user["mail"] ?? ""}",
                                          style:
                                              const TextStyle(fontSize: 14.0),
                                        ))
                                      ])
                                    : Container(width: 0.0),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Positioned.fill(
                      child: Lottie.asset(
                    'assets/lottie/birthday.zip',
                  )),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      decoration: const BoxDecoration(
                          border: Border(
                              top:
                                  BorderSide(color: Colors.black12, width: 1))),
                      padding: const EdgeInsets.all(10.0),
                      width: double.infinity,
                      child: Align(
                        alignment: Alignment.center,
                        child: Wrap(
                          children: <Widget>[
                            user["phone"] != null
                                ? InkWell(
                                    onTap: () {
                                      initCall(user["phone"] ?? "");
                                    },
                                    child: Container(
                                      width: 48.0,
                                      height: 32.0,
                                      decoration: BoxDecoration(
                                          color: Color(0xFF48e181),
                                          borderRadius:
                                              BorderRadius.circular(5.0)),
                                      child: const Center(
                                          child: Icon(Icons.phone,
                                              color: Colors.white)),
                                    ))
                                : Container(width: 0.0),
                            const SizedBox(width: 10.0),
                            user["phone"] != null
                                ? InkWell(
                                    onTap: () {
                                      initSMS(user["phone"] ?? "");
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color: const Color(0xFF55bff6),
                                          borderRadius:
                                              BorderRadius.circular(5.0)),
                                      width: 48.0,
                                      height: 32.0,
                                      child: const Center(
                                          child: Icon(
                                        Icons.chat_bubble,
                                        color: Colors.white,
                                      )),
                                    ))
                                : Container(width: 0.0),
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            )));
  }
}
