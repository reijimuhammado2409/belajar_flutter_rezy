import 'package:flutter/material.dart';
import '../database/sqflite.dart';
import '../models/siswa_model.dart';

class DataSiswaScreen extends StatefulWidget {
  const DataSiswaScreen({super.key});

  @override
  State<DataSiswaScreen> createState() => _DataSiswaScreenState();
}

class _DataSiswaScreenState extends State<DataSiswaScreen> {
  final db = DBHelper();

  final namaC = TextEditingController();
  final emailC = TextEditingController();
  final hpC = TextEditingController();
  final kotaC = TextEditingController();

  List<SiswaModel> siswaList = [];

  final formKey = GlobalKey<FormState>();

  SiswaModel? selectedSiswa; // untuk mode edit

  /// LOAD DATA
  Future<void> loadData() async {
    siswaList = await db.getAllSiswa();
    setState(() {});
  }

  /// SIMPAN DATA
  Future<void> simpanData() async {
    if (!formKey.currentState!.validate()) return;

    if (selectedSiswa == null) {
      /// INSERT
      await db.insertSiswa(
        SiswaModel(
          nama: namaC.text,
          email: emailC.text,
          noHp: hpC.text,
          kota: kotaC.text,
        ),
      );
    } else {
      ///UPDATE
      await db.updateSiswa(
        SiswaModel(
          id: selectedSiswa!.id,
          nama: namaC.text,
          email: emailC.text,
          noHp: hpC.text,
          kota: kotaC.text,
        ),
      );
      selectedSiswa = null;
    }

    namaC.clear();
    emailC.clear();
    hpC.clear();
    kotaC.clear();

    loadData(); // refresh list
  }

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Widget input(String label, TextEditingController c) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: c,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
        validator: (v) => v == null || v.isEmpty ? "$label wajib diisi" : null,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Pendaftaran Al Hafiz")),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            /// ===== FORM =====
            Form(
              key: formKey,
              child: Column(
                children: [
                  input("Nama", namaC),
                  input("Email", emailC),
                  input("Nomor HP", hpC),
                  input("Asal Kota", kotaC),

                  ElevatedButton(
                    onPressed: simpanData,
                    child: Text(selectedSiswa == null ? "Simpan" : "Update"),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            /// ===== LIST DATA =====
            Expanded(
              child: ListView.builder(
                itemCount: siswaList.length,
                itemBuilder: (context, index) {
                  final data = siswaList[index];

                  return Card(
                    child: ListTile(
                      title: Text(data.nama),
                      subtitle: Text("${data.email} • ${data.kota}"),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ///EDIT
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.blue),
                            onPressed: () {
                              setState(() {
                                selectedSiswa = data;
                                namaC.text = data.nama;
                                emailC.text = data.email;
                                hpC.text = data.noHp;
                                kotaC.text = data.kota;
                              });
                            },
                          ),

                          /// DELETE
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () async {
                              await DBHelper().deleteSiswa(data.id!);
                              loadData();
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
