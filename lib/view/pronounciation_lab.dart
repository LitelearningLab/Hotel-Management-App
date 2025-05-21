import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hotelmanagementapp/public/common_function.dart';
import 'package:hotelmanagementapp/view/prnouniciation_lab_sub.dart';

class PronounciationLab extends StatefulWidget {
  final String title;
  const PronounciationLab({required this.title, super.key});

  @override
  State<PronounciationLab> createState() => _PronounciationLabState();
}

class _PronounciationLabState extends State<PronounciationLab> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          forceMaterialTransparency: true,
          // elevation: .50,
          centerTitle: true,
          title: Text(
            widget.title,
            textAlign: TextAlign.start,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back),
          ),
        ),
        body: Padding(
            padding: EdgeInsets.symmetric(
                vertical: getWidgetHeight(height: 10),
                horizontal: getWidgetWidth(width: 10)),
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 10),
              itemCount: 10,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => PronunciationLabSub(
                                      title: "Index ${index + 1}",
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
                                vertical: getWidgetHeight(height: 20),
                                horizontal: getWidgetWidth(width: 20)),
                            child: Text(
                              "Index ${index + 1}",
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
  }
}
