import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final orderViewModelProvider =
    ChangeNotifierProvider.family<OrderViewModel, String>(
        (ref, id) => OrderViewModel(id));

class OrderViewModel extends ChangeNotifier {
  final String id;
  OrderViewModel(this.id);

  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String? _deliveryBoyMobile;
  String? get deliveryBoyMobile => _deliveryBoyMobile;
  set deliveryBoyMobile(String? deliveryBoyMobile) {
    _deliveryBoyMobile = deliveryBoyMobile;
    notifyListeners();
  }

  void setAsPacked() {
    try {
      _firestore.collection("orders").doc(id).update({"status": "Packed"});
    } on FirebaseException catch (e) {
      print(e.code);
    } catch (e) {
      print(e);
    }
  }

  void setAsOutForDelivery({required String id}) {
    try {
      _firestore.collection("orders").doc(id).update({
        "status": "Out For Delivery",
        "delivery_boy_mobile": _deliveryBoyMobile,
      });
    } catch (e) {}
  }
}
