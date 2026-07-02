import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hotelmanagementapp/controller/university_lab_sub_controller.dart';
import 'package:hotelmanagementapp/public/common_function.dart';
import 'package:hotelmanagementapp/public/keys.dart';
import 'package:hotelmanagementapp/route/route_name.dart';
import 'package:hotelmanagementapp/utility/web_view_page.dart';

class UniversityLabSub extends StatefulWidget {
  const UniversityLabSub({super.key});
  @override
  State<UniversityLabSub> createState() => _UniversityLabSubState();
}

class _UniversityLabSubState extends State<UniversityLabSub> {
  @override
  Widget build(BuildContext context) {
    double isKwidth = MediaQuery.of(context).size.width;
    return GetBuilder<UniversityLabSubController>(builder: (controller) {
      return Scaffold(
        appBar: AppBar(
            forceMaterialTransparency: true,
            backgroundColor: Colors.white,
            titleSpacing: 0,
            leading: IconButton(
              onPressed: () {
                if (kIsWeb) {
                  final box = GetStorage();
                  final saved = box.read(AppRoutes.universityLab) ?? {};
                  Get.rootDelegate.offNamed(
                    AppRoutes.universityLab,
                    arguments: saved,
                  );
                } else {
                  Navigator.pop(context);
                }
              },
              icon: const Icon(Icons.arrow_back, color: Colors.black),
            ),
            title: Text(
              controller.category.name,
              textAlign: TextAlign.left,
              style: TextStyle(
                fontFamily: Keys.fontFamily,
                fontWeight: FontWeight.w600,
                fontSize: kText.scale(isKwidth > 700 ? 25 : 20),
                color: Colors.black,
              ),
            )),
        body: Padding(
          padding: EdgeInsets.symmetric(
              vertical: getWidgetHeight(height: 0),
              horizontal: getWidgetWidth(width: 10)),
          child: controller.category.subcategory.isEmpty
              ? const Center(child: Text("No data found"))
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  itemCount: controller.category.subcategory.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        final sub = controller.category.subcategory[index];
                        if (sub.link.isNotEmpty) {
                          mainCategoryTitle = controller.collegeName.isNotEmpty
                              ? controller.collegeName
                              : "university lab";
                          subCategoryTitle = controller.category.name;
                          activityName = "university lab";
                          timestampIndex = 8;
                          sessionName = sub.text;

                          if (kIsWeb) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => WebContentPage(
                                    title: sub.text, url: sub.link),
                              ),
                            );
                          } else {
                            Get.toNamed(
                              AppRoutes.inAppWebView,
                              arguments: {
                                "url": sub.link,
                              },
                            );
                          }
                        }
                      },
                      child: Container(
                        width: getWidgetWidth(width: 375),
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
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: Colors.white,
                          ),
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: getWidgetHeight(height: 15),
                                horizontal:
                                    getWidgetWidth(width: kIsWeb ? 0 : 10)),
                            child: Row(
                              children: [
                                SizedBox(
                                  width: getWidgetWidth(width: kIsWeb ? 5 : 10),
                                ),
                                Expanded(
                                  child: Text(
                                    controller.category.subcategory[index].text,
                                    style: TextStyle(
                                      fontFamily: Keys.fontFamily,
                                      fontWeight: FontWeight.w500,
                                      fontSize:
                                          kText.scale(isKwidth > 700 ? 16 : 14),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
        ),
      );
    });
  }
}
