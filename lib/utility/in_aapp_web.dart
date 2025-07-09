import 'dart:async';
import 'dart:developer';

import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:hotelmanagementapp/public/api.dart';
import 'package:hotelmanagementapp/public/common_function.dart';
import 'package:hotelmanagementapp/public/constant.dart';

class InAppWebViewPage extends StatefulWidget {
  final String url;
  final bool isLandscape;
  final bool isMeetingEtiquite;
  final bool isSimulation;

  InAppWebViewPage({
    Key? key,
    required this.url,
    this.isLandscape = false,
    this.isMeetingEtiquite = false,
    this.isSimulation = false,
  }) : super(key: key);

  @override
  _InAppWebViewPageState createState() => _InAppWebViewPageState();
}

class _InAppWebViewPageState extends State<InAppWebViewPage>
    with AfterLayoutMixin<InAppWebViewPage>, WidgetsBindingObserver {
  bool onLoad = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    if (widget.url != ApiRoutes.privacyPolicy) {
      startTimerMainCategory("name");
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    resetOrientationIfNeeded();
    super.dispose();
  }

  void resetOrientationIfNeeded() {
    if (widget.isLandscape || widget.isMeetingEtiquite) {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive ||
        state == AppLifecycleState.detached) {
      if (count > 0) recordTiming("Paused");
      log("App paused or user left: $count");
    } else if (state == AppLifecycleState.resumed) {
      startTimings = DateTime.now();
      resume = true;
      log("User returned to the app.");
    }
  }

  @override
  FutureOr<void> afterFirstLayout(BuildContext context) {
    if (widget.isMeetingEtiquite) {
      SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    } else if (widget.isLandscape) {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvoked: (didPop) {
        stopTimerMainCategory();
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            // Splash/white background behind webview to avoid black flicker
            Container(color: Colors.white),

            Column(
              children: [
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(top: getWidgetHeight(height: 50)),
                    child: InAppWebView(
                      initialUrlRequest: URLRequest(url: Uri.parse(widget.url)),
                      initialOptions: InAppWebViewGroupOptions(
                        crossPlatform: InAppWebViewOptions(
                          mediaPlaybackRequiresUserGesture: false,
                          disableContextMenu: true,
                        ),
                        android: AndroidInAppWebViewOptions(
                          allowFileAccess: false,
                          allowContentAccess: false,
                        ),
                        ios: IOSInAppWebViewOptions(
                          allowsLinkPreview: false,
                        ),
                      ),
                      onLoadStart: (controller, url) {
                        setState(() => onLoad = true);
                      },
                      onLoadStop: (controller, url) {
                        setState(() => onLoad = false);
                      },
                      shouldOverrideUrlLoading: (controller, action) async {
                        return NavigationActionPolicy.ALLOW;
                      },
                      androidOnPermissionRequest:
                          (controller, origin, resources) async {
                        return PermissionRequestResponse(
                          resources: resources,
                          action: PermissionRequestResponseAction.GRANT,
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),

            if (onLoad)
              Container(
                color: Colors.white,
                child: Center(
                  child: CircularProgressIndicator(color: linearColor),
                ),
              ),

            Positioned(
              top: widget.isSimulation ? getWidgetHeight(height: 60) : null,
              bottom: widget.isSimulation ? null : getWidgetHeight(height: 20),
              left: getWidgetWidth(width: 10),
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      spreadRadius: 1,
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: IconButton(
                  onPressed: () {
                    stopTimerMainCategory();
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.arrow_back),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
