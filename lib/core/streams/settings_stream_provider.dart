import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:green_grocery_admin/core/models/settings.dart';

final settingsStreamProvider = StreamProvider(
  (ref) => FirebaseFirestore.instance
      .collection("settings")
      .doc("settings")
      .snapshots().map((event) => StoreSettings.fromFirestore(event)),
);
