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

/* ============================================================
   EXPANDABLE CARD
============================================================ */

class _ExpandableCard extends StatefulWidget {
  final FrontOfficeController controller;
  final int index;
  final bool isExpanded;

  const _ExpandableCard({
    required this.controller,
    required this.index,
    required this.isExpanded,
  });

  @override
  State<_ExpandableCard> createState() => _ExpandableCardState();
}

class _ExpandableCardState extends State<_ExpandableCard> {
  bool hover = false;

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
                              link: "",
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

  void _openWeb(BuildContext context, String url, String title) {
    if (kIsWeb) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => WebContentPage(title: title, url: url),
        ),
      );
    } else {
      Get.toNamed(AppRoutes.inAppWebView, arguments: {"url": url});
    }
  }
}

/* ============================================================
   ICON + LABEL
============================================================ */

class _IconWithLabel extends StatelessWidget {
  final String label;
  final String? asset;
  final IconData? icon;
  final VoidCallback onTap;
  final bool enabled;

  const _IconWithLabel({
    required this.label,
    this.asset,
    this.icon,
    required this.onTap,
    required this.enabled,
  });

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: enabled ? SystemMouseCursors.click : SystemMouseCursors.basic,
      child: GestureDetector(
        onTap: enabled ? onTap : null,
        child: Opacity(
          opacity: enabled ? 1 : 0.35,
          child: Row(
            children: [
              Text(
                label,
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
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
