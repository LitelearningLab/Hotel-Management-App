import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hotelmanagementapp/controller/bottom_navigation_controller.dart';
import 'package:hotelmanagementapp/controller/home_controller.dart';
import 'package:hotelmanagementapp/controller/language_lab_controller.dart';
import 'package:hotelmanagementapp/public/all_asset.dart';
import 'package:hotelmanagementapp/public/common_function.dart';
import 'package:hotelmanagementapp/public/constant.dart';
import 'package:hotelmanagementapp/route/route_name.dart';
import 'package:hotelmanagementapp/utility/custome_bottom_navigation.dart';
import 'package:hotelmanagementapp/utility/pe_top_categories_card.dart';
import 'package:hotelmanagementapp/utility/web_top_nav.dart';

class Languagelab extends StatelessWidget {
  const Languagelab({super.key});

  static const double _soundCardHeight = 420;

  @override
  Widget build(BuildContext context) {
    setPathTitle('language-lab');
    final homeController = Get.put(HomeController());

    return PopScope(
      onPopInvoked: (_) => homeController.loadRecentHistory(),
      child: Scaffold(
        backgroundColor: const Color(0xFFF9FAFB),
        floatingActionButton: kIsWeb ? null : const CustomeBottomNavigation(),
        body: Column(
          children: [
            if (kIsWeb)
              WebHeaderWithNav(title: "Language Lab")
            else
              AppBar(
                title: const Text("Language Lab"),
                leading: BackButton(
                  onPressed: () {
                    homeController.loadRecentHistory();

                    kIsWeb
                        ? Get.rootDelegate.offNamed(AppRoutes.home)
                        : Get.back();
                  },
                ),
              ),
            Expanded(
              child: GetBuilder<LanguageLabController>(
                builder: (controller) {
                  if (controller.isLoading) {
                    return Center(
                      child: CircularProgressIndicator(color: linearColor),
                    );
                  }

                  return SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 32, vertical: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // _pageHeader(),
                        // const SizedBox(height: 24),
                        _categoryGrid(context, controller),
                        const SizedBox(height: 12),

                        Text(
                          "Sounds",
                          style: GoogleFonts.inter(
                            fontSize: 22,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 8),

                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            PETopCategoriesCard(
                              height: getWidgetHeight(
                                  height: displayWidth(context) > 1200
                                      ? 120
                                      : 88.28),
                              width: getWidgetWidth(width: 96.11),
                              title: 'English Pronunciation',
                              imageUrl: AllAssets.pePl,
                              onTap: () async {
                                if (!controller.isLabActive('english_lab')) {
                                  controller.showReviewPopup(context);
                                  return;
                                }
                                mainCategoryTitle = 'English Pronunciation';
                                WidgetsBinding.instance
                                    .addPostFrameCallback((_) {
                                  GetStorage().write(AppRoutes.pronunciationLab,
                                      {"title": "English Pronunciation"});
                                  kIsWeb
                                      ? Get.rootDelegate.offNamed(
                                          AppRoutes.pronunciationLab,
                                          arguments: {
                                              "title": "English Pronunciation"
                                            })
                                      : Get.toNamed(AppRoutes.pronunciationLab,
                                          arguments: {
                                              "title": "English Pronunciation"
                                            });
                                });
                              },
                              isUnderConstruction:
                                  !controller.isLabActive('english_lab'),
                              cardColor: Color(0xFF398480),
                            ),
                            PETopCategoriesCard(
                              height: getWidgetHeight(
                                  height: displayWidth(context) > 1200
                                      ? 120
                                      : 88.28),
                              width: getWidgetWidth(width: 96.11),
                              title: 'French Pronunciation',
                              imageUrl: AllAssets.peScl,
                              onTap: () async {
                                if (!controller.isLabActive('french_lab')) {
                                  controller.showReviewPopup(context);
                                  return;
                                }
                                mainCategoryTitle = 'French Pronunciation';
                                WidgetsBinding.instance
                                    .addPostFrameCallback((_) {
                                  GetStorage().write(AppRoutes.pronunciationLab,
                                      {"title": "French Pronunciation"});
                                  kIsWeb
                                      ? Get.rootDelegate.offNamed(
                                          AppRoutes.pronunciationLab,
                                          arguments: {
                                              "title": "French Pronunciation"
                                            })
                                      : Get.toNamed(AppRoutes.pronunciationLab,
                                          arguments: {
                                              "title": "French Pronunciation"
                                            });
                                });
                              },
                              isUnderConstruction:
                                  !controller.isLabActive('french_lab'),
                              cardColor: Color(0xFF445EA9),
                            ),
                            PETopCategoriesCard(
                              height: getWidgetHeight(
                                  height: displayWidth(context) > 1200
                                      ? 120
                                      : 88.28),
                              width: getWidgetWidth(width: 96.11),
                              title: 'Sentence Lab',
                              imageUrl: AllAssets.peCfpl,
                              onTap: () async {
                                if (!controller.isLabActive('sentence_lab')) {
                                  controller.showReviewPopup(context);
                                  return;
                                }
                                mainCategoryTitle = 'Sentence Lab';
                                WidgetsBinding.instance
                                    .addPostFrameCallback((_) {
                                  GetStorage().write(AppRoutes.sentenceLab,
                                      {"title": "Sentence Lab"});
                                  kIsWeb
                                      ? Get.rootDelegate.offNamed(
                                          AppRoutes.sentenceLab,
                                          arguments: {"title": "Sentence Lab"})
                                      : Get.toNamed(AppRoutes.sentenceLab,
                                          arguments: {"title": "Sentence Lab"});
                                });
                              },
                              isUnderConstruction:
                                  !controller.isLabActive('sentence_lab'),
                              cardColor: Color(0xFF636CFF),
                            ),
                            PETopCategoriesCard(
                              height: getWidgetHeight(
                                  height: displayWidth(context) > 1200
                                      ? 120
                                      : 88.28),
                              width: getWidgetWidth(width: 96.11),
                              title: 'Grammer Lab',
                              imageUrl: AllAssets.peGl,
                              onTap: () {
                                if (!controller.isLabActive('grammer_lab')) {
                                  controller.showReviewPopup(context);
                                  return;
                                }
                                mainCategoryTitle = 'Grammer Lab';
                                WidgetsBinding.instance
                                    .addPostFrameCallback((_) {
                                  GetStorage().write(AppRoutes.grmmaerLab,
                                      {"title": "Grammer Lab"});
                                  kIsWeb
                                      ? Get.rootDelegate.offNamed(
                                          AppRoutes.grmmaerLab,
                                          arguments: {"title": "Grammer Lab"})
                                      : Get.toNamed(AppRoutes.grmmaerLab,
                                          arguments: {"title": "Grammer Lab"});
                                });
                              },
                              isUnderConstruction:
                                  !controller.isLabActive('grammer_lab'),
                              cardColor: Color(0xFFDC6379),
                            ),
                            const SizedBox(width: 20),
                            Expanded(
                              child: _soundSectionCard(
                                title: "Vowels",
                                child: _expandableSounds(
                                  controller,
                                  controller.vowelSoundsList,
                                  isVowel: true,
                                ),
                              ),
                              SizedBox(
                                width: getWidgetWidth(width: 7),
                              ),
                              Column(
                                children: [
                                  Text(
                                    '( Know more... )',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500,
                                      fontFamily: 'Roboto',
                                      letterSpacing: 0,
                                      fontSize: 13,
                                      wordSpacing: 2,
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(top: 2),
                                    height: getWidgetHeight(height: 2),
                                    color: Colors.black,
                                    width: displayWidth(context) > 700
                                        ? getWidgetWidth(width: 20)
                                        : getWidgetWidth(width: 80),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: getWidgetHeight(height: 8),
                        ),
                        Column(
                          children: [
                            DefaultTabController(
                              length: 3,
                              child: Column(
                                children: [
                                  TabBar(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: getWidgetWidth(width: 20)),
                                    splashFactory: InkSplash.splashFactory,
                                    splashBorderRadius:
                                        BorderRadius.circular(30),
                                    enableFeedback: false,
                                    indicatorPadding:
                                        EdgeInsets.symmetric(vertical: 5),
                                    onTap: (index) {
                                      mainCategoryTitle = index == 0
                                          ? "Important Sounds"
                                          : index == 1
                                              ? "Vowels"
                                              : "Consonants";
                                      controller.ontapTab(index);
                                    },
                                    labelPadding: EdgeInsets.only(right: 10),
                                    dividerColor: Colors.transparent,
                                    tabAlignment: TabAlignment.start,
                                    labelColor: Colors.white,
                                    isScrollable: true,
                                    physics: AlwaysScrollableScrollPhysics(),
                                    unselectedLabelColor: Color(0xFF99A0AE),
                                    indicatorColor: Color(0xFF6C63FE),
                                    indicatorSize: TabBarIndicatorSize.label,
                                    indicator: BoxDecoration(
                                      borderRadius: BorderRadius.circular(30),
                                      color: Color(0xFF6C63FE),
                                    ),
                                    tabs: List.generate(
                                      3,
                                      (index) => Tab(
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 20),
                                          height: 40,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(30),
                                            color: controller.selectedIndex ==
                                                    index
                                                ? Colors.transparent
                                                : Colors.white,
                                            boxShadow: controller
                                                        .selectedIndex ==
                                                    index
                                                ? []
                                                : [
                                                    BoxShadow(
                                                      color: Colors.black
                                                          .withOpacity(0.15),
                                                      blurRadius: 6,
                                                      offset:
                                                          const Offset(0, 3),
                                                    ),
                                                  ],
                                          ),
                                          child: Align(
                                            alignment: Alignment.center,
                                            child: Text(
                                              index == 0
                                                  ? "Important Sounds"
                                                  : index == 1
                                                      ? "Vowels"
                                                      : "Consonants",
                                              style: TextStyle(
                                                color: controller
                                                            .selectedIndex ==
                                                        index
                                                    ? Colors.white
                                                    : const Color(0xFF99A0AE),
                                                fontSize: 12,
                                                fontFamily: 'Roboto',
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        controller.selectedIndex == 0
                            ? SizedBox(
                                height: displayWidth(context) > 700
                                    ? displayHeight(context) * 0.85
                                    : getWidgetHeight(height: 255),
                                child: Scrollbar(
                                  thickness: 2,
                                  thumbVisibility: true,
                                  radius: Radius.circular(10),
                                  child: ListView.builder(
                                    itemCount: controller.importantSound
                                            ?.subcategories.length ??
                                        0,
                                    itemBuilder: (context, index) {
                                      return Column(
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.symmetric(
                                                vertical:
                                                    getWidgetHeight(height: 3),
                                                horizontal:
                                                    getWidgetWidth(width: 15)),
                                            child: InkWell(
                                              onTap: () {
                                                mainCategoryTitle =
                                                    "Important Sounds";
                                                activityName = 'Sound Lab';
                                                subCategoryTitle = controller
                                                    .importantSound!
                                                    .subcategories[index]
                                                    .name;
                                                addToRecentHistory(
                                                    path:
                                                        "Language Lab > Important Sounds",
                                                    category: controller
                                                        .importantSound!
                                                        .subcategories[index]
                                                        .name,
                                                    section: "Sound Lab",
                                                    link: "",
                                                    proLabTitle: "",
                                                    soundSubcategory: controller
                                                        .importantSound!
                                                        .subcategories[index]);
                                                GetStorage().write(
                                                    AppRoutes.soundPage, {
                                                  "title": controller
                                                      .importantSound!
                                                      .subcategories[index]
                                                      .name,
                                                  "soundModel": controller
                                                      .importantSound!
                                                      .subcategories[index]
                                                });
                                                WidgetsBinding.instance
                                                    .addPostFrameCallback((_) {
                                                  kIsWeb
                                                      ? Get.rootDelegate
                                                          .offNamed(
                                                              AppRoutes
                                                                  .soundPage,
                                                              arguments: {
                                                              "title": controller
                                                                  .importantSound!
                                                                  .subcategories[
                                                                      index]
                                                                  .name,
                                                              "soundModel": controller
                                                                  .importantSound!
                                                                  .subcategories[index]
                                                            })
                                                      : Get.toNamed(
                                                          AppRoutes.soundPage,
                                                          arguments: {
                                                              "title": controller
                                                                  .importantSound!
                                                                  .subcategories[
                                                                      index]
                                                                  .name,
                                                              "soundModel": controller
                                                                  .importantSound!
                                                                  .subcategories[index]
                                                            });
                                                });
                                              },
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 12),
                                                child: Row(
                                                  children: [
                                                    Text(
                                                      controller
                                                          .importantSound!
                                                          .subcategories[index]
                                                          .name,
                                                      style: TextStyle(
                                                        letterSpacing: 0,
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontFamily: Keys
                                                            .lucidaFontFamily,
                                                        fontSize:
                                                            kText.scale(15),
                                                      ),
                                                    ),
                                                    const Spacer(),
                                                    const Icon(
                                                      Icons
                                                          .chevron_right_rounded,
                                                      size: 30,
                                                      color: Color.fromARGB(
                                                          45, 82, 82, 82),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                          const Divider(
                                            color:
                                                Color.fromARGB(45, 82, 82, 82),
                                          ),
                                          if (index ==
                                              (controller.importantSound!
                                                      .subcategories.length -
                                                  1))
                                            SizedBox(
                                              height:
                                                  getWidgetHeight(height: 45),
                                            )
                                        ],
                                      );
                                    },
                                  ),
                                ),
                              )
                            : ((controller.selectedIndex == 1) ||
                                    (controller.selectedIndex == 2))
                                ? SizedBox(
                                    height: displayWidth(context) > 700
                                        ? displayWidth(context) * 0.5
                                        : getWidgetHeight(height: 255),
                                    child: Scrollbar(
                                      thickness: 2,
                                      thumbVisibility: true,
                                      radius: Radius.circular(10),
                                      child: ListView.builder(
                                        itemCount: controller.selectedIndex == 1
                                            ? controller.vowelSoundsList.length
                                            : controller
                                                .consonantSoundsList.length,
                                        itemBuilder: (context, index) {
                                          final isExpanded =
                                              controller.expandedIndex == index;
                                          return Column(
                                            children: [
                                              GestureDetector(
                                                onTap: () {
                                                  subCategoryTitle = controller
                                                              .selectedIndex ==
                                                          1
                                                      ? controller
                                                          .vowelSoundsList[
                                                              index]
                                                          .category
                                                      : controller
                                                          .consonantSoundsList[
                                                              index]
                                                          .category;
                                                  controller.expandedIndex =
                                                      isExpanded ? -1 : index;
                                                  controller.update();
                                                },
                                                child: Container(
                                                  width: getWidgetWidth(
                                                      width: 375),
                                                  // height: getWidgetHeight(height: 60),
                                                  margin: EdgeInsets.symmetric(
                                                      vertical: getWidgetHeight(
                                                          height: 5),
                                                      horizontal:
                                                          getWidgetWidth(
                                                              width: 15)),
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12),
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: Colors.black
                                                            .withOpacity(0.1),
                                                        offset:
                                                            const Offset(0, 4),
                                                        blurRadius: 10,
                                                      ),
                                                    ],
                                                  ),
                                                  child: Container(
                                                    width: getWidgetWidth(
                                                        width: 375),
                                                    // height: getWidgetHeight(height: 75),
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              12),
                                                      color: Colors.white,
                                                    ),
                                                    child: Padding(
                                                      padding: EdgeInsets.symmetric(
                                                          vertical:
                                                              getWidgetHeight(
                                                                  height: 6),
                                                          horizontal: displayWidth(
                                                                      context) >
                                                                  700
                                                              ? getWidgetWidth(
                                                                  width: 5)
                                                              : getWidgetWidth(
                                                                  width: 10)),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Row(
                                                            children: [
                                                              CircleAvatar(
                                                                backgroundColor:
                                                                    controller
                                                                            .colorList[
                                                                        index],
                                                                child:
                                                                    Image.asset(
                                                                  AllAssets
                                                                      .quickLinkPL,
                                                                  scale: displayWidth(context) > 500
                                                                      ? displayHeight(
                                                                              context) /
                                                                          250
                                                                      : displayWidth(
                                                                              context) /
                                                                          101.5,
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                width: displayWidth(
                                                                            context) >
                                                                        700
                                                                    ? getWidgetWidth(
                                                                        width:
                                                                            3)
                                                                    : getWidgetWidth(
                                                                        width:
                                                                            10),
                                                              ),
                                                              Text(
                                                                  controller.selectedIndex ==
                                                                          1
                                                                      ? controller
                                                                          .vowelSoundsList[
                                                                              index]
                                                                          .category
                                                                          .split(
                                                                              ':')
                                                                          .last
                                                                          .trim()
                                                                      : controller
                                                                          .consonantSoundsList[
                                                                              index]
                                                                          .category
                                                                          .split(
                                                                              ':')
                                                                          .last
                                                                          .trim(),
                                                                  style:
                                                                      TextStyle(
                                                                    fontFamily:
                                                                        Keys.fontFamily,
                                                                    letterSpacing:
                                                                        0,
                                                                  )),
                                                            ],
                                                          ),
                                                          Spacer(),
                                                          IconButton(
                                                              onPressed: () {},
                                                              icon: Icon(
                                                                Icons
                                                                    .expand_more,
                                                                color: Color(
                                                                    0xFF64748B),
                                                              ))
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              if (controller.expandedIndex > -1)

                                                // Expandable Section
                                                AnimatedCrossFade(
                                                  duration: const Duration(
                                                      milliseconds: 300),
                                                  firstChild:
                                                      const SizedBox.shrink(),
                                                  secondChild: ListView.builder(
                                                    shrinkWrap: true,
                                                    physics:
                                                        const NeverScrollableScrollPhysics(),
                                                    itemCount: controller
                                                                .selectedIndex ==
                                                            1
                                                        ? controller
                                                            .vowelSoundsList[
                                                                controller
                                                                    .expandedIndex]
                                                            .subcategories
                                                            .length
                                                        : controller
                                                            .consonantSoundsList[
                                                                controller
                                                                    .expandedIndex]
                                                            .subcategories
                                                            .length,
                                                    itemBuilder:
                                                        (context, index) {
                                                      final sub = controller
                                                                  .selectedIndex ==
                                                              1
                                                          ? controller
                                                                  .vowelSoundsList[
                                                                      controller
                                                                          .expandedIndex]
                                                                  .subcategories[
                                                              index]
                                                          : controller
                                                              .consonantSoundsList[
                                                                  controller
                                                                      .expandedIndex]
                                                              .subcategories[index];
                                                      return Column(
                                                        children: [
                                                          Padding(
                                                            padding: EdgeInsets.symmetric(
                                                                vertical:
                                                                    getWidgetHeight(
                                                                        height:
                                                                            3),
                                                                horizontal:
                                                                    getWidgetWidth(
                                                                        width:
                                                                            15)),
                                                            child: InkWell(
                                                              onTap: () {
                                                                activityName =
                                                                    "Sound Lab";
                                                                sessionName =
                                                                    sub.name;
                                                                log("${sessionName} session name is printing here");
                                                                addToRecentHistory(
                                                                  path:
                                                                      "Language Lab > $mainCategoryTitle > $subCategoryTitle",
                                                                  category:
                                                                      sessionName,
                                                                  section:
                                                                      "Sound Lab",
                                                                  link: "",
                                                                  proLabTitle:
                                                                      "",
                                                                  soundSubcategory:
                                                                      sub,
                                                                );
                                                                GetStorage().write(
                                                                    AppRoutes
                                                                        .soundPage,
                                                                    {
                                                                      "title": sub
                                                                          .name,
                                                                      "soundModel":
                                                                          sub,
                                                                    });
                                                                WidgetsBinding
                                                                    .instance
                                                                    .addPostFrameCallback(
                                                                        (_) {
                                                                  kIsWeb
                                                                      ? Get
                                                                          .rootDelegate
                                                                          .offNamed(
                                                                          AppRoutes
                                                                              .soundPage,
                                                                          arguments: {
                                                                            "title":
                                                                                sub.name,
                                                                            "soundModel":
                                                                                sub,
                                                                          },
                                                                        )
                                                                      : Get.toNamed(
                                                                          AppRoutes
                                                                              .soundPage,
                                                                          arguments: {
                                                                              "title": sub.name,
                                                                              "soundModel": sub,
                                                                            });
                                                                });
                                                              },
                                                              child: Container(
                                                                padding: const EdgeInsets
                                                                    .symmetric(
                                                                    horizontal:
                                                                        12),
                                                                child: Row(
                                                                  children: [
                                                                    Text(
                                                                      sub.name,
                                                                      style:
                                                                          TextStyle(
                                                                        letterSpacing:
                                                                            0,
                                                                        color: Colors
                                                                            .black,
                                                                        fontWeight:
                                                                            FontWeight.w500,
                                                                        fontFamily:
                                                                            Keys.lucidaFontFamily,
                                                                        fontSize:
                                                                            kText.scale(15),
                                                                      ),
                                                                    ),
                                                                    const Spacer(),
                                                                    const Icon(
                                                                      Icons
                                                                          .chevron_right_rounded,
                                                                      size: 30,
                                                                      color: Color
                                                                          .fromARGB(
                                                                              45,
                                                                              82,
                                                                              82,
                                                                              82),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          const Divider(
                                                              color: Color
                                                                  .fromARGB(
                                                                      45,
                                                                      82,
                                                                      82,
                                                                      82)),
                                                        ],
                                                      );
                                                    },
                                                  ),
                                                  crossFadeState: isExpanded
                                                      ? CrossFadeState
                                                          .showSecond
                                                      : CrossFadeState
                                                          .showFirst,
                                                ),
                                              if (index ==
                                                  (controller.selectedIndex == 1
                                                      ? controller
                                                              .vowelSoundsList
                                                              .length -
                                                          1
                                                      : controller
                                                              .consonantSoundsList
                                                              .length -
                                                          1))
                                                SizedBox(
                                                    height: getWidgetHeight(
                                                        height: 45))
                                            ],
                                          );
                                        },
                                      ),
                                    ),
                                  )
                                : Center(
                                    child: Text("No Data"),
                                  ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ================= HEADER =================
  Widget _pageHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Language Lab",
          style: GoogleFonts.inter(
            fontSize: 28,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          "Practice pronunciation, grammar and sentence construction",
          style: GoogleFonts.inter(
            fontSize: 14,
            color: Colors.grey.shade600,
          ),
        ),
      ],
    );
  }

  // ================= CATEGORY GRID =================
  Widget _categoryGrid(BuildContext context, LanguageLabController controller) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: MediaQuery.of(context).size.width > 1200 ? 4 : 2,
      crossAxisSpacing: 20,
      mainAxisSpacing: 20,
      childAspectRatio: 1.55,
      children: [
        _categoryCard(controller,
            title: "English Pronunciation",
            image: AllAssets.pePl,
            color: const Color(0xFF398480),
            keyName: "english_lab",
            route: AppRoutes.pronunciationLab),
        _categoryCard(controller,
            title: "French Pronunciation",
            image: AllAssets.peScl,
            color: const Color(0xFF445EA9),
            keyName: "french_lab",
            route: AppRoutes.pronunciationLab),
        _categoryCard(controller,
            title: "Sentence Lab",
            image: AllAssets.peCfpl,
            color: const Color(0xFF636CFF),
            keyName: "sentence_lab",
            route: AppRoutes.sentenceLab),
        _categoryCard(controller,
            title: "Grammer Lab",
            image: AllAssets.peGl,
            color: const Color(0xFFDC6379),
            keyName: "grammer_lab",
            route: AppRoutes.grmmaerLab),
      ],
    );
  }

  Widget _categoryCard(
    LanguageLabController controller, {
    required String title,
    required String image,
    required Color color,
    required String keyName,
    required String route,
  }) {
    return PETopCategoriesCard(
      title: title,
      imageUrl: image,
      cardColor: color,
      isUnderConstruction: !controller.isLabActive(keyName),
      onTap: () {
        if (!controller.isLabActive(keyName)) {
          controller.showReviewPopup(Get.context!);
          return;
        }

        mainCategoryTitle = title;
        GetStorage().write(route, {"title": title});
        kIsWeb
            ? Get.rootDelegate.offNamed(route, arguments: {"title": title})
            : Get.toNamed(route, arguments: {"title": title});
      },
    );
  }

  // ================= SOUND CARD =================
  Widget _soundSectionCard({
    required String title,
    required Widget child,
  }) {
    return Container(
      height: _soundCardHeight,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFEDEDED)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style:
                  GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w600)),
          const SizedBox(height: 12),
          const Divider(height: 1),
          const SizedBox(height: 8),
          Expanded(child: child),
        ],
      ),
    );
  }

  // ================= IMPORTANT SOUNDS =================
  Widget _importantSounds(LanguageLabController controller) {
    return ListView.separated(
      itemCount: controller.importantSound?.subcategories.length ?? 0,
      separatorBuilder: (_, __) => const Divider(color: Color(0xFFEDEDED)),
      itemBuilder: (context, index) {
        final item = controller.importantSound!.subcategories[index];

        return _soundTile(
          title: item.name,
          color: linearColor, // ✅ ONLY important sounds
          onTap: () {
            activityName = "Sound Lab";
            subCategoryTitle = item.name;

            addToRecentHistory(
              path: "Language Lab > Important Sounds",
              category: item.name,
              section: "Sound Lab",
              link: "",
              proLabTitle: "",
              soundSubcategory: item,
            );

            GetStorage().write(
              AppRoutes.soundPage,
              {"title": item.name, "soundModel": item},
            );

            kIsWeb
                ? Get.rootDelegate.offNamed(AppRoutes.soundPage,
                    arguments: {"title": item.name, "soundModel": item})
                : Get.toNamed(AppRoutes.soundPage,
                    arguments: {"title": item.name, "soundModel": item});
          },
        );
      },
    );
  }

  // ================= EXPANDABLE =================
  Widget _expandableSounds(
    LanguageLabController controller,
    List list, {
    required bool isVowel,
  }) {
    return ListView.separated(
      itemCount: list.length,
      separatorBuilder: (_, __) => const Divider(color: Color(0xFFEDEDED)),
      itemBuilder: (context, index) {
        final isExpanded = isVowel
            ? controller.expandedVowelIndex == index
            : controller.expandedConsonantIndex == index;

        final sectionColor = controller.colorList[index];

        return Column(
          children: [
            _soundTile(
              title: list[index].category,
              color: sectionColor,
              trailing: Icon(isExpanded
                  ? Icons.keyboard_arrow_up
                  : Icons.keyboard_arrow_down),
              onTap: () {
                if (isVowel) {
                  controller.expandedVowelIndex = isExpanded ? -1 : index;
                } else {
                  controller.expandedConsonantIndex = isExpanded ? -1 : index;
                }
                controller.update();
              },
            ),
            if (isExpanded)
              ...list[index].subcategories.map<Widget>((sub) {
                return Padding(
                  padding: const EdgeInsets.only(left: 28),
                  child: _soundTile(
                    title: sub.name,
                    color: sectionColor.withOpacity(0.35),
                    onTap: () {
                      activityName = "Sound Lab";
                      sessionName = sub.name;

                      addToRecentHistory(
                        path: "Language Lab > ${sub.name}",
                        category: sub.name,
                        section: "Sound Lab",
                        link: "",
                        proLabTitle: "",
                        soundSubcategory: sub,
                      );

                      GetStorage().write(
                        AppRoutes.soundPage,
                        {
                          "title": sub.name,
                          "soundModel": sub,
                        },
                      );

                      kIsWeb
                          ? Get.rootDelegate.offNamed(AppRoutes.soundPage,
                              arguments: {"title": sub.name, "soundModel": sub})
                          : Get.toNamed(AppRoutes.soundPage, arguments: {
                              "title": sub.name,
                              "soundModel": sub
                            });
                    },
                  ),
                );
              }).toList(),
          ],
        );
      },
    );
  }

  // ================= TILE =================
  Widget _soundTile({
    required String title,
    required VoidCallback onTap,
    required Color color,
    Widget? trailing,
  }) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: InkWell(
        hoverColor: linearColor.withOpacity(.06),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Row(
            children: [
              CircleAvatar(
                radius: 16,
                backgroundColor: color,
                child: const Text(
                  "En",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(child: Text(title)),
              trailing ??
                  const Icon(Icons.chevron_right, color: Color(0xFF94A3B8)),
              const SizedBox(width: 30),
            ],
          ),
        ),
      ),
    );
  }
}
