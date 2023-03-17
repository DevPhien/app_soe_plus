import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import '../../../../utils/golbal/golbal.dart';
// ignore: avoid_web_libraries_in_flutter
// import 'dart:html' as html;
// import 'dart:ui' as ui;

class WebViewWeb extends StatefulWidget {
  final String url;
  final String chuky;
  const WebViewWeb({Key? key, required this.url, required this.chuky})
      : super(key: key);

  @override
  _WebViewState createState() => _WebViewState();
}

class _WebViewState extends State<WebViewWeb> {
  // static html.IFrameElement iframe = html.IFrameElement()
  //   ..width = MediaQuery.of(Get.context!).size.width.toString() //'800'
  //   ..height = MediaQuery.of(Get.context!).size.height.toString() //'400'
  //   ..style.border = 'none'
  //   ..onLoad.listen((event) async {});
  final String createdViewId = 'signDoc';
  var imagePos = {};
  double zommImage = 1;
  @override
  void initState() {
    super.initState();
    initPlatformState();
    //html.window.addEventListener('message', handleMessage, true);
  }

  // void handleMessage(html.Event e) {
  //   var data = (e as html.MessageEvent).data;
  //   imagePos = data;
  // }

  Future<void> initPlatformState() async {
    // ignore: undefined_prefixed_name
    // ui.platformViewRegistry.registerViewFactory(createdViewId, (int viewId) {
    //   iframe = html.IFrameElement()
    //     ..width = MediaQuery.of(Get.context!).size.width.toString() //'800'
    //     ..height = MediaQuery.of(Get.context!).size.height.toString() //'400'
    //     ..src = Uri.encodeFull(widget.url)
    //     ..style.border = 'none'
    //     ..onLoad.listen((event) async {});
    //   return iframe;
    // });
  }

  @override
  dispose() {
    //html.window.removeEventListener('message', handleMessage, true);
    super.dispose();
  }

  Future<void> sendChuky(BuildContext context) async {
    // iframe.contentWindow!.postMessage(
    //     widget.chuky, Uri.encodeFull(widget.url));
  }
  Future<void> updateChuky(double value) async {
    // iframe.contentWindow!.postMessage(
    //     "{width:value * 3}", Uri.encodeFull(widget.url));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Golbal.appColorD,
        elevation: 1.0,
        iconTheme: IconThemeData(color: Golbal.iconColor),
        title: Text("Chèn chữ ký",
            style: TextStyle(
                color: Golbal.titleappColor, fontWeight: FontWeight.bold)),
        centerTitle: true,
        systemOverlayStyle: Golbal.systemUiOverlayStyle1,
      ),
      body: Column(
        children: [
          Expanded(
              child: HtmlElementView(
            viewType: createdViewId,
          )),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    child: Image.network(
                      widget.chuky,
                      height: 40,
                    ),
                    onTap: () {
                      sendChuky(context);
                    },
                  ),
                  Slider(
                    value: zommImage,
                    max: 100,
                    divisions: 50,
                    label: zommImage.round().toString() + " %",
                    onChanged: (double value) {
                      updateChuky(value);
                      setState(() {
                        zommImage = value;
                      });
                    },
                  ),
                  FloatingActionButton(
                    onPressed: () async {
                      Get.back(result: imagePos);
                    },
                    child: const Icon(Ionicons.save_outline),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
