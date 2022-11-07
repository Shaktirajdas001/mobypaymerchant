import 'package:flutter/material.dart';
// username
class UsernameVM with ChangeNotifier {
  String username = "";
  void onType(String value) {
    username = value;
    notifyListeners();
  }
}
// password
class LoginPasswordVM with ChangeNotifier {
  String password = "";
  void onType(String value) {
    password = value;
    notifyListeners();
  }
}

