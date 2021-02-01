import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoder/geocoder.dart';
import 'package:green_grocery_admin/core/models/address.dart';
import 'package:location/location.dart';

class AddressViewModel extends ChangeNotifier {
  GoogleMapController controller;

  void setController(GoogleMapController value) {
    controller = value;
  }

  bool _loading = false;
  bool get loading => _loading;

  List<LocationAddress> _locationAddressList = List<LocationAddress>();
  List<LocationAddress> get locationAddressList => _locationAddressList;

  LocationAddress _currentAddress;
  LocationAddress get currentAddress => _currentAddress;

  Future<void> registerLocalDatabase() async {
    saveLocationAddressList([]);
  }

  Future initializeData() async {
    try {
      _locationAddressList = await readLocationAddressList();
    } catch (e) {
      await registerLocalDatabase();
      _locationAddressList = await readLocationAddressList();
    }
    print('done');
    notifyListeners();
  }

  MapType _mapType = MapType.normal;
  MapType get mapType => _mapType;

  CameraPosition _position = CameraPosition(
    target: LatLng(17.6599, 75.9064),
    zoom: 13,
  );
  CameraPosition get position => _position;
  Marker _marker;
  Set<Marker> get markers => _marker != null ? {_marker} : null;
  String addressValue;

  void toggleMapType() {
    _mapType == MapType.normal
        ? _mapType = MapType.hybrid
        : _mapType = MapType.normal;
    notifyListeners();
  }

  void onCameraMove(CameraPosition position) {
    _position = position;
  }

  void setEditMode() {
    notifyListeners();
  }

  void setMarker() {
    _marker = Marker(
      markerId: MarkerId(
        _position.target.latitude.toString() +
            "," +
            _position.target.longitude.toString(),
      ),
      position: _position.target,
    );
    getAddressInfo();
    notifyListeners();
  }

  Location _location = new Location();

  bool _serviceEnabled;
  PermissionStatus _permissionGranted;
  LocationData _locationData;

  void gotoMyLocation() async {
    _loading = true;
    notifyListeners();
    try {
      _serviceEnabled = await _location.serviceEnabled();
      if (!_serviceEnabled) {
        _serviceEnabled = await _location.requestService();
        if (!_serviceEnabled) {
          return;
        }
      }

      _permissionGranted = await _location.hasPermission();
      if (_permissionGranted == PermissionStatus.denied) {
        _permissionGranted = await _location.requestPermission();
        if (_permissionGranted != PermissionStatus.granted) {
          return;
        }
      }

      _locationData = await _location.getLocation();
      _position = CameraPosition(
        target: LatLng(_locationData.latitude, _locationData.longitude),
        zoom: 18,
      );
      await controller.animateCamera(
        CameraUpdate.newCameraPosition(_position),
      );
    } catch (e) {
      print(e.toString());
    }
    _loading = false;
    notifyListeners();
  }

  void getAddressInfo() async {
    final coordinated =
        Coordinates(_marker.position.latitude, _marker.position.longitude);
    var addressInfo =
        await Geocoder.local.findAddressesFromCoordinates(coordinated);
    addressValue = addressInfo.first.addressLine;
    notifyListeners();
  }

  void initializeForEdit({LocationAddress address}) {
    _currentAddress = address;

    _marker = Marker(
      markerId: MarkerId('1'),
      position: LatLng(address.latitude, address.longitude),
    );
    _position = CameraPosition(
        target: LatLng(address.latitude, address.longitude), zoom: 17);
    addressValue = address.value;
  }

  void initializeForAdd() {
    _currentAddress = null;
    _marker = null;
    _position = CameraPosition(
      target: LatLng(17.6599, 75.9064),
      zoom: 13,
    );
    addressValue = null;
  }

  void addLocationAddress() {
    _locationAddressList.add(
      LocationAddress(
          value: addressValue,
          latitude: _marker.position.latitude,
          longitude: _marker.position.longitude),
    );
    notifyListeners();
    saveLocationAddressList(_locationAddressList);
  }

  void editAddress() {
    _locationAddressList
        .where((element) => element == _currentAddress)
        .first
        .editAddress(
          newLatitude: _marker.position.latitude,
          newLongitude: _marker.position.longitude,
          newValue: addressValue,
        );

    saveLocationAddressList(_locationAddressList);
    notifyListeners();
  }

  void deleteAddress({LocationAddress address}) {
    _locationAddressList.remove(address);
    notifyListeners();
    saveLocationAddressList(_locationAddressList);
  }

  Future<List<LocationAddress>> readLocationAddressList() async {
    List<LocationAddress> list = List<LocationAddress>();
  
    return list;
  }

  void saveLocationAddressList(
      List<LocationAddress> listLocationAddress) async {
    
  }
}
