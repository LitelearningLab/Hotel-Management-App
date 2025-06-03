import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hotelmanagementapp/model/user_mode.dart';

abstract class Jsonable {
  // Map<String, dynamic> toJson();

  Map<String, dynamic> toMap();

  factory Jsonable.fromJson(DocumentSnapshot json, Type t) {
    // if (json == null) {
    //   return null;
    // }

    print("json['type']");
    print(json);
    print(t);
    switch (t) {
      case UserM:
        return UserM.fromJson(json);

      default:
        throw ArgumentError('Invalid JSON data');
    }
  }
}
