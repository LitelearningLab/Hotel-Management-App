import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hotelmanagementapp/model/university_model.dart';
import 'package:hotelmanagementapp/public/all_asset.dart';
import 'package:hotelmanagementapp/public/common_function.dart';
import 'package:hotelmanagementapp/view/university_lab_sub.dart';

class UniversityLab extends StatefulWidget {
  UniversityModel universityModel;
  UniversityLab({required this.universityModel, Key? key}) : super(key: key);

  @override
  State<UniversityLab> createState() => _UniversityLabState();
}

class _UniversityLabState extends State<UniversityLab> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          forceMaterialTransparency: true,
          backgroundColor: Colors.white,
          titleSpacing: 0,
          title: Text(
            widget.universityModel.collegeName,
            textAlign: TextAlign.left,
            style: GoogleFonts.inter(
              fontWeight: FontWeight.w600,
              fontSize: 20,
              color: Colors.black,
            ),
          )),
      body: Padding(
        padding: EdgeInsets.symmetric(
            vertical: getWidgetHeight(height: 0),
            horizontal: getWidgetWidth(width: 10)),
        child: widget.universityModel.category.length < 1
            ? Center(child: Text("No data found"))
            : ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 10),
                itemCount: widget.universityModel.category.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => UniversityLabSub(
                            category: widget.universityModel.category[index],
                          ),
                        ),
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
                                widget.universityModel.category[index].name,
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
  }
}
