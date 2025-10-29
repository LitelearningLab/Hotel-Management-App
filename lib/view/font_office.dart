import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hotelmanagementapp/controller/front_office_controller.dart';
import 'package:hotelmanagementapp/controller/home_controller.dart';
import 'package:hotelmanagementapp/model/category_model.dart';
import 'package:hotelmanagementapp/public/all_asset.dart';
import 'package:hotelmanagementapp/public/common_function.dart';
import 'package:hotelmanagementapp/public/constant.dart';
import 'package:hotelmanagementapp/route/app_router_delegate.dart';
import 'package:hotelmanagementapp/route/route_name.dart';
import 'package:hotelmanagementapp/utility/in_aapp_web.dart';
import 'package:hotelmanagementapp/utility/web_view_page.dart';

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
    double isKwidth = MediaQuery.of(context).size.width;
    return PopScope(
      onPopInvoked: ((didPop) => homeController.loadRecentHistory()),
      child: Scaffold(body: SafeArea(
        child: GetBuilder<FrontOfficeController>(builder: (controller) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              displayWidth(context) > 800
                  ? Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: getWidgetWidth(width: 12)),
                      child: SizedBox(
                        // color: Colors.amber,
                        width: getWidgetWidth(width: 375),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Image with back button
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(top: 20, left: 25),
                                  // top: getWidgetHeight(height: 15),
                                  // left: getWidgetWidth(width: 5),
                                  child: IconButton(
                                    focusColor: Colors.transparent,
                                    hoverColor: Colors.transparent,
                                    highlightColor: Colors.transparent,
                                    splashColor: Colors.transparent,
                                    onPressed: () {
                                      kIsWeb
                                          ? Get.rootDelegate
                                              .offNamed(AppRoutes.home)
                                          : Get.back();
                                    },
                                    icon: Container(
                                      width: getWidgetWidth(width: 10),
                                      height: getWidgetHeight(height: 40),
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.black.withOpacity(0.3),
                                      ),
                                      child: const Icon(
                                        Icons.arrow_back,
                                        color: Colors.white,
                                        size: 30,
                                      ),
                                    ),
                                    padding: EdgeInsets.zero,
                                  ),
                                ),
                                SizedBox(
                                  width: getWidgetWidth(width: 2),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(top: 10),
                                  child: ClipPath(
                                    // clipper: CustomShape(),
                                    child: SvgPicture.asset(
                                      width: getWidgetWidth(width: 60),
                                      height: getWidgetHeight(height: 200),
                                      controller.image,
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            // Space between image and column
                            // SizedBox(width: getWidgetWidth(width: 10)),

                            // Headline + Search TextField
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: getWidgetHeight(height: 15)),
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: getWidgetWidth(width: 10),
                                        vertical: getWidgetHeight(height: 20)),
                                    child: Text(
                                      controller.title,
                                      style: GoogleFonts.inter(
                                        fontWeight: FontWeight.w600,
                                        fontSize: kText
                                            .scale(isKwidth > 700 ? 25 : 20),
                                        color: Colors.black,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 2,
                                    ),
                                  ),
                                  SizedBox(height: getWidgetHeight(height: 5)),
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: getWidgetWidth(width: 10)),
                                    child: TextField(
                                      cursorColor: Colors.grey,
                                      controller: controller.searchController,
                                      autofocus: true,
                                      decoration: InputDecoration(
                                        hintText: 'Search Title...',
                                        hintStyle:
                                            const TextStyle(color: Colors.grey),
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                                horizontal: 12, vertical: 8),
                                        suffixIcon: IconButton(
                                          icon: const Icon(Icons.clear,
                                              color: Colors.grey),
                                          onPressed: () {
                                            controller.clearSearch();
                                          },
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          borderSide: const BorderSide(
                                              color: Colors.grey),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          borderSide: const BorderSide(
                                              color: Colors.grey, width: 0.2),
                                        ),
                                      ),
                                      onChanged: (value) {
                                        controller.searchByCategory(value);
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  : SizedBox(
                      child: Column(
                        children: [
                          Stack(
                            children: [
                              ClipPath(
                                // clipper: CustomShape(),
                                child: SizedBox(
                                  width: getWidgetWidth(width: 375),
                                  height: getWidgetHeight(
                                      height: isKwidth > 700 ? 400 : 270),
                                  child: SvgPicture.asset(
                                    controller.image,
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),
                              // if (!kIsWeb)
                              Positioned(
                                  top: getWidgetHeight(height: 15),
                                  left: getWidgetWidth(
                                      width: isKwidth > 700 ? 0 : 5),
                                  child: IconButton(
                                    focusColor: Colors.transparent,
                                    hoverColor: Colors.transparent,
                                    highlightColor: Colors.transparent,
                                    splashColor: Colors.transparent,
                                    color: Colors.transparent,
                                    onPressed: () {
                                      kIsWeb
                                          ? Get.rootDelegate
                                              .offNamed(AppRoutes.home)
                                          : Get.back();
                                    },
                                    icon: Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        Container(
                                          width: getWidgetWidth(
                                              width: isKwidth > 700 ? 56 : 36),
                                          height: getWidgetHeight(
                                              height: isKwidth > 700 ? 56 : 36),
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color:
                                                Colors.black.withOpacity(0.3),
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
                                    iconSize: isKwidth > 700 ? 50 : 30,
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
                                      contentPadding: EdgeInsets.symmetric(
                                          horizontal: 12, vertical: 8),
                                      suffixIcon: IconButton(
                                        icon: Icon(Icons.clear,
                                            color: Colors.grey),
                                        onPressed: () {
                                          controller.clearSearch();
                                        },
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                        borderSide:
                                            BorderSide(color: Colors.grey),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                        borderSide: BorderSide(
                                            color: Colors.grey, width: 0.2),
                                      ),
                                    ),
                                    onChanged: (value) {
                                      controller.searchByCategory(value);
                                    },
                                  ),
                                )
                              : Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
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
                                            fontSize: kText.scale(
                                                isKwidth > 700 ? 25 : 20),
                                            color: Colors.black,
                                          ),
                                          overflow: TextOverflow
                                              .ellipsis, // Prevent overflow
                                          maxLines: 2,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(
                                        right: getWidgetWidth(
                                            width: isKwidth > 700 ? 20 : 10),
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
                                          size: isKwidth > 700 ? 36 : 26,
                                          weight: 800,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                        ],
                      ),
                    ),
              // SizedBox(
              //   height: getWidgetHeight(height: 6),
              // ),
              Expanded(
                child: controller.loading
                    ? Center(
                        child: SizedBox(
                          width:
                              getWidgetWidth(width: isKwidth > 700 ? 10 : 40),
                          // height:
                          //     getWidgetHeight(height: isKwidth > 700 ? 40 : 40),
                          child: CircularProgressIndicator(
                            strokeWidth: isKwidth > 700 ? 6 : 4,
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
                              fontSize: kText.scale(16),
                              color: Colors.black,
                            ),
                          ))
                        : ListView.builder(
                            padding: EdgeInsets.symmetric(
                                vertical: getWidgetHeight(height: 10),
                                horizontal: getWidgetWidth(width: 20)),
                            itemCount: controller.frontOfficeData.length,
                            itemBuilder: (context, index) {
                              final glossaryIndex =
                                  controller.glossaryIndex == index;
                              final isExpanded =
                                  controller.expandedIndex == index;
                              final linkAvailable = ((controller
                                      .frontOfficeData[index]
                                      .subcategory[0]
                                      .link
                                      .isNotEmpty ||
                                  controller.frontOfficeData[index]
                                          .subcategory[0].link !=
                                      ""));
                              final linkAvailable1 = ((controller
                                      .frontOfficeData[index]
                                      .subcategory[1]
                                      .link
                                      .isNotEmpty ||
                                  controller.frontOfficeData[index]
                                          .subcategory[1].link !=
                                      ""));

                              final subcat = controller.frontOfficeData[index]
                                  .subcategory[2]; // Knowledge Check

                              final linksToShow = subcat.linkList;
                              // .isNotEmpty
                              //     ? subcat.linkList
                              //     : [
                              //         {'name': subcat.name, 'link': subcat.link}
                              //       ]; // fallback to single link
                              final linkAvailable2 = linksToShow.isNotEmpty;
                              // final linkAvailable2 =
                              //  ((controller
                              //                                 .frontOfficeData[index]
                              //                                 .subcategory[2]
                              //                                 .link
                              //                                 .isEmpty)
                              //                             //  &&
                              //                             // accessLinks.toLowerCase().contains(
                              //                             //     "knowledge check".toLowerCase())
                              //                             );
                              return Column(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                        vertical: getWidgetHeight(height: 5)),
                                    child: GestureDetector(
                                        onTap: () {
                                          controller.expandedIndex =
                                              isExpanded ? -1 : index;
                                          controller.glossaryIndex =
                                              glossaryIndex ? -1 : -1;

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
                                                        height: isKwidth > 700
                                                            ? 22
                                                            : 12),
                                                    horizontal: getWidgetWidth(
                                                        width: isKwidth > 700
                                                            ? 5
                                                            : 20),
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
                                                        // fontSize: kText.scale(
                                                        //     isKwidth > 700
                                                        //         ? 16
                                                        //         : 14)
                                                      ),
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
                                                                  log("$kIsWeb printing im clicking the correct");
                                                                  if (kIsWeb) {
                                                                    Navigator.push(
                                                                        context,
                                                                        MaterialPageRoute(
                                                                            builder: (context) =>
                                                                                WebContentPage(title: controller.frontOfficeData[index].category, url: controller.frontOfficeData[index].subcategory[0].link)));
                                                                  } else {
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
                                                                  if (kIsWeb) {
                                                                    Navigator.push(
                                                                        context,
                                                                        MaterialPageRoute(
                                                                            builder: (context) =>
                                                                                WebContentPage(title: controller.frontOfficeData[index].category, url: controller.frontOfficeData[index].subcategory[1].link)));
                                                                  } else {
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
                                                          onTap: controller
                                                                  .frontOfficeData[
                                                                      index]
                                                                  .pronunID
                                                                  .isNotEmpty
                                                              ? () {
                                                                  print(
                                                                      "pronunID: ${controller.frontOfficeData[index].pronunID}");
                                                                  controller
                                                                      .glossaryIndex = -1;

                                                                  controller
                                                                      .update();
                                                                  activityName =
                                                                      "Prounciation Lab";
                                                                  debugPrint(
                                                                      "pronunCollectionName: ${controller.pronunCollectionName}");

                                                                  subCategoryTitle = controller
                                                                      .frontOfficeData[
                                                                          index]
                                                                      .category;
                                                                  GetStorage().write(
                                                                      AppRoutes
                                                                          .pronunciationLabSub,
                                                                      {
                                                                        'title': controller
                                                                            .frontOfficeData[index]
                                                                            .category,
                                                                        'subcategories':
                                                                            <SubcategoryPro>[],
                                                                        "id": controller
                                                                            .frontOfficeData[index]
                                                                            .pronunID,
                                                                        "pronunCollectionName":
                                                                            controller.pronunCollectionName,
                                                                      });
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
                                                                  WidgetsBinding
                                                                      .instance
                                                                      .addPostFrameCallback(
                                                                          (_) {
                                                                    kIsWeb
                                                                        ? Get.rootDelegate.offNamed(
                                                                            AppRoutes
                                                                                .pronunciationLabSub,
                                                                            arguments: {
                                                                                'title': controller.frontOfficeData[index].category,
                                                                                'subcategories': <SubcategoryPro>[],
                                                                                "id": controller.frontOfficeData[index].pronunID,
                                                                                "pronunCollectionName": controller.pronunCollectionName,
                                                                              })
                                                                        : Get.toNamed(
                                                                            AppRoutes.pronunciationLabSub,
                                                                            arguments: {
                                                                                'title': controller.frontOfficeData[index].category,
                                                                                'subcategories': <SubcategoryPro>[],
                                                                                "id": controller.frontOfficeData[index].pronunID,
                                                                                "pronunCollectionName": controller.pronunCollectionName,
                                                                              });
                                                                  });
                                                                  // Navigator.push(
                                                                  //     context,
                                                                  //     MaterialPageRoute(
                                                                  //         builder:
                                                                  //             (context) =>
                                                                  //                 AudioListPage()));
                                                                }
                                                              : null,
                                                          child: SizedBox(
                                                            width:
                                                                getWidgetWidth(
                                                                    width: 32),
                                                            height:
                                                                getWidgetHeight(
                                                                    height: 28),
                                                            child: Icon(
                                                              Icons.mic,
                                                              size: 30,
                                                              color: controller
                                                                      .frontOfficeData[
                                                                          index]
                                                                      .pronunID
                                                                      .isNotEmpty
                                                                  ? Colors.black
                                                                  : Colors.grey,
                                                            ),
                                                          ),
                                                        ),
                                                        GestureDetector(
                                                          onTap: linkAvailable2
                                                              ? () {
                                                                  controller
                                                                          .glossaryIndex =
                                                                      glossaryIndex
                                                                          ? -1
                                                                          : index;
                                                                  controller
                                                                      .update();

                                                                  // if (kIsWeb) {
                                                                  //   Navigator.push(
                                                                  //       context,
                                                                  //       MaterialPageRoute(
                                                                  //           builder: (context) =>
                                                                  //               WebContentPage(title: controller.frontOfficeData[index].category, url: controller.frontOfficeData[index].subcategory[2].link)));
                                                                  // } else {
                                                                  //   Get.toNamed(
                                                                  //       AppRoutes
                                                                  //           .inAppWebView,
                                                                  //       arguments: {
                                                                  //         "url": controller
                                                                  //             .frontOfficeData[index]
                                                                  //             .subcategory[2]
                                                                  //             .link
                                                                  //       });
                                                                  // }
                                                                }
                                                              : null,
                                                          child: Image.asset(
                                                            AllAssets.approval,
                                                            color: (isExpanded)
                                                                ? linearColor
                                                                : linkAvailable2
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
                                                      ],
                                                    ),
                                                  ),
                                                if (isExpanded)
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                        left: getWidgetWidth(
                                                            width: 10),
                                                        right: getWidgetWidth(
                                                            width: 80)),
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
                                                    child: ListView.builder(
                                                      shrinkWrap: true,
                                                      itemCount:
                                                          linksToShow.length,
                                                      physics:
                                                          NeverScrollableScrollPhysics(),
                                                      itemBuilder: (context,
                                                          glossaryIndex) {
                                                        final linkItem =
                                                            linksToShow[
                                                                glossaryIndex];
                                                        return Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            GestureDetector(
                                                              onTap: linksToShow[
                                                                              glossaryIndex]
                                                                          [
                                                                          'link']!
                                                                      .isEmpty
                                                                  ? null
                                                                  : () {
                                                                      activityName =
                                                                          "Knowledge Check";

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
                                                                          link: linksToShow[glossaryIndex]
                                                                              [
                                                                              'link']!,
                                                                          proLabTitle:
                                                                              "");
                                                                      log("printing the link here ${linksToShow[glossaryIndex]['link']!}");
                                                                      if (kIsWeb) {
                                                                        Navigator.push(
                                                                            context,
                                                                            MaterialPageRoute(builder: (context) => WebContentPage(title: controller.frontOfficeData[index].category, url: linksToShow[glossaryIndex]['link']!)));
                                                                      } else {
                                                                        Get.toNamed(
                                                                            AppRoutes.inAppWebView,
                                                                            arguments: {
                                                                              "url": linksToShow[glossaryIndex]['link']!
                                                                            });
                                                                      }
                                                                      // ✅ Launch link here
                                                                      // launchUrl(Uri.parse(linkItem['link']!)); → use url_launcher plugin
                                                                    },
                                                              child: Text(
                                                                "> ${linkItem['name']!.isEmpty ? 'Open check' : linkItem['name']}",
                                                                style: TextStyle(
                                                                    color: linksToShow[glossaryIndex]['link']!
                                                                            .isEmpty
                                                                        ? Colors
                                                                            .grey
                                                                        : linearColor),
                                                              ),
                                                            ),
                                                            Padding(
                                                              padding: EdgeInsets
                                                                  .symmetric(
                                                                horizontal: kIsWeb
                                                                    ? 15
                                                                    : getWidgetWidth(
                                                                        width:
                                                                            10),
                                                              ),
                                                              child:
                                                                  const Divider(
                                                                color: Color
                                                                    .fromARGB(
                                                                        57,
                                                                        107,
                                                                        107,
                                                                        107),
                                                              ),
                                                            ),
                                                          ],
                                                        );
                                                      },
                                                    ),
                                                  )
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
