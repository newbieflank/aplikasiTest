import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/viewmodels/auth_viewmodel.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test_app/core/models/user.dart';
import 'views/login_screen.dart';
import 'views/dashboard_screen.dart';
import 'core/services/auth_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthViewModel()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  Future<bool> checkLoginStatus() async {
    final user = await _getUser();
    final token = await _getToken();

    return user != null && token != null && token.isNotEmpty;
  }

  Future<User?> _getUser() async {
    final prefs = await SharedPreferences.getInstance();
    final String? userData = prefs.getString(AuthService.userKey);

    if (userData != null) {
      final Map<String, dynamic> userMap = jsonDecode(userData);
      return User(
        id: userMap["id"],
        name: userMap["name"],
        email: userMap["email"],
      );
    }
    return null;
  }

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(AuthService.tokenKey);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: FutureBuilder<bool>(
        future: checkLoginStatus(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          } else if (snapshot.hasData && snapshot.data == true) {
            return const DashboardScreen();
          } else {
            return const LoginScreen();
          }
        },
      ),
    );
  }
}
