import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:soe/utils/golbal/golbal.dart';
import 'package:soe/views/user/controller/usercontroller.dart';

class InfoSmartOffice extends StatelessWidget {
  final UserController controller = Get.put(UserController());

  InfoSmartOffice({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context)
          .copyWith(textScaleFactor: Golbal.textScaleFactor),
      child: Scaffold(
        backgroundColor: const Color(0xFFf2f2f2),
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.black45),
          backgroundColor: Colors.white,
          automaticallyImplyLeading: false,
          elevation: 0.0,
          title: const Text(
            "Thông tin về Smart Ofifce",
            style: TextStyle(
              color: Color(0xFF0186f8),
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.close),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        ),
        body: Stack(
          children: <Widget>[
            Column(
              children: <Widget>[
                Container(
                  margin: const EdgeInsets.all(10.0),
                  padding: const EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5.0),
                    color: Colors.white,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Row(
                            children: const <Widget>[
                              Icon(
                                MaterialCommunityIcons.certificate,
                                size: 18.0,
                                color: Color(0xFF2196f3),
                              ),
                              SizedBox(width: 5.0),
                              Text("Phiên bản hiện tại:"),
                            ],
                          ),
                          Text(
                            "${controller.infoApp}",
                            style: const TextStyle(color: Colors.black87),
                          ),
                        ],
                      ),
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //   children: <Widget>[
                      //     Row(
                      //       children: <Widget>[
                      //         Icon(
                      //           MaterialCommunityIcons.web,
                      //           color: const Color(0xFF673ab7),
                      //           size: 16.0,
                      //         ),
                      //         SizedBox(width: 5.0),
                      //         Text("Website sản phẩm:"),
                      //       ],
                      //     ),
                      //     FlatButton(
                      //       onPressed: () {
                      //         goUrl("http://www.soe.vn");
                      //       },
                      //       child: Text("www.soe.vn"),
                      //     )
                      //   ],
                      // ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Row(
                            children: const <Widget>[
                              Icon(
                                MaterialCommunityIcons.comment_text_outline,
                                color: Colors.pink,
                                size: 16.0,
                              ),
                              SizedBox(width: 5.0),
                              Text("Góp ý và phản hồi:"),
                            ],
                          ),
                          TextButton(
                            onPressed: () {
                              controller.sendMail("sale@soe.vn");
                            },
                            child: const Text(
                              "sale@soe.vn",
                              style: TextStyle(color: Colors.black87),
                            ),
                          )
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Row(
                            children: const <Widget>[
                              Icon(
                                AntDesign.mobile1,
                                color: Colors.green,
                                size: 16.0,
                              ),
                              SizedBox(width: 5.0),
                              Text("Hỗ trợ sản phẩm:"),
                            ],
                          ),
                          TextButton(
                            onPressed: () {
                              controller.initCall("0901426788");
                            },
                            child: const Text(
                              "090 142 6788",
                              style: TextStyle(color: Colors.black87),
                            ),
                          )
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Expanded(
                            child: Row(
                              children: const <Widget>[
                                Icon(
                                  MaterialCommunityIcons.web,
                                  color: Colors.green,
                                  size: 16.0,
                                ),
                                SizedBox(width: 5.0),
                                Expanded(
                                    child: Text(
                                  "Url App:",
                                  maxLines: 1,
                                )),
                              ],
                            ),
                          ),
                          Obx(() => TextButton(
                                onPressed: (() {
                                  controller.goSetting(context);
                                }),
                                child: Text(
                                  "${controller.urlApp}",
                                  style: const TextStyle(color: Colors.black87),
                                ),
                              )),
                        ],
                      ),
                    ],
                  ),
                ),
                Expanded(
                    child: Container(
                  margin: const EdgeInsets.all(10.0),
                  padding: const EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5.0),
                      color: Colors.white,
                      image: DecorationImage(
                          colorFilter: ColorFilter.mode(
                              Colors.black.withOpacity(.3), BlendMode.dstATop),
                          image: const AssetImage("assets/os.jpg"),
                          alignment: Alignment.bottomRight)),
                  child: ListView(
                    children: <Widget>[
                      const Text("Smart Office Enterprise Team",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 15)),
                      const SizedBox(height: 15.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Row(
                            children: const <Widget>[
                              Icon(
                                EvilIcons.location,
                                size: 22.0,
                                color: Color(0xFF2196f3),
                              ),
                              Text("Địa chỉ:")
                            ],
                          ),
                          const Expanded(
                            child: Text(
                              "Tầng 6 tòa nhà Văn phòng - Số 1, ngõ 7 Nguyên Hồng - Phường Thành Công - Quận Ba Đình - Hà Nội",
                              textAlign: TextAlign.right,
                              style: TextStyle(color: Colors.black87),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Row(
                            children: const <Widget>[
                              Icon(
                                Feather.phone,
                                color: Color(0xFF009688),
                                size: 16.0,
                              ),
                              SizedBox(width: 5.0),
                              Text("Điện thoại:")
                            ],
                          ),
                          TextButton(
                            onPressed: () {
                              controller.initCall("02435379185");
                            },
                            child: const Text(
                              "024.3537.9185",
                              style: TextStyle(color: Colors.black87),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Row(
                            children: const <Widget>[
                              Icon(
                                MaterialCommunityIcons.fax,
                                color: Color(0xFFff9800),
                                size: 16.0,
                              ),
                              SizedBox(width: 5.0),
                              Text("Fax:")
                            ],
                          ),
                          TextButton(
                            onPressed: () {
                              controller.initCall("02432595351");
                            },
                            child: const Text(
                              "024.3259.5351",
                              style: TextStyle(color: Colors.black87),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Row(
                            children: const <Widget>[
                              Icon(
                                MaterialCommunityIcons.web,
                                color: Color(0xFF673ab7),
                                size: 16.0,
                              ),
                              SizedBox(width: 5.0),
                              Text("Webstie:")
                            ],
                          ),
                          TextButton(
                            onPressed: () {
                              controller.goUrl("https://www.soe.vn");
                            },
                            child: const Text(
                              "www.soe.vn",
                              style: TextStyle(color: Colors.black87),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Row(
                            children: const <Widget>[
                              Icon(
                                Fontisto.email,
                                color: Colors.blue,
                                size: 16.0,
                              ),
                              SizedBox(width: 5.0),
                              Text("Email:")
                            ],
                          ),
                          TextButton(
                            onPressed: () {
                              controller.sendMail("sale@soe.vn");
                            },
                            child: const Text(
                              "sale@soe.vn",
                              style: TextStyle(color: Colors.black87),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ))
              ],
            ),
            Positioned(
              bottom: 25.0,
              right: 0.0,
              left: Golbal.screenSize.width / 2 - 78,
              child: Center(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    const Icon(
                      AntDesign.copyright,
                      color: Colors.black54,
                      size: 12.0,
                    ),
                    const SizedBox(width: 5.0),
                    Text(
                      "Copyright 2008-${controller.year}",
                      style: const TextStyle(fontSize: 12.0),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
