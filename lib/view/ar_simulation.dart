import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hotelmanagementapp/controller/simulation_controller.dart';
import 'package:hotelmanagementapp/public/all_asset.dart';
import 'package:hotelmanagementapp/public/common_function.dart';
import 'package:hotelmanagementapp/public/constant.dart';
import 'package:hotelmanagementapp/route/route_name.dart';
import 'package:hotelmanagementapp/utility/ar_grid_tile.dart';
import 'package:hotelmanagementapp/utility/custome_bottom_navigation.dart';
import 'package:hotelmanagementapp/view/simulation_sub.dart';

class ARCallSimulation extends StatelessWidget {
  ARCallSimulation({super.key});

  List<Map<String, dynamic>> gridTileDatas = [
    {
      'tileColor': Color(0xFF009991),
      'title': "Accommodation\nManagement - Front Office",
      'image': "assets/Front Office 2.png",
      'ellipse': AllAssets.argreenEllipse
    },
    {
      'tileColor': Color(0xFF4040CA),
      'title': "Food & Beverage Service\nManagement",
      'image': "assets/F&B 2.png",
      'ellipse': AllAssets.arblueEllipse
    },
    {
      'tileColor': Color(0xFFDC6379),
      'title': 'Food Production',
      'image': "assets/Chef 2.png",
      'ellipse': AllAssets.arpinkEllipse
    },
    {
      'tileColor': Color(0xFF8540C8),
      'title': 'Accommodation\nManagement - Housekeeping',
      'image': "assets/Housekeeping 2.png",
      'ellipse': AllAssets.arpurpleEllipse
    },
    {
      'tileColor': Color(0xFF009991),
      'title': "Mock Interviews",
      'image': "assets/Interview 2.png",
      'ellipse': AllAssets.argreenEllipse
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CustomeBottomNavigation(),
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
            // vertical: getWidgetWidth(width: 20),
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
                : Padding(
                    padding:
                        EdgeInsets.only(bottom: getWidgetHeight(height: 20)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      // crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: getWidgetHeight(height: 5),
                        ),
                        Container(
                          // height: displayHeight(context) * 0.2,
                          // height: getWidgetHeight(height: 160),
                          // width: displayWidth(context),
                          // color: Colors.amber,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Indulge in Lifelike Immersive Learning!',
                                style: TextStyle(
                                  fontFamily: 'Roboto',
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black,
                                  letterSpacing: 0,
                                  fontSize: kText.scale(16),
                                ),
                              ),
                              Text(
                                'Be Ready & Confident To Handle Challenging Situations!',
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black,
                                  fontSize: kText.scale(15),
                                  fontFamily: 'Roboto',
                                  letterSpacing: 0,
                                ),
                              ),
                              SizedBox(height: getWidgetHeight(height: 10)),
                              Text(
                                'Practice Fearlessly...',
                                style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    color: Color(0xFF808080),
                                    fontSize: kText.scale(31),
                                    fontFamily: 'Kaushan',
                                    letterSpacing: 0),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: getWidgetHeight(height: 15),
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              children: [
                                controller.simulations[0].category.isNotEmpty
                                    ? ARGridTile(
                                        onTap: () async {
                                          subCategoryTitle = controller
                                              .simulations[0].category;
                                          Get.toNamed(AppRoutes.simulationSub,
                                              arguments: {
                                                'title': controller
                                                    .simulations[0].category,
                                                'simulation':
                                                    controller.simulations[0]
                                              });
                                          // Navigator.push(
                                          //     context,
                                          //     MaterialPageRoute(
                                          //         builder: (context) =>
                                          //             SimulationSub(
                                          //                 title:
                                          //                     controller
                                          //                         .simulations[0]
                                          //                         .category,
                                          //                 simulation: controller
                                          //                     .simulations[0])));
                                        },
                                        tileColor: gridTileDatas[0]
                                            ['tileColor'],
                                        title:
                                            controller.simulations[0].category,
                                        icon: gridTileDatas[0]['image'],
                                        ellipse: gridTileDatas[0]['ellipse'],
                                      )
                                    : const SizedBox.shrink(),
                                SizedBox(
                                  height: getWidgetHeight(height: 20),
                                ),
                                controller.simulations[2].category.isNotEmpty
                                    ? ARGridTile(
                                        onTap: () async {
                                          subCategoryTitle = controller
                                              .simulations[2].category;
                                          Get.toNamed(AppRoutes.simulationSub,
                                              arguments: {
                                                'title': controller
                                                    .simulations[2].category,
                                                'simulation':
                                                    controller.simulations[2]
                                              });
                                        },
                                        tileColor: gridTileDatas[2]
                                            ['tileColor'],
                                        title:
                                            controller.simulations[2].category,
                                        icon: gridTileDatas[2]['image'],
                                        ellipse: gridTileDatas[2]['ellipse'],
                                      )
                                    : const SizedBox.shrink(),
                                SizedBox(
                                  height: getWidgetHeight(height: 20),
                                ),
                                controller.simulations[4].category.isNotEmpty
                                    ? ARGridTile(
                                        onTap: () async {
                                          subCategoryTitle = controller
                                              .simulations[4].category;
                                          Get.toNamed(AppRoutes.simulationSub,
                                              arguments: {
                                                'title': controller
                                                    .simulations[4].category,
                                                'simulation':
                                                    controller.simulations[4]
                                              });
                                        },
                                        // height: getWidgetHeight(height: 180),
                                        tileColor: gridTileDatas[4]
                                            ['tileColor'],
                                        title:
                                            controller.simulations[4].category,
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
                                        onTap: () async {
                                          subCategoryTitle = controller
                                              .simulations[1].category;
                                          Get.toNamed(AppRoutes.simulationSub,
                                              arguments: {
                                                'title': controller
                                                    .simulations[1].category,
                                                'simulation':
                                                    controller.simulations[1]
                                              });
                                        },
                                        tileColor: gridTileDatas[1]
                                            ['tileColor'],
                                        title:
                                            controller.simulations[1].category,
                                        icon: gridTileDatas[1]['image'],
                                        ellipse: gridTileDatas[1]['ellipse'],
                                      )
                                    : const SizedBox.shrink(),
                                SizedBox(
                                  height: getWidgetHeight(height: 20),
                                ),
                                controller.simulations[3].category.isNotEmpty
                                    ? ARGridTile(
                                        onTap: () async {
                                          subCategoryTitle = controller
                                              .simulations[3].category;
                                          Get.toNamed(AppRoutes.simulationSub,
                                              arguments: {
                                                'title': controller
                                                    .simulations[3].category,
                                                'simulation':
                                                    controller.simulations[3]
                                              });
                                        },
                                        tileColor: gridTileDatas[3]
                                            ['tileColor'],
                                        title:
                                            controller.simulations[3].category,
                                        icon: gridTileDatas[3]['image'],
                                        ellipse: gridTileDatas[3]['ellipse'],
                                      )
                                    : const SizedBox.shrink(),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
          }),
        ),
      )),
    );
  }
}
