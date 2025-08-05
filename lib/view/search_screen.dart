import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hotelmanagementapp/controller/search_screen_controller.dart';
import 'package:hotelmanagementapp/public/common_function.dart';
import 'package:hotelmanagementapp/public/constant.dart';
import 'package:hotelmanagementapp/public/keys.dart';
import 'package:hotelmanagementapp/utility/in_aapp_web.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  @override
  void initState() {
    super.initState();
    // fetchAllDocs();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SearchScreenController>(builder: (controller) {
      return Scaffold(
        body: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          // behavior: HitTestBehavior.opaque,
          child: Column(
            children: [
              SizedBox(
                height: getWidgetHeight(height: 40),
              ),
              // const Divider(color: Color.fromARGB(255, 248, 248, 248)),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: Container(
                  height: 45,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: const Icon(Icons.arrow_back_ios,
                            size: 20, color: Colors.black),
                      ),
                      SizedBox(width: getWidgetWidth(width: 10)),
                      Expanded(
                        child: TextField(
                          controller: controller.controller,
                          onChanged: (value) {
                            controller.searchTerm = value.trim();
                            // fetchSearchResults(searchTerm);
                            // fetchMatchingDocs(searchTerm);
                            controller.performSearch(controller.searchTerm);
                          },
                          style: const TextStyle(color: Colors.black),
                          decoration: const InputDecoration(
                            hintText: 'Search...',
                            hintStyle: TextStyle(color: Colors.black54),
                            border: InputBorder.none,
                            isDense: true,
                            contentPadding: EdgeInsets.zero,
                          ),
                        ),
                      ),
                      const Icon(Icons.search, color: Colors.black54),
                    ],
                  ),
                ),
              ),

              // const Divider(color: Color.fromARGB(255, 248, 248, 248)),
              if (controller.controller.text.isNotEmpty)
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: getWidgetWidth(width: 12)),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Search Results for: ${controller.searchTerm}",
                      style: TextStyle(
                        fontSize: kText.scale(13),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              const Divider(color: Color.fromARGB(255, 248, 248, 248)),
              Expanded(
                child: controller.isLoading
                    ? Center(
                        child: CircularProgressIndicator(color: linearColor),
                      )
                    : controller.finalResults.isEmpty ||
                            controller.controller.text.isEmpty
                        ? const Center(child: Text("No results found"))
                        : ListView.builder(
                            itemCount: controller.finalResults.length,
                            padding: EdgeInsets.symmetric(
                                horizontal: getWidgetHeight(height: 12)),
                            itemBuilder: (context, index) {
                              final item = controller.finalResults[index];
                              final collectionName = item['fromCollection'] ==
                                      'InteractiveSimulationCollection'
                                  ? 'InteractiveSimulationCollection > ${item["simulationSub"]}'
                                  : item['fromCollection'] ==
                                          "FoodAndBevarageCollection"
                                      ? "Core Department > Food and Beverage Service Management"
                                      : item['fromCollection'] ==
                                              "HousekeepingCollection"
                                          ? "Core Department > Accommodation Management - Housekeeping"
                                          : item['fromCollection'] ==
                                                  "FrontOfficeCollection"
                                              ? "Core Department > Front Office"
                                              : item['fromCollection'] ==
                                                      'FoodProductionCollection'
                                                  ? "Core Department > Food Production"
                                                  : "No Path Found";

                              final List<dynamic> matches =
                                  item['matches'] ?? [];

                              return Container(
                                color: Colors.white,
                                padding: EdgeInsets.symmetric(
                                    vertical: getWidgetHeight(height: 8)),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: getWidgetWidth(width: 8),
                                      ),
                                      child: Text(
                                        collectionName,
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: kText.scale(9),
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                        height: getWidgetHeight(height: 6)),
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: getWidgetWidth(width: 8),
                                      ),
                                      child: Text(
                                        item['category'] ?? '',
                                        style: TextStyle(
                                          fontSize: kText.scale(13),
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                        height: getWidgetHeight(height: 6)),
                                    ...matches.map((match) {
                                      return Padding(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: getWidgetWidth(width: 8),
                                          vertical: getWidgetHeight(height: 6),
                                        ),
                                        child: InkWell(
                                          onTap: () async {
                                            final collectionName =
                                                item['fromCollection'];
                                            final category = item['category'];
                                            final matchKey =
                                                match['key']?.toLowerCase();

                                            try {
                                              if (collectionName ==
                                                  'InteractiveSimulationCollection') {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        InAppWebViewPage(
                                                      isSimulation: true,
                                                      url: item[
                                                          'simulationLink'],
                                                    ),
                                                  ),
                                                );
                                              }
                                              {
                                                final querySnapshot =
                                                    await FirebaseFirestore
                                                        .instance
                                                        .collection(
                                                            collectionName)
                                                        .where("category",
                                                            isEqualTo: category)
                                                        .get();

                                                if (querySnapshot
                                                    .docs.isNotEmpty) {
                                                  final docData = querySnapshot
                                                      .docs.first
                                                      .data();
                                                  final List<dynamic>
                                                      subcategory =
                                                      docData['subcategory'] ??
                                                          [];

                                                  final matchedSub =
                                                      subcategory.firstWhere(
                                                    (sub) =>
                                                        (sub['name']
                                                                ?.toString()
                                                                .toLowerCase() ??
                                                            '') ==
                                                        matchKey,
                                                    orElse: () => {},
                                                  );

                                                  final link =
                                                      matchedSub['link'];
                                                  if (link != null &&
                                                      link.isNotEmpty) {
                                                    print(
                                                        "✅ Link found: $link");
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            InAppWebViewPage(
                                                          isSimulation: false,
                                                          url: link,
                                                        ),
                                                      ),
                                                    );
                                                  } else {
                                                    openDialog(context);
                                                    print(
                                                        "❌ No link found for $matchKey");
                                                  }
                                                } else {
                                                  print(
                                                      "❌ No document found in $collectionName with category: $category");
                                                }
                                              }
                                            } catch (e) {
                                              print(
                                                  "❗ Error fetching data: $e");
                                            }
                                          },
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Flexible(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      "${match['key']}",
                                                      style: TextStyle(
                                                        fontSize:
                                                            kText.scale(12),
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        color: Colors.grey[700],
                                                      ),
                                                    ),
                                                    SizedBox(height: 2),
                                                    // Text.rich(
                                                    //   TextSpan(
                                                    //     children:
                                                    //         highlightOccurrences(
                                                    //       match['matched'] ?? '',
                                                    //       searchTerm,
                                                    //     ),
                                                    //   ),
                                                    // ),
                                                  ],
                                                ),
                                              ),
                                              Icon(
                                                Icons
                                                    .arrow_forward_ios_outlined,
                                                size: 16,
                                                color: Colors.black,
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                    const Divider(
                                        color:
                                            Color.fromARGB(255, 248, 248, 248)),
                                  ],
                                ),
                              );
                            },
                          ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
