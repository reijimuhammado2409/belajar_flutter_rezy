import 'package:shared_preferences/shared_preferences.dart';

class Preferences {

  static const String isLoginKey = "login_screen";

  /// simpan status login
  static Future<void> setLogin(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(isLoginKey, value);
  }

  /// ambil status login
  static Future<bool> getLogin() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(isLoginKey) ?? false;
  }

  /// logout
  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(isLoginKey);
  }
}