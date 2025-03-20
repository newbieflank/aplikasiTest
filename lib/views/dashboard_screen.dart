import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test_app/core/models/user.dart';
import 'package:test_app/core/services/auth_service.dart';
import 'package:test_app/core/viewmodels/auth_viewmodel.dart';
import 'package:test_app/views/login_screen.dart';
import 'package:test_app/views/profile_screen.dart';
import 'package:test_app/views/makanan_screen.dart';
import 'package:test_app/views/minuman_screen.dart';
import 'package:test_app/views/pesanan_screen.dart';
import '../widgets/custom_button.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  String? username;
  int? id;
  int _selectedIndex = 0;

  @override
  void initState() {
    _loadUserData();
    super.initState();
  }

  Future<void> _loadUserData() async {
    User? user = await _getUser();
    // String? token = await _getToken();

    setState(() {
      if (user != null) {
        username = user.name;
      } else {
        username = "guest";
      }
    });
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

  Future<void> _logout() async {
    final authProvider = Provider.of<AuthViewModel>(context, listen: false);
    await authProvider.logout();

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }

  void _onItemTapped(int index) {
    if (mounted) {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  // 🔹 Widget untuk menampilkan halaman berdasarkan menu yang dipilih
  Widget _buildScreen() {
    switch (_selectedIndex) {
      case 0:
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Welcome, $username!",
                style:
                    const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              CustomButton(
                text: "Logout",
                onPressed: _logout,
                backgroundColor: Colors.red,
                textColor: Colors.white,
                height: 50,
              ),
            ],
          ),
        );
      case 1:
        return const ProfileScreen();
      case 2:
        return const PesananScreen();
      case 3:
        return const MinumanScreen();
      default:
        return const Center(child: Text("Page Not Found"));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(32, 87, 129, 1),
        title: const Text(
          "MyApp",
          style: TextStyle(
              color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
        ),
        // centerTitle: true,
      ),
      body: _buildScreen(),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          _buildNavItem(Icons.home, "Home", 0),
          _buildNavItem(Icons.food_bank, "Makanan", 1),
          _buildNavItem(Icons.local_drink, "Minuman", 2),
          _buildNavItem(Icons.add_chart, "Pesanan", 3),
          _buildNavItem(Icons.settings, "Profile", 4),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: _selectedIndex == 0
            ? Colors.blue
            : _selectedIndex == 1
                ? Colors.green
                : _selectedIndex == 2
                    ? Colors.red
                    : _selectedIndex == 3
                        ? Colors.yellow
                        : Colors.purple,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
        showSelectedLabels: false,
        showUnselectedLabels: false,
      ),
    );
  }

  BottomNavigationBarItem _buildNavItem(
      IconData icon, String label, int index) {
    bool isSelected = _selectedIndex == index;
    Color selectedColor = _selectedIndex == 0
        ? Colors.blue
        : _selectedIndex == 1
            ? Colors.green
            : _selectedIndex == 2
                ? Colors.red
                : _selectedIndex == 3
                    ? Colors.orange
                    : Colors.purple;

    return BottomNavigationBarItem(
      icon: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: isSelected
            ? BoxDecoration(
                color: selectedColor,
                borderRadius: BorderRadius.circular(20),
              )
            : null,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected ? Colors.white : Colors.grey,
            ),
            if (isSelected) ...[
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  label,
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.grey,
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis,
                  softWrap: false,
                ),
              ),
            ],
          ],
        ),
      ),
      label: "",
    );
  }
}
