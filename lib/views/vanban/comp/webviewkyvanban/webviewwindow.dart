import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:soe/utils/golbal/golbal.dart';
import 'package:webview_windows/webview_windows.dart';

import '../../../component/use/inlineloadding.dart';

class WebBrowser extends StatefulWidget {
  final String url;
  final String chuky;
  const WebBrowser({Key? key, required this.url, required this.chuky})
      : super(key: key);

  @override
  State<WebBrowser> createState() => _WebBrowser();
}

class _WebBrowser extends State<WebBrowser> {
  final _controller = WebviewController();
  var imagePos = {};
  double zommImage = 1;
  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  @override
  dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> initPlatformState() async {
    await _controller.initialize();
    await _controller.setBackgroundColor(Colors.transparent);
    await _controller.setPopupWindowPolicy(WebviewPopupWindowPolicy.deny);
    await _controller.loadUrl(Uri.encodeFull(widget.url));
    _controller.title.listen((event) {
      if (event != "Document Viewer" && event.toString().contains("{")) {
        var data = json.decode(event);
        if (kDebugMode) {
          print(data);
        }
        imagePos = data;
      }
    });
    if (!mounted) return;
    setState(() {});
  }

  Widget compositeView() {
    if (!_controller.value.isInitialized) {
      return const InlineLoadding();
    } else {
      return Padding(
        padding: const EdgeInsets.all(20),
        child: Card(
            color: Colors.transparent,
            elevation: 0,
            clipBehavior: Clip.antiAliasWithSaveLayer,
            child: Stack(
              children: [
                Webview(
                  _controller,
                  permissionRequested: _onPermissionRequested,
                ),
                StreamBuilder<LoadingState>(
                    stream: _controller.loadingState,
                    builder: (context, snapshot) {
                      if (snapshot.hasData &&
                          snapshot.data == LoadingState.loading) {
                        return const LinearProgressIndicator();
                      } else {
                        return const SizedBox();
                      }
                    }),
              ],
            )),
      );
    }
  }

  Future<void> sendChuky(BuildContext context) async {
    await _controller.executeScript('initImage("${widget.chuky}",1,100);');
  }

  Future<void> updateChuky(double value) async {
    await _controller.executeScript('resetImage(${value * 3});');
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
        body: Center(
          child: Column(
            children: [
              Expanded(child: compositeView()),
              SafeArea(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
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
        ));
  }

  Future<WebviewPermissionDecision> _onPermissionRequested(
      String url, WebviewPermissionKind kind, bool isUserInitiated) async {
    final decision = await showDialog<WebviewPermissionDecision>(
      context: Get.context!,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('WebView permission requested'),
        content: Text('WebView has requested permission \'$kind\''),
        actions: <Widget>[
          TextButton(
            onPressed: () =>
                Navigator.pop(context, WebviewPermissionDecision.deny),
            child: const Text('Deny'),
          ),
          TextButton(
            onPressed: () =>
                Navigator.pop(context, WebviewPermissionDecision.allow),
            child: const Text('Allow'),
          ),
        ],
      ),
    );

    return decision ?? WebviewPermissionDecision.none;
  }
}
