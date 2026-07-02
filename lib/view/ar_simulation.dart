import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
        ],
      ),
    );
  }

  Widget _grid(SimulationController controller) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: controller.simulations.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: kIsWeb ? 4 : 2,
        crossAxisSpacing: 20,
        mainAxisSpacing: 20,
        childAspectRatio: 1.45,
      ),
      itemBuilder: (context, index) {
        final simulation = controller.simulations[index];
        final meta = gridTileDatas[index];

        return _HoverCard(
          child: ARGridTile(
            title: simulation.category,
            icon: meta['image'],
            tileColor: meta['tileColor'],
            ellipse: meta['ellipse'],
            isUnderConstruction: !controller.isLabActive(
              simulation.category.toLowerCase().replaceAll(' ', '_'),
            ),
            onTap: () {
              final key =
                  simulation.category.toLowerCase().replaceAll(' ', '_');

              if (!controller.isLabActive(key)) {
                controller.showReviewPopup(context);
                return;
              }

              WidgetsBinding.instance.addPostFrameCallback((_) {
                GetStorage().write(
                  AppRoutes.simulationSub,
                  {
                    'title': simulation.category,
                    'simulation': simulation.toJson(),
                  },
                );

                kIsWeb
                    ? Get.rootDelegate.offNamed(
                        AppRoutes.simulationSub,
                        arguments: {
                          'title': simulation.category,
                          'simulation': simulation,
                        },
                      )
                    : Get.toNamed(
                        AppRoutes.simulationSub,
                        arguments: {
                          'title': simulation.category,
                          'simulation': simulation,
                        },
                      );
              });
            },
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
