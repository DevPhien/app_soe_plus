import 'dart:async';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewHTMLMobile extends StatefulWidget {
  final String html;
  const WebViewHTMLMobile({Key? key, required this.html}) : super(key: key);

  @override
  WebViewState createState() => WebViewState();
}

class WebViewState extends State<WebViewHTMLMobile> {
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();
  late WebViewController webcontroller;
  @override
  void initState() {
    super.initState();
  }

  @override
  dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WebView(
      javascriptMode: JavascriptMode.unrestricted,
      allowsInlineMediaPlayback: true,
      onWebViewCreated: (WebViewController controller) {
        _controller.complete(controller);
        webcontroller = controller;
        webcontroller.loadHtmlString(widget.html);
      },
    );
  }
}
