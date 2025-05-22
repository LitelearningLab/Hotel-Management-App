import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:hotelmanagementapp/firebase_options.dart';
import 'package:hotelmanagementapp/public/common_function.dart';
import 'package:hotelmanagementapp/route/binding.dart';
import 'package:hotelmanagementapp/route/route_name.dart';
import 'package:hotelmanagementapp/route/route_service.dart';
import 'package:hotelmanagementapp/view/home.dart';
import 'package:uuid/uuid.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  uploadBulkData();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    kHeight = MediaQuery.of(context).size.height;
    kWidth = MediaQuery.of(context).size.width;
    return GetMaterialApp(
      getPages: RouteService.getPages,
      initialBinding: InitialBinding(),
      title: 'Hotel Management App',
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        primaryColor: Colors.white,
        colorScheme: ColorScheme.fromSwatch().copyWith(primary: Colors.white),
      ),
      home: const Home(),
      // Remove the builder as it's not needed - GetMaterialApp already provides the MaterialApp functionality
    );
  }
}

Future<void> uploadBulkData() async {
  Future<void> uploadBulkData() async {
    String jsonString = await rootBundle
        .loadString('assets/front_office_bulk_upload_with_order.json');
    Map<String, dynamic> jsonData = json.decode(jsonString);
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    var uuid = Uuid();

    Map<String, dynamic> collectionData = jsonData["FrontOfficeCollection"];

    for (var entry in collectionData.entries) {
      String docId = uuid.v4(); // Generate unique ID
      await firestore
          .collection("FrontOfficeCollection")
          .doc(docId)
          .set(entry.value);
    }

    print("Bulk upload with unique IDs completed!");
  }
}
