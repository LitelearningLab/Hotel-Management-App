import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hotelmanagementapp/controller/simulation_controller.dart';
import 'package:hotelmanagementapp/public/all_asset.dart';
import 'package:hotelmanagementapp/public/common_function.dart';
import 'package:hotelmanagementapp/public/constant.dart';
import 'package:hotelmanagementapp/utility/ar_grid_tile.dart';

class ARCallSimulation extends StatelessWidget {
  ARCallSimulation({super.key});

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
          child: GetBuilder<SimulationController>(builder: (controller) {
            return controller.loading
                ? SizedBox(
                    height: MediaQuery.of(context).size.height / 1.5,
                    child: Center(
                      child: CircularProgressIndicator(
                        color: linearColor,
                      ),
                    ),
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            children: [
                              controller.simulations[0].category.isNotEmpty
                                  ? ARGridTile(
                                      onTap: () async {},
                                      tileColor: gridTileDatas[0]['tileColor'],
                                      title: controller.simulations[0].category,
                                      icon: gridTileDatas[0]['image'],
                                      ellipse: gridTileDatas[0]['ellipse'],
                                    )
                                  : const SizedBox.shrink(),
                              SizedBox(
                                height: getWidgetHeight(height: 20),
                              ),
                              controller.simulations[3].category.isNotEmpty
                                  ? ARGridTile(
                                      onTap: () async {},
                                      tileColor: gridTileDatas[3]['tileColor'],
                                      title: controller.simulations[3].category,
                                      icon: gridTileDatas[3]['image'],
                                      ellipse: gridTileDatas[3]['ellipse'],
                                    )
                                  : const SizedBox.shrink(),
                              SizedBox(
                                height: getWidgetHeight(height: 20),
                              ),
                              controller.simulations[4].category.isNotEmpty
                                  ? ARGridTile(
                                      onTap: () async {},
                                      height: getWidgetHeight(height: 180),
                                      tileColor: gridTileDatas[4]['tileColor'],
                                      title: controller.simulations[4].category,
                                      icon: gridTileDatas[4]['image'],
                                      ellipse: gridTileDatas[4]['ellipse'],
                                    )
                                  : const SizedBox.shrink(),
                            ],
                          ),
                          const Spacer(),
                          Column(
                            children: [
                              SizedBox(
                                height: getWidgetHeight(height: 40),
                              ),
                              controller.simulations[1].category.isNotEmpty
                                  ? ARGridTile(
                                      onTap: () async {},
                                      tileColor: gridTileDatas[1]['tileColor'],
                                      title: controller.simulations[1].category,
                                      icon: gridTileDatas[1]['image'],
                                      ellipse: gridTileDatas[1]['ellipse'],
                                    )
                                  : const SizedBox.shrink(),
                              SizedBox(
                                height: getWidgetHeight(height: 20),
                              ),
                              controller.simulations[2].category.isNotEmpty
                                  ? ARGridTile(
                                      onTap: () async {},
                                      tileColor: gridTileDatas[2]['tileColor'],
                                      title: controller.simulations[2].category,
                                      icon: gridTileDatas[2]['image'],
                                      ellipse: gridTileDatas[2]['ellipse'],
                                    )
                                  : const SizedBox.shrink(),
                            ],
                          ),
                        ],
                      ),
                    ],
                  );
          }),
        ),
      )),
    );
  }
}
