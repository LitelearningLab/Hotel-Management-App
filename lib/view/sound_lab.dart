// import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hotelmanagementapp/controller/sound_lab_controller.dart';
import 'package:hotelmanagementapp/model/sound_model.dart';
import 'package:hotelmanagementapp/public/all_asset.dart';
import 'package:hotelmanagementapp/public/common_function.dart';
import 'package:hotelmanagementapp/public/constant.dart';
import 'package:hotelmanagementapp/public/keys.dart';
import 'package:hotelmanagementapp/public/size_helpers.dart';
import 'package:hotelmanagementapp/public/spacing.dart';
import 'package:hotelmanagementapp/route/route_name.dart';
import 'package:hotelmanagementapp/utility/custome_bottom_navigation.dart';

class SoundLab extends StatefulWidget {
  const SoundLab({super.key});

  @override
  State<SoundLab> createState() => _SoundLabState();
}

class _SoundLabState extends State<SoundLab> {
  int expandedIndex = -1;
  @override
  Widget build(BuildContext context) {
    return GetBuilder<SoundLabController>(builder: (controller) {
      return Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: Align(
          alignment: Alignment.bottomCenter,
          child: CustomeBottomNavigation(),
        ),
        appBar: AppBar(
          forceMaterialTransparency: true,
          surfaceTintColor: Colors.white,
          shadowColor: Colors.white,
          backgroundColor: Colors.white,
          titleSpacing: 0,
          title: Text(
            controller.soundSubcategory.name,
            maxLines: 2,
            style: const TextStyle(
              fontFamily: Keys.lucidaFontFamily,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          leading: IconButton(
            onPressed: () {
              final box = GetStorage();
              final saved = box.read(AppRoutes.soundPage) ?? {};

              late SoundSubcategory soundModel;
              final storedSound = saved['soundModel'];
              if (storedSound is Map<String, dynamic>) {
                soundModel = SoundSubcategory.fromJson(storedSound);
              } else if (storedSound is SoundSubcategory) {
                soundModel = storedSound;
              }
              kIsWeb
                  ? Get.rootDelegate.offNamed(AppRoutes.soundPage, arguments: {
                      'title': saved['title'] ?? "Sound Page",
                      'soundModel': soundModel,
                    })
                  : Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back),
          ),
        ),
        body: ListView.builder(
          padding: EdgeInsets.symmetric(
              vertical: getWidgetHeight(height: 10),
              horizontal: getWidgetWidth(width: 10)),
          itemCount: controller.soundSubcategory.soundsPractice?.length,
          itemBuilder: (context, index) {
            final isExpanded = expandedIndex == index;
            final soundPractice =
                controller.soundSubcategory.soundsPractice![index];

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
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.white,
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: displayWidth(context) > 500
                                ? displayHeight(context) * 0.02
                                : getWidgetHeight(height: 6),
                            horizontal: displayWidth(context) > 500
                                ? displayWidth(context) * 0.01
                                : getWidgetWidth(width: 10)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                (controller.loadingIndex == index)
                                    ? SizedBox(
                                        height: getWidgetHeight(
                                            height: displayWidth(context) > 500
                                                ? 20
                                                : 20),
                                        width: getWidgetWidth(
                                            width: displayWidth(context) > 500
                                                ? 8
                                                : 22),
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2.0,
                                          color: linearColor,
                                        ),
                                      )
                                    : (controller.currentlyPlayingIndex ==
                                            index)
                                        ? InkWell(
                                            onTap: () {
                                              controller.handlePlayPause(index);
                                            },
                                            child: Icon(
                                              Icons.pause_circle_outline,
                                              color: linearColor,
                                              size: 26,
                                            ),
                                          )
                                        : controller.errorPlaying == index
                                            ? GestureDetector(
                                                onTap: () {},
                                                child: Icon(
                                                  Icons.info_outline,
                                                  color: Colors.red,
                                                  size: 25,
                                                ),
                                              )
                                            : GestureDetector(
                                                onTap: () {
                                                  controller
                                                      .handlePlayPause(index);
                                                },
                                                child: ImageIcon(
                                                  const AssetImage(
                                                      AllAssets.roundPlay),
                                                  color: linearColor,
                                                ),
                                              ),
                                SizedBox(
                                  width: getWidgetWidth(
                                      width:
                                          displayWidth(context) > 500 ? 4 : 10),
                                ),
                                Text(soundPractice.text,
                                    style: TextStyle(
                                      fontFamily: Keys.fontFamily,
                                      letterSpacing: 0,
                                    )),
                              ],
                            ),
                            if (!kIsWeb)
                              IconButton(
                                onPressed: () {},
                                icon: SizedBox(
                                  height: 19,
                                  width: 19,
                                  child: Image.asset(
                                    AllAssets.save,
                                    width: 18,
                                    color: Colors.black,
                                  ),
                                ),
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
                              RichText(
                                textAlign: TextAlign.justify,
                                text: TextSpan(
                                  children:
                                      buildTextSpans(soundPractice.syllables),
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
                                            fontWeight: FontWeight.w400,
                                            fontSize: 12,
                                            color: lightWhite),
                                      ),
                                      SizedBox(
                                        height: getWidgetHeight(height: 6),
                                      ),
                                      SizedBox(
                                        width: getWidgetWidth(width: 180),
                                        child: Text(
                                          soundPractice.pronun == ""
                                              ? "no data"
                                              : soundPractice.pronun
                                                  .replaceAll("/", ""),
                                          maxLines: 2,
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 20,
                                            fontFamily: Keys.fontFamily,
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                  if (!kIsWeb)
                                    GestureDetector(
                                      onTap: () {
                                        controller.kShowDialog(
                                            soundPractice.text, false, context);
                                      },
                                      child: Container(
                                        width: getWidgetWidth(width: 130),
                                        height: getWidgetHeight(height: 45),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          color: Colors.white,
                                          boxShadow: [
                                            BoxShadow(
                                              color:
                                                  Colors.black.withOpacity(0.1),
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
                                              color: Color.fromARGB(
                                                  255, 112, 112, 112),
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
                                    ),
                                ],
                              ),
                              if (controller.selectedWord.toLowerCase() ==
                                  soundPractice.text.toLowerCase())
                                ListTile(
                                  contentPadding: EdgeInsets.zero,
                                  title: Text(
                                    "Pronunciation Analysis Result",
                                    style: TextStyle(
                                        color: Color(0xFF6C63FF),
                                        fontSize: kText.scale(13),
                                        fontFamily: Keys.fontFamily),
                                  ),
                                  subtitle: Text(
                                    "Note: This result only indicates intelligibility and does not confirm the accuracy of pronunciation.",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: kText.scale(10),
                                        fontFamily: Keys.fontFamily),
                                  ),
                                  trailing: Icon(
                                    controller.isCorrect
                                        ? Icons.check_circle
                                        : Icons.cancel,
                                    color: controller.isCorrect
                                        ? Colors.green
                                        : Colors.red,
                                    size: 45,
                                  ),
                                ),
                              // SPH(10)
                            ],
                          ),
                        )
                      : const SizedBox.shrink(),
                )
              ],
            );
          },
        ),
      );
    });
  }
}
