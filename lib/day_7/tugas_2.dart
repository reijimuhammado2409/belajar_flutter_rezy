import 'package:flutter/material.dart';

class Tugas2 extends StatelessWidget {
  const Tugas2({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //Judul AppBar
      appBar: AppBar(backgroundColor: const Color.fromARGB(255, 2, 130, 12),
      title: Text("Profil Hero"),
      centerTitle: true,
      ),
      body : Column(
        // mainAxisAlignment: MainAxisAlignment.center,
        
        crossAxisAlignment: CrossAxisAlignment.start,
        //baris 1 - Nama Apps
        
        children: [
          const SizedBox(height: 20),
          Center(
            child: Text("Al-HAFIZH",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),            
            ),
          ),

          //baris 6 - foto saya taruh diatas

           SizedBox(height: 20),

          Container(
            width: double.infinity,
            height: 60,
            child: Center(child: Image.asset("assets/images/priasolo.jpg")),
          ),

        const SizedBox(height: 10),

        //baris 2  - detail kontak/informasi 
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 255, 255, 255),
              borderRadius: BorderRadius.circular(12),
              
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const[
                Row(
                  children: [
                    Icon(Icons.person),
                    SizedBox(width: 8),
                    Text("Email :", 
                    style: TextStyle(
                      fontSize: 15,
                    ),
                    ),
                    Spacer(),
                    Text("fufufafa@gmail.com",
                    style: TextStyle(
                      fontSize: 15,
                    ),
                    ),
                  ],
                ),
                // baris 2 
                 Row(
                  children: [
                    Icon(Icons.phone),
                    SizedBox(width: 8),
                    Text("No Telp : ",
                    style: TextStyle(
                      fontSize:15,
                    ),
                    ),
                    Spacer(),
                    Text("+62 877 6655 4433",
                    style: TextStyle(
                      fontSize: 15,
                    ),
                    ),
                  ],
                 ),
                 Row(
                  children: [
                    Icon(Icons.location_on),
                    SizedBox(width: 8),
                    Text("Alamat : ",
                    style: TextStyle(
                      fontSize: 15,
                    ),
                    ),
                    Spacer(),
                    Text("Antartika",
                    style: TextStyle(
                      fontSize: 15,
                    ),
                    ),
                  ],
                 ),
              ],
            ),
          ),
          ),

          // baris 3 aksi & informasi

          Padding(padding: const EdgeInsetsGeometry.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Row(
            children: const[
              Icon(Icons.grade),
              SizedBox(width: 8),
              Text("Jenjang"),
              Spacer(),
              Text("2 SD"),
            ],
          ),         
          ),
          Padding(padding: const EdgeInsetsGeometry.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Row(
            children: const[
              Icon(Icons.grade),
              SizedBox(width: 8),
              Text("Umur"),
              Spacer(),
              Text("8 thn"),
            ],
          ),         
          ),

          //baris 4 - Area Statistik dan horizontal
          Padding(padding: const EdgeInsetsGeometry.symmetric(horizontal: 16.0),
          child: Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  margin: const EdgeInsets.only(left: 8),
                  decoration: BoxDecoration(
                    color: Colors.green[200],
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: const Column(
                    children: [
                      Text("Baik",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                      ),
                      Text("Sikap & Perilaku"),
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
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: const Column(
                    children: [
                      Text("IQRO 2",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                      ),
                      Text("Level Iqro/Quran"),
                    ],
                  ),
              ),
              ),
            ],
          ),
          ),

          //Baris 5 - Naratif

          const SizedBox(height: 20),

          const Padding(padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            "Fufufafa adalah seorang murid dari TPQ Al-Mu'minin."
            " selama pembelajaran Fufufafa adalah murid yang berperilaku baik."
            " Tidak hanya berperilaku baik, Fufufafa telah menunjukkan hasil"
            "dari proses yang sekarang sudah mencapai Iqro 2 di jenjangnya."
            ),
          ),

          SizedBox(height: 20),

          Container(
            height: 80,
            width: double.infinity,
            color: const Color.fromARGB(255, 2, 130, 12),
            child: const Center(
              child: Text(
                "Al-Hafizh App 2026",
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