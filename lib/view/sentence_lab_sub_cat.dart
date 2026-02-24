import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_launcher_icons/xml_templates.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import 'package:hotelmanagementapp/controller/sentence_lab_sub_cat_controller.dart';
import 'package:hotelmanagementapp/model/sentence_model.dart';
import 'package:hotelmanagementapp/public/common_function.dart';
import 'package:hotelmanagementapp/public/constant.dart';
import 'package:hotelmanagementapp/public/keys.dart';
import 'package:hotelmanagementapp/route/route_name.dart';

class SentenceLabSubCat extends StatefulWidget {
  const SentenceLabSubCat({super.key});

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
    return GetBuilder<SentenceLabSubCatController>(
      builder: (controller) {
        return PopScope(
          onPopInvoked: (_) => stopTimerMainCategory(),
          child: Scaffold(
            backgroundColor: const Color(0xFFF8FAFC),

            // ===================== APP BAR =====================
            appBar: _buildAppBar(controller),

            // ===================== BODY =====================
            body: controller.isLoading
                ? const Center(
                    child:
                        SizedBox(width: 14, child: CircularProgressIndicator()))
                : Column(
                    children: [
                      if (controller.searchController.text.isNotEmpty &&
                          controller.searchController.text.trim() != "")
                        _searchResultLabel(controller),
                      Expanded(
                        child: Center(
                          child: _buildContent(controller),
                        ),
                      ),
                    ],
                  ),
          ),
        );
      },
    );
  }

  // ==========================================================
  // APP BAR
  // ==========================================================
  AppBar _buildAppBar(SentenceLabSubCatController controller) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      titleSpacing: 0,
      title: controller.isSearching
          ? TextField(
              controller: controller.searchController,
              autofocus: true,
              cursorColor: Colors.black,
              decoration: const InputDecoration(
                hintText: "Search...",
                border: InputBorder.none,
              ),
              onChanged: controller.searchSentences,
            )
          : Padding(
              padding: const EdgeInsets.only(right: 16),
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
        icon: Icon(
          controller.isSearching ? Icons.close : Icons.arrow_back,
        ),
        onPressed: () {
          if (controller.isSearching) {
            controller.clearSearch();
          } else {
            // mianCategoryTitile = controller.mainCategoryTitle;
            // subCategoryTitle = controller.title;
            // activityName = "Sentence Lab";
            // timestampIndex = controller.index;
            // sessionName = controller.title;

            stopTimerMainCategory();
            if (kIsWeb) {
              final saved = GetStorage().read(AppRoutes.sentenceLabSub) ?? {};
              Get.rootDelegate.offNamed(
                AppRoutes.sentenceLabSub,
                arguments: {
                  "title": saved['title'] ?? "",
                  "subcategories": saved['subcategories'] ?? [],
                },
              );
            } else {
              Navigator.pop(Get.context!);
            }
          }
        },
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
            } else if (value == 'search') {
              controller.isSearching = true;
            }
            controller.update();
          },
          itemBuilder: (_) => const [
            PopupMenuItem(value: 'search', child: Text('Search')),
            PopupMenuItem(value: 'priority', child: Text('Filter Priority')),
            PopupMenuItem(value: 'all_priority', child: Text('Clear Filter')),
          ],
        ),
      ],
    );
  }

  // ==========================================================
  // CONTENT
  // ==========================================================
  Widget _buildContent(SentenceLabSubCatController controller) {
    if (controller.subcategories.isEmpty) {
      return const Center(child: Text("No Data Found"));
    }

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 120),
      itemCount: controller.subcategories.length,
      itemBuilder: (context, index) {
        final subCategory = controller.subcategories[index];
        final title = toBeginningOfSentenceCase(subCategory.id ?? "") ?? "";

        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 140),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.poppins(
                  color: linearColor,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: subCategory.sentence.length,
                itemBuilder: (context, subIndex) {
                  final sentence = subCategory.sentence[subIndex];
                  final id = index * 1000 + subIndex;
                  final isExpanded = expandedIndex == id;

                  return _HoverSentenceCard(
                    expanded: isExpanded,
                    child: InkWell(
                      focusColor: Colors.transparent,
                      hoverColor: Colors.transparent,
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      onTap: () {
                        setState(() {
                          expandedIndex = isExpanded ? -1 : id;
                        });
                      },
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 14),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: const Color(0xFFE5E7EB),
                          ),
                        ),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    sentence.text,
                                    style: TextStyle(
                                      fontFamily: Keys.fontFamily,
                                    ),
                                  ),
                                ),
                                if (!kIsWeb)
                                  IconButton(
                                    onPressed: () =>
                                        controller.saveUpdate(index, subIndex),
                                    icon: controller.buildDownloadIcon(
                                        index, subIndex),
                                  ),
                              ],
                            ),

                            // ================= EXPAND =================
                            AnimatedSize(
                              duration: const Duration(milliseconds: 250),
                              curve: Curves.easeOut,
                              child: isExpanded
                                  ? Padding(
                                      padding: const EdgeInsets.only(top: 12),
                                      child: Column(
                                        children: [
                                          const Divider(height: 16),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              InkWell(
                                                focusColor: Colors.transparent,
                                                onTap: () {
                                                  controller.handlePlayPause(
                                                      index, subIndex);
                                                },
                                                child: Row(
                                                  children: [
                                                    controller.buildAudioIcon(
                                                        index, subIndex),
                                                    const SizedBox(width: 6),
                                                    const Text(
                                                      "Native Speaker",
                                                      style: TextStyle(
                                                          fontSize: 13),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              if (!kIsWeb) ...[
                                                const SizedBox(width: 24),
                                                InkWell(
                                                  onTap: () {
                                                    controller.kShowDialog(
                                                      subCategory.id,
                                                      sentence.text,
                                                      false,
                                                      context,
                                                    );
                                                  },
                                                  child: const Row(
                                                    children: [
                                                      Icon(Icons.mic),
                                                      SizedBox(width: 6),
                                                      Text("Practice",
                                                          style: TextStyle(
                                                              fontSize: 13)),
                                                    ],
                                                  ),
                                                ),
                                              ]
                                            ],
                                          ),
                                        ],
                                      ),
                                    )
                                  : const SizedBox.shrink(),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  // ==========================================================
  // SEARCH LABEL
  // ==========================================================
  Widget _searchResultLabel(SentenceLabSubCatController controller) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          "Search Results for: ${controller.searchTerm}",
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

// ============================================================
// HOVER EFFECT WRAPPER
// ============================================================
class _HoverSentenceCard extends StatefulWidget {
  final Widget child;
  final bool expanded;

  const _HoverSentenceCard({
    required this.child,
    required this.expanded,
  });

  @override
  State<_HoverSentenceCard> createState() => _HoverSentenceCardState();
}

class _HoverSentenceCardState extends State<_HoverSentenceCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) {
        if (kIsWeb) setState(() => _hovered = true);
      },
      onExit: (_) {
        if (kIsWeb) setState(() => _hovered = false);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOut,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          boxShadow: _hovered && !widget.expanded
              ? [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 3,
                    offset: const Offset(0, 0),
                  ),
                ]
              : [],
        ),
        child: widget.child,
      ),
    );
  }
}
