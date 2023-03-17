import 'dart:async';
import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../model/congty.dart';
import '../../utils/golbal/golbal.dart';
import '../component/use/inlineloadding.dart';
import '../login/login.dart';

class ChonCongTy extends StatefulWidget {
  final bool? back;
  const ChonCongTy({Key? key, this.back}) : super(key: key);
  @override
  ChonCongTyState createState() => ChonCongTyState();
}

// Custom config
class ChonCongTyState extends State<ChonCongTy> {
  List<CongTy> apps = <CongTy>[];
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 100), () {
      listApps();
    });
  }

  listApps() async {
    try {
      var response = await Dio()
          .post("https://api.soe.vn/api/HomeApp/GetListOrganization", data: {});
      var data = response.data;
      if (data != null) {
        var tbs = json.decode(data["data"]);
        if (tbs.length > 0) {
          List<CongTy> als = <CongTy>[];
          for (var obj in tbs) {
            CongTy vs = CongTy.fromJson(obj);
            if (vs.logo != null) {
              vs.logo = "https://sfile.soe.vn/" + vs.logo!;
            }
            als.add(vs);
          }
          setState(() {
            apps = als;
          });
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  Future<void> chonCongty(CongTy cty) async {
    //print(cty.toJson());
    Golbal.congty = cty;
    EasyLoading.show(
      status: "loading ...",
    );
    EasyLoading.dismiss();
    if (widget.back == true) {
      Navigator.of(context).pop();
    } else {
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => const LoginPage()));
    }
  }

  initCall(String phone) async {
    try {
      var url = 'tel:$phone';
      if (await launchUrl(Uri.parse(url))) {
      } else {}
    } catch (e) {}
  }

  sendMail(String mail) async {
    try {
      var url =
          'mailto:$mail?subject=Hỗ trợ sử dụng SmartOffice&body=Dear OrientSoft,';
      if (await launchUrl(Uri.parse(url))) {
      } else {}
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    int col = 3;
    double chilratio = 1;
    return MediaQuery(
        data: MediaQuery.of(context)
            .copyWith(textScaleFactor: Golbal.textScaleFactor),
        child: Scaffold(
          appBar: AppBar(
            iconTheme: const IconThemeData(color: Colors.white),
            elevation: 0.0,
            //titleSpacing: 0.0,
            backgroundColor: const Color(0xFF0078D4),
            title: const Text("Xác định đơn vị sử dụng",
                style: TextStyle(color: Colors.white)),
          ),
          backgroundColor: const Color(0xFFeeeeee),
          body: apps.isEmpty
              ? const InlineLoadding()
              : GridView.builder(
                  padding: const EdgeInsets.all(5),
                  itemCount: apps.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: col, childAspectRatio: chilratio),
                  itemBuilder: (BuildContext context, int i) {
                    CongTy cty = apps[i];
                    return InkWell(
                      onTap: () {
                        chonCongty(cty);
                      },
                      child: Container(
                        margin: const EdgeInsets.symmetric(
                            vertical: 5.0, horizontal: 5),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(
                                color: const Color(0xffdddddd), width: 0.5),
                            borderRadius: BorderRadius.circular(10.0)),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10.0, vertical: 5.0),
                        child: Center(
                          child: CachedNetworkImage(
                            imageUrl: cty.logo!,
                          ),
                        ),
                      ),
                    );
                  }),
        ));
  }
}
