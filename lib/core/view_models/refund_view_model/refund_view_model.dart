import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:green_grocery_admin/core/models/wallet.dart';
import 'package:http/http.dart' as http;

class RefundViewModel extends ChangeNotifier {
  Wallet wallet;
  bool loading = false;

  void setWallet(Wallet value) {
    wallet = value;
    notifyListeners();
  }

  void refund() async {
    loading = true;
    notifyListeners();
    String username = 'rzp_test_KmPzyFK6pErbkC';
    String password = 'HDLsL5DxJOc4dxdk0lrQTww2';
    String basicAuth =
        'Basic ' + base64Encode(utf8.encode('$username:$password'));
    print(basicAuth);

    try {
      var r = await http.post(
          "https://api.razorpay.com/v1/payments/${wallet.paymentIds.first}/refund",
          headers: {
            'Content-Type': 'application/json',
            'authorization': basicAuth
          },
          body: jsonEncode({"amount": (wallet.amount * 100).toInt(),"speed": "optimum",}));
      print(r.statusCode);
      print(r.body);
    } catch (e) {
      print("SSSSS" + " " + e.toString());
    }
    loading = false;
    notifyListeners();
  }
}
