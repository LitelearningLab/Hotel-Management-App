import 'dart:developer';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:hotelmanagementapp/public/constant.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../public/common_function.dart';

class ContentLabController extends GetxController {
  String selectedSort = "Relevance (Default)";
  late DataSnapshot snapshot;
  List<WebViewController?> controllers = [];
  List<bool> expandedDescriptions = [];
  bool isloading = true;
  bool controllerInitialized = false;
  String? selectedCategory;
  Set<String> selectedSubcategories = {};
  DateTime? checkInDate;
  DateTime? checkOutDate;
  bool demoOptionSelected = false;
  bool isSearching = false;
  List<Map<String, dynamic>> showPosts = [];
  TextEditingController searchController = TextEditingController();
  bool filterApplied = false;
  Set<String> likedVideoUrls = {};
  List<Map<String, dynamic>> posts = [];
  bool fetchMore = false;
  final database = FirebaseDatabase.instance;
  int _batchSize = 2;
  int _currentIndex = 0;
  bool isFetchingMore = false;
  bool hasMorePosts = true;
  String? _lastFetchedKey;
  bool _hasMoreData = true;

  ScrollController scrollController = ScrollController();
  Future<void> fetchPostsFromFirebase() async {
    isloading = true;
    _lastFetchedKey = null;
    hasMorePosts = false; // Since we're loading everything at once
    showPosts.clear();
    posts.clear();
    expandedDescriptions.clear();
    controllers.clear();
    update();

    try {
      final ref = database.ref('ContentLibraryCollection');

      // 🔄 No pagination - get all data
      final snapshot = await ref.orderByKey().get();

      if (snapshot.exists) {
        final data = snapshot.value as Map<dynamic, dynamic>;
        final entries = data.entries.toList();

        final List<Map<String, dynamic>> loadedPosts = [];

        for (final entry in entries) {
          final postMap = Map<String, dynamic>.from(entry.value);
          postMap['id'] = entry.key;

          DateTime uploadDate;
          try {
            final rawDate = postMap['uploadDate'];
            if (rawDate is String) {
              uploadDate = DateTime.parse(rawDate);
            } else if (rawDate is DateTime) {
              uploadDate = rawDate;
            } else {
              uploadDate = DateTime.now();
            }
          } catch (_) {
            uploadDate = DateTime.now();
          }

          loadedPosts.add({
            ...postMap,
            'uploadDate': uploadDate,
            'isLike': false,
            'likes': postMap['likes'] ?? 0,
            'views': postMap['views'] ?? 0,
            'description': postMap['description'] ?? '',
            'category': postMap['category'] ?? '',
            'subcategory': postMap['subcategory'] ?? '',
          });
        }

        showPosts.addAll(loadedPosts);
        posts.addAll(loadedPosts);
        expandedDescriptions
            .addAll(List<bool>.filled(loadedPosts.length, false));
        controllers.addAll(List.filled(loadedPosts.length, null));

        await loadLikedPosts();
      }
    } catch (e) {
      debugPrint("Error fetching all emergency posts: $e");
    }

    isloading = false;
    update();
  }

  Future<void> loadLikedPosts() async {
    final prefs = await SharedPreferences.getInstance();
    likedVideoUrls = prefs.getStringList('likedPosts')?.toSet() ?? {};
    for (var post in showPosts) {
      post['isLike'] = likedVideoUrls.contains(post['videoUrl']);
    }

    showPosts = [...posts];
    update();
  }

  @override
  void onReady() {
    super.onReady();
    fetchPostsFromFirebase();
    // showPosts = posts;
    // sortPosts();
    // loadLikedPosts();
    // expandedDescriptions = List.filled(showPosts.length, false);
    // scrollController.addListener(() {
    //   if (scrollController.position.pixels >=
    //       scrollController.position.maxScrollExtent - 100) {
    //     // fetchPostsFromFirebase(loadMore: true);
    //   }
    // });

    update();
  }

  List<Map<String, dynamic>> searchPosts(String query) {
    if (query.trim().isEmpty && !filterApplied) {
      return posts;
    } else {
      _applyCategorySubcategoryFilter(
          selectedCategory, selectedSubcategories.toList());
    }

    final lowerQuery = query.toLowerCase().trim();
    return showPosts.where((post) {
      final category = post['category']?.toLowerCase() ?? '';
      final subcategory = post['subcategory']?.toLowerCase() ?? '';
      final description = post['description']?.toLowerCase() ?? '';
      final title = post['title'] ?? "";
      // final title = subcategory;
      return category.contains(lowerQuery) ||
          subcategory.contains(lowerQuery) ||
          title.contains(lowerQuery) ||
          description.contains(lowerQuery);
    }).toList();
  }

  Future<void> toggleLike(Map<String, dynamic> post) async {
    final prefs = await SharedPreferences.getInstance();
    final videoUrl = post['videoUrl'];

    // Toggle local like status
    if (likedVideoUrls.contains(videoUrl)) {
      likedVideoUrls.remove(videoUrl);
      post['isLike'] = false;
      post['likes'] = (post['likes'] ?? 1) - 1;
    } else {
      likedVideoUrls.add(videoUrl);
      post['isLike'] = true;
      post['likes'] = (post['likes'] ?? 0) + 1;
    }

    await prefs.setStringList('likedPosts', likedVideoUrls.toList());
    try {
      final data = snapshot.value;
      if (data is List) {
        for (int i = 0; i < data.length; i++) {
          final item = data[i];
          if (item == null || item is! Map) continue;

          if (item['videoUrl'] == videoUrl) {
            final postRef = database.ref('ContentLibraryCollection/$i');
            await postRef.update({
              'likes': post['likes'],
            });
            break;
          }
        }
      } else {
        debugPrint("Snapshot is not a List. Cannot update post.");
      }
    } catch (e) {
      debugPrint("Error updating Firebase: $e");
    }

    update();
  }

  void sortPosts() {
    isloading = true;
    update();

    if (selectedSort == "Relevance (Default)") {
      // showPosts.shuffle();
    } else if (selectedSort == "Most Liked") {
      showPosts
          .sort((a, b) => (b["likes"] as int).compareTo(a["likes"] as int));
    } else if (selectedSort == "Recent Uploaded") {
      showPosts.sort((a, b) =>
          (b["uploadDate"] as DateTime).compareTo(a["uploadDate"] as DateTime));
    }

    controllers = [];
    controllerInitialized = false;
    expandedDescriptions = List.generate(showPosts.length, (_) => false);
    controllers = List.filled(showPosts.length, null);

    // // Delay WebViewController creation
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   controllers = showPosts.map((post) {
    //     final embedUrl = convertToEmbedUrl(post["videoUrl"]);
    //     debugPrint("Loading WebView for $embedUrl");
    //     final controller = WebViewController()
    //       ..setJavaScriptMode(JavaScriptMode.unrestricted)
    //       ..loadHtmlString(_buildHtmlForUrl(embedUrl));
    //     return controller;
    //   }).toList();
    //   // Future.delayed(const Duration(seconds: 2), () {});
    //   controllerInitialized = true;
    //   isloading = false;
    //   update();
    // });
    isloading = false;
    update();
  }

  void openSortBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<String>(
                title: Text(
                  "Relevance (Default)",
                  style: TextStyle(
                    fontSize: kText.scale(14),
                  ),
                ),
                value: "Relevance (Default)",
                groupValue: selectedSort,
                activeColor: linearColor,
                onChanged: (value) {
                  selectedSort = value!;
                  sortPosts();
                  Navigator.pop(context);
                  update();
                }),
            RadioListTile<String>(
                title: Text(
                  "Most Liked",
                  style: TextStyle(
                    fontSize: kText.scale(14),
                  ),
                ),
                value: "Most Liked",
                groupValue: selectedSort,
                activeColor: linearColor,
                onChanged: (value) {
                  selectedSort = value!;
                  sortPosts();
                  Navigator.pop(context);
                }),
            RadioListTile<String>(
                title: Text(
                  "Recent Uploaded",
                  style: TextStyle(
                    fontSize: kText.scale(14),
                  ),
                ),
                value: "Recent Uploaded",
                groupValue: selectedSort,
                activeColor: linearColor,
                onChanged: (value) {
                  selectedSort = value!;
                  sortPosts();
                  Navigator.pop(context);
                }),
          ],
        ),
      ),
    );
  }

  Future<void> refreshPosts() async {
    clearAll();

    // await fetchPostsFromFirebase();
    update();
  }

  clearAllFilters() {
    isloading = true;
    update();
    if (filterApplied) {
      filterApplied = false;

      selectedCategory = null;
      selectedSubcategories.clear();

      if (searchController.text.isEmpty) {
        showPosts = posts;
      }

      sortPosts();

      // controllers = showPosts.map((post) {
      //   final embedUrl = convertToEmbedUrl(post["videoUrl"]);
      //   debugPrint("Loading WebView for $embedUrl");

      //   final controller = WebViewController()
      //     ..setJavaScriptMode(JavaScriptMode.unrestricted)
      //     ..loadHtmlString(_buildHtmlForUrl(embedUrl));
      //   return controller;
      // }).toList();

      update();
    }
    isloading = false;
    update();
  }

  clearAll() async {
    isloading = true;
    update();

    isSearching = false;
    searchController.clear();
    clearAllFilters();
    selectedSort = "Relevance (Default)";
    sortPosts();
    await Future.delayed(Duration(seconds: 2));
    isloading = false;
    update();
  }

  void openFilterBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            final categories = searchController.text.isNotEmpty
                ? showPosts
                    .map((post) => post["category"] as String)
                    .toSet()
                    .toList()
                : posts
                    .map((post) => post["category"] as String)
                    .toSet()
                    .toList();

            final subcategories = selectedCategory != null
                ? searchController.text.isNotEmpty
                    ? showPosts
                        .where((post) => post["category"] == selectedCategory)
                        .map((post) => post["subcategory"] as String)
                        .toSet()
                        .toList()
                    : posts
                        .where((post) => post["category"] == selectedCategory)
                        .map((post) => post["subcategory"] as String)
                        .toSet()
                        .toList()
                : [];

            return Padding(
              padding: EdgeInsets.symmetric(
                horizontal: getWidgetWidth(width: 16),
                vertical: getWidgetHeight(height: 10),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Category",
                    style: TextStyle(
                      fontSize: kText.scale(12),
                      fontWeight: FontWeight.w500,
                      color: Colors.grey[400],
                    ),
                  ),
                  SizedBox(height: getWidgetHeight(height: 10)),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: categories.map((category) {
                      final isSelected = selectedCategory == category;

                      return GestureDetector(
                        onTap: () {
                          setModalState(() {
                            selectedCategory = category;
                            selectedSubcategories.clear();
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                offset: const Offset(0, 4),
                                blurRadius: 10,
                              ),
                            ],
                          ),
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: getWidgetWidth(width: 10),
                              vertical: getWidgetHeight(height: 8),
                            ),
                            decoration: BoxDecoration(
                              color: selectedCategory == category
                                  ? linearColor
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Text(
                              category,
                              style: TextStyle(
                                color: selectedCategory == category
                                    ? Colors.white
                                    : Colors.black,
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  SizedBox(height: getWidgetHeight(height: 20)),
                  if (selectedCategory != null) ...[
                    Text(
                      "Subcategory",
                      style: TextStyle(
                        fontSize: kText.scale(12),
                        fontWeight: FontWeight.w500,
                        color: Colors.grey[400],
                      ),
                    ),
                    SizedBox(height: getWidgetHeight(height: 12)),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: subcategories.map((subcategory) {
                        final isChecked =
                            selectedSubcategories.contains(subcategory);
                        return GestureDetector(
                          onTap: () {
                            setModalState(() {
                              if (isChecked) {
                                selectedSubcategories.remove(subcategory);
                              } else {
                                selectedSubcategories.add(subcategory);
                              }
                            });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  offset: const Offset(0, 4),
                                  blurRadius: 10,
                                ),
                              ],
                            ),
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: getWidgetWidth(width: 10),
                                vertical: getWidgetHeight(height: 8),
                              ),
                              decoration: BoxDecoration(
                                color: isChecked ? linearColor : Colors.white,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Text(
                                subcategory,
                                style: TextStyle(
                                  color:
                                      isChecked ? Colors.white : Colors.black,
                                ),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                  SizedBox(height: getWidgetHeight(height: 30)),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            setModalState(() {
                              clearAllFilters();
                            });
                            Navigator.pop(context);
                          },
                          style: OutlinedButton.styleFrom(
                            backgroundColor: Colors.white,
                            elevation: 0,
                            shadowColor: Colors.transparent,
                          ),
                          child: const Text(
                            "Clear",
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                      ),
                      SizedBox(width: getWidgetWidth(width: 12)),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                            _applyCategorySubcategoryFilter(
                              selectedCategory,
                              selectedSubcategories.toList(),
                            );
                            filterApplied = true;
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: linearColor,
                            shadowColor: Colors.white,
                            elevation: 4,
                          ),
                          child: const Text(
                            "Apply",
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _applyCategorySubcategoryFilter(
      String? category, List<String> subcategories) {
    List<Map<String, dynamic>> filtered = posts;

    if (category != null) {
      filtered =
          filtered.where((post) => post['category'] == category).toList();
    }

    if (subcategories.isNotEmpty) {
      filtered = filtered
          .where((post) => subcategories.contains(post['subcategory']))
          .toList();
    }

    showPosts = filtered;
    // controllers = filtered.map((post) {
    //   final embedUrl = convertToEmbedUrl(post["videoUrl"]);
    //   final controller = WebViewController()
    //     ..setJavaScriptMode(JavaScriptMode.unrestricted)
    //     ..loadHtmlString(_buildHtmlForUrl(embedUrl));
    //   return controller;
    // }).toList();
    controllers = List.filled(showPosts.length, null);
    // Optionally, reset or update expandedDescriptions too
    expandedDescriptions = List.generate(showPosts.length, (_) => false);
    update();
  }

  String convertToEmbedUrl(String url) {
    final uri = Uri.parse(url);

    if (uri.host.contains("youtu.be")) {
      // https://youtu.be/VIDEO_ID
      final videoId = uri.pathSegments.first;
      return "https://www.youtube.com/embed/$videoId";
    } else if (uri.host.contains("youtube.com") &&
        uri.queryParameters.containsKey("v")) {
      // https://www.youtube.com/watch?v=VIDEO_ID
      return "https://www.youtube.com/embed/${uri.queryParameters['v']}";
    }

    return url; // fallback
  }

  String buildHtmlForUrl(String url) {
    return '''
      <!DOCTYPE html>
      <html>
        <head>
          <meta name="viewport" content="width=device-width, initial-scale=1.0">
          <style>
            html, body {
              margin: 0;
              padding: 0;
              height: 100%;
              background-color: black;
            }
            iframe {
              display: block;
              width: 100%;
              height: 100%;
              border: none;
            }
          </style>
        </head>
        <body>
          <iframe 
            src="$url" 
            allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" 
            allowfullscreen>
          </iframe>
        </body>
      </html>
    ''';
  }

  String formatTimeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final diff = now.difference(dateTime);

    if (diff.inSeconds < 60) {
      final seconds = diff.inSeconds;
      return '$seconds${seconds == 1 ? 'second' : 'seconds'} ago';
    }

    if (diff.inMinutes < 60) {
      final minutes = diff.inMinutes;
      return '$minutes${minutes == 1 ? 'minute' : 'minutes'} ago';
    }

    if (diff.inHours < 24) {
      final hours = diff.inHours;
      return '$hours${hours == 1 ? 'hour' : 'hours'} ago';
    }

    if (diff.inDays < 30) {
      final days = diff.inDays;
      return '$days${days == 1 ? 'day' : 'days'} ago';
    }

    if (diff.inDays < 365) {
      final months = (diff.inDays / 30).floor();
      return '$months${months == 1 ? 'month' : 'months'} ago';
    }

    final years = (diff.inDays / 365).floor();
    return '$years${years == 1 ? 'year' : 'years'} ago';
  }

  String truncateText(String text, int maxChars) {
    if (text.length <= maxChars) return text;
    return "${text.substring(0, maxChars).trim()}...";
  }
}
