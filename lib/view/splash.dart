import 'dart:async';
import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hotelmanagementapp/public/all_asset.dart';
import 'package:hotelmanagementapp/public/common_function.dart';
import 'package:hotelmanagementapp/view/login.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hotelmanagementapp/route/route_name.dart';

class SplashScreen extends StatefulWidget {
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    // FirebaseUploader firebaseUploader = FirebaseUploader();
    // firebaseUploader.uploadJsonData(
    //     'assets/EnglishLab.json', 'FrenchLabCollection');
    _initAnimation();
    startTimer();
  }

  void _initAnimation() {
    _controller = AnimationController(
      duration: Duration(milliseconds: 1500),
      vsync: this,
    );
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);

    _controller.forward();
  }

  Future<void> startTimer() async {
    log("checking whether it goes here or not");
    await Future.delayed(Duration(seconds: 2));
    final prefs = await SharedPreferences.getInstance();
    final email = prefs.getString('email');
    final password = prefs.getString('password');
    if (email != null && password != null) {
      log('navigating to home');
      kIsWeb
          ? Get.rootDelegate.offNamed(AppRoutes.home)
          : Get.offAllNamed(AppRoutes.home);
    } else {
      log("navigating to login");
      kIsWeb
          ? Get.rootDelegate.offNamed(AppRoutes.login)
          : Get.offAllNamed(AppRoutes.login);
      // Get.offAllNamed(AppRoutes.login);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: FadeTransition(
          opacity: _animation,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: getWidgetHeight(height: 300),
                width: getWidgetWidth(width: 300),
                child: CircleAvatar(
                  backgroundColor: Colors.transparent,
                  // radius: 25,
                  child: Image.asset(
                    AllAssets.splashLogo,
                    fit: BoxFit.contain,
                    // width: getWidgetWidth(width: 200),
                    height: getWidgetHeight(height: 300),
                  ),
                ),
              ),
              // SizedBox(height: 20),
              // Text(
              //   "Profluent Hotelier",
              //   style: TextStyle(
              //     fontSize: 24,
              //     fontWeight: FontWeight.bold,
              //     color: Colors.deepPurple,
              //   ),
              // ),
              // SizedBox(height: 10),
              if (!kIsWeb)
                Text(
                  "Loading...",
                  style: TextStyle(color: Colors.grey),
                ),
              SizedBox(height: getWidgetHeight(height: 60)),
            ],
          ),
        ),
      ),
    );
  }
}
