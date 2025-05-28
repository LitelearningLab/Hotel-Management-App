import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hotelmanagementapp/public/all_asset.dart';
import 'package:hotelmanagementapp/public/common_function.dart';
import 'package:hotelmanagementapp/public/constant.dart';
import 'package:hotelmanagementapp/utility/ar_grid_tile.dart';

class ARCallSimulation extends StatefulWidget {
  ARCallSimulation({super.key});

  @override
  State<ARCallSimulation> createState() => _ARCallSimulationState();
}

class _ARCallSimulationState extends State<ARCallSimulation> {
  List<Map<String, dynamic>> gridTileDatas = [
    {
      'tileColor': Color(0xFF009991),
      'title': "Accommodation\nManagement - Front Office",
      'image': "assets/Front Office.png",
      'ellipse': AllAssets.argreenEllipse
    },
    {
      'tileColor': Color(0xFF4040CA),
      'title': "Food & Beverage Service\nManagement",
      'image': "assets/F&B.png",
      'ellipse': AllAssets.arblueEllipse
    },
    {
      'tileColor': Color(0xFFDC6379),
      'title': 'Food Production',
      'image': "assets/Chef.png",
      'ellipse': AllAssets.arpinkEllipse
    },
    {
      'tileColor': Color(0xFF8540C8),
      'title': 'Accommodation\nManagement - Housekeeping',
      'image': "assets/Housekeeping.png",
      'ellipse': AllAssets.arpurpleEllipse
    },
    {
      'tileColor': Color(0xFF009991),
      'title': "Mock Interview",
      'image': "assets/Interview.png",
      'ellipse': AllAssets.argreenEllipse
    },
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          forceMaterialTransparency: true,
          backgroundColor: Colors.white,
          titleSpacing: 0,
          title: Text(
            "Interactive Simulations",
            textAlign: TextAlign.left,
            style: GoogleFonts.inter(
              fontWeight: FontWeight.w600,
              fontSize: 20,
              color: Colors.black,
            ),
          )),
      body: SafeArea(
          child: Padding(
        padding: EdgeInsets.symmetric(
            vertical: getWidgetWidth(width: 20),
            horizontal: getWidgetHeight(height: 20)),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    children: [
                      ARGridTile(
                        onTap: () async {},
                        tileColor: gridTileDatas[0]['tileColor'],
                        title: gridTileDatas[0]['title']!,
                        icon: gridTileDatas[0]['image'],
                        ellipse: gridTileDatas[0]['ellipse'],
                      ),
                      SizedBox(
                        height: getWidgetHeight(height: 20),
                      ),
                      ARGridTile(
                        onTap: () async {},
                        tileColor: gridTileDatas[3]['tileColor'],
                        title: gridTileDatas[3]['title']!,
                        icon: gridTileDatas[3]['image'],
                        ellipse: gridTileDatas[3]['ellipse'],
                      ),
                      SizedBox(
                        height: getWidgetHeight(height: 20),
                      ),
                      ARGridTile(
                        onTap: () async {},
                        height: getWidgetHeight(height: 180),
                        tileColor: gridTileDatas[4]['tileColor'],
                        title: gridTileDatas[4]['title']!,
                        icon: gridTileDatas[4]['image'],
                        ellipse: gridTileDatas[4]['ellipse'],
                      ),
                    ],
                  ),
                  const Spacer(),
                  Column(
                    children: [
                      SizedBox(
                        height: getWidgetHeight(height: 40),
                      ),
                      ARGridTile(
                        onTap: () async {},
                        tileColor: gridTileDatas[1]['tileColor'],
                        title: gridTileDatas[1]['title']!,
                        icon: gridTileDatas[1]['image'],
                        ellipse: gridTileDatas[1]['ellipse'],
                      ),
                      SizedBox(
                        height: getWidgetHeight(height: 20),
                      ),
                      ARGridTile(
                        onTap: () async {},
                        tileColor: gridTileDatas[2]['tileColor'],
                        title: gridTileDatas[2]['title']!,
                        icon: gridTileDatas[2]['image'],
                        ellipse: gridTileDatas[2]['ellipse'],
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      )),
    );
  }
}
