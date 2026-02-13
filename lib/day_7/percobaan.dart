import 'package:flutter/material.dart';

class percobaan extends StatelessWidget {
  const percobaan({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 1️⃣ Header Halaman
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 2, 130, 12),
        title: const Text("Profil Hero"),
        centerTitle: true,
      ),

      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          // 2️⃣ Identitas Utama (Wajib Center)
          const SizedBox(height: 20),
          Center(
            child: Text(
              "Al-Hafizh",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          const SizedBox(height: 20),

          // 3️⃣ Detail Kontak / Informasi
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: const [

                  // Email
                  Row(
                    children: [
                      Icon(Icons.email),
                      SizedBox(width: 8),
                      Text("Email"),
                      Spacer(),
                      Text("fufufafa@gmail.com"),
                    ],
                  ),

                  SizedBox(height: 10),

                  // No Telp
                  Row(
                    children: [
                      Icon(Icons.phone),
                      SizedBox(width: 8),
                      Text("No Telp"),
                      Spacer(),
                      Text("+62 877 6655 4433"),
                    ],
                  ),

                  SizedBox(height: 10),

                  // Lokasi
                  Row(
                    children: [
                      Icon(Icons.location_on),
                      SizedBox(width: 8),
                      Text("Alamat"),
                      Spacer(),
                      Text("Antartika"),
                    ],
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),

          // 4️⃣ Aksi / Informasi Pendukung (Row + Spacer)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: const [
                Icon(Icons.star),
                SizedBox(width: 8),
                Text("Rank Hero"),
                Spacer(),
                Text("S-Class"),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // 5️⃣ Area Statistik Horizontal (Row + Expanded)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [

                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    margin: const EdgeInsets.only(right: 8),
                    decoration: BoxDecoration(
                      color: Colors.green[200],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Column(
                      children: [
                        Text(
                          "100",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text("Misi"),
                      ],
                    ),
                  ),
                ),

                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    margin: const EdgeInsets.only(left: 8),
                    decoration: BoxDecoration(
                      color: Colors.green[200],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Column(
                      children: [
                        Text(
                          "50",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text("Prestasi"),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // 6️⃣ Deskripsi Naratif
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              "Al-Hafizh adalah hero legendaris yang berasal dari Antartika. "
              "Ia memiliki kekuatan es yang luar biasa dan telah menyelesaikan "
              "ratusan misi berbahaya demi melindungi dunia.",
              textAlign: TextAlign.justify,
            ),
          ),

          const SizedBox(height: 20),

          // 7️⃣ Visual Branding
          Container(
            height: 80,
            width: double.infinity,
            color: const Color.fromARGB(255, 2, 130, 12),
            child: const Center(
              child: Text(
                "Hero App 2026",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
