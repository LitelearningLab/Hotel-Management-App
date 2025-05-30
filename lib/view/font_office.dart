import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hotelmanagementapp/controller/front_office_controller.dart';
import 'package:hotelmanagementapp/public/all_asset.dart';
import 'package:hotelmanagementapp/public/common_function.dart';
import 'package:hotelmanagementapp/public/constant.dart';
import 'package:hotelmanagementapp/utility/in_aapp_web.dart';
import 'package:hotelmanagementapp/view/prnouniciation_lab_sub.dart';

import 'package:hotelmanagementapp/view/pronounciation_lab.dart';

import '../utility/custome_shape.dart';

class FrontOfficeHotelReception extends StatefulWidget {
  const FrontOfficeHotelReception({super.key});

  @override
  State<FrontOfficeHotelReception> createState() =>
      _FrontOfficeHotelReceptionState();
}

class _FrontOfficeHotelReceptionState extends State<FrontOfficeHotelReception> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: SafeArea(
      child: GetBuilder<FrontOfficeController>(builder: (controller) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipPath(
                  // clipper: CustomShape(),
                  child: SizedBox(
                    width: getWidgetWidth(width: 3750),
                    height: getWidgetHeight(height: 270),
                    child: SvgPicture.asset(
                      controller.image,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned(
                    top: getWidgetHeight(height: 15),
                    left: getWidgetWidth(width: 5),
                    child: IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: Stack(
                        alignment: Alignment.center,
                        children: [
                          // Blur circle background
                          Container(
                            width: getWidgetWidth(
                                width: 36), // Slightly larger than the icon
                            height: getWidgetHeight(height: 36),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.black.withOpacity(0.3),
                              //   boxShadow: [
                              //     BoxShadow(
                              //       color: Colors.black.withOpacity(0.3),
                              //       blurRadius: 5,
                              //       spreadRadius: 0,
                              //     ),
                              //   ],
                            ),
                          ),
                          // Icon with shadow
                          const Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                            // shadows: [
                            //   Shadow(
                            //     color: Colors.black.withOpacity(0.5),
                            //     blurRadius: 4,
                            //     offset: Offset(2, 2),
                            //   ),
                            // ],
                          ),
                        ],
                      ),
                      iconSize: 30,
                      splashColor: Colors.transparent, // Remove splash effect
                      highlightColor:
                          Colors.transparent, // Remove highlight effect
                      padding: EdgeInsets.zero, // Remove default padding
                    )),
              ],
            ),
            SizedBox(
              height: getWidgetHeight(height: 10),
            ),
            Padding(
              padding:
                  EdgeInsets.symmetric(horizontal: getWidgetWidth(width: 20)),
              child: Text(
                controller.title,
                textAlign: TextAlign.left,
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.w600,
                  fontSize: 20,
                  color: Colors.black,
                ),
              ),
            ),
            SizedBox(
              height: getWidgetHeight(height: 15),
            ),
            Expanded(
              child: controller.loading
                  ? Center(
                      child: SizedBox(
                        width: getWidgetWidth(width: 40),
                        height: getWidgetHeight(height: 40),
                        child: CircularProgressIndicator(
                          color: linearColor,
                        ),
                      ),
                    )
                  : controller.frontOfficeData.isEmpty
                      ? Center(
                          child: Text(
                          "No data",
                          textAlign: TextAlign.left,
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                            color: Colors.black,
                          ),
                        ))
                      : ListView.builder(
                          padding: EdgeInsets.symmetric(
                              vertical: getWidgetHeight(height: 10),
                              horizontal: getWidgetWidth(width: 20)),
                          itemCount: controller.frontOfficeData.length,
                          itemBuilder: (context, index) {
                            final isExpanded =
                                controller.expandedIndex == index;
                            final linkAvailable = (controller
                                    .frontOfficeData[index]
                                    .subcategory[0]
                                    .link
                                    .isNotEmpty ||
                                controller.frontOfficeData[index].subcategory[0]
                                        .link !=
                                    "");
                            final linkAvailable1 = (controller
                                    .frontOfficeData[index]
                                    .subcategory[1]
                                    .link
                                    .isNotEmpty ||
                                controller.frontOfficeData[index].subcategory[1]
                                        .link !=
                                    "");
                            final linkAvailable2 = (controller
                                    .frontOfficeData[index]
                                    .subcategory[2]
                                    .link
                                    .isNotEmpty ||
                                controller.frontOfficeData[index].subcategory[2]
                                        .link !=
                                    "");

                            return Column(
                              children: [
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: getWidgetHeight(height: 5)),
                                  child: GestureDetector(
                                      onTap: () {
                                        controller.expandedIndex =
                                            isExpanded ? -1 : index;
                                        controller.update();
                                      },
                                      child: AnimatedSize(
                                        duration:
                                            const Duration(milliseconds: 200),
                                        curve: Curves.fastOutSlowIn,
                                        child: Container(
                                          width: double.infinity,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            color: Colors.white,
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
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Padding(
                                                padding: EdgeInsets.symmetric(
                                                  vertical: getWidgetHeight(
                                                      height: 12),
                                                  horizontal:
                                                      getWidgetWidth(width: 20),
                                                ),
                                                child: Text(
                                                  controller
                                                      .frontOfficeData[index]
                                                      .category,
                                                  style: GoogleFonts.inter(
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 14,
                                                  ),
                                                ),
                                              ),
                                              if (isExpanded)
                                                Padding(
                                                  padding: EdgeInsets.symmetric(
                                                    horizontal: getWidgetWidth(
                                                        width: 10),
                                                  ),
                                                  child: const Divider(
                                                    color: Color.fromARGB(
                                                        255, 107, 107, 107),
                                                  ),
                                                ),
                                              if (isExpanded)
                                                Padding(
                                                  padding: EdgeInsets.symmetric(
                                                    horizontal: getWidgetWidth(
                                                        width: 15),
                                                    vertical: getWidgetHeight(
                                                        height: 8),
                                                  ),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      GestureDetector(
                                                        onTap: linkAvailable
                                                            ? () {
                                                                activityName =
                                                                    "E-Learning";
                                                                Navigator.push(
                                                                    context,
                                                                    MaterialPageRoute(
                                                                        builder: (context) =>
                                                                            InAppWebViewPage(
                                                                              url: controller.frontOfficeData[index].subcategory[0].link,
                                                                            )));
                                                              }
                                                            : null,
                                                        child: Image.asset(
                                                          AllAssets.interaction,
                                                          color: linkAvailable
                                                              ? Colors.black
                                                              : Colors.grey,
                                                          width: getWidgetWidth(
                                                              width: 28),
                                                          height:
                                                              getWidgetHeight(
                                                                  height: 28),
                                                        ),
                                                      ),
                                                      GestureDetector(
                                                        onTap: linkAvailable1
                                                            ? () {
                                                                activityName =
                                                                    'video';

                                                                controller
                                                                    .frontOfficeData[
                                                                        index]
                                                                    .category;
                                                                Navigator.push(
                                                                    context,
                                                                    MaterialPageRoute(
                                                                        builder: (context) =>
                                                                            InAppWebViewPage(
                                                                              url: controller.frontOfficeData[index].subcategory[1].link,
                                                                            )));
                                                              }
                                                            : null,
                                                        child: Image.asset(
                                                          AllAssets.bookIcon,
                                                          color: linkAvailable1
                                                              ? Colors.black
                                                              : Colors.grey,
                                                          width: getWidgetWidth(
                                                              width: 28),
                                                          height:
                                                              getWidgetHeight(
                                                                  height: 26),
                                                        ),
                                                      ),
                                                      GestureDetector(
                                                        onTap: linkAvailable2
                                                            ? () {
                                                                activityName =
                                                                    "third option";

                                                                subCategoryTitle =
                                                                    controller
                                                                        .frontOfficeData[
                                                                            index]
                                                                        .category;
                                                                Navigator.push(
                                                                    context,
                                                                    MaterialPageRoute(
                                                                        builder: (context) =>
                                                                            InAppWebViewPage(
                                                                              url: controller.frontOfficeData[index].subcategory[2].link,
                                                                            )));
                                                              }
                                                            : null,
                                                        child: Image.asset(
                                                          AllAssets.approval,
                                                          color: linkAvailable2
                                                              ? Colors.black
                                                              : Colors.grey,
                                                          width: getWidgetWidth(
                                                              width: 22),
                                                          height:
                                                              getWidgetHeight(
                                                                  height: 26),
                                                        ),
                                                      ),
                                                      InkWell(
                                                        onTap: () {
                                                          activityName =
                                                              "Prounciation Lab";

                                                          subCategoryTitle =
                                                              controller
                                                                  .frontOfficeData[
                                                                      index]
                                                                  .category;
                                                          Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                  builder:
                                                                      (context) =>
                                                                          PronunciationLabSub(
                                                                            title:
                                                                                controller.hospitalityTopics[index],
                                                                          )));
                                                        },
                                                        child: SizedBox(
                                                          width: getWidgetWidth(
                                                              width: 32),
                                                          height:
                                                              getWidgetHeight(
                                                                  height: 28),
                                                          child: const Icon(
                                                            Icons.mic,
                                                            size: 30,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                            ],
                                          ),
                                        ),
                                      )),
                                ),
                              ],
                            );
                          },
                        ),
            ),
          ],
        );
      }),
    ));
  }
}
