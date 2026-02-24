import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hotelmanagementapp/controller/content_lab_controller.dart';
import 'package:hotelmanagementapp/public/common_function.dart';
import 'package:hotelmanagementapp/public/constant.dart';
import 'package:hotelmanagementapp/route/route_name.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class ContentLab extends StatelessWidget {
  const ContentLab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ContentLabController>(
      builder: (controller) {
        final query = controller.searchController.text.trim();

        return Scaffold(
          backgroundColor: const Color(0xFFF7F8FA),

          /// ---------------- HEADER ----------------
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 1,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () {
                stopTimerMainCategory();
                kIsWeb
                    ? Get.rootDelegate.offNamed(AppRoutes.home)
                    : Navigator.pop(context);
              },
            ),
            title: const Text(
              "Content Library",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
            centerTitle: true,
          ),

          /// ---------------- BODY (FULL PAGE SCROLL) ----------------
          body: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1440),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// ---------------- TOOLBAR ----------------
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 16,
                      ),
                      child: Row(
                        children: controller.isSearching
                            ? [
                                Expanded(child: _searchBar(controller)),
                              ]
                            : [
                                _toolbarButton(
                                  icon: Icons.sort,
                                  label: "Sort",
                                  onTap: () => controller
                                      .openSortBottomSheet(context),
                                ),
                                const SizedBox(width: 12),
                                _toolbarButton(
                                  icon: Icons.filter_list,
                                  label: "Filter",
                                  onTap: () => controller
                                      .openFilterBottomSheet(context),
                                ),
                                const SizedBox(width: 12),
                                _toolbarButton(
                                  icon: Icons.search,
                                  label: "Search",
                                  onTap: () {
                                    controller.isSearching = true;
                                    controller.update();
                                  },
                                ),
                              ],
                      ),
                    ),

                    /// ---------------- CONTENT ----------------
                    if (controller.isLoading)
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 120),
                        child: Center(child: CircularProgressIndicator()),
                      )
                    else if (controller.showPosts.isEmpty)
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 120),
                        child: Center(
                          child: Text(
                            "No content found",
                            style: TextStyle(color: Colors.grey),
                          ),
                        ),
                      )
                    else
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Column(
                          children: List.generate(
                            controller.showPosts.length,
                            (index) {
                              final post = controller.showPosts[index];
                              final embedUrl = controller
                                  .convertToEmbedUrl(post["videoUrl"]);

                              return _contentCard(
                                controller: controller,
                                post: post,
                                index: index,
                                embedUrl: embedUrl,
                                query: query,
                              );
                            },
                          ),
                        ),
                      ),

                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}


/// ======================================================
/// SEARCH BAR
/// ======================================================
Widget _searchBar(ContentLabController controller) {
  return Container(
    height: 44,
    padding: const EdgeInsets.symmetric(horizontal: 12),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(8),
      border: Border.all(color: Colors.grey.shade300),
    ),
    child: Row(
      children: [
        const Icon(Icons.search, size: 20),
        const SizedBox(width: 8),
        Expanded(
          child: TextField(
            controller: controller.searchController,
            cursorColor: Colors.black,
            style: const TextStyle(color: Colors.black),
            decoration: const InputDecoration(
              hintText: "Search content...",
              border: InputBorder.none,
            ),
            onChanged: controller.applySearch,
          ),
        ),
        IconButton(
          icon: const Icon(Icons.close, size: 18),
          onPressed: controller.clearAll,
        ),
      ],
    ),
  );
}

/// ======================================================
/// TOOLBAR BUTTON
/// ======================================================
Widget _toolbarButton({
  required IconData icon,
  required String label,
  required VoidCallback onTap,
}) {
  return InkWell(
    borderRadius: BorderRadius.circular(8),
    onTap: onTap,
    child: Container(
      height: 44,
      padding: const EdgeInsets.symmetric(horizontal: 18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        children: [
          Icon(icon, size: 18),
          const SizedBox(width: 8),
          Text(label),
        ],
      ),
    ),
  );
}

/// ======================================================
/// CONTENT CARD
/// ======================================================
Widget _contentCard({
  required ContentLabController controller,
  required Map post,
  required int index,
  required String embedUrl,
  required String query,
}) {
  return Container(
    margin: const EdgeInsets.only(bottom: 20),
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: Colors.grey.shade200),
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// VIDEO
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: SizedBox(
            width: 420,
            height: 240,
            child: _buildVideoPlayer(controller, index, embedUrl),
          ),
        ),
        const SizedBox(width: 20),

        /// DETAILS
        Expanded(
          child: SizedBox(
            height: 240,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                highlightText(
                  post["title"] ?? "",
                  query,
                  maxLines: 2,
                  normalStyle: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                  highlightStyle: TextStyle(
                    color: linearColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  post["externalSource"] ?? "",
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey.shade600,
                  ),
                ),
                const SizedBox(height: 10),
                highlightText(
                  post["description"] ?? "",
                  query,
                  maxLines: 4,
                  normalStyle:
                      const TextStyle(fontSize: 14, color: Colors.black),
                  highlightStyle: TextStyle(
                    color: Colors.amber,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () => controller.toggleLike(post),
                      child: Row(
                        children: [
                          Icon(
                            Icons.thumb_up,
                            size: 18,
                            color:
                                post['isLike'] ? linearColor : Colors.grey,
                          ),
                          const SizedBox(width: 6),
                          Text("${post["likes"]}"),
                        ],
                      ),
                    ),
                    Text(
                      controller.formatTimeAgo(post["uploadDate"]),
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}

/// ======================================================
/// VIDEO PLAYER (SAFE INDEXING)
/// ======================================================
Widget _buildVideoPlayer(
  ContentLabController controller,
  int index,
  String embedUrl,
) {
  // Ensure controller lists are long enough
  if (controller.webControllers.length <= index) {
    controller.webControllers
        .addAll(List.filled(index + 1 - controller.webControllers.length, null));
  }
  if (controller.ytControllers.length <= index) {
    controller.ytControllers
        .addAll(List.filled(index + 1 - controller.ytControllers.length, null));
  }

  if (!kIsWeb) {
    final videoId = YoutubePlayerController.convertUrlToId(embedUrl) ?? "";
    final finalUrl = "https://www.youtube.com/embed/$videoId";

    controller.webControllers[index] ??= WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse(finalUrl));

    return WebViewWidget(controller: controller.webControllers[index]!);
  } else {
    controller.ytControllers[index] ??=
        YoutubePlayerController.fromVideoId(
      videoId: YoutubePlayerController.convertUrlToId(embedUrl) ?? "",
      autoPlay: false,
      params: const YoutubePlayerParams(
        showControls: true,
        showFullscreenButton: true,
        enableKeyboard: true,
        playsInline: true,
      ),
    );

    return YoutubePlayer(
      controller: controller.ytControllers[index]!,
      aspectRatio: 16 / 9,
    );
  }
  
}
Widget highlightText(
  String text,
  String query, {
  TextStyle? normalStyle,
  TextStyle? highlightStyle,
  int maxLines = 4,
}) {
  if (query.isEmpty) {
    return Text(
      text,
      maxLines: maxLines,
      overflow: TextOverflow.ellipsis,
      style: normalStyle,
    );
  }

  final lowerText = text.toLowerCase();
  final lowerQuery = query.toLowerCase();

  final spans = <TextSpan>[];
  int start = 0;

  while (true) {
    final index = lowerText.indexOf(lowerQuery, start);
    if (index < 0) {
      spans.add(TextSpan(text: text.substring(start)));
      break;
    }
    if (index > start) {
      spans.add(TextSpan(text: text.substring(start, index)));
    }
    spans.add(
      TextSpan(
        text: text.substring(index, index + query.length),
        style: highlightStyle,
      ),
    );
    start = index + query.length;
  }

  return RichText(
    maxLines: maxLines,
    overflow: TextOverflow.ellipsis,
    text: TextSpan(style: normalStyle, children: spans),
  );
}
