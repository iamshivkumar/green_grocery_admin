import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../core/models/order.dart';


final mapViewModelProvider = ChangeNotifierProvider<MapViewModel>(
  (ref) => MapViewModel(),
);


class MapViewModel extends ChangeNotifier {

  Order? _order;

  Order? get order => _order;

  set order(Order? order) {
    _order = order;
    notifyListeners();
  }



  bool _loading = false;
  bool get loading => _loading;

  MapType _mapType = MapType.normal;
  MapType get mapType => _mapType;

  CameraPosition _position = CameraPosition(
    target: LatLng(19.084383799507364, 72.88087688252803),
    zoom: 13,
  );
  CameraPosition get position => _position;

  void toggleMapType() {
    _mapType == MapType.normal
        ? _mapType = MapType.hybrid
        : _mapType = MapType.normal;
    notifyListeners();
  }


}
