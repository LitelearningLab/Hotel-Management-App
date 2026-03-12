import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hotelmanagementapp/model/category_model.dart';
import 'package:hotelmanagementapp/public/api.dart';
import 'package:hotelmanagementapp/public/common_function.dart';
import 'package:hotelmanagementapp/public/keys.dart';
import 'package:hotelmanagementapp/view/profile_screen.dart' show ProfileScreen;
import 'package:hotelmanagementapp/view/university_lab.dart';
import 'package:package_info_plus/package_info_plus.dart';

import 'package:hotelmanagementapp/controller/home_controller.dart';
import 'package:hotelmanagementapp/public/all_asset.dart';
import 'package:hotelmanagementapp/public/constant.dart';
import 'package:hotelmanagementapp/public/update_checker.dart';
import 'package:hotelmanagementapp/route/route_name.dart';
import 'package:hotelmanagementapp/utility/web_top_nav.dart';

import 'package:hotelmanagementapp/model/grammer_lab_model.dart';
import 'package:hotelmanagementapp/model/sentence_model.dart';
import 'package:hotelmanagementapp/model/sound_model.dart';
import 'package:hotelmanagementapp/view/grammer_lab_sub.dart';
import 'package:hotelmanagementapp/utility/web_view_page.dart';

int currentIndex = 0;

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with WidgetsBindingObserver {
  late final HomeController ctr;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String? appVersion;

  // --------------------------------------------------
  // LIFECYCLE
  // --------------------------------------------------
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    /// ✅ KEEP HOME CONTROLLER ALIVE
    ctr = Get.find<HomeController>();

    currentIndex = 0;
    _loadAppVersion();
    ctr.loadRecentHistory();
    UpdateChecker.checkForUpdate(context);
  }

  Future<void> _loadAppVersion() async {
    if (kIsWeb) {
      appVersion = "web";
    } else {
      final info = await PackageInfo.fromPlatform();
      appVersion = info.version;
    }
    if (mounted) setState(() {});
  }

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

  Widget _mainDrawer() {
    return GetBuilder<HomeController>(builder: (controller) {
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
                        kIsWeb
                            ? Get.rootDelegate.offNamed(AppRoutes.feedbackpage)
                            : Get.toNamed(AppRoutes.feedbackpage);
                        // uploadFeedbackForm();
                        // Navigator.push(
                        //     context,
                        //     MaterialPageRoute(
                        //         builder: (context) =>
                        //             FeedbackFormScreen()));
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
            if (!kIsWeb)
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
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      ctr.loadRecentHistory();
    }
  }

  // --------------------------------------------------
  // BUILD
  // --------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: const Color(0xFFF9FAFB),
      endDrawer: _mainDrawer(),
      body: Column(
        children: [
          /// ✅ WEB HEADER SAFE
          if (kIsWeb)
            WebHeaderWithNav(
              title: 'Home',
              onDrawer: () {
                _scaffoldKey.currentState?.openEndDrawer();
              },
            )
          else
            _mobileHeader(),

          /// ✅ BODY MUST BE EXPANDED
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: 32,
                vertical: 24,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _fiveCardRow(context),
                  const SizedBox(height: 32),
                  _dashboardRow(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --------------------------------------------------
  // MOBILE HEADER
  // --------------------------------------------------
  Widget _mobileHeader() {
    return Container(
      height: 80,
      padding: const EdgeInsets.symmetric(horizontal: 32),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Color(0xFFEDEDED))),
      ),
      child: Row(
        children: [
          Image.asset(AllAssets.splashLogo, height: 56),
          const Spacer(),
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => Get.toNamed(AppRoutes.searchScreen),
          ),
          IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => _scaffoldKey.currentState?.openEndDrawer(),
          ),
        ],
      ),
    );
  }

  // --------------------------------------------------
  // FIVE COURSE CARDS
  // --------------------------------------------------
  Widget _fiveCardRow(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final cardWidth = (width - 160) / 5;

    return GetBuilder<HomeController>(
      builder: (c) {
        return Row(
          children: List.generate(c.cardNames.length, (index) {
            return Padding(
              padding: EdgeInsets.only(right: index == 4 ? 0 : 20),
              child: SizedBox(
                width: cardWidth,
                child: _CourseCard(index, c),
              ),
            );
          }),
        );
      },
    );
  }

  // --------------------------------------------------
  // DASHBOARD
  // --------------------------------------------------
  Widget _dashboardRow() {
    return SizedBox(
      height: 360, // 🔑 IMPORTANT: give Row a height
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: _smartShots()),
          const SizedBox(width: 24),
          Expanded(child: _recentHistory()),
          const SizedBox(width: 24),
          Expanded(child: _todo()),
        ],
      ),
    );
  }

  Widget _smartShots() {
    return _panel(
      title: "Smart Shots",
      child: Column(
        children: List.generate(3, (i) => _SmartTile(i)),
      ),
    );
  }

  Widget _recentHistory() {
    return _panel(
      title: "Recent History",
      child: GetBuilder<HomeController>(
        builder: (c) {
          if (c.homeRecentHistory.isEmpty) {
            return const Center(
              child: Text(
                "No recent history found",
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 13,
                ),
              ),
            );
          }

          return ListView.separated(
            itemCount: c.homeRecentHistory.take(5).length,
            separatorBuilder: (_, __) => const Divider(
              height: 16,
              thickness: 0.5,
              color: Color(0xFFEFEFEF),
            ),
            itemBuilder: (context, index) {
              final item = c.homeRecentHistory[index];

              return InkWell(
                borderRadius: BorderRadius.circular(10),
                onTap: () {
                  final section = (item['section'] ?? '').toString();
                  final path = (item['path'] ?? '').toString();
                  final link = (item['link'] ?? '').toString();
                  final category = (item['category'] ?? '').toString();
                  final proLabTitle = (item['proLabTitle'] ?? '').toString();
                  final sectionLower = section.toLowerCase().trim();

                  final isWebContentSection = sectionLower == 'e-learning' ||
                      sectionLower == 'glossary' ||
                      sectionLower == 'quiz' ||
                      sectionLower == 'interactive simulation' ||
                      sectionLower == 'interactive simulations';

                  if (isWebContentSection) {
                    if (link.trim().isEmpty) return;
                    if (kIsWeb) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => WebContentPage(
                            title: category,
                            url: link,
                          ),
                        ),
                      );
                    } else {
                      Get.toNamed(AppRoutes.inAppWebView,
                          arguments: {"url": link});
                    }
                  } else if (sectionLower.contains('pronunciation') ||
                      sectionLower.contains('prounciation')) {
                    if (item['extraStorageData'] != null &&
                        (item['extraStorageData'] as Map).isNotEmpty) {
                      GetStorage().write(AppRoutes.pronunciationLabSubStoreKey,
                          item['extraStorageData']);
                      if (kIsWeb) {
                        Get.rootDelegate.toNamed(
                          AppRoutes.pronunciationLabSub,
                          arguments: item['extraStorageData'],
                        );
                      } else {
                        Get.toNamed(AppRoutes.pronunciationLabSub,
                            arguments: item['extraStorageData']);
                      }
                    } else if (proLabTitle.isNotEmpty) {
                      // From Language Lab
                      GetStorage().write(
                          AppRoutes.pronunciationLab, {"title": proLabTitle});
                      if (kIsWeb) {
                        Get.rootDelegate.toNamed(
                          AppRoutes.pronunciationLab,
                          arguments: {"title": proLabTitle},
                        );
                      } else {
                        Get.toNamed(AppRoutes.pronunciationLab, arguments: {
                          "title": proLabTitle,
                        });
                      }
                    } else if (path.toLowerCase().contains('language lab')) {
                      final parts = path
                          .split('>')
                          .map((e) => e.trim())
                          .where((e) => e.isNotEmpty)
                          .toList();
                      final derivedTitle = parts.length > 1 ? parts[1] : '';
                      final titleToOpen = derivedTitle.isNotEmpty
                          ? derivedTitle
                          : "English Pronunciation";
                      GetStorage().write(
                          AppRoutes.pronunciationLab, {"title": titleToOpen});
                      if (kIsWeb) {
                        Get.rootDelegate.toNamed(
                          AppRoutes.pronunciationLab,
                          arguments: {"title": titleToOpen},
                        );
                      } else {
                        Get.toNamed(AppRoutes.pronunciationLab,
                            arguments: {"title": titleToOpen});
                      }
                    } else {
                      // From Front Office
                      String pronunCollectionName = "";
                      int index = -1;
                      String mainCategoryTitle = "";

                      if (path.contains("Front Office")) {
                        pronunCollectionName =
                            CollectionNames.frontOfficePronun;
                        index = 0;
                        mainCategoryTitle = "Front Office Reception";
                      } else if (path.contains("Food & Beverage")) {
                        pronunCollectionName =
                            CollectionNames.foodAndBeveragePronun;
                        index = 1;
                        mainCategoryTitle = "Food & Beverage";
                      } else if (path.contains("Food Production")) {
                        pronunCollectionName =
                            CollectionNames.foodProductionPronun;
                        index = 2;
                        mainCategoryTitle = "Food Production";
                      } else if (path.contains("House Keeping") ||
                          path.contains("Housekeeping") ||
                          path.contains("Accommodation")) {
                        pronunCollectionName =
                            CollectionNames.houseKeepingPronun;
                        index = 3;
                        mainCategoryTitle = "House Keeping";
                      }

                      final storageData = {
                        'title': category,
                        'subcategories': <SubcategoryPro>[],
                        "id": link,
                        "pronunCollectionName": pronunCollectionName,
                        'index': index,
                        'mainCategoryTitle': mainCategoryTitle,
                      };

                      GetStorage().write(
                          AppRoutes.pronunciationLabSubStoreKey, storageData);

                      if (kIsWeb) {
                        Get.rootDelegate.toNamed(
                          AppRoutes.pronunciationLabSub,
                          arguments: storageData,
                        );
                      } else {
                        Get.toNamed(AppRoutes.pronunciationLabSub,
                            arguments: storageData);
                      }
                    }
                  } else if (sectionLower.contains('grammer') ||
                      sectionLower.contains('grammar')) {
                    final rawDoc = item['grammarDocs'];
                    if (rawDoc is Map &&
                        rawDoc.isNotEmpty &&
                        rawDoc['subcategory'] is List) {
                      final doc = GrammarDoc.fromJson(
                          Map<String, dynamic>.from(rawDoc));
                      Get.to(() => GrammerLabSub(title: category, doc: doc));
                    }
                  } else if (sectionLower == 'sound lab') {
                    final rawSound = item['soundSub'];
                    if (rawSound is Map && rawSound.isNotEmpty) {
                      final soundSub = SoundSubcategory.fromJson(
                          Map<String, dynamic>.from(rawSound));
                      if (kIsWeb) {
                        Get.rootDelegate.toNamed(
                          AppRoutes.soundPage,
                          arguments: {
                            'title': category,
                            'soundModel': soundSub,
                          },
                        );
                      } else {
                        Get.toNamed(AppRoutes.soundPage, arguments: {
                          'title': category,
                          'soundModel': soundSub,
                        });
                      }
                    }
                  } else if (sectionLower == 'sentence lab') {
                    final rawSubCategories = item['subCategories'];
                    List<SubCategoryModel> categoryModel = [];
                    if (rawSubCategories is List) {
                      categoryModel = rawSubCategories
                          .map((entry) {
                            if (entry is SubCategoryModel) return entry;
                            if (entry is Map) {
                              return SubCategoryModel.fromJson(
                                  Map<String, dynamic>.from(entry));
                            }
                            return null;
                          })
                          .whereType<SubCategoryModel>()
                          .toList();
                    }
                    final args = {
                      "title": category,
                      "CategoryModel": categoryModel,
                    };
                    GetStorage().write(AppRoutes.sentenceLabSubCat, args);
                    if (kIsWeb) {
                      Get.rootDelegate.toNamed(
                        AppRoutes.sentenceLabSubCat,
                        arguments: args,
                      );
                    } else {
                      Get.toNamed(AppRoutes.sentenceLabSubCat, arguments: args);
                    }
                  }
                },
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
                  child: Row(
                    children: [
                      // LEFT DOT / ICON
                      Container(
                        height: 8,
                        width: 8,
                        decoration: BoxDecoration(
                          color: linearColor,
                          shape: BoxShape.circle,
                        ),
                      ),

                      const SizedBox(width: 12),

                      // TEXT CONTENT
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item['category'] ?? '',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 13.5,
                                fontWeight: FontWeight.w500,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              item['section'] ?? '',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(width: 8),

                      // ARROW
                      const Icon(
                        Icons.arrow_forward_ios,
                        size: 12,
                        color: Colors.grey,
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _todo() {
    return _panel(
      title: "To Do",
      child: const Center(
        child: Text("No assignments yet",
            style: TextStyle(fontWeight: FontWeight.w600)),
      ),
    );
  }

  // --------------------------------------------------
  // PANEL
  // --------------------------------------------------
  Widget _panel({required String title, required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFEFEFEF)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.inter(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 14),
          SizedBox(
            height: 260,
            child: child,
          ),
        ],
      ),
    );
  }

  // --------------------------------------------------
  // DRAWER
  // --------------------------------------------------
  Drawer _appDrawer() {
    return Drawer(
      child: Column(
        children: [
          const SizedBox(height: 16),
          GetBuilder<HomeController>(
            builder: (c) => ListTile(
              title: Text("Welcome", style: TextStyle(color: linearColor)),
              subtitle: Text(c.userName, style: const TextStyle(fontSize: 22)),
            ),
          ),
          const Spacer(),
          Text("App version $appVersion",
              style: const TextStyle(color: Colors.grey)),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

// ==================================================
// COURSE CARD (CURVED HOVER)
// ==================================================
class _CourseCard extends StatefulWidget {
  final int index;
  final HomeController c;
  const _CourseCard(this.index, this.c);

  @override
  State<_CourseCard> createState() => _CourseCardState();
}

class _CourseCardState extends State<_CourseCard> {
  bool hovered = false;

  @override
  Widget build(BuildContext context) {
    final index = widget.index;
    final c = widget.c;

    return MouseRegion(
      onEnter: (_) => setState(() => hovered = true),
      onExit: (_) => setState(() => hovered = false),
      cursor: SystemMouseCursors.click,
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        splashColor: Colors.transparent,
        hoverColor: Colors.transparent,
        onTap: () {
          if (index == 4) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => UniversityLab(
                  universityModel: c.universityModel,
                ),
              ),
            );
          } else {
            final title = c.cardNames[index] == "Front Office\nManagement"
                ? "Front Office Management"
                : c.cardNames[index] == "Food & Beverage Service\nManagement"
                    ? "Food & Beverage Service Management"
                    : c.cardNames[index] ==
                            "Accommodation\nManagement - Housekeeping"
                        ? "Accommodation Management - Housekeeping"
                        : c.cardNames[index];
            setPathTitle(title);

            GetStorage().write(AppRoutes.frontOfficeStoreKey, {
              'title': title,
              'image': c.cardImages[index],
              'index': index,
            });
            // mianCategoryTitile = title;
            kIsWeb
                ? Get.rootDelegate.offNamed(
                    AppRoutes.frontOffice,
                    arguments: {
                      'title': title,
                      'image': c.cardImages[index],
                      'index': index,
                    },
                  )
                : Get.toNamed(
                    AppRoutes.frontOffice,
                    arguments: {
                      'title': title,
                      'image': c.cardImages[index],
                      'index': index,
                    },
                  );
          }
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          height: 380,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18), // 👈 smoother
            border: Border.all(color: const Color(0xFFEDEDED)),
            boxShadow: hovered
                ? [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.06),
                      blurRadius: 28, // 👈 softer
                      spreadRadius: 1, // 👈 removes hard edge
                      offset: const Offset(0, 12),
                    ),
                  ]
                : [],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 220,
                width: double.infinity,
                child: ClipRRect(
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(18)),
                  child: index >= 4
                      ? Image.network(c.cardImages[index],
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              Container(
                                color: Colors.grey[200],
                                child: const Icon(Icons.broken_image,
                                    color: Colors.grey),
                              ))
                      : SvgPicture.asset(
                          c.cardImages[index],
                          fit: BoxFit.cover,
                        ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        index == 4
                            ? 'Institute Specific Content'
                            : 'Hotel Management',
                        style: TextStyle(fontSize: 11, color: Colors.grey),
                      ),
                      const SizedBox(height: 6),
                      Expanded(
                        child: Text(
                          c.cardNames[index],
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            fontFamily: Keys.fontFamily,
                          ),
                        ),
                      ),
                      const Text(
                        "View Details",
                        style: TextStyle(
                          color: Colors.blue,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

// ==================================================
// SMART TILE (TITLE + DESCRIPTION + HOVER)
// ==================================================
class _SmartTile extends StatefulWidget {
  final int index;
  const _SmartTile(this.index);

  @override
  State<_SmartTile> createState() => _SmartTileState();
}

class _SmartTileState extends State<_SmartTile> {
  bool hovered = false;

  @override
  Widget build(BuildContext context) {
    final descriptions = [
      "250+ simulations for real-world hotel scenarios",
      "Pronunciation, grammar & language practice",
      "Micro-learning content for quick skill boosts",
    ];

    return GetBuilder<HomeController>(builder: (c) {
      return MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) => setState(() => hovered = true),
        onExit: (_) => setState(() => hovered = false),
        child: InkWell(
          onTap: () {
            if (widget.index == 0) {
              kIsWeb
                  ? Get.rootDelegate.toNamed(AppRoutes.simulation)
                  : Get.toNamed(AppRoutes.simulation);
            } else if (widget.index == 1) {
              setPathTitle('language-lab');
              kIsWeb
                  ? Get.rootDelegate.toNamed(AppRoutes.languageLab)
                  : Get.toNamed(AppRoutes.languageLab);
            } else {
              kIsWeb
                  ? Get.rootDelegate.toNamed(AppRoutes.contentLibrary)
                  : Get.toNamed(AppRoutes.contentLibrary);
            }
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 160),
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0xFFEFEFEF)),
              boxShadow: hovered
                  ? [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.06),
                        blurRadius: 14,
                        offset: const Offset(0, 8),
                      ),
                    ]
                  : [],
            ),
            child: Row(
              children: [
                // ✅ FIXED ICON CONTAINER
                Container(
                  height: 44,
                  width: 44,
                  decoration: BoxDecoration(
                    color: linearColor.withOpacity(0.95), // 🔑 visible
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: linearColor.withOpacity(0.6),
                    ),
                  ),
                  alignment: Alignment.center,
                  child: const Icon(
                    Icons.play_arrow,
                    size: 22,
                    color: Colors.white, // 🔒 force visible
                  ),
                ),

                const SizedBox(width: 14),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        c.smartShorts[widget.index],
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                          fontFamily: Keys.fontFamily,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        descriptions[widget.index],
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                          fontFamily: Keys.fontFamily,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
