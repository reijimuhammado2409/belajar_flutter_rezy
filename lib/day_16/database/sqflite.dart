import 'package:belajar_flutter_rezy/day_16/models/user_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DBHelper{
  static Future<Database> db() async{
     final dbPath = await getDatabasesPath();
     return openDatabase(
      join(dbPath, 'al-hafizh.db'),
      onCreate: (db, version){
        return db.execute(
          'CREATE TABEL iser (id INTEGER PRIMARY KEY, email TEXT, password TEXT)'
        );
      },
      version: 1,
     );
  }

  static Future<void>registerUser(UserModel user) async{
    final dbs = await db();
    await dbs.insert('user', user.toMap());
  }

  static Future<UserModel?> loginUser({
    required String email,
    required String password,
  })async{
    final dbs = await db();
    final List<Map<String, dynamic>> results = await dbs.query(
      "User",
      where: 'email = ? AND passworrd = ?',
      whereArgs: [email, password],
      );
      if(results.isNotEmpty){
        return UserModel.fromMap(results.first);
      }
      return null;
  }
}