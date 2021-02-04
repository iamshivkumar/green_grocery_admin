import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:green_grocery_admin/core/models/deliveryBoy.dart';

class OrdersViewModel extends ChangeNotifier {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String deliveryDay;
  String deliveryBy;
  DeliveryBoy deliveryBoy;
  void setDeliveryDay(String value) {
    deliveryDay = value;
    notifyListeners();
  }

  void setDeliveryBy(String value) {
    deliveryBy = value;
    notifyListeners();
  }

  void setAsPacked(String id) {
    _firestore.collection("orders").doc(id).update({"status": "Packed"});
  }

  void setDeliveryBoy(DeliveryBoy value) {
    deliveryBoy = value;
    notifyListeners();
  }

  void setAsOutForDelivery(
      {String id}) {
    _firestore.collection("orders").doc(id).update({
      "status": "Out For Delivery",
      "deliveryBoy": deliveryBoy.name,
      "deliveryBoyId": deliveryBoy.id,
    });
  }
}
