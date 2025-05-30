import 'dart:async';
import 'dart:developer';

import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:hotelmanagementapp/public/common_function.dart';
import 'package:hotelmanagementapp/public/constant.dart';

class InAppWebViewPage extends StatefulWidget {
  InAppWebViewPage(
      {Key? key,
      required this.url,
      this.isLandscape = false,
      this.isMeetingEtiquite = false})
      : super(key: key);

  final String url;
  final bool isLandscape;
  final bool isMeetingEtiquite;

  @override
  _InAppWebViewPageState createState() => new _InAppWebViewPageState();
}

class _InAppWebViewPageState extends State<InAppWebViewPage>
    with AfterLayoutMixin<InAppWebViewPage>, WidgetsBindingObserver {
  bool onLoad = false;

  @override
  void initState() {
    super.initState();
    startTimerMainCategory("name");
    // Add the observer for lifecycle events
    WidgetsBinding.instance.addObserver(this);
  }

  start() async {}

  @override
  void dispose() {
    // Remove the observer when the widget is disposed
    WidgetsBinding.instance.removeObserver(this);

    if (widget.isLandscape || widget.isMeetingEtiquite) {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);
    }
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive ||
        state == AppLifecycleState.detached) {
      if (count > 0) {
        recordTiming("Paused");
      }
      log("User navigated to another app or attended a call.${count}");
    } else if (state == AppLifecycleState.resumed) {
      startTimings = DateTime.now();
      resume = true;
      // subResume = true;
      log("User returned to the app.");
    }
  }

  @override
  FutureOr<void> afterFirstLayout(BuildContext context) {
    if (widget.isMeetingEtiquite) {
      SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    } else if (widget.isLandscape) {
      SystemChrome.setPreferredOrientations(
          [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
    }
  }

  @override
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
            Column(
              children: <Widget>[
                Expanded(
                  child: Container(
                    color: Colors.white,
                    child: Padding(
                      padding:
                          EdgeInsets.only(top: getWidgetHeight(height: 50)),
                      child: InAppWebView(
                        onLoadStop: (controller, url) {
                          setState(() {
                            onLoad = false;
                          });
                        },
                        onLoadStart: (controller, url) {
                          setState(() {
                            onLoad = true;
                          });
                        },
                        initialUrlRequest:
                            URLRequest(url: Uri.parse(widget.url)),
                        initialOptions: InAppWebViewGroupOptions(
                          crossPlatform: InAppWebViewOptions(
                              mediaPlaybackRequiresUserGesture: false,
                              disableContextMenu: true),
                          android: AndroidInAppWebViewOptions(
                            allowFileAccess: false,
                            allowContentAccess: false,
                          ),
                          ios: IOSInAppWebViewOptions(
                            allowsLinkPreview: false,
                          ),
                        ),
                        onWebViewCreated: (controller) {},
                        onDownloadStartRequest: (controller, request) async {
                          return;
                        },
                        shouldOverrideUrlLoading:
                            (controller, navigationAction) async {
                          return NavigationActionPolicy.ALLOW;
                        },
                        androidOnPermissionRequest:
                            (controller, origin, resources) async {
                          return PermissionRequestResponse(
                              resources: resources,
                              action: PermissionRequestResponseAction.GRANT);
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
            // Loader Overlay
            if (onLoad)
              Container(
                color: Colors.white,
                child: Center(
                  child: CircularProgressIndicator(
                    color: linearColor,
                  ),
                ),
              ),

            // Back Button
            Positioned(
              bottom: 20,
              left: 10,
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
