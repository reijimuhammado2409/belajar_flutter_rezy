import 'package:flutter/material.dart';

class Tugas4 extends StatelessWidget {
  const Tugas4({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 2, 130, 12),
        title: const Text("Input & Daftar Santri"),
        centerTitle: true,
      ),

      /// 1. List View sebagai Root Widget
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [

          /// header aplikasi
          const Center(
            child: Text(
              "Al-HAFIZH",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          const SizedBox(height: 20),

          ///2. Formulir pengguna denga Textfield
          const Text(
            "Input Data Santri",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 12),

          const TextField(
            decoration: InputDecoration(
              labelText: "Nama",
              border: OutlineInputBorder(),
            ),
          ),

          const SizedBox(height: 12),

          const TextField(
            decoration: InputDecoration(
              labelText: "Email",
              border: OutlineInputBorder(),
            ),
          ),

          const SizedBox(height: 12),

          const TextField(
            decoration: InputDecoration(
              labelText: "No HP",
              border: OutlineInputBorder(),
            ),
          ),

          const SizedBox(height: 12),

          const TextField(
            decoration: InputDecoration(
              labelText: "Deskripsi",
              border: OutlineInputBorder(),
            ),
          ),

          const SizedBox(height: 24),

          /// Daftar Santri 
          const Text(
            "Daftar Santri",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 12),

          ///  3. daftar item nantinya akan jadi hasil output dari inputan data siswa
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text("Ahmad Fauzi"),
            subtitle: const Text("Iqro 2 • Umur 8 Tahun"),
          ),

          ListTile(
            leading: const Icon(Icons.person),
            title: const Text("Siti Aisyah"),
            subtitle: const Text("Iqro 3 • Umur 9 Tahun"),
          ),

          ListTile(
            leading: const Icon(Icons.person),
            title: const Text("Muhammad Rizki"),
            subtitle: const Text("Iqro 1 • Umur 7 Tahun"),
          ),

          ListTile(
            leading: const Icon(Icons.person),
            title: const Text("Nur Halimah"),
            subtitle: const Text("Al-Quran • Umur 11 Tahun"),
          ),

          ListTile(
            leading: const Icon(Icons.person),
            title: const Text("Fajar Ramadhan"),
            subtitle: const Text("Iqro 4 • Umur 10 Tahun"),
          ),

          const SizedBox(height: 30),
        ],
      ),
    );
  }
}
