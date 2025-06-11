import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hotelmanagementapp/controller/sentence_lab_controller.dart';
import 'package:hotelmanagementapp/public/all_asset.dart';
import 'package:hotelmanagementapp/public/common_function.dart';
import 'package:hotelmanagementapp/public/constant.dart';
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
                  child: CircularProgressIndicator(
                    color: linearColor,
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
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SentenceLabSub(
                                          title: controller
                                              .sentenceLabList[index].category,
                                          subcategories: controller
                                              .sentenceLabList[index]
                                              .subcategory,
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
                                  vertical: getWidgetHeight(height: 15),
                                  horizontal: getWidgetWidth(width: 10),
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      height: getWidgetHeight(height: 36),
                                      width: getWidgetWidth(width: 36),
                                      decoration: BoxDecoration(
                                          color: controller
                                                      .sentenceConstructionLabList[
                                                  index]['bgColor'] ??
                                              Colors.white,
                                          shape: BoxShape.circle),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: ImageIcon(
                                          AssetImage(
                                            controller.sentenceConstructionLabList[
                                                    index]['image'] ??
                                                AllAssets.plDays,
                                          ),
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: getWidgetWidth(width: 10),
                                    ),
                                    Text(
                                      controller
                                          .sentenceLabList[index].category,
                                      style: GoogleFonts.inter(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 16,
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
