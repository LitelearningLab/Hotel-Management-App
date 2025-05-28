import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hotelmanagementapp/model/simulation_model.dart';

class SimulationResponse {
  Future<List<SimulationModel>> getSimulationCollection(
      String collectionName) async {
    try {
      final firestore = FirebaseFirestore.instance;
      final snapshot = await firestore.collection(collectionName).get();

      List<SimulationModel> documents = snapshot.docs.map((doc) {
        return SimulationModel.fromJson(doc.data());
      }).toList();

      documents.sort((a, b) => a.order.compareTo(b.order));

      log('Number of simulation documents: ${documents.length}');

      return documents;
    } catch (e) {
      print('Error fetching SimulationCollection: $e');
      return [];
    }
  }
}
