import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hotelmanagementapp/model/grammer_lab_model.dart';
import 'package:hotelmanagementapp/public/all_asset.dart';
import 'package:hotelmanagementapp/public/common_function.dart';
import 'package:hotelmanagementapp/public/keys.dart';
import 'package:hotelmanagementapp/utility/custome_bottom_navigation.dart';

class GrammerLabSub extends StatefulWidget {
  final String title;
  final GrammarDoc doc;
  const GrammerLabSub({required this.title, required this.doc, super.key});

  @override
  State<GrammerLabSub> createState() => _GrammerLabSubState();
}

class _GrammerLabSubState extends State<GrammerLabSub> {
  int expandedIndex = -1;
  @override
  void initState() {
    startTimerMainCategory("");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvoked: (didPop) {
        stopTimerMainCategory();
      },
      child: Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: Align(
          alignment: Alignment.bottomCenter,
          child: CustomeBottomNavigation(),
        ),
        appBar: AppBar(
          forceMaterialTransparency: true,
          backgroundColor: Colors.white,
          titleSpacing: 0,
          title: Text(
            widget.title,
            textAlign: TextAlign.left,
            style: GoogleFonts.inter(
              fontWeight: FontWeight.w600,
              fontSize: 20,
              color: Colors.black,
            ),
          ),
        ),
        body: ListView.builder(
          padding: EdgeInsets.symmetric(
              vertical: getWidgetHeight(height: 10),
              horizontal: getWidgetWidth(width: 10)),
          itemCount: widget.doc.subcategory.length,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            final isExpanded = expandedIndex == index;

            return GestureDetector(
              onTap: () {
                setState(() {
                  expandedIndex = isExpanded ? -1 : index;
                });
              },
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      offset: const Offset(0, 4),
                      blurRadius: 10,
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: getWidgetHeight(height: 16),
                        horizontal: getWidgetWidth(width: 10),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              SizedBox(width: getWidgetWidth(width: 10)),
                              Text(
                                widget.doc.subcategory[index].text,
                                style: TextStyle(
                                    fontFamily: Keys.fontFamily,
                                    letterSpacing: 0,
                                    fontSize: 16),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    // Expandable Section
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.fastOutSlowIn,
                      height: isExpanded ? getWidgetHeight(height: 70) : 0,
                      // width: MediaQuery.of(context).size.width * 0.6,
                      padding: EdgeInsets.symmetric(
                        // vertical: getWidgetHeight(height: 10),
                        horizontal: getWidgetWidth(width: 15),
                      ),
                      child: isExpanded
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (isExpanded)
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: getWidgetWidth(width: 10),
                                    ),
                                    child: const Divider(
                                      color: Color.fromARGB(255, 107, 107, 107),
                                    ),
                                  ),
                                SizedBox(
                                  height: getWidgetHeight(height: 10),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 30, right: 30),
                                  child: Row(
                                    children: [
                                      // SPW(35),
                                      // if (!_isPlaying)
                                      InkWell(
                                        onTap: () async {},
                                        child: Row(
                                          children: [
                                            Image.asset(AllAssets.interaction,
                                                width: 25,
                                                height: 25,
                                                color: Colors.black),
                                            // SPW(5),
                                            Text(
                                              "Learning Module",
                                              style: TextStyle(
                                                  fontSize: 13,
                                                  color: Colors.black),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Spacer(),
                                      InkWell(
                                        onTap: () async {},
                                        child: Wrap(
                                          children: [
                                            Image.asset(
                                              AllAssets.approval,
                                              width: 25,
                                              height: 25,
                                              color: Colors.black,
                                            ),
                                            // SPW(5),
                                            Text(
                                              "Exercise",
                                              style: TextStyle(
                                                  fontSize: 13,
                                                  color: Colors.black),
                                            )
                                          ],
                                        ),
                                      ),
                                      // SPW(20),
                                      Spacer(),
                                    ],
                                  ),
                                ),
                              ],
                            )
                          : const SizedBox.shrink(),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
