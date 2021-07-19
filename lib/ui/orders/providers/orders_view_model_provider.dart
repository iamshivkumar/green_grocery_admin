import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../core/enums/delivery_by.dart';

final ordersViewModelProvider = ChangeNotifierProvider<OrdersViewModel>(
  (ref) => OrdersViewModel(),
);


class OrdersViewModel extends ChangeNotifier {

  DeliveyBy? _deliveyBy;
  DeliveyBy? get deliveyBy => _deliveyBy;
  set deliveyBy(DeliveyBy? deliveyBy) {
    _deliveyBy = deliveyBy;
    notifyListeners();
  }

  DateTime? _selectedDate;
  DateTime? get selectedDate => _selectedDate;
  set selectedDate(DateTime? selectedDate) {
    _selectedDate = selectedDate;
    notifyListeners();
  }

  bool mapMode = false;
  void setMapMode(bool value) {
    mapMode = value;
    notifyListeners();
  }



   
}
