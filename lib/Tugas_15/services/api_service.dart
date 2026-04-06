// tugas_15/services/api_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';

/// Service untuk semua komunikasi dengan API
class ApiService {
  // Base URL API
  static const String baseUrl = 'https://absensib1.mobileprojp.com';

  // Key untuk SharedPreferences
  static const String _tokenKey = 'token';

  static const String _userKey = 'user';

  static Future<void> saveUser(UserModel user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userKey, jsonEncode(user.toJson()));
  }

  static Future<UserModel?> getSavedUser() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(_userKey);
    if (data != null) {
      return UserModel.fromJson(jsonDecode(data));
    }
    return null;
  }

  // ─────────────────────────────────────────────
  //  SHARED PREFERENCES HELPERS
  // ─────────────────────────────────────────────

  /// Simpan token ke SharedPreferences
  static Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
  }

  /// Ambil token dari SharedPreferences
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  /// Hapus token (logout)
  static Future<void> clearToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
  }

  // ─────────────────────────────────────────────
  //  REGISTER (POST)
  // ─────────────────────────────────────────────

  /// Register user baru
  /// Endpoint: POST /api/register
  static Future<Map<String, dynamic>> register({
    required String name,
    required String email,
    required String password,
    String? phone,
    String? address,
  }) async {
    try {
      final url = Uri.parse('$baseUrl/api/register');

      // Buat body request
      final body = {
        'name': name,
        'email': email,
        'password': password,
        if (phone != null && phone.isNotEmpty) 'phone': phone,
        if (address != null && address.isNotEmpty) 'address': address,
      };

      // Kirim request POST
      final response = await http
          .post(
            url,
            headers: {'Content-Type': 'application/json', 'Accept': 'application/json'},
            body: jsonEncode(body),
          )
          .timeout(const Duration(seconds: 30));

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return {'success': true, 'data': data};
      } else {
        // Ambil pesan error dari response
        final message = data['message'] ?? data['error'] ?? 'Registrasi gagal';
        return {'success': false, 'message': message};
      }
    } catch (e) {
      return {'success': false, 'message': 'Koneksi gagal: $e'};
    }
  }

  // ─────────────────────────────────────────────
  //  LOGIN (POST)
  // ─────────────────────────────────────────────

  /// Login user dan simpan token
  /// Endpoint: POST /api/login
  static Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    try {
      final url = Uri.parse('$baseUrl/api/login');

      final body = {
        'email': email,
        'password': password,
      };

      // Kirim request POST login
      final response = await http
          .post(
            url,
            headers: {'Content-Type': 'application/json', 'Accept': 'application/json'},
            body: jsonEncode(body),
          )
          .timeout(const Duration(seconds: 30));

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        // Ambil token dari response dan simpan ke SharedPreferences
        String? token;

        if (data['token'] != null) {
          token = data['token'];
        } else if (data['access_token'] != null) {
          token = data['access_token'];
        } else if (data['data'] != null && data['data']['token'] != null) {
          token = data['data']['token'];
        }

        print("TOKEN DARI API: $token"); // DEBUG

        if (token != null) {
          await saveToken(token);
        } else {
          print("TOKEN NULL BRO ❌");
        }

        // Buat UserModel dari response
        final user = UserModel.fromJson(data);

        final oldUser = await getSavedUser();

        final mergedUser = user.copyWith(
          id: user.id,
          name: user.name,
          email: user.email,
          phone: oldUser?.phone,
          address: oldUser?.address,
        );

        await saveUser(mergedUser);

        return {'success': true, 'user': mergedUser, 'token': token};
      } else {
        final message = data['message'] ?? data['error'] ?? 'Login gagal';
        return {'success': false, 'message': message};
      }
    } catch (e) {
      return {'success': false, 'message': 'Koneksi gagal: $e'};
    }
  }

  // ─────────────────────────────────────────────
  //  GET PROFILE (GET dengan token)
  // ─────────────────────────────────────────────

  /// Ambil data profil user yang sedang login
  /// Endpoint: GET /api/user atau /api/profile
  static Future<UserModel> getProfile() async {
    // Ambil token dari SharedPreferences
    final token = await getToken();

    if (token == null) {
      throw Exception('Token tidak ditemukan. Silakan login ulang.');
    }

    final url = Uri.parse('$baseUrl/api/profile');

    // Kirim GET request dengan Authorization header
    final response = await http
        .get(
          url,
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer $token', // Sertakan token di header
          },
        )
        .timeout(const Duration(seconds: 30));

      print("STATUS: ${response.statusCode}");
      print("BODY: ${response.body}");
      print("TOKEN DIPAKAI: $token");

    if (response.statusCode == 200) {
      print("ISI JSON: ${response.body}");
      final data = jsonDecode(response.body);
      print("RESPONSE PROFILE: ${response.body}");
      
      final apiUser = UserModel.fromJson(data);

      // ambil data local
      final localUser = await getSavedUser();

      return apiUser.copyWith(
        id: apiUser.id,
        name: apiUser.name,
        email: apiUser.email,
        phone: localUser?.phone ?? apiUser.phone,
        address: localUser?.address ?? apiUser.address,
      );

    } else if (response.statusCode == 401) {
      // Token tidak valid atau expired
      await clearToken();
      throw Exception('Sesi habis. Silakan login ulang.');
    } else {
      throw Exception('Gagal mengambil profil: ${response.statusCode}');
    }
  }

  // ─────────────────────────────────────────────
  //  EDIT PROFILE (PUT dengan token)
  // ─────────────────────────────────────────────

  /// Update data profil user
  /// Endpoint: PUT /api/user atau /api/profile
  static Future<Map<String, dynamic>> updateProfile({
    required String name,
    required String email,
    String? phone,
    String? address,
    String? password, // Opsional, hanya jika ingin ganti password
  }) async {
    try {
      // Ambil token dari SharedPreferences
      final token = await getToken();

      if (token == null) {
        return {'success': false, 'message': 'Token tidak ditemukan. Silakan login ulang.'};
      }

      final url = Uri.parse('$baseUrl/api/profile');

      // Body yang akan dikirim
      final body = <String, dynamic>{
        'name': name,
        'email': email,
        if (phone != null && phone.isNotEmpty) 'phone': phone,
        if (address != null && address.isNotEmpty) 'address': address,
        if (password != null && password.isNotEmpty) 'password': password,
      };

      // Kirim PUT request dengan token di header
      final response = await http
          .put(
            url,
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
              'Authorization': 'Bearer $token',
            },
            body: jsonEncode(body),
          )
          .timeout(const Duration(seconds: 30));

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        final oldUser = await getSavedUser();

        final updatedUser = UserModel(
          id: oldUser?.id,
          name: name,
          email: email,
          phone: phone,
          address: address,
        );

        await saveUser(updatedUser);

        return {'success': true, 'data': data};
      } else if (response.statusCode == 401) {
        await clearToken();
        return {'success': false, 'message': 'Sesi habis. Silakan login ulang.'};
      } else {
        final message = data['message'] ?? data['error'] ?? 'Gagal update profil';
        return {'success': false, 'message': message};
      }
    } catch (e) {
      return {'success': false, 'message': 'Koneksi gagal: $e'};
    }
  }
}