import 'package:cloud_firestore/cloud_firestore.dart';

class DeliveryBoy {
  final String name;
  final String mobile;
  final String? id;
  DeliveryBoy({this.name = '', this.mobile = '', this.id});
  factory DeliveryBoy.fromFirestore(DocumentSnapshot doc) {
    var data = doc.data() as Map;
    return DeliveryBoy(
      id: doc.id,
      mobile: data["mobile"],
      name: data['name'],
    );
  }

  Map<String, dynamic> toMap() => {
        'name': name,
        'mobile': mobile,
      };
}
