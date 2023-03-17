import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:webview_windows/webview_windows.dart';

import '../use/inlineloadding.dart';

class WebHTML extends StatefulWidget {
  final String html;
  const WebHTML({Key? key, required this.html}) : super(key: key);

  @override
  State<WebHTML> createState() => _WebHTML();
}

class _WebHTML extends State<WebHTML> {
  final _controller = WebviewController();
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
    await _controller.loadStringContent(widget.html);
    if (!mounted) return;
    setState(() {});
  }

  Widget compositeView() {
    if (!_controller.value.isInitialized) {
      return const InlineLoadding();
    } else {
      return Stack(
        children: [
          Webview(
            _controller,
            permissionRequested: _onPermissionRequested,
          ),
          StreamBuilder<LoadingState>(
              stream: _controller.loadingState,
              builder: (context, snapshot) {
                if (snapshot.hasData && snapshot.data == LoadingState.loading) {
                  return const LinearProgressIndicator();
                } else {
                  return const SizedBox();
                }
              }),
        ],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return compositeView();
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
