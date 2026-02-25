import 'package:flutter/material.dart';

class Produk {
  final String nama;
  final String deskripsi;
  final String gambar;

  Produk({
    required this.nama,
    required this.deskripsi,
    required this.gambar,
  });
}

class SoalModel extends StatefulWidget {
  const SoalModel({super.key});

  @override
  State<SoalModel> createState() => _SoalModelState();
}

class _SoalModelState extends State<SoalModel> {

  final List<Produk> produkList = [
    Produk(
      nama: "Iqro 1",
      deskripsi: "Belajar huruf hijaiyah dasar",
      gambar: "assets/images/Iqro.jpg",
    ),
    Produk(
      nama: "Iqro 2",
      deskripsi: "Belajar lanjutan tajwid dasar",
      gambar: "assets/images/Iqro.jpg",
    ),
    Produk(
      nama: "Iqro 3",
      deskripsi: "Mulai membaca lebih lancar",
      gambar: "assets/images/Iqro.jpg",
    ),
    Produk(
      nama: "Iqro 4",
      deskripsi: "Pendalaman makhraj huruf",
      gambar: "assets/images/Iqro.jpg",
    ),
    Produk(
      nama: "Iqro 5",
      deskripsi: "Pendalaman makhraj huruf",
      gambar: "assets/images/Iqro.jpg",
    ),
    Produk(
      nama: "Iqro 6",
      deskripsi: "Pendalaman makhraj huruf",
      gambar: "assets/images/Iqro.jpg",
    ),
    Produk(
      nama: "Juz Amma",
      deskripsi: "Hafalan surat pendek",
      gambar: "assets/images/Iqro.jpg",
    ),
    Produk(
      nama: "Al-Qur'an",
      deskripsi: "Pembelajaran penuh Al-Qur'an",
      gambar: "assets/images/Iqro.jpg",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("List Model"),
        centerTitle: true,
      ),

      body: ListView.builder(
        padding: const EdgeInsets.all(16),

        itemCount: produkList.length,
        itemBuilder: (context, index) {

          final produk = produkList[index];

          return Card(
            margin: const EdgeInsets.only(bottom: 12),

            child: ListTile(
              leading: Image.asset(
                produk.gambar,
                width: 40,
              ),

              title: Text(produk.nama),

              subtitle: Text(produk.deskripsi),

              trailing: const Icon(
                Icons.arrow_forward_ios,
                size: 16,
              ),

              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("${produk.nama} dipilih"),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}