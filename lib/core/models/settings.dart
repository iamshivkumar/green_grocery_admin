import 'package:cloud_firestore/cloud_firestore.dart';

class StoreSettings {
  double serviceTaxPercentage;
  double deliveryCharge;
  final DocumentReference ref;
  StoreSettings(
      {required this.deliveryCharge,
      required this.serviceTaxPercentage,
      required this.ref});

  factory StoreSettings.fromFirestore(DocumentSnapshot doc) {
    var data = doc.data() as Map;
    return StoreSettings(
      deliveryCharge: data["delivery"],
      serviceTaxPercentage: data["tax%"],
      ref: doc.reference,
    );
  }




  void save() {
    ref.update({
      "delivery": deliveryCharge,
      "tax%": serviceTaxPercentage,
    });
  }
}
