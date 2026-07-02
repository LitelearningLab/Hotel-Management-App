import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:hotelmanagementapp/controller/home_controller.dart';
import 'package:hotelmanagementapp/controller/simulation_sub_controller.dart';
import 'package:hotelmanagementapp/public/common_function.dart';
import 'package:hotelmanagementapp/route/route_name.dart';
import 'package:hotelmanagementapp/utility/custome_bottom_navigation.dart';
import 'package:hotelmanagementapp/utility/web_top_nav.dart';
import 'package:hotelmanagementapp/utility/web_view_page.dart';

class SimulationSub extends StatefulWidget {
  final SimulationSubController controller =
      Get.put(SimulationSubController());

  SimulationSub({super.key});

  @override
  State<SimulationSub> createState() => _SimulationSubState();
}

class _SimulationSubState extends State<SimulationSub> {
  late final HomeController homeController;

  @override
  void initState() {
    super.initState();
    homeController = Get.isRegistered<HomeController>()
        ? Get.find<HomeController>()
        : Get.put(HomeController(), permanent: true);
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    /// Responsive horizontal padding
    final horizontalPadding = screenWidth > 1400
        ? 120.0
        : screenWidth > 1000
            ? 64.0
            : 24.0;

    return PopScope(
      onPopInvoked: (_) {
        sessionName = "";
        homeController.loadRecentHistory();
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFF9FAFB),

        // ---------------- WEB HEADER ----------------
        appBar: kIsWeb
            ? PreferredSize(
                preferredSize: const Size.fromHeight(72),
                child: WebHeaderWithNav(title: "Front Office Scenarios",onBack: (){
                    sessionName = "";
                    Get.rootDelegate.offNamed(AppRoutes.simulation);
                },),
              )
            : AppBar(
                backgroundColor: Colors.white,
                elevation: 0,
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.black),
                  onPressed: () {
                    sessionName = "";
                    kIsWeb
                        ? Get.rootDelegate.offNamed(AppRoutes.simulation)
                        : Get.back();
                  },
                ),
                title: GetBuilder<SimulationSubController>(
                  builder: (controller) => Text(
                    controller.title,
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.w600,
                      fontSize: 20,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),

        floatingActionButtonLocation:
            FloatingActionButtonLocation.centerDocked,
        floatingActionButton:
            kIsWeb ? null : const CustomeBottomNavigation(),

        // ---------------- BODY ----------------
        body: SafeArea(
          child: GetBuilder<SimulationSubController>(
            builder: (controller) {
              return ListView.builder(
                padding: EdgeInsets.fromLTRB(
                  horizontalPadding,
                  32,
                  horizontalPadding,
                  40,
                ),
                itemCount: controller.simulation.subcategory.length,
                itemBuilder: (context, index) {
                  final item =
                      controller.simulation.subcategory[index];

                  return _ScenarioCard(
                    index: index + 1,
                    title: item.title,
                    onTap: () {
                      subCategoryTitle = item.title;
                      activityName = 'Interactive Simulation';

                      addToRecentHistory(
                        path:
                            "Interactive Simulation > $subCategoryTitle",
                        category: item.title,
                        section: activityName,
                        link: item.links[0],
                        proLabTitle: "",
                      );

                      if (kIsWeb) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => WebContentPage(
                              title: item.title,
                              url: item.links[0],
                            ),
                          ),
                        );
                      } else {
                        Get.toNamed(
                          AppRoutes.inAppWebView,
                          arguments: {
                            "isSimulation": true,
                            "url": item.links[0],
                          },
                        );
                      }
                    },
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}

/* ============================================================
   SCENARIO CARD – WIDE / MODERN
============================================================ */

class _ScenarioCard extends StatefulWidget {
  final int index;
  final String title;
  final VoidCallback onTap;

  const _ScenarioCard({
    required this.index,
    required this.title,
    required this.onTap,
  });

  @override
  State<_ScenarioCard> createState() => _ScenarioCardState();
}

class _ScenarioCardState extends State<_ScenarioCard> {
  bool hover = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => hover = true),
      onExit: (_) => setState(() => hover = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          margin: const EdgeInsets.only(bottom: 16),
          padding:
              const EdgeInsets.symmetric(horizontal: 22, vertical: 18),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFE5E7EB)),
            boxShadow: hover
                ? [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 22,
                      offset: const Offset(0, 10),
                    ),
                  ]
                : [],
          ),
          child: Row(
            children: [
              // LEFT INDEX / ACCENT
              Container(
                width: 40,
                height: 40,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  widget.index.toString(),
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.w600,
                    color: Colors.black54,
                  ),
                ),
              ),

              const SizedBox(width: 16),

              // TITLE
              Expanded(
                child: Text(
                  widget.title,
                  style: GoogleFonts.inter(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
              ),

              const Icon(
                Icons.chevron_right,
                size: 22,
                color: Colors.black45,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
