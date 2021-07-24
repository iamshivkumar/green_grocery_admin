import 'package:cloud_firestore/cloud_firestore.dart';
import '../../utils/utils.dart';

class Product {
  final String id;
  String name;
  String category;
  int quantity;
  String description;
  List<String> images;
  bool popular;
  String amount;
  double price;
  bool active;
  String unit;

  Product(
      {required this.description,
      required this.id,
      required this.images,
      required this.name,
      required this.quantity,
      required this.popular,
      required this.category,
      required this.amount,
      required this.price,
      required this.active,
      required this.unit});

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
      active: data['active'],
      unit: data['unit'],
    );
  }

  factory Product.empty() => Product(
        description: '',
        id: '',
        images: [],
        name: '',
        quantity: 0,
        popular: false,
        category: Utils.writeCategories.first,
        amount: '',
        price: 0,
        active: true,
        unit: Utils.units.first,
      );

  Map<String, dynamic> toMap({bool forUpdate = false, required List<String> searckKeys}) {
    var map = {
      "name": name,
      "description": description,
      "quantity": quantity,
      "images": images,
      "category": category,
      "popular": popular,
      "amount": amount,
      'price': price,
      'active': active,
      'unit': unit,
      'keys':searckKeys,
    };
    if (forUpdate) {
      map = {
        ...map,
        "updated_on": Timestamp.now(),
      };
    } else {
      map = {
        ...map,
        "created_on": Timestamp.now(),
      };
    }
    return map;
  }
}
