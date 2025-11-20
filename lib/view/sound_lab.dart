// import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hotelmanagementapp/controller/sound_lab_controller.dart';
import 'package:hotelmanagementapp/model/sound_model.dart';
import 'package:hotelmanagementapp/public/all_asset.dart';
import 'package:hotelmanagementapp/public/common_function.dart';
import 'package:hotelmanagementapp/public/constant.dart';
import 'package:hotelmanagementapp/public/keys.dart';
import 'package:hotelmanagementapp/public/size_helpers.dart';
import 'package:hotelmanagementapp/public/spacing.dart';
import 'package:hotelmanagementapp/route/route_name.dart';
import 'package:hotelmanagementapp/utility/custome_bottom_navigation.dart';

class SoundLab extends StatefulWidget {
  const SoundLab({super.key});

  @override
  State<SoundLab> createState() => _SoundLabState();
}

class _SoundLabState extends State<SoundLab> {
  int expandedIndex = -1;
  @override
  Widget build(BuildContext context) {
    return GetBuilder<SoundLabController>(builder: (controller) {
      return Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: Align(
          alignment: Alignment.bottomCenter,
          child: !controller.isSearching ? CustomeBottomNavigation() : null,
        ),
        appBar: AppBar(
          forceMaterialTransparency: true,
          surfaceTintColor: Colors.white,
          shadowColor: Colors.white,
          backgroundColor: Colors.white,
          titleSpacing: 0,
          title: controller.isSearching
              ? TextField(
                  cursorColor: Colors.grey,
                  controller: controller.searchController,
                  autofocus: true,
                  decoration: InputDecoration(
                    hintText: 'Search...',
                    border: InputBorder.none,
                    hintStyle: TextStyle(color: Colors.grey),
                  ),
                  onChanged: (value) {
                    controller.searchSubcategories(value); // Your search logic
                  },
                )
              : Padding(
                  padding: EdgeInsets.only(right: getWidgetWidth(width: 12)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Flexible(
                        child: Text(
                          controller.soundSubcategory.name,
                          maxLines: 2,
                          style: TextStyle(
                            fontSize: kText
                                .scale(displayWidth(context) > 700 ? 20 : 18),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      // Spacer(),
                      kIsWeb
                          ? Spacer()
                          : SizedBox(
                              width: 5,
                            ),
                      SizedBox(
                        width: getWidgetWidth(width: 30),
                        child: IconButton(
                          splashColor: Colors.transparent,
                          color: Colors.transparent,
                          focusColor: Colors.transparent,
                          disabledColor: Colors.transparent,
                          hoverColor: Colors.transparent,
                          highlightColor: Colors.transparent,
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
                            height: 35,
                            // width: 25,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      SizedBox(
                        width: getWidgetWidth(width: 30),
                        child: IconButton(
                          splashColor: Colors.transparent,
                          color: Colors.transparent,
                          focusColor: Colors.transparent,
                          disabledColor: Colors.transparent,
                          hoverColor: Colors.transparent,
                          highlightColor: Colors.transparent,
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
                            height: 35,
                            // width: 25,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
          leading: IconButton(
            onPressed: () {
              if (controller.isSearching) {
                controller.isSearching = false;
                controller.searchController.clear();
                controller.clearSearch();
                controller.update();
              } else {
                final box = GetStorage();
                final saved = box.read(AppRoutes.soundPage) ?? {};

                late SoundSubcategory soundModel;
                final storedSound = saved['soundModel'];
                if (storedSound is Map<String, dynamic>) {
                  soundModel = SoundSubcategory.fromJson(storedSound);
                } else if (storedSound is SoundSubcategory) {
                  soundModel = storedSound;
                }
                kIsWeb
                    ? Get.rootDelegate
                        .offNamed(AppRoutes.soundPage, arguments: {
                        'title': saved['title'] ?? "Sound Page",
                        'soundModel': soundModel,
                      })
                    : Navigator.pop(context);
              }
            },
            icon: const Icon(Icons.arrow_back),
          ),
          actions: [
            SizedBox(
              width: getWidgetWidth(width: 30),
              child: PopupMenuButton<String>(
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
                itemBuilder: (BuildContext context) => [
                  PopupMenuItem<String>(
                    value: 'search',
                    child: Text(
                      'Search',
                      style: TextStyle(
                        fontWeight: controller.selectedMenuOption == 'search'
                            ? FontWeight.w600
                            : FontWeight.normal,
                        color: controller.selectedMenuOption == 'search'
                            ? Colors.black
                            : Colors.grey[800],
                      ),
                    ),
                  ),
                  if (!kIsWeb)
                    PopupMenuItem<String>(
                      value: 'priority',
                      child: Text(
                        'Filter Priority',
                        style: TextStyle(
                          fontWeight:
                              controller.selectedMenuOption == 'priority'
                                  ? FontWeight.w600
                                  : FontWeight.normal,
                          color: controller.selectedMenuOption == 'priority'
                              ? Colors.black
                              : Colors.grey[800],
                        ),
                      ),
                    ),
                  if (!kIsWeb)
                    PopupMenuItem<String>(
                      value: 'all_priority',
                      child: Text(
                        'Clear Filter',
                        style: TextStyle(
                          fontWeight: FontWeight.normal,
                          color: Colors.grey[800],
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
        body: controller.isLoading
            ? Center(
                child: CircularProgressIndicator(
                  color: linearColor,
                ),
              )
            : Stack(
                children: [
                  ListView.builder(
                    controller: controller.scrollController,
                    padding: EdgeInsets.symmetric(
                        vertical: getWidgetHeight(height: 10),
                        horizontal: getWidgetWidth(width: 10)),
                    itemCount: controller.soundsPractice?.length,
                    itemBuilder: (context, index) {
                      final isExpanded = controller.expandedIndex == index;
                      final soundPractice = controller.soundsPractice![index];

                      return Column(
                        children: [
                          GestureDetector(
                            onTap: () {
                              controller.expandedIndex =
                                  isExpanded ? -1 : index;
                              controller.update();
                            },
                            child: Container(
                              width: getWidgetWidth(width: 375),
                              // height: getWidgetHeight(height: 60),
                              margin: const EdgeInsets.symmetric(vertical: 5),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    offset: const Offset(0, 4),
                                    blurRadius: 10,
                                  ),
                                ],
                              ),
                              child: Container(
                                width: getWidgetWidth(width: 375),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: Colors.white,
                                ),
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: displayWidth(context) > 500
                                          ? displayHeight(context) * 0.02
                                          : getWidgetHeight(height: 6),
                                      horizontal: displayWidth(context) > 500
                                          ? displayWidth(context) * 0.01
                                          : getWidgetWidth(width: 10)),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          (controller.currentlyPlayingIndex ==
                                                  index
                                              //      &&
                                              // controller.isPlaying
                                              )
                                              ? InkWell(
                                                  onTap: () {
                                                    controller
                                                        .handlePlayPause(index);
                                                  },
                                                  child: Icon(
                                                    Icons.pause_circle_outline,
                                                    color: linearColor,
                                                    size: 26,
                                                  ),
                                                )
                                              : controller.errorPlaying == index
                                                  ? GestureDetector(
                                                      onTap: () {
                                                        controller
                                                            .handlePlayPause(
                                                                index);
                                                      },
                                                      child: Icon(
                                                        Icons.info_outline,
                                                        color: Colors.red,
                                                        size: 25,
                                                      ),
                                                    )
                                                  : GestureDetector(
                                                      onTap: () {
                                                        controller
                                                            .handlePlayPause(
                                                                index);
                                                      },
                                                      child: controller
                                                                  .playingIs ==
                                                              index
                                                          ? SizedBox(
                                                              height: getWidgetHeight(
                                                                  height:
                                                                      displayWidth(context) >
                                                                              500
                                                                          ? 20
                                                                          : 20),
                                                              width: getWidgetWidth(
                                                                  width:
                                                                      displayWidth(context) >
                                                                              500
                                                                          ? 5
                                                                          : 22),
                                                              child:
                                                                  CircularProgressIndicator(
                                                                strokeWidth:
                                                                    2.0,
                                                                color:
                                                                    linearColor,
                                                              ),
                                                            )
                                                          : ImageIcon(
                                                              const AssetImage(
                                                                  AllAssets
                                                                      .roundPlay),
                                                              color:
                                                                  linearColor,
                                                            ),
                                                    ),
                                          SizedBox(
                                            width: getWidgetWidth(
                                                width:
                                                    displayWidth(context) > 500
                                                        ? 4
                                                        : 10),
                                          ),
                                          Text(soundPractice.text,
                                              style: TextStyle(
                                                fontFamily: Keys.fontFamily,
                                                letterSpacing: 0,
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
                                              ? SizedBox(
                                                  height: getWidgetHeight(
                                                      height: 20),
                                                  width:
                                                      getWidgetWidth(width: 19),
                                                )
                                              : IconButton(
                                                  onPressed: () {
                                                    controller
                                                        .saveUpdate(index);
                                                  },
                                                  icon: SizedBox(
                                                    // width: displayWidth(context) / 18.75,
                                                    // height: displayHeight(context) / 40.6,
                                                    height: getWidgetHeight(
                                                        height: 19),
                                                    width: getWidgetWidth(
                                                        width: 19),
                                                    child: controller
                                                                .isSaving ==
                                                            index
                                                        ? SizedBox(
                                                            height:
                                                                getWidgetHeight(
                                                                    height: 19),
                                                            width:
                                                                getWidgetWidth(
                                                                    width: 19),
                                                            child:
                                                                CircularProgressIndicator(
                                                              strokeWidth: 2.0,
                                                              color:
                                                                  linearColor,
                                                            ),
                                                          )
                                                        : Image.asset(
                                                            AllAssets.save,
                                                            width: 18,
                                                            color: controller
                                                                        .isPriorityList[
                                                                    index]
                                                                ? linearColor
                                                                : Colors.black,
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

                          // Expandable Section
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.fastOutSlowIn,
                            width: double.infinity,
                            child: isExpanded
                                ? Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: getWidgetWidth(width: 15),
                                      vertical: getWidgetHeight(height: 10),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "IPA",
                                          style: GoogleFonts.inter(
                                              fontWeight: FontWeight.w400,
                                              fontSize: 12,
                                              color: lightWhite),
                                        ),
                                        SizedBox(
                                          height: getWidgetHeight(height: 6),
                                        ),
                                        RichText(
                                          textAlign: TextAlign.justify,
                                          text: TextSpan(
                                            children: buildTextSpans(
                                                soundPractice.syllables),
                                          ),
                                        ),
                                        SizedBox(
                                          height: getWidgetHeight(height: 20),
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "PRONUNCIATION",
                                                  style: GoogleFonts.inter(
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      fontSize: 12,
                                                      color: lightWhite),
                                                ),
                                                SizedBox(
                                                  height: getWidgetHeight(
                                                      height: 6),
                                                ),
                                                SizedBox(
                                                  width: getWidgetWidth(
                                                      width: 180),
                                                  child: Text(
                                                    soundPractice.pronun == ""
                                                        ? "no data"
                                                        : soundPractice.pronun
                                                            .replaceAll(
                                                                "/", ""),
                                                    maxLines: 2,
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 20,
                                                      fontFamily:
                                                          Keys.fontFamily,
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                            if (!kIsWeb)
                                              GestureDetector(
                                                onTap: () {
                                                  controller.kShowDialog(
                                                      soundPractice.text,
                                                      false,
                                                      context);
                                                },
                                                child: Container(
                                                  width: getWidgetWidth(
                                                      width: 130),
                                                  height: getWidgetHeight(
                                                      height: 45),
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8),
                                                    color: Colors.white,
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
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceAround,
                                                    children: [
                                                      const Icon(
                                                        Icons.mic,
                                                        color: Color.fromARGB(
                                                            255, 112, 112, 112),
                                                      ),
                                                      Text(
                                                        "Practice",
                                                        style:
                                                            GoogleFonts.inter(
                                                          color: const Color
                                                              .fromARGB(255,
                                                              112, 112, 112),
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          fontSize: 16,
                                                        ),
                                                      ),
                                                      const SizedBox()
                                                    ],
                                                  ),
                                                ),
                                              ),
                                          ],
                                        ),
                                        if (controller.selectedWord
                                                .toLowerCase() ==
                                            soundPractice.text.toLowerCase())
                                          ListTile(
                                            contentPadding: EdgeInsets.zero,
                                            title: Text(
                                              "Pronunciation Analysis Result",
                                              style: TextStyle(
                                                  color: Color(0xFF6C63FF),
                                                  fontSize: kText.scale(13),
                                                  fontFamily: Keys.fontFamily),
                                            ),
                                            subtitle: Text(
                                              "Note: This result only indicates intelligibility and does not confirm the accuracy of pronunciation.",
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: kText.scale(10),
                                                  fontFamily: Keys.fontFamily),
                                            ),
                                            trailing: Icon(
                                              controller.isCorrect
                                                  ? Icons.check_circle
                                                  : Icons.cancel,
                                              color: controller.isCorrect
                                                  ? Colors.green
                                                  : Colors.red,
                                              size: 45,
                                            ),
                                          ),
                                        // SPH(10)
                                      ],
                                    ),
                                  )
                                : const SizedBox.shrink(),
                          ),
                          if (controller
                                  .soundSubcategory.soundsPractice?.length ==
                              index + 1)
                            SizedBox(
                              height: getWidgetHeight(height: 180),
                            )
                        ],
                      );
                    },
                  ),
                  controller.isPlayingOne || controller.isPlayingThree
                      ? Positioned(
                          right: kIsWeb
                              ? displayWidth(context) / 3
                              : displayWidth(context) / 4,
                          child: Container(
                            width: kIsWeb
                                ? getWidgetWidth(width: 120)
                                : getWidgetWidth(width: 180),
                            height: kIsWeb
                                ? getWidgetHeight(height: 55)
                                : getWidgetHeight(height: 50),
                            decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.3),
                                    offset: const Offset(0, 4),
                                    blurRadius: 10,
                                  ),
                                ],
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(30)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.only(left: 15, top: 5),
                                  child: Image.asset(
                                    controller.isPlayingOne
                                        ? AllAssets.playOne
                                        : controller.isPlayingThree
                                            ? AllAssets.playThree
                                            : "",
                                    // height: 30,
                                    width: 30,
                                  ),
                                ),
                                InkWell(
                                    splashColor: Colors.transparent,
                                    focusColor: Colors.transparent,
                                    hoverColor: Colors.transparent,
                                    highlightColor: Colors.transparent,
                                    onTap: () {
                                      controller.isPaused =
                                          !controller.isPaused;
                                      controller.update();
                                    },
                                    child: Icon(
                                        controller.isPaused
                                            ? Icons.play_arrow
                                            : Icons.pause,
                                        color: Color(0XFF34425D),
                                        size: 30)),
                                IconButton(
                                    disabledColor: Colors.transparent,
                                    color: Colors.transparent,
                                    splashColor: Colors.transparent,
                                    focusColor: Colors.transparent,
                                    hoverColor: Colors.transparent,
                                    highlightColor: Colors.transparent,
                                    onPressed: () {
                                      controller.isPlayingOne = false;
                                      controller.isPlayingThree = false;
                                      controller.isCancelled = true;
                                      controller.stopAllPlaying();
                                      controller.update();
                                    },
                                    icon: Icon(
                                      Icons.stop,
                                      color: Color(0XFF34425D),
                                      size: 30,
                                    )),
                              ],
                            ),
                          ),
                        )
                      : SizedBox.shrink()
                ],
              ),
      );
    });
  }
}
