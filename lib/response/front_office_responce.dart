import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:hotelmanagementapp/model/front_office_model.dart';
import 'package:hotelmanagementapp/public/api.dart';

class FrontOfficeResponse {
  Future<List<FrontOfficeDocument>> getFrontOfficeCollection(
      String collectionName) async {
    try {
      final firestore = FirebaseFirestore.instance;
      final snapshot = await firestore.collection(collectionName).get();

      List<FrontOfficeDocument> documents = snapshot.docs.map((doc) {
        return FrontOfficeDocument.fromMap(doc.data());
      }).toList();

      documents.sort((a, b) => a.order.compareTo(b.order));
      log(documents.length);

      return documents;
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching FrontOfficeCollection: $e');
      }
      return [];
    }
  }
}
