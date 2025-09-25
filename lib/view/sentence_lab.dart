import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hotelmanagementapp/controller/sentence_lab_controller.dart';
import 'package:hotelmanagementapp/public/all_asset.dart';
import 'package:hotelmanagementapp/public/common_function.dart';
import 'package:hotelmanagementapp/public/constant.dart';
import 'package:hotelmanagementapp/public/size_helpers.dart';
import 'package:hotelmanagementapp/utility/custome_bottom_navigation.dart';
import 'package:hotelmanagementapp/view/sentence_lab_sub.dart';

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
              controller.title.value,
              textAlign: TextAlign.left,
              style: GoogleFonts.inter(
                fontWeight: FontWeight.w600,
                fontSize: 20,
                color: Colors.black,
              ),
            )),
        body: Padding(
          padding: EdgeInsets.symmetric(
              vertical: getWidgetHeight(height: 10),
              horizontal: getWidgetWidth(width: 10)),
          child: controller.isLoading.value
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(
                        color: linearColor,
                      ),
                      SizedBox(height: getWidgetHeight(height: 12)),
                      !controller.hasInitialized
                          ? Text(
                              "This may take a couple of minutes \n(only during the first time).",
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 15),
                              textAlign: TextAlign.center,
                            )
                          : SizedBox.shrink(),
                      SizedBox(height: getWidgetHeight(height: 65)),
                    ],
                  ),
                )
              : controller.sentenceLabList.length < 1
                  ? Center(child: Text("No data found"))
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      itemCount: controller.sentenceLabList.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            subCategoryTitle =
                                controller.sentenceLabList[index].sectionName;
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SentenceLabSub(
                                          title: controller
                                              .sentenceLabList[index]
                                              .sectionName,
                                          subcategories: controller
                                              .sentenceLabList[index]
                                              .categories,
                                        )));
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
                                    vertical: displayWidth(context) > 500
                                        ? displayWidth(context) * 0.01
                                        : getWidgetHeight(height: 15),
                                    horizontal: displayWidth(context) > 500
                                        ? displayWidth(context) * 0.008
                                        : getWidgetWidth(width: 10)),
                                child: Row(
                                  children: [
                                    Container(
                                      height: getWidgetHeight(height: 36),
                                      width: displayWidth(context) > 500
                                          ? displayHeight(context) * 0.04
                                          : getWidgetWidth(width: 36),
                                      decoration: BoxDecoration(
                                          color: controller
                                                      .sentenceConstructionLabList[
                                                  index]['bgColor'] ??
                                              Colors.white,
                                          shape: BoxShape.circle),
                                      child: const Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: ImageIcon(
                                          AssetImage(
                                            AllAssets.slQl,
                                          ),
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: displayWidth(context) > 500
                                          ? displayWidth(context) * 0.01
                                          : getWidgetWidth(width: 10),
                                    ),
                                    Expanded(
                                      child: Text(
                                        controller.sentenceLabList[index]
                                                .sectionName.isNotEmpty
                                            ? controller.sentenceLabList[index]
                                                    .sectionName[0]
                                                    .toUpperCase() +
                                                controller
                                                    .sentenceLabList[index]
                                                    .sectionName
                                                    .substring(1)
                                            : '',
                                        style: GoogleFonts.inter(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 16,
                                        ),
                                      ),
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
      );
    });
  }
}
