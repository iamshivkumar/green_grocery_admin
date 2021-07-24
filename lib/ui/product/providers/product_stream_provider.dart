import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/models/product.dart';

final productProvider = StreamProvider.family<Product, String>(
  (ref, id) {
    FirebaseFirestore _firestore = FirebaseFirestore.instance;
    return _firestore.collection('products').doc(id).snapshots().map(
          (e) => Product.fromFirestore(doc: e),
        );
  },
);
