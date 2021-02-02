import 'package:cloud_firestore/cloud_firestore.dart';

class DeliveryBoy {
  String name;
  String mobile;
  String id;
  DeliveryBoy({this.name, this.mobile, this.id});
  factory DeliveryBoy.fromFirestore(DocumentSnapshot doc) {
    var data = doc.data();
    return DeliveryBoy(
      id: doc.id,
      mobile: data["mobile"],
      name: data['name'],
    );
  }
}
