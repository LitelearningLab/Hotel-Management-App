import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hotelmanagementapp/controller/pronunciation_lab_controller.dart';
import 'package:hotelmanagementapp/public/common_function.dart';
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
                  ? CircularProgressIndicator()
                  : controller.categories.length < 1
                      ? Center(child: Text("No data found"))
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          itemCount: controller.categories!.length,
                          itemBuilder: (context, index) {
                            return Column(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                PronunciationLabSub(
                                                  title: controller
                                                      .categories[index]
                                                      .category,
                                                  subcategories: controller
                                                      .categories[index]
                                                      .subcategories,
                                                )));
                                  },
                                  child: Container(
                                    width: getWidgetWidth(width: 375),
                                    // height: getWidgetHeight(height: 60),
                                    margin:
                                        const EdgeInsets.symmetric(vertical: 5),
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
                                            vertical:
                                                getWidgetHeight(height: 20),
                                            horizontal:
                                                getWidgetWidth(width: 20)),
                                        child: Text(
                                          controller
                                              .categories[index]!.category,
                                          style: GoogleFonts.inter(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        )));
    });
  }
}
