import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hotelmanagementapp/public/common_function.dart';
import 'package:hotelmanagementapp/public/constant.dart';

class ARGridTile extends StatelessWidget {
  final Function onTap;
  final Color tileColor;
  final String title;
  final String icon;
  final String ellipse;
  final double? height;
  final bool isUnderConstruction; // 🔹 new flag

  const ARGridTile({
    required this.onTap,
    required this.tileColor,
    required this.title,
    required this.icon,
    required this.ellipse,
    this.height,
    this.isUnderConstruction = false, // 🔹 default false
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      hoverColor: Colors.transparent,
      splashColor: Colors.transparent,
      focusColor: Colors.transparent,
      // overlayColor: Colors.transparent,
      highlightColor: Colors.transparent,

      onTap: () {
        if (!isUnderConstruction) {
          mianCategoryTitile = title;
        }
        onTap();
      },
      child: displayWidth(context) > 1200
          ? Stack(
              children: [
                Container(
                  width: getWidgetWidth(width: 100),
                  // height: getWidgetHeight(height: 100),/
                  padding: EdgeInsets.symmetric(
                      vertical: getWidgetHeight(height: 5)),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        offset: const Offset(0, 5),
                        blurRadius: 10,
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: getWidgetWidth(width: 10)),
                        child: SizedBox(
                            height: getWidgetHeight(height: 180),
                            child: Image.asset(icon)),
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.only(left: 10, top: 20, right: 20),
                        child: Text(
                          title,
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      SizedBox(height: getWidgetHeight(height: 20)),
                    ],
                  ),
                ),

                // 🔹 Overlay Layer for "Under Construction"
                if (isUnderConstruction)
                  Container(
                      width: getWidgetWidth(width: 100),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.75),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Container(
                          width: displayWidth(context) > 1200
                              ? getWidgetWidth(width: 140)
                              : getWidgetWidth(width: 160),
                          color: linearColor,
                          child: Text("Under Review",
                              textAlign: TextAlign.center,
                              style: GoogleFonts.inter(
                                  fontSize: 16,
                                  color: Colors.white,
                                  fontWeight: FontWeight.normal)),
                        ),
                      )),
              ],
            )
          : Stack(
              children: [
                Container(
                  width: displayWidth(context) > 1200
                      ? getWidgetWidth(width: 140)
                      : getWidgetWidth(width: 160),
                  height: height,
                  padding: EdgeInsets.symmetric(
                      vertical: getWidgetHeight(height: 5)),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        offset: const Offset(0, 4),
                        blurRadius: 10,
                      ),
                    ],
                  ),
                  child: displayWidth(context) > 1200
                      ? Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: getWidgetWidth(width: 10)),
                              child: SizedBox(
                                height: getWidgetHeight(height: 100),
                                child: Image.asset(icon),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 10, top: 10, right: 20),
                              child: Text(
                                title,
                                style: GoogleFonts.inter(
                                  fontSize: 14,
                                  color: isUnderConstruction
                                      ? Colors.grey
                                      : Colors.black, // 🔹 title color
                                ),
                              ),
                            ),
                          ],
                        )
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: getWidgetWidth(width: 10)),
                              child: SizedBox(
                                height: getWidgetHeight(height: 100),
                                child: Image.asset(icon),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 10, top: 10, right: 20),
                              child: Text(
                                title,
                                style: GoogleFonts.inter(
                                  fontSize: 14,
                                  color: isUnderConstruction
                                      ? Colors.grey
                                      : Colors.black,
                                ),
                              ),
                            ),
                            SizedBox(height: getWidgetHeight(height: 20)),
                          ],
                        ),
                ),

                // 🔹 Overlay Layer for "Under Construction"
                if (isUnderConstruction)
                  Container(
                      width: displayWidth(context) > 1200
                          ? getWidgetWidth(width: 140)
                          : getWidgetWidth(width: 160),
                      height: displayWidth(context) > 1200
                          ? getWidgetHeight(height: 110)
                          : getWidgetHeight(height: 180),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.75),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Container(
                          width: displayWidth(context) > 1200
                              ? getWidgetWidth(width: 140)
                              : getWidgetWidth(width: 160),
                          color: linearColor,
                          child: Text("Under Review",
                              textAlign: TextAlign.center,
                              style: GoogleFonts.inter(
                                  fontSize: 16,
                                  color: Colors.white,
                                  fontWeight: FontWeight.normal)),
                        ),
                      )),
              ],
            ),
    );
  }
}
