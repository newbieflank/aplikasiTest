import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
import '../models/user.dart';
import '../services/auth_service.dart';

class AuthViewModel extends ChangeNotifier {
  final AuthService _authService = AuthService();
  bool _isLoading = false;
  User? _user;

  bool get isLoading => _isLoading;
  User? get user => _user;

  // Login Method
  Future<bool> login(String email, String password) async {
    _isLoading = true;
    notifyListeners();

    User? user = await _authService.login(email, password);
    _isLoading = false;

    if (user != null) {
      _user = user;
      notifyListeners();
      return true;
    }
    notifyListeners();
    return false;
  }

  Future<bool> register(
      String name,
      String email,
      String password,
      String username,
      String gender,
      String no_telp,
      String alamat,
      String tgl_lahir) async {
    _isLoading = true;
    notifyListeners();

    bool success = await _authService.register(
        name, email, password, username, gender, no_telp, alamat, tgl_lahir);
    _isLoading = false;

    notifyListeners();
    return success;
  }

  // Logout Method
  Future<void> logout() async {
    await _authService.logout();
    notifyListeners();
  }
}
