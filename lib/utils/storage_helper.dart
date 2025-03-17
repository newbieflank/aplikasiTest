import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:test_app/core/models/user.dart';

class StorageHelper {
  static Future<void> saveUser(User user) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(
        "user",
        jsonEncode({
          "id": user.id,
          "name": user.name,
          "email": user.email,
        }));
  }

  static Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString("token", token);
  }

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("token");
  }
}
