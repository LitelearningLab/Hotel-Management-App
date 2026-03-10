import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hotelmanagementapp/controller/pronunciation_lab_sub_controller.dart';
import 'package:hotelmanagementapp/model/category_model.dart';
import 'package:hotelmanagementapp/public/all_asset.dart';
import 'package:hotelmanagementapp/public/common_function.dart';
import 'package:hotelmanagementapp/public/constant.dart';
import 'package:hotelmanagementapp/public/keys.dart';
import 'package:hotelmanagementapp/public/size_helpers.dart';
import 'package:hotelmanagementapp/public/spacing.dart';
import 'package:hotelmanagementapp/route/route_name.dart';
import 'package:hotelmanagementapp/utility/boom_menu.dart';

import 'package:hotelmanagementapp/utility/boom_menu_item.dart' as bm;
import 'package:hotelmanagementapp/utility/custome_bottom_navigation.dart';
import 'package:hotelmanagementapp/view/home.dart';

import '../utility/boom_menu_item.dart';
import '../utility/boom_menu_item.dart';

class PronunciationLabSub extends StatefulWidget {
  const PronunciationLabSub({super.key});

  @override
  State<PronunciationLabSub> createState() => _PronunciationLabSubState();
}

class _PronunciationLabSubState extends State<PronunciationLabSub> {
  @override
  void initState() {
    startTimerMainCategory("");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double isKwidth = MediaQuery.of(context).size.width;
    return GetBuilder<PronunciationLabSubController>(builder: (controller) {
      return PopScope(
        onPopInvoked: (didPop) {
          subCategoryTitle = controller.title;
          activityName = "Pronunciation Lab";
          mianCategoryTitile = controller.mainCategoryTitle;
          timestampIndex = controller.index;
          stopTimerMainCategory();
        },
        child: Scaffold(
          // bottomNavigationBar: CustomeBottomNavigation(),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          floatingActionButton: Align(
            alignment: Alignment.bottomCenter,
            child: kIsWeb ? null : CustomeBottomNavigation(),
          ),
          appBar: AppBar(
            forceMaterialTransparency: true,
            surfaceTintColor: Colors.white,
            shadowColor: Colors.white,
            backgroundColor: Colors.white,
            titleSpacing: 0,
            title: controller.isSearching
                ? Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 50),
                    child: SizedBox(
                      height: 44,
                      child: TextField(
                        controller: controller.searchController,
                        autofocus: true,
                        cursorColor: Colors.black,
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                        ),
                        decoration: InputDecoration(
                          hintText: 'Search...',
                          hintStyle: TextStyle(
                            color: Colors.grey.shade500,
                            fontSize: 14,
                          ),

                          /// 🔍 Left icon
                          prefixIcon: const Icon(
                            Icons.search,
                            size: 18,
                            color: Colors.grey,
                          ),

                          /// ❌ Clear button
                          suffixIcon:
                              controller.searchController.text.isNotEmpty
                                  ? IconButton(
                                      icon: const Icon(
                                        Icons.close,
                                        size: 18,
                                        color: Colors.grey,
                                      ),
                                      onPressed: () {
                                        controller.searchController.clear();
                                        controller.clearSearch();
                                        controller.update();
                                      },
                                    )
                                  : null,

                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 10),

                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                              color: Color(0xFFE0E0E0),
                              width: 1,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                              color: Colors.black54,
                              width: 1.2,
                            ),
                          ),
                        ),
                        onChanged: (value) {
                          controller.searchSubcategories(value);
                          controller.update();
                        },
                      ),
                    ),
                  )
                : Container(
                    height: 56,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: const Color(0xFFEDEDED)),
                    ),
                    child: Row(
                      children: [
                        /// ---------------- LEFT: BACK / CLOSE ----------------
                        IconButton(
                          onPressed: () {
                            if (controller.isSearching) {
                              controller.isSearching = false;
                              controller.searchController.clear();
                              controller.clearSearch();
                              controller.update();
                            } else {
                              subCategoryTitle = controller.title;
                              activityName = "Pronunciation Lab";
                              mianCategoryTitile = controller.mainCategoryTitle;
                              timestampIndex = controller.index;

                              stopTimerMainCategory();
                              if (kIsWeb) {
                                final box = GetStorage();

                                if (controller.id != "") {
                                  final saved = box
                                          .read(AppRoutes.frontOfficeStoreKey) ??
                                      {};
                                  Get.rootDelegate.offNamed(
                                    AppRoutes.frontOffice,
                                    arguments: {
                                      'title': saved['title'] ?? "Front Office",
                                      'image': saved['image'],
                                      'index': saved['index'],
                                    },
                                  );
                                } else {
                                  final saved =
                                      box.read(AppRoutes.pronunciationLab) ??
                                          {};
                                  Get.rootDelegate.offNamed(
                                    AppRoutes.pronunciationLab,
                                    arguments: {
                                      'title':
                                          saved['title'] ?? "Pronunciation Lab",
                                    },
                                  );
                                }
                              } else {
                                Navigator.pop(context);
                              }
                            }
                          },
                          icon: Icon(
                            controller.isSearching
                                ? Icons.close
                                : Icons.arrow_back,
                          ),
                        ),

                        const SizedBox(width: 12),

                        /// ---------------- TITLE ----------------
                        Expanded(
                          child: Text(
                            controller.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: kText.scale(isKwidth > 700 ? 20 : 18),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),

                        /// ---------------- RIGHT ACTIONS ----------------
                        Row(
                          children: [
                            /// Play 3 times
                            IconButton(
                              padding: EdgeInsets.zero,
                              onPressed: () {
                                if (controller.isPlayingThree) return;
                                controller.isPlayingThree = true;
                                controller.isPlayingOne = false;
                                controller.playThreeTimes();
                                controller.update();
                              },
                              icon: Image.asset(
                                AllAssets.playThree,
                                height: 32,
                              ),
                            ),

                            const SizedBox(width: 8),

                            /// Play once
                            IconButton(
                              padding: EdgeInsets.zero,
                              onPressed: () {
                                if (controller.isPlayingOne) return;
                                controller.playOneTime();
                                controller.isPlayingOne = true;
                                controller.isPlayingThree = false;
                                controller.update();
                              },
                              icon: Image.asset(
                                AllAssets.playOne,
                                height: 32,
                              ),
                            ),

                            const SizedBox(width: 12),

                            /// MENU
                            kIsWeb
                                ? IconButton(
                                    onPressed: () {
                                      controller.isSearching = true;
                                      controller.update();
                                    },
                                    icon: Icon(Icons.search),
                                  )
                                : PopupMenuButton<String>(
                                    padding: EdgeInsets.zero,
                                    color: Colors.white,
                                    onSelected: (value) {
                                      controller.selectedMenuOption = value;

                                      if (value == 'priority') {
                                        controller.applyDownloadedFilter(true);
                                      } else if (value == 'all_priority') {
                                        controller.applyDownloadedFilter(false);
                                      } else if (value == 'search') {
                                        controller.isSearching = true;
                                      }

                                      controller.update();
                                    },
                                    itemBuilder: (context) => [
                                      PopupMenuItem<String>(
                                        value: 'search',
                                        child: Text(
                                          'Search',
                                          style: TextStyle(
                                            fontWeight:
                                                controller.selectedMenuOption ==
                                                        'search'
                                                    ? FontWeight.w600
                                                    : FontWeight.normal,
                                          ),
                                        ),
                                      ),
                                      if (!kIsWeb)
                                        PopupMenuItem<String>(
                                          value: 'priority',
                                          child: Text(
                                            'Filter Priority',
                                            style: TextStyle(
                                              fontWeight: controller
                                                          .selectedMenuOption ==
                                                      'priority'
                                                  ? FontWeight.w600
                                                  : FontWeight.normal,
                                            ),
                                          ),
                                        ),
                                      if (!kIsWeb)
                                        const PopupMenuItem<String>(
                                          value: 'all_priority',
                                          child: Text('Clear Filter'),
                                        ),
                                    ],
                                  ),
                          ],
                        ),
                      ],
                    ),
                  ),
          ),
          body: controller.isLoading
              ? Center(
                  child: CircularProgressIndicator(
                    color: linearColor,
                  ),
                )
              : Stack(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (controller.subTitle != null ||
                            controller.searchController.text.isNotEmpty)
                          Column(
                            children: [
                              SizedBox(
                                height: getWidgetHeight(height: 10),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: getWidgetWidth(width: 12)),
                                child: RichText(
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                        text: "Results for: ",
                                        style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: kText.scale(10),
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      TextSpan(
                                        text: controller.searchController.text
                                                .isNotEmpty
                                            ? controller.searchController.text
                                            : controller.subTitle,
                                        style: TextStyle(
                                          color: linearColor,
                                          fontSize: kText.scale(11),
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        // if (controller.searchController.text.isNotEmpty)
                        //   Padding(
                        //     padding: EdgeInsets.symmetric(
                        //         horizontal: getWidgetWidth(width: 12)),
                        //     child: Align(
                        //       alignment: Alignment.centerLeft,
                        //       child: Text(
                        //         "Search Results for: ${controller.searchController.text}",
                        //         style: TextStyle(
                        //           fontSize: kText.scale(13),
                        //           fontWeight: FontWeight.w600,
                        //         ),
                        //       ),
                        //     ),
                        //   ),
                        controller.subcategories.isEmpty
                            ? SizedBox(
                                height: getWidgetHeight(height: 550),
                                child: Center(
                                  child: Text(controller
                                          .searchController.text.isNotEmpty
                                      ? "No Search Result Found"
                                      : "No Data Found"),
                                ),
                              )
                            : Expanded(
                                child: Stack(
                                  children: [
                                    ListView.builder(
                                      controller: controller.scrollController,
                                      shrinkWrap: true,
                                      padding: EdgeInsets.symmetric(
                                          vertical: getWidgetHeight(height: 10),
                                          horizontal:
                                              getWidgetWidth(width: 10)),
                                      itemCount:
                                          controller.subcategories.length,
                                      itemBuilder: (context, index) {
                                        final isExpanded =
                                            controller.expandedIndex == index;

                                        return Column(
                                          children: [
                                            _HoverCard(
                                              child: GestureDetector(
                                                onTap: () async {
                                                  // await controller
                                                  //     .scrollToIndex(180);
                                                  controller.expandedIndex =
                                                      isExpanded ? -1 : index;
                                                  controller.update();
                                                },
                                                child: Container(
                                                  width: getWidgetWidth(
                                                      width: 375),
                                                  // height: getWidgetHeight(height: 60),
                                                  margin: const EdgeInsets
                                                      .symmetric(vertical: 5),
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
                                                          vertical: displayWidth(
                                                                      context) >
                                                                  500
                                                              ? displayHeight(
                                                                      context) *
                                                                  0.02
                                                              : getWidgetHeight(
                                                                  height: 6),
                                                          horizontal: displayWidth(
                                                                      context) >
                                                                  500
                                                              ? displayWidth(
                                                                      context) *
                                                                  0.01
                                                              : getWidgetWidth(
                                                                  width: 10)),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Row(
                                                            children: [
                                                              // (controller.loadingIndex == index)
                                                              //     ? SizedBox(
                                                              //         height: getWidgetHeight(
                                                              //             height: 25),
                                                              //         width:
                                                              //             getWidgetWidth(width: 25),
                                                              //         child: Padding(
                                                              //           padding:
                                                              //               const EdgeInsets.all(
                                                              //                   3.0),
                                                              //           child:
                                                              //               CircularProgressIndicator(
                                                              //             strokeWidth: 2,
                                                              //             color: linearColor,
                                                              //           ),
                                                              //         ),
                                                              //       )
                                                              //     :
                                                              (controller.currentlyPlayingIndex ==
                                                                      index
                                                                  //      &&
                                                                  // controller.isPlaying
                                                                  )
                                                                  ? InkWell(
                                                                      onTap:
                                                                          () {
                                                                        controller
                                                                            .handlePlayPause(index);
                                                                      },
                                                                      child:
                                                                          Icon(
                                                                        Icons
                                                                            .pause_circle_outline,
                                                                        color:
                                                                            linearColor,
                                                                        size:
                                                                            26,
                                                                      ),
                                                                    )
                                                                  : controller.errorPlaying ==
                                                                          index
                                                                      ? GestureDetector(
                                                                          onTap:
                                                                              () {
                                                                            controller.handlePlayPause(index);
                                                                          },
                                                                          child:
                                                                              Icon(
                                                                            Icons.info_outline,
                                                                            color:
                                                                                Colors.red,
                                                                            size:
                                                                                25,
                                                                          ),
                                                                        )
                                                                      : GestureDetector(
                                                                          onTap:
                                                                              () {
                                                                            controller.handlePlayPause(index);
                                                                          },
                                                                          child: controller.playingIs == index
                                                                              ? SizedBox(
                                                                                  height: getWidgetHeight(height: displayWidth(context) > 500 ? 20 : 20),
                                                                                  width: getWidgetWidth(width: displayWidth(context) > 500 ? 5 : 22),
                                                                                  child: CircularProgressIndicator(
                                                                                    strokeWidth: 2.0,
                                                                                    color: linearColor,
                                                                                  ),
                                                                                )
                                                                              : ImageIcon(
                                                                                  const AssetImage(AllAssets.roundPlay),
                                                                                  color: linearColor,
                                                                                ),
                                                                        ),
                                                              SizedBox(
                                                                width: getWidgetWidth(
                                                                    width: isKwidth >
                                                                            500
                                                                        ? 2
                                                                        : 10),
                                                              ),
                                                              Text(
                                                                  controller
                                                                      .subcategories[
                                                                          index]
                                                                      .text,
                                                                  style:
                                                                      TextStyle(
                                                                    fontFamily:
                                                                        Keys.fontFamily,
                                                                    letterSpacing:
                                                                        0,
                                                                  )),
                                                            ],
                                                          ),
                                                          Row(
                                                            children: [
                                                              // GestureDetector(
                                                              //   onTap: () {
                                                              //     controller.saveUpdate(index);
                                                              //   },
                                                              //   child: SizedBox(
                                                              //     // width: displayWidth(context) / 18.75,
                                                              //     // height: displayHeight(context) / 40.6,
                                                              //     height: 19,
                                                              //     width: 19,
                                                              //     child: ImageIcon(
                                                              //       AssetImage(AllAssets.download),
                                                              //       color: controller
                                                              //               .isPriorityList[index]
                                                              //           ? linearColor
                                                              //           : Colors.black,
                                                              //       // size: size.height * 0.03,
                                                              //     ),
                                                              //   ),
                                                              // ),
                                                              kIsWeb
                                                                  ? Icon(isExpanded
                                                                      ? Icons
                                                                          .keyboard_arrow_up
                                                                      : Icons
                                                                          .keyboard_arrow_down)
                                                                  : IconButton(
                                                                      onPressed:
                                                                          () {
                                                                        controller
                                                                            .saveUpdate(index);
                                                                      },
                                                                      icon:
                                                                          SizedBox(
                                                                        // width: displayWidth(context) / 18.75,
                                                                        // height: displayHeight(context) / 40.6,
                                                                        height: getWidgetHeight(
                                                                            height:
                                                                                19),
                                                                        width: getWidgetWidth(
                                                                            width:
                                                                                19),
                                                                        child: controller.isSaving ==
                                                                                index
                                                                            ? SizedBox(
                                                                                height: getWidgetHeight(height: 19),
                                                                                width: getWidgetWidth(width: 19),
                                                                                child: CircularProgressIndicator(
                                                                                  strokeWidth: 2.0,
                                                                                  color: linearColor,
                                                                                ),
                                                                              )
                                                                            : Image.asset(
                                                                                AllAssets.save,
                                                                                width: 18,
                                                                                color: controller.isPriorityList[index] ? linearColor : Colors.black,
                                                                              ),
                                                                      ),
                                                                    )
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),

                                            // Expandable Section
                                            AnimatedContainer(
                                              duration: const Duration(
                                                  milliseconds: 300),
                                              curve: Curves.fastOutSlowIn,
                                              width: double.infinity,
                                              child: isExpanded
                                                  ? Padding(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                        horizontal:
                                                            getWidgetWidth(
                                                                width: 15),
                                                        vertical:
                                                            getWidgetHeight(
                                                                height: 10),
                                                      ),
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            "PRONUNCIATION",
                                                            style: GoogleFonts.inter(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                                fontSize: 12,
                                                                color:
                                                                    linearColor),
                                                          ),
                                                          SizedBox(
                                                            height:
                                                                getWidgetHeight(
                                                                    height: 6),
                                                          ),
                                                          SizedBox(
                                                            width:
                                                                getWidgetWidth(
                                                                    width: 180),
                                                            child: Text(
                                                              controller
                                                                          .subcategories[
                                                                              index]
                                                                          .pronun
                                                                          .trim() ==
                                                                      ""
                                                                  ? "no data"
                                                                  : controller
                                                                      .subcategories[
                                                                          index]
                                                                      .pronun
                                                                      .replaceAll(
                                                                          "/",
                                                                          ""),
                                                              maxLines: 2,
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontSize: 20,
                                                                fontFamily: Keys
                                                                    .lucidaFontFamily,
                                                              ),
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            height:
                                                                getWidgetHeight(
                                                                    height: 20),
                                                          ),
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Text(
                                                                    "IPA",
                                                                    style: GoogleFonts.inter(
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .w400,
                                                                        fontSize:
                                                                            12,
                                                                        color:
                                                                            lightWhite),
                                                                  ),
                                                                  SizedBox(
                                                                    height: getWidgetHeight(
                                                                        height:
                                                                            6),
                                                                  ),
                                                                  RichText(
                                                                    textAlign:
                                                                        TextAlign
                                                                            .justify,
                                                                    text:
                                                                        TextSpan(
                                                                      children: buildTextSpans(controller
                                                                          .subcategories[
                                                                              index]
                                                                          .syllables),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                              if (!kIsWeb)
                                                                GestureDetector(
                                                                  onTap: () {
                                                                    controller
                                                                        .stopAllPlaying();
                                                                    controller.kShowDialog(
                                                                        controller
                                                                            .subcategories[index]
                                                                            .text,
                                                                        false,
                                                                        context);
                                                                  },
                                                                  child:
                                                                      Container(
                                                                    width: getWidgetWidth(
                                                                        width:
                                                                            130),
                                                                    height: getWidgetHeight(
                                                                        height:
                                                                            45),
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              8),
                                                                      color: Colors
                                                                          .white,
                                                                      boxShadow: [
                                                                        BoxShadow(
                                                                          color: Colors
                                                                              .black
                                                                              .withOpacity(0.1),
                                                                          offset: const Offset(
                                                                              0,
                                                                              4),
                                                                          blurRadius:
                                                                              10,
                                                                        ),
                                                                      ],
                                                                    ),
                                                                    child: Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .spaceAround,
                                                                      children: [
                                                                        const Icon(
                                                                          Icons
                                                                              .mic,
                                                                          color: Color.fromARGB(
                                                                              255,
                                                                              112,
                                                                              112,
                                                                              112),
                                                                        ),
                                                                        Text(
                                                                          "Practice",
                                                                          style:
                                                                              GoogleFonts.inter(
                                                                            color: const Color.fromARGB(
                                                                                255,
                                                                                112,
                                                                                112,
                                                                                112),
                                                                            fontWeight:
                                                                                FontWeight.w600,
                                                                            fontSize:
                                                                                16,
                                                                          ),
                                                                        ),
                                                                        const SizedBox()
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ),
                                                            ],
                                                          ),
                                                          if (controller
                                                              .subcategories[
                                                                  index]
                                                              .meaningSamples
                                                              .isNotEmpty)
                                                            Column(
                                                              children: [
                                                                SizedBox(
                                                                  height:
                                                                      getWidgetHeight(
                                                                          height:
                                                                              12),
                                                                ),
                                                                SizedBox(
                                                                  height:
                                                                      getWidgetHeight(
                                                                          height:
                                                                              24),
                                                                  child: Text(
                                                                    "ENGLISH MEANING",
                                                                    style: GoogleFonts.inter(
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .w400,
                                                                        fontSize:
                                                                            10,
                                                                        color:
                                                                            lightWhite),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),

                                                          if (controller
                                                              .subcategories[
                                                                  index]
                                                              .meaningSamples
                                                              .isNotEmpty) ...[
                                                            for (var sentence
                                                                in controller
                                                                    .subcategories[
                                                                        index]
                                                                    .meaningSamples)
                                                              Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Text(
                                                                      sentence),
                                                                  Divider(
                                                                    thickness:
                                                                        0.2,
                                                                    color: Colors
                                                                        .black,
                                                                  )
                                                                ],
                                                              )
                                                          ],

                                                          if (controller
                                                              .subcategories[
                                                                  index]
                                                              .sentenceSamples
                                                              .isNotEmpty)
                                                            Column(
                                                              children: [
                                                                SizedBox(
                                                                  height:
                                                                      getWidgetHeight(
                                                                          height:
                                                                              12),
                                                                ),
                                                                SizedBox(
                                                                  height:
                                                                      getWidgetHeight(
                                                                          height:
                                                                              24),
                                                                  child: Text(
                                                                    "SAMPLE SENTENCES",
                                                                    style: GoogleFonts.inter(
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .w400,
                                                                        fontSize:
                                                                            10,
                                                                        color:
                                                                            lightWhite),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),

                                                          if (controller
                                                              .subcategories[
                                                                  index]
                                                              .sentenceSamples
                                                              .isNotEmpty) ...[
                                                            for (var sentence
                                                                in controller
                                                                    .subcategories[
                                                                        index]
                                                                    .sentenceSamples)
                                                              Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  highlightWord(
                                                                      sentence,
                                                                      controller
                                                                          .subcategories[
                                                                              index]
                                                                          .text),
                                                                  Divider(
                                                                    thickness:
                                                                        0.2,
                                                                    color: Colors
                                                                        .black,
                                                                  )
                                                                ],
                                                              )
                                                          ],
                                                          if (controller
                                                                  .selectedWord
                                                                  .toLowerCase() ==
                                                              controller
                                                                  .subcategories[
                                                                      index]
                                                                  .text
                                                                  .toLowerCase())
                                                            ListTile(
                                                              contentPadding:
                                                                  EdgeInsets
                                                                      .zero,
                                                              title: Text(
                                                                "Pronunciation Analysis Result",
                                                                style: TextStyle(
                                                                    color:
                                                                        linearColor,
                                                                    fontSize:
                                                                        13,
                                                                    fontFamily:
                                                                        Keys.fontFamily),
                                                              ),
                                                              subtitle: Text(
                                                                "Note: This result only indicates intelligibility and does not confirm the accuracy of pronunciation.",
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .black,
                                                                    fontSize: kText
                                                                        .scale(
                                                                            12),
                                                                    fontFamily: Keys
                                                                        .fontFamily,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500),
                                                              ),
                                                              trailing:
                                                                  Container(
                                                                height:
                                                                    getWidgetHeight(
                                                                        height:
                                                                            40),
                                                                width:
                                                                    getWidgetWidth(
                                                                        width:
                                                                            40),
                                                                child: Image.asset(controller
                                                                        .isCorrect
                                                                    ? "assets/images/right.png"
                                                                    : "assets/images/wrong.png"),
                                                              ),
                                                            ),
                                                          // SPH(10)
                                                        ],
                                                      ),
                                                    )
                                                  : const SizedBox.shrink(),
                                            ),
                                            if (controller
                                                        .subcategories.length -
                                                    1 ==
                                                index)
                                              SizedBox(
                                                height: getWidgetHeight(
                                                    height: 180),
                                              )
                                          ],
                                        );
                                      },
                                    ),
                                    controller.isPlayingOne ||
                                            controller.isPlayingThree
                                        ? Positioned(
                                            right: displayWidth(context) / 4,
                                            child: Container(
                                              width: getWidgetWidth(width: 180),
                                              height:
                                                  getWidgetHeight(height: 45),
                                              decoration: BoxDecoration(
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Colors.black
                                                          .withOpacity(0.3),
                                                      offset:
                                                          const Offset(0, 4),
                                                      blurRadius: 10,
                                                    ),
                                                  ],
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          30)),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 15, top: 5),
                                                    child: Image.asset(
                                                      controller.isPlayingOne
                                                          ? AllAssets.playOne
                                                          : controller
                                                                  .isPlayingThree
                                                              ? AllAssets
                                                                  .playThree
                                                              : "",
                                                      // height: 30,
                                                      width: 30,
                                                    ),
                                                  ),
                                                  InkWell(
                                                      onTap: () {
                                                        controller.isPaused =
                                                            !controller
                                                                .isPaused;
                                                        controller.update();
                                                      },
                                                      child: Icon(
                                                          controller.isPaused
                                                              ? Icons.play_arrow
                                                              : Icons.pause,
                                                          color:
                                                              Color(0XFF34425D),
                                                          size: 30)),
                                                  IconButton(
                                                      onPressed: () {
                                                        controller
                                                                .isPlayingOne =
                                                            false;
                                                        controller
                                                                .isPlayingThree =
                                                            false;
                                                        controller.isCancelled =
                                                            true;
                                                        controller
                                                            .stopAllPlaying();
                                                        controller.update();
                                                      },
                                                      icon: Icon(
                                                        Icons.stop,
                                                        color:
                                                            Color(0XFF34425D),
                                                        size: 30,
                                                      )),
                                                ],
                                              ),
                                            ),
                                          )
                                        : SizedBox.shrink()
                                  ],
                                ),
                              ),
                      ],
                    ),
                    if (controller.isProcessing)
                      Container(
                        width: displayWidth(context),
                        height: displayHeight(context),
                        decoration: BoxDecoration(
                          color: Colors.white
                              .withOpacity(0.7), // translucent white overlay
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        ),
                        child: Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              CircularProgressIndicator(
                                color: Color(0xFF61B3CA),
                                strokeWidth: 3,
                              ),
                              SizedBox(height: 16),
                              Text(
                                "Analyzing your pronunciation...",
                                style: TextStyle(
                                  color: Colors.black87,
                                  fontFamily: Keys.fontFamily,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
        ),
      );
    });
  }

  Widget highlightWord(String sentence, String targetWord) {
    final words = sentence.split(' ');
    return RichText(
      text: TextSpan(
        children: words.map((word) {
          bool isMatch = word.toLowerCase().replaceAll(RegExp(r'[^\w]'), '') ==
              targetWord.toLowerCase();
          return TextSpan(
            text: "$word ",
            style: TextStyle(
              fontWeight: isMatch ? FontWeight.bold : FontWeight.normal,
              color: linearColor,
              fontSize: kText.scale(14),
            ),
          );
        }).toList(),
      ),
    );
  }

  buildBoomMenu() {
    return Padding(
      padding: EdgeInsets.symmetric(
          vertical: getWidgetHeight(height: 80),
          horizontal: getWidgetWidth(width: 10)),
      child: BoomMenu(
          animatedIcon: AnimatedIcons.menu_close,
          animatedIconTheme: IconThemeData(size: 22.0, color: Colors.white),
          onOpen: () {
            print('OPENING DIAL');
          },
          onClose: () {
            print('DIAL CLOSED');
          },
          backgroundColor: linearColor,
          overlayColor: Colors.grey[400], //Colors.transparent,
          overlayOpacity: 0.9,
          children: [
            bm.MenuItem(
              child: Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: getWidgetWidth(width: 12),
                      vertical: getWidgetHeight(height: 12)),
                  decoration: BoxDecoration(
                      color: Colors.white, shape: BoxShape.circle),
                  child: Image.asset("assets/images/filter.png",
                      color: Colors.grey)),
              title: "Filter Priority",
              titleColor: Colors.white,
              backgroundColor: Colors.transparent,
              onTap: () {},
            ),
            bm.MenuItem(
              child: Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: getWidgetWidth(width: 12),
                      vertical: getWidgetHeight(height: 12)),
                  decoration: BoxDecoration(
                      color: Colors.white, shape: BoxShape.circle),
                  child: Image.asset("assets/images/filter_all.png",
                      color: Colors.grey)),
              title: "Filter All Priority",
              titleColor: Colors.white,
              backgroundColor: Colors.transparent,
              onTap: () {},
            ),
          ]),
    );
  }
}

class _HoverCard extends StatefulWidget {
  final Widget child;
  const _HoverCard({required this.child});

  @override
  State<_HoverCard> createState() => _HoverCardState();
}

class _HoverCardState extends State<_HoverCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    if (!kIsWeb) return widget.child;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOut,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: _hovered
              ? [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 24,
                    offset: const Offset(0, 10),
                  ),
                ]
              : [],
        ),
        child: widget.child,
      ),
    );
  }
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
