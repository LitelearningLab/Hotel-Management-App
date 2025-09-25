import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:hotelmanagementapp/public/constant.dart';

class SearchScreenController extends GetxController {
  final TextEditingController controller = TextEditingController();
  String searchTerm = "";
  List<Map<String, dynamic>> searchResults = [];
  bool isLoading = false;
  List<Map<String, dynamic>> finalResults = [];
  List<Map<String, dynamic>> allDocs = [];
  List<Map<String, dynamic>> simulationDocs = [];
  @override
  void onInit() {
    super.onInit();
    fetchAllDocs();
  }

  Future<void> fetchAllDocs() async {
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
    await FirebaseFirestore.instance
        .collection('InteractiveSimulationCollection')
        .get()
        .then((snapshot) {
      simulationDocs = snapshot.docs
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
      final String simulation = doc['SimulationKey'] ?? '';

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
      final List<String> simulationTerms = simulation
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
      String simulationSub = "SimulationSub";
      String simulationLink = "";
      final simulationMatch = simulationTerms.firstWhere(
        (word) => word.startsWith(lowerSearch),
        orElse: () => '',
      );
      if (simulationMatch.isNotEmpty) {
        matches.add({
          "key": "Simulation",
          "matched": simulationMatch,
        });
        for (var simDoc in simulationDocs) {
          final simCategory = simDoc['category'] ?? '';
          final List<dynamic> subListRaw = simDoc['subcategory'] ?? [];

          log("[log] 📂 Checking Simulation Doc - Category: $simCategory with ${subListRaw.length} sub-items");

          for (var item in subListRaw) {
            final sub = Map<String, dynamic>.from(item);
            final title = (sub['title'] ?? '').toString().trim().toLowerCase();

            log("[log] 📝 Comparing title '$title' with category '${category.toLowerCase()}'");

            if (title.toLowerCase() == category.toLowerCase()) {
              simulationSub = simCategory;
              simulationLink = sub['links'][0] ?? '';
              log("[log] ✅ Match found! Simulation title '$title' starts with category '${category.toLowerCase()}'. Assigned simulationSub: $simulationSub");
              break;
            }
          }

          if (simulationSub != "SimulationSub") {
            log("[log] 🎯 Matched simulationSub found early: $simulationSub. Breaking outer loop.");
            break;
          } else {
            log("[log] ❌ No match found in this document. Continuing to next.");
          }
        }
      }

      if (matches.isNotEmpty) {
        finalResults.add({
          'simulationSub': simulationSub,
          "id": id,
          "fromCollection": collectionName,
          "category": category,
          "matches": matches,
          'simulationLink': simulationLink
        });
      }
    }

    update();
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

    searchResults = matchedDocs.cast<Map<String, dynamic>>();
    isLoading = false;
    update();

    log("[log] 📄 Fetched ${searchResults.length} matching documents for '$searchTerm'");
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

  // Future<void> fetchSearchResults(String query) async {
  //   if (query.isEmpty) {
  //     setState(() {
  //       searchResults = [];
  //       isLoading = false;
  //     });
  //     return;
  //   }

  //   setState(() {
  //     isLoading = true;
  //   });

  //   try {
  //     final snapshot = await FirebaseFirestore.instance
  //         .collection('GlobalSearchCollection')
  //         .where('Key', isGreaterThanOrEqualTo: query)
  //         .where('Key', isLessThan: query + 'z')
  //         .limit(20)
  //         .get();

  //     final initialResults = snapshot.docs.map((doc) => doc.data()).toList();
  //     log("[log] 📄 Fetched ${initialResults.length} initial search result(s)");

  //     final List<Map<String, dynamic>> finalResults = [];

  //     /// Define a task list to be run in parallel
  //     final List<Future<void>> tasks = [];

  //     for (var doc in initialResults) {
  //       tasks.add(Future(() async {
  //         final collectionName = doc['CollectionName'];
  //         final category = doc['Category'];

  //         log("[log] 📁 Checking collection: $collectionName, category: $category");

  //         final allDocs =
  //             await FirebaseFirestore.instance.collection(collectionName).get();

  //         // Normalize and find matching category doc
  //         DocumentSnapshot? matchingDoc;
  //         for (var docSnap in allDocs.docs) {
  //           final data = docSnap.data() as Map<String, dynamic>;
  //           final docCategory =
  //               data['category']?.toString().trim().toLowerCase() ?? '';
  //           final inputCategory = category.toString().trim().toLowerCase();

  //           if (docCategory == inputCategory) {
  //             matchingDoc = docSnap;
  //             log("[log] ✅ MATCHED: '$docCategory'");
  //             break;
  //           }
  //         }

  //         if (matchingDoc == null) {
  //           log("[log] ❗ No category document matched manually in $collectionName");
  //           return;
  //         }

  //         final data = matchingDoc.data() as Map<String, dynamic>;
  //         if (data['subcategory'] is! List) return;

  //         final subList = List<Map<String, dynamic>>.from(data['subcategory']);
  //         log("[log] 📦 Found ${subList.length} subcategories in $collectionName > $category");

  //         List<Map<String, dynamic>> categoryMatches = [];

  //         for (var sub in subList) {
  //           final keyString = sub['Key'] ?? '';
  //           final keys = keyString.toString().split(',');

  //           for (var word in keys) {
  //             final trimmed = word.trim().toLowerCase();

  //             if (trimmed.isNotEmpty &&
  //                 trimmed.startsWith(query.toLowerCase())) {
  //               categoryMatches.add({
  //                 'match': trimmed,
  //                 'links': sub['link'] ?? '',
  //                 'name': sub['name'],
  //                 'keys': sub['Key'],
  //               });
  //               log("[log] ✅ Match found: ${sub['name']} | Keys: ${sub['Key']}");
  //               break; // Stop checking other keys once matched
  //             }
  //           }
  //         }

  //         if (categoryMatches.isNotEmpty) {
  //           finalResults.add({
  //             ''
  //                 'fromCollection': collectionName,
  //             'category': category,
  //             'matches': categoryMatches,
  //           });

  //           log("[log] 📦 Added ${categoryMatches.length} matches for $collectionName > $category");
  //         } else {
  //           log("[log] ❌ No matches found in subcategories for $collectionName > $category");
  //         }
  //       }));
  //     }

  //     // Wait for all tasks to complete
  //     await Future.wait(tasks);

  //     setState(() {
  //       searchResults = finalResults;
  //       isLoading = false;
  //     });

  //     log("[log] 🎯 Total final results: ${finalResults.length} for query '$query'");
  //   } catch (e) {
  //     log("[log] 🔥 Error during search: $e");
  //     setState(() {
  //       searchResults = [];
  //       isLoading = false;
  //     });
  //   }
  // }
}
