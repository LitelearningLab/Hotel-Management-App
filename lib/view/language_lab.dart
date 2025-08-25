import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hotelmanagementapp/controller/home_controller.dart';
import 'package:hotelmanagementapp/controller/language_lab_controller.dart';
import 'package:hotelmanagementapp/public/all_asset.dart';
import 'package:hotelmanagementapp/public/common_function.dart';
import 'package:hotelmanagementapp/public/constant.dart';
import 'package:hotelmanagementapp/public/keys.dart';
import 'package:hotelmanagementapp/route/route_name.dart';
import 'package:hotelmanagementapp/utility/custome_bottom_navigation.dart';
import 'package:hotelmanagementapp/utility/pe_top_categories_card.dart';

class Languagelab extends StatelessWidget {
  const Languagelab({super.key});

  @override
  Widget build(BuildContext context) {
    HomeController homeController = Get.put(HomeController());
    return PopScope(
      onPopInvoked: (didpop) {
        homeController.loadRecentHistory();
      },
      child: Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: Align(
          alignment: Alignment.bottomCenter,
          child: CustomeBottomNavigation(),
        ),
        appBar: AppBar(
          forceMaterialTransparency: true,
          backgroundColor: Colors.white,
          titleSpacing: 0,
          title: Text(
            "Langauge Lab",
            textAlign: TextAlign.left,
            style: GoogleFonts.inter(
              fontWeight: FontWeight.w600,
              fontSize: 20,
              color: Colors.black,
            ),
          ),
          leading: Padding(
            padding: EdgeInsets.symmetric(vertical: getWidgetHeight(height: 8)),
            child: IconButton(
              iconSize: 30,
              onPressed: () {
                homeController.loadRecentHistory();
                Navigator.pop(context);
              },
              icon: const Icon(Icons.arrow_back),
            ),
          ),
        ),
        body: SafeArea(
          child: GetBuilder<LanguageLabController>(builder: (controller) {
            return controller.isLoading
                ? Center(
                    child: CircularProgressIndicator(
                      color: linearColor,
                    ),
                  )
                : ListView(
                    // padding: const EdgeInsets.all(20),
                    children: [
                      // Grid View inside a fixed height
                      GridView.count(
                        crossAxisCount: 2,
                        shrinkWrap: true,
                        padding: EdgeInsets.symmetric(
                            horizontal: getWidgetHeight(height: 20)),
                        physics:
                            const NeverScrollableScrollPhysics(), // prevent inner scrolling
                        crossAxisSpacing: getWidgetWidth(width: 10),
                        mainAxisSpacing: getWidgetHeight(height: 10),
                        childAspectRatio:
                            1, // Adjust as needed for height/width
                        children: [
                          PETopCategoriesCard(
                            height: getWidgetHeight(height: 88.28),
                            width: getWidgetWidth(width: 96.11),
                            title: 'English Pronunciation',
                            imageUrl: AllAssets.pePl,
                            onTap: () async {
                              mianCategoryTitile = 'English Pronunciation';
                              Get.toNamed(AppRoutes.pronunciationLab,
                                  arguments: {
                                    "title": "English Pronunciation"
                                  });
                            },
                            cardColor: Color(0xFF398480),
                          ),
                          PETopCategoriesCard(
                            height: getWidgetHeight(height: 88.47),
                            width: getWidgetWidth(width: 103.76),
                            title: 'French Pronunciation',
                            imageUrl: AllAssets.peScl,
                            onTap: () async {
                              mianCategoryTitile = 'French Pronunciation';
                              Get.toNamed(AppRoutes.pronunciationLab,
                                  arguments: {"title": "French Pronunciation"});
                            },
                            cardColor: Color(0xFF445EA9),
                          ),
                          PETopCategoriesCard(
                            height: getWidgetHeight(height: 88.65),
                            width: getWidgetWidth(width: 106.03),
                            title: 'Sentence Lab',
                            imageUrl: AllAssets.peCfpl,
                            onTap: () async {
                              mianCategoryTitile = 'Sentence Lab';
                              Get.toNamed(AppRoutes.sentenceLab,
                                  arguments: {"title": "Sentence Lab"});
                            },
                            cardColor: Color(0xFF636CFF),
                          ),
                          PETopCategoriesCard(
                            height: getWidgetHeight(height: 88),
                            width: getWidgetWidth(width: 130.04),
                            title: 'Grammer Lab',
                            imageUrl: AllAssets.peGl,
                            onTap: () {
                              mianCategoryTitile = 'Grammer Lab';
                              Get.toNamed(AppRoutes.grmmaerLab,
                                  arguments: {"title": "Grammer Lab"});
                            },
                            cardColor: Color(0xFFDC6379),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: getWidgetHeight(height: 20),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: getWidgetHeight(height: 20)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              'Sounds',
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w600,
                                fontFamily: 'Roboto',
                                letterSpacing: 0,
                                fontSize: 18,
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
                                  width: getWidgetWidth(width: 80),
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
                                  splashBorderRadius: BorderRadius.circular(30),
                                  enableFeedback: false,
                                  indicatorPadding:
                                      EdgeInsets.symmetric(vertical: 5),
                                  onTap: (index) {
                                    mianCategoryTitile = index == 0
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
                                          color:
                                              controller.selectedIndex == index
                                                  ? Colors.transparent
                                                  : Colors.white,
                                          boxShadow: controller.selectedIndex ==
                                                  index
                                              ? []
                                              : [
                                                  BoxShadow(
                                                    color: Colors.black
                                                        .withOpacity(0.15),
                                                    blurRadius: 6,
                                                    offset: const Offset(0, 3),
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
                                              color: controller.selectedIndex ==
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
                          )
                        ],
                      ),
                      controller.selectedIndex == 0
                          ? SizedBox(
                              height: getWidgetHeight(height: 255),
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
                                              mianCategoryTitile =
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
                                              Get.toNamed(AppRoutes.soundPage,
                                                  arguments: {
                                                    "title": controller
                                                        .importantSound!
                                                        .subcategories[index]
                                                        .name,
                                                    "soundModel": controller
                                                        .importantSound!
                                                        .subcategories[index]
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
                                                      fontFamily:
                                                          Keys.lucidaFontFamily,
                                                      fontSize: kText.scale(15),
                                                    ),
                                                  ),
                                                  const Spacer(),
                                                  const Icon(
                                                    Icons.chevron_right_rounded,
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
                                          color: Color.fromARGB(45, 82, 82, 82),
                                        ),
                                      ],
                                    );
                                  },
                                ),
                              ),
                            )
                          : ((controller.selectedIndex == 1) ||
                                  (controller.selectedIndex == 2))
                              ? SizedBox(
                                  height: getWidgetHeight(height: 255),
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
                                                        .vowelSoundsList[index]
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
                                                width:
                                                    getWidgetWidth(width: 375),
                                                // height: getWidgetHeight(height: 60),
                                                margin: EdgeInsets.symmetric(
                                                    vertical: getWidgetHeight(
                                                        height: 5),
                                                    horizontal: getWidgetWidth(
                                                        width: 15)),
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(12),
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
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            vertical:
                                                                getWidgetHeight(
                                                                    height: 6),
                                                            horizontal:
                                                                getWidgetWidth(
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
                                                                scale: displayWidth(
                                                                        context) /
                                                                    101.5,
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              width:
                                                                  getWidgetWidth(
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
                                                                  fontFamily: Keys
                                                                      .fontFamily,
                                                                  letterSpacing:
                                                                      0,
                                                                )),
                                                          ],
                                                        ),
                                                        Spacer(),
                                                        IconButton(
                                                            onPressed: () {},
                                                            icon: Icon(
                                                              Icons.expand_more,
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
                                                                    "Language Lab > $mianCategoryTitile > $subCategoryTitle",
                                                                category:
                                                                    sessionName,
                                                                section:
                                                                    "Sound Lab",
                                                                link: "",
                                                                proLabTitle: "",
                                                                soundSubcategory:
                                                                    sub,
                                                              );
                                                              Get.toNamed(
                                                                  AppRoutes
                                                                      .soundPage,
                                                                  arguments: {
                                                                    "title": sub
                                                                        .name,
                                                                    "soundModel":
                                                                        sub,
                                                                  });
                                                            },
                                                            child: Container(
                                                              padding:
                                                                  const EdgeInsets
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
                                                                          FontWeight
                                                                              .w500,
                                                                      fontFamily:
                                                                          Keys.lucidaFontFamily,
                                                                      fontSize:
                                                                          kText.scale(
                                                                              15),
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
                                                            color:
                                                                Color.fromARGB(
                                                                    45,
                                                                    82,
                                                                    82,
                                                                    82)),
                                                      ],
                                                    );
                                                  },
                                                ),
                                                crossFadeState: isExpanded
                                                    ? CrossFadeState.showSecond
                                                    : CrossFadeState.showFirst,
                                              )
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
                  );
          }),
        ),
      ),
    );
  }
}
