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
      highlightColor: Colors.transparent,

      onTap: () {
        if (!isUnderConstruction) {
          mainCategoryTitle = title;
        }
        onTap();
      },
      child: displayWidth(context) > 1200
          ? Stack(
              children: [
                Container(
                  width: getWidgetWidth(width: 100),
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
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: getWidgetWidth(width: 10)),
                        child: SizedBox(
                            height: getWidgetHeight(height: 180).clamp(90.0, 130.0),
                            child: Image.asset(icon)),
                      ),
                      const SizedBox(height: 12),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12),
                        child: Text(
                          title,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // 🔹 Overlay Layer for "Under Construction"
                if (isUnderConstruction)
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.75),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Container(
                          width: double.infinity,
                          color: linearColor,
                          padding: const EdgeInsets.symmetric(vertical: 6),
                          child: Text(
                            "Under Review",
                            textAlign: TextAlign.center,
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
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
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: getWidgetWidth(width: 10)),
                        child: SizedBox(
                          height: getWidgetHeight(height: 100).clamp(50.0, 90.0),
                          child: Image.asset(icon),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12),
                        child: Text(
                          title,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: isUnderConstruction
                                ? Colors.grey
                                : Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // 🔹 Overlay Layer for "Under Construction"
                if (isUnderConstruction)
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.75),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Container(
                          width: double.infinity,
                          color: linearColor,
                          padding: const EdgeInsets.symmetric(vertical: 6),
                          child: Text(
                            "Under Review",
                            textAlign: TextAlign.center,
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
    );
  }
}
