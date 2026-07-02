import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hotelmanagementapp/controller/home_controller.dart';
import 'package:hotelmanagementapp/public/all_asset.dart';
import 'package:hotelmanagementapp/public/common_function.dart';
import 'package:hotelmanagementapp/public/constant.dart' show linearColor;
import 'package:hotelmanagementapp/route/route_name.dart';
import 'package:hotelmanagementapp/view/home.dart';

class WebTopNavigation extends StatelessWidget {
  const WebTopNavigation({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      margin: const EdgeInsets.symmetric(horizontal: 28),
      padding: const EdgeInsets.symmetric(horizontal: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFEDEDED)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _item(0, AllAssets.bottomHome, "Home"),
          _divider(),
          _item(1, AllAssets.search, "Search"),
          _divider(),
          _item(2, AllAssets.bottomIS, "Simulations"),
          _divider(),
          _item(3, AllAssets.bottomPE, "Language"),
        ],
      ),
    );
  }

  Widget _item(int index, String icon, String label) {
    final active = currentIndex == index;

    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: () {
        currentIndex = index;
        if (index == 0) {
          Get.rootDelegate.offNamed(AppRoutes.home);
        } else if (index == 1) {
          Get.rootDelegate.toNamed(AppRoutes.searchScreen);
        } else if (index == 2) {
          Get.rootDelegate.toNamed(AppRoutes.simulation);
        } else if (index == 3) {
          setPathTitle('language-lab');
          Get.rootDelegate.toNamed(AppRoutes.languageLab);
        }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14),
        child: Row(
          children: [
            ImageIcon(
              AssetImage(icon),
              size: 18,
              color: active ? linearColor : Colors.grey,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: active ? linearColor : Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _divider() {
    return Container(
      height: 20,
      width: 1,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      color: const Color(0xFFEDEDED),
    );
  }
}

/// =======================================================
/// WEB HEADER WITH CONDITIONAL LOGIC
/// =======================================================
class WebHeaderWithNav extends StatelessWidget {
  final String title;
  Function? onBack;
  Function? onDrawer;

  WebHeaderWithNav({
    super.key,
    required this.title,
    this.onBack,
    this.onDrawer,
  });

  bool get isHome => title.toLowerCase() == "home";

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64,
      padding: const EdgeInsets.symmetric(horizontal: 28),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: Color(0xFFEDEDED)),
        ),
      ),
      child: Row(
        children: [
          /// ---------------- LEFT SECTION ----------------
          if (!isHome) ...[
            IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: onBack != null
                  ? () => onBack!()
                  : () {
                      // Get.find<HomeController>().loadRecentHistory();
                      Get.rootDelegate.offNamed(AppRoutes.home);
                    },
            ),
            const SizedBox(width: 8),
            Text(
              title,
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ] else ...[
            Image.asset(
              AllAssets.splashLogo,
              height: 56,
            ),
          ],

          const Spacer(),

          /// ---------------- NAV ITEMS ----------------
          _navItem(
            label: "Home",
            icon: AllAssets.bottomHome,
            index: 0,
            route: AppRoutes.home,
          ),
          _navItem(
            label: "Search",
            icon: AllAssets.search,
            index: 1,
            route: AppRoutes.searchScreen,
          ),
          _navItem(
            label: "Simulations",
            icon: AllAssets.bottomIS,
            index: 2,
            route: AppRoutes.simulation,
          ),
          _navItem(
            label: "Language",
            icon: AllAssets.bottomPE,
            index: 3,
            route: AppRoutes.languageLab,
          ),
          if (isHome)
            IconButton(
              icon: const Icon(Icons.menu),
              onPressed: onDrawer != null ? () => onDrawer!() : null,
            ),
        ],
      ),
    );
  }

  Widget _navItem({
    required String label,
    required String icon,
    required int index,
    required String route,
  }) {
    final active = currentIndex == index;

    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: () {
        if (index == 3) {
          setPathTitle('language-lab');
        }
        currentIndex = index;
        Get.rootDelegate.offNamed(route);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14),
        child: Row(
          children: [
            ImageIcon(
              AssetImage(icon),
              size: 18,
              color: active ? linearColor : Colors.grey,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: active ? linearColor : Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
