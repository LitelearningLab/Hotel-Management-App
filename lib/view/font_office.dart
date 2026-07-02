import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:hotelmanagementapp/controller/front_office_controller.dart';
import 'package:hotelmanagementapp/controller/home_controller.dart';
import 'package:hotelmanagementapp/model/subcategoryPro_hive_model.freezed.dart'
    show SubcategoryPro;
import 'package:hotelmanagementapp/public/all_asset.dart';
import 'package:hotelmanagementapp/public/common_function.dart';
import 'package:hotelmanagementapp/public/constant.dart';
import 'package:hotelmanagementapp/public/keys.dart';
import 'package:hotelmanagementapp/route/route_name.dart';
import 'package:hotelmanagementapp/utility/web_view_page.dart';

class FrontOfficeHotelReception extends StatelessWidget {
  const FrontOfficeHotelReception({super.key});

  @override
  Widget build(BuildContext context) {
    final homeController = Get.put(HomeController());

    return PopScope(
      onPopInvoked: (_) => homeController.loadRecentHistory(),
      child: Scaffold(
        backgroundColor: const Color(0xFFF9FAFB),
        body: SafeArea(
          child: GetBuilder<FrontOfficeController>(
            builder: (controller) {
              final width = MediaQuery.of(context).size.width;

              return Column(
                children: [
                  _HeaderSection(
                    controller: controller,
                    width: width,
                    homeController: homeController,
                  ),
                  const Divider(height: 1),
                  Expanded(
                    child: controller.loading
                        ? Center(
                            child: CircularProgressIndicator(
                              color: linearColor,
                            ),
                          )
                        : ListView.builder(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 24, vertical: 20),
                            itemCount: controller.frontOfficeData.length,
                            itemBuilder: (context, index) {
                              final isExpanded =
                                  controller.expandedIndex == index;
                              mainCategoryTitle = controller.title;
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10),
                                child: _ExpandableCard(
                                  controller: controller,
                                  index: index,
                                  isExpanded: isExpanded,
                                ),
                              );
                            },
                          ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

/* ============================================================
   HEADER
============================================================ */

class _HeaderSection extends StatelessWidget {
  final FrontOfficeController controller;
  final HomeController homeController;
  final double width;

  const _HeaderSection({
    required this.controller,
    required this.width,
    required this.homeController,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 8, 24, 8),
      child: Row(
        children: [
          MouseRegion(
            cursor: SystemMouseCursors.click,
            child: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                homeController.loadRecentHistory();

                if (kIsWeb) {
                  Get.rootDelegate.offNamed(AppRoutes.home);
                } else {
                  Get.back();
                }
              },
            ),
          ),
          const SizedBox(width: 12),
          if (controller.image.isNotEmpty)
            SvgPicture.asset(
              controller.image,
              width: 160,
              height: 160,
              fit: BoxFit.contain,
            )
          else
            const SizedBox(width: 160, height: 160),
          const SizedBox(width: 24),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  controller.title,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                    fontFamily: Keys.fontFamily,
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: controller.searchController,
                  cursorColor: Colors.black,
                  decoration: InputDecoration(
                    hintText: "Search topic...",
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 10),
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.black),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(color: Colors.black, width: 1.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: controller.clearSearch,
                    ),
                  ),
                  onChanged: controller.searchByCategory,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _FrontOfficeHotelReceptionState extends State<FrontOfficeHotelReception> {
  HomeController homeController = Get.put<HomeController>(HomeController());

  Widget _actionItem({
    required Widget icon,
    required String label,
    Color? labelColor,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          icon,
          const SizedBox(height: 6),
          Text(
            label,
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              fontSize: 8.5,
              fontWeight: FontWeight.w500,
              color: labelColor ?? Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final item = widget.controller.frontOfficeData[widget.index];

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => hover = true),
      onExit: (_) => setState(() => hover = false),
      child: GestureDetector(
        onTap: () {
          widget.controller.expandedIndex =
              widget.isExpanded ? -1 : widget.index;
          widget.controller.update();
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: const Color(0xFFE5E7EB)),
            boxShadow: hover
                ? [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 18,
                      offset: const Offset(0, 8),
                    ),
                  ]
                : [],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      item.category,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                        fontFamily: Keys.fontFamily,
                      ),
                    ),
                  ),
                  Icon(widget.isExpanded
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down),
                ],
              ),
              if (widget.isExpanded) ...[
                const Divider(),
                const SizedBox(height: 14),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _IconWithLabel(
                      label: "E-Learning",
                      asset: AllAssets.interaction,
                      enabled: item.subcategory[0].link.isNotEmpty,
                      onTap: () {
                        activityName = "E-Learning";
                        subCategoryTitle = item.category;
                        addToRecentHistory(
                            path:
                                "Core Department > ${widget.controller.title} ",
                            category: subCategoryTitle,
                            section: activityName,
                            link: item.subcategory[0].link,
                            proLabTitle: "");
                        _openWeb(
                            context, item.subcategory[0].link, item.category);
                      },
                    ),
                    const SizedBox(width: 28),
                    _IconWithLabel(
                      label: "Glossary",
                      asset: AllAssets.bookIcon,
                      enabled: item.subcategory[1].link.isNotEmpty,
                      onTap: () {
                        activityName = "Glossary";
                        subCategoryTitle = item.category;
                        addToRecentHistory(
                            path:
                                "Core Department > ${widget.controller.title} ",
                            category: subCategoryTitle,
                            section: activityName,
                            link: item.subcategory[1].link,
                            proLabTitle: "");
                        _openWeb(
                            context, item.subcategory[1].link, item.category);
                      },
                    ),
                    const SizedBox(width: 28),
                    _IconWithLabel(
                        label: "Pronunciation",
                        icon: Icons.mic,
                        enabled: item.pronunID.isNotEmpty,
                        onTap: () {
                          widget.controller.loading = true;
                          widget.controller.update();
                          if (kDebugMode) {
                            print("pronunID: ${item.pronunID}");
                          }

                          activityName = "Prounciation Lab";
                          debugPrint(
                              "pronunCollectionName: ${widget.controller.pronunCollectionName}");

                          subCategoryTitle = item.category;
                          mainCategoryTitle = widget.controller.title;
                          GetStorage()
                              .write(AppRoutes.pronunciationLabSubStoreKey, {
                            'title': item.category,
                            'subcategories': <SubcategoryPro>[],
                            "id": item.pronunID,
                            "pronunCollectionName":
                                widget.controller.pronunCollectionName,
                            'index': widget.controller.index,
                            'mainCategoryTitle': widget.controller.title,
                          });
                          addToRecentHistory(
                              path:
                                  "Core Department > ${widget.controller.title}",
                              category: subCategoryTitle,
                              section: "Pronunciation Lab",
                              link: item.pronunID,
                              proLabTitle: "");
                          widget.controller.loading = false;
                          widget.controller.update();
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            kIsWeb
                                ? Get.rootDelegate.offNamed(
                                    AppRoutes.pronunciationLabSub,
                                    arguments: {
                                        'title': item.category,
                                        'subcategories': <SubcategoryPro>[],
                                        "id": item.pronunID,
                                        "pronunCollectionName": widget
                                            .controller.pronunCollectionName,
                                        'index': widget.controller.index,
                                        'mainCategoryTitle':
                                            widget.controller.title,
                                      })
                                : Get.toNamed(AppRoutes.pronunciationLabSub,
                                    arguments: {
                                        'title': item.category,
                                        'subcategories': <SubcategoryPro>[],
                                        "id": item.pronunID,
                                        "pronunCollectionName": widget
                                            .controller.pronunCollectionName,
                                        'index': widget.controller.index,
                                        'mainCategoryTitle':
                                            widget.controller.title,
                                      });
                          });
                        }),
                  ],
                ),
                const SizedBox(height: 12),
                Divider(
                  height: 1,
                  thickness: 0.6,
                  color: Colors.black.withOpacity(0.12),
                ),
                const SizedBox(height: 10),
                if (item.subcategory.length > 2)
                  ...item.subcategory[2].linkList.map((e) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 6),
                      child: MouseRegion(
                        cursor: e['link']!.isNotEmpty
                            ? SystemMouseCursors.click
                            : SystemMouseCursors.basic,
                        child: GestureDetector(
                          onTap: e['link']!.isEmpty
                              ? null
                              : () {
                                  subCategoryTitle = item.category;
                                  activityName = "Quiz";
                                  addToRecentHistory(
                                      path:
                                          "Core Department > ${widget.controller.title}",
                                      category: subCategoryTitle,
                                      section: activityName,
                                      link: e['link']!,
                                      proLabTitle: "");
                                  _openWeb(context, e['link']!, item.category);
                                },
                          child: Row(
                            children: [
                              Text(
                                "›",
                                style: GoogleFonts.inter(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: e['link']!.isEmpty
                                      ? Colors.grey
                                      : linearColor,
                                ),
                              ),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  e['name']!,
                                  style: GoogleFonts.inter(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: e['link']!.isEmpty
                                        ? Colors.grey
                                        : linearColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }).toList(),
              ],
            ],
          ),
        ),
      ),
    );
  }

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
                                                              .spaceAround,
                                                      children: [
                                                        _actionItem(
                                                          label: "E-Learning",
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
                                                          icon: Image.asset(
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
                                                        _actionItem(
                                                          label: "Glossary",
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
                                                          icon: Image.asset(
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
                                                        _actionItem(
                                                          label:
                                                              "Pronunciation",
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

/* ============================================================
   ICON + LABEL
============================================================ */

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
                                                                          "Pronunciation Lab",
                                                                      link: "",
                                                                      proLabTitle:
                                                                          "",
                                                                      proSubcategories: <SubcategoryPro>[],
                                                                      pronunCollectionName:
                                                                          controller
                                                                              .pronunCollectionName,
                                                                      proId: controller
                                                                          .frontOfficeData[
                                                                              index]
                                                                          .pronunID);
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
                                                                }
                                                              : null,
                                                          icon: SizedBox(
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
                                                        // _actionItem(
                                                        //   label:
                                                        //       "Knowledge Check",
                                                        //   labelColor: (isExpanded)
                                                        //       ? linearColor
                                                        //       : linkAvailable2
                                                        //           ? Colors.black
                                                        //           : Colors.grey,
                                                        //   onTap: linkAvailable2
                                                        //       ? () {
                                                        //           controller
                                                        //                   .glossaryIndex =
                                                        //               glossaryIndex
                                                        //                   ? -1
                                                        //                   : index;
                                                        //           controller
                                                        //               .update();
                                                        //         }
                                                        //       : null,
                                                        //   icon: Image.asset(
                                                        //     AllAssets.approval,
                                                        //     color: (isExpanded)
                                                        //         ? linearColor
                                                        //         : linkAvailable2
                                                        //             ? Colors
                                                        //                 .black
                                                        //             : Colors
                                                        //                 .grey,
                                                        //     width:
                                                        //         getWidgetWidth(
                                                        //             width: 22),
                                                        //     height:
                                                        //         getWidgetHeight(
                                                        //             height: 26),
                                                        //   ),
                                                        // ),
                                                      ],
                                                    ),
                                                  ),
                                                if (isExpanded)
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                        left: getWidgetWidth(
                                                            width: 10),
                                                        right: getWidgetWidth(
                                                            width: 10)),
                                                    child: const Divider(
                                                      thickness: 0.3,
                                                      // height: 1,
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
                                                              child: glossaryIndex ==
                                                                      linksToShow
                                                                              .length -
                                                                          1
                                                                  ? const SizedBox
                                                                      .shrink()
                                                                  : const Divider(
                                                                      color: Color.fromARGB(
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
              const SizedBox(width: 6),
              asset != null
                  ? Image.asset(asset!, width: 28, height: 28)
                  : Icon(icon, size: 30),
            ],
          ),
        ),
      ),
    );
  }
}
