import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:hotelmanagementapp/public/constant.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../public/common_function.dart';

class ContentLabController extends GetxController {
  String selectedSort = "Relevance (Default)";
  List<WebViewController> controllers = [];
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
  final List<Map<String, dynamic>> posts = [
    {
      "category": "Food and Beverage",
      "subcategory": "Communication Skills",
      "videoUrl": "https://youtu.be/Ly7p88cL45U?si=n2Aw7ccxmezvdlBC",
      "description":
          "In this video, you’ll learn professional communication skills that every hotel front office staff must know.\n\n"
              "From handling guest queries to body language tips, this guide ensures you deliver a seamless customer experience.",
      "likes": 152,
      "views": 2100,
      "uploadDate": DateTime.now().subtract(const Duration(hours: 2)),
      'externalSource': "Nisbets (Youtube Channel)",
      'isLike': false
    },
    {
      "category": "Food Production",
      "subcategory": "Telephone Etiquette",
      "videoUrl": "https://youtu.be/gSZiXRRs65c?si=qHMSuKjSUReGXSFp",
      "description":
          "A quick guide to telephone handling in hospitality. Learn the do's and don'ts, tone control, and the correct way to take and transfer calls.",
      "likes": 98,
      "views": 1800,
      "uploadDate": DateTime.now().subtract(const Duration(hours: 4)),
      'isLike': false
    },
    {
      "category": "Food Production",
      "subcategory": "Handling Complaints",
      "videoUrl": "https://youtu.be/ewnqShNBUpY?si=muPLFsfmcjUEfmSQ",
      "description": "",
      "likes": 143,
      "views": 2300,
      "uploadDate": DateTime.now().subtract(const Duration(hours: 6)),
      "externalSource": "WebstaurantStore (Youtube Channel)",
      'isLike': false
    },
    {
      "category": "Housekeeping",
      "subcategory": "Reservation Process",
      "videoUrl": "https://www.youtube.com/watch?v=b85tkcqHmgk",
      "description": "This is an in-depth tutorial on managing reservations.\n\n"
          "From walk-in to advance bookings, confirmations, and cancellations, the video covers complete front office reservation procedures.",
      "likes": 167,
      "views": 2750,
      "uploadDate": DateTime.now().subtract(const Duration(days: 1)),
      "externalSource": "Institut Escoffier lle Maurice (Youtube Channel)",
      'isLike': false
    },
    {
      "category": "Front Office",
      "subcategory": "Mindfulness & Stress Relief",
      "videoUrl": "https://youtu.be/cULNEk6Px5E?si=Hfnac5DjDdgKNr13",
      "description": "Guided meditation for peace, mindfulness, and calmness.\n\n"
          "Includes breathing exercises to relax your mind and body. Perfect for hotel staff managing high-pressure environments.",
      "likes": 302,
      "views": 3471,
      "uploadDate": DateTime.now().subtract(const Duration(days: 2)),
      'isLike': false
    },
    {
      "category": "Front Office",
      "subcategory": "Health & Energy",
      "videoUrl": "https://youtu.be/3pYbdj-rp_Q?si=vo84bwkVQ0biY9F5",
      "description": "",
      "likes": 89,
      "views": 1321,
      "uploadDate": DateTime.now().subtract(const Duration(hours: 5)),
      "externalSource": "Reception Academy (Youtube Channel)",
      'isLike': false
    },
    {
      "category": "Front Office",
      "subcategory": "Focus & Productivity",
      "videoUrl": "https://youtu.be/IVXRmxc36Vw?si=yUlwd64mY0WtstKw",
      "description":
          "Techniques to stay focused while studying or working long shifts.\n\n"
              "Practical tools, time-blocking strategies, and examples tailored for hospitality professionals.",
      "likes": 120,
      "views": 2400,
      "uploadDate": DateTime.now().subtract(const Duration(hours: 1)),
      "externalSource": "Reception Academy (Youtube Channel)",
      'isLike': false
    },
  ];
  Future<void> loadLikedPosts() async {
    final prefs = await SharedPreferences.getInstance();
    likedVideoUrls = prefs.getStringList('likedPosts')?.toSet() ?? {};

    // Mark liked status in posts
    for (var post in showPosts) {
      post['isLike'] = likedVideoUrls.contains(post['videoUrl']);
      if (post['isLike']) {
        post['likes'] += 1;
      }
    }

    showPosts = [...posts]; // initialize display list
    update();
  }

  @override
  void onReady() {
    super.onReady();

    showPosts = posts;
    sortPosts();
    loadLikedPosts();
    expandedDescriptions = List.filled(showPosts.length, false);
    update();
  }

  List<Map<String, dynamic>> searchPosts(String query) {
    if (query.trim().isEmpty && !filterApplied) {
      return posts;
    } else {
      _applyCategorySubcategoryFilter(
          selectedCategory, selectedSubcategories.toList());
    }

    final lowerQuery = query.toLowerCase();
    return showPosts.where((post) {
      final category = post['category']?.toLowerCase() ?? '';
      final subcategory = post['subcategory']?.toLowerCase() ?? '';
      final description = post['description']?.toLowerCase() ?? '';
      final title = subcategory;
      return category.contains(lowerQuery) ||
          subcategory.contains(lowerQuery) ||
          title.contains(lowerQuery) ||
          description.contains(lowerQuery);
    }).toList();
  }

  Future<void> toggleLike(Map<String, dynamic> post) async {
    final prefs = await SharedPreferences.getInstance();
    final videoUrl = post['videoUrl'];
    if (likedVideoUrls.contains(videoUrl)) {
      likedVideoUrls.remove(videoUrl);
      post['isLike'] = false;
      post['likes'] -= 1;
    } else {
      likedVideoUrls.add(videoUrl);
      post['isLike'] = true;
      post['likes'] += 1;
    }
    await prefs.setStringList('likedPosts', likedVideoUrls.toList());
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

    // Delay WebViewController creation
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controllers = showPosts.map((post) {
        final embedUrl = convertToEmbedUrl(post["videoUrl"]);
        debugPrint("Loading WebView for $embedUrl");
        final controller = WebViewController()
          ..setJavaScriptMode(JavaScriptMode.unrestricted)
          ..loadHtmlString(_buildHtmlForUrl(embedUrl));
        return controller;
      }).toList();
      // Future.delayed(const Duration(seconds: 2), () {});
      controllerInitialized = true;
      isloading = false;
      update();
    });
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

  clearAllFilters() {
    if (filterApplied) {
      filterApplied = false;

      selectedCategory = null;
      selectedSubcategories.clear();

      if (searchController.text.isEmpty) {
        showPosts = posts;
      }

      sortPosts();

      controllers = showPosts.map((post) {
        final embedUrl = convertToEmbedUrl(post["videoUrl"]);
        debugPrint("Loading WebView for $embedUrl");

        final controller = WebViewController()
          ..setJavaScriptMode(JavaScriptMode.unrestricted)
          ..loadHtmlString(_buildHtmlForUrl(embedUrl));
        return controller;
      }).toList();

      update();
    }
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
    controllers = filtered.map((post) {
      final embedUrl = convertToEmbedUrl(post["videoUrl"]);
      final controller = WebViewController()
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..loadHtmlString(_buildHtmlForUrl(embedUrl));
      return controller;
    }).toList();

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

  String _buildHtmlForUrl(String url) {
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

    if (diff.inSeconds < 60) return '${diff.inSeconds}seconds ago';
    if (diff.inMinutes < 60) return '${diff.inMinutes}minutes ago';
    if (diff.inHours < 24) return '${diff.inHours}hours ago';
    if (diff.inDays < 30) return '${diff.inDays}days ago';
    if (diff.inDays < 365) return '${(diff.inDays / 30).floor()}months ago';
    return '${(diff.inDays / 365).floor()}years ago';
  }

  String truncateText(String text, int maxChars) {
    if (text.length <= maxChars) return text;
    return "${text.substring(0, maxChars).trim()}...";
  }
}
