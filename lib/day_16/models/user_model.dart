import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class UserModel {
  final int? id;
  final String nama;
  final String gmail;
  final String password;
  UserModel({
    this.id,
    required this.nama,
    required this.gmail,
    required this.password,
  });

  /// object -> map(masuk ke database)
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'nama': nama,
      'gmail': gmail,
      'password': password,
    };
  }

  /// map databse -> object
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'],
      nama: map['nama'] ?? '',
      gmail: map['gmail'] ?? '',
      password: map['password'] ?? '',
    );
  }

  ///object -> json
  String toJson() => json.encode(toMap());

  ///json -> object
  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
