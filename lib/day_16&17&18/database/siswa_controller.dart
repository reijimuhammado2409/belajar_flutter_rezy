// import 'dart:ffi';

// import 'package:belajar_flutter_rezy/day_16/database/sqflite.dart';
// import 'package:belajar_flutter_rezy/day_16/models/Siswa_model.dart';

// class SiswaController {
//     static Future<void>registerSiswa(SiswaModel siswa) async{
//     final dbs = await DBHelper.db();
//     await dbs.insert('siswa', siswa.toMap());
//     print(siswa.toMap());
//   }

//   static Future<List<SiswaModel>> getAllSiswa() async{
//     final dbs = await DBHelper.db();
//     final List<Map<String,dynamic>> results =await dbs.query("siswa");
//     print(results.map((e) => SiswaModel.fromMap(e)).toList());
//     return (results.map((e) => SiswaModel.fromMap(e)).toList());
//   }
// }
