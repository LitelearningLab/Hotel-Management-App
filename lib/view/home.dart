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
import 'package:get_storage/get_storage.dart';
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
import 'package:hotelmanagementapp/public/size_helpers.dart';
import 'package:hotelmanagementapp/public/update_checker.dart';
import 'package:hotelmanagementapp/route/route_name.dart';
import 'package:hotelmanagementapp/utility/custome_bottom_navigation.dart';
import 'package:hotelmanagementapp/utility/in_aapp_web.dart';
import 'package:hotelmanagementapp/utility/web_view_page.dart';
import 'package:hotelmanagementapp/view/ar_simulation.dart';
import 'package:hotelmanagementapp/view/feedback_form_page.dart';
import 'package:hotelmanagementapp/view/font_office.dart';
import 'package:hotelmanagementapp/view/grammer_lab_sub.dart';
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
    currentIndex = 0;
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
    if (Platform.isIOS) {
      setState(() {
        appVersion = "1.0.0";
      });
    } else {
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      setState(() {
        appVersion = packageInfo.version;
      });
    }
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

  // Future<void> uploadFeedbackForm() async {
  //   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  //   final feedbackRef = _firestore.collection('feedbackform').doc();

  //   final List<Map<String, dynamic>> sections = [
  //     {
  //       "order": 1,
  //       "title": "Industry Fundamentals",
  //       "questions": [
  //         {
  //           "order": 1,
  //           "text":
  //               "How clearly do the eLearning modules explain hospitality concepts and procedures?",
  //           "options": [
  //             "Extremely clear",
  //             "Very clear",
  //             "Moderately clear",
  //             "Slightly clear",
  //             "Not clear"
  //           ]
  //         },
  //         {
  //           "order": 2,
  //           "text":
  //               "How helpful is the real-time scenario section in understanding how hospitality concepts are applied in actual work situations?",
  //           "options": [
  //             "Extremely helpful",
  //             "Very helpful",
  //             "Moderately helpful",
  //             "Slightly helpful",
  //             "Not helpful"
  //           ]
  //         },
  //         {
  //           "order": 3,
  //           "text":
  //               "How interesting and helpful are the quizzes and image-based quizzes in supporting your learning process?",
  //           "options": [
  //             "Extremely helpful",
  //             "Very helpful",
  //             "Moderately helpful",
  //             "Slightly helpful",
  //             "Not helpful"
  //           ]
  //         },
  //         {
  //           "order": 4,
  //           "text":
  //               "How interesting and helpful are the drag & drop activities in supporting your understanding of the topic?",
  //           "options": [
  //             "Extremely helpful",
  //             "Very helpful",
  //             "Moderately helpful",
  //             "Slightly helpful",
  //             "Not helpful"
  //           ]
  //         },
  //         {
  //           "order": 5,
  //           "text":
  //               "How useful are the case studies in connecting theory with real hotel situations?",
  //           "options": [
  //             "Extremely useful",
  //             "Very useful",
  //             "Moderately useful",
  //             "Slightly useful",
  //             "Not useful"
  //           ]
  //         },
  //         {
  //           "order": 6,
  //           "text":
  //               "How helpful is the Glossary in learning new terms and understanding their real-world use?",
  //           "options": [
  //             "Extremely helpful",
  //             "Very helpful",
  //             "Moderately helpful",
  //             "Slightly helpful",
  //             "Not helpful"
  //           ]
  //         },
  //         {
  //           "order": 7,
  //           "text":
  //               "How helpful is the Audio Book option in understanding the content by listening to the narration of each page?",
  //           "options": [
  //             "Extremely helpful",
  //             "Very helpful",
  //             "Moderately helpful",
  //             "Slightly helpful",
  //             "Not helpful"
  //           ]
  //         },
  //         {
  //           "order": 8,
  //           "text":
  //               "How well does the Pronunciation Lab help you in knowing and practicing the correct pronunciation of key hospitality terms?",
  //           "options": [
  //             "Extremely helpful",
  //             "Very helpful",
  //             "Moderately helpful",
  //             "Slightly helpful",
  //             "Not helpful"
  //           ]
  //         },
  //         {"order": 9, "text": "Suggestions for improvement in this section:"},
  //       ],
  //     },
  //     {
  //       "order": 2,
  //       "title": "Language Lab",
  //       "questions": [
  //         {
  //           "order": 1,
  //           "text":
  //               "How well does the English Pronunciation section help you in knowing and practicing the correct pronunciation?",
  //           "options": [
  //             "Extremely helpful",
  //             "Very helpful",
  //             "Moderately helpful",
  //             "Slightly helpful",
  //             "Not helpful"
  //           ]
  //         },
  //         {
  //           "order": 2,
  //           "text":
  //               "How well does the French Pronunciation section help you in learning and practicing the correct pronunciation of hospitality terms?",
  //           "options": [
  //             "Extremely helpful",
  //             "Very helpful",
  //             "Moderately helpful",
  //             "Slightly helpful",
  //             "Not helpful"
  //           ]
  //         },
  //         {
  //           "order": 3,
  //           "text":
  //               "How effectively does the Sentence Lab help you improve your fluency and confidence in speaking?",
  //           "options": [
  //             "Extremely effective",
  //             "Very effective",
  //             "Moderately effective",
  //             "Slightly effective",
  //             "Not effective"
  //           ]
  //         },
  //         {
  //           "order": 4,
  //           "text":
  //               "How useful is the Grammar Lab in improving your sentence formation and accuracy?",
  //           "options": [
  //             "Extremely effective",
  //             "Very effective",
  //             "Moderately effective",
  //             "Slightly effective",
  //             "Not effective"
  //           ]
  //         },
  //         {"order": 5, "text": "Suggestions for this section:"},
  //       ],
  //     },
  //     {
  //       "order": 3,
  //       "title": "Interactive Simulations",
  //       "questions": [
  //         {
  //           "order": 1,
  //           "text":
  //               "How interesting and helpful are the interactive simulations in understanding how to handle real hotel situations?",
  //           "options": [
  //             "Extremely interesting and helpful",
  //             "Very interesting and helpful",
  //             "Moderately helpful",
  //             "Slightly helpful",
  //             "Not helpful"
  //           ]
  //         },
  //         {
  //           "order": 2,
  //           "text": "Suggestions on scenarios you’d like to see added:"
  //         },
  //       ],
  //     },
  //     {
  //       "order": 4,
  //       "title": "Content Library",
  //       "questions": [
  //         {
  //           "order": 1,
  //           "text":
  //               "How helpful is the Content Library in helping you know more about hospitality topics?",
  //           "options": [
  //             "Extremely helpful",
  //             "Very helpful",
  //             "Moderately helpful",
  //             "Slightly helpful",
  //             "Not helpful"
  //           ]
  //         },
  //         {
  //           "order": 2,
  //           "text":
  //               "What topics/content would you like to see added in this section:"
  //         },
  //       ],
  //     },
  //     {
  //       "order": 5,
  //       "title": "PMS Simulation",
  //       "questions": [
  //         {
  //           "order": 1,
  //           "text":
  //               "How helpful is the PMS simulation in understanding front office procedures and guest handling?",
  //           "options": [
  //             "Extremely helpful",
  //             "Very helpful",
  //             "Moderately helpful",
  //             "Slightly helpful",
  //             "Not helpful"
  //           ]
  //         },
  //         {
  //           "order": 2,
  //           "text":
  //               "How comfortable do you feel performing check-in, billing, and reservation tasks in the PMS simulation?",
  //           "options": [
  //             "Extremely comfortable",
  //             "Very comfortable",
  //             "Moderately comfortable",
  //             "Slightly comfortable",
  //             "Not comfortable"
  //           ]
  //         },
  //         {
  //           "order": 3,
  //           "text": "Any difficulties or suggestions for improvement:"
  //         },
  //       ],
  //     },
  //     {
  //       "order": 6,
  //       "title": "Overall Experience",
  //       "questions": [
  //         {
  //           "order": 1,
  //           "text":
  //               "How satisfied are you with your overall experience using the Profluent Hotelier App?",
  //           "options": [
  //             "Extremely satisfied",
  //             "Very satisfied",
  //             "Moderately satisfied",
  //             "Slightly satisfied",
  //             "Dissatisfied"
  //           ]
  //         },
  //         {
  //           "order": 2,
  //           "text":
  //               "How likely are you to recommend the app to your classmates or friends?",
  //           "options": [
  //             "Definitely",
  //             "Most likely",
  //             "Probably",
  //             "Maybe",
  //             "Unlikely"
  //           ]
  //         },
  //         {"order": 3, "text": "Any other comments or suggestions:"},
  //       ],
  //     },
  //   ];

  //   await feedbackRef.set({
  //     "createdAt": FieldValue.serverTimestamp(),
  //     "sections": sections,
  //   });

  //   print("✅ Feedback form uploaded successfully (ID: ${feedbackRef.id})");
  // }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    double isKwidth = MediaQuery.of(context).size.width;
    double isKheight = MediaQuery.of(context).size.height;
    print("width is printing  ${isKwidth}");
    print("height is printing  ${isKheight}");
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
                            onTap: () async {
                              // uploadFeedbackForm();
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          FeedbackFormScreen()));
                            }),
                        _tile(
                            icon: Icon(
                              Icons.star,
                              color: Colors.grey.shade400,
                              size: 20,
                            ),
                            menu: "Rate this app",
                            onTap: () {
                              controller.openAppStore();
                              // if (Platform.isAndroid || Platform.isIOS) {
                              //   const appId = "com.profluent.hotelier.app";
                              //   final url =
                              //       Uri.parse("market://details?id=$appId");
                              //   launchUrl(
                              //     url,
                              //     mode: LaunchMode.externalApplication,
                              //   );
                              // }
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
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        kIsWeb
                            ? Get.rootDelegate
                                .offNamed(AppRoutes.inAppWebView, arguments: {
                                "url": ApiRoutes.privacyPolicy,
                              })
                            : Get.toNamed(AppRoutes.inAppWebView, arguments: {
                                "url": ApiRoutes.privacyPolicy,
                              });
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
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                  height: getWidgetHeight(height: isKwidth > 500 ? 20 : 60)),
              Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: getWidgetWidth(width: 20)),
                child: Row(
                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      height: kWidth > 700 ? 50 : getWidgetHeight(height: 40),
                      width: isKwidth > 700 ? 150 : getWidgetWidth(width: 130),
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
                      return GestureDetector(
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
                            left:
                                getWidgetWidth(width: isKwidth > 700 ? 18 : 0)),
                        child: Row(
                          children: List.generate(controller.cardNames.length,
                              (index) {
                            return Padding(
                              padding: EdgeInsets.only(
                                  left: getWidgetWidth(
                                      width: isKwidth > 700 ? 5 : 20),
                                  bottom: getWidgetHeight(height: 20),
                                  top: getWidgetHeight(height: 10)),
                              child: AnimatedContainer(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                height: displayWidth(context) > 800
                                    ? 340
                                    : getWidgetHeight(height: 300),
                                width: isKwidth > 800
                                    ? 240
                                    : getWidgetWidth(width: 218),
                                duration: const Duration(milliseconds: 300),
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
                                      debugPrint(
                                          "Card name is and the click is happening or not ${controller.cardNames[index]}");
                                      GetStorage()
                                          .write(AppRoutes.frontOffice, {
                                        'title': controller.cardNames[index] ==
                                                "Front Office\nManagement"
                                            ? "Front Office Management"
                                            : controller.cardNames[index] ==
                                                    "Food & Beverage Service\nManagement"
                                                ? "Food & Beverage Service Management"
                                                : controller.cardNames[index] ==
                                                        "Accommodation\nManagement - Housekeeping"
                                                    ? "Accommodation Management - Housekeeping"
                                                    : controller
                                                        .cardNames[index],
                                        'image': controller.cardImages[index],
                                        'index': index,
                                      });
                                      WidgetsBinding.instance
                                          .addPostFrameCallback((_) {
                                        if (kIsWeb) {
                                          Get.rootDelegate.offNamed(
                                              AppRoutes.frontOffice,
                                              arguments: {
                                                'title': controller
                                                            .cardNames[index] ==
                                                        "Front Office\nManagement"
                                                    ? "Front Office Management"
                                                    : controller.cardNames[
                                                                index] ==
                                                            "Food & Beverage Service\nManagement"
                                                        ? "Food & Beverage Service Management"
                                                        : controller.cardNames[
                                                                    index] ==
                                                                "Accommodation\nManagement - Housekeeping"
                                                            ? "Accommodation Management - Housekeeping"
                                                            : controller
                                                                    .cardNames[
                                                                index],
                                                'image': controller
                                                    .cardImages[index],
                                                'index': index,
                                              });
                                        } else {
                                          Get.toNamed(AppRoutes.frontOffice,
                                              arguments: {
                                                'title': controller
                                                            .cardNames[index] ==
                                                        "Front Office\nManagement"
                                                    ? "Front Office Management"
                                                    : controller.cardNames[
                                                                index] ==
                                                            "Food & Beverage Service\nManagement"
                                                        ? "Food & Beverage Service Management"
                                                        : controller.cardNames[
                                                                    index] ==
                                                                "Accommodation\nManagement - Housekeeping"
                                                            ? "Accommodation Management - Housekeeping"
                                                            : controller
                                                                    .cardNames[
                                                                index],
                                                'image': controller
                                                    .cardImages[index],
                                                'index': index,
                                              });
                                        }
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
                                  child: AnimatedContainer(
                                    duration: Duration(milliseconds: 300),
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
                                          AnimatedContainer(
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(16),
                                            ),
                                            duration:
                                                Duration(microseconds: 300),
                                            width: isKwidth > 800
                                                ? 240
                                                : getWidgetWidth(width: 218),
                                            height: displayWidth(context) > 800
                                                ? 180
                                                : getWidgetHeight(height: 157),
                                            child: ClipRRect(
                                              borderRadius:
                                                  const BorderRadius.only(
                                                topLeft: Radius.circular(16),
                                                topRight: Radius.circular(16),
                                              ),
                                              child: index == 4
                                                  ? Image.network(
                                                      controller
                                                          .cardImages[index],
                                                      fit: BoxFit.fill,
                                                    )
                                                  : SvgPicture.asset(
                                                      controller
                                                          .cardImages[index],
                                                      fit: isKwidth > 800
                                                          ? BoxFit.fill
                                                          : BoxFit.fitWidth,
                                                    ),
                                            ),
                                          ),
                                          SizedBox(
                                              height: isKwidth > 700
                                                  ? 5
                                                  : getWidgetHeight(height: 8)),
                                          Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: isKwidth > 700
                                                    ? 10
                                                    : getWidgetWidth(
                                                        width: 10)),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  index == 4
                                                      ? "Institute Specific Content"
                                                      : "Hotel Management",
                                                  style: TextStyle(
                                                    color: lightWhite,
                                                    fontSize: kText.scale(
                                                      // (isKwidth >
                                                      //         1200) // full desktop
                                                      //     ? 12
                                                      //     : (isKwidth <
                                                      //             500) // mobile
                                                      //         ?
                                                      12
                                                      // :
                                                      // 10
                                                      , // tablet / in-between
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                    height: isKwidth > 700
                                                        ? 6
                                                        : getWidgetHeight(
                                                            height: 8)),
                                                AnimatedContainer(
                                                  duration: Duration(
                                                      milliseconds: 300),
                                                  height: isKwidth > 700
                                                      ? 90
                                                      : getWidgetHeight(
                                                          height: 78),
                                                  child: Text(
                                                    controller.cardNames[index],
                                                    textAlign: TextAlign.start,
                                                    overflow: TextOverflow.fade,
                                                    style: GoogleFonts.inter(
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontSize: kText.scale(
                                                        // (isKwidth > 1200)
                                                        //     ? 16
                                                        //     : (isKwidth <
                                                        //             500) // mobile
                                                        //         ?
                                                        16
                                                        // :
                                                        // 13
                                                        , // tablet / in-between
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                    height: isKwidth > 700
                                                        ? 5
                                                        : getWidgetHeight(
                                                            height: 5)),
                                                SizedBox(
                                                  height: isKwidth > 700
                                                      ? 18
                                                      : getWidgetHeight(
                                                          height: 15),
                                                  child: Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
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
                                                // if (!kIsWeb)
                                                SizedBox(
                                                    height: isKwidth > 700
                                                        ? 14
                                                        : getWidgetHeight(
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
              GetBuilder<HomeController>(builder: (homeController) {
                return SizedBox(
                  height: getWidgetHeight(height: 300),
                  child: TabBarView(
                    controller: _tabController,
                    physics: const BouncingScrollPhysics(),
                    children: [
                      GetBuilder<HomeController>(builder: (controller) {
                        return ListView.builder(
                          shrinkWrap: true,
                          itemCount: 3,
                          physics: BouncingScrollPhysics(),
                          padding: EdgeInsets.only(
                              top: isKwidth > 700
                                  ? 5
                                  : getWidgetHeight(height: 10),
                              bottom: isKwidth > 700
                                  ? 80
                                  : getWidgetHeight(height: 100)),
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
                                  if (index == 0) {
                                    kIsWeb
                                        ? Get.rootDelegate.toNamed(AppRoutes
                                            .simulation) // ✅ Use toNamed() instead of offNamed()
                                        : Get.toNamed(AppRoutes.simulation);
                                  } else if (index == 1) {
                                    kIsWeb
                                        ? Get.rootDelegate
                                            .toNamed(AppRoutes.languageLab)
                                        : Get.toNamed(AppRoutes.languageLab);
                                  } else if (index == 2) {
                                    kIsWeb
                                        ? Get.rootDelegate
                                            .toNamed(AppRoutes.contentLibrary)
                                        : Get.toNamed(AppRoutes.contentLibrary);
                                  } else {
                                    controller.showPopupAtTap(tapPosition);
                                  }
                                },
                                child: Container(
                                  // height: isKwidth > 700
                                  //     ? 100
                                  //     : getWidgetHeight(height: 75),
                                  padding: EdgeInsets.symmetric(
                                      vertical: getWidgetHeight(height: 5)),
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
                                      SizedBox(
                                          width: isKwidth > 700
                                              ? 5
                                              : getWidgetWidth(width: 4)),
                                      Container(
                                        width: isKwidth > 700
                                            ? 65
                                            : getWidgetWidth(width: 55),
                                        height: isKwidth > 700
                                            ? 65
                                            : getWidgetHeight(height: 68),
                                        decoration: BoxDecoration(
                                          color: linearColor,
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(12),
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
                                                      : isKwidth > 700
                                                          ? 18
                                                          : getWidgetHeight(
                                                              height: 22),
                                                  horizontal: index == 1
                                                      ? 0
                                                      : isKwidth > 700
                                                          ? 18
                                                          : getWidgetWidth(
                                                              width: 16),
                                                ),
                                                child: index == 0
                                                    ? Image.asset(
                                                        fit: BoxFit.fill,
                                                        AllAssets
                                                            .interactiveSimulations,
                                                        color: Colors.white,
                                                      )
                                                    : index == 1
                                                        ? Icon(
                                                            Icons.mic,
                                                            color: Colors.white,
                                                            size: isKwidth > 700
                                                                ? 30
                                                                : 28,
                                                          )
                                                        : Image.asset(
                                                            "assets/language_lab.png"),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                          width: isKwidth > 700
                                              ? 12
                                              : getWidgetWidth(width: 12)),
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
                                      SizedBox(
                                          width: getWidgetWidth(width: 16)),
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
                                              height:
                                                  getWidgetHeight(height: 6)),

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
                                              height:
                                                  getWidgetHeight(height: 6)),

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
                                                              item[
                                                                  'soundSub']));
                                                  WidgetsBinding.instance
                                                      .addPostFrameCallback(
                                                          (_) {
                                                    !kIsWeb
                                                        ? Get.toNamed(
                                                            AppRoutes.soundPage,
                                                            arguments: {
                                                                "title": item[
                                                                    'category'],
                                                                "soundModel":
                                                                    soundSubcategory
                                                              })
                                                        : Get.rootDelegate
                                                            .offNamed(
                                                                AppRoutes
                                                                    .soundPage,
                                                                arguments: {
                                                                "title": item[
                                                                    'category'],
                                                                "soundModel":
                                                                    soundSubcategory
                                                              });
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
                                                                doc:
                                                                    grammerDocs,
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
                                                  WidgetsBinding.instance
                                                      .addPostFrameCallback(
                                                          (_) {
                                                    !kIsWeb
                                                        ? Get.toNamed(
                                                            AppRoutes
                                                                .sentenceLabSub,
                                                            arguments: {
                                                              "title": item[
                                                                  'category'],
                                                              "CategoryModel":
                                                                  subCategories,
                                                            },
                                                          )
                                                        : Get.rootDelegate
                                                            .offNamed(
                                                            AppRoutes
                                                                .sentenceLabSub,
                                                            arguments: {
                                                              "title": item[
                                                                  'category'],
                                                              "CategoryModel":
                                                                  subCategories,
                                                            },
                                                          );
                                                  });
                                                } else if (item['section'] ==
                                                    'proLab') {
                                                  log("proLab tapped");
                                                  Get.toNamed(
                                                      AppRoutes
                                                          .pronunciationLabSub,
                                                      arguments: {
                                                        'title':
                                                            item['category'],
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
                                                                url: item[
                                                                    'link']),
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
                                                            color: Colors
                                                                .grey[700],
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
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
