import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hotelmanagementapp/controller/pronunciation_lab_controller.dart';
import 'package:hotelmanagementapp/public/all_asset.dart';
import 'package:hotelmanagementapp/public/common_function.dart';
import 'package:hotelmanagementapp/public/constant.dart';
import 'package:hotelmanagementapp/route/route_name.dart';
import 'package:hotelmanagementapp/utility/custome_bottom_navigation.dart';
import 'package:hotelmanagementapp/view/prnouniciation_lab_sub.dart';

class PronounciationLab extends StatefulWidget {
  // final String title;
  const PronounciationLab({super.key});

  @override
  State<PronounciationLab> createState() => _PronounciationLabState();
}

class _PronounciationLabState extends State<PronounciationLab> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<PronunciationLabController>(builder: (controller) {
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
        body: controller.isLoading.value
            ? Center(
                child: CircularProgressIndicator(
                  color: linearColor,
                ),
              )
            : controller.categories.length < 1
                ? Center(child: Text("No data found"))
                : ListView.builder(
                    padding: EdgeInsets.symmetric(
                        vertical: getWidgetHeight(height: 10),
                        horizontal: getWidgetWidth(width: 15)),
                    itemCount: controller.categories.length,
                    itemBuilder: (context, index) {
                      return Column(
                        children: [
                          GestureDetector(
                            onTap: () {
                              subCategoryTitle =
                                  controller.categories[index].category;
                              addToRecentHistory(
                                  path:
                                      "Language Lab > ${controller.title.value} > ${controller.categories[index].category}",
                                  category:
                                      controller.categories[index].category,
                                  section: "proLab",
                                  link: "",
                                  proLabTitle: "");
                              Get.toNamed(
                                AppRoutes.pronunciationLabSub,
                                arguments: {
                                  'title':
                                      controller.categories[index].category,
                                  'subcategories': controller
                                      .categories[index].subcategories,
                                },
                              );
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
                                    children: [
                                      Container(
                                        height: getWidgetHeight(height: 36),
                                        width: getWidgetWidth(width: 36),
                                        decoration: BoxDecoration(
                                            color:
                                                controller.pronunciationLabList[
                                                        index]['bgColor'] ??
                                                    Colors.white,
                                            shape: BoxShape.circle),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: ImageIcon(
                                            AssetImage(
                                              controller.pronunciationLabList[
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
                                      Expanded(
                                        child: Text(
                                          controller.categories[index].category
                                                  .isNotEmpty
                                              ? controller.categories[index]
                                                      .category[0]
                                                      .toUpperCase() +
                                                  controller.categories[index]
                                                      .category
                                                      .substring(1)
                                              : '',
                                          maxLines: 2,
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
                          ),
                          if (controller.categories.length - 1 == index)
                            SizedBox(
                              height: getWidgetHeight(height: 80),
                            )
                        ],
                      );
                    },
                  ),
      );
    });
  }
}
