import 'package:flutter/material.dart';

class Tugas1Flutter extends StatelessWidget {
  const Tugas1Flutter({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //Judul AppBar
      appBar: AppBar(backgroundColor: const Color.fromARGB(255, 13, 83, 203),
      title: Text("Profil Saya"),
      centerTitle: true,
      ),
      body : Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        //baris 1 - Nama
        children: [Text ("Nama : Muhammad Fachri Fahrezy",
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
        ),
        
        const SizedBox(height: 8),

        //baris 2 - icon + kota
        Row(children: const [
          Text("Alamat : ",
          style: TextStyle(fontSize: 16),
          ),
          Icon(Icons.location_on),
          SizedBox(width: 4),
          Text("Jakarta",
          style: TextStyle(fontSize: 16),
          ),
        ],
        ),
        //baris 3 - deskripsi
        Text("Seorang pelajar yang sedang belajar Flutter.", 
        style: TextStyle(fontSize: 14)),
        ],
      ),
    );
  }
}