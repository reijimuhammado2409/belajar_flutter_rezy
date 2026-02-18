import 'package:flutter/material.dart';

class Tugas3 extends StatelessWidget {
  const Tugas3({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 2, 130, 12),
        title: const Text("Input & Galeri Santri"),
        centerTitle: true,
      ),
      
      /// 1. single child scroll view sebagai 
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              /// judul aplikasi              
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

              /// 2. Formulir Input Data Santri
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
                  labelText: "Nama Santri",
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 12),

              const TextField(
                decoration: InputDecoration(
                  labelText: "Umur",
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 12),

              const TextField(
                decoration: InputDecoration(
                  labelText: "Jenjang / Level",
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 12),

              const TextField(
                decoration: InputDecoration(
                  labelText: "Alamat",
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 24),

              /// 3. Galeri Kegiatan TPQ 
              const Text(
                "Galeri Kegiatan TPQ",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 12),

              
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,

                /// 4. Label di atas Gambar (stack)

                children: List.generate(6, (index) {
                  return Stack(
                    children: [

                      /// Kotak warna / gambar
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.green[200],
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),

                      /// Label di atas
                      Positioned(
                        bottom: 10,
                        left: 10,
                        child: Text(
                          "Kegiatan ${index + 1}",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  );
                }),
              ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
