import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthProvider extends ChangeNotifier {
  String? _phone;
  bool _kycDone = false;
  bool _isOnline = true;
  String? _verificationId;

  String? get phone => _phone;
  bool get isLoggedIn => _phone != null;
  bool get kycDone => _kycDone;
  bool get isOnline => _isOnline;

  Future<void> sendOtp(String phone, Function(String verificationId) onCodeSent, Function(String error) onError) async {
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: phone,
      timeout: const Duration(seconds: 60),
      verificationCompleted: (PhoneAuthCredential credential) async {
        await FirebaseAuth.instance.signInWithCredential(credential);
        _phone = phone;
        notifyListeners();
      },
      verificationFailed: (FirebaseAuthException e) {
        onError(e.message ?? 'Verification failed');
      },
      codeSent: (String verificationId, int? resendToken) {
        _verificationId = verificationId;
        onCodeSent(verificationId);
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        _verificationId = verificationId;
      },
    );
  }

  Future<bool> verifyOtp(String smsCode) async {
    if (_verificationId == null) return false;
    try {
      final credential = PhoneAuthProvider.credential(
        verificationId: _verificationId!,
        smsCode: smsCode,
      );
      final userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
      _phone = userCredential.user?.phoneNumber;
      notifyListeners();
      return true;
    } catch (e) {
      return false;
    }
  }

  void completeKyc() {
    _kycDone = true;
    notifyListeners();
  }

  void setOnline(bool value) {
    _isOnline = value;
    notifyListeners();
  }

  void logout() async {
    await FirebaseAuth.instance.signOut();
    _phone = null;
    _kycDone = false;
    _isOnline = true;
    notifyListeners();
  }
}