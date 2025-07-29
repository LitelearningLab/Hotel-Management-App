import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hotelmanagementapp/controller/grammer_lab_controller.dart';
import 'package:hotelmanagementapp/public/all_asset.dart';
import 'package:hotelmanagementapp/public/common_function.dart';
import 'package:hotelmanagementapp/public/constant.dart';
import 'package:hotelmanagementapp/utility/custome_bottom_navigation.dart';
import 'package:hotelmanagementapp/view/grammer_lab_sub.dart';

class GrammerLab extends StatefulWidget {
  const GrammerLab({super.key});

  @override
  State<GrammerLab> createState() => _GrammerLabState();
}

class _GrammerLabState extends State<GrammerLab> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<GrammerLabController>(builder: (controller) {
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
                  child: CircularProgressIndicator(
                    color: linearColor,
                  ),
                )
              : controller.grammarDocs.length < 1
                  ? Center(child: Text("No data found"))
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      itemCount: controller.grammarDocs.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            subCategoryTitle =
                                controller.grammarDocs[index].category;
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => GrammerLabSub(
                                          title: controller
                                              .grammarDocs[index].category,
                                          doc: controller.grammarDocs[index],
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
                                    horizontal: getWidgetWidth(width: 10)),
                                child: Row(
                                  children: [
                                    Container(
                                      height: getWidgetHeight(height: 36),
                                      width: getWidgetWidth(width: 36),
                                      decoration: BoxDecoration(
                                          color: controller.grammarCheckLabList[
                                                  index]['bgColor'] ??
                                              Colors.white,
                                          shape: BoxShape.circle),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: ImageIcon(
                                          AssetImage(
                                            controller.grammarCheckLabList[
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
                                      controller.grammarDocs[index].category,
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
