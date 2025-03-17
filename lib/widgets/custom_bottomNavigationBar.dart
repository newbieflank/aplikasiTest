import 'package:flutter/material.dart';

class CustomBottomNavigation extends StatefulWidget {
  @override
  _CustomBottomNavigationState createState() => _CustomBottomNavigationState();
}

class _CustomBottomNavigationState extends State<CustomBottomNavigation> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
            "Selected: ${_selectedIndex == 0 ? "Dashboard" : _selectedIndex == 1 ? "Profile" : "Settings"}"),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          _buildNavItem(Icons.dashboard, "Dashboard", 0),
          _buildNavItem(Icons.person, "Profile", 1),
          _buildNavItem(Icons.settings, "Settings", 2),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
        showSelectedLabels: false, // Menonaktifkan label bawaan
        showUnselectedLabels: false,
      ),
    );
  }

  BottomNavigationBarItem _buildNavItem(
      IconData icon, String label, int index) {
    return BottomNavigationBarItem(
      icon: Stack(
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon,
                  color: _selectedIndex == index ? Colors.blue : Colors.grey),
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                width: _selectedIndex == index
                    ? 80
                    : 0, // Lebar hanya muncul saat dipilih
                margin: const EdgeInsets.only(
                    left: 8), // Jarak antara ikon dan teks
                child: _selectedIndex == index
                    ? Text(
                        label,
                        style: const TextStyle(
                            color: Colors.blue, fontWeight: FontWeight.bold),
                        overflow: TextOverflow.clip,
                      )
                    : null,
              ),
            ],
          ),
        ],
      ),
      label: "",
    );
  }
}
