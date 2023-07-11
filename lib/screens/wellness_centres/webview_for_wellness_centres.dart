import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebviewForWellnessCentres extends StatefulWidget {
  final String websiteName, website;

  const WebviewForWellnessCentres(
      {super.key, required this.websiteName, required this.website});

  @override
  State<WebviewForWellnessCentres> createState() =>
      _WebviewForWellnessCentresState();
}

class _WebviewForWellnessCentresState extends State<WebviewForWellnessCentres> {
  @override
  Widget build(BuildContext context) {
    final controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      // ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {},
          onPageStarted: (String url) {},
          onPageFinished: (String url) {},
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.startsWith('https://www.flutter.dev')) {
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.website));

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.websiteName),
      ),
      body: WebViewWidget(controller: controller),
    );
  }
}
