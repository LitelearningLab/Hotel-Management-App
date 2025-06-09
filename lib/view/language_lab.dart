import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hotelmanagementapp/controller/language_lab_controller.dart';
import 'package:hotelmanagementapp/public/all_asset.dart';
import 'package:hotelmanagementapp/public/common_function.dart';
import 'package:hotelmanagementapp/utility/pe_top_categories_card.dart';

class Languagelab extends StatelessWidget {
  const Languagelab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        forceMaterialTransparency: true,
        backgroundColor: Colors.white,
        titleSpacing: 0,
        title: Text(
          "Langauge Lab",
          textAlign: TextAlign.left,
          style: GoogleFonts.inter(
            fontWeight: FontWeight.w600,
            fontSize: 20,
            color: Colors.black,
          ),
        ),
        leading: Padding(
          padding: EdgeInsets.symmetric(vertical: getWidgetHeight(height: 8)),
          child: IconButton(
            iconSize: 30,
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back),
          ),
        ),
      ),
      body: SafeArea(
        child: GetBuilder<LanguageLabController>(builder: (controller) {
          return ListView(
            padding: const EdgeInsets.all(20),
            children: [
              // Grid View inside a fixed height
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics:
                    const NeverScrollableScrollPhysics(), // prevent inner scrolling
                crossAxisSpacing: getWidgetWidth(width: 10),
                mainAxisSpacing: getWidgetHeight(height: 10),
                childAspectRatio: 1, // Adjust as needed for height/width
                children: [
                  PETopCategoriesCard(
                    height: getWidgetHeight(height: 88.28),
                    width: getWidgetWidth(width: 96.11),
                    title: 'English Pronunciation',
                    imageUrl: AllAssets.pePl,
                    onTap: () async {},
                    cardColor: Color(0xFF398480),
                  ),
                  PETopCategoriesCard(
                    height: getWidgetHeight(height: 88.47),
                    width: getWidgetWidth(width: 103.76),
                    title: 'French Pronunciation',
                    imageUrl: AllAssets.peScl,
                    onTap: () async {},
                    cardColor: Color(0xFF445EA9),
                  ),
                  PETopCategoriesCard(
                    height: getWidgetHeight(height: 88.65),
                    width: getWidgetWidth(width: 106.03),
                    title: 'Sentence Lab',
                    imageUrl: AllAssets.peCfpl,
                    onTap: () async {},
                    cardColor: Color(0xFF636CFF),
                  ),
                  PETopCategoriesCard(
                    height: getWidgetHeight(height: 88),
                    width: getWidgetWidth(width: 130.04),
                    title: 'Grammer Lab',
                    imageUrl: AllAssets.peGl,
                    onTap: () {},
                    cardColor: Color(0xFFDC6379),
                  ),
                ],
              ),
              SizedBox(
                height: getWidgetHeight(height: 20),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    'Sounds',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Roboto',
                      letterSpacing: 0,
                      fontSize: 18,
                    ),
                  ),
                  SizedBox(
                    width: getWidgetWidth(width: 7),
                  ),
                  Column(
                    children: [
                      Text(
                        '( Know more... )',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                          fontFamily: 'Roboto',
                          letterSpacing: 0,
                          fontSize: 13,
                          wordSpacing: 2,
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 2),
                        height: getWidgetHeight(height: 2),
                        color: Colors.black,
                        width: getWidgetWidth(width: 80),
                      )
                    ],
                  ),
                ],
              ),
              SizedBox(
                height: getWidgetHeight(height: 8),
              ),
              Column(
                children: [
                  DefaultTabController(
                    length: 3,
                    child: Column(
                      children: [
                        TabBar(
                          padding: EdgeInsets.zero,
                          splashFactory: InkSplash.splashFactory,
                          splashBorderRadius: BorderRadius.circular(30),
                          enableFeedback: false,
                          indicatorPadding: EdgeInsets.symmetric(vertical: 5),
                          onTap: (int) async {
                            print('/////////// $int');
                            // _onTabChanged(int);
                            controller.ontapTab(int);
                            // tabarController.changeTabarIndex(int);
                          },
                          labelPadding: EdgeInsets.only(right: 10),
                          dividerColor: Colors.transparent,
                          tabAlignment: TabAlignment.start,
                          labelColor: Colors.white,
                          isScrollable: true,
                          physics: AlwaysScrollableScrollPhysics(),
                          unselectedLabelColor: Color(0xFF99A0AE),
                          indicatorColor: Color(0xFF6C63FE),
                          indicatorSize: TabBarIndicatorSize.label,
                          indicator: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              color: Color(0xFF6C63FE)),
                          tabs: [
                            Tab(
                                child: Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              height: 40,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                color: controller.selectedIndex == 0
                                    ? Colors.transparent
                                    : Colors.white,
                                boxShadow: controller.selectedIndex == 0
                                    ? []
                                    : [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.15),
                                          blurRadius: 6,
                                          offset: const Offset(0, 3),
                                        ),
                                      ],
                              ),
                              child: Align(
                                alignment: Alignment.center,
                                child: Text(
                                  'Important Sounds',
                                  style: TextStyle(
                                    color: controller.selectedIndex == 0
                                        ? Colors.white
                                        : const Color(0xFF99A0AE),
                                    fontSize: 12,
                                    fontFamily: 'Roboto',
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            )),
                            Tab(
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 20),
                                height: 40,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.1),
                                      offset: const Offset(0, 4),
                                      blurRadius: 10,
                                    ),
                                  ],
                                  color: controller.selectedIndex == 1
                                      ? Colors.transparent
                                      : Colors.white,
                                ),
                                child: Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                    'Vowels',
                                    style: TextStyle(
                                        color: controller.selectedIndex == 1
                                            ? Colors.white
                                            : Color(0xFF99A0AE),
                                        fontSize: 12,
                                        fontFamily: 'Roboto',
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                              ),
                            ),
                            Tab(
                              child: Container(
                                height: 40,
                                padding: EdgeInsets.symmetric(horizontal: 20),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.1),
                                      offset: const Offset(0, 4),
                                      blurRadius: 10,
                                    ),
                                  ],
                                  color: controller.selectedIndex == 2
                                      ? Colors.transparent
                                      : Colors.white,
                                ),
                                child: Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                    'Consonants',
                                    style: TextStyle(
                                        color: controller.selectedIndex == 2
                                            ? Colors.white
                                            : Color(0xFF99A0AE),
                                        fontSize: 12,
                                        fontFamily: 'Roboto',
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ),
              Scrollbar(
                thickness: 2,
                thumbVisibility: true,
                radius: Radius.circular(10),
                child: ListView.builder(
                  // physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  // separatorBuilder:
                  //     (context, index) => Divider(
                  //   color: Color(0xFF34425D),
                  // ),
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 3),
                          child: InkWell(
                            onTap: () {},
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 12),
                              child: Row(
                                children: [
                                  Text(
                                    'important sounds',
                                    style: TextStyle(
                                      letterSpacing: 0,
                                      color:
                                          const Color.fromARGB(255, 82, 82, 82),
                                      fontWeight: FontWeight.w500,
                                      fontFamily: 'Roboto',
                                      fontSize: 15,
                                    ),
                                  ),
                                  Spacer(),
                                  Icon(
                                    Icons.chevron_right_rounded,
                                    size: 30,
                                    color:
                                        const Color.fromARGB(255, 82, 82, 82),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Divider(
                          color: const Color.fromARGB(255, 82, 82, 82),
                        ),
                      ],
                    );
                  },
                  itemCount: 10,
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}
