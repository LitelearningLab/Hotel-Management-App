import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hotelmanagementapp/model/university_model.dart';
import 'package:hotelmanagementapp/public/common_function.dart';
import 'package:hotelmanagementapp/public/keys.dart';
import 'package:hotelmanagementapp/route/route_name.dart';
import 'package:hotelmanagementapp/utility/in_aapp_web.dart';
import 'package:hotelmanagementapp/utility/pdf_viewer_page.dart';

class UniversityLabSub extends StatefulWidget {
  UniversityCategory category;
  UniversityLabSub({required this.category, super.key});
  @override
  State<UniversityLabSub> createState() => _UniversityLabSubState();
}

class _UniversityLabSubState extends State<UniversityLabSub> {
  @override
  Widget build(BuildContext context) {
    double isKwidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
          forceMaterialTransparency: true,
          backgroundColor: Colors.white,
          titleSpacing: 0,
          title: Text(
            widget.category.name,
            textAlign: TextAlign.left,
            style: TextStyle(
              fontFamily: Keys.fontFamily,
              fontWeight: FontWeight.w600,
              fontSize: kText.scale(isKwidth > 700 ? 25 : 20),
              color: Colors.black,
            ),
          )),
      body: Padding(
        padding: EdgeInsets.symmetric(
            vertical: getWidgetHeight(height: 0),
            horizontal: getWidgetWidth(width: 10)),
        child: widget.category.subcategory.length < 1
            ? Center(child: Text("No data found"))
            : ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 10),
                itemCount: widget.category.subcategory.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      final sub = widget.category.subcategory[index];
                      if (sub.link.isNotEmpty) {
                        Get.toNamed(
                          AppRoutes.inAppWebView,
                          arguments: {
                            "url": sub.link,
                          },
                        );
                      }
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
                              horizontal:
                                  getWidgetWidth(width: kIsWeb ? 0 : 10)),
                          child: Row(
                            children: [
                              // Container(
                              //   height: getWidgetHeight(height: 36),
                              //   width: getWidgetWidth(width: 36),
                              //   decoration: BoxDecoration(
                              //       color: Color(0xFF8540C8),
                              //       shape: BoxShape.circle),
                              //   child: Padding(
                              //     padding: const EdgeInsets.all(8.0),
                              //     child: ImageIcon(
                              //       AssetImage(
                              //         AllAssets.plDays,
                              //       ),
                              //       color: Colors.white,
                              //     ),
                              //   ),
                              // ),
                              SizedBox(
                                width: getWidgetWidth(width: kIsWeb ? 5 : 10),
                              ),
                              Text(
                                widget.category.subcategory[index].text,
                                style: TextStyle(
                                  fontFamily: Keys.fontFamily,
                                  fontWeight: FontWeight.w500,
                                  fontSize: kText.scale(isKwidth > 700 ? 16 : 14),
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
  }
}
