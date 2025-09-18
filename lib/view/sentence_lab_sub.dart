import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:hotelmanagementapp/model/sentence_model.dart';
import 'package:hotelmanagementapp/public/common_function.dart';
import 'package:hotelmanagementapp/public/keys.dart';
import 'package:hotelmanagementapp/route/route_name.dart';
import 'package:hotelmanagementapp/utility/custome_bottom_navigation.dart';

class SentenceLabSub extends StatefulWidget {
  final String title;
  final List<CategoryModel> subcategories;
  const SentenceLabSub(
      {required this.title, required this.subcategories, super.key});

  @override
  State<SentenceLabSub> createState() => _SentenceLabSubState();
}

class _SentenceLabSubState extends State<SentenceLabSub> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final sortedSubcategories = [...widget.subcategories]
      ..sort((a, b) => a.order.compareTo(b.order));
    return PopScope(
      onPopInvoked: (didPop) {},
      child: Scaffold(
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
          title: Text(
            widget.title, maxLines: 2,
            // textAlign: TextAlign.start,
            style: const TextStyle(
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
        body: ListView.builder(
          padding: EdgeInsets.symmetric(
              vertical: getWidgetHeight(height: 10),
              horizontal: getWidgetWidth(width: 10)),
          itemCount: sortedSubcategories.length,
          itemBuilder: (context, index) {
            log("here im printing which order this are showing ${sortedSubcategories[index].order}");
            return Padding(
              padding: EdgeInsets.only(
                  bottom: index == sortedSubcategories.length - 1
                      ? getWidgetHeight(height: 80)
                      : 0),
              child: GestureDetector(
                onTap: () {
                  sessionName = sortedSubcategories[index].categoryName;
                  log(sessionName);
                  addToRecentHistory(
                      path: "Language Lab > Sentence Lab > ${widget.title}",
                      category: sortedSubcategories[index].categoryName,
                      section: "Sentence Lab",
                      link: "",
                      proLabTitle: "",
                      subCategories: sortedSubcategories[index].subCategories);
                  Get.toNamed(AppRoutes.sentenceLabSub, arguments: {
                    "title": sortedSubcategories[index].categoryName,
                    "CategoryModel": sortedSubcategories[index].subCategories
                  });
                },
                child: Container(
                  width: getWidgetWidth(width: 375),
                  // height: getWidgetHeight(height: 60),
                  margin: const EdgeInsets.symmetric(vertical: 5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        offset: const Offset(0, 4),
                        blurRadius: 10,
                      ),
                    ],
                  ),
                  child: Container(
                    width: getWidgetWidth(width: 375),
                    // height: getWidgetHeight(height: 75),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.white,
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: getWidgetHeight(height: 16),
                          horizontal: getWidgetWidth(width: 15)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(sortedSubcategories[index].categoryName,
                                // maxLines: 2,
                                style: TextStyle(
                                    fontFamily: Keys.fontFamily,
                                    letterSpacing: 0,
                                    fontSize: 16)),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
