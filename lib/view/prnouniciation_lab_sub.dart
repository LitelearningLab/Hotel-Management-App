import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hotelmanagementapp/public/all_asset.dart';
import 'package:hotelmanagementapp/public/common_function.dart';
import 'package:hotelmanagementapp/public/constant.dart';

class PronunciationLabSub extends StatefulWidget {
  final String title;
  const PronunciationLabSub({required this.title, super.key});

  @override
  State<PronunciationLabSub> createState() => _PronunciationLabSubState();
}

class _PronunciationLabSubState extends State<PronunciationLabSub> {
  int expandedIndex = -1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        forceMaterialTransparency: true,
        surfaceTintColor: Colors.white,
        shadowColor: Colors.white,
        backgroundColor: Colors.white,
        titleSpacing: 0,
        title: Text(
          widget.title, maxLines: 2,
          // textAlign: TextAlign.start,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: ListView.builder(
        padding: EdgeInsets.symmetric(
            vertical: getWidgetHeight(height: 10),
            horizontal: getWidgetWidth(width: 10)),
        itemCount: 10,
        itemBuilder: (context, index) {
          final isExpanded = expandedIndex == index;

          return Column(
            children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    expandedIndex = isExpanded ? -1 : index;
                  });
                },
                child: Container(
                  width: getWidgetWidth(width: 375),
                  // height: getWidgetHeight(height: 60),
                  margin: const EdgeInsets.symmetric(vertical: 5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        offset: const Offset(0, 4),
                        blurRadius: 10,
                      ),
                    ],
                  ),
                  child: Container(
                    width: getWidgetWidth(width: 375),
                    // height: getWidgetHeight(height: 75),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.white,
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: getWidgetHeight(height: 15),
                          horizontal: getWidgetWidth(width: 10)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              ImageIcon(
                                const AssetImage(AllAssets.roundPlay),
                                color: linearColor,
                              ),
                              SizedBox(
                                width: getWidgetWidth(width: 10),
                              ),
                              Text(
                                "Index ${index + 1}",
                                style: GoogleFonts.inter(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              SizedBox(
                                width: getWidgetWidth(width: 10),
                                child: IconButton(
                                    onPressed: () {},
                                    icon: const Icon(
                                      Icons.save_alt,
                                      size: 20,
                                    )),
                              ),
                              SizedBox(
                                width: getWidgetWidth(width: 10),
                              ),
                              IconButton(
                                  onPressed: () {},
                                  icon: const Icon(
                                    Icons.check,
                                    size: 20,
                                  )),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              // Expandable Section
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.fastOutSlowIn,
                height: isExpanded ? getWidgetHeight(height: 150) : 0,
                width: double.infinity,
                child: isExpanded
                    ? Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: getWidgetWidth(width: 15),
                          vertical: getWidgetHeight(height: 10),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "IPA",
                              style: GoogleFonts.inter(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 12,
                                  color: lightWhite),
                            ),
                            SizedBox(
                              height: getWidgetHeight(height: 6),
                            ),
                            Text(
                              "Mon . day",
                              style: GoogleFonts.inter(
                                fontWeight: FontWeight.w600,
                                fontSize: 18,
                              ),
                            ),
                            SizedBox(
                              height: getWidgetHeight(height: 20),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "PRONUNCIATION",
                                      style: GoogleFonts.inter(
                                          fontWeight: FontWeight.w400,
                                          fontSize: 12,
                                          color: lightWhite),
                                    ),
                                    SizedBox(
                                      height: getWidgetHeight(height: 6),
                                    ),
                                    Text(
                                      "Muhn_dey",
                                      style: GoogleFonts.inter(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 18,
                                      ),
                                    ),
                                  ],
                                ),
                                Container(
                                  width: getWidgetWidth(width: 130),
                                  height: getWidgetHeight(height: 45),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    color: Colors.white,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.1),
                                        offset: const Offset(0, 4),
                                        blurRadius: 10,
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      const Icon(
                                        Icons.mic,
                                        color:
                                            Color.fromARGB(255, 112, 112, 112),
                                      ),
                                      Text(
                                        "Practice",
                                        style: GoogleFonts.inter(
                                          color: const Color.fromARGB(
                                              255, 112, 112, 112),
                                          fontWeight: FontWeight.w600,
                                          fontSize: 16,
                                        ),
                                      ),
                                      const SizedBox()
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      )
                    : const SizedBox.shrink(),
              ),
            ],
          );
        },
      ),
    );
  }
}
