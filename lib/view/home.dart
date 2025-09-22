import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_launcher_icons/xml_templates.dart';
// import 'package:flutter_inappwebview/flutter_inappwebview.dart';

import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hotelmanagementapp/controller/home_controller.dart';
import 'package:hotelmanagementapp/model/category_model.dart';
import 'package:hotelmanagementapp/model/grammer_lab_model.dart';
import 'package:hotelmanagementapp/model/sentence_model.dart';
import 'package:hotelmanagementapp/model/sound_model.dart';
import 'package:hotelmanagementapp/public/all_asset.dart';
import 'package:hotelmanagementapp/public/api.dart';
import 'package:hotelmanagementapp/public/common_function.dart';
import 'package:hotelmanagementapp/public/constant.dart';
import 'package:hotelmanagementapp/public/keys.dart';
import 'package:hotelmanagementapp/public/update_checker.dart';
import 'package:hotelmanagementapp/route/route_name.dart';
import 'package:hotelmanagementapp/utility/custome_bottom_navigation.dart';
import 'package:hotelmanagementapp/utility/in_aapp_web.dart';
import 'package:hotelmanagementapp/utility/web_view_page.dart';
import 'package:hotelmanagementapp/view/ar_simulation.dart';
import 'package:hotelmanagementapp/view/font_office.dart';
import 'package:hotelmanagementapp/view/grammer_lab_sub.dart';
import 'package:hotelmanagementapp/view/interactive_simulations.dart';
import 'package:hotelmanagementapp/view/language_lab.dart';
import 'package:hotelmanagementapp/view/login.dart';
import 'package:hotelmanagementapp/view/pdf.dart';
import 'package:hotelmanagementapp/view/profile_screen.dart';
import 'package:hotelmanagementapp/view/university_lab.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

int currentIndex = 0;

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  late TabController _tabController;
  HomeController historyController = Get.put(HomeController());
  String? appVersion;

  @override
  void initState() {
    super.initState();
    _loadAppVersion();
    UpdateChecker.checkForUpdate(context);
    WidgetsBinding.instance.addObserver(this);
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _tabController.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // if (state == AppLifecycleState.resumed) {
    // This is like onResume
    historyController.loadRecentHistory();
    // }
  }

  Future<void> _loadAppVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      appVersion = packageInfo.version;
    });
  }

  exitPop() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white, // White background
        title: Text(
          'Exit',
          style: TextStyle(color: Colors.black), // Black title text
        ),
        content: Text(
          'Are you sure you want to Exit?',
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
              'Exit',
              style: TextStyle(color: Colors.black), // Black button text
            ),
            onPressed: () async {
              Navigator.pop(context);
              Navigator.pop(context); // Close dialog
            },
          ),
        ],
      ),
    );
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    double isKwidth = MediaQuery.of(context).size.width;
    print("width is printing  ${isKwidth}");
    Widget _tile(
        {required Widget icon, required String menu, Function()? onTap}) {
      return ListTile(
        onTap: onTap,
        leading: icon,
        //  ImageIcon(
        //   icon,
        // color: Colors.grey.shade400,
        // size: 20,
        // ),
        title: Text(menu,
            style: TextStyle(
              fontFamily: Keys.fontFamily,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade400,
              fontSize: 15,
            )),
        // onTap: _logout,
      );
    }

    return PopScope(
      onPopInvoked: (didPop) async {
        await exitPop();
      },
      child: Scaffold(
        key: _scaffoldKey,
        endDrawer: SafeArea(
          child: GetBuilder<HomeController>(builder: (controller) {
            return Drawer(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Menu items scrollable
                  Expanded(
                    child: ListView(
                      padding: EdgeInsets.zero,
                      children: [
                        SizedBox(height: getWidgetHeight(height: 10)),
                        ListTile(
                          title: Text("Welcome",
                              style: TextStyle(
                                fontFamily: Keys.fontFamily,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey,
                                fontSize: 12,
                              )),
                          subtitle: Text(controller.userName,
                              style: TextStyle(
                                fontFamily: Keys.fontFamily,
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                                fontSize: 30,
                              )),
                        ),
                        _tile(
                            icon: Icon(
                              Icons.person,
                              color: Colors.grey.shade400,
                              size: 20,
                            ),
                            menu: "Profile",
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ProfileScreen()));
                            }),
                        _tile(
                            icon: Image.asset(
                              "assets/images/presentation_icon.png",
                              color: Colors.grey.shade400,
                              height: 18,
                              width: 20,
                            ) /* Icon(
                          Icons.account_box_outlined,
                          color: Colors.grey.shade400,
                          size: 20,
                        )*/
                            ,
                            menu: "About Profluent Hotelier",
                            onTap: () {
                              // Navigator.push(
                              //     context,
                              //     MaterialPageRoute(
                              //         builder: (context) => InAppWebViewPage(
                              //               url: aboutLiteLearningLink,
                              //             )));
                            }),
                        _tile(
                            icon: Image.asset(
                              "assets/images/feedback.png",
                              color: Colors.grey.shade400,
                              height: 18,
                              width: 20,
                            ),
                            /* icon: Icon(
                          Icons.home,
                          color: Colors.grey.shade400,
                          size: 20,
                        ),*/
                            menu: "Share your feedback with us",
                            onTap: () {
                              // Navigator.push(
                              //     context,
                              //     MaterialPageRoute(
                              //         builder: (context) => InAppWebViewPage(
                              //               url: helpLink,
                              //             )));
                            }),
                        _tile(
                            icon: Icon(
                              Icons.star,
                              color: Colors.grey.shade400,
                              size: 20,
                            ),
                            menu: "Rate this app",
                            onTap: () {
                              if (Platform.isAndroid || Platform.isIOS) {
                                const appId = "com.profluent.hotelier.app";
                                final url =
                                    Uri.parse("market://details?id=$appId");
                                launchUrl(
                                  url,
                                  mode: LaunchMode.externalApplication,
                                );
                              }
                            }),
                        /*_tile(
                        icon: SvgPicture.asset(
                          'assets/images/about.svg',
                          colorFilter: ColorFilter.mode(
                            Colors.grey.shade400,
                            BlendMode.srcIn,
                          ),
                          height: 20,
                        ),
                        menu: "Help",
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => InAppWebViewPage(
                                        url: helpLink,
                                      )));
                        }),*/
                        _tile(
                            icon: Image.asset(
                              "assets/images/user_guide_icon.png",
                              color: Colors.grey.shade400,
                              height: 18,
                              width: 20,
                            ),
                            /*SvgPicture.asset(
                          'assets/images/dashboard.svg',
                          colorFilter: ColorFilter.mode(
                            Colors.grey.shade400,
                            BlendMode.srcIn,
                          ),
                          height: 20,
                        ),*/
                            menu: "User Guide",
                            onTap: () {
                              // Navigator.push(
                              //     context,
                              //     MaterialPageRoute(
                              //         builder: (context) => InAppWebViewPage(
                              //               url: overViewLink,
                              //             )));
                            }),
                        _tile(
                            icon: Icon(
                              Icons.copyright_rounded,
                              color: Colors.grey.shade400,
                              size: 20,
                            ),
                            menu: "Copyright",
                            onTap: () {
                              // Navigator.push(
                              //     context,
                              //     MaterialPageRoute(
                              //         builder: (context) => InAppWebViewPage(
                              //               url: copyRightLink,
                              //             )));
                            }),
                        // Spacer(),
                        _tile(
                            icon: Icon(
                              Icons.power_settings_new,
                              color: Colors.grey.shade400,
                              size: 20,
                            ),
                            menu: "Logout",
                            onTap: () {
                              controller.exitPopup(context);
                            }
                            /* onTap: () async {
                          await user.signOut();
                        }*/
                            ),
                      ],
                    ),
                  ),

                  TextButton(
                    onPressed: () async {
                      Get.toNamed(AppRoutes.inAppWebView, arguments: {
                        "url": ApiRoutes.privacyPolicy,
                      });
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
                  Text(
                    "App version $appVersion",
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.w300,
                      height: 0.5,
                      fontSize: 12,
                      color: lightWhite,
                    ),
                  ),
                  SizedBox(
                    height: getWidgetHeight(height: 30),
                  )
                ],
              ),
            );
          }),
        ),
        extendBody: true,
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: Align(
          alignment: Alignment.bottomCenter,
          child: CustomeBottomNavigation(),
        ),
        backgroundColor: Colors.white,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: getWidgetHeight(height: isKwidth > 500 ? 20 : 60)),
            Padding(
              padding:
                  EdgeInsets.symmetric(horizontal: getWidgetWidth(width: 20)),
              child: Row(
                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    height: getWidgetHeight(height: kWidth > 700 ? 40 : 40),
                    width: getWidgetWidth(
                        width: isKwidth > 1204
                            ? 40
                            : (isKwidth > 700 && kWidth < 1204)
                                ? 60
                                : 130),
                    child: CircleAvatar(
                      backgroundColor: Colors.transparent,
                      // radius: 25,
                      child: Image.asset(
                        AllAssets.splashLogo,
                        fit: BoxFit.fitWidth,
                        // width: getWidgetWidth(width: 200),
                        // height: getWidgetHeight(height: 200),
                      ),
                    ),
                  ),
                  Spacer(),
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
                            borderRadius: BorderRadius.circular(16)),
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
            SizedBox(height: getWidgetHeight(height: 5)),
            if (kIsWeb) SizedBox(height: getWidgetHeight(height: 20)),
            GetBuilder<HomeController>(
                init: HomeController(),
                builder: (controller) {
                  return SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Padding(
                      padding: EdgeInsets.only(
                          right: getWidgetWidth(width: 20),
                          left: getWidgetWidth(width: isKwidth > 700 ? 18 : 0)),
                      child: Row(
                        children:
                            List.generate(controller.cardNames.length, (index) {
                          return Padding(
                            padding: EdgeInsets.only(
                                left: getWidgetWidth(
                                    width: isKwidth > 700 ? 5 : 20),
                                bottom: getWidgetHeight(height: 20),
                                top: getWidgetHeight(height: 10)),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              height: getWidgetHeight(height: 300),
                              width: getWidgetWidth(
                                  width: isKwidth > 700 ? 80 : 218),
                              child: InkWell(
                                highlightColor: Colors.transparent,
                                focusColor: Colors.transparent,
                                hoverColor: Colors.transparent,
                                splashColor: Colors.transparent,
                                onTap: () {
                                  timestampIndex = index;
                                  mianCategoryTitile =
                                      controller.cardNames[index];
                                  if (index != 4) {
                                    Get.toNamed(AppRoutes.frontOffice,
                                        arguments: {
                                          'title': controller
                                                      .cardNames[index] ==
                                                  "Front Office\nManagement"
                                              ? "Front Office Management"
                                              : controller.cardNames[index] ==
                                                      "Food & Beverage Service\nManagement"
                                                  ? "Food & Beverage Service Management"
                                                  : controller.cardNames[
                                                              index] ==
                                                          "Accommodation\nManagement - Housekeeping"
                                                      ? "Accommodation Management - Housekeeping"
                                                      : controller
                                                          .cardNames[index],
                                          'image': controller.cardImages[index],
                                          'index': index,
                                        });
                                  } else {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => UniversityLab(
                                          universityModel:
                                              controller.universityModel,
                                        ),
                                      ),
                                    );
                                  }
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
                                  child: GetBuilder<HomeController>(
                                      builder: (ctr) {
                                    return Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          width: getWidgetWidth(width: 235),
                                          height: getWidgetHeight(height: 160),
                                          child: index == 4
                                              ? SvgPicture.network(
                                                  controller.cardImages[index],
                                                  placeholderBuilder: (context) =>
                                                      const CircularProgressIndicator(),
                                                )
                                              : SvgPicture.asset(
                                                  controller.cardImages[index]),
                                        ),
                                        SizedBox(
                                            height: getWidgetHeight(height: 8)),
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: getWidgetWidth(
                                                  width:
                                                      isKwidth > 700 ? 3 : 10)),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                index == 4
                                                    ? ""
                                                    : "Hotel Management",
                                                style: TextStyle(
                                                    color: lightWhite,
                                                    fontSize: kText.scale(
                                                        isKwidth > 700
                                                            ? 12
                                                            : 10)),
                                              ),
                                              SizedBox(
                                                  height: getWidgetHeight(
                                                      height: 8)),
                                              SizedBox(
                                                height:
                                                    getWidgetHeight(height: 78),
                                                child: Text(
                                                  controller.cardNames[index],
                                                  textAlign: TextAlign.start,
                                                  overflow: TextOverflow.fade,
                                                  style: GoogleFonts.inter(
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: kText.scale(
                                                        isKwidth > 700
                                                            ? 18
                                                            : 16),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                  height: getWidgetHeight(
                                                      height: 5)),
                                              SizedBox(
                                                height:
                                                    getWidgetHeight(height: 15),
                                                child: Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                      "View Details",
                                                      textAlign:
                                                          TextAlign.start,
                                                      style: TextStyle(
                                                        fontSize:
                                                            kText.scale(12),
                                                        color: linearColor,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                    ),
                                                    // LinearPercentIndicator(
                                                    //   center: Text(
                                                    //     "20%",
                                                    //     style: TextStyle(
                                                    //         color: Colors.white,
                                                    //         fontSize: kText
                                                    //             .scale(10)),
                                                    //   ),
                                                    //   barRadius:
                                                    //       Radius.circular(6),
                                                    //   width: getWidgetWidth(
                                                    //       width: 150),
                                                    //   lineHeight:
                                                    //       getWidgetHeight(
                                                    //           height: 14),
                                                    //   percent: 0.2,
                                                    //   backgroundColor:
                                                    //       Colors.grey,
                                                    //   progressColor:
                                                    //       linearColor,
                                                    // ),
                                                  ],
                                                ),
                                              ),
                                              SizedBox(
                                                  height: getWidgetHeight(
                                                      height: 10))
                                            ],
                                          ),
                                        ),
                                      ],
                                    );
                                  }),
                                ),
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
              child: GetBuilder<HomeController>(builder: (homeController) {
                return TabBarView(
                  controller: _tabController,
                  physics: const BouncingScrollPhysics(),
                  children: [
                    GetBuilder<HomeController>(builder: (controller) {
                      return ListView.builder(
                        shrinkWrap: true,
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
                                // timestampIndex = index;
                                final tapPosition = details.globalPosition;
                                index == 0
                                    ?
                                    //  accessLinks.toLowerCase().contains(
                                    //         "simulation".toLowerCase())
                                    //     ?
                                    Get.toNamed(AppRoutes.simulation)
                                    //     :
                                    // controller.showPopupAtTap(tapPosition)
                                    : index == 1
                                        ? Get.toNamed(AppRoutes.languageLab)
                                        : index == 2
                                            ?
                                            //  Navigator.push(
                                            //     context,
                                            //     MaterialPageRoute(
                                            //         builder: (context) =>
                                            //             PDFPreviewWithFirstPage()))
                                            Get.toNamed(
                                                AppRoutes.contentLibrary)
                                            : controller
                                                .showPopupAtTap(tapPosition);
                                // controller.showPopupAtTap(tapPosition);
                                // for playstore
                                // index == 0
                                //     ? Get.toNamed(AppRoutes.simulation)
                                //     : controller.showPopupAtTap(tapPosition);
                              },
                              child: Container(
                                height: getWidgetHeight(
                                    height: isKwidth > 700 ? 100 : 75),
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
                                      width: getWidgetWidth(
                                          width: isKwidth > 700 ? 25 : 55),
                                      height: getWidgetHeight(
                                          height: isKwidth > 700 ? 80 : 68),
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
                                                    : getWidgetHeight(
                                                        height: isKwidth > 700
                                                            ? 15
                                                            : 22),
                                                horizontal: index == 1
                                                    ? 0
                                                    : getWidgetWidth(
                                                        width: isKwidth > 700
                                                            ? 8
                                                            : 16),
                                              ),
                                              child: index == 0
                                                  ? Image.asset(
                                                      AllAssets
                                                          .interactiveSimulations,
                                                      color: Colors.white,
                                                    )
                                                  : index == 1
                                                      ? Icon(
                                                          Icons.mic,
                                                          color: Colors.white,
                                                          size: isKwidth > 700
                                                              ? 45
                                                              : 28,
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          controller.smartShorts[index],
                                          textAlign: TextAlign.start,
                                          style: GoogleFonts.inter(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 16,
                                          ),
                                        ),
                                        SizedBox(
                                          width: getWidgetWidth(width: 240),
                                          child: Text(
                                            maxLines: 2,
                                            index == 0
                                                ? "250+ Simulations - Experiential learning for handling challenging situations & interviews."
                                                : index == 1
                                                    ? "English & French Pronunciation, Sentence Lab, Grammar, and Phonetic Sounds. "
                                                    : "Excellent collection of content for casual and enjoyable micro-learning",
                                            style: TextStyle(
                                              overflow: TextOverflow.ellipsis,
                                              color: lightWhite,
                                              fontSize: kText.scale(10),
                                            ),
                                          ),
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
                    homeController.recentHistoryLoaded
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CircularProgressIndicator(
                                color: linearColor,
                              ),
                              SizedBox(
                                height: getWidgetHeight(height: 75),
                              )
                            ],
                          )
                        : homeController.homeRecentHistory.isEmpty
                            ? Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text("No recent history found!"),
                                  SizedBox(
                                    height: getWidgetHeight(height: 75),
                                  )
                                ],
                              )
                            : ListView.builder(
                                shrinkWrap: true,
                                padding: EdgeInsets.only(
                                    top: getWidgetHeight(height: 10),
                                    bottom: getWidgetHeight(height: 100)),
                                itemCount:
                                    homeController.homeRecentHistory.length,
                                itemBuilder: (context, index) {
                                  final item =
                                      homeController.homeRecentHistory[index];

                                  return Padding(
                                    padding: EdgeInsets.symmetric(
                                      // vertical: getWidgetHeight(height: 8),
                                      horizontal: getWidgetWidth(width: 12),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        // collectionName
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                            horizontal:
                                                getWidgetWidth(width: 12),
                                          ),
                                          child: Text(
                                            item['path'] ?? '',
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: kText.scale(9),
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),

                                        SizedBox(
                                            height: getWidgetHeight(height: 6)),

                                        // category
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                            horizontal:
                                                getWidgetWidth(width: 12),
                                          ),
                                          child: Text(
                                            item['category'] ?? '',
                                            style: TextStyle(
                                              fontSize: kText.scale(13),
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),

                                        SizedBox(
                                            height: getWidgetHeight(height: 6)),

                                        // keyword (or path or any identifier)
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                            horizontal:
                                                getWidgetWidth(width: 12),
                                            vertical:
                                                getWidgetHeight(height: 6),
                                          ),
                                          child: InkWell(
                                            onTap: () async {
                                              if (item['section'] ==
                                                  'Sound Lab') {
                                                SoundSubcategory?
                                                    soundSubcategory =
                                                    SoundSubcategory.fromJson(
                                                        Map<String,
                                                                dynamic>.from(
                                                            item['soundSub']));

                                                Get.toNamed(AppRoutes.soundPage,
                                                    arguments: {
                                                      "title": item['category'],
                                                      "soundModel":
                                                          soundSubcategory
                                                    });
                                              } else if (item['section'] ==
                                                  'Grammer Lab') {
                                                GrammarDoc? grammerDocs =
                                                    GrammarDoc.fromJson(Map<
                                                            String,
                                                            dynamic>.from(
                                                        item['grammarDocs']));

                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            GrammerLabSub(
                                                              title: item[
                                                                  'category'],
                                                              doc: grammerDocs,
                                                            )));
                                              } else if (item['section'] ==
                                                  'Sentence Lab') {
                                                final subCategories = (item[
                                                            'subCategories']
                                                        as List)
                                                    .map((e) => SubCategoryModel
                                                        .fromJson(Map<String,
                                                            dynamic>.from(e)))
                                                    .toList();
                                                Get.toNamed(
                                                  AppRoutes.sentenceLabSub,
                                                  arguments: {
                                                    "title": item['category'],
                                                    "CategoryModel":
                                                        subCategories,
                                                  },
                                                );
                                              } else if (item['section'] ==
                                                  'proLab') {
                                                log("proLab tapped");
                                                Get.toNamed(
                                                    AppRoutes
                                                        .pronunciationLabSub,
                                                    arguments: {
                                                      'title': item['category'],
                                                      'subcategories':
                                                          <SubcategoryPro>[],
                                                    });
                                              } else {
                                                if (kIsWeb) {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          WebContentPage(
                                                              title: item[
                                                                  'category'],
                                                              url:
                                                                  item['link']),
                                                    ),
                                                  );
                                                } else {
                                                  Get.toNamed(
                                                      AppRoutes.inAppWebView,
                                                      arguments: {
                                                        "isSimulation":
                                                            item['section'] ==
                                                                    'simulation'
                                                                ? true
                                                                : false,
                                                        "url": item['link'],
                                                      });
                                                }
                                              }
                                            },
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Flexible(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        item['section'] ?? '',
                                                        style: TextStyle(
                                                          fontSize:
                                                              kText.scale(12),
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          color:
                                                              Colors.grey[700],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Icon(
                                                  Icons
                                                      .arrow_forward_ios_outlined,
                                                  size: 16,
                                                  color: Colors.black,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),

                                        const Divider(
                                            color: Color.fromARGB(
                                                255, 248, 248, 248)),
                                      ],
                                    ),
                                  );
                                },
                              ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Learning Assignments Coming Soon!"),
                        SizedBox(
                          height: getWidgetHeight(height: 75),
                        )
                      ],
                    ),
                  ],
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
