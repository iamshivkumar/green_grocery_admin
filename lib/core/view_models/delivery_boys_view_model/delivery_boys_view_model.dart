import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../models/deliveryBoy.dart';

final deliveryBoyViewModelProvider = Provider((ref) => DeliveryBoyViewModel());

class DeliveryBoyViewModel {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  DeliveryBoy deliveryBoy = DeliveryBoy();

  void deleteDeliveryBoy(String id) {
    _firestore.collection('deliveryBoys').doc(id).delete();
  }

  void addEditDeliveryBoy() {
    if (deliveryBoy.id != null) {
      _firestore
          .collection('deliveryBoys')
          .doc(deliveryBoy.id)
          .update(deliveryBoy.toMap());
    } else {
      _firestore.collection('deliveryBoys').add(
            deliveryBoy.toMap(),
          );
    }
  }

  void clear() {
    deliveryBoy = DeliveryBoy();
  }
}
