import 'package:flutter/material.dart';

class Tugas5 extends StatefulWidget {
  const Tugas5({super.key});

  @override
  State<Tugas5> createState() => _Tugas5State();
}

class _Tugas5State extends State<Tugas5> {
  bool showName = false;
  bool isStarred = false;
  bool showInfo = false;
  bool showActivity = false;

  int hafalanCounter = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: const Text("Interaksi Santri TPQ"),
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        onPressed: () {
          setState(() {
            hafalanCounter--;
          });
        },
        child: const Icon(Icons.remove),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            /// 1️ ElevatedButton
            ElevatedButton(
              onPressed: () {
                setState(() {
                  showName = !showName;
                });
              },
              child: const Text("Tampilkan Nama Santri"),
            ),

            if (showName)
              const Text("Nama saya: Fachri Fahrezy"),

            const SizedBox(height: 20),

            /// 2️ IconButton
            Row(
              children: [
                IconButton(
                  onPressed: () {
                    setState(() {
                      isStarred = !isStarred;
                    });
                  },
                  icon: Icon(
                    Icons.star,
                    color: isStarred ? Colors.amber : Colors.grey,
                  ),
                ),

                if (isStarred)
                  const Text("Santri Teladan"),
              ],
            ),

            /// 3️ TextButton
            TextButton(
              onPressed: () {
                setState(() {
                  showInfo = !showInfo;
                });
              },
              child: const Text("Lihat Selengkapnya"),
            ),

            if (showInfo)
              const Text("TPQ Al-Hafizh adalah tempat belajar Al-Qur'an."),

            const SizedBox(height: 20),

            /// 4️ InkWell (Ripple Fix)
            Material(
              color: Colors.green,

              child: InkWell(
                onTap: () {
                  setState(() {
                    showActivity = !showActivity;
                  });

                  print("Kotak disentuh!");
                },

                child: const Padding(
                  padding: EdgeInsets.all(12),
                  child: Text(
                    "Aktivitas Hari Ini",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),

            if (showActivity)
              const Text("Hari ini belajar Surah Al-Ikhlas"),

            const SizedBox(height: 30),

            /// 5️ GestureDetector
            GestureDetector(
              onTap: () {
                setState(() {
                  hafalanCounter += 1;
                });
                print("Ditekan sekali");
              },

              onDoubleTap: () {
                setState(() {
                  hafalanCounter += 2;
                });
                print("Ditekan dua kali");
              },

              onLongPress: () {
                setState(() {
                  hafalanCounter += 3;
                });
                print("Tahan lama");
              },

              child: Container(
                padding: const EdgeInsets.all(16),
                color: Colors.grey[300],
                child: Text(
                  "Jumlah Hafalan: $hafalanCounter",
                  style: const TextStyle(fontSize: 18),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
