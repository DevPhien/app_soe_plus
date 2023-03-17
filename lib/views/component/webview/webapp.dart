import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewApp extends StatefulWidget {
  const WebViewApp({
    Key? key,
  }) : super(key: key);

  @override
  _WebViewState createState() => _WebViewState();
}

class _WebViewState extends State<WebViewApp> {
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
    return const WebView(
        initialUrl: "https://app.soe.vn",
        javascriptMode: JavascriptMode.unrestricted,
        allowsInlineMediaPlayback: true);
  }
}
