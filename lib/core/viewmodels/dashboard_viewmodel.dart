import 'package:flutter/material.dart';

class DashboardViewModel extends ChangeNotifier {
  String _message = "Welcome to the Dashboard!";

  String get message => _message;

  void updateMessage(String newMessage) {
    _message = newMessage;
    notifyListeners(); // UI updates automatically
  }
}
