import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hotelmanagementapp/controller/sentence_lab_sub_cat_controller.dart';
import 'package:hotelmanagementapp/model/sentence_model.dart';
import 'package:hotelmanagementapp/public/all_asset.dart';
import 'package:hotelmanagementapp/public/common_function.dart';
import 'package:hotelmanagementapp/public/constant.dart';
import 'package:hotelmanagementapp/public/keys.dart';
import 'package:intl/intl.dart';

class SentenceLabSubCat extends StatefulWidget {
  SentenceLabSubCat({super.key});

  @override
  State<SentenceLabSubCat> createState() => _SentenceLabSubCatState();
}

class _SentenceLabSubCatState extends State<SentenceLabSubCat> {
  int expandedIndex = -1;

  @override
  void initState() {
    startTimerMainCategory("");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SentenceLabSubCatController>(builder: (controller) {
      return PopScope(
        onPopInvoked: (didPop) {
          stopTimerMainCategory();
        },
        child: Scaffold(
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
                      controller.searchSentences(value);
                    },
                  )
                : Padding(
                    padding: EdgeInsets.only(right: getWidgetWidth(width: 12)),
                    child: Text(
                      controller.title,
                      maxLines: 2,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
            leading: IconButton(
              onPressed: () {
                if (controller.isSearching) {
                  controller.clearSearch();
                } else {
                  Navigator.pop(context);
                }
              },
              icon:
                  Icon(controller.isSearching ? Icons.close : Icons.arrow_back),
            ),
            actions: [
              PopupMenuButton<String>(
                color: Colors.white,
                onSelected: (value) {
                  controller.selectedMenuOption = value;

                  if (value == 'priority') {
                    controller.filterByDownloadStatus("downloaded");
                  } else if (value == 'all_priority') {
                    controller.clearFilter();
                    // controller.applyDownloadedFilter(false);
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
                  PopupMenuItem<String>(
                    value: 'priority',
                    child: Text(
                      'Filter Priority',
                      style: TextStyle(
                        fontWeight: controller.selectedMenuOption == 'priority'
                            ? FontWeight.w600
                            : FontWeight.normal,
                        color: controller.selectedMenuOption == 'priority'
                            ? Colors.black
                            : Colors.grey[800],
                      ),
                    ),
                  ),
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
            ],
          ),
          body: controller.isLoading
              ? CircularProgressIndicator()
              : Column(
                  children: [
                    if (controller.searchController.text.isNotEmpty)
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: getWidgetWidth(width: 12)),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Search Results for: ${controller.searchTerm}",
                            style: TextStyle(
                              fontSize: kText.scale(13),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    controller.subcategories.isEmpty
                        ? SizedBox(
                            height: getWidgetHeight(height: 550),
                            child: Center(
                              child: Text(
                                  controller.searchController.text.isNotEmpty
                                      ? "No Search Result Found"
                                      : "No Data Found"),
                            ),
                          )
                        : Expanded(
                            child: ListView.builder(
                              padding: EdgeInsets.symmetric(
                                vertical: getWidgetHeight(height: 10),
                                horizontal: getWidgetWidth(width: 10),
                              ),
                              itemCount: controller.subcategories.length,
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                SubCategoryModel subCategory =
                                    controller.subcategories[index];
                                String? subname = subCategory.id;
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      toBeginningOfSentenceCase(subname) ?? "",
                                      style: GoogleFonts.poppins(
                                        color: linearColor,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    ListView.builder(
                                      shrinkWrap: true,
                                      physics: NeverScrollableScrollPhysics(),
                                      itemCount: subCategory.sentence.length,
                                      itemBuilder: (context, subIndex) {
                                        final sentence =
                                            subCategory.sentence[subIndex];
                                        final isExpanded = expandedIndex ==
                                            index * 1000 + subIndex;

                                        return GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              expandedIndex = isExpanded
                                                  ? -1
                                                  : index * 1000 + subIndex;
                                            });
                                          },
                                          child: Container(
                                            margin: EdgeInsets.symmetric(
                                                vertical:
                                                    getWidgetHeight(height: 6)),
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.black
                                                      .withOpacity(0.1),
                                                  offset: const Offset(0, 4),
                                                  blurRadius: 10,
                                                ),
                                              ],
                                            ),
                                            child: Column(
                                              children: [
                                                Padding(
                                                  padding: EdgeInsets.only(
                                                    top: getWidgetHeight(
                                                        height: 8),
                                                    bottom: getWidgetHeight(
                                                        height: 8),
                                                    left: getWidgetWidth(
                                                        width: 10),
                                                    // right: getWidgetWidth(width: 15)
                                                  ),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Expanded(
                                                        child: Text(
                                                          sentence.text,
                                                          style: TextStyle(
                                                            fontFamily:
                                                                Keys.fontFamily,
                                                            letterSpacing: 0,
                                                          ),
                                                        ),
                                                      ),
                                                      IconButton(
                                                        onPressed: () {
                                                          controller.saveUpdate(
                                                              index, subIndex);
                                                        },
                                                        icon: SizedBox(
                                                          // width: displayWidth(context) / 18.75,
                                                          // height: displayHeight(context) / 40.6,
                                                          height: 19,
                                                          width: 19,
                                                          child: controller
                                                                          .isLoadingMap[
                                                                      "$index-$subIndex"] ==
                                                                  true
                                                              ? CircularProgressIndicator(
                                                                  strokeWidth:
                                                                      2,
                                                                  color:
                                                                      linearColor,
                                                                )
                                                              : Image.asset(
                                                                  AllAssets
                                                                      .save,
                                                                  width: 18,
                                                                  color: sentence
                                                                          .isDownloaded
                                                                      ? linearColor
                                                                      : Colors
                                                                          .black,
                                                                ),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                                AnimatedContainer(
                                                  duration: const Duration(
                                                      milliseconds: 300),
                                                  curve: Curves.fastOutSlowIn,
                                                  height: isExpanded
                                                      ? getWidgetHeight(
                                                          height: 65)
                                                      : 0,
                                                  padding: EdgeInsets.symmetric(
                                                    horizontal: getWidgetWidth(
                                                        width: 15),
                                                  ),
                                                  child: isExpanded
                                                      ? Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            const Divider(
                                                              color: Color
                                                                  .fromARGB(
                                                                      255,
                                                                      107,
                                                                      107,
                                                                      107),
                                                            ),
                                                            SizedBox(
                                                                height:
                                                                    getWidgetHeight(
                                                                        height:
                                                                            6)),
                                                            Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceAround,
                                                              children: [
                                                                InkWell(
                                                                  onTap:
                                                                      () async {
                                                                    controller.handlePlayPause(
                                                                        index,
                                                                        subIndex);
                                                                  },
                                                                  child: Row(
                                                                    children: [
                                                                      Icon(
                                                                        controller.currentlyPlayingIndex ==
                                                                                subIndex
                                                                            ? Icons.pause_circle_outline
                                                                            : Icons.play_circle_outline,
                                                                        color: Colors
                                                                            .black,
                                                                      ),
                                                                      SizedBox(
                                                                          width:
                                                                              getWidgetWidth(width: 5)),
                                                                      const Text(
                                                                          "Native Speaker",
                                                                          style:
                                                                              TextStyle(fontSize: 13)),
                                                                    ],
                                                                  ),
                                                                ),
                                                                InkWell(
                                                                  onTap: () {
                                                                    controller.kShowDialog(
                                                                        subname,
                                                                        sentence
                                                                            .text,
                                                                        false,
                                                                        context);
                                                                    // Add dialog or recording functionality
                                                                  },
                                                                  child: Row(
                                                                    children: [
                                                                      const Icon(
                                                                          Icons
                                                                              .mic),
                                                                      SizedBox(
                                                                          width:
                                                                              getWidgetWidth(width: 5)),
                                                                      const Text(
                                                                          "Practice",
                                                                          style:
                                                                              TextStyle(fontSize: 13)),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ],
                                                        )
                                                      : const SizedBox.shrink(),
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                    controller.subcategories.length - 1 != index
                                        ? Divider(
                                            color: Colors.grey[300],
                                            thickness: 1,
                                            height: getWidgetHeight(height: 20),
                                          )
                                        : SizedBox(
                                            height: getWidgetHeight(height: 20),
                                          ),
                                  ],
                                );
                              },
                            ),
                          ),
                  ],
                ),
        ),
      );
    });
  }
}
