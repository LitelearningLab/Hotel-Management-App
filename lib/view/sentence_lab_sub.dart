import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hotelmanagementapp/controller/sentence_lab_sub_controller.dart';
import 'package:hotelmanagementapp/model/sentence_model.dart';
import 'package:hotelmanagementapp/public/common_function.dart';
import 'package:hotelmanagementapp/public/keys.dart';
import 'package:hotelmanagementapp/route/route_name.dart';
import 'package:hotelmanagementapp/utility/custome_bottom_navigation.dart';

class SentenceLabSub extends StatefulWidget {
  const SentenceLabSub({super.key});

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
    // final sortedSubcategories = [...widget.subcategories]
    //   ..sort((a, b) => a.order.compareTo(b.order));
    return PopScope(
      onPopInvoked: (didPop) {},
      child: GetBuilder<SentenceLabSubController>(builder: (controller) {
        return Scaffold(
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
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
              controller.title, maxLines: 2,
              // textAlign: TextAlign.start,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            leading: IconButton(
              onPressed: () {
                if (kIsWeb) {
                  final box = GetStorage();
                  final saved = box.read(AppRoutes.sentenceLab) ?? {};
                  Get.rootDelegate.offNamed(
                    AppRoutes.sentenceLab,
                    arguments: {
                      "title": saved['title'] ?? "",
                    },
                  );
                  debugPrint("Back button pressed - Web");
                } else {
                  Navigator.pop(context);
                }
              },
              icon: const Icon(Icons.arrow_back),
            ),
          ),
          body: ListView.builder(
            padding: EdgeInsets.symmetric(
                vertical: getWidgetHeight(height: 10),
                horizontal: getWidgetWidth(width: 10)),
            itemCount: controller.sortedSubcategories.length,
            itemBuilder: (context, index) {
              log("here im printing which order this are showing ${controller.sortedSubcategories[index].order}");
              return Padding(
                padding: EdgeInsets.only(
                    bottom: index == controller.sortedSubcategories.length - 1
                        ? getWidgetHeight(height: 80)
                        : 0),
                child: GestureDetector(
                  onTap: () {
                    sessionName =
                        controller.sortedSubcategories[index].categoryName;
                    log(sessionName);
                    addToRecentHistory(
                        path:
                            "Language Lab > Sentence Lab > ${controller.title}",
                        category:
                            controller.sortedSubcategories[index].categoryName,
                        section: "Sentence Lab",
                        link: "",
                        proLabTitle: "",
                        subCategories: controller
                            .sortedSubcategories[index].subCategories);
                    GetStorage().write(AppRoutes.sentenceLabSubCat, {
                      "title":
                          controller.sortedSubcategories[index].categoryName,
                      "CategoryModel":
                          controller.sortedSubcategories[index].subCategories
                    });
                    kIsWeb
                        ? Get.rootDelegate
                            .offNamed(AppRoutes.sentenceLabSubCat, arguments: {
                            "title": controller
                                .sortedSubcategories[index].categoryName,
                            "CategoryModel": controller
                                .sortedSubcategories[index].subCategories
                          })
                        : Get.toNamed(AppRoutes.sentenceLabSubCat, arguments: {
                            "title": controller
                                .sortedSubcategories[index].categoryName,
                            "CategoryModel": controller
                                .sortedSubcategories[index].subCategories
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
                            vertical: displayWidth(context) > 500
                                ? displayWidth(context) * 0.01
                                : getWidgetHeight(height: 15),
                            horizontal: displayWidth(context) > 500
                                ? displayWidth(context) * 0.008
                                : getWidgetWidth(width: 10)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                  controller
                                      .sortedSubcategories[index].categoryName,
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
        );
      }),
    );
  }
}
