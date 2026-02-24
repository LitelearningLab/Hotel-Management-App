import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hotelmanagementapp/public/common_function.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebContentPage extends StatefulWidget {
  final String url;
  final String title;
  const WebContentPage({super.key, required this.url, required this.title});

  @override
  State<WebContentPage> createState() => _WebContentPageState();
}

class _WebContentPageState extends State<WebContentPage> {
  @override
  void initState() {
    super.initState();
    startTimerMainCategory("");
  }

  @override
  void dispose() {
    stopTimerMainCategory();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (kIsWeb) {
      // ✅ Web: use iframe without setJavaScriptMode
      return PopScope(
        onPopInvoked: (didPop) => stopTimerMainCategory(),
        child: Scaffold(
          appBar: AppBar(leading: BackButton(onPressed: () {
            stopTimerMainCategory();
            Navigator.of(context).pop();
          }),
     
          ),
          body: WebViewWidget(
            controller: WebViewController()
              ..loadRequest(Uri.parse(widget.url)), // only safe call
          ),
        ),
      );
    } else {
      // ✅ Mobile: full InAppWebView
      return Scaffold(
        appBar: AppBar(title: const Text("Web Page")),
        body: InAppWebView(
          initialUrlRequest: URLRequest(url: WebUri(widget.url)),
        ),
      );
    }
  }
}
