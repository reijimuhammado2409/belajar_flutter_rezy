import 'package:flutter/material.dart';

class SoalList extends StatefulWidget {
  const SoalList({super.key});

  @override
  State<SoalList> createState() => _SoalListState();
}

class _SoalListState extends State<SoalList> {

  final List<String> levelList = const [
    "Iqro 1",
    "Iqro 2",
    "Iqro 3",
    "Iqro 4",
    "Iqro 5",
    "Iqro 6",
    "Juz 30",
    "Al-Qur'an",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Daftar Level Santri"),
        centerTitle: true,
      ),

      body: ListView.builder(
        padding: const EdgeInsets.all(16),

        itemCount: levelList.length,
        itemBuilder: (context, index) {
          return Card(
            margin: const EdgeInsets.only(bottom: 12),

            child: ListTile(
              leading: const Icon(Icons.menu_book),

              title: Text(levelList[index]),

              subtitle: Text("Level ke-${index + 1}"),

              trailing: const Icon(
                Icons.arrow_forward_ios,
                size: 16,
              ),

              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("${levelList[index]} dipilih"),
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