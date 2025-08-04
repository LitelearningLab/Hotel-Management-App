import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hotelmanagementapp/public/all_asset.dart';
import 'package:hotelmanagementapp/public/common_function.dart';
import 'package:hotelmanagementapp/utility/custome_bottom_navigation.dart';
import 'package:intl/intl.dart';

class ContentLab extends StatelessWidget {
  const ContentLab({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> posts = [
      {
        "imageUrl": AllAssets.frontOffice,
        "likes": 120,
        "views": 2400,
        "uploadDate": DateTime.now().subtract(const Duration(days: 2)),
      },
      {
        "imageUrl": AllAssets.accomodationManagement,
        "likes": 89,
        "views": 1321,
        "uploadDate": DateTime.now().subtract(const Duration(days: 5)),
      },
      {
        "imageUrl": AllAssets.houseKeeping,
        "likes": 302,
        "views": 3471,
        "uploadDate": DateTime.now().subtract(const Duration(days: 8)),
      },
    ];

    return Scaffold(
      bottomNavigationBar: CustomeBottomNavigation(),
      appBar: AppBar(
        forceMaterialTransparency: true,
        backgroundColor: Colors.white,
        titleSpacing: 0,
        title: Text(
          "Content Library",
          textAlign: TextAlign.left,
          style: GoogleFonts.inter(
            fontWeight: FontWeight.w600,
            fontSize: 20,
            color: Colors.black,
          ),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: posts.length,
        itemBuilder: (context, index) {
          final post = posts[index];
          return Padding(
            padding: EdgeInsets.symmetric(vertical: getWidgetHeight(height: 5)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image with fallback
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.asset(
                    post["imageUrl"],
                    height: getWidgetHeight(height: 150),
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: getWidgetHeight(height: 150),
                        width: double.infinity,
                        color: Colors.grey[300],
                        alignment: Alignment.center,
                        child: Icon(Icons.broken_image,
                            color: Colors.grey[600], size: 40),
                      );
                    },
                  ),
                ),
                SizedBox(height: getWidgetHeight(height: 10)),
                // Metadata
                Row(
                  children: [
                    Icon(Icons.favorite_border,
                        color: Colors.grey.shade700, size: 20),
                    SizedBox(width: getWidgetWidth(width: 4)),
                    Text("${post["likes"]}",
                        style: TextStyle(color: Colors.grey.shade700)),
                    SizedBox(width: getWidgetWidth(width: 16)),
                    Icon(Icons.remove_red_eye_outlined,
                        color: Colors.grey.shade700, size: 20),
                    SizedBox(width: getWidgetWidth(width: 4)),
                    Text("${post["views"]}",
                        style: TextStyle(color: Colors.grey.shade700)),
                    const Spacer(),
                    Text(
                      DateFormat('dd MMM yyyy').format(post["uploadDate"]),
                      style:
                          TextStyle(color: Colors.grey.shade600, fontSize: 12),
                    ),
                  ],
                ),
                Divider()
              ],
            ),
          );
        },
      ),
    );
  }
}
