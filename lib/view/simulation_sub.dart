import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:get/instance_manager.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hotelmanagementapp/controller/simulation_controller.dart';
import 'package:hotelmanagementapp/controller/simulation_sub_controller.dart';
import 'package:hotelmanagementapp/model/simulation_model.dart';
import 'package:hotelmanagementapp/public/all_asset.dart';
import 'package:hotelmanagementapp/public/common_function.dart';
import 'package:hotelmanagementapp/utility/in_aapp_web.dart';

class SimulationSub extends StatefulWidget {
  final SimulationSubController controller = Get.put(SimulationSubController());

  SimulationSub({super.key});

  @override
  State<SimulationSub> createState() => _SimulationSubState();
}

class _SimulationSubState extends State<SimulationSub> {
  late List<bool> isExpanded;
  int expandedIndex = -1;
  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvoked: (didpop) {
        sessionName = "";
      },
      child: Scaffold(
        appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () {
                sessionName = "";
                Navigator.pop(context);
              }, // or Get.back()
            ),
            forceMaterialTransparency: true,
            backgroundColor: Colors.white,
            titleSpacing: 0,
            title: GetBuilder<SimulationSubController>(builder: (controller) {
              return Text(
                controller.title,
                textAlign: TextAlign.left,
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.w600,
                  fontSize: 20,
                  color: Colors.black,
                ),
              );
            })),
        body: SafeArea(
            child: Column(
          children: [
            GetBuilder<SimulationSubController>(builder: (controller) {
              return Expanded(
                child: ListView.builder(
                  padding: EdgeInsets.symmetric(
                      vertical: getWidgetHeight(height: 10),
                      horizontal: getWidgetWidth(width: 20)),
                  itemCount: controller.simulation.subcategory.length,
                  itemBuilder: (context, index) {
                    final isExpanded = controller.expandedIndex == index;

                    final linkAvailable = (controller.simulation
                            .subcategory[index].links[0].isNotEmpty &&
                        controller.simulation.subcategory[index].links[0] !=
                            "link1");

                    final linkAvailable1 = (controller.simulation
                            .subcategory[index].links[1].isNotEmpty &&
                        controller.simulation.subcategory[index].links[1] !=
                            "link2");

                    final linkAvailable2 = (controller.simulation
                            .subcategory[index].links[2].isNotEmpty &&
                        controller.simulation.subcategory[index].links[2] !=
                            "link3");
                    // final linkAvailable1 = (controller
                    //         .frontOfficeData[index]
                    //         .subcategory[1]
                    //         .link
                    //         .isNotEmpty ||
                    //     controller.frontOfficeData[index].subcategory[1]
                    //             .link !=
                    //         "");
                    // final linkAvailable2 = (controller
                    //         .frontOfficeData[index]
                    //         .subcategory[2]
                    //         .link
                    //         .isNotEmpty ||
                    //     controller.frontOfficeData[index].subcategory[2]
                    //             .link !=
                    //         "");

                    return Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: getWidgetHeight(height: 5)),
                          child: GestureDetector(
                              onTap: () {
                                controller.expandedIndex =
                                    isExpanded ? -1 : index;
                                setState(() {});
                                // controller.update();
                              },
                              child: AnimatedSize(
                                duration: const Duration(milliseconds: 200),
                                curve: Curves.fastOutSlowIn,
                                child: Container(
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    color: Colors.white,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.1),
                                        offset: const Offset(0, 4),
                                        blurRadius: 10,
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                          vertical: getWidgetHeight(height: 12),
                                          horizontal: getWidgetWidth(width: 20),
                                        ),
                                        child: Text(
                                          controller.simulation
                                              .subcategory[index].title,
                                          style: GoogleFonts.inter(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ),
                                      if (isExpanded)
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                            horizontal:
                                                getWidgetWidth(width: 10),
                                          ),
                                          child: const Divider(
                                            color: Color.fromARGB(
                                                255, 107, 107, 107),
                                          ),
                                        ),
                                      if (isExpanded)
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                            horizontal:
                                                getWidgetWidth(width: 15),
                                            vertical:
                                                getWidgetHeight(height: 8),
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            children: [
                                              GestureDetector(
                                                onTap: linkAvailable
                                                    ? () {
                                                        sessionName = controller
                                                            .simulation
                                                            .subcategory[index]
                                                            .title;
                                                        activityName =
                                                            "Simulation 1";
                                                        Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        InAppWebViewPage(
                                                                          url: controller
                                                                              .simulation
                                                                              .subcategory[index]
                                                                              .links[0],
                                                                        )));
                                                      }
                                                    : null,
                                                child: Wrap(
                                                  children: [
                                                    Text(
                                                      "#1",
                                                      style: TextStyle(
                                                        color: linkAvailable
                                                            ? Colors.black
                                                            : Colors.grey,
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: getWidgetWidth(
                                                          width: 5),
                                                    ),
                                                    Image.asset(
                                                      AllAssets.interb,
                                                      color: linkAvailable
                                                          ? Colors.black
                                                          : Colors.grey,
                                                      width: getWidgetWidth(
                                                          width: 26),
                                                      height: getWidgetHeight(
                                                          height: 28),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              GestureDetector(
                                                onTap: linkAvailable1
                                                    ? () {
                                                        sessionName = controller
                                                            .simulation
                                                            .subcategory[index]
                                                            .title;
                                                        activityName =
                                                            "Simulation 2";
                                                        Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        InAppWebViewPage(
                                                                          url: controller
                                                                              .simulation
                                                                              .subcategory[index]
                                                                              .links[1],
                                                                        )));
                                                      }
                                                    : null,
                                                child: Wrap(
                                                  children: [
                                                    Text(
                                                      "#2",
                                                      style: TextStyle(
                                                        color: linkAvailable1
                                                            ? Colors.black
                                                            : Colors.grey,
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: getWidgetWidth(
                                                          width: 5),
                                                    ),
                                                    Image.asset(
                                                      AllAssets.interb,
                                                      color: linkAvailable1
                                                          ? Colors.black
                                                          : Colors.grey,
                                                      width: getWidgetWidth(
                                                          width: 26),
                                                      height: getWidgetHeight(
                                                          height: 28),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              GestureDetector(
                                                onTap: linkAvailable2
                                                    ? () {
                                                        sessionName = controller
                                                            .simulation
                                                            .subcategory[index]
                                                            .title;
                                                        activityName =
                                                            "Simulation 3";
                                                        Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        InAppWebViewPage(
                                                                          url: controller
                                                                              .simulation
                                                                              .subcategory[index]
                                                                              .links[2],
                                                                        )));
                                                      }
                                                    : null,
                                                child: Wrap(
                                                  children: [
                                                    Text(
                                                      "#3",
                                                      style: TextStyle(
                                                        color: linkAvailable2
                                                            ? Colors.black
                                                            : Colors.grey,
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: getWidgetWidth(
                                                          width: 5),
                                                    ),
                                                    Image.asset(
                                                      AllAssets.interb,
                                                      color: linkAvailable2
                                                          ? Colors.black
                                                          : Colors.grey,
                                                      width: getWidgetWidth(
                                                          width: 26),
                                                      height: getWidgetHeight(
                                                          height: 28),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              )),
                        ),
                      ],
                    );
                  },
                ),
              );
            }),
          ],
        )),
      ),
    );
  }
}
