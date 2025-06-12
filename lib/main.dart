import 'dart:convert';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:hotelmanagementapp/firebase_options.dart';
import 'package:hotelmanagementapp/public/common_function.dart';
import 'package:hotelmanagementapp/route/binding.dart';
import 'package:hotelmanagementapp/route/route_name.dart';
import 'package:hotelmanagementapp/route/route_service.dart';
import 'package:hotelmanagementapp/view/home.dart';
import 'package:hotelmanagementapp/view/login.dart';
import 'package:hotelmanagementapp/view/splash.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // debugPrint = (String? message, {int? wrapWidth}) {
  //   if (message != null) print(message);
  // };
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
    kText = MediaQuery.of(context).textScaler;
    return GetMaterialApp(
      getPages: RouteService.getPages,
      initialBinding: InitialBinding(),
      title: 'Hotel Management App',
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        primaryColor: Colors.white,
        colorScheme: ColorScheme.fromSwatch().copyWith(primary: Colors.white),
      ),
      home: SplashScreen(),
      // Remove the builder as it's not needed - GetMaterialApp already provides the MaterialApp functionality
    );
  }
}

Future<void> uploadBulkData() async {
  // Load JSON from assets
  String jsonString =
      await rootBundle.loadString('assets/front_office_bulk_upload.json');
  Map<String, dynamic> jsonData = json.decode(jsonString);

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  // Access your specific collection from JSON
  final documents = jsonData['GrammerLabCollection'];

  if (documents != null && documents is Map<String, dynamic>) {
    for (final docId in documents.keys) {
      final fields = documents[docId];
      await firestore.collection("GrammerLabCollection").doc(docId).set(fields);
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
        'key': '',
        'id': doc.id,
        'subcategory': [
          {
            "name": "E-Learning",
            "link":
                "https://new-acc-space-2807.ispring.com/app/preview/6040e2c0-117d-11ef-ba88-8a12e27a05a8"
          },
          {
            "name": "Glossary",
            "link":
                "https://firebasestorage.googleapis.com/v0/b/lite-learning-lab.appspot.com/o/Profluent%20English%2FSounds%20Animation%2FVowels%2FLong%20vowels%2FLong%20vowel%20u%20or%20u%3A%2FVowels%20u%CB%90%20Monophthongs.mp4?alt=media&token=a2321bb2-8bca-48f9-b831-680c4c1f0c2a"
          },
          {
            "name": "Knowledge check",
            "link":
                "https://new-acc-space-2807.ispring.com/app/preview/b744c324-1288-11ee-9bc6-dec30c56cf91"
          }
        ],
        // Optionally add more fields like a timestamp here
        // 'updatedAt': FieldValue.serverTimestamp(),
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

class FirebaseUploader {
  final DatabaseReference _databaseRef;

  FirebaseUploader() : _databaseRef = FirebaseDatabase.instance.ref();

  // Method to upload JSON data to a specific path
  Future<void> uploadJsonData(String jsonPath, String firebasePath) async {
    try {
      // Load the JSON file from assets
      final String jsonString = await rootBundle.loadString(jsonPath);
      final dynamic jsonData = json.decode(jsonString);

      // Upload to Firebase
      await _databaseRef.child(firebasePath).set(jsonData);

      log('Bulk upload completed successfully!');
    } catch (e) {
      log('Error during bulk upload: $e');
      rethrow;
    }
  }

  // Alternative method for large datasets (uploads in chunks)
  Future<void> uploadLargeJsonData(String jsonPath, String firebasePath) async {
    try {
      final String jsonString = await rootBundle.loadString(jsonPath);
      final dynamic jsonData = json.decode(jsonString);

      if (jsonData is Map) {
        // For JSON objects (Map)
        for (final key in jsonData.keys) {
          await _databaseRef.child('$firebasePath/$key').set(jsonData[key]);
        }
      } else if (jsonData is List) {
        // For JSON arrays (List)
        for (int i = 0; i < jsonData.length; i++) {
          await _databaseRef.child('$firebasePath/$i').set(jsonData[i]);
        }
      }

      print('Bulk upload completed successfully!');
    } catch (e) {
      print('Error during bulk upload: $e');
      rethrow;
    }
  }
}
