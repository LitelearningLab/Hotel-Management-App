import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hotelmanagementapp/public/all_asset.dart';
import 'package:hotelmanagementapp/public/common_function.dart';
import 'package:hotelmanagementapp/public/constant.dart';
import 'package:hotelmanagementapp/route/route_name.dart';
import 'package:hotelmanagementapp/view/home.dart';
import 'package:hotelmanagementapp/view/search_screen.dart';

class CustomeBottomNavigation extends StatefulWidget {
  const CustomeBottomNavigation({
    super.key,
  });

  @override
  State<CustomeBottomNavigation> createState() =>
      _CustomeBottomNavigationState();
}

class _CustomeBottomNavigationState extends State<CustomeBottomNavigation> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
          left: getWidgetWidth(width: 20),
          right: getWidgetWidth(width: 20),
          bottom: getWidgetHeight(height: 20)),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(kIsWeb ? 0.5 : 0.1),
              blurRadius: 15,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30),
          child: BottomNavigationBar(
            backgroundColor: Colors.white,
            type: BottomNavigationBarType.fixed,
            currentIndex: currentIndex,
            onTap: (index) {
              stopTimerMainCategory();
              log('BottomNavigationBar tapped: $index');
              if (index == 0) {
                currentIndex = index;
                kIsWeb
                    ? Get.rootDelegate.offNamed(AppRoutes.home)
                    : Get.offAndToNamed(AppRoutes.home);
                // Navigator.of(context).pushAndRemoveUntil(
                //   MaterialPageRoute(builder: (context) => const Home()),
                //   (Route<dynamic> route) => false,
                // );
              } else if (index == 1) {
                kIsWeb
                    ? Get.rootDelegate.toNamed(AppRoutes.searchScreen)
                    : Get.toNamed(AppRoutes.searchScreen);
                // currentIndex = 0;
                // openDialog(context);
                // ScaffoldMessenger.of(context).showSnackBar(
                //   const SnackBar(content: Text("Work in progress")),
                // );
              } else if (index == 2) {
                kIsWeb
                    ? Get.rootDelegate.toNamed(AppRoutes.simulation)
                    : Get.toNamed(AppRoutes.simulation);
                currentIndex = index;
              } else if (index == 3) {
                kIsWeb
                    ? Get.rootDelegate.toNamed(AppRoutes.languageLab)
                    : Get.toNamed(AppRoutes.languageLab);
                currentIndex = index;
              }

              setState(() {});
            },
            selectedItemColor: linearColor, // Your linearColor highlight
            unselectedItemColor: Colors.grey,
            showSelectedLabels: false,
            showUnselectedLabels: false,
            items: const [
              BottomNavigationBarItem(
                  icon: ImageIcon(
                    AssetImage(AllAssets.bottomHome),
                    size: 18,
                  ),
                  label: ''),
              // BottomNavigationBarItem(icon: Icon(Icons.home), label: ''),
              BottomNavigationBarItem(
                  icon: ImageIcon(
                    AssetImage(AllAssets.search),
                    size: 18,
                  ),
                  label: ''),
              BottomNavigationBarItem(
                  icon: ImageIcon(
                    AssetImage(AllAssets.bottomIS),
                    size: 20,
                  ),
                  label: ''),
              BottomNavigationBarItem(
                  icon: ImageIcon(
                    AssetImage(AllAssets.bottomPE),
                    size: 20,
                  ),
                  label: ''),
            ],
          ),
        ),
      ),
    );
  }
}
