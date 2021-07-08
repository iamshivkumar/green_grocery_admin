import 'package:cloud_firestore/cloud_firestore.dart';

import '../enums/delivery_by.dart';
import '../enums/order_status.dart';
import 'order_product.dart';

class Order {
  final String id;

  final String customerId;
  final String customerName;
  final String customerMobile;

  final double deliveryCharge;
  final double price;
  final double walletAmount;
  final double total;

  final List<OrderProduct> products;
  final int items;

  final String code;
  final GeoPoint location;
  final DateTime deliveryDate;
  final DeliveyBy deliveryBy;
  final OrderStatus status;
  final String? deliveryBoyMobile;

  final String paymentMethod;
  final bool paid;

  final DateTime createdOn;

  Order({
    required this.id,
    required this.customerName,
    required this.customerMobile,
    required this.deliveryCharge,
    required this.price,
    required this.total,
    required this.products,
    required this.items,
    required this.code,
    required this.location,
    required this.deliveryDate,
    required this.deliveryBy,
    required this.status,
    this.deliveryBoyMobile,
    required this.walletAmount,
    required this.paymentMethod,
    required this.paid,
    required this.createdOn,
    required this.customerId,
  });

  factory Order.fromFirestore({required DocumentSnapshot doc}) {
    final Map<dynamic, dynamic> data = doc.data() as Map;
    final Iterable productsData = data['products'];
    final Timestamp deliveryDateData = data['delivery_date'];
    final Timestamp createdOnData = data['created_on'];
    return Order(
        code: data['code'],
        createdOn: createdOnData.toDate(),
        customerId: data['customer_id'],
        customerMobile: data['customer_mobile'],
        customerName: data['customer_name'],
        deliveryBy: getDeliveyBy(data['delivery_by']),
        deliveryDate: deliveryDateData.toDate(),
        deliveryBoyMobile: data['delivery_boy_mobile'],
        deliveryCharge: data['delivery_charge'],
        id: doc.id,
        location: data['location'],
        paid: data['paid'],
        paymentMethod: data['payment_method'],
        price: data['price'],
        products: productsData.map((e) => OrderProduct.fromMap(e)).toList(),
        status: getStatus(data['status']),
        walletAmount: data['wallet_amount'],
        items: data['items'],
        total: data['total']);
  }
}
