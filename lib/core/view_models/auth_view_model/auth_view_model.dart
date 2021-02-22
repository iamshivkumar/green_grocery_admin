import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class AuthViewModel extends ChangeNotifier {
  FirebaseAuth _auth = FirebaseAuth.instance;
  User user = FirebaseAuth.instance.currentUser;
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController smsController = TextEditingController();
  String _verificationId;
  bool loading = false;
  bool phoneLoading = false;
  bool otpSent = false;

  void verifyPhoneNumber({VoidCallback onVerify}) async {
    phoneLoading = true;
    otpSent = false;
    notifyListeners();
    try {
      var admins = await FirebaseFirestore.instance
          .collection("admins")
          .where("mobile", isEqualTo: phoneNumberController.text)
          .get();
      if (admins.docs.isEmpty) {
        print("admin not registered");
        phoneLoading = false;
        notifyListeners();
        return;
      }
      await _auth.verifyPhoneNumber(
        phoneNumber: "+91" + phoneNumberController.text,
        verificationCompleted: (PhoneAuthCredential credential) async {
          loading = true;
          otpSent = false;
          notifyListeners();
          user = (await _auth.signInWithCredential(credential)).user;
          onVerify();
        },
        verificationFailed: (FirebaseAuthException e) {
          if (e.code == 'invalid-phone-number') {
            print('The provided phone number is not valid.');
          }
        },
        codeSent: (String verificationId, int resendToken) async {
          otpSent = true;
          phoneLoading = false;
          _verificationId = verificationId;
          notifyListeners();
        },
        timeout: const Duration(seconds: 30),
        codeAutoRetrievalTimeout: (String verificationId) {
          _verificationId = verificationId;
          loading = false;
        },
      );
    } catch (e) {
      print(e.toString());
    }
  }

  Future<User> signInWithPhoneNumber() async {
    loading = true;
    notifyListeners();
    try {
      final AuthCredential credential = PhoneAuthProvider.credential(
        verificationId: _verificationId,
        smsCode: smsController.text,
      );
      user = (await _auth.signInWithCredential(credential)).user;
      print("Successfully signed in UID: ${user.uid}");
    } catch (e) {
      print("Failed to sign in: " + e.toString());
    }
    loading = false;
    notifyListeners();
    return user;
  }

  Future<void> signOut() async {
    await _auth.signOut();
    user = null;
  }
}
