import 'package:belajar_flutter_rezy/day_16/view/navbar/bottomNavbar_screen.dart';
import 'package:flutter/material.dart';
import '../database/preference.dart';
import '../database/sqflite.dart';
import '../models/user_model.dart';
import 'dashboard_screen.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  /// ===============================
  /// FORM KEY
  /// ===============================
  final _formKey = GlobalKey<FormState>();

  /// CONTROLLER INPUT
  final TextEditingController gmailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  /// DATABASE HELPER
  final DBHelper dbHelper = DBHelper();

  bool isObscure = true;
  bool isLoading = false;

  /// ===============================
  /// FUNCTION LOGIN (SQFLITE AUTH)
  /// ===============================
  void handleLogin() async {
    /// validasi form dulu
    if (!_formKey.currentState!.validate()) return;

    setState(() => isLoading = true);

    /// ambil input user
    final gmail = gmailController.text.trim();
    final password = passwordController.text.trim();

    /// cek user di database
    UserModel? user = await dbHelper.loginUser(gmail, password);

    setState(() => isLoading = false);

    /// jika user ditemukan
    if (user != null) {
      /// simpan status login
      await Preferences.setLogin(true);

      /// pindah ke dashboard
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => BottomNavbar(nama: user.nama, gmail: user.gmail),
        ),
      );
    } else {
      /// jika login gagal
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Gmail atau Password salah"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  /// ===============================
  /// DISPOSE CONTROLLER
  /// ===============================
  @override
  void dispose() {
    gmailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  /// ===============================
  /// UI LOGIN
  /// ===============================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24),

            child: Form(
              key: _formKey,

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 40),

                  /// LOGO
                  Image.asset("assets/images/LogoTPQ.jpeg"),

                  const SizedBox(height: 20),

                  const Text(
                    "Login",
                    style: TextStyle(
                      fontFamily: "Poppins",
                      fontSize: 26,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  const SizedBox(height: 8),

                  const Text(
                    "Silakan masuk untuk melanjutkan",
                    style: TextStyle(color: Colors.grey),
                  ),

                  const SizedBox(height: 35),

                  /// ===============================
                  /// INPUT GMAIL
                  /// ===============================
                  TextFormField(
                    controller: gmailController,
                    decoration: InputDecoration(
                      labelText: "Gmail",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Gmail wajib diisi";
                      }
                      if (!value.endsWith("@gmail.com")) {
                        return "Gunakan @gmail.com";
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 18),

                  /// ===============================
                  /// INPUT PASSWORD
                  /// ===============================
                  TextFormField(
                    controller: passwordController,
                    obscureText: isObscure,
                    decoration: InputDecoration(
                      labelText: "Password",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          isObscure ? Icons.visibility_off : Icons.visibility,
                        ),
                        onPressed: () {
                          setState(() {
                            isObscure = !isObscure;
                          });
                        },
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Password wajib diisi";
                      }
                      if (value.length < 6) {
                        return "Minimal 6 karakter";
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 28),

                  /// ===============================
                  /// BUTTON LOGIN
                  /// ===============================
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0F9D58),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      onPressed: isLoading ? null : handleLogin,
                      child: isLoading
                          ? const SizedBox(
                              height: 18,
                              width: 18,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Text(
                              "Login",
                              style: TextStyle(
                                fontFamily: "Poppins",
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  /// PINDAH REGISTER
                  Center(
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const Register_Screen(),
                          ),
                        );
                      },
                      child: const Text(
                        "Belum punya akun? Daftar",
                        style: TextStyle(fontFamily: "Poppins"),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
