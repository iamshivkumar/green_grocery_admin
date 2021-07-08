import 'package:cloud_firestore/cloud_firestore.dart';

class Product {
  final String id;
  final String name;
  final String category;
  final int quantity;
  final String description;
  final List<String> images;
  final bool popular;
  final String amount;
  final double price;
  final bool active;

  Product({
    required this.description,
    required this.id,
    required this.images,
    required this.name,
    required this.quantity,
    required this.popular,
    required this.category,
    required this.amount,
    required this.price,
    required this.active
  });

  factory Product.fromFirestore({required DocumentSnapshot doc}) {
    Map data = doc.data() as Map;
    return Product(
      id: doc.id,
      name: data['name'],
      description: data['description'],
      quantity: data['quantity'],
      category: data['category'],
      popular: data['popular'],
      images: data['images'].cast<String>(),
      amount: data['amount'],
      price: data['price'],
      active: data['active']
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "name": name,
      "image": images,
      "category": category,
      "id": id,
    };
  }
}
