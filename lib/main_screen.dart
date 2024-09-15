import 'package:flutter/material.dart';
import 'package:flutter_ai_saas_app/constants/colors.dart';
import 'package:flutter_ai_saas_app/screens/conversion_history.dart';
import 'package:flutter_ai_saas_app/screens/home_page.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  // Method to handle the tapping on bottom navigation item
  void _onTapItem(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: BottomNavigationBar(
          items: const [
            BottomNavigationBarItem(
                icon: Icon(Icons.transform), label: "Conversion"),
            BottomNavigationBarItem(
                icon: Icon(Icons.history), label: "History"),
          ],
          onTap: _onTapItem,
          currentIndex: _selectedIndex,
          unselectedItemColor: const Color.fromARGB(255, 3, 43, 79),
          selectedItemColor: const Color.fromARGB(255, 251, 254, 255),
          backgroundColor: mainColor,
        ),
        body: _selectedIndex == 0
            ? const HomePage()
            : const HistoryConversions());
  }
}
