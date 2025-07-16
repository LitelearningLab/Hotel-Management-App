import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hotelmanagementapp/public/common_function.dart';
import 'package:hotelmanagementapp/public/constant.dart';
import 'package:hotelmanagementapp/public/keys.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _controller = TextEditingController();
  String searchTerm = "";
  List<Map<String, dynamic>> searchResults = [];
  bool isLoading = false;
  List<Map<String, dynamic>> finalResults = [];

  Future<void> fetchSearchResults(String query) async {
    if (query.isEmpty) {
      setState(() {
        searchResults = [];
        isLoading = false;
      });
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('GlobalSearchCollection')
          .where('Key', isGreaterThanOrEqualTo: query)
          .where('Key', isLessThan: query + 'z')
          .limit(20)
          .get();

      final initialResults = snapshot.docs.map((doc) => doc.data()).toList();

      final List<Map<String, dynamic>> finalResults = List.from(initialResults);

      for (var doc in initialResults) {
        final collectionName = doc['CollectionName'];
        final category = doc['Category'];
        log("message: $collectionName, $category");

        if (collectionName == null || category == null) continue;

        final categoryQuery = await FirebaseFirestore.instance
            .collection(collectionName)
            .where('category', isEqualTo: category)
            .limit(1)
            .get();
        if (categoryQuery.docs.isNotEmpty) {
          final data = categoryQuery.docs.first.data();
          if (data['subcategory'] is List) {
            final subList =
                List<Map<String, dynamic>>.from(data['subcategory']);

            // Create a list to hold matches for this category
            List<Map<String, dynamic>> categoryMatches = [];

            for (var sub in subList) {
              final keyString = sub['key'] ?? '';
              final keys = keyString.toString().split(',');

              for (var word in keys) {
                final trimmed = word.trim().toLowerCase();
                if (trimmed.isNotEmpty &&
                    trimmed.startsWith(query.toLowerCase())) {
                  categoryMatches.add({
                    'match': trimmed,
                    'link': sub['link'],
                    'name': sub['name'],
                  });
                  break; // Stop checking other keys for this sub-item if we found a match
                }
              }
            }

            // If we found any matches for this category, add them all as a group
            if (categoryMatches.isNotEmpty) {
              finalResults.add({
                'fromCollection': collectionName,
                'category': category,
                'matches': categoryMatches,
              });
            }
          }
        } else {
          log("No data found for collection: $collectionName, category: $category");
        }
      }

      setState(() {
        searchResults = finalResults;
        isLoading = false;
      });

      log("Search results: ${finalResults.length} items found for query '$query'");
    } catch (e) {
      log("Error: $e");
      setState(() {
        searchResults = [];
        isLoading = false;
      });
    }
  }

  List<TextSpan> highlightOccurrences(String source, String query) {
    if (query.isEmpty) {
      return [TextSpan(text: source, style: TextStyle(color: Colors.black))];
    }

    final matches = <TextSpan>[];
    final lcSource = source.toLowerCase();
    final lcQuery = query.toLowerCase();
    int start = 0;

    while (true) {
      final index = lcSource.indexOf(lcQuery, start);
      if (index < 0) {
        matches.add(TextSpan(
            text: source.substring(start),
            style: const TextStyle(color: Colors.black)));
        break;
      }

      if (index > start) {
        matches.add(TextSpan(
            text: source.substring(start, index),
            style: const TextStyle(color: Colors.black)));
      }

      matches.add(TextSpan(
          text: source.substring(index, index + query.length),
          style: TextStyle(fontWeight: FontWeight.bold, color: linearColor)));

      start = index + query.length;
    }

    return matches;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        forceMaterialTransparency: true,
        backgroundColor: Colors.white,
        titleSpacing: 0,
        title: Text(
          "Search",
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
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back),
          ),
        ),
      ),
      body: Column(
        children: [
          const Divider(color: Color.fromARGB(255, 248, 248, 248)),
          Container(
            color: Colors.white,
            child: TextField(
              controller: _controller,
              onChanged: (value) {
                searchTerm = value.trim();
                fetchSearchResults(searchTerm);
              },
              style: const TextStyle(color: Colors.black),
              decoration: const InputDecoration(
                hintText: 'Search...',
                hintStyle: TextStyle(color: Colors.black54),
                prefixIcon: Icon(Icons.search, color: Colors.black),
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                filled: false,
                isDense: true,
                contentPadding: EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
          const Divider(color: Color.fromARGB(255, 248, 248, 248)),
          if (_controller.text.isNotEmpty)
            Padding(
              padding:
                  EdgeInsets.symmetric(horizontal: getWidgetWidth(width: 12)),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Search Results for: $searchTerm",
                  style: TextStyle(
                    fontSize: kText.scale(15),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          Expanded(
            child: isLoading
                ? Center(
                    child: CircularProgressIndicator(
                    color: linearColor,
                  ))
                : searchResults.isEmpty
                    ? const Center(child: Text("No results found"))
                    : ListView.builder(
                        itemCount: searchResults.length,
                        padding: EdgeInsets.symmetric(
                            horizontal: getWidgetHeight(height: 12)),
                        itemBuilder: (context, index) {
                          final item = searchResults[index];
                          String collectionName = item['CollectionName'] ==
                                  "FoodAndBeverageCollection"
                              ? "Core Department > Food and Beverage"
                              : item['CollectionName'] ==
                                      "HousekeepingCollection"
                                  ? "Core Department > Housekeeping"
                                  : item['CollectionName'] ==
                                          "FrontOfficeCollection"
                                      ? "Core Department > Front Office"
                                      : "No Path Found";
                          final hasSubcategories =
                              item['subcategory'] != null &&
                                  (item['subcategory'] is List ||
                                      item['subcategory'] is Map);

                          if (hasSubcategories) {
                            if (item['subcategory'] is List) {
                              final subList = item['subcategory'] as List;
                              log("Subcategories count: ${subList.length}");
                              // You can also log the subcategories details if needed
                              for (var sub in subList) {
                                log("Subcategory: ${sub.toString()}");
                              }
                            } else if (item['subcategory'] is Map) {
                              final subMap = item['subcategory'] as Map;
                              log("Subcategories count: ${subMap.length}");
                              // You can also log the subcategories details if needed
                              subMap.forEach((key, value) {
                                log("Subcategory - $key: $value");
                              });
                            }
                          }
                          return Container(
                            color: Colors.white,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    collectionName,
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: kText.scale(14),
                                        fontWeight: FontWeight.w500),
                                  ),
                                  Text.rich(
                                    TextSpan(
                                      children: highlightOccurrences(
                                          item['key'] ?? '', searchTerm),
                                    ),
                                  ),
                                  Text(
                                    "${item['category'] ?? ''} > ${item['subcategory'] ?? ''}",
                                    style: TextStyle(
                                      fontSize: kText.scale(12),
                                      fontFamily: Keys.fontFamily,
                                    ),
                                  ),
                                  SizedBox(height: getWidgetHeight(height: 6)),
                                  const Divider(
                                      color: Color.fromARGB(255, 248, 248, 248))
                                ],
                              ),
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}
