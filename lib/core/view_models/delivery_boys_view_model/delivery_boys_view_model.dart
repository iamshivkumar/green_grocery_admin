import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:green_grocery_admin/core/models/deliveryBoy.dart';

class DeliveryBoyViewModel {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String name;
  String mobile;

  DeliveryBoy deliveryBoy;

  void setName(String value) {
    name = value;
  }

  void setMobile(String value) {
    mobile = value;
  }

  void initForEdit(DeliveryBoy value) {
    deliveryBoy = value;
    name = deliveryBoy.name;
    mobile = deliveryBoy.mobile;
  }

  void deleteDeliveryBoy(String id) {
    _firestore.collection('deliveryBoys').doc(id).delete();
  }

  void addEditDeliveryBoy() {
    if (deliveryBoy != null) {
      _firestore
          .collection('deliveryBoys')
          .doc(deliveryBoy.id)
          .update({"name": name, "mobile": mobile});
    } else {
      _firestore
          .collection('deliveryBoys')
          .add({"name": name, "mobile": mobile});
    }
    _dispose();
  }

  void _dispose() {
    deliveryBoy = null;
    name = null;
    mobile = null;
  }
}
