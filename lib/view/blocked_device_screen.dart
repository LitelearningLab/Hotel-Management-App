import 'package:flutter/material.dart';
import 'package:hotelmanagementapp/public/all_asset.dart';
import 'package:hotelmanagementapp/public/common_function.dart';
import 'package:url_launcher/url_launcher.dart';

class BlockedDeviceScreen extends StatelessWidget {
  final String? reason; // 💡 dynamic message from outside
  static final Uri _playStoreUri = Uri.parse(
    "https://play.google.com/store/apps/details?id=com.profluent.hotelier.app",
  );
  static final Uri _appStoreUri = Uri.parse(
    "https://apps.apple.com/in/app/profluent-hotelier/id6754444749",
  );

  const BlockedDeviceScreen({super.key, this.reason});

  Future<void> _openStore(Uri uri) async {
    if (!await launchUrl(uri, webOnlyWindowName: "_blank")) {
      debugPrint("Could not launch $uri");
    }
  }

  @override
  Widget build(BuildContext context) {
    // Default message
    String message =
        "This website is optimized for desktop use only.\nMobile users: please use the Profluent Hotelier app.";

    final hasCustomReason = reason != null && reason!.isNotEmpty;
    // If custom reason provided → override message
    if (hasCustomReason) {
      message = reason!;
    }

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: LayoutBuilder(builder: (context, constraints) {
          kHeight = constraints.maxHeight;
          kWidth = constraints.maxWidth;
          kText = MediaQuery.of(context).textScaler;

          return Container(
            height: kHeight,
            width: kWidth,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFFF4F7FC), Color(0xFFE8EEF9)],
              ),
            ),
            child: SafeArea(
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 520),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 24,
                    ),
                    child: Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(18),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.08),
                            blurRadius: 18,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            height: getWidgetHeight(height: 122),
                            width: getWidgetWidth(width: 122),
                            child: Image.asset(
                              AllAssets.splashLogo,
                              fit: BoxFit.contain,
                              height: getWidgetHeight(height: 58),
                            ),
                          ),
                          hasCustomReason
                              ? Column(
                                  children: [
                                    SizedBox(height: getWidgetHeight(height: 10)),
                                    Text(
                                      message,
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                          fontSize: 16,
                                          height: 1.5,
                                          fontWeight: FontWeight.w500,
                                          color: Color.fromARGB(232, 244, 67, 54)),
                                    ),
                                  ],
                                )
                              : RichText(
                                  textAlign: TextAlign.center,
                                  text: const TextSpan(
                                    style: TextStyle(
                                      fontSize: 14,
                                      height: 1.5,
                                      fontWeight: FontWeight.w500,
                                      color: Color(0xFF344054),
                                    ),
                                    children: [
                                      TextSpan(
                                        text:
                                            "This website is optimized for desktop use only.\n",
                                      ),
                                      TextSpan(
                                        text: "Mobile users: ",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w700),
                                      ),
                                      TextSpan(
                                        text:
                                            "please use the Profluent Hotelier app. \n",
                                      ),
                                    ],
                                  ),
                                ),
                          if (!hasCustomReason)
                            Column(
                              children: [
                                SizedBox(
                                  width: getWidgetWidth(width: 200),
                                  child: ElevatedButton.icon(
                                    onPressed: () => _openStore(_playStoreUri),
                                    icon: const Icon(Icons.android_rounded),
                                    label: const Text("Play Store"),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFF129F52),
                                      foregroundColor: Colors.white,
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 12),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 20),
                                SizedBox(
                                  width: getWidgetWidth(width: 200),
                                  child: ElevatedButton.icon(
                                    onPressed: () => _openStore(_appStoreUri),
                                    icon: const Icon(Icons.apple_rounded),
                                    label: const Text("App Store"),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFF111827),
                                      foregroundColor: Colors.white,
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 12),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
