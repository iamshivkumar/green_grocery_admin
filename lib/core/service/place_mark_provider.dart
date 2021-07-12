import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geocoding/geocoding.dart' as geo;
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../utils/utils.dart';

final placeProvider = FutureProvider.family<String, GeoPoint>(
  (ref, point) async {
    final _placemarks =
        await geo.placemarkFromCoordinates(point.latitude, point.longitude);
    return Utils.formatedAddress(_placemarks.first);
  },
);
