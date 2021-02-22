import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:green_grocery_admin/core/models/wallet.dart';

final refundRequestsStreamProvider = StreamProvider<List<Wallet>>(
  (ref) {
    FirebaseFirestore _firestore = FirebaseFirestore.instance;
    return _firestore
        .collection('wallets')
        .where("refundRequested", isEqualTo: true)
        .snapshots()
        .map(
            (event) => event.docs.map((e) => Wallet.fromFirestore(e)).toList());
  },
);
