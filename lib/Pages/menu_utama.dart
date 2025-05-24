import 'package:flutter/material.dart';
import '../models/model_user.dart';
import '../screens/home_screen.dart';
import '../screens/portofolio_screen.dart';
import '../screens/profile_screen.dart';

class MainPage extends StatefulWidget {
  final User user;

  const MainPage({super.key, required this.user});

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  late User user; // Simpan user di state supaya bisa diperbarui
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    user = widget.user;
  }

  void onUserUpdated(User newUser) {
    setState(() {
      user = newUser;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screens = [
      HomeScreen(user: user),
      PortofolioScreen(userId: user.id ?? 0),
      ProfileScreen(user: user),
    ];

    return Scaffold(
      body: screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Beranda'),
          BottomNavigationBarItem(icon: Icon(Icons.pie_chart), label: 'Portofolio'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
        ],
      ),
    );
  }
}
