import 'package:flutter/material.dart';
import 'package:belajar_flutter_rezy/day_16/view/dashboard_screen.dart';
import 'package:belajar_flutter_rezy/day_16/view/cr_siswa.dart';

class BottomNavbar extends StatefulWidget {
  final String nama;
  final String gmail;

  const BottomNavbar({super.key, required this.nama, required this.gmail});

  @override
  State<BottomNavbar> createState() => _BottomNavbarState();
}

class _BottomNavbarState extends State<BottomNavbar> {
  int _selectedIndex = 0;

  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();

    _pages = [
      DashboardScreen(nama: widget.nama, gmail: widget.gmail),
      const DataSiswaScreen(),
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _selectedIndex, children: _pages),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: const Color(0xFF0F9D58),

        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.list), label: "List"),
        ],
      ),
    );
  }
}
