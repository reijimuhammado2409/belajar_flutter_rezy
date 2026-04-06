// tugas_15/models/user_model.dart

/// Model untuk data User dari API
class UserModel {
  final int? id;
  final String? name;
  final String? email;
  final String? phone;
  final String? address;
  final String? token; // Token hanya ada saat login/register

  UserModel({
    this.id,
    this.name,
    this.email,
    this.phone,
    this.address,
    this.token,
  });

  /// Buat UserModel dari JSON (response API)
  factory UserModel.fromJson(Map<String, dynamic> json) {
    // Ambil data dari 'data' jika ada, atau langsung dari root json
    final data = json['data'] ?? json['user'] ?? json;

    return UserModel(
      id: data['id'],
      name: data['name'],
      email: data['email'],
      phone: data['phone'] ?? data['no_hp'] ?? data['hp'] ?? '',
      address: data['address']  ?? data['alamat'] ?? '',
      token: json['token'] ?? json['access_token'], // Token ada di root response (bukan di dalam 'data')
    );
  }

  /// Konversi UserModel ke JSON (untuk kirim ke API)
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (email != null) 'email': email,
      if (phone != null) 'phone': phone,
      if (address != null) 'address': address,
    };
  }

  /// CopyWith untuk update sebagian field
  UserModel copyWith({
    int? id,
    String? name,
    String? email,
    String? phone,
    String? address,
    String? token,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      token: token ?? this.token,
    );
  }

  @override
  String toString() {
    return 'UserModel(id: $id, name: $name, email: $email, phone: $phone, address: $address)';
  }
}