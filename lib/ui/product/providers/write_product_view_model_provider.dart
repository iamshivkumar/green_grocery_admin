import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../core/models/product.dart';

final writeProductViewModelProvider =
    ChangeNotifierProvider.autoDispose.family<WriteProductViewModel, Product>(
  (ref, product) => WriteProductViewModel(product),
);

class WriteProductViewModel extends ChangeNotifier {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  FirebaseStorage _storage = FirebaseStorage.instance;
  WriteProductViewModel(this.product);

  bool _loading = false;
  bool get loading => _loading;
  set loading(bool loading) {
    _loading = loading;
    notifyListeners();
  }


  final Product product;

  String get category => product.category;

  set category(String category) {
    product.category = category;
    notifyListeners();
  }

  String get unit => product.unit;

  set unit(String unit) {
    product.unit = unit;
    notifyListeners();
  }

  bool get active => product.active;

  set active(bool active) {
    product.active = active;
    notifyListeners();
  }

  bool get popular => product.popular;

  set popular(bool popular) {
    product.popular = popular;
    notifyListeners();
  }

  List<String> get images {
    List<String> list = [];
    for (var item in product.images) {
      if (!_removedImages.contains(item)) {
        list.add(item);
      }
    }
    return list;
  }

  List<String> _removedImages = [];

  List<File> files = [];
  void addImage(File value) {
    files.add(value);
    notifyListeners();
  }

  void removeImage(value) {
    if (value is String) {
      _removedImages.add(value);
    } else {
      files.remove(value);
    }
    notifyListeners();
  }

  List<String> _keys() {
    List<String> values = [];
    String initValue = "";
    for (var item in product.name.toLowerCase().split("")) {
      initValue = initValue + item;
      values.add(initValue);
    }
    return values;
  }

  Future<void> writeProduct() async {
    loading = true;
    for (var item in _removedImages) {
      product.images.remove(item);
      // _deleteImage(item);
    }
    for (var item in files) {
      final url = await _uploadImage(item);
      if (url != null) {
        product.images.add(url);
      }
    }

    if (product.id.isEmpty) {
      _firestore.collection("products").add(
            product.toMap(
              searckKeys: _keys(),
            ),
          );
    } else {
      _firestore.collection("products").doc(product.id).update(
            product.toMap(
              searckKeys: _keys(),
            ),
          );
    }
    loading = false;
  }

  void deleteProduct(Product product) async {
    List<dynamic> images = product.images;
    await Future.delayed(Duration(milliseconds: 500));
    try {
      await _firestore.collection("products").doc(product.id).delete();
      for (var image in images) {
        _deleteImage(image);
      }
      Fluttertoast.showToast(msg: "Product ${product.name} deleted.");
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
    }
  }

  Future<String?> _uploadImage(File file) async {
    return await (await _storage
            .ref("product_images/${DateTime.now().toString()}")
            .putFile(file))
        .ref
        .getDownloadURL();
  }

  void _deleteImage(String image) {
    _storage.refFromURL(image).delete();
  }

  void setProductStatus({required String id, required bool value}) async {
    _firestore.collection("products").doc(id).update({"active": value});
  }

  void setProductPopularity({required String id, required bool value}) {
    _firestore.collection("products").doc(id).update({"popular": value});
  }

  void updateProductQuantity({required String id, required int qt}) {
    _firestore.collection("products").doc(id).update(
      {"quantity": FieldValue.increment(qt)},
    );
  }
}
