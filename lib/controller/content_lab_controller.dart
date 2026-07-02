import 'dart:developer';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hotelmanagementapp/public/constant.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

import '../public/common_function.dart';

class ContentLabController extends GetxController {
  /// ---------------- DATABASE ----------------
  final database = FirebaseDatabase.instance;

  /// ---------------- DATA ----------------
  final List<Map<String, dynamic>> posts = []; // master list
  List<Map<String, dynamic>> showPosts = []; // visible list

  /// ---------------- STATE ----------------
  bool isLoading = true;
  bool isSearching = false;
  bool filterApplied = false;

  String selectedSort = "Relevance (Default)";
  String? selectedCategory;
  Set<String> selectedSubcategories = {};

  final TextEditingController searchController = TextEditingController();

  /// ---------------- HELPERS ----------------
  final List<WebViewController?> webControllers = [];
  final List<YoutubePlayerController?> ytControllers = [];
  final List<bool> expandedDescriptions = [];

  final Set<String> likedVideoUrls = {};

  /// ---------------- INIT ----------------
  @override
  void onReady() {
    super.onReady();
    mainCategoryTitle = "Content Library";
    timestampIndex = 7;
    subCategoryTitle = "";
    activityName = "Content Library";
    sessionName = "";
    startTimerMainCategory("");
    fetchPostsFromFirebase();
  }

  /// ---------------- FETCH ----------------
  Future<void> fetchPostsFromFirebase() async {
    isLoading = true;
    update();

    posts.clear();
    showPosts.clear();

    try {
      final ref = database.ref('ContentLibraryCollection');
      final snapshot = await ref.orderByKey().get();

      if (!snapshot.exists) return;

      final raw = Map<dynamic, dynamic>.from(snapshot.value as Map);

      for (final entry in raw.entries) {
        final map = Map<String, dynamic>.from(entry.value);

        posts.add({
          ...map,
          'id': entry.key,
          'uploadDate': _parseDate(map['uploadDate']),
          'likes': map['likes'] ?? 0,
          'views': map['views'] ?? 0,
          'isLike': false,
          'description': map['description'] ?? '',
          'category': map['category'] ?? '',
          'subcategory': map['subcategory'] ?? '',
        });
      }

      await _loadLikedPosts();
      _rebuildVisibleList();
    } catch (e) {
      log("Fetch error: $e");
    }

    isLoading = false;
    update();
  }

  /// ---------------- CORE PIPELINE ----------------
  void _rebuildVisibleList() {
    List<Map<String, dynamic>> result = List.from(posts);

    /// SEARCH
    final q = searchController.text.trim().toLowerCase();
    if (q.isNotEmpty) {
      result = result.where((p) {
        return p['title'].toString().toLowerCase().contains(q) ||
            p['description'].toString().toLowerCase().contains(q) ||
            p['category'].toString().toLowerCase().contains(q) ||
            p['subcategory'].toString().toLowerCase().contains(q);
      }).toList();
    }

    showPosts = [...posts];
    update();
  }

  @override
  void onReady() {
    super.onReady();
    mainCategoryTitle = "Content Library";
    subCategoryTitle = "";
    activityName = "";
    sessionName = "";
    sessionName2 = "";
    timestampIndex = 7;

    if (selectedSubcategories.isNotEmpty) {
      result = result
          .where((p) => selectedSubcategories.contains(p['subcategory']))
          .toList();
    }

    showPosts = result;

    /// SORT (original behavior)
    _applySort();

    _syncHelpers();
  }

  /// ---------------- SEARCH ----------------
  void applySearch(String _) {
    isSearching = true;
    _rebuildVisibleList();
    update();
  }

  /// ---------------- CLEAR ALL ----------------
  void clearAll() {
    isSearching = false;
    filterApplied = false;

    searchController.clear();
    selectedCategory = null;
    selectedSubcategories.clear();
    selectedSort = "Relevance (Default)";

    _rebuildVisibleList();
    update();
  }

  /// ---------------- SORT ----------------
  void sortPosts() {
    _applySort();
    _syncHelpers();
    update();
  }

  void _applySort() {
    if (selectedSort == "Most Liked") {
      showPosts.sort(
        (a, b) => (b['likes'] as int).compareTo(a['likes'] as int),
      );
    } else if (selectedSort == "Recent Uploaded") {
      showPosts.sort(
        (a, b) => (b['uploadDate'] as DateTime)
            .compareTo(a['uploadDate'] as DateTime),
      );
    }
  }

  /// ---------------- FILTER ----------------
  void applyCategorySubcategoryFilter(
    String? category,
    List<String> subcategories,
  ) {
    selectedCategory = category;
    selectedSubcategories = subcategories.toSet();
    filterApplied = true;

    _rebuildVisibleList();
    update();
  }

  void clearAllFilters() {
    selectedCategory = null;
    selectedSubcategories.clear();
    filterApplied = false;

    _rebuildVisibleList();
    update();
  }

  /// ---------------- SORT SHEET ----------------
  void openSortBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _sortTile(
                  title: "Relevance (Default)",
                  value: "Relevance (Default)",
                  // setSheetState: setSheetState,
                  sheetContext: context,
                ),
                _sortTile(
                  title: "Most Liked",
                  value: "Most Liked",
                  // setSheetState: setSheetState,
                  sheetContext: context,
                ),
                _sortTile(
                  title: "Recent Uploaded",
                  value: "Recent Uploaded",
                  // setSheetState: setSheetState,
                  sheetContext: context,
                ),
                const SizedBox(height: 8),
              ],
            );
          },
        );
      },
    );
  }

  Widget _sortTile({
    required String title,
    required String value,
    required BuildContext sheetContext,
  }) {
    return RadioListTile<String>(
      title: Text(
        title,
        style: TextStyle(
          fontSize: kText.scale(14),
          fontWeight: FontWeight.w500,
        ),
      ),
      value: value,
      groupValue: selectedSort,
      activeColor: linearColor,
      onChanged: (val) async {
        if (val == null || val == selectedSort) return;

        // ✅ 1. Close sheet first (VERY IMPORTANT)
        Navigator.pop(sheetContext);

        // ✅ 2. Show loader in main UI
        isLoading = true;
        update();

        // ✅ 3. Let UI paint loader
        await Future.delayed(const Duration(milliseconds: 80));

        // ✅ 4. Update state
        selectedSort = val;

        // ✅ 5. FULL rebuild (safe)
        _rebuildVisibleList();

        // ✅ 6. Hide loader
        isLoading = false;
        update();
      },
    );
  }

  /// ---------------- FILTER SHEET ----------------
  void openFilterBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) {
        final categories =
            posts.map((p) => p['category'] as String).toSet().toList();

        final subcategories = selectedCategory == null
            ? <String>[]
            : posts
                .where((p) => p['category'] == selectedCategory)
                .map((p) => p['subcategory'] as String)
                .toSet()
                .toList();

        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Category"),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: categories.map((c) {
                  return ChoiceChip(
                    label: Text(c),
                    selected: selectedCategory == c,
                    selectedColor: linearColor,
                    onSelected: (_) {
                      selectedCategory = c;
                      selectedSubcategories.clear();
                      update();
                    },
                  );
                }).toList(),
              ),
              if (selectedCategory != null) ...[
                const SizedBox(height: 20),
                const Text("Subcategory"),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  children: subcategories.map((s) {
                    return FilterChip(
                      label: Text(s),
                      selected: selectedSubcategories.contains(s),
                      selectedColor: linearColor,
                      onSelected: (_) {
                        selectedSubcategories.contains(s)
                            ? selectedSubcategories.remove(s)
                            : selectedSubcategories.add(s);
                        update();
                      },
                    );
                  }).toList(),
                ),
              ],
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        clearAllFilters();
                        Navigator.pop(context);
                      },
                      child: const Text("Clear"),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: linearColor,
                      ),
                      onPressed: () {
                        _rebuildVisibleList();
                        Navigator.pop(context);
                      },
                      child: const Text("Apply"),
                    ),
                  ),
                ],
              )
            ],
          ),
        );
      },
    );
  }

  /// ---------------- LIKE ----------------
  Future<void> toggleLike(Map<dynamic, dynamic> post) async {
    final prefs = await SharedPreferences.getInstance();
    final url = post['videoUrl'];

    if (likedVideoUrls.contains(url)) {
      likedVideoUrls.remove(url);
      post['isLike'] = false;
      post['likes']--;
    } else {
      likedVideoUrls.add(url);
      post['isLike'] = true;
      post['likes']++;
    }

    await prefs.setStringList('likedPosts', likedVideoUrls.toList());
    update();
  }

  Future<void> _loadLikedPosts() async {
    final prefs = await SharedPreferences.getInstance();
    likedVideoUrls.addAll(prefs.getStringList('likedPosts') ?? []);
    for (final p in posts) {
      p['isLike'] = likedVideoUrls.contains(p['videoUrl']);
    }
  }

  /// ---------------- HELPERS ----------------
  void _syncHelpers() {
    _resize<WebViewController?>(webControllers, null);
    _resize<YoutubePlayerController?>(ytControllers, null);
    _resize<bool>(expandedDescriptions, false);
  }

  void _resize<T>(List<T?> list, T? fill) {
    while (list.length < showPosts.length) {
      list.add(fill);
    }

    if (list.length > showPosts.length) {
      list.removeRange(showPosts.length, list.length);
    }
  }

  DateTime _parseDate(dynamic raw) {
    try {
      if (raw is String) return DateTime.parse(raw);
      if (raw is DateTime) return raw;
    } catch (_) {}
    return DateTime.now();
  }

  /// ---------------- VIDEO ----------------
  String convertToEmbedUrl(String url) {
    final uri = Uri.parse(url);
    if (uri.host.contains("youtu.be")) {
      return "https://www.youtube.com/embed/${uri.pathSegments.first}";
    }
    if (uri.queryParameters.containsKey("v")) {
      return "https://www.youtube.com/embed/${uri.queryParameters['v']}";
    }
    return url;
  }

  String formatTimeAgo(DateTime d) {
    final diff = DateTime.now().difference(d);
    if (diff.inMinutes < 1) return "${diff.inSeconds}s ago";
    if (diff.inHours < 1) return "${diff.inMinutes}m ago";
    if (diff.inDays < 1) return "${diff.inHours}h ago";
    if (diff.inDays < 30) return "${diff.inDays}d ago";
    if (diff.inDays < 365) return "${(diff.inDays / 30).floor()}mo ago";
    return "${(diff.inDays / 365).floor()}y ago";
  }
}
