import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/product.dart';

class Parameters extends Equatable {
  const Parameters(this.category, this.limit);

  final String category;
  final int limit;
  @override
  List<Object> get props => [category, limit];
}

final productListStreamProvider =
    StreamProvider.family<List<Product>,Parameters>((ref, parameters) {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  return _firestore
      .collection('products')
      .where("category", isEqualTo: parameters.category)
      .limit(parameters.limit)
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
