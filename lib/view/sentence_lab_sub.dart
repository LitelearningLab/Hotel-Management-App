import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'package:hotelmanagementapp/controller/sentence_lab_sub_controller.dart';
import 'package:hotelmanagementapp/public/common_function.dart';
import 'package:hotelmanagementapp/public/keys.dart';
import 'package:hotelmanagementapp/route/route_name.dart';
import 'package:hotelmanagementapp/utility/custome_bottom_navigation.dart';
import 'package:hotelmanagementapp/utility/web_top_nav.dart';

class SentenceLabSub extends StatefulWidget {
  const SentenceLabSub({super.key});

  @override
  State<SentenceLabSub> createState() => _SentenceLabSubState();
}

class _SentenceLabSubState extends State<SentenceLabSub> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<SentenceLabSubController>(
      builder: (controller) {
        return Scaffold(
          backgroundColor: const Color(0xFFF8FAFC),

          // ================= MOBILE BOTTOM NAV =================
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          floatingActionButton: kIsWeb ? null : const CustomeBottomNavigation(),

          // ================= MAIN LAYOUT =================
          body: Column(
            children: [
              // ===================================================
              // WEB TOP NAV (already exists in your project)
              // ===================================================
              if (kIsWeb)
                WebHeaderWithNav(
                    title: "Sentence Lab",
                    onBack: () {
                      Get.rootDelegate.offNamed(AppRoutes.sentenceLab);
                    } // Back handled in _pageHeader for better history management
                    ),

              // ===================================================
              // CONTENT AREA
              // ===================================================
              Expanded(
                child: Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ================= PAGE HEADER =================
                      // _pageHeader(controller),

                      const SizedBox(height: 20),

                      // ================= LIST =================
                      Expanded(
                        child: ListView.builder(
                          padding: const EdgeInsets.only(bottom: 120),
                          itemCount: controller.sortedSubcategories.length,
                          itemBuilder: (context, index) {
                            final item = controller.sortedSubcategories[index];

                            log("Showing order: ${item.order}");

                            return Padding(
                              padding: EdgeInsets.symmetric(horizontal: 40),
                              child: _HoverCard(
                                child: InkWell(
                                  focusColor: Colors.transparent,
                                  hoverColor: Colors.transparent,
                                  splashColor: Colors.transparent,
                                  highlightColor: Colors.transparent,
                                  // borderRadius: BorderRadius.circular(14),
                                  onTap: () {
                                    sessionName = item.categoryName;

                                    addToRecentHistory(
                                      path:
                                          "Language Lab > Sentence Lab > ${controller.title}",
                                      category: item.categoryName,
                                      section: "Sentence Lab",
                                      link: "",
                                      proLabTitle: "",
                                      subCategories: item.subCategories,
                                    );

                                    GetStorage()
                                        .write(AppRoutes.sentenceLabSubCat, {
                                      "title": item.categoryName,
                                      "CategoryModel": item.subCategories,
                                    });

                                    kIsWeb
                                        ? Get.rootDelegate.offNamed(
                                            AppRoutes.sentenceLabSubCat,
                                            arguments: {
                                              "title": item.categoryName,
                                              "CategoryModel":
                                                  item.subCategories,
                                            },
                                          )
                                        : Get.toNamed(
                                            AppRoutes.sentenceLabSubCat,
                                            arguments: {
                                              "title": item.categoryName,
                                              "CategoryModel":
                                                  item.subCategories,
                                            },
                                          );
                                  },
                                  child: Container(
                                    margin: const EdgeInsets.only(bottom: 14),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 22,
                                      vertical: 18,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(14),
                                      border: Border.all(
                                        color: const Color(0xFFE5E7EB),
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            item.categoryName,
                                            style: TextStyle(
                                              fontFamily: Keys.fontFamily,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500,
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
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // ==========================================================
  // PAGE HEADER (SINGLE HEADER – NO DUPLICATION)
  // ==========================================================
  Widget _pageHeader(SentenceLabSubController controller) {
    return Padding(
      padding: const EdgeInsets.only(top: 24),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              if (kIsWeb) {
                final box = GetStorage();
                final saved = box.read(AppRoutes.sentenceLab) ?? {};
                Get.rootDelegate.offNamed(
                  AppRoutes.sentenceLab,
                  arguments: {
                    "title": saved['title'] ?? "",
                  },
                );
              } else {
                Navigator.pop(context);
              }
            },
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              controller.title,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// ============================================================
/// HOVER CARD (WEB ONLY SHADOW EFFECT)
/// ============================================================
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
    return MouseRegion(
      onEnter: (_) {
        if (kIsWeb) {
          setState(() => _hovered = true);
        }
      },
      onExit: (_) {
        if (kIsWeb) {
          setState(() => _hovered = false);
        }
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,   
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          boxShadow: _hovered
              ? [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 6),
                  ),
                ]
              : [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.02),
                    blurRadius: 4,
                    offset: const Offset(0, 3),
                  ),
                ],
        ),
        child: widget.child,
      ),
    );
  }
}
