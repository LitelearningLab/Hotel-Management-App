import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:hotelmanagementapp/controller/pronunciation_lab_controller.dart';
// import 'package:hotelmanagementapp/model/english_lab_model';
import 'package:hotelmanagementapp/model/user_mode.dart';
// import 'package:hotelmanagementapp/models/english_lab_category_model.dart';

abstract class Jsonable {
  // Map<String, dynamic> toJson();

  Map<String, dynamic> toMap();

  factory Jsonable.fromJson(DocumentSnapshot json, Type t) {
    // if (json == null) {
    //   return null;
    // }

    if (kDebugMode) {
      print("json['type']");
      print(json);
      print(t);
    }
    switch (t) {
      case UserM:
        return UserM.fromJson(json);

      default:
        throw ArgumentError('Invalid JSON data');
    }
  }
}

// class FirebaseDataService {
//   final DatabaseReference _dbRef = FirebaseDatabase.instance.ref();

//   Future<EnglishLabCategory> fetchEnglishLabData() async {
//     final snapshot = await _dbRef.child('EnglishLabCollection').get();

//     if (!snapshot.exists) {
//       throw Exception("No data found");
//     }

//     final Map<String, dynamic> result = {};

//     for (final child in snapshot.children) {
//       final key = child.key ?? '';
//       final value = child.value;
//       if (value != null && value is Map) {
//         result[key] = Map<String, dynamic>.from(value);
//       }
//     }

//     return EnglishLabModel.fromMap(result);
//   }
// }
