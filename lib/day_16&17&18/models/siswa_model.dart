class SiswaModel {
  final int? id;
  final String nama;
  final String email;
  final String noHp;
  final String kota;

  SiswaModel({
    this.id,
    required this.nama,
    required this.email,
    required this.noHp,
    required this.kota,
  });

  /// object → database
  Map<String, dynamic> toMap() {
    return {'id': id, 'nama': nama, 'email': email, 'noHp': noHp, 'kota': kota};
  }

  /// database → object
  factory SiswaModel.fromMap(Map<String, dynamic> map) {
    return SiswaModel(
      id: map['id'],
      nama: map['nama'] ?? '',
      email: map['email'] ?? '',
      noHp: map['noHp'] ?? '',
      kota: map['kota'] ?? '',
    );
  }
}
