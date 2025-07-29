import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
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
  final TextEditingController _controller = TextEditingController();
  String searchTerm = "";
  List<Map<String, dynamic>> searchResults = [];
  bool isLoading = false;
  List<Map<String, dynamic>> finalResults = [];
  List<Map<String, dynamic>> allDocs = [];

  @override
  void initState() {
    super.initState();
    fetchAllDocs();
  }

  fetchAllDocs() async {
    await FirebaseFirestore.instance
        .collection('GlobalSearchCollection')
        .get()
        .then((snapshot) {
      allDocs = snapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();

      log("[log] 📄 Fetched ${allDocs.length} documents from GlobalSearchCollection");
    }).catchError((error) {
      log("[log] ❗ Error fetching documents: $error");
    });
  }

  List<Map<String, dynamic>> performSearch(String searchTerm) {
    final lowerSearch = searchTerm.trim().toLowerCase();
    finalResults = [];

    for (final doc in allDocs) {
      final id = doc['id'] ?? '';
      final glossary = doc['glossaryKey'] ?? '';
      final elearning = doc['elearningKey'] ?? '';
      final String collectionName = doc['CollectionName'] ?? '';
      final String category = doc['Category'] ?? '';

      final List<String> glossaryTerms = glossary
          .toString()
          .split(',')
          .map((e) => e.trim().toLowerCase())
          .where((e) => e.isNotEmpty)
          .toList();

      final List<String> elearningTerms = elearning
          .toString()
          .split(',')
          .map((e) => e.trim().toLowerCase())
          .where((e) => e.isNotEmpty)
          .toList();

      final List<Map<String, String>> matches = [];

      // Add only first glossary match (if any)
      final glossaryMatch = glossaryTerms.firstWhere(
        (word) => word.startsWith(lowerSearch),
        orElse: () => '',
      );
      if (glossaryMatch.isNotEmpty) {
        matches.add({
          "key": "Glossary",
          "matched": glossaryMatch,
        });
      }

      // Add only first elearning match (if any)
      final elearningMatch = elearningTerms.firstWhere(
        (word) => word.startsWith(lowerSearch),
        orElse: () => '',
      );
      if (elearningMatch.isNotEmpty) {
        matches.add({
          "key": "E-Learning",
          "matched": elearningMatch,
        });
      }

      if (matches.isNotEmpty) {
        finalResults.add({
          "id": id,
          "fromCollection": collectionName,
          "category": category,
          "matches": matches,
        });
      }
    }

    setState(() {});
    log("[log] 🔍 Search results for '$searchTerm': ${finalResults.length} documents matched");
    return finalResults;
  }

  Future<void> fetchMatchingDocs(String searchTerm) async {
    final snapshot = await FirebaseFirestore.instance
        .collection('GlobalSearchCollection')
        .get();

    final lowerSearch = searchTerm.toLowerCase();
    log("[log] 🔍 Searching for: $lowerSearch");

    final List<QueryDocumentSnapshot> matchedDocs = snapshot.docs.where((doc) {
      final elearning = doc['E-learningKey'] ?? '';
      final glossary = doc['Glossarykey'] ?? '';

      // Convert string to list, trim and lowercase each keyword
      final elearningTerms = elearning
          .split(',')
          .map((e) => e.trim().toLowerCase())
          .where((term) => term.startsWith(lowerSearch));

      final glossaryTerms = glossary
          .split(',')
          .map((e) => e.trim().toLowerCase())
          .where((term) => term.startsWith(lowerSearch));

      // Match found if either list is not empty
      return elearningTerms.isNotEmpty || glossaryTerms.isNotEmpty;
    }).toList();

    setState(() {
      searchResults = matchedDocs.cast<Map<String, dynamic>>();
      isLoading = false;
    });
    log("[log] 📄 Fetched ${searchResults.length} matching documents for '$searchTerm'");
  }

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
      log("[log] 📄 Fetched ${initialResults.length} initial search result(s)");

      final List<Map<String, dynamic>> finalResults = [];

      /// Define a task list to be run in parallel
      final List<Future<void>> tasks = [];

      for (var doc in initialResults) {
        tasks.add(Future(() async {
          final collectionName = doc['CollectionName'];
          final category = doc['Category'];

          log("[log] 📁 Checking collection: $collectionName, category: $category");

          final allDocs =
              await FirebaseFirestore.instance.collection(collectionName).get();

          // Normalize and find matching category doc
          DocumentSnapshot? matchingDoc;
          for (var docSnap in allDocs.docs) {
            final data = docSnap.data() as Map<String, dynamic>;
            final docCategory =
                data['category']?.toString().trim().toLowerCase() ?? '';
            final inputCategory = category.toString().trim().toLowerCase();

            if (docCategory == inputCategory) {
              matchingDoc = docSnap;
              log("[log] ✅ MATCHED: '$docCategory'");
              break;
            }
          }

          if (matchingDoc == null) {
            log("[log] ❗ No category document matched manually in $collectionName");
            return;
          }

          final data = matchingDoc.data() as Map<String, dynamic>;
          if (data['subcategory'] is! List) return;

          final subList = List<Map<String, dynamic>>.from(data['subcategory']);
          log("[log] 📦 Found ${subList.length} subcategories in $collectionName > $category");

          List<Map<String, dynamic>> categoryMatches = [];

          for (var sub in subList) {
            final keyString = sub['Key'] ?? '';
            final keys = keyString.toString().split(',');

            for (var word in keys) {
              final trimmed = word.trim().toLowerCase();

              if (trimmed.isNotEmpty &&
                  trimmed.startsWith(query.toLowerCase())) {
                categoryMatches.add({
                  'match': trimmed,
                  'links': sub['link'] ?? '',
                  'name': sub['name'],
                  'keys': sub['Key'],
                });
                log("[log] ✅ Match found: ${sub['name']} | Keys: ${sub['Key']}");
                break; // Stop checking other keys once matched
              }
            }
          }

          if (categoryMatches.isNotEmpty) {
            finalResults.add({
              'fromCollection': collectionName,
              'category': category,
              'matches': categoryMatches,
            });

            log("[log] 📦 Added ${categoryMatches.length} matches for $collectionName > $category");
          } else {
            log("[log] ❌ No matches found in subcategories for $collectionName > $category");
          }
        }));
      }

      // Wait for all tasks to complete
      await Future.wait(tasks);

      setState(() {
        searchResults = finalResults;
        isLoading = false;
      });

      log("[log] 🎯 Total final results: ${finalResults.length} for query '$query'");
    } catch (e) {
      log("[log] 🔥 Error during search: $e");
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
                    SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        controller: _controller,
                        onChanged: (value) {
                          searchTerm = value.trim();
                          // fetchSearchResults(searchTerm);
                          // fetchMatchingDocs(searchTerm);
                          performSearch(searchTerm);
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
            if (_controller.text.isNotEmpty)
              Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: getWidgetWidth(width: 12)),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Search Results for: $searchTerm",
                    style: TextStyle(
                      fontSize: kText.scale(13),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            const Divider(color: Color.fromARGB(255, 248, 248, 248)),
            Expanded(
              child: isLoading
                  ? Center(
                      child: CircularProgressIndicator(color: linearColor),
                    )
                  : finalResults.isEmpty || _controller.text.isEmpty
                      ? const Center(child: Text("No results found"))
                      : ListView.builder(
                          itemCount: finalResults.length,
                          padding: EdgeInsets.symmetric(
                              horizontal: getWidgetHeight(height: 12)),
                          itemBuilder: (context, index) {
                            final item = finalResults[index];
                            final collectionName = item['fromCollection'] ==
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

                            final List<dynamic> matches = item['matches'] ?? [];

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
                                        fontSize: kText.scale(14),
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: getWidgetHeight(height: 6)),
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
                                  SizedBox(height: getWidgetHeight(height: 6)),
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
                                            final querySnapshot =
                                                await FirebaseFirestore.instance
                                                    .collection(collectionName)
                                                    .where("category",
                                                        isEqualTo: category)
                                                    .get();

                                            if (querySnapshot.docs.isNotEmpty) {
                                              final docData = querySnapshot
                                                  .docs.first
                                                  .data();
                                              final List<dynamic> subcategory =
                                                  docData['subcategory'] ?? [];

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

                                              final link = matchedSub['link'];
                                              if (link != null &&
                                                  link.isNotEmpty) {
                                                print("✅ Link found: $link");
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
                                          } catch (e) {
                                            print("❗ Error fetching data: $e");
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
                                                      fontSize: kText.scale(12),
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
                                              Icons.arrow_forward_ios_outlined,
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
  }
}
