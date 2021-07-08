import 'product.dart';

class OrderProduct {
  final String id;
  final String name;
  final String image;
  final double price;
  final String amount;
  final int qt;

  OrderProduct({
    required this.id,
    required this.qt,
    required this.image,
    required this.name,
    required this.price,
    required this.amount,
  });

  factory OrderProduct.fromProduct(
      {required Product product, required int quantity}) {
    return OrderProduct(
      amount: product.amount,
      id: product.id,
      image: product.images.first,
      name: product.name,
      price: product.price,
      qt: quantity,
    );
  }

  factory OrderProduct.fromMap(Map<String, dynamic> data) {
    return OrderProduct(
      amount: data['amount'],
      id: data['id'],
      image: data['image'],
      name: data['name'],
      price: data['price'],
      qt: data['qt'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'qt': qt,
      'image': image,
      'name': name,
      'price': price,
      'amount': amount,
    };
  }
}
