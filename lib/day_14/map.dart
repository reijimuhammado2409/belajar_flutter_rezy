import 'package:flutter/material.dart';

class SoalMap extends StatefulWidget {
  const SoalMap({super.key});

  @override
  State<SoalMap> createState() => _SoalMapState();
}

class _SoalMapState extends State<SoalMap> {

  final List<Map<String, dynamic>> levelList = const [
    {"nama": "Iqro 1", "icon": Icons.looks_one},
    {"nama": "Iqro 2", "icon": Icons.looks_two},
    {"nama": "Iqro 3", "icon": Icons.looks_3},
    {"nama": "Iqro 4", "icon": Icons.looks_4},
    {"nama": "Iqro 5", "icon": Icons.looks_5},
    {"nama": "Iqro 6", "icon": Icons.looks_6},
    {"nama": "Juz Amma", "icon": Icons.menu_book},
    {"nama": "Al-Qur'an", "icon": Icons.book},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Daftar Level (MAP)"),
        centerTitle: true,
      ),

      body: ListView.builder(
        padding: const EdgeInsets.all(16),

        itemCount: levelList.length,
        itemBuilder: (context, index) {

          final item = levelList[index];

          return Card(
            margin: const EdgeInsets.only(bottom: 12),

            child: ListTile(
              leading: Icon(item["icon"]),

              title: Text(item["nama"]),

              subtitle: Text("Data MAP ke-${index + 1}"),

              trailing: const Icon(
                Icons.arrow_forward_ios,
                size: 16,
              ),

              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("${item["nama"]} dipilih"),
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