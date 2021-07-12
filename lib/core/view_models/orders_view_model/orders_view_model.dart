import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../enums/delivery_by.dart';

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
