import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hotelmanagementapp/model/front_office_model.dart';
import 'package:hotelmanagementapp/public/api.dart';

class FrontOfficeResponse {
  Future<List<FrontOfficeDocument>> getFrontOfficeCollection() async {
    try {
      final firestore = FirebaseFirestore.instance;
      final snapshot =
          await firestore.collection(CollectionNames.frontOffice).get();

      List<FrontOfficeDocument> documents = snapshot.docs.map((doc) {
        return FrontOfficeDocument.fromMap(doc.data());
      }).toList();

      documents.sort((a, b) => a.order.compareTo(b.order));

      return documents;
    } catch (e) {
      print('Error fetching FrontOfficeCollection: $e');
      return [];
    }
  }
}
