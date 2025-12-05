import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hotelmanagementapp/controller/home_controller.dart';
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
  HomeController homeController = Get.put(HomeController());
  List<Map<String, dynamic>> gridTileDatas = [
    {
      'tileColor': Color(0xFF009991),
      'title': "Accommodation\nManagement - Front Office",
      'image': "assets/Front Office 2.png",
      'ellipse': AllAssets.argreenEllipse
    },
    {
      'tileColor': Color(0xFF009991),
      'title': "Restaurant Management",
      'image': AllAssets.restuarant,
      'ellipse': AllAssets.argreenEllipse
    },
    {
      'tileColor': Color(0xFF4040CA),
      'title': "Room Service",
      'image': AllAssets.roomService,
      'ellipse': AllAssets.arblueEllipse
    },
    {
      'tileColor': Color(0xFF009991),
      'title': "Bar service",
      'image': AllAssets.bar,
      'ellipse': AllAssets.argreenEllipse
    },
    {
      'tileColor': Color(0xFF009991),
      'title': "Banquet Scenarios",
      'image': AllAssets.banquet,
      'ellipse': AllAssets.argreenEllipse
    },
    {
      'tileColor': Color(0xFF8540C8),
      'title': 'Accommodation\nManagement - Housekeeping',
      'image': "assets/Housekeeping 2.png",
      'ellipse': AllAssets.arpurpleEllipse
    },
    {
      'tileColor': Color(0xFFDC6379),
      'title': 'Food Production',
      'image': "assets/Chef 2.png",
      'ellipse': AllAssets.arpinkEllipse
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
    return PopScope(
      onPopInvoked: (didPop) {
        homeController.loadRecentHistory();
      },
      child: Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: Align(
          alignment: Alignment.bottomCenter,
          child: CustomeBottomNavigation(),
        ),
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
          ),
          leading: Padding(
            padding: EdgeInsets.symmetric(vertical: getWidgetHeight(height: 8)),
            child: IconButton(
              iconSize: 30,
              onPressed: () {
                homeController.loadRecentHistory();
                kIsWeb
                    ? Get.rootDelegate.offNamed(AppRoutes.home)
                    : Navigator.pop(context);
              },
              icon: const Icon(Icons.arrow_back),
            ),
          ),
        ),
        body: SafeArea(
            child: Padding(
          padding: EdgeInsets.symmetric(
              // vertical: getWidgetWidth(width: 20),
              // horizontal: getWidgetHeight(height: 20)
              ),
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
                        // mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: getWidgetHeight(height: 5),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: getWidgetHeight(height: 20)),
                            child: kIsWeb
                                ? SizedBox.shrink()
                                // ? SizedBox(
                                //     height: getWidgetHeight(height: 52),
                                //     child: Row(
                                //       mainAxisAlignment:
                                //           MainAxisAlignment.center,
                                //       crossAxisAlignment:
                                //           CrossAxisAlignment.start,
                                //       children: [
                                //         SizedBox(
                                //           height: getWidgetHeight(height: 52),
                                //           child: Row(
                                //             children: [
                                //               Text(
                                //                 'Indulge in Lifelike Immersive Learning!',
                                //                 style: TextStyle(
                                //                   fontFamily: 'Roboto',
                                //                   fontWeight: FontWeight.w500,
                                //                   color: Colors.black,
                                //                   letterSpacing: 0,
                                //                   fontSize: kText.scale(16),
                                //                 ),
                                //               ),
                                //               Text(
                                //                 'Be Ready & Confident To Handle Challenging Situations!',
                                //                 style: TextStyle(
                                //                   fontWeight: FontWeight.w500,
                                //                   color: Colors.black,
                                //                   fontSize: kText.scale(15),
                                //                   fontFamily: 'Roboto',
                                //                   letterSpacing: 0,
                                //                 ),
                                //               ),
                                //             ],
                                //           ),
                                //         ),
                                //         // SizedBox(
                                //         //     height: getWidgetHeight(height: 10)),
                                //         Text(
                                //           'Practice Fearlessly...',
                                //           style: TextStyle(
                                //               fontWeight: FontWeight.w400,
                                //               color: Color(0xFF808080),
                                //               fontSize: kText.scale(31),
                                //               fontFamily: 'Kaushan',
                                //               letterSpacing: 0),
                                //         ),
                                //       ],
                                //     ),
                                //   )
                                : Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                      SizedBox(
                                          height: getWidgetHeight(height: 10)),
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
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: getWidgetHeight(height: 20)),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                if (kIsWeb)
                                  SizedBox(
                                    height: getWidgetHeight(height: 10),
                                  ),
                                kIsWeb
                                    ? Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal:
                                                getWidgetWidth(width: 20)),
                                        child: GridView.builder(
                                          shrinkWrap: true,
                                          gridDelegate:
                                              const SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: 4,
                                            mainAxisSpacing: 20,
                                            crossAxisSpacing: 20,
                                            childAspectRatio: 1.5,
                                          ),
                                          itemCount: controller.simulations
                                              .length, // change as needed
                                          itemBuilder: (context, index) {
                                            return ARGridTile(
                                              onTap: () async {
                                                subCategoryTitle = controller
                                                    .simulations[index]
                                                    .category;
                                                if (!controller.isLabActive(
                                                    subCategoryTitle
                                                        .toLowerCase()
                                                        .replaceAll(
                                                            ' ', '_'))) {
                                                  controller
                                                      .showReviewPopup(context);
                                                  return;
                                                }
                                                // GetStorage().write(
                                                //     AppRoutes.simulationSub, {
                                                //   'title': controller
                                                //       .simulations[0]
                                                //       .category,
                                                //   'simulation': controller
                                                //       .simulations[0]
                                                // });
                                                WidgetsBinding.instance
                                                    .addPostFrameCallback((_) {
                                                  final data = {
                                                    'title': controller
                                                        .simulations[index]
                                                        .category,
                                                    'simulation': controller
                                                        .simulations[index]
                                                  };
                                                  GetStorage().write(
                                                      AppRoutes.simulationSub, {
                                                    'title': data['title'],
                                                    'simulation': controller
                                                        .simulations[index]
                                                        .toJson(), // ✅ ensure JSON safe
                                                  });
                                                  kIsWeb
                                                      ? Get.rootDelegate
                                                          .offNamed(
                                                              AppRoutes
                                                                  .simulationSub,
                                                              arguments: {
                                                              'title': controller
                                                                  .simulations[
                                                                      index]
                                                                  .category,
                                                              'simulation':
                                                                  controller
                                                                          .simulations[
                                                                      index]
                                                            })
                                                      : Get.toNamed(
                                                          AppRoutes
                                                              .simulationSub,
                                                          arguments: {
                                                              'title': controller
                                                                  .simulations[
                                                                      index]
                                                                  .category,
                                                              'simulation':
                                                                  controller
                                                                          .simulations[
                                                                      index]
                                                            });
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
                                              isUnderConstruction: !controller
                                                  .isLabActive(controller
                                                      .simulations[index]
                                                      .category
                                                      .toLowerCase()
                                                      .replaceAll(' ', '_')),
                                              tileColor: gridTileDatas[index]
                                                  ['tileColor'],
                                              title: controller
                                                  .simulations[index].category,
                                              icon: gridTileDatas[index]
                                                  ['image'],
                                              ellipse: gridTileDatas[index]
                                                  ['ellipse'],
                                            );
                                          },
                                        ),
                                      )
                                    : Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Column(
                                            children: [
                                              controller.simulations[0].category
                                                      .isNotEmpty
                                                  ? ARGridTile(
                                                      onTap: () async {
                                                        subCategoryTitle =
                                                            controller
                                                                .simulations[0]
                                                                .category;
                                                        if (!controller
                                                            .isLabActive(
                                                                subCategoryTitle
                                                                    .toLowerCase()
                                                                    .replaceAll(
                                                                        ' ',
                                                                        '_'))) {
                                                          controller
                                                              .showReviewPopup(
                                                                  context);
                                                          return;
                                                        }
                                                        // GetStorage().write(
                                                        //     AppRoutes.simulationSub, {
                                                        //   'title': controller
                                                        //       .simulations[0]
                                                        //       .category,
                                                        //   'simulation': controller
                                                        //       .simulations[0]
                                                        // });
                                                        WidgetsBinding.instance
                                                            .addPostFrameCallback(
                                                                (_) {
                                                          final data = {
                                                            'title': controller
                                                                .simulations[0]
                                                                .category,
                                                            'simulation':
                                                                controller
                                                                    .simulations[0]
                                                          };
                                                          GetStorage().write(
                                                              AppRoutes
                                                                  .simulationSub,
                                                              {
                                                                'title': data[
                                                                    'title'],
                                                                'simulation': controller
                                                                    .simulations[
                                                                        0]
                                                                    .toJson(), // ✅ ensure JSON safe
                                                              });
                                                          kIsWeb
                                                              ? Get.rootDelegate
                                                                  .offNamed(
                                                                      AppRoutes
                                                                          .simulationSub,
                                                                      arguments: {
                                                                      'title': controller
                                                                          .simulations[
                                                                              0]
                                                                          .category,
                                                                      'simulation':
                                                                          controller
                                                                              .simulations[0]
                                                                    })
                                                              : Get.toNamed(
                                                                  AppRoutes
                                                                      .simulationSub,
                                                                  arguments: {
                                                                      'title': controller
                                                                          .simulations[
                                                                              0]
                                                                          .category,
                                                                      'simulation':
                                                                          controller
                                                                              .simulations[0]
                                                                    });
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
                                                      isUnderConstruction:
                                                          !controller
                                                              .isLabActive(controller
                                                                  .simulations[
                                                                      0]
                                                                  .category
                                                                  .toLowerCase()
                                                                  .replaceAll(
                                                                      ' ',
                                                                      '_')),
                                                      tileColor:
                                                          gridTileDatas[0]
                                                              ['tileColor'],
                                                      title: controller
                                                          .simulations[0]
                                                          .category,
                                                      icon: gridTileDatas[0]
                                                          ['image'],
                                                      ellipse: gridTileDatas[0]
                                                          ['ellipse'],
                                                    )
                                                  : const SizedBox.shrink(),
                                              SizedBox(
                                                height:
                                                    getWidgetHeight(height: 20),
                                              ),
                                              controller.simulations[2].category
                                                      .isNotEmpty
                                                  ? ARGridTile(
                                                      onTap: () async {
                                                        subCategoryTitle =
                                                            controller
                                                                .simulations[2]
                                                                .category;
                                                        if (!controller
                                                            .isLabActive(
                                                                subCategoryTitle
                                                                    .toLowerCase()
                                                                    .replaceAll(
                                                                        ' ',
                                                                        '_'))) {
                                                          controller
                                                              .showReviewPopup(
                                                                  context);
                                                          return;
                                                        }
                                                        // GetStorage().write(
                                                        //     AppRoutes.simulationSub, {
                                                        //   'title': controller
                                                        //       .simulations[2]
                                                        //       .category,
                                                        //   'simulation': controller
                                                        //       .simulations[2]
                                                        // });
                                                        WidgetsBinding.instance
                                                            .addPostFrameCallback(
                                                                (_) {
                                                          final data = {
                                                            'title': controller
                                                                .simulations[2]
                                                                .category,
                                                            'simulation':
                                                                controller
                                                                    .simulations[2]
                                                          };
                                                          GetStorage().write(
                                                              AppRoutes
                                                                  .simulationSub,
                                                              {
                                                                'title': data[
                                                                    'title'],
                                                                'simulation': controller
                                                                    .simulations[
                                                                        2]
                                                                    .toJson(), // ✅ ensure JSON safe
                                                              });
                                                          kIsWeb
                                                              ? Get.rootDelegate
                                                                  .offNamed(
                                                                      AppRoutes
                                                                          .simulationSub,
                                                                      arguments: {
                                                                      'title': controller
                                                                          .simulations[
                                                                              2]
                                                                          .category,
                                                                      'simulation':
                                                                          controller
                                                                              .simulations[2]
                                                                    })
                                                              : Get.toNamed(
                                                                  AppRoutes
                                                                      .simulationSub,
                                                                  arguments: {
                                                                      'title': controller
                                                                          .simulations[
                                                                              2]
                                                                          .category,
                                                                      'simulation':
                                                                          controller
                                                                              .simulations[2]
                                                                    });
                                                        });
                                                      },
                                                      isUnderConstruction:
                                                          !controller
                                                              .isLabActive(controller
                                                                  .simulations[
                                                                      2]
                                                                  .category
                                                                  .toLowerCase()
                                                                  .replaceAll(
                                                                      ' ',
                                                                      '_')),
                                                      tileColor:
                                                          gridTileDatas[2]
                                                              ['tileColor'],
                                                      title: controller
                                                          .simulations[2]
                                                          .category,
                                                      icon: gridTileDatas[2]
                                                          ['image'],
                                                      ellipse: gridTileDatas[2]
                                                          ['ellipse'],
                                                    )
                                                  : const SizedBox.shrink(),
                                              SizedBox(
                                                height:
                                                    getWidgetHeight(height: 20),
                                              ),
                                              controller.simulations[4].category
                                                      .isNotEmpty
                                                  ? ARGridTile(
                                                      onTap: () async {
                                                        subCategoryTitle =
                                                            controller
                                                                .simulations[4]
                                                                .category;
                                                        if (!controller
                                                            .isLabActive(
                                                                subCategoryTitle
                                                                    .toLowerCase()
                                                                    .replaceAll(
                                                                        ' ',
                                                                        '_'))) {
                                                          controller
                                                              .showReviewPopup(
                                                                  context);
                                                          return;
                                                        }
                                                        // GetStorage().write(
                                                        //     AppRoutes.simulationSub, {
                                                        //   'title': controller
                                                        //       .simulations[4]
                                                        //       .category,
                                                        //   'simulation': controller
                                                        //       .simulations[4]
                                                        // });
                                                        WidgetsBinding.instance
                                                            .addPostFrameCallback(
                                                                (_) {
                                                          final data = {
                                                            'title': controller
                                                                .simulations[4]
                                                                .category,
                                                            'simulation':
                                                                controller
                                                                    .simulations[4]
                                                          };
                                                          GetStorage().write(
                                                              AppRoutes
                                                                  .simulationSub,
                                                              {
                                                                'title': data[
                                                                    'title'],
                                                                'simulation': controller
                                                                    .simulations[
                                                                        4]
                                                                    .toJson(), // ✅ ensure JSON safe
                                                              });
                                                          kIsWeb
                                                              ? Get.rootDelegate
                                                                  .offNamed(
                                                                      AppRoutes
                                                                          .simulationSub,
                                                                      arguments: {
                                                                      'title': controller
                                                                          .simulations[
                                                                              4]
                                                                          .category,
                                                                      'simulation':
                                                                          controller
                                                                              .simulations[4]
                                                                    })
                                                              : Get.toNamed(
                                                                  AppRoutes
                                                                      .simulationSub,
                                                                  arguments: {
                                                                      'title': controller
                                                                          .simulations[
                                                                              4]
                                                                          .category,
                                                                      'simulation':
                                                                          controller
                                                                              .simulations[4]
                                                                    });
                                                        });
                                                      },
                                                      // height: getWidgetHeight(height: 180),
                                                      isUnderConstruction:
                                                          !controller
                                                              .isLabActive(controller
                                                                  .simulations[
                                                                      4]
                                                                  .category
                                                                  .toLowerCase()
                                                                  .replaceAll(
                                                                      ' ',
                                                                      '_')),
                                                      tileColor:
                                                          gridTileDatas[4]
                                                              ['tileColor'],
                                                      title: controller
                                                          .simulations[4]
                                                          .category,
                                                      icon: gridTileDatas[4]
                                                          ['image'],
                                                      ellipse: gridTileDatas[4]
                                                          ['ellipse'],
                                                    )
                                                  : const SizedBox.shrink(),
                                              SizedBox(
                                                height:
                                                    getWidgetHeight(height: 20),
                                              ),
                                              controller.simulations[6].category
                                                      .isNotEmpty
                                                  ? ARGridTile(
                                                      onTap: () async {
                                                        subCategoryTitle =
                                                            controller
                                                                .simulations[6]
                                                                .category;
                                                        if (!controller
                                                            .isLabActive(
                                                                subCategoryTitle
                                                                    .toLowerCase()
                                                                    .replaceAll(
                                                                        ' ',
                                                                        '_'))) {
                                                          controller
                                                              .showReviewPopup(
                                                                  context);
                                                          return;
                                                        }
                                                        // GetStorage().write(
                                                        //     AppRoutes.simulationSub, {
                                                        //   'title': controller
                                                        //       .simulations[6]
                                                        //       .category,
                                                        //   'simulation': controller
                                                        //       .simulations[6]
                                                        // });
                                                        WidgetsBinding.instance
                                                            .addPostFrameCallback(
                                                                (_) {
                                                          final data = {
                                                            'title': controller
                                                                .simulations[6]
                                                                .category,
                                                            'simulation':
                                                                controller
                                                                    .simulations[6]
                                                          };
                                                          GetStorage().write(
                                                              AppRoutes
                                                                  .simulationSub,
                                                              {
                                                                'title': data[
                                                                    'title'],
                                                                'simulation': controller
                                                                    .simulations[
                                                                        6]
                                                                    .toJson(), // ✅ ensure JSON safe
                                                              });
                                                          kIsWeb
                                                              ? Get.rootDelegate
                                                                  .offNamed(
                                                                      AppRoutes
                                                                          .simulationSub,
                                                                      arguments: {
                                                                      'title': controller
                                                                          .simulations[
                                                                              6]
                                                                          .category,
                                                                      'simulation':
                                                                          controller
                                                                              .simulations[6]
                                                                    })
                                                              : Get.toNamed(
                                                                  AppRoutes
                                                                      .simulationSub,
                                                                  arguments: {
                                                                      'title': controller
                                                                          .simulations[
                                                                              6]
                                                                          .category,
                                                                      'simulation':
                                                                          controller
                                                                              .simulations[6]
                                                                    });
                                                        });
                                                      },
                                                      // height: getWidgetHeight(height: 180),
                                                      isUnderConstruction:
                                                          !controller
                                                              .isLabActive(controller
                                                                  .simulations[
                                                                      6]
                                                                  .category
                                                                  .toLowerCase()
                                                                  .replaceAll(
                                                                      ' ',
                                                                      '_')),
                                                      tileColor:
                                                          gridTileDatas[6]
                                                              ['tileColor'],
                                                      title: controller
                                                          .simulations[6]
                                                          .category,
                                                      icon: gridTileDatas[6]
                                                          ['image'],
                                                      ellipse: gridTileDatas[6]
                                                          ['ellipse'],
                                                    )
                                                  : const SizedBox.shrink(),
                                            ],
                                          ),
                                          // const Spacer(),
                                          SizedBox(
                                            width: getWidgetWidth(width: 13.9),
                                          ),
                                          Column(
                                            children: [
                                              SizedBox(
                                                height:
                                                    getWidgetHeight(height: 40),
                                              ),
                                              controller.simulations[1].category
                                                      .isNotEmpty
                                                  ? ARGridTile(
                                                      onTap: () async {
                                                        subCategoryTitle =
                                                            controller
                                                                .simulations[1]
                                                                .category;
                                                        if (!controller
                                                            .isLabActive(
                                                                subCategoryTitle
                                                                    .toLowerCase()
                                                                    .replaceAll(
                                                                        ' ',
                                                                        '_'))) {
                                                          controller
                                                              .showReviewPopup(
                                                                  context);
                                                          return;
                                                        }
                                                        // GetStorage().write(
                                                        //     AppRoutes.simulationSub, {
                                                        //   'title': controller
                                                        //       .simulations[1]
                                                        //       .category,
                                                        //   'simulation': controller
                                                        //       .simulations[1]
                                                        // });
                                                        WidgetsBinding.instance
                                                            .addPostFrameCallback(
                                                                (_) {
                                                          final data = {
                                                            'title': controller
                                                                .simulations[1]
                                                                .category,
                                                            'simulation':
                                                                controller
                                                                    .simulations[1]
                                                          };
                                                          GetStorage().write(
                                                              AppRoutes
                                                                  .simulationSub,
                                                              {
                                                                'title': data[
                                                                    'title'],
                                                                'simulation': controller
                                                                    .simulations[
                                                                        1]
                                                                    .toJson(), // ✅ ensure JSON safe
                                                              });
                                                          kIsWeb
                                                              ? Get.rootDelegate
                                                                  .offNamed(
                                                                      AppRoutes
                                                                          .simulationSub,
                                                                      arguments: {
                                                                      'title': controller
                                                                          .simulations[
                                                                              1]
                                                                          .category,
                                                                      'simulation':
                                                                          controller
                                                                              .simulations[1]
                                                                    })
                                                              : Get.toNamed(
                                                                  AppRoutes
                                                                      .simulationSub,
                                                                  arguments: {
                                                                      'title': controller
                                                                          .simulations[
                                                                              1]
                                                                          .category,
                                                                      'simulation':
                                                                          controller
                                                                              .simulations[1]
                                                                    });
                                                        });
                                                      },
                                                      isUnderConstruction:
                                                          !controller
                                                              .isLabActive(controller
                                                                  .simulations[
                                                                      1]
                                                                  .category
                                                                  .toLowerCase()
                                                                  .replaceAll(
                                                                      ' ',
                                                                      '_')),
                                                      tileColor:
                                                          gridTileDatas[1]
                                                              ['tileColor'],
                                                      title: controller
                                                          .simulations[1]
                                                          .category,
                                                      icon: gridTileDatas[1]
                                                          ['image'],
                                                      ellipse: gridTileDatas[1]
                                                          ['ellipse'],
                                                    )
                                                  : const SizedBox.shrink(),
                                              SizedBox(
                                                height:
                                                    getWidgetHeight(height: 20),
                                              ),
                                              controller.simulations[3].category
                                                      .isNotEmpty
                                                  ? ARGridTile(
                                                      onTap: () async {
                                                        subCategoryTitle =
                                                            controller
                                                                .simulations[3]
                                                                .category;
                                                        if (!controller
                                                            .isLabActive(
                                                                subCategoryTitle
                                                                    .toLowerCase()
                                                                    .replaceAll(
                                                                        ' ',
                                                                        '_'))) {
                                                          controller
                                                              .showReviewPopup(
                                                                  context);
                                                          return;
                                                        }
                                                        // GetStorage().write(
                                                        //     AppRoutes.simulationSub, {
                                                        //   'title': controller
                                                        //       .simulations[3]
                                                        //       .category,
                                                        //   'simulation': controller
                                                        //       .simulations[3]
                                                        // });
                                                        WidgetsBinding.instance
                                                            .addPostFrameCallback(
                                                                (_) {
                                                          final data = {
                                                            'title': controller
                                                                .simulations[3]
                                                                .category,
                                                            'simulation':
                                                                controller
                                                                    .simulations[3]
                                                          };
                                                          GetStorage().write(
                                                              AppRoutes
                                                                  .simulationSub,
                                                              {
                                                                'title': data[
                                                                    'title'],
                                                                'simulation': controller
                                                                    .simulations[
                                                                        3]
                                                                    .toJson(), // ✅ ensure JSON safe
                                                              });
                                                          kIsWeb
                                                              ? Get.rootDelegate
                                                                  .offNamed(
                                                                      AppRoutes
                                                                          .simulationSub,
                                                                      arguments: {
                                                                      'title': controller
                                                                          .simulations[
                                                                              3]
                                                                          .category,
                                                                      'simulation':
                                                                          controller
                                                                              .simulations[3]
                                                                    })
                                                              : Get.toNamed(
                                                                  AppRoutes
                                                                      .simulationSub,
                                                                  arguments: {
                                                                      'title': controller
                                                                          .simulations[
                                                                              3]
                                                                          .category,
                                                                      'simulation':
                                                                          controller
                                                                              .simulations[3]
                                                                    });
                                                        });
                                                      },
                                                      isUnderConstruction:
                                                          !controller
                                                              .isLabActive(controller
                                                                  .simulations[
                                                                      3]
                                                                  .category
                                                                  .toLowerCase()
                                                                  .replaceAll(
                                                                      ' ',
                                                                      '_')),
                                                      tileColor:
                                                          gridTileDatas[3]
                                                              ['tileColor'],
                                                      title: controller
                                                          .simulations[3]
                                                          .category,
                                                      icon: gridTileDatas[3]
                                                          ['image'],
                                                      ellipse: gridTileDatas[3]
                                                          ['ellipse'],
                                                    )
                                                  : const SizedBox.shrink(),
                                              SizedBox(
                                                height:
                                                    getWidgetHeight(height: 20),
                                              ),
                                              controller.simulations[5].category
                                                      .isNotEmpty
                                                  ? ARGridTile(
                                                      onTap: () async {
                                                        subCategoryTitle =
                                                            controller
                                                                .simulations[5]
                                                                .category;
                                                        if (!controller
                                                            .isLabActive(
                                                                subCategoryTitle
                                                                    .toLowerCase()
                                                                    .replaceAll(
                                                                        ' ',
                                                                        '_'))) {
                                                          controller
                                                              .showReviewPopup(
                                                                  context);
                                                          return;
                                                        }
                                                        // GetStorage().write(
                                                        //     AppRoutes.simulationSub, {
                                                        //   'title': controller
                                                        //       .simulations[5]
                                                        //       .category,
                                                        //   'simulation': controller
                                                        //       .simulations[5]
                                                        // });
                                                        WidgetsBinding.instance
                                                            .addPostFrameCallback(
                                                                (_) {
                                                          final data = {
                                                            'title': controller
                                                                .simulations[5]
                                                                .category,
                                                            'simulation':
                                                                controller
                                                                    .simulations[5]
                                                          };
                                                          GetStorage().write(
                                                              AppRoutes
                                                                  .simulationSub,
                                                              {
                                                                'title': data[
                                                                    'title'],
                                                                'simulation': controller
                                                                    .simulations[
                                                                        5]
                                                                    .toJson(), // ✅ ensure JSON safe
                                                              });
                                                          kIsWeb
                                                              ? Get.rootDelegate
                                                                  .offNamed(
                                                                      AppRoutes
                                                                          .simulationSub,
                                                                      arguments: {
                                                                      'title': controller
                                                                          .simulations[
                                                                              5]
                                                                          .category,
                                                                      'simulation':
                                                                          controller
                                                                              .simulations[5]
                                                                    })
                                                              : Get.toNamed(
                                                                  AppRoutes
                                                                      .simulationSub,
                                                                  arguments: {
                                                                      'title': controller
                                                                          .simulations[
                                                                              5]
                                                                          .category,
                                                                      'simulation':
                                                                          controller
                                                                              .simulations[5]
                                                                    });
                                                        });
                                                      },
                                                      isUnderConstruction:
                                                          !controller
                                                              .isLabActive(controller
                                                                  .simulations[
                                                                      5]
                                                                  .category
                                                                  .toLowerCase()
                                                                  .replaceAll(
                                                                      ' ',
                                                                      '_')),
                                                      tileColor:
                                                          gridTileDatas[5]
                                                              ['tileColor'],
                                                      title: controller
                                                          .simulations[5]
                                                          .category,
                                                      icon: gridTileDatas[5]
                                                          ['image'],
                                                      ellipse: gridTileDatas[5]
                                                          ['ellipse'],
                                                    )
                                                  : const SizedBox.shrink(),
                                              SizedBox(
                                                height:
                                                    getWidgetHeight(height: 20),
                                              ),
                                              controller.simulations[7].category
                                                      .isNotEmpty
                                                  ? ARGridTile(
                                                      onTap: () async {
                                                        subCategoryTitle =
                                                            controller
                                                                .simulations[7]
                                                                .category;
                                                        if (!controller
                                                            .isLabActive(
                                                                subCategoryTitle
                                                                    .toLowerCase()
                                                                    .replaceAll(
                                                                        ' ',
                                                                        '_'))) {
                                                          controller
                                                              .showReviewPopup(
                                                                  context);
                                                          return;
                                                        }
                                                        // GetStorage().write(
                                                        //     AppRoutes.simulationSub, {
                                                        //   'title': controller
                                                        //       .simulations[5]
                                                        //       .category,
                                                        //   'simulation': controller
                                                        //       .simulations[5]
                                                        // });
                                                        WidgetsBinding.instance
                                                            .addPostFrameCallback(
                                                                (_) {
                                                          final data = {
                                                            'title': controller
                                                                .simulations[7]
                                                                .category,
                                                            'simulation':
                                                                controller
                                                                    .simulations[7]
                                                          };
                                                          GetStorage().write(
                                                              AppRoutes
                                                                  .simulationSub,
                                                              {
                                                                'title': data[
                                                                    'title'],
                                                                'simulation': controller
                                                                    .simulations[
                                                                        7]
                                                                    .toJson(), // ✅ ensure JSON safe
                                                              });
                                                          kIsWeb
                                                              ? Get.rootDelegate
                                                                  .offNamed(
                                                                      AppRoutes
                                                                          .simulationSub,
                                                                      arguments: {
                                                                      'title': controller
                                                                          .simulations[
                                                                              7]
                                                                          .category,
                                                                      'simulation':
                                                                          controller
                                                                              .simulations[7]
                                                                    })
                                                              : Get.toNamed(
                                                                  AppRoutes
                                                                      .simulationSub,
                                                                  arguments: {
                                                                      'title': controller
                                                                          .simulations[
                                                                              7]
                                                                          .category,
                                                                      'simulation':
                                                                          controller
                                                                              .simulations[7]
                                                                    });
                                                        });
                                                      },
                                                      isUnderConstruction:
                                                          !controller
                                                              .isLabActive(controller
                                                                  .simulations[
                                                                      7]
                                                                  .category
                                                                  .toLowerCase()
                                                                  .replaceAll(
                                                                      ' ',
                                                                      '_')),
                                                      tileColor:
                                                          gridTileDatas[7]
                                                              ['tileColor'],
                                                      title: controller
                                                          .simulations[7]
                                                          .category,
                                                      icon: gridTileDatas[7]
                                                          ['image'],
                                                      ellipse: gridTileDatas[7]
                                                          ['ellipse'],
                                                    )
                                                  : const SizedBox.shrink(),
                                            ],
                                          ),
                                        ],
                                      ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: getWidgetHeight(height: 90),
                          ),
                        ],
                      ),
                    );
            }),
          ),
        )),
      ),
    );
  }
}
