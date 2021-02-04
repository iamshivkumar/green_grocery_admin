import 'package:cloud_firestore/cloud_firestore.dart';

class Area {
  String name;
  String id;
  List<dynamic> points;
  Area({this.name, this.points, this.id});

  factory Area.fromFirestore(DocumentSnapshot doc) {
    var data = doc.data();
    return Area(id: doc.id, name: data["name"], points: data["points"]);
  }
}
