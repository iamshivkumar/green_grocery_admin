import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/product.dart';


final popularProductListStreamProvider = StreamProvider<List<Product>>((ref) {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  return _firestore
      .collection('products')
      .where("popular", isEqualTo: true)
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
