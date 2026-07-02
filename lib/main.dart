import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hotelmanagementapp/firebase_options.dart';
import 'package:hotelmanagementapp/public/common_function.dart';
import 'package:hotelmanagementapp/public/sessio_service.dart';
import 'package:hotelmanagementapp/route/app_router_delegate.dart';
import 'package:hotelmanagementapp/route/binding.dart';
import 'package:hotelmanagementapp/route/route_name.dart';
import 'package:hotelmanagementapp/route/route_service.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
//for web only
import 'dart:html' as html;
import 'package:get_storage/get_storage.dart';
import 'package:hotelmanagementapp/view/blocked_device_screen.dart';
// import 'package:webview_flutter_web/webview_flutter_web.dart';

bool isOnNoInternetPage = false;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  final appRouterDelegate = Get.put(AppRouterDelegate(), permanent: true);
  Get.lazyPut<AppRouterDelegate>(() => AppRouterDelegate());

  // WebView.platform = WebWebViewPlatform();
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
      options: FirebaseOptions(
        apiKey: "AIzaSyBWDZkn03gGxw7jnJYSQI0PZQbSTY8LC1Q",
        appId: "1:233565329277:web:4df00d8ac94bf7ff005e14",
        messagingSenderId: "233565329277",
        projectId: "hotel-management-app-d25d5",
        authDomain: "hotel-management-app-d25d5.firebaseapp.com",
        storageBucket: "hotel-management-app-d25d5.firebasestorage.app",
        databaseURL:
            "https://hotel-management-app-d25d5-default-rtdb.firebaseio.com/",
      ),
    );
    // // for web only
    if (_isMobileOrTabletDevice()) {
      runApp(const BlockedDeviceScreen(
        reason: "Your account is already active on another device.",
      ));
      return;
    }
  } else {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }

  runApp(MyApp(
    appRouterDelegate: appRouterDelegate,
  ));
}

// // for web only
bool _isMobileOrTabletDevice() {
  try {
    final userAgent = html.window.navigator.userAgent.toLowerCase();
    final screenWidth = html.window.screen?.width ?? 0;

    // Common mobile/tablet indicators
    return userAgent.contains('mobile') ||
        userAgent.contains('android') ||
        userAgent.contains('iphone') ||
        userAgent.contains('ipad') ||
        userAgent.contains('tablet') ||
        screenWidth < 900;
  } catch (_) {
    return false;
  }
}

class MyApp extends StatefulWidget {
  final AppRouterDelegate appRouterDelegate;
  MyApp({required this.appRouterDelegate, super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final Connectivity _connectivity = Connectivity();
  StreamSubscription<List<ConnectivityResult>>? _connectivitySub;
  Timer? _offlineDebounceTimer;
  String? lastRoute;

  bool _isConnected(List<ConnectivityResult> results) {
    return results.any((result) => result != ConnectivityResult.none);
  }

  @override
  void initState() {
    super.initState();
    if (kIsWeb) {
      SessionService.startWebSessionGuard(onSessionBlocked: () {
        if (Get.currentRoute != AppRoutes.login) {
          Get.rootDelegate.offNamed(AppRoutes.login);
        }
      });
    }

    _connectivitySub = _connectivity.onConnectivityChanged.listen((results) {
      final isConnected = _isConnected(results);

      if (isConnected) {
        _offlineDebounceTimer?.cancel();
        if (Get.currentRoute == AppRoutes.noInternet) {
          Get.back();
        }
      } else {
        // iOS (especially in debug/hot-restart) can emit transient `none`.
        // Re-check after a short delay before routing to No Internet screen.
        _offlineDebounceTimer?.cancel();
        _offlineDebounceTimer = Timer(const Duration(seconds: 2), () async {
          final recheck = await _connectivity.checkConnectivity();
          final stillOffline = !_isConnected(recheck);
          if (stillOffline && Get.currentRoute != AppRoutes.noInternet) {
            Get.toNamed(AppRoutes.noInternet);
          }
        });
      }
    });
  }

  @override
  void dispose() {
    if (kIsWeb) {
      SessionService.stopWebSessionGuard();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    kHeight = MediaQuery.of(context).size.height;
    kWidth = MediaQuery.of(context).size.width;
    kText = MediaQuery.of(context).textScaler;

    return kIsWeb
        ? GetMaterialApp.router(
            key: Get.key,
            routerDelegate: widget.appRouterDelegate,
            getPages: RouteService.getPages,
            // initialBinding: InitialBinding(),
            title: 'Profluent Hotelier',
            theme: ThemeData(
              useMaterial3: true,
              scaffoldBackgroundColor: Colors.white,
              primaryColor: Colors.white,
              colorScheme: ColorScheme.fromSwatch().copyWith(
                primary: Colors.white,
                surface: Colors.white,
                onSurface: Colors.black,
              ),
              appBarTheme: const AppBarTheme(
                backgroundColor: Colors.white,
                surfaceTintColor: Colors.transparent,
                elevation: 0,
              ),
              popupMenuTheme: const PopupMenuThemeData(
                color: Colors.white,
                surfaceTintColor: Colors.transparent,
              ),
              dialogTheme: const DialogThemeData(
                backgroundColor: Colors.white,
                surfaceTintColor: Colors.transparent,
              ),
            ),
          )
        : GetMaterialApp(
            // key: Get.key,
            getPages: RouteService.getPages,
            initialBinding: InitialBinding(),

            title: 'Profluent Hotelier',
            theme: ThemeData(
              useMaterial3: true,
              scaffoldBackgroundColor: Colors.white,
              primaryColor: Colors.white,
              colorScheme: ColorScheme.fromSwatch().copyWith(
                primary: Colors.white,
                surface: Colors.white,
                onSurface: Colors.black,
              ),
              appBarTheme: const AppBarTheme(
                backgroundColor: Colors.white,
                surfaceTintColor: Colors.transparent,
                elevation: 0,
              ),
              popupMenuTheme: const PopupMenuThemeData(
                color: Colors.white,
                surfaceTintColor: Colors.transparent,
              ),
              dialogTheme: const DialogThemeData(
                backgroundColor: Colors.white,
                surfaceTintColor: Colors.transparent,
              ),
            ),
            initialRoute: AppRoutes.splashScreen,
          );
  }
}
