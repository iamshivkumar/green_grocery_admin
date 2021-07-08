import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

import 'payment.dart';

class Wallet extends Equatable {
  final double amount;
  final String id;
  final List<Payment> payments;
  final String name;
  Wallet(
      {required this.amount,
      required this.name,
      required this.payments,
      required this.id});

  factory Wallet.fromFirestore(DocumentSnapshot doc) {
    var data = doc.data() as Map;
    Iterable payments = data["payments"];
    return Wallet(
      amount: data["amount"],
      name: data["name"],
      payments: payments.map((e) => Payment.fromMap(e)).toList(),
      id: doc.id,
    );
  }
  @override
  List<Object> get props => [id, amount, payments, name];
}
