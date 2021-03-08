import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:green_grocery_admin/core/models/product.dart';
import 'package:path_provider/path_provider.dart';

class AddEditProductViewModel extends ChangeNotifier {
  bool _loading = false;
  bool get loading => _loading;

  void initializeModelForEdit(Product value) async {
    product = value;

    if (amountTypes.contains(value.amount.split(" ").last)) {
      amountType = value.amount.split(" ").last;
    }
    category = value.category;
    active = value.active;
    popular = value.popular;

    Directory tempDir = await getTemporaryDirectory();
    try {
      for (var image in value.images) {
        File downloadToFile = File(
          tempDir.path +
              "/" +
              value.name +
              value.images.indexWhere((element) => element == image).toString(),
        );
        await _storage.refFromURL(image).writeToFile(downloadToFile);
        files.add(downloadToFile);
      }
    } catch (e) {
      print(e.code);
    }
    notifyListeners();
  }

  void disposeModel() async {
    product = null;
    _loading = false;
    files = [];
  }

  List<String> categories = [
    'Fruits',
    "Vegetables",
    'Food',
    'Drinks',
    'Snacks'
  ];

  String category = "Fruits";
  void setCategory(String value) {
    category = value;
    notifyListeners();
  }

  String _name;
  void setName(String value) {
    _name = value;
  }

  Product product;

  double _price;
  void setPrice(String value) {
    _price = double.parse(value);
  }

  int _quantity;
  void setQuantity(String value) {
    _quantity = int.parse(value);
  }

  String _amount;
  void setAmount(String value) {
    _amount = value;
  }

  List<String> amountTypes = ['Kg', "Gram", "Litre", "ML", 'PCS', 'Dozen'];
  String amountType = "Kg";

  void setAmountType(String value) {
    amountType = value;
    notifyListeners();
  }

  String _description;
  void setDescription(String value) {
    _description = value;
  }

  bool active = true;
  void setActive(bool value) {
    active = value;
    notifyListeners();
  }

  bool popular = false;
  void setPopular(bool value) {
    popular = value;
    notifyListeners();
  }

  List<File> files = [];
  void addImage(File value) {
    files.add(value);
    notifyListeners();
  }

  void removeImage(File value) {
    files.remove(value);
    notifyListeners();
  }

  FirebaseStorage _storage = FirebaseStorage.instance;

  // ignore: missing_return
  Future<String> uploadFile(File file) async {
    Fluttertoast.showToast(msg: "Uploading images");
    try {
      UploadTask uploadTask = _storage
          .ref("ProductImages/" +
              _name +
              files.indexWhere((element) => element == file).toString())
          .putFile(file);
      return await (await uploadTask).ref.getDownloadURL();
    } on FirebaseException catch (e) {
      Fluttertoast.showToast(msg: e.code);
    }
  }

  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Future addProduct() async {
    _loading = true;
    notifyListeners();

    List<String> images = [];
    for (var file in files) {
      images.add(await uploadFile(file));
    }
    try {
      await _firestore.collection("products").add({
        "name": _name,
        "amount": _amount + " " + amountType,
        "description": _description,
        "images": images,
        "price": _price,
        "quantity": _quantity,
        "active": active,
        "popular": popular,
        "category": category,
      });
      Fluttertoast.showToast(msg: "Product $_name added.");
    } catch (e) {
      Fluttertoast.showToast(msg: e.code);
    }
  }

  Future updateProduct() async {
    _loading = true;
    notifyListeners();
    product.images.forEach((element) {
      _storage.refFromURL(element).delete();
    });
    List<String> images = [];
    for (var file in files) {
      images.add(await uploadFile(file));
    }
    try {
      await _firestore.collection("products").doc(product.id).update({
        "name": _name,
        "amount": _amount + " " + amountType,
        "description": _description,
        "images": images,
        "price": _price,
        "quantity": _quantity,
        "active": active,
        "popular": popular,
        "category": category,
      });
      Fluttertoast.showToast(msg: "Product $_name updated.");
    } catch (e) {
      Fluttertoast.showToast(msg: e.code);
    }
    _loading = false;
  }

  void deleteProduct(Product product) async {
    List<dynamic> images = product.images;
    await Future.delayed(Duration(milliseconds: 500));
    try {
      await _firestore.collection("products").doc(product.id).delete();
      for (var image in images) {
        _storage.refFromURL(image).delete();
      }
      Fluttertoast.showToast(msg: "Product ${product.name} deleted.");
    } catch (e) {
      Fluttertoast.showToast(msg: e.code);
    }
  }

  void setProductStatus({String id, value}) async {
    _firestore.collection("products").doc(id).update({"active": value});
  }

  void setProductPopularity({String id, value}) {
    _firestore.collection("products").doc(id).update({"popular": value});
  }

  void updateProductQuantity({String id, qt}) {
    _firestore.collection("products").doc(id).update(
      {"quantity": FieldValue.increment(qt)},
    );
  }
}
