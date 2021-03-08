import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
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
    try {
      _firestore.collection("orders").doc(id).update({"status": "Packed"});
    } catch (e) {}
  }

  void setDeliveryBoy(DeliveryBoy value) {
    deliveryBoy = value;
    notifyListeners();
  }

  void setAsOutForDelivery({String id}) {
    try {
      _firestore.collection("orders").doc(id).update({
        "status": "Out For Delivery",
        "deliveryBoy": deliveryBoy.name,
        "deliveryBoyMobile": deliveryBoy.mobile,
      });
    } catch (e) {}
  }

  bool mapMode = false;
  void setMapMode(bool value) {
    mapMode = value;
    notifyListeners();
  }
}
