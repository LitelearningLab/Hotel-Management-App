import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hotelmanagementapp/controller/pronunciation_lab_controller.dart';
import 'package:hotelmanagementapp/public/all_asset.dart';
import 'package:hotelmanagementapp/public/common_function.dart';
import 'package:hotelmanagementapp/public/constant.dart';
import 'package:hotelmanagementapp/public/keys.dart';
import 'package:hotelmanagementapp/public/size_helpers.dart';
import 'package:hotelmanagementapp/route/route_name.dart';
import 'package:hotelmanagementapp/utility/custome_bottom_navigation.dart';
import 'package:hotelmanagementapp/view/prnouniciation_lab_sub.dart';

class PronounciationLab extends StatefulWidget {
  // final String title;
  const PronounciationLab({super.key});

  @override
  State<PronounciationLab> createState() => _PronounciationLabState();
}

class _PronounciationLabState extends State<PronounciationLab> {
  int expandedIndex = -1;
  @override
  Widget build(BuildContext context) {
    return GetBuilder<PronunciationLabController>(builder: (controller) {
      return Scaffold(
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          floatingActionButton: Builder(builder: (context) {
            final isKeyboardOpen = MediaQuery.of(context).viewInsets.bottom > 0;

            return Align(
              alignment: Alignment.bottomCenter,
              child:
                  (isKeyboardOpen || kIsWeb) ? null : CustomeBottomNavigation(),
            );
          }),
          appBar: AppBar(
              forceMaterialTransparency: true,
              backgroundColor: Colors.white,
              titleSpacing: 0,
              automaticallyImplyLeading: true,
              title: controller.isSearching
                  ? Padding(
                      padding: EdgeInsets.only(
                          right: getWidgetWidth(width: 20),
                          left: getWidgetWidth(width: 20)),
                      child: TextField(
                        cursorColor: Colors.grey,
                        controller: controller.searchController,
                        autofocus: true,
                        decoration: InputDecoration(
                          hintText: 'Search...',
                          hintStyle: TextStyle(color: Colors.grey),
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          suffixIcon: IconButton(
                            icon: Icon(Icons.clear, color: Colors.grey),
                            onPressed: () {
                              // controller.update();
                              controller.clearSearch();
                            },
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide:
                                BorderSide(color: Colors.grey, width: 0.2),
                          ),
                        ),
                        onChanged: (value) {
                          controller.searchSubcategories(value);
                        },
                      ),
                    )
                  : Container(
                      height: 56,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: const Color(0xFFEDEDED)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              if (kIsWeb)
                                SizedBox(
                                  width: getWidgetWidth(width: 12),
                                  child: IconButton(
                                      onPressed: () {
                                        kIsWeb
                                            ? Get.rootDelegate
                                                .offNamed(AppRoutes.languageLab)
                                            : Navigator.pop(context);
                                      },
                                      icon: Icon(
                                        Icons.arrow_back,
                                        color: Colors.black,
                                      )),
                                ),
                              Text(
                                controller.title.value,
                                textAlign: TextAlign.left,
                                style: GoogleFonts.inter(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 20,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                              right: getWidgetWidth(
                                  width: displayWidth(context) > 700 ? 20 : 10),
                              top: getWidgetHeight(height: 4),
                            ),
                            child: IconButton(
                              onPressed: () {
                                controller.isSearching = true;
                                controller.update();
                              },
                              icon: Icon(
                                Icons.search,
                                color: Colors.black.withOpacity(0.9),
                                size: displayWidth(context) > 700 ? 36 : 26,
                                weight: 800,
                              ),
                            ),
                          ),
                        ],
                      ),
                    )),
          body: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1200),
              child: controller.isLoading.value
                  ? Center(
                      child: CircularProgressIndicator(
                        color: linearColor,
                      ),
                    )
                  : controller.categories.length < 1
                      ? Center(child: Text("No data found"))
                      : controller.searchController.text.isNotEmpty
                          ? ListView.builder(
                              shrinkWrap: true,
                              padding: EdgeInsets.symmetric(
                                  vertical: getWidgetHeight(height: 10),
                                  horizontal: getWidgetWidth(width: 10)),
                              itemCount: controller.subcategories.length,
                              itemBuilder: (context, index) {
                                final isExpanded = expandedIndex == index;

                                return Column(
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          expandedIndex =
                                              isExpanded ? -1 : index;
                                        });
                                      },
                                      child: Container(
                                        width: getWidgetWidth(width: 375),
                                        // height: getWidgetHeight(height: 60),
                                        margin: const EdgeInsets.symmetric(
                                            vertical: 5),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          boxShadow: [
                                            BoxShadow(
                                              color:
                                                  Colors.black.withOpacity(0.1),
                                              offset: const Offset(0, 4),
                                              blurRadius: 10,
                                            ),
                                          ],
                                        ),
                                        child: Container(
                                          width: getWidgetWidth(width: 375),
                                          // height: getWidgetHeight(height: 75),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            color: Colors.white,
                                          ),
                                          child: Padding(
                                            padding: EdgeInsets.symmetric(
                                                vertical:
                                                    displayWidth(context) > 500
                                                        ? displayHeight(
                                                                context) *
                                                            0.02
                                                        : getWidgetHeight(
                                                            height: 6),
                                                horizontal: displayWidth(
                                                            context) >
                                                        500
                                                    ? displayWidth(context) *
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
                                                    // (controller.loadingIndex ==
                                                    //         index)
                                                    //     ? SizedBox(
                                                    //         height: getWidgetHeight(
                                                    //             height: 25),
                                                    //         width: getWidgetWidth(
                                                    //             width: 25),
                                                    //         child: Padding(
                                                    //           padding:
                                                    //               const EdgeInsets
                                                    //                   .all(3.0),
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
                                                            onTap: () {
                                                              controller
                                                                  .handlePlayPause(
                                                                      index);
                                                            },
                                                            child: Icon(
                                                              Icons
                                                                  .pause_circle_outline,
                                                              color:
                                                                  linearColor,
                                                              size: 26,
                                                            ),
                                                          )
                                                        : controller.errorPlaying ==
                                                                index
                                                            ? GestureDetector(
                                                                onTap: () {
                                                                  controller
                                                                      .handlePlayPause(
                                                                          index);
                                                                },
                                                                child: Icon(
                                                                  Icons
                                                                      .info_outline,
                                                                  color: Colors
                                                                      .red,
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
                                                                            height: displayWidth(context) > 500
                                                                                ? 20
                                                                                : 20),
                                                                        width: getWidgetWidth(
                                                                            width: displayWidth(context) > 500
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
                                                                            AllAssets.roundPlay),
                                                                        color:
                                                                            linearColor,
                                                                      ),
                                                              ),
                                                    SizedBox(
                                                      width: getWidgetWidth(
                                                          width: displayWidth(
                                                                      context) >
                                                                  500
                                                              ? 2
                                                              : 10),
                                                    ),
                                                    Text(
                                                        controller
                                                            .subcategories[
                                                                index]
                                                            .text,
                                                        style: TextStyle(
                                                          fontFamily:
                                                              Keys.fontFamily,
                                                          letterSpacing: 0,
                                                        )),
                                                  ],
                                                ),
                                                Row(
                                                  children: [
                                                    // GestureDetector(
                                                    //   onTap: () {
                                                    //     controller
                                                    //         .saveUpdate(index);
                                                    //   },
                                                    //   child: SizedBox(
                                                    //     // width: displayWidth(context) / 18.75,
                                                    //     // height: displayHeight(context) / 40.6,
                                                    //     height: 19,
                                                    //     width: 19,
                                                    //     child: ImageIcon(
                                                    //       AssetImage(
                                                    //           AllAssets.download),
                                                    //       color: controller
                                                    //                   .isPriorityList[
                                                    //               index]
                                                    //           ? linearColor
                                                    //           : Colors.black,
                                                    //       // size: size.height * 0.03,
                                                    //     ),
                                                    //   ),
                                                    // ),
                                                    kIsWeb
                                                        ? SizedBox(
                                                            height:
                                                                getWidgetHeight(
                                                                    height: 20),
                                                            width:
                                                                getWidgetWidth(
                                                                    width: 19),
                                                          )
                                                        : IconButton(
                                                            onPressed: () {
                                                              controller
                                                                  .saveUpdate(
                                                                      index);
                                                            },
                                                            icon: SizedBox(
                                                              // width: displayWidth(context) / 18.75,
                                                              // height: displayHeight(context) / 40.6,
                                                              height:
                                                                  getWidgetHeight(
                                                                      height:
                                                                          19),
                                                              width:
                                                                  getWidgetWidth(
                                                                      width:
                                                                          19),
                                                              child: controller
                                                                          .isSaving ==
                                                                      index
                                                                  ? SizedBox(
                                                                      height: getWidgetHeight(
                                                                          height:
                                                                              19),
                                                                      width: getWidgetWidth(
                                                                          width:
                                                                              19),
                                                                      child:
                                                                          CircularProgressIndicator(
                                                                        strokeWidth:
                                                                            2.0,
                                                                        color:
                                                                            linearColor,
                                                                      ),
                                                                    )
                                                                  : Image.asset(
                                                                      AllAssets
                                                                          .save,
                                                                      width: 18,
                                                                      color: controller.isPriorityList[
                                                                              index]
                                                                          ? linearColor
                                                                          : Colors
                                                                              .black,
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
                                      duration:
                                          const Duration(milliseconds: 300),
                                      curve: Curves.fastOutSlowIn,
                                      width: double.infinity,
                                      child: isExpanded
                                          ? Padding(
                                              padding: EdgeInsets.symmetric(
                                                horizontal:
                                                    getWidgetWidth(width: 15),
                                                vertical:
                                                    getWidgetHeight(height: 10),
                                              ),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    "IPA",
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
                                                  RichText(
                                                    textAlign:
                                                        TextAlign.justify,
                                                    text: TextSpan(
                                                      children: buildTextSpans(
                                                          controller
                                                              .subcategories[
                                                                  index]
                                                              .syllables),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: getWidgetHeight(
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
                                                            "PRONUNCIATION",
                                                            style: GoogleFonts.inter(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                                fontSize: 12,
                                                                color:
                                                                    lightWhite),
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
                                                                    .fontFamily,
                                                              ),
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                      if (!kIsWeb)
                                                        GestureDetector(
                                                          onTap: () {
                                                            controller.kShowDialog(
                                                                controller
                                                                    .subcategories[
                                                                        index]
                                                                    .text,
                                                                false,
                                                                context);
                                                          },
                                                          child: Container(
                                                            width:
                                                                getWidgetWidth(
                                                                    width: 130),
                                                            height:
                                                                getWidgetHeight(
                                                                    height: 45),
                                                            decoration:
                                                                BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          8),
                                                              color:
                                                                  Colors.white,
                                                              boxShadow: [
                                                                BoxShadow(
                                                                  color: Colors
                                                                      .black
                                                                      .withOpacity(
                                                                          0.1),
                                                                  offset:
                                                                      const Offset(
                                                                          0, 4),
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
                                                                  Icons.mic,
                                                                  color: Color
                                                                      .fromARGB(
                                                                          255,
                                                                          112,
                                                                          112,
                                                                          112),
                                                                ),
                                                                Text(
                                                                  "Practice",
                                                                  style:
                                                                      GoogleFonts
                                                                          .inter(
                                                                    color: const Color
                                                                        .fromARGB(
                                                                        255,
                                                                        112,
                                                                        112,
                                                                        112),
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600,
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
                                                      .subcategories[index]
                                                      .meaningSamples
                                                      .isNotEmpty)
                                                    Column(
                                                      children: [
                                                        SizedBox(
                                                          height:
                                                              getWidgetHeight(
                                                                  height: 12),
                                                        ),
                                                        SizedBox(
                                                          height:
                                                              getWidgetHeight(
                                                                  height: 24),
                                                          child: Text(
                                                            "ENGLISH MEANING",
                                                            style: GoogleFonts.inter(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                                fontSize: 10,
                                                                color:
                                                                    lightWhite),
                                                          ),
                                                        ),
                                                      ],
                                                    ),

                                                  if (controller
                                                      .subcategories[index]
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
                                                          Text(sentence),
                                                          Divider(
                                                            thickness: 0.2,
                                                            color: Colors.black,
                                                          )
                                                        ],
                                                      )
                                                  ],

                                                  if (controller
                                                      .subcategories[index]
                                                      .sentenceSamples
                                                      .isNotEmpty)
                                                    Column(
                                                      children: [
                                                        SizedBox(
                                                          height:
                                                              getWidgetHeight(
                                                                  height: 12),
                                                        ),
                                                        SizedBox(
                                                          height:
                                                              getWidgetHeight(
                                                                  height: 24),
                                                          child: Text(
                                                            "SAMPLE SENTENCES",
                                                            style: GoogleFonts.inter(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                                fontSize: 10,
                                                                color:
                                                                    lightWhite),
                                                          ),
                                                        ),
                                                      ],
                                                    ),

                                                  if (controller
                                                      .subcategories[index]
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
                                                            thickness: 0.2,
                                                            color: Colors.black,
                                                          )
                                                        ],
                                                      )
                                                  ],
                                                  if (controller.selectedWord
                                                          .toLowerCase() ==
                                                      controller
                                                          .subcategories[index]
                                                          .text
                                                          .toLowerCase())
                                                    ListTile(
                                                      contentPadding:
                                                          EdgeInsets.zero,
                                                      title: Text(
                                                        "Pronunciation Analysis Result",
                                                        style: TextStyle(
                                                            color: linearColor,
                                                            fontSize: 13,
                                                            fontFamily: Keys
                                                                .fontFamily),
                                                      ),
                                                      subtitle: Text(
                                                        "Note: This result only indicates intelligibility and does not confirm the accuracy of pronunciation.",
                                                        style: TextStyle(
                                                            color: Colors.black,
                                                            fontSize:
                                                                kText.scale(12),
                                                            fontFamily:
                                                                Keys.fontFamily,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w500),
                                                      ),
                                                      trailing: Container(
                                                        height: getWidgetHeight(
                                                            height: 40),
                                                        width: getWidgetWidth(
                                                            width: 40),
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
                                    if (controller.subcategories.length - 1 ==
                                        index)
                                      SizedBox(
                                        height: getWidgetHeight(height: 80),
                                      )
                                    : const SizedBox.shrink(),
                              ),
                              if (controller.subcategories.length - 1 == index)
                                SizedBox(
                                  height: getWidgetHeight(height: 80),
                                )
                            ],
                          );
                        },
                      )
                    : ListView.builder(
                        padding: EdgeInsets.symmetric(
                            vertical: getWidgetHeight(height: 10),
                            horizontal: getWidgetWidth(width: 15)),
                        itemCount: controller.categories.length,
                        itemBuilder: (context, index) {
                          return Column(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  subCategoryTitle =
                                      controller.categories[index].category;
                                  addToRecentHistory(
                                      path:
                                          "Language Lab > ${controller.title.value} > ${controller.categories[index].category}",
                                      category:
                                          controller.categories[index].category,
                                      section: "Pronunciation Lab",
                                      link: "",
                                      proLabTitle: "",
                                      proSubcategories: controller
                                          .categories[index].subcategories,
                                      pronunCollectionName:
                                          controller.collectionName,
                                      proId: controller
                                          .categories[index].category);
                                  GetStorage()
                                      .write(AppRoutes.pronunciationLabSub, {
                                    'title':
                                        controller.categories[index].category,
                                    'subcategories': controller
                                        .categories[index].subcategories
                                        .map((e) => e.toMap())
                                        .toList(),
                                  });
                                  kIsWeb
                                      ? Get.rootDelegate.offNamed(
                                          AppRoutes.pronunciationLabSub,
                                          arguments: {
                                            'title': controller
                                                .categories[index].category,
                                            'subcategories': controller
                                                .categories[index].subcategories
                                                .map((e) => e.toMap())
                                                .toList(),
                                            'mainCategoryTitle':
                                                controller.title.value,
                                            'index': 6,
                                          };

                                          addToRecentHistory(
                                            path:
                                                "Language Lab > ${controller.title.value} > ${controller.categories[index].category}",
                                            category: controller
                                                .categories[index].category,
                                            section: "Pronunciation Lab",
                                            link: "",
                                            proLabTitle: "",
                                            extraStorageData: storageData,
                                          );

                                          GetStorage().write(
                                            AppRoutes
                                                .pronunciationLabSubStoreKey,
                                            {
                                              'title': controller
                                                  .categories[index].category,
                                              'subcategories': controller
                                                  .categories[index]
                                                  .subcategories
                                                  .map((e) => e.toMap())
                                                  .toList(),
                                              'mainCategoryTitle':
                                                  controller.title.value,
                                              'index': 6,
                                            },
                                          );

                                          kIsWeb
                                              ? Get.rootDelegate.offNamed(
                                                  AppRoutes.pronunciationLabSub,
                                                  arguments: {
                                                    'title': controller
                                                        .categories[index]
                                                        .category,
                                                    'subcategories': controller
                                                        .categories[index]
                                                        .subcategories,
                                                    'mainCategoryTitle':
                                                        controller.title.value,
                                                    'index': 6,
                                                  },
                                                )
                                              : Get.toNamed(
                                                  AppRoutes.pronunciationLabSub,
                                                  arguments: {
                                                    'title': controller
                                                        .categories[index]
                                                        .category,
                                                    'subcategories': controller
                                                        .categories[index]
                                                        .subcategories,
                                                    'index': 6,
                                                    'mainCategoryTitle':
                                                        controller.title.value,
                                                  },
                                                );

                                          debugPrint(
                                            "Navigated to Pronunciation Lab Sub with title: ${controller.categories[index].category}",
                                          );
                                        },
                                        child: Container(
                                          width: getWidgetWidth(width: 375),
                                          margin: const EdgeInsets.symmetric(
                                              vertical: 5),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            border: Border.all(
                                              color: const Color(0xFFE5E7EB),
                                              width: 1,
                                            ),
                                            color: Colors.white,
                                          ),
                                          child: Padding(
                                            padding: EdgeInsets.symmetric(
                                              vertical: displayWidth(context) >
                                                      500
                                                  ? displayWidth(context) * 0.01
                                                  : getWidgetHeight(height: 15),
                                              horizontal:
                                                  displayWidth(context) > 500
                                                      ? displayWidth(context) *
                                                          0.008
                                                      : getWidgetWidth(
                                                          width: 10),
                                            ),
                                            child: Row(
                                              children: [
                                                Container(
                                                  height: kIsWeb
                                                      ? 42
                                                      : getWidgetHeight(
                                                          height: 36),
                                                  width: displayWidth(context) >
                                                          500
                                                      ? displayHeight(context) *
                                                          0.06
                                                      : getWidgetWidth(
                                                          width: 36),
                                                  decoration: BoxDecoration(
                                                    color: controller
                                                                .pronunciationLabList[
                                                            index]['bgColor'] ??
                                                        Colors.yellow,
                                                    shape: BoxShape.circle,
                                                  ),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: ImageIcon(
                                                      AssetImage(
                                                        controller.pronunciationLabList[
                                                                    index]
                                                                ['image'] ??
                                                            AllAssets.plDays,
                                                      ),
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width:
                                                      displayWidth(context) >
                                                              500
                                                          ? displayWidth(
                                                                  context) *
                                                              0.01
                                                          : getWidgetWidth(
                                                              width: 10),
                                                ),
                                                Expanded(
                                                  child: Text(
                                                    controller.categories[index]
                                                            .category.isNotEmpty
                                                        ? controller
                                                                .categories[
                                                                    index]
                                                                .category[0]
                                                                .toUpperCase() +
                                                            controller
                                                                .categories[
                                                                    index]
                                                                .category
                                                                .substring(1)
                                                        : '',
                                                    maxLines: 2,
                                                    style: GoogleFonts.inter(
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontSize: 15,
                                                      color: Colors.black87,
                                                    ),
                                                  ),
                                                ),
                                                const Icon(
                                                  Icons.chevron_right,
                                                  color: Colors.grey,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    if (controller.categories.length - 1 ==
                                        index)
                                      SizedBox(
                                        height: getWidgetHeight(height: 180),
                                      ),
                                  ],
                                );
                              },
                            ),
            ),
          ));
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
