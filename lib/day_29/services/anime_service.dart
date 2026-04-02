import 'dart:async'; // <-- tambah ini!
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../models/anime_model.dart';

class AnimeService {
  static const String _baseUrl = 'https://api.jikan.moe/v4';
  static const Duration _timeout = Duration(seconds: 10); // fix loading lama!

  Future<AnimeModel> fetchAnime({int page = 1}) async {
    try {
      final response = await http
          .get(Uri.parse('$_baseUrl/anime?page=$page'))
          .timeout(_timeout);

      if (response.statusCode == 200) {
        return animeModelFromJson(response.body);
      } else if (response.statusCode == 429) {
        throw Exception('Rate limit! Tunggu sebentar...');
      } else {
        throw Exception('Server error: ${response.statusCode}');
      }
    } on SocketException {
      throw Exception('Tidak ada koneksi internet');
    } on TimeoutException {
      throw Exception('Request timeout, coba lagi');
    }
  }
}