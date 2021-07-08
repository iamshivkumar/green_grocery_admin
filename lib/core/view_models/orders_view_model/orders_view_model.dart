import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../enums/delivery_by.dart';

class OrdersViewModel extends ChangeNotifier {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  


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

  void setAsPacked(String id) {
    try {
      _firestore.collection("orders").doc(id).update({"status": "Packed"});
    } catch (e) {}
  }

  bool mapMode = false;
  void setMapMode(bool value) {
    mapMode = value;
    notifyListeners();
  }
}
