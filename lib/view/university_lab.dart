import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hotelmanagementapp/controller/university_lab_controller.dart';
import 'package:hotelmanagementapp/public/common_function.dart';
import 'package:hotelmanagementapp/public/keys.dart';
import 'package:hotelmanagementapp/route/route_name.dart';

class UniversityLab extends StatefulWidget {
  const UniversityLab({Key? key}) : super(key: key);

  @override
  State<UniversityLab> createState() => _UniversityLabState();
}

class _UniversityLabState extends State<UniversityLab> {
  @override
  Widget build(BuildContext context) {
    double isKwidth = MediaQuery.of(context).size.width;
    return GetBuilder<UniversityLabController>(builder: (controller) {
      return Scaffold(
        appBar: AppBar(
            forceMaterialTransparency: true,
            backgroundColor: Colors.white,
            titleSpacing: 0,
            leading: IconButton(
              onPressed: () {
                if (kIsWeb) {
                  Get.rootDelegate.offNamed(AppRoutes.home);
                } else {
                  Navigator.pop(context);
                }
              },
              icon: const Icon(Icons.arrow_back, color: Colors.black),
            ),
            title: Text(
              controller.universityModel.collegeName,
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
          child: controller.universityModel.category.isEmpty
              ? const Center(child: Text("No data found"))
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  itemCount: controller.universityModel.category.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        mainCategoryTitle = controller.universityModel.collegeName;
                        GetStorage().write(
                          AppRoutes.universityLabSub,
                          controller.universityModel.category[index].toMap(),
                        );
                        if (kIsWeb) {
                          Get.rootDelegate.offNamed(
                            AppRoutes.universityLabSub,
                            arguments: controller.universityModel.category[index],
                          );
                        } else {
                          Get.toNamed(
                            AppRoutes.universityLabSub,
                            arguments: controller.universityModel.category[index],
                          );
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
                                    controller.universityModel.category[index].name,
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
