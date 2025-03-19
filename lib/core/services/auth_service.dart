import 'dart:convert';
// import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test_app/core/models/minuman.dart';
import '../models/user.dart';
// import '../../utils/storage_helper.dart';

class AuthService {
  static const String userKey = "user";
  static const String tokenKey = "token";
  final String baseUrl = "http://127.0.0.1:8000/api";

  Future<bool> register(
      String name,
      String email,
      String password,
      String username,
      String gender,
      String no_telp,
      String alamat,
      String tgl_lahir) async {
    final url = Uri.parse("$baseUrl/register");
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "name": name,
        "username": username,
        "gender": gender,
        "tanggal_lahir": tgl_lahir,
        "no_telp": no_telp,
        "alamat": alamat,
        "email": email,
        "password": password,
      }),
    );

    if (response.statusCode == 201) {
      return true;
    }
    return false;
  }

  // Method untuk login
  Future<User?> login(String email, String password) async {
    final url = Uri.parse("$baseUrl/login");
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"email": email, "password": password}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      if (data['success']) {
        User user = User.fromJson(data['user']);
        await _saveUser(user);
        await _saveToken(data['token']);

        return user;
      }
    }
    return null;
  }

  Future<List<Minuman>?> fetchMinuman() async {
    try {
      String? token = await _getToken();
      final response = await http.get(
        Uri.parse("$baseUrl/minuman"),
        headers: {
          "Authorization": "Bearer $token",
          "Accept": "application/json",
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);

        if (responseData['success'] == true &&
            responseData.containsKey('minuman')) {
          List<dynamic> minumanData = responseData['minuman'];
          return minumanData.map((item) => Minuman.fromJson(item)).toList();
        }
      }
    } catch (e) {
      print("Error fetching data: $e");
    }
    return null;
  }

  // Method untuk mengecek apakah user sudah login
  // Future<bool> isLoggedIn() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   String? token = prefs.getString(tokenKey);
  //   return token != null; // Jika token ada, berarti user sudah login
  // }

  // Method untuk logout
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(userKey);
    await prefs.remove(tokenKey);
  }

  // Simpan user data
  Future<void> _saveUser(User user) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(
        userKey,
        jsonEncode({
          "id": user.id,
          "name": user.name,
          "email": user.email,
        }));
  }

  // Simpan token
  Future<void> _saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(tokenKey, token);
  }

  // Ambil user data
  Future<User?> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    String? userData = prefs.getString(userKey);

    if (userData != null) {
      return User.fromJson(jsonDecode(userData));
    }
    return null;
  }

  _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(AuthService.tokenKey);
  }
}
