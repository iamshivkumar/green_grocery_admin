import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:green_grocery_admin/core/models/wallet.dart';
import 'package:http/http.dart' as http;

class RefundViewModel extends ChangeNotifier {
  RefundViewModel({this.wallet});
  final Wallet wallet;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool loading = false;

  void refund() async {
    loading = true;
    notifyListeners();
    String username = 'rzp_test_KmPzyFK6pErbkC';
    String password = 'HDLsL5DxJOc4dxdk0lrQTww2';
    String basicAuth =
        'Basic ' + base64Encode(utf8.encode('$username:$password'));

    bool removeRequest = true;
    double walletAmount = wallet.amount;
    for (var payment in wallet.payments) {
      double refundAmount =
          walletAmount > payment.amount ? payment.amount : walletAmount;

      try {
        var r = await http.post(
            Uri.parse(
                'https://api.razorpay.com/v1/payments/${payment.id}/refund'),
            headers: {
              'Content-Type': 'application/json',
              'authorization': basicAuth
            },
            body: jsonEncode(
                {"speed": "optimum", "amount": (refundAmount * 100).toInt()}));
        if (r.statusCode == 200) {
          walletAmount -= refundAmount;
          _firestore.collection("wallets").doc(wallet.id).update({
            "refundIDs": FieldValue.arrayUnion([
              {
                "id": jsonDecode(r.body)["id"],
                "amount": jsonDecode(r.body)["amount"] / 100
              }
            ]),
            "amount": FieldValue.increment(-refundAmount),
            "payments": FieldValue.arrayRemove([
              {
                "id": payment.id,
                "amount": payment.amount,
              }
            ])
          });
        } else if (r.statusCode == 400) {
          removeRequest = false;
          Fluttertoast.showToast(
              msg: jsonDecode(r.body)["error"]["description"]);
        }
      } catch (e) {
        Fluttertoast.showToast(msg: e.code);
      }
    }
    if (removeRequest) {
      _firestore
          .collection("wallets")
          .doc(wallet.id)
          .update({"refundRequested": false});
    }
    loading = false;
    notifyListeners();
  }
}
