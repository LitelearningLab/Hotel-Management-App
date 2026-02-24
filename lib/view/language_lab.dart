import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:hotelmanagementapp/controller/home_controller.dart';
import 'package:hotelmanagementapp/controller/language_lab_controller.dart';
import 'package:hotelmanagementapp/public/all_asset.dart';
import 'package:hotelmanagementapp/public/common_function.dart';
import 'package:hotelmanagementapp/public/constant.dart';
import 'package:hotelmanagementapp/route/route_name.dart';
import 'package:hotelmanagementapp/utility/custome_bottom_navigation.dart';
import 'package:hotelmanagementapp/utility/pe_top_categories_card.dart';
import 'package:hotelmanagementapp/utility/web_top_nav.dart';

class Languagelab extends StatelessWidget {
  const Languagelab({super.key});

  static const double _soundCardHeight = 420;

  @override
  Widget build(BuildContext context) {
    final homeController = Get.put(HomeController());

    return PopScope(
      onPopInvoked: (_) => homeController.loadRecentHistory(),
      child: Scaffold(
        backgroundColor: const Color(0xFFF9FAFB),
        floatingActionButton: kIsWeb ? null : const CustomeBottomNavigation(),
        body: Column(
          children: [
            if (kIsWeb)
              WebHeaderWithNav(title: "Language Lab")
            else
              AppBar(
                title: const Text("Language Lab"),
                leading: BackButton(
                  onPressed: () {
                    homeController.loadRecentHistory();

                    kIsWeb
                        ? Get.rootDelegate.offNamed(AppRoutes.home)
                        : Get.back();
                  },
                ),
              ),
            Expanded(
              child: GetBuilder<LanguageLabController>(
                builder: (controller) {
                  if (controller.isLoading) {
                    return Center(
                      child: CircularProgressIndicator(color: linearColor),
                    );
                  }

                  return SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 32, vertical: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // _pageHeader(),
                        // const SizedBox(height: 24),
                        _categoryGrid(context, controller),
                        const SizedBox(height: 12),

                        Text(
                          "Sounds",
                          style: GoogleFonts.inter(
                            fontSize: 22,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 8),

                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: _soundSectionCard(
                                title: "Important Sounds",
                                child: _importantSounds(controller),
                              ),
                            ),
                            const SizedBox(width: 20),
                            Expanded(
                              child: _soundSectionCard(
                                title: "Vowels",
                                child: _expandableSounds(
                                  controller,
                                  controller.vowelSoundsList,
                                  isVowel: true,
                                ),
                              ),
                            ),
                            const SizedBox(width: 20),
                            Expanded(
                              child: _soundSectionCard(
                                title: "Consonants",
                                child: _expandableSounds(
                                  controller,
                                  controller.consonantSoundsList,
                                  isVowel: false,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ================= HEADER =================
  Widget _pageHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Language Lab",
          style: GoogleFonts.inter(
            fontSize: 28,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          "Practice pronunciation, grammar and sentence construction",
          style: GoogleFonts.inter(
            fontSize: 14,
            color: Colors.grey.shade600,
          ),
        ),
      ],
    );
  }

  // ================= CATEGORY GRID =================
  Widget _categoryGrid(BuildContext context, LanguageLabController controller) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: MediaQuery.of(context).size.width > 1200 ? 4 : 2,
      crossAxisSpacing: 20,
      mainAxisSpacing: 20,
      childAspectRatio: 1.55,
      children: [
        _categoryCard(controller,
            title: "English Pronunciation",
            image: AllAssets.pePl,
            color: const Color(0xFF398480),
            keyName: "english_lab",
            route: AppRoutes.pronunciationLab),
        _categoryCard(controller,
            title: "French Pronunciation",
            image: AllAssets.peScl,
            color: const Color(0xFF445EA9),
            keyName: "french_lab",
            route: AppRoutes.pronunciationLab),
        _categoryCard(controller,
            title: "Sentence Lab",
            image: AllAssets.peCfpl,
            color: const Color(0xFF636CFF),
            keyName: "sentence_lab",
            route: AppRoutes.sentenceLab),
        _categoryCard(controller,
            title: "Grammer Lab",
            image: AllAssets.peGl,
            color: const Color(0xFFDC6379),
            keyName: "grammer_lab",
            route: AppRoutes.grmmaerLab),
      ],
    );
  }

  Widget _categoryCard(
    LanguageLabController controller, {
    required String title,
    required String image,
    required Color color,
    required String keyName,
    required String route,
  }) {
    return PETopCategoriesCard(
      title: title,
      imageUrl: image,
      cardColor: color,
      isUnderConstruction: !controller.isLabActive(keyName),
      onTap: () {
        if (!controller.isLabActive(keyName)) {
          controller.showReviewPopup(Get.context!);
          return;
        }

        mianCategoryTitile = title;
        GetStorage().write(route, {"title": title});
        kIsWeb
            ? Get.rootDelegate.offNamed(route, arguments: {"title": title})
            : Get.toNamed(route, arguments: {"title": title});
      },
      height: null,
      width: null,
    );
  }

  // ================= SOUND CARD =================
  Widget _soundSectionCard({
    required String title,
    required Widget child,
  }) {
    return Container(
      height: _soundCardHeight,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFEDEDED)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style:
                  GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w600)),
          const SizedBox(height: 12),
          const Divider(height: 1),
          const SizedBox(height: 8),
          Expanded(child: child),
        ],
      ),
    );
  }

  // ================= IMPORTANT SOUNDS =================
  Widget _importantSounds(LanguageLabController controller) {
    return ListView.separated(
      itemCount: controller.importantSound?.subcategories.length ?? 0,
      separatorBuilder: (_, __) => const Divider(color: Color(0xFFEDEDED)),
      itemBuilder: (context, index) {
        final item = controller.importantSound!.subcategories[index];

        return _soundTile(
          title: item.name,
          color: linearColor, // ✅ ONLY important sounds
          onTap: () {
            activityName = "Sound Lab";
            subCategoryTitle = item.name;

            addToRecentHistory(
              path: "Language Lab > Important Sounds",
              category: item.name,
              section: "Sound Lab",
              link: "",
              proLabTitle: "",
              soundSubcategory: item,
            );

            GetStorage().write(
              AppRoutes.soundPage,
              {"title": item.name, "soundModel": item},
            );

            kIsWeb
                ? Get.rootDelegate.offNamed(AppRoutes.soundPage,
                    arguments: {"title": item.name, "soundModel": item})
                : Get.toNamed(AppRoutes.soundPage,
                    arguments: {"title": item.name, "soundModel": item});
          },
        );
      },
    );
  }

  // ================= EXPANDABLE =================
  Widget _expandableSounds(
    LanguageLabController controller,
    List list, {
    required bool isVowel,
  }) {
    return ListView.separated(
      itemCount: list.length,
      separatorBuilder: (_, __) => const Divider(color: Color(0xFFEDEDED)),
      itemBuilder: (context, index) {
        final isExpanded = isVowel
            ? controller.expandedVowelIndex == index
            : controller.expandedConsonantIndex == index;

        final sectionColor = controller.colorList[index];

        return Column(
          children: [
            _soundTile(
              title: list[index].category,
              color: sectionColor,
              trailing: Icon(isExpanded
                  ? Icons.keyboard_arrow_up
                  : Icons.keyboard_arrow_down),
              onTap: () {
                if (isVowel) {
                  controller.expandedVowelIndex = isExpanded ? -1 : index;
                } else {
                  controller.expandedConsonantIndex = isExpanded ? -1 : index;
                }
                controller.update();
              },
            ),
            if (isExpanded)
              ...list[index].subcategories.map<Widget>((sub) {
                return Padding(
                  padding: const EdgeInsets.only(left: 28),
                  child: _soundTile(
                    title: sub.name,
                    color: sectionColor.withOpacity(0.35),
                    onTap: () {
                      activityName = "Sound Lab";
                      sessionName = sub.name;

                      addToRecentHistory(
                        path: "Language Lab > ${sub.name}",
                        category: sub.name,
                        section: "Sound Lab",
                        link: "",
                        proLabTitle: "",
                        soundSubcategory: sub,
                      );

                      GetStorage().write(
                        AppRoutes.soundPage,
                        {
                          "title": sub.name,
                          "soundModel": sub,
                        },
                      );

                      kIsWeb
                          ? Get.rootDelegate.offNamed(AppRoutes.soundPage,
                              arguments: {"title": sub.name, "soundModel": sub})
                          : Get.toNamed(AppRoutes.soundPage, arguments: {
                              "title": sub.name,
                              "soundModel": sub
                            });
                    },
                  ),
                );
              }).toList(),
          ],
        );
      },
    );
  }

  // ================= TILE =================
  Widget _soundTile({
    required String title,
    required VoidCallback onTap,
    required Color color,
    Widget? trailing,
  }) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: InkWell(
        hoverColor: linearColor.withOpacity(.06),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Row(
            children: [
              CircleAvatar(
                radius: 16,
                backgroundColor: color,
                child: const Text(
                  "En",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(child: Text(title)),
              trailing ??
                  const Icon(Icons.chevron_right, color: Color(0xFF94A3B8)),
              const SizedBox(width: 30),
            ],
          ),
        ),
      ),
    );
  }
}
