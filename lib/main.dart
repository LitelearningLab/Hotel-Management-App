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

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // uploadBulkData();
  // bulkEditDocuments();
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
  // Load JSON from assets
  String jsonString =
      await rootBundle.loadString('assets/front_office_final_upload.json');
  Map<String, dynamic> jsonData = json.decode(jsonString);

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  // Access your specific collection from JSON
  final documents = jsonData['FrontOfficeCollection'];

  if (documents != null && documents is Map<String, dynamic>) {
    for (final docId in documents.keys) {
      final fields = documents[docId];
      await firestore
          .collection("FrontOfficeCollection")
          .doc(docId)
          .set(fields);
    }

    print("✅ Bulk upload completed to 'FrontOfficeCollection'!");
  } else {
    print("⚠️ 'FrontOfficeCollection' not found or invalid in JSON.");
  }
}

Future<void> bulkEditDocuments() async {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  try {
    // Get all documents from the collection
    final querySnapshot =
        await firestore.collection("FrontOfficeCollection").get();

    // Batch write for better performance (limit 500 operations per batch)
    final batch = firestore.batch();
    int batchCounter = 0;

    for (final doc in querySnapshot.docs) {
      // Create a map with the new field(s) you want to add
      final updates = {
        'key': '', // Replace with your field name and value
        // 'anotherField': anotherValue, // Add more fields if needed
        // Optional: add update timestamp
      };

      // Add the update to the batch
      batch.update(doc.reference, updates);
      batchCounter++;

      // Commit batch if we reach the limit (500 operations)
      if (batchCounter % 500 == 0) {
        await batch.commit();
        print('✅ Updated $batchCounter documents');
        // Start a new batch
        batchCounter = 0;
      }
    }

    // Commit any remaining operations
    if (batchCounter > 0) {
      await batch.commit();
      print('✅ Updated $batchCounter documents');
    }

    print(
        '🎉 Bulk edit completed! Total documents updated: ${querySnapshot.size}');
  } catch (e) {
    print('⚠️ Error during bulk edit: $e');
  }
}
