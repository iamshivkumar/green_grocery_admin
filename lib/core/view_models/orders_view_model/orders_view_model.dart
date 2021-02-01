import 'package:flutter/foundation.dart';

class OrdersViewModel extends ChangeNotifier {
  String deliveryDay;
  String deliveryBy;

  void setDeliveryDay(String value) {
    deliveryDay = value;
    notifyListeners();
  }
  void setDeliveryBy(String value) {
    deliveryBy = value;
    notifyListeners();
  }
  
}
