import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hotelmanagementapp/controller/home_controller.dart';
import 'package:hotelmanagementapp/public/all_asset.dart';
import 'package:hotelmanagementapp/public/api.dart';
import 'package:hotelmanagementapp/public/common_function.dart';
import 'package:hotelmanagementapp/public/constant.dart';
import 'package:hotelmanagementapp/route/route_name.dart';
import 'package:hotelmanagementapp/utility/custome_bottom_navigation.dart';
import 'package:hotelmanagementapp/utility/in_aapp_web.dart';
import 'package:hotelmanagementapp/view/ar_simulation.dart';
import 'package:hotelmanagementapp/view/font_office.dart';
import 'package:hotelmanagementapp/view/interactive_simulations.dart';
import 'package:hotelmanagementapp/view/language_lab.dart';
import 'package:hotelmanagementapp/view/login.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

int currentIndex = 0;

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 3, vsync: this);
    super.initState();
  }

  Future<void> logout(BuildContext context) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white, // White background
        title: Text(
          'Logout',
          style: TextStyle(color: Colors.black), // Black title text
        ),
        content: Text(
          'Are you sure you want to logout?',
          style: TextStyle(color: Colors.black), // Black content text
        ),
        actions: [
          TextButton(
            child: Text(
              'Cancel',
              style: TextStyle(color: Colors.black), // Black button text
            ),
            onPressed: () => Navigator.pop(context),
          ),
          TextButton(
            child: Text(
              'Logout',
              style: TextStyle(color: Colors.black), // Black button text
            ),
            onPressed: () async {
              Navigator.pop(context); // Close dialog

              // Firebase SignOut
              await FirebaseAuth.instance.signOut();

              // Clear SharedPreferences
              final prefs = await SharedPreferences.getInstance();
              await prefs.clear();

              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => LoginPage()),
              );
            },
          ),
        ],
      ),
    );
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      endDrawer: Drawer(
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Menu items scrollable
              Expanded(
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    SizedBox(height: getWidgetHeight(height: 60)),
                    ListTile(
                      leading: Icon(Icons.home),
                      title: Text('Home'),
                      onTap: () => Navigator.pop(context),
                    ),
                    ListTile(
                      leading: Icon(Icons.settings),
                      title: Text('Settings'),
                      onTap: () => Navigator.pop(context),
                    ),
                    ListTile(
                      leading: Icon(Icons.logout),
                      title: Text('Logout'),
                      onTap: () {
                        Navigator.pop(context);
                        Future.delayed(
                            Duration(milliseconds: 250), () => logout(context));
                      },
                    ),
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextButton(
                  onPressed: () async {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => InAppWebViewPage(
                                  url: ApiRoutes.privacyPolicy,
                                )));
                  },
                  child: Text(
                    "Privacy & Policy",
                    style: GoogleFonts.inter(
                      height: 0.5,
                      fontWeight: FontWeight.w400,
                      fontSize: 12,
                      color: lightWhite,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      extendBody: true,
      bottomNavigationBar: CustomeBottomNavigation(),
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: getWidgetHeight(height: 50)),
          Padding(
            padding:
                EdgeInsets.symmetric(horizontal: getWidgetWidth(width: 20)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.transparent,
                      radius: 25,
                      child: ClipOval(
                        child: Image.asset(
                          "assets/appIcon.png",
                          fit: BoxFit.contain,
                          width: getWidgetWidth(width: 48),
                          height: getWidgetHeight(height: 48),
                        ),
                      ),
                    ),
                    SizedBox(width: getWidgetWidth(width: 5.92)),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: getWidgetHeight(height: 8),
                        ),
                        Text(
                          "Profluent",
                          style: GoogleFonts.inter(
                              height: 0.5,
                              fontWeight: FontWeight.w400,
                              fontSize: 12,
                              color: lightWhite),
                        ),
                        Text(
                          "Hotelier",
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.w700,
                            fontSize: 18,
                          ),
                        )
                      ],
                    ),
                  ],
                ),
                Builder(builder: (context) {
                  return InkWell(
                    onTap: () {
                      _scaffoldKey.currentState?.openEndDrawer();
                    },
                    child: Container(
                      height: getWidgetHeight(height: 40),
                      width: getWidgetWidth(width: 40),
                      padding: EdgeInsets.symmetric(
                          horizontal: getWidgetWidth(width: 8),
                          vertical: getWidgetHeight(height: 10)),
                      decoration: BoxDecoration(
                          color: const Color(0xFFF7F8F8),
                          borderRadius: BorderRadius.circular(8)),
                      child: Image.asset(
                        AllAssets.drawerIcon,
                        color: Colors.black,
                      ),
                    ),
                  );
                })
              ],
            ),
          ),
          SizedBox(height: getWidgetHeight(height: 10)),
          GetBuilder<HomeController>(builder: (controller) {
            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Padding(
                padding: EdgeInsets.only(right: getWidgetWidth(width: 20)),
                child: Row(
                  children: List.generate(4, (index) {
                    return Padding(
                      padding: EdgeInsets.only(
                          left: getWidgetWidth(width: 20),
                          bottom: getWidgetHeight(height: 20),
                          top: getWidgetHeight(height: 10)),
                      child: InkWell(
                        onTap: () {
                          timestampIndex = index;
                          mianCategoryTitile = controller.cardNames[index];
                          Get.toNamed(AppRoutes.frontOffice, arguments: {
                            'title': controller.cardNames[index] ==
                                    "Front Office\nManagement"
                                ? "Front Office Management"
                                : controller.cardNames[index],
                            'image': controller.cardImages[index],
                            'index': index,
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                offset: const Offset(0, 4),
                                blurRadius: 10,
                              ),
                            ],
                          ),
                          child:
                              GetBuilder<HomeController>(builder: (controller) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SvgPicture.asset(controller.cardImages[index]),
                                SizedBox(height: getWidgetHeight(height: 8)),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: getWidgetWidth(width: 10)),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Hotel Management",
                                        style: TextStyle(
                                            color: lightWhite, fontSize: 10),
                                      ),
                                      SizedBox(
                                          height: getWidgetHeight(height: 8)),
                                      SizedBox(
                                        height: getWidgetHeight(height: 60),
                                        child: Text(
                                          controller.cardNames[index],
                                          textAlign: TextAlign.start,
                                          overflow: TextOverflow.fade,
                                          style: GoogleFonts.inter(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                          height: getWidgetHeight(height: 15)),
                                      Text(
                                        "View Details",
                                        textAlign: TextAlign.start,
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: linearColor,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      SizedBox(
                                          height: getWidgetHeight(height: 10))
                                    ],
                                  ),
                                )
                              ],
                            );
                          }),
                        ),
                      ),
                    );
                  }),
                ),
              ),
            );
          }),
          Container(
            padding:
                EdgeInsets.symmetric(horizontal: getWidgetWidth(width: 20)),
            child: TabBar(
              controller: _tabController,
              labelPadding: EdgeInsets.zero,
              indicatorPadding: EdgeInsets.zero,
              labelColor: darkBlack,
              unselectedLabelColor: lightWhite,
              indicatorColor: linearColor,
              indicatorSize: TabBarIndicatorSize.tab,
              tabs: const [
                Tab(text: 'Smart Shots'),
                Tab(text: 'Recent History'),
                Tab(text: 'To Do'),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              physics: const BouncingScrollPhysics(),
              children: [
                GetBuilder<HomeController>(builder: (controller) {
                  return ListView.builder(
                    // shrinkWrap: true,
                    itemCount: 3,
                    padding: EdgeInsets.only(
                        top: getWidgetHeight(height: 10),
                        bottom: getWidgetHeight(height: 100)),
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: getWidgetWidth(width: 20),
                          vertical: getWidgetHeight(height: 6),
                        ),
                        child: GestureDetector(
                          onTapDown: (TapDownDetails details) {
                            final tapPosition = details.globalPosition;
                            index == 0
                                ? Get.toNamed(AppRoutes.simulation)
                                : controller.showPopupAtTap(tapPosition);
                          },
                          // onTap: () {
                          //   mianCategoryTitile = controller.smartShorts[index];
                          //   timestampIndex = -1;
                          //   index == 0
                          //       ? Get.toNamed(AppRoutes.simulation)
                          //       : index == 1
                          //           ? openDialog(context)
                          //           : openDialog(context);

                          //   //      index == 0
                          //   // ? Get.toNamed(AppRoutes.simulation)
                          //   // : index == 1
                          //   //     ? Get.toNamed(AppRoutes.languageLab)
                          //   //     : Navigator.push(
                          //   //         context,
                          //   //         MaterialPageRoute(
                          //   //           builder: (context) =>
                          //   //               InteractiveSimulatiion(
                          //   //                   title: controller
                          //   //                       .smartShorts[index]),
                          //   //         ),
                          //   //       );
                          // },
                          child: Container(
                            height: getWidgetHeight(height: 75),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  offset: const Offset(0, 4),
                                  blurRadius: 10,
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                SizedBox(width: getWidgetWidth(width: 4)),
                                Container(
                                  width: getWidgetWidth(width: 55),
                                  height: getWidgetHeight(height: 68),
                                  decoration: BoxDecoration(
                                    color: linearColor,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: Stack(
                                      fit: StackFit.expand,
                                      children: [
                                        SvgPicture.asset(
                                          "assets/Square Vector.svg",
                                          fit: BoxFit.cover,
                                        ),
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                            vertical: index == 1
                                                ? 0
                                                : getWidgetHeight(height: 22),
                                            horizontal: index == 1
                                                ? 0
                                                : getWidgetWidth(width: 16),
                                          ),
                                          child: index == 0
                                              ? Image.asset(
                                                  AllAssets
                                                      .interactiveSimulations,
                                                  color: Colors.white,
                                                )
                                              : index == 1
                                                  ? const Icon(
                                                      Icons.mic,
                                                      color: Colors.white,
                                                      size: 28,
                                                    )
                                                  : Image.asset(
                                                      "assets/language_lab.png"),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(width: getWidgetWidth(width: 12)),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      controller.smartShorts[index],
                                      textAlign: TextAlign.start,
                                      style: GoogleFonts.inter(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16,
                                      ),
                                    ),
                                    Text(
                                      "View Schedule, Progress Report...",
                                      style: TextStyle(
                                          color: lightWhite, fontSize: 12),
                                    ),
                                  ],
                                ),
                                const Spacer(),
                                SvgPicture.asset("assets/threedots.svg"),
                                SizedBox(width: getWidgetWidth(width: 16)),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }),
                Center(child: Text("Recent History")),
                Center(child: Text("To Do")),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
