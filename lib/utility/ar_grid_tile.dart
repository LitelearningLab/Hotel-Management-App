import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hotelmanagementapp/public/common_function.dart';

class ARGridTile extends StatelessWidget {
  final Function onTap;
  final Color tileColor;
  final String title;
  final String icon;
  final String ellipse;
  double? height;
  ARGridTile(
      {required this.onTap,
      required this.tileColor,
      required this.title,
      required this.icon,
      required this.ellipse,
      this.height,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onTap();
      },
      child: Container(
        // height: getWidgetHeight(height: 230),
        width: getWidgetWidth(width: 160),
        height: height,
        padding: EdgeInsets.symmetric(vertical: getWidgetHeight(height: 5)),
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
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              // mainAxisAlignment: MainAxisAlignment.,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: getWidgetWidth(width: 10)),
                  child: Align(
                    // alignment: Alignment.bottomRight,
                    child: SizedBox(
                      // height: displayHeight(context) * 0.061,
                      // width: displayWidth(context) * 0.133,
                      height: getWidgetHeight(height: 100),
                      // width: 50,
                      child: Image.asset(
                        icon,
                        // gridTileDatas[0]['image'],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10, top: 10, right: 20),
                  child: Text(
                    title,
                    textAlign: TextAlign.start,
                    // overflow: TextOverflow.fade,
                    style: GoogleFonts.inter(
                      // fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                ),
                SizedBox(
                  height: getWidgetHeight(height: 20),
                )
              ],
            ),
            // Align(
            //   alignment: Alignment.bottomLeft,
            //   child: ClipRRect(
            //     borderRadius: BorderRadius.only(
            //       bottomLeft: Radius.circular(10),
            //     ),
            //     child: Image.asset(
            //       ellipse,
            //       // gridTileDatas[0]['ellipse'],
            //       scale: 3.5,
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
