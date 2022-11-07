import 'package:flutter/material.dart';
// register Mobile
class ResetPasswordVM with ChangeNotifier {
  String password = "";
  void onType(String value) {
    password = value;
    notifyListeners();
  }
}
