import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:green_grocery_admin/core/models/area.dart';

class AreasViewModel extends ChangeNotifier {
  GoogleMapController controller;

  void setController(GoogleMapController value) {
    controller = value;
  }

  bool _loading = false;
  bool get loading => _loading;

  MapType _mapType = MapType.normal;
  MapType get mapType => _mapType;

  CameraPosition _position = CameraPosition(
    target: LatLng(17.6599, 75.9064),
    zoom: 13,
  );
  CameraPosition get position => _position;

  void toggleMapType() {
    _mapType == MapType.normal
        ? _mapType = MapType.hybrid
        : _mapType = MapType.normal;
    notifyListeners();
  }

  String _name;
  void setName(String value) {
    _name = value;
  }

  Set<Polygon> get polygons => _latlngList.isNotEmpty
      ? {
          Polygon(
              geodesic: true,
              polygonId: PolygonId("1"),
              points: _latlngList,
              strokeWidth: 2,
              fillColor: Colors.red.withOpacity(0.1))
        }
      : null;

  List<LatLng> _latlngList = [];
  bool get isPointsAdded => _latlngList.isNotEmpty;
  List<Area> areas = [];
  void onCameraMove(CameraPosition position) {
    _position = position;
  }

  void addCoordinate() {
    var latlng = LatLng(_position.target.latitude, _position.target.longitude);
    if (!_latlngList.contains(latlng)) {
      _latlngList.add(latlng);
    }
    notifyListeners();
  }

  void save() {
    areas.add(
      Area(
        name: _name??"New Are",
        points: _latlngList
            .map((e) => {
                  "lat": e.latitude,
                  "long": e.longitude,
                })
            .toList(),
      ),
    );
    _latlngList = [];
    notifyListeners();
  }

  void limitedDispose() {
    _latlngList = [];
  }
}
