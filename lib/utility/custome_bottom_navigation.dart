import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hotelmanagementapp/public/all_asset.dart';
import 'package:hotelmanagementapp/public/common_function.dart';
import 'package:hotelmanagementapp/public/constant.dart';
import 'package:hotelmanagementapp/route/route_name.dart';
import 'package:hotelmanagementapp/view/home.dart';

class CustomeBottomNavigation extends StatefulWidget {
  const CustomeBottomNavigation({super.key});

  @override
  State<CustomeBottomNavigation> createState() =>
      _CustomeBottomNavigationState();
}

class _CustomeBottomNavigationState extends State<CustomeBottomNavigation> {
  @override
  Widget build(BuildContext context) {
    return kIsWeb ? _webTopNav() : _mobileBottomNav();
  }

  // ==================================================
  // WEB TOP NAVIGATION (WEBSITE STYLE)
  // ==================================================
  Widget _webTopNav() {
    return Container(
      height: 64,
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: Color(0xFFEDEDED)),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _webNavItem(0, AllAssets.bottomHome),
          _webNavItem(1, AllAssets.search),
          _webNavItem(2, AllAssets.bottomIS),
          _webNavItem(3, AllAssets.bottomPE),
        ],
      ),
    );
  }

  Widget _webNavItem(int index, String icon) {
    final isActive = currentIndex == index;

    return InkWell(
      onTap: () => _onTap(index),
      borderRadius: BorderRadius.circular(10),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 28),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ImageIcon(
              AssetImage(icon),
              size: 20,
              color: isActive ? linearColor : Colors.grey,
            ),
            const SizedBox(height: 6),
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              height: 2,
              width: isActive ? 22 : 0,
              decoration: BoxDecoration(
                color: linearColor,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ==================================================
  // MOBILE BOTTOM NAVIGATION (UNCHANGED STYLE)
  // ==================================================
  Widget _mobileBottomNav() {
    return Padding(
      padding: EdgeInsets.only(
        left: getWidgetWidth(width: 20),
        right: getWidgetWidth(width: 20),
        bottom: getWidgetHeight(height: 20),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.12),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30),
          child: BottomNavigationBar(
            backgroundColor: Colors.white,
            type: BottomNavigationBarType.fixed,
            currentIndex: currentIndex,
            onTap: _onTap,
            selectedItemColor: linearColor,
            unselectedItemColor: Colors.grey,
            showSelectedLabels: false,
            showUnselectedLabels: false,
            items: const [
              BottomNavigationBarItem(
                icon: ImageIcon(
                  AssetImage(AllAssets.bottomHome),
                  size: 18,
                ),
                label: '',
              ),
              BottomNavigationBarItem(
                icon: ImageIcon(
                  AssetImage(AllAssets.search),
                  size: 18,
                ),
                label: '',
              ),
              BottomNavigationBarItem(
                icon: ImageIcon(
                  AssetImage(AllAssets.bottomIS),
                  size: 20,
                ),
                label: '',
              ),
              BottomNavigationBarItem(
                icon: ImageIcon(
                  AssetImage(AllAssets.bottomPE),
                  size: 20,
                ),
                label: '',
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ==================================================
  // NAVIGATION LOGIC (UNTOUCHED)
  // ==================================================
  void _onTap(int index) {
    stopTimerMainCategory();
    log('BottomNavigationBar tapped: $index');

    if (index == 0) {
      currentIndex = index;
      kIsWeb
          ? Get.rootDelegate.offNamed(AppRoutes.home)
          : Get.offAndToNamed(AppRoutes.home);
    } else if (index == 1) {
      kIsWeb
          ? Get.rootDelegate.toNamed(AppRoutes.searchScreen)
          : Get.toNamed(AppRoutes.searchScreen);
    } else if (index == 2) {
      currentIndex = index;
      kIsWeb
          ? Get.rootDelegate.toNamed(AppRoutes.simulation)
          : Get.toNamed(AppRoutes.simulation);
    } else if (index == 3) {
      currentIndex = index;
      kIsWeb
          ? Get.rootDelegate.toNamed(AppRoutes.languageLab)
          : Get.toNamed(AppRoutes.languageLab);
    }

    setState(() {});
  }
}
