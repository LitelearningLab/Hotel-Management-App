import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hotelmanagementapp/route/route_name.dart';

class BottomNavigationController extends GetxController {
  RxInt currentIndex = 0.obs;

  void setIndex(int index) {
    currentIndex.value = index;
  }
}

class BottomNavObserver extends GetObserver {
  @override
  void didPush(Route route, Route? previousRoute) {
    super.didPush(route, previousRoute);
    _updateIndex();
  }

  @override
  void didPop(Route route, Route? previousRoute) {
    super.didPop(route, previousRoute);
    _updateIndex();
  }

  void _updateIndex() {
    final currentRoute = Get.routing.current;
    if (currentRoute == AppRoutes.home) {
      Get.find<BottomNavigationController>().setIndex(0);
    } else if (currentRoute == AppRoutes.simulation) {
      Get.find<BottomNavigationController>().setIndex(2);
    } else if (currentRoute == AppRoutes.languageLab) {
      Get.find<BottomNavigationController>().setIndex(3);
    } else if (currentRoute == AppRoutes.searchScreen) {
      Get.find<BottomNavigationController>().setIndex(1);
    }
  }
}
