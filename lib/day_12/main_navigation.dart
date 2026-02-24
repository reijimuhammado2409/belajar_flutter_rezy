import 'package:flutter/material.dart';
import 'DashboardTPQ.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {

  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const DashboardTPQ(),   // Tab Home (Tugas 7 + Drawer aktif)
    const TentangAplikasi(), // Tab Tentang
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      // Body berubah sesuai tab
      body: _pages[_selectedIndex],

      // Bottom Navigation
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: const Color(0xFF0F9D58),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
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
              "dalam mengelola data santri, absensi, dan perkembangan belajar."
              "untuk calon my bini freya jayawardhana : )",
              style: TextStyle(fontSize: 16),
            ),

            SizedBox(height: 20),

            Text(
              "Dibuat oleh:",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),

            Text("Nama: My BINI Freya Jayawardhana"),
            Text("Versi: 1.0.0"),
          ],
        ),
      ),
    );
  }
}