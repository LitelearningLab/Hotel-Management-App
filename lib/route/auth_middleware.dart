// auth_middleware.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hotelmanagementapp/route/route_name.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthMiddleware extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    Future.delayed(Duration.zero, () async {
      final prefs = await SharedPreferences.getInstance();
      final email = prefs.getString('email');
      final password = prefs.getString('password');
      final loggedIn = email != null && password != null;

      if (!loggedIn && route != AppRoutes.login) {
        prefs.setString('lastFailedRoute', route ?? '');
        Get.rootDelegate.offNamed(AppRoutes.login);
      } else if (loggedIn && route == AppRoutes.login) {
        Get.rootDelegate.offNamed(AppRoutes.home);
      }
    });
    return null;
  }
}
