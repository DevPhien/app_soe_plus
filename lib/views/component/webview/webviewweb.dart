import 'package:flutter/material.dart';
//ignore: avoid_web_libraries_in_flutter
// import 'dart:html' as html;
// import 'dart:ui' as ui;

//import 'package:get/get.dart';

class WebViewWeb extends StatefulWidget {
  final String html;
  const WebViewWeb({Key? key, required this.html}) : super(key: key);

  @override
  _WebViewState createState() => _WebViewState();
}

class _WebViewState extends State<WebViewWeb> {
  // static html.IFrameElement iframe = html.IFrameElement()
  //   ..width = MediaQuery.of(Get.context!).size.width.toString() //'800'
  //   ..height = MediaQuery.of(Get.context!).size.height.toString() //'400'
  //   ..style.border = 'none'
  //   ..onLoad.listen((event) async {});
  final String createdViewId = 'viewHTML';
  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  Future<void> initPlatformState() async {
    // ignore: undefined_prefixed_name
    // ui.platformViewRegistry.registerViewFactory(createdViewId, (int viewId) {
    //   iframe = html.IFrameElement()
    //     ..width = MediaQuery.of(Get.context!).size.width.toString() //'800'
    //     ..height = MediaQuery.of(Get.context!).size.height.toString() //'400'
    //     ..src = Uri.encodeFull(widget.html)
    //     ..style.border = 'none';
    //   return iframe;
    // });
  }

  @override
  dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return HtmlElementView(
      viewType: createdViewId,
    );
  }
}
