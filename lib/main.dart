import 'dart:convert';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hotelmanagementapp/firebase_options.dart';
import 'package:hotelmanagementapp/public/common_function.dart';
import 'package:hotelmanagementapp/route/app_router_delegate.dart';
import 'package:hotelmanagementapp/route/binding.dart';
import 'package:hotelmanagementapp/route/route_name.dart';
import 'package:hotelmanagementapp/route/route_service.dart';
import 'package:hotelmanagementapp/view/home.dart';
import 'package:hotelmanagementapp/view/login.dart';
import 'package:hotelmanagementapp/view/splash.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

import 'package:get_storage/get_storage.dart';

bool isOnNoInternetPage = false;
void main() async {
  await GetStorage.init();
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
  } else {
    await Firebase.initializeApp();
  }
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final Connectivity _connectivity = Connectivity();
  String? lastRoute;

  @override
  void initState() {
    super.initState();

    _connectivity.onConnectivityChanged
        .listen((List<ConnectivityResult> results) {
      bool isConnected =
          results.any((result) => result != ConnectivityResult.none);

      if (!isConnected) {
        lastRoute = Get.currentRoute;
        if (lastRoute == AppRoutes.inAppWebView) return;
        if (lastRoute == AppRoutes.noInternet) return;

        isOnNoInternetPage = true;
        // Get.toNamed(AppRoutes.noInternet);
      } else {
        if (isOnNoInternetPage) {
          isOnNoInternetPage = false;
          if (Get.currentRoute == AppRoutes.noInternet) {
            Get.back();
          }
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    kHeight = MediaQuery.of(context).size.height;
    kWidth = MediaQuery.of(context).size.width;
    kText = MediaQuery.of(context).textScaler;

    return kIsWeb
        ? GetMaterialApp.router(
            key: Get.key,
            routerDelegate: AppRouterDelegate(),
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
