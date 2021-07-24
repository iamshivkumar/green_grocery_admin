import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/settings.dart';

final settingsStreamProvider = StreamProvider<StoreSettings>(
  (ref) => FirebaseFirestore.instance
      .collection("master_data")
      .doc("master_data_v1")
      .snapshots().map((event) => StoreSettings.fromFirestore(event)),
);
