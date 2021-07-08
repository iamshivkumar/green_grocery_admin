import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/deliveryBoy.dart';

final deliveryBoysListProvder = StreamProvider<List<DeliveryBoy>>(
  (ref) {
    FirebaseFirestore _firestore = FirebaseFirestore.instance;
    return _firestore.collection("deliveryBoys").snapshots().map(
          (event) =>
              event.docs.map((e) => DeliveryBoy.fromFirestore(e)).toList(),
        );
  },
);
