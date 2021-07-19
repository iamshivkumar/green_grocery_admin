import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/models/product.dart';



final productsProvider =
    StreamProvider.family<List<Product>,String>((ref, category) {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  return _firestore
      .collection('products')
      .where("category", isEqualTo: category)
      .orderBy('name')
      .snapshots()
      .map(
        (event) => event.docs
            .map(
              (e) => Product.fromFirestore(doc: e),
            )
            .toList(),
      );
});
