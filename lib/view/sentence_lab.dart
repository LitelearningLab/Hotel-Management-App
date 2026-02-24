import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:hotelmanagementapp/controller/sentence_lab_controller.dart';
import 'package:hotelmanagementapp/public/all_asset.dart';
import 'package:hotelmanagementapp/public/common_function.dart';
import 'package:hotelmanagementapp/public/constant.dart';
import 'package:hotelmanagementapp/route/route_name.dart';
import 'package:hotelmanagementapp/utility/custome_bottom_navigation.dart';
import 'package:hotelmanagementapp/utility/web_top_nav.dart';

class SentenceLab extends StatefulWidget {
  const SentenceLab({super.key});

  @override
  State<SentenceLab> createState() => _SentenceLabState();
}

class _SentenceLabState extends State<SentenceLab> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<SentenceLabController>(builder: (controller) {
      return Scaffold(
        backgroundColor: const Color(0xFFF7F8FA),

        /// ---------------- BODY ----------------
        body: Column(
          children: [
            /// ---------------- WEB HEADER ----------------
            if (kIsWeb)
              WebHeaderWithNav(
                title: controller.title.value,
                onBack: () {
                  Get.rootDelegate.offNamed(AppRoutes.languageLab);
                },
              ),

            /// ---------------- CONTENT ----------------
            Expanded(
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1200),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 16,
                    ),
                    child: controller.isLoading.value
                        ? _loadingState(controller)
                        : _categoryList(controller),
                  ),
                ),
              ),
            ),
          ],
        ),

        /// ---------------- MOBILE HEADER ----------------
        appBar: kIsWeb
            ? null
            : AppBar(
                backgroundColor: Colors.white,
                elevation: 0,
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.black),
                  onPressed: () {
                    Get.rootDelegate.offNamed(AppRoutes.languageLab);
                  },
                ),
                title: Text(
                  controller.title.value,
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                    color: Colors.black,
                  ),
                ),
              ),

        /// ---------------- MOBILE BOTTOM NAV ----------------
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: kIsWeb ? null : const CustomeBottomNavigation(),
      );
    });
  }

  /// =====================================================
  /// LOADING STATE
  /// =====================================================
  Widget _loadingState(SentenceLabController controller) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(color: linearColor),
          const SizedBox(height: 12),
          if (!controller.hasInitialized)
            const Text(
              "This may take a couple of minutes\n(only during the first time).",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
        ],
      ),
    );
  }

  /// =====================================================
  /// CATEGORY LIST
  /// =====================================================
  Widget _categoryList(SentenceLabController controller) {
    if (controller.sentenceLabList.isEmpty) {
      return const Center(child: Text("No data found"));
    }

    return ListView.separated(
      itemCount: controller.sentenceLabList.length,
      separatorBuilder: (_, __) => const SizedBox(height: 14),
      itemBuilder: (context, index) {
        final item = controller.sentenceLabList[index];

        return _HoverCard(
          onTap: () {
            subCategoryTitle = item.sectionName;

            GetStorage().write(AppRoutes.sentenceLabSub, {
              "title": item.sectionName,
              "subcategories": item.categories,
              "mainCategoryTitle": controller.title.value,
              "index": 6,
              "subCategoryTitle": item.sectionName,
            });

            Get.rootDelegate.offNamed(
              AppRoutes.sentenceLabSub,
              arguments: {
                "title": item.sectionName,
                "subcategories": item.categories,
                "mainCategoryTitle": controller.title.value,
                "index": 6,
                "subCategoryTitle": item.sectionName,
              },
            );
          },
          child: Row(
            children: [
              /// ICON
              Container(
                height: 42,
                width: 42,
                decoration: BoxDecoration(
                  color: controller.sentenceConstructionLabList[index]
                          ['bgColor'] ??
                      Colors.grey.shade200,
                  shape: BoxShape.circle,
                ),
                child: const Center(
                  child: ImageIcon(
                    AssetImage(AllAssets.slQl),
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),

              const SizedBox(width: 16),

              /// TITLE
              Expanded(
                child: Text(
                  _capitalize(item.sectionName),
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
              ),

              const Icon(
                Icons.chevron_right,
                color: Colors.grey,
              ),
            ],
          ),
        );
      },
    );
  }

  String _capitalize(String value) {
    if (value.isEmpty) return value;
    return value[0].toUpperCase() + value.substring(1);
  }
}

/// =====================================================
/// HOVER CARD (WEB POLISH)
/// =====================================================
class _HoverCard extends StatefulWidget {
  final Widget child;
  final VoidCallback onTap;

  const _HoverCard({
    required this.child,
    required this.onTap,
  });

  @override
  State<_HoverCard> createState() => _HoverCardState();
}

class _HoverCardState extends State<_HoverCard> {
  bool _hovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: kIsWeb ? SystemMouseCursors.click : MouseCursor.defer,
      onEnter: (_) {
        if (kIsWeb) setState(() => _hovering = true);
      },
      onExit: (_) {
        if (kIsWeb) setState(() => _hovering = false);
      },
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOut,
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade200),
            boxShadow: _hovering
                ? [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.12),
                      blurRadius: 14,
                      offset: const Offset(0, 6),
                    )
                  ]
                : [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    )
                  ],
          ),
          child: widget.child,
        ),
      ),
    );
  }
}
