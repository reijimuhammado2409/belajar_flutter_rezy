import 'package:flutter/material.dart';
import 'dashb0ardtpq.dart';
import 'list.dart';
import 'map.dart';
import 'model.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {

  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const Dashb0ardtpq(),
    const SoalList(),
    const SoalMap(),
    const SoalModel(),
    const TentangAplikasi(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      // 🔥 FIX UTAMA → biar navbar stabil
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),

      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed, // WAJIB kalau item banyak

        backgroundColor: Colors.white,
        selectedItemColor: const Color(0xFF0F9D58),
        unselectedItemColor: Colors.grey,

        currentIndex: _selectedIndex,
        onTap: _onItemTapped,

        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: "List",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.map),
            label: "Map",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Model",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.info),
            label: "Tentang",
          ),
        ],
      ),
    );
  }
}

class TentangAplikasi extends StatelessWidget {
  const TentangAplikasi({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tentang Aplikasi"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [

            SizedBox(height: 20),

            Text(
              "Al-Hafizh App",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            SizedBox(height: 15),

            Text(
              "Aplikasi ini digunakan untuk membantu pengajar TPQ "
              "dalam mengelola data santri, absensi, dan perkembangan belajar. "
              "Segitu dulu pak, pusing pala saya  :(",
              style: TextStyle(fontSize: 16),
            ),

            SizedBox(height: 20),

            Text(
              "Dibuat oleh:",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),

            Text("Nama: penyakit koding gila"),
            Text("Versi: 1.0.0"),
          ],
        ),
      ),
    );
  }
}