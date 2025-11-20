// import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hotelmanagementapp/public/common_function.dart';
import 'package:hotelmanagementapp/public/constant.dart';

// import 'package:litelearninglab/constants/all_assets.dart';
//
class PETopCategoriesCard extends StatefulWidget {
  final String title;
  final String imageUrl;
  final Function onTap;
  final Color cardColor;
  final double height;
  final double width;
  final bool isUnderConstruction; // New flag
  const PETopCategoriesCard({
    required this.title,
    required this.imageUrl,
    required this.onTap,
    required this.cardColor,
    required this.height,
    required this.width,
    this.isUnderConstruction = false, // Default false
    Key? key,
  }) : super(key: key);

  @override
  State<PETopCategoriesCard> createState() => _PETopCategoriesCardState();
}

class _PETopCategoriesCardState extends State<PETopCategoriesCard> {
  @override
  void initState() {
    super.initState();
    // startTimerMainCategory("name");
    // subCategoryTitile = widget.title;
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    // final textscalar = MediaQuery.of(context).textScaler;
    return InkWell(
      hoverColor: Colors.transparent,
      focusColor: Colors.transparent,
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: () {
        widget.onTap();
      },
      child: Stack(
        children: [
          Container(
            padding: EdgeInsets.only(
              left: 10,
              top: 12,
            ),
            height: kIsWeb
                ? getWidgetHeight(height: 310)
                : getWidgetHeight(height: 150),
            width: size.width * 0.45,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: widget.cardColor,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(widget.title,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                      fontSize: displayWidth(context) > 500 ? 20 : 16,
                      fontFamily: 'Roboto',
                      letterSpacing: 0,
                    )
                    // textScaler: textscalar,
                    ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Container(
                      // color: Colors.yellow,
                      height: widget.height,
                      // width: widget.width,
                      // decoration: BoxDecoration(
                      //   image: DecorationImage(image: AssetImage(imageUrl),fit: BoxFit.fitHeight)
                      // ),
                      child: Image.asset(
                        fit: BoxFit.fitHeight,
                        widget.imageUrl,
                      )),
                )
              ],
            ),
          ),
          if (widget.isUnderConstruction)
            Container(
                height: kIsWeb
                    ? getWidgetHeight(height: 310)
                    : getWidgetHeight(height: 150),
                width: size.width * 0.45,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.85),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Container(
                    width: displayWidth(context) > 1200
                        ? getWidgetWidth(width: 140)
                        : getWidgetWidth(width: 160),
                    color: primaryDark,
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
