import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hotelmanagementapp/public/common_function.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebContentPage extends StatelessWidget {
  final String url;
  final String title;
  const WebContentPage({super.key, required this.url, required this.title});

  @override
  Widget build(BuildContext context) {
    if (kIsWeb) {
      // ✅ Web: use iframe without setJavaScriptMode
      return Scaffold(
        appBar: AppBar(
            title: Text(
          title,
          style: GoogleFonts.inter(
            fontWeight: FontWeight.w600,
            fontSize: kText.scale(20),
            color: Colors.black,
          ),
        )),
        body: WebViewWidget(
          controller: WebViewController()
            ..loadRequest(Uri.parse(url)), // only safe call
        ),
      );
    } else {
      // ✅ Mobile: full InAppWebView
      return Scaffold(
        appBar: AppBar(title: const Text("Web Page")),
        body: InAppWebView(
          initialUrlRequest: URLRequest(url: WebUri(url)),
        ),
      );
    }
  }
}
