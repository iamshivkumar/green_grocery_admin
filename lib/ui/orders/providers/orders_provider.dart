import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/models/order.dart';

final ordersProvider = StreamProvider.family<List<Order>, String>(
  (ref, status) {
    FirebaseFirestore _firestore = FirebaseFirestore.instance;
    return _firestore
        .collection('orders')
        .where("status", isEqualTo: status)
        .snapshots()
        .map(
          (event) => event.docs
              .map(
                (e) => Order.fromFirestore(doc: e),
              )
              .toList(),
        );
  },
);
