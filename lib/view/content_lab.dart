import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_launcher_icons/xml_templates.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:hotelmanagementapp/controller/content_lab_controller.dart';
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
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ContentLabController>(builder: (controller) {
      return Scaffold(
        bottomNavigationBar: CustomeBottomNavigation(),
        backgroundColor: Colors.white,
        // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        // floatingActionButton: Align(
        //   alignment: Alignment.bottomCenter,
        //   child: CustomeBottomNavigation(),
        // ),
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
                vertical: getWidgetHeight(height: 6),
              ),
              child: Row(
                children: controller.isSearching
                    ? [
                        Expanded(
                          child: Material(
                            elevation: 4,
                            shadowColor: Colors.black,
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.white,
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: getWidgetWidth(width: 12),
                                vertical: getWidgetHeight(height: 0),
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: TextField(
                                      controller: controller.searchController,
                                      decoration: const InputDecoration(
                                        border: InputBorder.none,
                                        hintText: "Search...",
                                      ),
                                      onSubmitted: (value) {
                                        controller.showPosts = [];
                                        controller.showPosts =
                                            controller.searchPosts(value);
                                        controller.isSearching = false;
                                        controller.update();
                                      },
                                      onChanged: (value) {
                                        // Call your controller's search method
                                        // widget.controller.search(value);
                                      },
                                    ),
                                  ),
                                  IconButton(
                                      icon: const Icon(Icons.close,
                                          color: Colors.black),
                                      onPressed: () {
                                        controller.isSearching = false;
                                        controller.searchController.clear();
                                        controller.clearAllFilters();
                                        controller.selectedSort =
                                            "Relevance (Default)";
                                        controller.sortPosts();
                                        controller.update();
                                      }),
                                ],
                              ),
                            ),
                          ),
                        )
                      ]
                    : [
                        // Sort Button
                        Expanded(
                          child: Material(
                            elevation: 4,
                            shadowColor: Colors.black,
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.white,
                            child: InkWell(
                              onTap: () {
                                controller.openSortBottomSheet(context);
                              },
                              borderRadius: BorderRadius.circular(8),
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                  vertical: getWidgetHeight(height: 10),
                                ),
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

                        // Filter Button
                        Expanded(
                          child: Material(
                            elevation: 4,
                            shadowColor: Colors.black,
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.white,
                            child: InkWell(
                              onTap: () {
                                controller.openFilterBottomSheet(context);
                              },
                              borderRadius: BorderRadius.circular(8),
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                  vertical: getWidgetHeight(height: 10),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(Icons.filter_list,
                                        color: Colors.black),
                                    SizedBox(width: getWidgetWidth(width: 8)),
                                    const Text("Filter",
                                        style: TextStyle(color: Colors.black)),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),

                        SizedBox(width: getWidgetWidth(width: 12)),

                        // Search Button
                        Expanded(
                          child: Material(
                            elevation: 4,
                            shadowColor: Colors.black,
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.white,
                            child: InkWell(
                              onTap: () {
                                controller.isSearching = true;
                                controller.update();
                              },
                              borderRadius: BorderRadius.circular(8),
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                  vertical: getWidgetHeight(height: 10),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(Icons.search,
                                        color: Colors.black),
                                    SizedBox(width: getWidgetWidth(width: 8)),
                                    const Text("Search",
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
            if (controller.searchController.text.isNotEmpty)
              Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: getWidgetWidth(width: 12)),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Search Results for: ${controller.searchController.text}",
                    style: TextStyle(
                      fontSize: kText.scale(13),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),

            controller.isloading
                ? SizedBox(
                    height: getWidgetHeight(height: 550),
                    child: Center(
                      child: CircularProgressIndicator(
                        color: linearColor,
                      ),
                    ),
                  )
                : controller.showPosts.isEmpty
                    ? SizedBox(
                        height: getWidgetHeight(height: 550),
                        child: Center(
                          child: Text(
                            "No content found",
                            style: TextStyle(
                              fontSize: kText.scale(16),
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      )
                    : Expanded(
                        child: ListView.builder(
                          itemCount: controller.showPosts.length,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 10),
                          itemBuilder: (context, index) {
                            final post = controller.showPosts[index];
                            final ctr = controller.controllers[index];
                            final isExpanded =
                                controller.expandedDescriptions[index];
                            final description = post["description"] as String;
                            final isLongDesc =
                                description.trim().split('\n').length > 2 ||
                                    description.length > 100;
                            String externalSource =
                                post["externalSource"] ?? "";

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
                                      child: WebViewWidget(controller: ctr),
                                    ),
                                  ),
                                  SizedBox(
                                    height: getWidgetHeight(height: 4),
                                  ),
                                  if (externalSource.isNotEmpty)
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          child: RichText(
                                            softWrap: true,
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            text: TextSpan(
                                              style: TextStyle(
                                                fontSize: kText.scale(10),
                                                color: Colors.grey,
                                              ),
                                              children: [
                                                TextSpan(
                                                  text: "External Source",
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: kText.scale(12),
                                                    color: Colors.grey[700],
                                                  ),
                                                ),
                                                TextSpan(
                                                  text: " : ",
                                                  style: TextStyle(
                                                    fontSize: kText.scale(10),
                                                    color: Colors.black,
                                                  ),
                                                ),
                                                TextSpan(
                                                  text:
                                                      post["externalSource"] ??
                                                          '',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w500,
                                                    color: Colors.black,
                                                    fontSize: kText.scale(12),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  SizedBox(
                                    height: getWidgetHeight(height: 4),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          RichText(
                                            text: TextSpan(
                                              style: TextStyle(
                                                fontSize: kText.scale(10),
                                                color: Colors.grey,
                                              ),
                                              children: [
                                                TextSpan(
                                                    text: post["category"] ??
                                                        "Content Title"),
                                                TextSpan(
                                                    text: " | ",
                                                    style: TextStyle(
                                                        fontSize:
                                                            kText.scale(10),
                                                        color: Colors.black)),
                                                TextSpan(
                                                  text: post["subcategory"] ??
                                                      "Content Title",
                                                  style: TextStyle(
                                                    fontSize: kText.scale(10),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: getWidgetHeight(height: 4)),
                                  description.isEmpty
                                      ? const SizedBox.shrink()
                                      : RichText(
                                          text: TextSpan(
                                            style: TextStyle(
                                                fontSize: kText.scale(12),
                                                color: Colors.black),
                                            children: [
                                              TextSpan(
                                                text: isExpanded || !isLongDesc
                                                    ? description
                                                    : controller.truncateText(
                                                        description,
                                                        100), // Adjust char count as needed
                                              ),
                                              if (!isExpanded && isLongDesc)
                                                TextSpan(
                                                  text: " See more",
                                                  style: TextStyle(
                                                      color: Colors.grey,
                                                      fontSize:
                                                          kText.scale(11)),
                                                  recognizer:
                                                      TapGestureRecognizer()
                                                        ..onTap = () {
                                                          controller
                                                                  .expandedDescriptions[
                                                              index] = true;
                                                          controller.update();
                                                        },
                                                ),
                                              if (isExpanded && isLongDesc)
                                                TextSpan(
                                                  text: " See less",
                                                  style: TextStyle(
                                                      color: Colors.grey,
                                                      fontSize:
                                                          kText.scale(11)),
                                                  recognizer:
                                                      TapGestureRecognizer()
                                                        ..onTap = () {
                                                          controller
                                                                  .expandedDescriptions[
                                                              index] = false;
                                                          controller.update();
                                                        },
                                                ),
                                            ],
                                          ),
                                        ),
                                  SizedBox(height: getWidgetHeight(height: 6)),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          controller.toggleLike(post);
                                        },
                                        child: Row(
                                          children: [
                                            Icon(Icons.thumb_up,
                                                size: 16,
                                                color: post['isLike']
                                                    ? linearColor
                                                    : Colors.grey),
                                            const SizedBox(width: 4),
                                            Text(
                                              "${post["likes"]}",
                                              style: TextStyle(
                                                  color: post['isLike']
                                                      ? linearColor
                                                      : Colors.grey),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            controller.formatTimeAgo(
                                                post["uploadDate"]),
                                            style: const TextStyle(
                                                fontSize: 12,
                                                color: Colors.grey),
                                          ),
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
          ],
        ),
      );
    });
  }
}
