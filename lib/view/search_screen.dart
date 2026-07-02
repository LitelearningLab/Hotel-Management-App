import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/instance_manager.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hotelmanagementapp/controller/home_controller.dart';
import 'package:hotelmanagementapp/controller/search_screen_controller.dart';
import 'package:hotelmanagementapp/public/common_function.dart';
import 'package:hotelmanagementapp/public/constant.dart';
import 'package:hotelmanagementapp/public/keys.dart';
import 'package:hotelmanagementapp/route/route_name.dart';
import 'package:hotelmanagementapp/utility/in_aapp_web.dart';
import 'package:hotelmanagementapp/utility/web_view_page.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  HomeController homeController = Get.put(HomeController());
  @override
  void initState() {
    super.initState();
    // fetchAllDocs();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SearchScreenController>(
      builder: (controller) {
        return PopScope(
          onPopInvoked: (_) {
            homeController.loadRecentHistory();
          },
          child: Scaffold(
            backgroundColor: const Color(0xFFF9FAFB),
            body: GestureDetector(
              onTap: () => FocusScope.of(context).unfocus(),
              child: Column(
                children: [
                  // ================================
                  // TOP SEARCH BAR (WEB STYLE)
                  // ================================
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 14,
                    ),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      border: Border(
                        bottom: BorderSide(color: Color(0xFFEDEDED)),
                      ),
                    ),
                    child: Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 1100),
                        child: Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.arrow_back_ios, size: 18),
                              onPressed: () {
                                homeController.loadRecentHistory();
                                if (kIsWeb) {
                                  Get.rootDelegate.offNamed(AppRoutes.home);
                                } else {
                                  Navigator.pop(context);
                                }
                              },
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Container(
                                height: 44,
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 14),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF1F3F5),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(Icons.search,
                                        size: 18, color: Colors.grey),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: TextField(
                                        controller: controller.controller,
                                        onChanged: (value) {
                                          controller.searchTerm = value.trim();
                                          controller.performSearch(
                                              controller.searchTerm);
                                        },
                                        style: const TextStyle(
                                          color: Colors.black, // 🔑 typed text
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                        ),
                                        cursorColor: Colors.black, // 🔑 caret
                                        decoration: const InputDecoration(
                                          hintText: 'Search lessons, topics...',
                                          hintStyle: TextStyle(
                                            color: Colors
                                                .black54, // 🔑 placeholder
                                            fontSize: 14,
                                          ),
                                          border: InputBorder.none,
                                          isDense: true,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // ================================
                  // BODY
                  // ================================
                  Expanded(
                    child: Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 1100),
                        child: controller.isLoading
                            ? Center(
                                child: CircularProgressIndicator(
                                  color: linearColor,
                                ),
                              )
                            : controller.finalResults.isEmpty ||
                                    controller.controller.text.isEmpty
                                ? const Center(
                                    child: Text(
                                      "No results found",
                                      style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 14,
                                      ),
                                    ),
                                  )
                                : ListView.builder(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 24),
                                    itemCount: controller.finalResults.length,
                                    itemBuilder: (context, index) {
                                      final item =
                                          controller.finalResults[index];

                                      final collectionName = item[
                                                  'fromCollection'] ==
                                              'InteractiveSimulationCollection'
                                          ? 'Interactive Simulations'
                                          : item['fromCollection'] ==
                                                  "FoodAndBevarageCollection"
                                              ? "Food & Beverage Service"
                                              : item['fromCollection'] ==
                                                      "HousekeepingCollection"
                                                  ? "Housekeeping"
                                                  : item['fromCollection'] ==
                                                          "FrontOfficeCollection"
                                                      ? "Front Office"
                                                      : item['fromCollection'] ==
                                                              'FoodProductionCollection'
                                                          ? "Food Production"
                                                          : "Unknown";

                                      final List<dynamic> matches =
                                          item['matches'] ?? [];

                                      return Container(
                                        margin:
                                            const EdgeInsets.only(bottom: 20),
                                        padding: const EdgeInsets.all(18),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(14),
                                          border: Border.all(
                                              color: const Color(0xFFEFEFEF)),
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              collectionName.toUpperCase(),
                                              style: const TextStyle(
                                                fontSize: 11,
                                                letterSpacing: 0.8,
                                                color: Colors.grey,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            const SizedBox(height: 6),
                                            Text(
                                              item['category'] ?? '',
                                              style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            const SizedBox(height: 14),

                                            // ====================
                                            // MATCHED ITEMS
                                            // ====================
                                            ...matches.map((match) {
                                              return InkWell(
                                                onTap: () {
                                                  // 🔒 KEEP YOUR EXISTING ON TAP LOGIC
                                                  // (unchanged)
                                                },
                                                child: Container(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                    vertical: 10,
                                                    horizontal: 12,
                                                  ),
                                                  margin: const EdgeInsets.only(
                                                      bottom: 8),
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    color:
                                                        const Color(0xFFF8F9FA),
                                                  ),
                                                  child: Row(
                                                    children: [
                                                      Expanded(
                                                        child: Text(
                                                          match['key'] ?? '',
                                                          style:
                                                              const TextStyle(
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                          ),
                                                        ),
                                                      ),
                                                      const Icon(
                                                        Icons.arrow_forward_ios,
                                                        size: 14,
                                                        color: Colors.grey,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              );
                                            }).toList(),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
