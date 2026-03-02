import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/user_model.dart';
import '../models/siswa_model.dart';

class DBHelper {
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await initDB();
    return _database!;
  }

  /// ===============================
  /// INIT DATABASE
  /// ===============================
  Future<Database> initDB() async {
    final path = join(await getDatabasesPath(), 'tpq.db');

    return await openDatabase(
      path,
      version: 2, // 🔥 NAIKKAN VERSION
      onCreate: (db, version) async {
        /// TABLE USERS
        await db.execute('''
          CREATE TABLE users(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            nama TEXT,
            gmail TEXT UNIQUE,
            password TEXT
          )
        ''');

        /// TABLE SISWA
        await db.execute('''
          CREATE TABLE siswa(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            nama TEXT,
            email TEXT,
            noHp TEXT,
            kota TEXT
          )
        ''');
      },

      /// kalau update database lama
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          await db.execute('''
            CREATE TABLE siswa(
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              nama TEXT,
              email TEXT,
              noHp TEXT,
              kota TEXT
            )
          ''');
        }
      },
    );
  }

  /// INSERT USER
  Future<int> insertUser(UserModel user) async {
    final db = await database;
    return await db.insert(
      'users',
      user.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  /// LOGIN USER
  Future<UserModel?> loginUser(String gmail, String password) async {
    final db = await database;

    final result = await db.query(
      'users',
      where: 'gmail = ? AND password = ?',
      whereArgs: [gmail, password],
    );

    if (result.isNotEmpty) {
      return UserModel.fromMap(result.first);
    }
    return null;
  }

  /// INSERT SISWA
  Future<int> insertSiswa(SiswaModel siswa) async {
    final db = await database;
    return await db.insert('siswa', siswa.toMap());
  }

  /// GET ALL SISWA
  Future<List<SiswaModel>> getAllSiswa() async {
    final db = await database;
    final result = await db.query('siswa');
    return result.map((e) => SiswaModel.fromMap(e)).toList();
  }
}
