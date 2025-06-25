import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hotelmanagementapp/controller/pronunciation_lab_sub_controller.dart';
import 'package:hotelmanagementapp/model/category_model.dart';
import 'package:hotelmanagementapp/public/all_asset.dart';
import 'package:hotelmanagementapp/public/common_function.dart';
import 'package:hotelmanagementapp/public/constant.dart';
import 'package:hotelmanagementapp/public/keys.dart';

class PronunciationLabSub extends StatefulWidget {
  const PronunciationLabSub({super.key});

  @override
  State<PronunciationLabSub> createState() => _PronunciationLabSubState();
}

class _PronunciationLabSubState extends State<PronunciationLabSub> {
  int expandedIndex = -1;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PronunciationLabSubController>(builder: (controller) {
      return Scaffold(
        appBar: AppBar(
          forceMaterialTransparency: true,
          surfaceTintColor: Colors.white,
          shadowColor: Colors.white,
          backgroundColor: Colors.white,
          titleSpacing: 0,
          title: Text(
            controller.title, maxLines: 2,
            // textAlign: TextAlign.start,
            style: const TextStyle(
              fontSize: 18,
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
        body: controller.isLoading
            ? Center(
                child: CircularProgressIndicator(
                  color: linearColor,
                ),
              )
            : controller.subcategories.length < 1
                ? Center(
                    child: Text("No Data Found"),
                  )
                : ListView.builder(
                    padding: EdgeInsets.symmetric(
                        vertical: getWidgetHeight(height: 10),
                        horizontal: getWidgetWidth(width: 10)),
                    itemCount: controller.subcategories.length,
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
                                      vertical: getWidgetHeight(height: 6),
                                      horizontal: getWidgetWidth(width: 10)),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          (controller.loadingIndex == index)
                                              ? SizedBox(
                                                  height: getWidgetHeight(
                                                      height: 25),
                                                  width:
                                                      getWidgetWidth(width: 25),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            3.0),
                                                    child:
                                                        CircularProgressIndicator(
                                                      strokeWidth: 2,
                                                      color: linearColor,
                                                    ),
                                                  ),
                                                )
                                              : (controller
                                                          .currentlyPlayingIndex ==
                                                      index)
                                                  ? InkWell(
                                                      onTap: () {
                                                        controller
                                                            .handlePlayPause(
                                                                index);
                                                      },
                                                      child: Icon(
                                                        Icons
                                                            .pause_circle_outline,
                                                        color: linearColor,
                                                        size: 26,
                                                      ),
                                                    )
                                                  : controller.errorPlaying ==
                                                          index
                                                      ? GestureDetector(
                                                          onTap: () {
                                                            controller
                                                                .handlePlayPause(
                                                                    index);
                                                          },
                                                          child: Icon(
                                                            Icons.info_outline,
                                                            color: Colors.red,
                                                            size: 25,
                                                          ),
                                                        )
                                                      : GestureDetector(
                                                          onTap: () {
                                                            controller
                                                                .handlePlayPause(
                                                                    index);
                                                          },
                                                          child: ImageIcon(
                                                            const AssetImage(
                                                                AllAssets
                                                                    .roundPlay),
                                                            color: linearColor,
                                                          ),
                                                        ),
                                          SizedBox(
                                            width: getWidgetWidth(width: 10),
                                          ),
                                          Text(
                                              controller
                                                  .subcategories[index]!.text,
                                              style: TextStyle(
                                                fontFamily: Keys.fontFamily,
                                                letterSpacing: 0,
                                              )),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          GestureDetector(
                                            onTap: () {
                                              controller.saveUpdate(index);
                                            },
                                            child: SizedBox(
                                              // width: displayWidth(context) / 18.75,
                                              // height: displayHeight(context) / 40.6,
                                              height: 19,
                                              width: 19,
                                              child: ImageIcon(
                                                AssetImage(AllAssets.download),
                                                color: controller
                                                        .isPriorityList[index]
                                                    ? linearColor
                                                    : Colors.black,
                                                // size: size.height * 0.03,
                                              ),
                                            ),
                                          ),
                                          IconButton(
                                            onPressed: () {
                                              controller.saveUpdate(index);
                                            },
                                            icon: SizedBox(
                                              // width: displayWidth(context) / 18.75,
                                              // height: displayHeight(context) / 40.6,
                                              height: 19,
                                              width: 19,
                                              child: Image.asset(
                                                AllAssets.save,
                                                width: 18,
                                                color: controller
                                                        .isPriorityList[index]
                                                    ? linearColor
                                                    : Colors.black,
                                              ),
                                            ),
                                          )
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
                            height:
                                isExpanded ? getWidgetHeight(height: 150) : 0,
                            width: double.infinity,
                            child: isExpanded
                                ? Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: getWidgetWidth(width: 15),
                                      vertical: getWidgetHeight(height: 10),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
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
                                        RichText(
                                          textAlign: TextAlign.justify,
                                          text: TextSpan(
                                            children: _buildTextSpans(controller
                                                .subcategories[index]!
                                                .syllables),
                                          ),
                                        ),
                                        SizedBox(
                                          height: getWidgetHeight(height: 20),
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "PRONUNCIATION",
                                                  style: GoogleFonts.inter(
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      fontSize: 12,
                                                      color: lightWhite),
                                                ),
                                                SizedBox(
                                                  height: getWidgetHeight(
                                                      height: 6),
                                                ),
                                                FittedBox(
                                                  child: Text(
                                                    controller
                                                                .subcategories[
                                                                    index]!
                                                                .pronun
                                                                .trim() ==
                                                            ""
                                                        ? "no data"
                                                        : controller
                                                            .subcategories[
                                                                index]!
                                                            .pronun
                                                            .replaceAll(
                                                                "/", ""),
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 20,
                                                      fontFamily:
                                                          Keys.fontFamily,
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                controller.kShowDialog(
                                                    controller
                                                        .subcategories[index]
                                                        .text,
                                                    false,
                                                    context);
                                              },
                                              child: Container(
                                                width:
                                                    getWidgetWidth(width: 130),
                                                height:
                                                    getWidgetHeight(height: 45),
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                  color: Colors.white,
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Colors.black
                                                          .withOpacity(0.1),
                                                      offset:
                                                          const Offset(0, 4),
                                                      blurRadius: 10,
                                                    ),
                                                  ],
                                                ),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceAround,
                                                  children: [
                                                    const Icon(
                                                      Icons.mic,
                                                      color: Color.fromARGB(
                                                          255, 112, 112, 112),
                                                    ),
                                                    Text(
                                                      "Practice",
                                                      style: GoogleFonts.inter(
                                                        color: const Color
                                                            .fromARGB(
                                                            255, 112, 112, 112),
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontSize: 16,
                                                      ),
                                                    ),
                                                    const SizedBox()
                                                  ],
                                                ),
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
    });
  }

  List<TextSpan> _buildTextSpans(String text) {
    List<TextSpan> spans = [];
    bool isWithinParentheses = false;
    StringBuffer buffer = StringBuffer();

    for (int i = 0; i < text.length; i++) {
      if (text[i] == '(') {
        if (buffer.isNotEmpty) {
          spans.add(TextSpan(
            text: buffer.toString(),
            style: TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.w500,
                fontFamily: Keys.lucidaFontFamily),
          ));
          buffer.clear();
        }
        isWithinParentheses = true;
      } else if (text[i] == ')') {
        spans.add(TextSpan(
          text: ' ${buffer.toString()} ',
          style: TextStyle(
              color: Colors.yellow,
              fontSize: 20,
              fontWeight: FontWeight.w700,
              fontFamily: Keys.lucidaFontFamily),
        ));
        buffer.clear();
        isWithinParentheses = false;
      } else {
        buffer.write(text[i]);
      }
    }
    if (buffer.isNotEmpty) {
      spans.add(TextSpan(
        text: buffer.toString(),
        style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w500,
            fontFamily: Keys.lucidaFontFamily),
      ));
    }

    return spans;
  }
}
