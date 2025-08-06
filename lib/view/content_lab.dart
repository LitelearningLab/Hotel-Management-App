import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:hotelmanagementapp/public/common_function.dart';
import 'package:hotelmanagementapp/public/constant.dart';
import 'package:hotelmanagementapp/utility/custome_bottom_navigation.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:intl/intl.dart';

class ContentLab extends StatefulWidget {
  const ContentLab({Key? key}) : super(key: key);

  @override
  State<ContentLab> createState() => _ContentLabState();
}

class _ContentLabState extends State<ContentLab> {
  String selectedSort = "Random";
  List<WebViewController> controllers = [];
  List<bool> expandedDescriptions = [];
  bool isloading = true;
  bool controllerInitialized = false;
  String? selectedCategory;
  Set<String> selectedSubcategories = {};
  DateTime? checkInDate;
  DateTime? checkOutDate;
  bool demoOptionSelected = false;
  List<Map<String, dynamic>> showPosts = [];
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
    },
    {
      "category": "Food Production",
      "subcategory": "Handling Complaints",
      "videoUrl": "https://youtu.be/ewnqShNBUpY?si=muPLFsfmcjUEfmSQ",
      "description": "",
      "likes": 143,
      "views": 2300,
      "uploadDate": DateTime.now().subtract(const Duration(hours: 6)),
    },
    {
      "category": "Accommodation Mangement - Housekeeping",
      "subcategory": "Reservation Process",
      "videoUrl": "https://www.youtube.com/watch?v=b85tkcqHmgk",
      "description": "This is an in-depth tutorial on managing reservations.\n\n"
          "From walk-in to advance bookings, confirmations, and cancellations, the video covers complete front office reservation procedures.",
      "likes": 167,
      "views": 2750,
      "uploadDate": DateTime.now().subtract(const Duration(days: 1)),
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
    },
    {
      "category": "Front Office",
      "subcategory": "Health & Energy",
      "videoUrl": "https://youtu.be/3pYbdj-rp_Q?si=vo84bwkVQ0biY9F5",
      "description": "",
      "likes": 89,
      "views": 1321,
      "uploadDate": DateTime.now().subtract(const Duration(hours: 5)),
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
    },
  ];
  void _sortPosts() {
    isloading = true;
    setState(() {});

    if (selectedSort == "Random") {
      showPosts.shuffle();
    } else if (selectedSort == "Most Views") {
      showPosts
          .sort((a, b) => (b["views"] as int).compareTo(a["views"] as int));
    } else if (selectedSort == "Most Liked") {
      showPosts
          .sort((a, b) => (b["likes"] as int).compareTo(a["likes"] as int));
    } else if (selectedSort == "Recent Uploaded") {
      showPosts.sort((a, b) =>
          (b["uploadDate"] as DateTime).compareTo(a["uploadDate"] as DateTime));
    }

    controllers = [];
    controllers = showPosts.map((post) {
      final embedUrl = convertToEmbedUrl(post["videoUrl"]);
      final controller = WebViewController()
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..loadHtmlString(_buildHtmlForUrl(embedUrl));
      return controller;
    }).toList();
    controllerInitialized = true;
    expandedDescriptions = List.generate(showPosts.length, (_) => false);
    isloading = false;
    setState(() {});
  }

  void _openSortBottomSheet() {
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
                "Random",
                style: TextStyle(
                  fontSize: kText.scale(14),
                ),
              ),
              value: "Random",
              groupValue: selectedSort,
              activeColor: linearColor,
              onChanged: (value) => setState(() {
                selectedSort = value!;
                _sortPosts();
                Navigator.pop(context);
              }),
            ),
            RadioListTile<String>(
              title: Text(
                "Most Views",
                style: TextStyle(
                  fontSize: kText.scale(14),
                ),
              ),
              value: "Most Views",
              groupValue: selectedSort,
              activeColor: linearColor,
              onChanged: (value) => setState(() {
                selectedSort = value!;
                _sortPosts();
                Navigator.pop(context);
              }),
            ),
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
              onChanged: (value) => setState(() {
                selectedSort = value!;
                _sortPosts();
                Navigator.pop(context);
              }),
            ),
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
              onChanged: (value) => setState(() {
                selectedSort = value!;
                _sortPosts();
                Navigator.pop(context);
              }),
            ),
          ],
        ),
      ),
    );
  }

  void _openFilterBottomSheet() {
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
            final categories = posts
                .map((post) => post["category"] as String)
                .toSet()
                .toList();
            final subcategories = selectedCategory != null
                ? posts
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
                        color: Colors.grey[400]),
                  ),
                  SizedBox(
                    height: getWidgetHeight(height: 10),
                  ),
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
                                vertical: getWidgetHeight(height: 8)),
                            decoration: BoxDecoration(
                              color: isSelected ? linearColor : Colors.white,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Text(
                              category,
                              style: TextStyle(
                                color: isSelected ? Colors.white : Colors.black,
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
                          color: Colors.grey[400]),
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
                                  vertical: getWidgetHeight(height: 8)),
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
                            Navigator.pop(context);
                            setState(() {
                              selectedCategory = null;
                              selectedSubcategories.clear();
                              showPosts = posts; // Reset to original posts
                              _sortPosts();
                              // controllers = [];
                              controllers = showPosts.map((post) {
                                final embedUrl =
                                    convertToEmbedUrl(post["videoUrl"]);
                                final controller = WebViewController()
                                  ..setJavaScriptMode(
                                      JavaScriptMode.unrestricted)
                                  ..loadHtmlString(_buildHtmlForUrl(embedUrl));
                                return controller;
                              }).toList(); // Reapply sorting
                            });
                          },
                          style: OutlinedButton.styleFrom(
                            backgroundColor: Colors.white,
                            // side: const BorderSide(color: Colors.black),
                            elevation: 0,
                            shadowColor: Colors.transparent,
                          ),
                          child: const Text(
                            "Clear",
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: getWidgetWidth(width: 12),
                      ),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                            _applyCategorySubcategoryFilter(selectedCategory,
                                selectedSubcategories.toList());
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: linearColor,
                            shadowColor: Colors.white,
                            elevation: 4,
                            // side: const BorderSide(color: Colors.black),
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

    setState(() {
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
    });
  }

  @override
  void initState() {
    super.initState();
    showPosts = posts;
    _sortPosts();
    // controllers = posts.map((post) {
    //   final embedUrl = convertToEmbedUrl(post["videoUrl"]);
    //   final controller = WebViewController()
    //     ..setJavaScriptMode(JavaScriptMode.unrestricted)
    //     ..loadHtmlString(_buildHtmlForUrl(embedUrl));
    //   return controller;
    // }).toList();

    expandedDescriptions = List.filled(showPosts.length, false);
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

    if (diff.inSeconds < 60) return '${diff.inSeconds}s';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m';
    if (diff.inHours < 24) return '${diff.inHours}h';
    if (diff.inDays < 30) return '${diff.inDays}d';
    if (diff.inDays < 365) return '${(diff.inDays / 30).floor()}mo';
    return '${(diff.inDays / 365).floor()}y';
  }

  String _truncateText(String text, int maxChars) {
    if (text.length <= maxChars) return text;
    return text.substring(0, maxChars).trim() + "...";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Align(
        alignment: Alignment.bottomCenter,
        child: CustomeBottomNavigation(),
      ),
      appBar: AppBar(
        forceMaterialTransparency: true,
        surfaceTintColor: Colors.white,
        shadowColor: Colors.white,
        backgroundColor: Colors.white,
        titleSpacing: 0,
        title: const Text(
          "Content Library", maxLines: 2,
          // textAlign: TextAlign.start,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: Column(
        children: [
          // Sort and Filter buttons
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: getWidgetWidth(width: 15),
                vertical: getWidgetHeight(height: 6)),
            child: Row(
              children: [
                Expanded(
                  child: Material(
                    elevation: 4,
                    shadowColor: Colors.black,
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.white,
                    child: InkWell(
                      onTap: _openSortBottomSheet,
                      borderRadius: BorderRadius.circular(8),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: getWidgetHeight(height: 10)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.sort, color: Colors.black),
                            SizedBox(width: getWidgetWidth(width: 8)),
                            const Text("Sort",
                                style: TextStyle(color: Colors.black)),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: getWidgetWidth(width: 12)),
                Expanded(
                  child: Material(
                    elevation: 4,
                    shadowColor: Colors.black,
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.white,
                    child: InkWell(
                      onTap: _openFilterBottomSheet,
                      borderRadius: BorderRadius.circular(8),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: getWidgetHeight(height: 10)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.filter_list, color: Colors.black),
                            SizedBox(width: getWidgetHeight(height: 8)),
                            const Text("Filter",
                                style: TextStyle(color: Colors.black)),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          isloading
              ? SizedBox(
                  height: getWidgetHeight(height: 550),
                  child: Center(
                    child: CircularProgressIndicator(
                      color: linearColor,
                    ),
                  ),
                )
              : Expanded(
                  child: ListView.builder(
                    itemCount: showPosts.length,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 10),
                    itemBuilder: (context, index) {
                      final post = showPosts[index];
                      final controller = controllers[index];
                      final isExpanded = expandedDescriptions[index];
                      final description = post["description"] as String;
                      final isLongDesc =
                          description.trim().split('\n').length > 2 ||
                              description.length > 100;

                      return Padding(
                        padding: EdgeInsets.only(
                            bottom: getWidgetHeight(height: 10)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: SizedBox(
                                height: getWidgetHeight(height: 200),
                                child: WebViewWidget(controller: controller),
                              ),
                            ),
                            SizedBox(
                              height: getWidgetHeight(height: 4),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      post["category"] ?? "Content Title",
                                      style: TextStyle(
                                          fontSize: kText.scale(10),
                                          color: Colors.grey),
                                    ),
                                    Text(
                                      post["subcategory"] ?? "Content Title",
                                      style: TextStyle(
                                          fontSize: kText.scale(8),
                                          color: Colors.grey),
                                    ),
                                  ],
                                ),
                                Text(
                                  formatTimeAgo(post["uploadDate"]),
                                  style: const TextStyle(
                                      fontSize: 12, color: Colors.grey),
                                ),
                              ],
                            ),
                            SizedBox(height: getWidgetHeight(height: 4)),
                            RichText(
                              text: TextSpan(
                                style: TextStyle(
                                    fontSize: kText.scale(12),
                                    color: Colors.black),
                                children: [
                                  TextSpan(
                                    text: isExpanded || !isLongDesc
                                        ? description
                                        : _truncateText(description,
                                            100), // Adjust char count as needed
                                  ),
                                  if (!isExpanded && isLongDesc)
                                    TextSpan(
                                      text: " See more",
                                      style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: kText.scale(11)),
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () {
                                          setState(() {
                                            expandedDescriptions[index] = true;
                                          });
                                        },
                                    ),
                                  if (isExpanded && isLongDesc)
                                    TextSpan(
                                      text: " See less",
                                      style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: kText.scale(11)),
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () {
                                          setState(() {
                                            expandedDescriptions[index] = false;
                                          });
                                        },
                                    ),
                                ],
                              ),
                            ),
                            SizedBox(height: getWidgetHeight(height: 6)),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    const Icon(Icons.thumb_up,
                                        size: 16, color: Colors.grey),
                                    const SizedBox(width: 4),
                                    Text("${post["likes"]}"),
                                  ],
                                ),
                                Row(
                                  children: [
                                    const Icon(Icons.remove_red_eye_outlined,
                                        size: 16, color: Colors.grey),
                                    const SizedBox(width: 4),
                                    Text("${post["views"]}"),
                                  ],
                                )
                              ],
                            ),
                            Divider(
                              color: Colors.grey.withOpacity(0.5),
                              // height: 20,
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
          SizedBox(
            height: getWidgetHeight(height: 60),
          )
        ],
      ),
    );
  }
}
