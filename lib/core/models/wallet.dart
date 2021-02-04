import 'package:cloud_firestore/cloud_firestore.dart';

class Wallet {
  final double amount;
  final String id;
  final List<dynamic> paymentIds;
  final String name;
  Wallet({this.amount, this.name, this.paymentIds,this.id});

  factory Wallet.fromFirestore(DocumentSnapshot doc) {
    var data = doc.data();
    return Wallet(
      amount: data["amount"],
      name: data["name"],
      paymentIds: data["paymentIDs"],
      id: doc.id
    );
  }
}
