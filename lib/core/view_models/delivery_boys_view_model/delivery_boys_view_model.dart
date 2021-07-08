import 'package:cloud_firestore/cloud_firestore.dart';

import '../../models/deliveryBoy.dart';

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
}
