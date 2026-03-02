import 'package:flutter/material.dart';
import 'package:belajar_flutter_rezy/day_16/view/login_screen.dart';

import '../models/user_model.dart';
import '../database/sqflite.dart';

class Register_Screen extends StatefulWidget {
  const Register_Screen({super.key});

  @override
  State<Register_Screen> createState() => _Register_ScreenState();
}

class _Register_ScreenState extends State<Register_Screen> {
  final _formKey = GlobalKey<FormState>();

  final namaController = TextEditingController();
  final gmailController = TextEditingController();
  final passwordController = TextEditingController();

  bool isObscure = true;

  /// regex password
  final passwordRegex = RegExp(r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{6,}$');

  /// ===============================
  /// REGISTER FUNCTION (FINAL)
  /// ===============================
  void handleRegister() async {
    if (!_formKey.currentState!.validate()) return;

    final user = UserModel(
      nama: namaController.text.trim(),
      gmail: gmailController.text.trim(),
      password: passwordController.text.trim(),
    );

    try {
      await DBHelper().insertUser(user);

      if (!mounted) return;

      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text("Berhasil"),
          content: const Text("Akun berhasil dibuat"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);

                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                );
              },
              child: const Text("Login"),
            ),
          ],
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Gmail sudah terdaftar")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 40),

                Image.asset("assets/images/LogoTPQ.jpeg"),

                const SizedBox(height: 20),

                const Text(
                  "Daftar Akun",
                  style: TextStyle(
                    fontFamily: "Poppins",
                    fontSize: 26,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 8),

                const Text(
                  "Silakan isi data pendaftaran",
                  style: TextStyle(color: Colors.grey),
                ),

                const SizedBox(height: 35),

                /// ================= NAMA
                TextFormField(
                  controller: namaController,
                  decoration: InputDecoration(
                    labelText: "Username",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  validator: (value) =>
                      value!.isEmpty ? "Nama wajib diisi" : null,
                ),

                const SizedBox(height: 18),

                /// ================= GMAIL
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
                    if (!value.contains("@gmail.com")) {
                      return "Gunakan gmail @gmail.com";
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 18),

                /// ================= PASSWORD
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
                    if (!passwordRegex.hasMatch(value)) {
                      return "Minimal 6 karakter & huruf + angka";
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 28),

                /// ================= BUTTON
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: handleRegister,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0F9D58),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: const Text(
                      "Daftar",
                      style: TextStyle(
                        fontFamily: "Poppins",
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                Center(
                  child: TextButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (_) => const LoginScreen()),
                      );
                    },
                    child: const Text(
                      "Sudah punya akun? Login",
                      style: TextStyle(fontFamily: "Poppins"),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
