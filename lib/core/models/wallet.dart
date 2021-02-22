import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:green_grocery_admin/core/models/payment.dart';

class Wallet extends Equatable {
  final double amount;
  final String id;
  final List<Payment> payments;
  final String name;
  Wallet({this.amount, this.name, this.payments, this.id});

  factory Wallet.fromFirestore(DocumentSnapshot doc) {
    var data = doc.data();
    Iterable payments = data["payments"];
    return Wallet(
        amount: data["amount"],
        name: data["name"],
        payments: payments.map((e) => Payment.fromMap(e)).toList(),
        id: doc.id);
  }
  @override
  List<Object> get props => [id, amount, payments, name];
}
