import 'package:flutter/material.dart';

import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hotelmanagementapp/controller/front_office_controller.dart';
import 'package:hotelmanagementapp/controller/home_controller.dart';
import 'package:hotelmanagementapp/model/category_model.dart';
import 'package:hotelmanagementapp/public/all_asset.dart';
import 'package:hotelmanagementapp/public/common_function.dart';
import 'package:hotelmanagementapp/public/constant.dart';
import 'package:hotelmanagementapp/route/route_name.dart';
import 'package:hotelmanagementapp/utility/in_aapp_web.dart';

class FrontOfficeHotelReception extends StatefulWidget {
  const FrontOfficeHotelReception({super.key});

  @override
  State<FrontOfficeHotelReception> createState() =>
      _FrontOfficeHotelReceptionState();
}

class _FrontOfficeHotelReceptionState extends State<FrontOfficeHotelReception> {
  HomeController homeController = Get.put<HomeController>(HomeController());
  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvoked: ((didPop) => homeController.loadRecentHistory()),
      child: Scaffold(body: SafeArea(
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
                            Container(
                              width: getWidgetWidth(width: 36),
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
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        padding: EdgeInsets.zero,
                      )),
                ],
              ),
              SizedBox(
                height: getWidgetHeight(height: 10),
              ),
              controller.isSearching
                  ? Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: getWidgetWidth(width: 20),
                      ),
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
                          controller.searchByCategory(value);
                        },
                      ),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: getWidgetWidth(width: 20),
                            ),
                            child: Text(
                              controller.title,
                              style: GoogleFonts.inter(
                                fontWeight: FontWeight.w600,
                                fontSize: kText.scale(20),
                                color: Colors.black,
                              ),
                              overflow:
                                  TextOverflow.ellipsis, // Prevent overflow
                              maxLines: 2,
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                            right: getWidgetWidth(width: 10),
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
                              size: 26,
                              weight: 800,
                            ),
                          ),
                        ),
                      ],
                    ),
              // SizedBox(
              //   height: getWidgetHeight(height: 6),
              // ),
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
                            controller.searchController.text.isNotEmpty
                                ? "No Search Result Found"
                                : "No data",
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
                                  controller.frontOfficeData[index]
                                          .subcategory[0].link !=
                                      "");
                              final linkAvailable1 = (controller
                                      .frontOfficeData[index]
                                      .subcategory[1]
                                      .link
                                      .isNotEmpty ||
                                  controller.frontOfficeData[index]
                                          .subcategory[1].link !=
                                      "");
                              final linkAvailable2 = (controller
                                      .frontOfficeData[index]
                                      .subcategory[2]
                                      .link
                                      .isNotEmpty ||
                                  controller.frontOfficeData[index]
                                          .subcategory[2].link !=
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
                                                    horizontal: getWidgetWidth(
                                                        width: 20),
                                                  ),
                                                  child: RichText(
                                                    text: TextSpan(
                                                      children: controller
                                                          .highlightOccurrences(
                                                              controller
                                                                  .frontOfficeData[
                                                                      index]
                                                                  .category,
                                                              controller
                                                                  .searchTerm),
                                                      style: GoogleFonts.inter(
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontSize: 15),
                                                    ),
                                                  ),
                                                ),
                                                if (isExpanded)
                                                  Padding(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                      horizontal:
                                                          getWidgetWidth(
                                                              width: 10),
                                                    ),
                                                    child: const Divider(
                                                      color: Color.fromARGB(
                                                          255, 107, 107, 107),
                                                    ),
                                                  ),
                                                if (isExpanded)
                                                  Padding(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                      horizontal:
                                                          getWidgetWidth(
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
                                                                  subCategoryTitle = controller
                                                                      .frontOfficeData[
                                                                          index]
                                                                      .category;
                                                                  addToRecentHistory(
                                                                      path:
                                                                          "Core Department > ${controller.title} ",
                                                                      category:
                                                                          subCategoryTitle,
                                                                      section:
                                                                          activityName,
                                                                      link: controller
                                                                          .frontOfficeData[
                                                                              index]
                                                                          .subcategory[
                                                                              0]
                                                                          .link,
                                                                      proLabTitle:
                                                                          "");
                                                                  Get.toNamed(
                                                                      AppRoutes
                                                                          .inAppWebView,
                                                                      arguments: {
                                                                        "url": controller
                                                                            .frontOfficeData[index]
                                                                            .subcategory[0]
                                                                            .link
                                                                      });
                                                                }
                                                              : null,
                                                          child: Image.asset(
                                                            AllAssets
                                                                .interaction,
                                                            color: linkAvailable
                                                                ? Colors.black
                                                                : Colors.grey,
                                                            width:
                                                                getWidgetWidth(
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
                                                                      'Glossary';
                                                                  subCategoryTitle = controller
                                                                      .frontOfficeData[
                                                                          index]
                                                                      .category;
                                                                  addToRecentHistory(
                                                                      path:
                                                                          "Core Department > ${controller.title} ",
                                                                      category:
                                                                          subCategoryTitle,
                                                                      section:
                                                                          activityName,
                                                                      link: controller
                                                                          .frontOfficeData[
                                                                              index]
                                                                          .subcategory[
                                                                              1]
                                                                          .link,
                                                                      proLabTitle:
                                                                          "");
                                                                  Get.toNamed(
                                                                      AppRoutes
                                                                          .inAppWebView,
                                                                      arguments: {
                                                                        "url": controller
                                                                            .frontOfficeData[index]
                                                                            .subcategory[1]
                                                                            .link
                                                                      });
                                                                }
                                                              : null,
                                                          child: Image.asset(
                                                            AllAssets.bookIcon,
                                                            color:
                                                                linkAvailable1
                                                                    ? Colors
                                                                        .black
                                                                    : Colors
                                                                        .grey,
                                                            width:
                                                                getWidgetWidth(
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
                                                                      "Knowledge check";

                                                                  subCategoryTitle = controller
                                                                      .frontOfficeData[
                                                                          index]
                                                                      .category;
                                                                  addToRecentHistory(
                                                                      path:
                                                                          "Core Department > ${controller.title} ",
                                                                      category:
                                                                          subCategoryTitle,
                                                                      section:
                                                                          activityName,
                                                                      link: controller
                                                                          .frontOfficeData[
                                                                              index]
                                                                          .subcategory[
                                                                              2]
                                                                          .link,
                                                                      proLabTitle:
                                                                          "");
                                                                  Get.toNamed(
                                                                      AppRoutes
                                                                          .inAppWebView,
                                                                      arguments: {
                                                                        "url": controller
                                                                            .frontOfficeData[index]
                                                                            .subcategory[2]
                                                                            .link
                                                                      });
                                                                }
                                                              : null,
                                                          child: Image.asset(
                                                            AllAssets.approval,
                                                            color:
                                                                linkAvailable2
                                                                    ? Colors
                                                                        .black
                                                                    : Colors
                                                                        .grey,
                                                            width:
                                                                getWidgetWidth(
                                                                    width: 22),
                                                            height:
                                                                getWidgetHeight(
                                                                    height: 26),
                                                          ),
                                                        ),
                                                        GestureDetector(
                                                          // onTapDown:
                                                          //     (TapDownDetails
                                                          //         details) {
                                                          //   final tapPosition =
                                                          //       details
                                                          //           .globalPosition;
                                                          //   controller
                                                          //       .showPopupAtTap(
                                                          //           tapPosition);
                                                          // },
                                                          onTap: () {
                                                            activityName =
                                                                "Prounciation Lab";

                                                            subCategoryTitle =
                                                                controller
                                                                    .frontOfficeData[
                                                                        index]
                                                                    .category;
                                                            addToRecentHistory(
                                                                path:
                                                                    "Core Department > ${controller.title}",
                                                                category:
                                                                    subCategoryTitle,
                                                                section:
                                                                    "proLab",
                                                                link: "",
                                                                proLabTitle:
                                                                    "");
                                                            Get.toNamed(
                                                                AppRoutes
                                                                    .pronunciationLabSub,
                                                                arguments: {
                                                                  'title': controller
                                                                      .frontOfficeData[
                                                                          index]
                                                                      .category,
                                                                  'subcategories':
                                                                      <SubcategoryPro>[],
                                                                  "id": controller
                                                                      .frontOfficeData[
                                                                          index]
                                                                      .pronunID,
                                                                  "pronunCollectionName":
                                                                      controller
                                                                          .pronunCollectionName,
                                                                });
                                                            // Navigator.push(
                                                            //     context,
                                                            //     MaterialPageRoute(
                                                            //         builder:
                                                            //             (context) =>
                                                            //                 AudioListPage()));
                                                          },
                                                          child: SizedBox(
                                                            width:
                                                                getWidgetWidth(
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
      )),
    );
  }
}
