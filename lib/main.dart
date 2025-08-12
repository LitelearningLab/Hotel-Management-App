import 'dart:convert';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hotelmanagementapp/firebase_options.dart';
import 'package:hotelmanagementapp/public/common_function.dart';
import 'package:hotelmanagementapp/route/binding.dart';
import 'package:hotelmanagementapp/route/route_name.dart';
import 'package:hotelmanagementapp/route/route_service.dart';
import 'package:hotelmanagementapp/view/home.dart';
import 'package:hotelmanagementapp/view/login.dart';
import 'package:hotelmanagementapp/view/splash.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

bool isOnNoInternetPage = false;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

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
        Get.toNamed(AppRoutes.noInternet);
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

    return GetMaterialApp(
      getPages: RouteService.getPages,
      initialBinding: InitialBinding(),
      title: 'Hotel Management App',
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        primaryColor: Colors.white,
        colorScheme: ColorScheme.fromSwatch().copyWith(primary: Colors.white),
      ),
      initialRoute: AppRoutes.splashScreen,
    );
  }
}
