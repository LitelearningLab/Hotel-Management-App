import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hotelmanagementapp/controller/sentence_lab_sub_cat_controller.dart';
import 'package:hotelmanagementapp/model/sentence_model.dart';
import 'package:hotelmanagementapp/public/all_asset.dart';
import 'package:hotelmanagementapp/public/common_function.dart';
import 'package:hotelmanagementapp/public/constant.dart';
import 'package:hotelmanagementapp/public/keys.dart';
import 'package:hotelmanagementapp/utility/custome_bottom_navigation.dart';

class SentenceLabSubCat extends StatefulWidget {
  SentenceLabSubCat({super.key});

  @override
  State<SentenceLabSubCat> createState() => _SentenceLabSubCatState();
}

class _SentenceLabSubCatState extends State<SentenceLabSubCat> {
  int expandedIndex = -1;
  @override
  Widget build(BuildContext context) {
    return GetBuilder<SentenceLabSubCatController>(builder: (controller) {
      return Scaffold(
        // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        // floatingActionButton: Align(
        //   alignment: Alignment.bottomCenter,
        //   child: CustomeBottomNavigation(),
        // ),
        appBar: AppBar(
          forceMaterialTransparency: true,
          surfaceTintColor: Colors.white,
          shadowColor: Colors.white,
          backgroundColor: Colors.white,
          titleSpacing: 0,
          title: Text(
            controller.title, maxLines: 2,
            // textAlign: TextAlign.start,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back),
          ),
        ),
        body: ListView.builder(
          padding: EdgeInsets.symmetric(
              vertical: getWidgetHeight(height: 10),
              horizontal: getWidgetWidth(width: 10)),
          itemCount: controller.subcategories.length,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            final isExpanded = expandedIndex == index;

            return GestureDetector(
              onTap: () {
                setState(() {
                  expandedIndex = isExpanded ? -1 : index;
                });
              },
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      offset: const Offset(0, 4),
                      blurRadius: 10,
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: getWidgetHeight(height: 6),
                        horizontal: getWidgetWidth(width: 10),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              SizedBox(width: getWidgetWidth(width: 10)),
                              Text(
                                controller.subcategories[index].sentence.text,
                                style: TextStyle(
                                  fontFamily: Keys.fontFamily,
                                  letterSpacing: 0,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              SizedBox(
                                width: getWidgetWidth(width: 10),
                                child: IconButton(
                                  onPressed: () {},
                                  icon: const Icon(Icons.save_alt, size: 20),
                                ),
                              ),
                              SizedBox(width: getWidgetWidth(width: 10)),
                              IconButton(
                                onPressed: () {},
                                icon: const Icon(Icons.check, size: 20),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    // Expandable Section
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.fastOutSlowIn,
                      height: isExpanded ? getWidgetHeight(height: 80) : 0,
                      // width: MediaQuery.of(context).size.width * 0.6,
                      padding: EdgeInsets.symmetric(
                        // vertical: getWidgetHeight(height: 10),
                        horizontal: getWidgetWidth(width: 15),
                      ),
                      child: isExpanded
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (isExpanded)
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: getWidgetWidth(width: 10),
                                    ),
                                    child: const Divider(
                                      color: Color.fromARGB(255, 107, 107, 107),
                                    ),
                                  ),
                                SizedBox(
                                  height: getWidgetHeight(height: 16),
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    InkWell(
                                      onTap: () async {
                                        controller.handlePlayPause(index);
                                      },
                                      child: Row(
                                        children: [
                                          // SPW(35),
                                          Icon(
                                            controller.isPlaying &&
                                                    controller
                                                            .currentlyPlayingIndex ==
                                                        index
                                                ? Icons.pause_circle_outline
                                                : Icons.play_circle_outline,
                                            color: Colors.black,
                                          ),
                                          // SPW(5),
                                          SizedBox(
                                            width: getWidgetWidth(width: 5),
                                          ),
                                          Text(
                                            "Native Speaker",
                                            style: TextStyle(fontSize: 13),
                                          ),
                                        ],
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () async {
                                        controller.kShowDialog(
                                            controller.subcategories[index]
                                                .sentence.text,
                                            false,
                                            context);
                                      },
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.mic,
                                          ),
                                          // SPW(5),
                                          SizedBox(
                                            width: getWidgetWidth(width: 5),
                                          ),
                                          Text(
                                            "Practice",
                                            style: TextStyle(fontSize: 13),
                                          ),
                                          // SPW(35),
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
      );
    });
  }
}
