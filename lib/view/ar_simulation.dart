import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hotelmanagementapp/controller/bottom_navigation_controller.dart';
import 'package:hotelmanagementapp/controller/home_controller.dart';
import 'package:hotelmanagementapp/controller/simulation_controller.dart';
import 'package:hotelmanagementapp/public/all_asset.dart';
import 'package:hotelmanagementapp/public/common_function.dart';
import 'package:hotelmanagementapp/public/constant.dart';
import 'package:hotelmanagementapp/route/route_name.dart';
import 'package:hotelmanagementapp/utility/ar_grid_tile.dart';
import 'package:hotelmanagementapp/utility/custome_bottom_navigation.dart';
import 'package:hotelmanagementapp/utility/web_top_nav.dart';
import 'package:hotelmanagementapp/view/home.dart';

class ARCallSimulation extends StatelessWidget {
  ARCallSimulation({super.key});

  final HomeController homeController = Get.put(HomeController());
  final SimulationController simulationController =
      Get.put(SimulationController());

  final List<Map<String, dynamic>> gridTileDatas = [
    {
      'tileColor': Color(0xFF009991),
      'image': "assets/Front Office 2.png",
      'ellipse': AllAssets.argreenEllipse
    },
    {
      'tileColor': Color(0xFF009991),
      'image': AllAssets.restuarant,
      'ellipse': AllAssets.argreenEllipse
    },
    {
      'tileColor': Color(0xFF4040CA),
      'image': AllAssets.roomService,
      'ellipse': AllAssets.arblueEllipse
    },
    {
      'tileColor': Color(0xFF009991),
      'image': AllAssets.bar,
      'ellipse': AllAssets.argreenEllipse
    },
    {
      'tileColor': Color(0xFF009991),
      'image': AllAssets.banquet,
      'ellipse': AllAssets.argreenEllipse
    },
    {
      'tileColor': Color(0xFF8540C8),
      'image': "assets/Housekeeping 2.png",
      'ellipse': AllAssets.arpurpleEllipse
    },
    {
      'tileColor': Color(0xFFDC6379),
      'image': "assets/Chef 2.png",
      'ellipse': AllAssets.arpinkEllipse
    },
    {
      'tileColor': Color(0xFF009991),
      'image': "assets/Interview 2.png",
      'ellipse': AllAssets.argreenEllipse
    },
  ];

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvoked: (_) => homeController.loadRecentHistory(),
      child: Scaffold(
        backgroundColor: const Color(0xFFF7F7F7),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: kIsWeb ? null : const CustomeBottomNavigation(),

        // appBar: AppBar(
        //   backgroundColor: Colors.white,
        //   elevation: 0,
        //   centerTitle: true,
        //   leading: IconButton(
        //     icon: const Icon(Icons.arrow_back),
        //     onPressed: () {
        //       homeController.loadRecentHistory();
        //       kIsWeb
        //           ? Get.rootDelegate.offNamed(AppRoutes.home)
        //           : Navigator.pop(context);
        //     },
        //   ),
        //   title: Text(
        //     "Interactive Simulations",
        //     style: GoogleFonts.inter(
        //       fontSize: 16,
        //       fontWeight: FontWeight.w600,
        //       color: Colors.black,
        //     ),
        //   ),
        // ),

        body: SafeArea(
          child: GetBuilder<SimulationController>(
            builder: (controller) {
              if (controller.loading) {
                return const Center(child: CircularProgressIndicator());
              }

              return SingleChildScrollView(
                child: Column(
                  children: [
                    if (kIsWeb)
                      WebHeaderWithNav(
                        title: 'Interactive Simulations',
                      )
                    else
                      AppBar(
                        backgroundColor: Colors.white,
                        elevation: 0,
                        leading: IconButton(
                          icon: const Icon(Icons.arrow_back),
                          onPressed: () => Navigator.pop(context),
                        ),
                        title: Text(
                          "Interactive Simulations",
                          style: GoogleFonts.inter(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    // _subtitle(),
                    // const SizedBox(height: 14),
                    Padding(
                      padding: const EdgeInsets.all(40),
                      child: _grid(controller),
                    ),
                    const SizedBox(height: 120),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _subtitle() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
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
          Text(
            " Practice Fearlessly...",
            style: GoogleFonts.kaushanScript(
              fontSize: 22,
              color: linearColor,
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
                                        child: LayoutBuilder(
                                          builder: (context, constraints) {
                                            final double width = constraints.maxWidth;
                                            int crossAxisCount = 4;
                                            double childAspectRatio = 1.5;

                                            if (width > 1200) {
                                              crossAxisCount = 4;
                                              childAspectRatio = 1.2;
                                            } else if (width >= 900) {
                                              crossAxisCount = 4;
                                              childAspectRatio = 1.15;
                                            } else if (width >= 600) {
                                              crossAxisCount = 3;
                                              childAspectRatio = 1.1;
                                            } else {
                                              crossAxisCount = 2;
                                              childAspectRatio = 0.85;
                                            }

                                            return GridView.builder(
                                              shrinkWrap: true,
                                              gridDelegate:
                                                  SliverGridDelegateWithFixedCrossAxisCount(
                                                crossAxisCount: crossAxisCount,
                                                mainAxisSpacing: 20,
                                                crossAxisSpacing: 20,
                                                childAspectRatio: childAspectRatio,
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
        );
      },
    );
  }
}

class _HoverCard extends StatefulWidget {
  final Widget child;
  const _HoverCard({required this.child});

  @override
  State<_HoverCard> createState() => _HoverCardState();
}

class _HoverCardState extends State<_HoverCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    if (!kIsWeb) return widget.child;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOut,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: _hovered
              ? [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 24,
                    offset: const Offset(0, 10),
                  ),
                ]
              : [],
        ),
        child: widget.child,
      ),
    );
  }
}
