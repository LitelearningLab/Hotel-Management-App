import 'dart:async';
import 'dart:developer';

import 'package:after_layout/after_layout.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:hotelmanagementapp/controller/in_app_web_view_controller.dart';
import 'package:hotelmanagementapp/dbHelper/progress_bar_db_helper.dart';
import 'package:hotelmanagementapp/main.dart';
import 'package:hotelmanagementapp/model/progress_model.dart';
import 'package:hotelmanagementapp/public/api.dart';
import 'package:hotelmanagementapp/public/common_function.dart';
import 'package:hotelmanagementapp/public/constant.dart';
import 'package:hotelmanagementapp/route/route_name.dart';
import 'package:path_provider/path_provider.dart';

class InAppWebViewPage extends StatefulWidget {
  InAppWebViewPage({Key? key}) : super(key: key);

  @override
  _InAppWebViewPageState createState() => _InAppWebViewPageState();
}

class _InAppWebViewPageState extends State<InAppWebViewPage>
    with AfterLayoutMixin<InAppWebViewPage>, WidgetsBindingObserver {
  bool onLoad = true;
  bool isLandscape = false;
  bool isMeetingEtiquite = false;
  Map<String, ProgressModel> progressData = {};
  Timer? _timer;
  String? cachedHtml;
  late Box<String> cacheBox;
  bool cacheReady = false;

  // guard so we don't repeatedly init cache on rebuilds
  bool _cacheRequested = false;
  String? _cachedForUrl;

  InAppWebViewController? webViewCtrl;

  Future<void> _initCache(String url) async {
    try {
      final dir = await getApplicationDocumentsDirectory();
      if (!Hive.isBoxOpen("web_cache")) {
        Hive.init(dir.path);
      }
      cacheBox = await Hive.openBox<String>("web_cache");

      // Check if URL already cached
      if (cacheBox.containsKey(url)) {
        cachedHtml = cacheBox.get(url);
        onLoad = false; // already have cache, skip loader
        log("📦 Loaded from cache: $url");
      } else {
        cachedHtml = null;
      }

      setState(() {
        cacheReady = true;
        _cachedForUrl = url;
      });
    } catch (e, st) {
      log("Cache init error: $e\n$st");
      setState(() {
        cacheReady = true; // proceed even if cache fails
      });
    }
  }

  Future<bool> _checkInternetAndHandleBack() async {
    var results = await Connectivity().checkConnectivity();

    bool isConnected =
        results.any((result) => result != ConnectivityResult.none);
    log("$isConnected $results is connected or not in the back button press.");

    if (!isConnected) {
      isOnNoInternetPage = true;
      // Get.toNamed(AppRoutes.noInternet);
      return false;
    }
    return true;
  }

  @override
  void initState() {
    _startTimer(subCategoryTitle, 1);
    _cacheRequested = false;
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    resetOrientationIfNeeded();
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer(String id, int option) {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) async {
      ProgressModel? p = await ProgressBarDbHelper.getProgress(id);
      if (p == null) return;

      int o1Time = p.option1Time;
      int o2Time = p.option2Time;
      bool o1Done = p.option1Done;
      bool o2Done = p.option2Done;
      double percentage = p.percentageEarned;

      if (option == 1 && !o1Done) {
        o1Time++;
        if (o1Time >= 10) {
          // change 10 -> 300 for 5 min
          o1Done = true;
          percentage += 3;
        }
      } else if (option == 2 && !o2Done) {
        o2Time++;
        if (o2Time >= 10) {
          o2Done = true;
          percentage += 1;
        }
      }

      ProgressModel updated = ProgressModel(
        id: id,
        option1Time: o1Time,
        option1Done: o1Done,
        option2Time: o2Time,
        option2Done: o2Done,
        percentageEarned: percentage,
      );

      await ProgressBarDbHelper.saveProgress(updated);

      setState(() {
        progressData[id] = updated;
      });

      if ((option == 1 && o1Done) || (option == 2 && o2Done)) {
        _timer?.cancel();
      }
    });
  }

  void resetOrientationIfNeeded() {
    if (isLandscape || isMeetingEtiquite) {
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
    if (isMeetingEtiquite) {
      SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    } else if (isLandscape) {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);
    }
  }

  // helper to cache HTML after load stop
  Future<void> _cacheHtmlIfNeeded(
      String url, InAppWebViewController controller) async {
    try {
      // don't cache if we already have it
      if (cacheBox.isOpen && cacheBox.containsKey(url)) return;

      // evaluate JS to get full HTML
      final dynamic raw = await controller.evaluateJavascript(
        source: "document.documentElement.outerHTML;",
      );
      if (raw == null) return;
      String html;
      if (raw is String) {
        html = raw;
      } else {
        html = raw.toString();
      }

      if (html.isNotEmpty) {
        await cacheBox.put(url, html);
        log("✅ Cached $url");
      }
    } catch (e, st) {
      log("Error caching HTML: $e\n$st");
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvoked: (didPop) async {
        await _checkInternetAndHandleBack();
        stopTimerMainCategory();
      },
      child: GetBuilder<InAppWebViewGetController>(builder: (controller) {
        // Request cache init only once per distinct URL
        if (!_cacheRequested && controller.url.isNotEmpty) {
          _cacheRequested = true;
          _initCache(controller.url);
        } else if (_cachedForUrl != null &&
            controller.url.isNotEmpty &&
            controller.url != _cachedForUrl) {
          // controller url changed: re-init cache for new url
          _cacheRequested = true;
          _initCache(controller.url);
        }

        // If cache not ready yet show loader to avoid race
        if (!cacheReady) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        return Scaffold(
          backgroundColor: Colors.white,
          body: Stack(
            children: [
              // Splash/white background behind webview to avoid black flicker
              Container(color: Colors.white),

              Column(
                children: [
                  Expanded(
                    child: Padding(
                      padding:
                          EdgeInsets.only(top: getWidgetHeight(height: 50)),
                      child: cachedHtml != null
                          ? InAppWebView(
                              initialData: InAppWebViewInitialData(
                                data: cachedHtml!,
                                baseUrl: WebUri(controller.url),
                                mimeType: "text/html",
                                encoding: "utf-8",
                              ),
                              onWebViewCreated: (c) {
                                webViewCtrl = c;
                              },
                              onLoadStart: (c, url) {
                                setState(() => onLoad = true);
                              },
                              onLoadStop: (c, url) {
                                setState(() => onLoad = false);
                              },
                            )
                          : InAppWebView(
                              initialUrlRequest: URLRequest(
                                url: WebUri(controller.url),
                              ),
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
                              onWebViewCreated: (c) {
                                webViewCtrl = c;
                              },
                              onLoadStart: (c, url) {
                                setState(() => onLoad = true);
                              },
                              onLoadStop: (c, url) async {
                                setState(() => onLoad = false);
                                // cache HTML for this URL if not already cached
                                try {
                                  // ensure cacheBox is open (init may have succeeded earlier)
                                  if (!Hive.isBoxOpen("web_cache")) {
                                    final dir =
                                        await getApplicationDocumentsDirectory();
                                    Hive.init(dir.path);
                                    cacheBox =
                                        await Hive.openBox<String>("web_cache");
                                  }
                                  await _cacheHtmlIfNeeded(controller.url, c);
                                } catch (e, st) {
                                  log("onLoadStop cache error: $e\n$st");
                                }
                              },
                              shouldOverrideUrlLoading: (c, action) async {
                                // allow all navigation (you can add custom logic)
                                return NavigationActionPolicy.ALLOW;
                              },
                              androidOnPermissionRequest:
                                  (c, origin, resources) async {
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
                top: controller.isSimulation
                    ? getWidgetHeight(height: 60)
                    : null,
                bottom: controller.isSimulation
                    ? null
                    : getWidgetHeight(height: 20),
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
        );
      }),
    );
  }
}
