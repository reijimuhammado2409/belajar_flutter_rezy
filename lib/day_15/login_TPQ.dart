// import 'package:belajar_flutter_rezy/day_14/dashb0ardTPQ.dart';
// import 'package:belajar_flutter_rezy/day_14/mainNavigation.dart';
import 'package:flutter/material.dart';
import 'register_TPQ.dart';
import 'dashboard_TPQ.dart';
import 'navbar/bottom_navigation.dart';
import 'navbar/drawer.dart';

class Login_TPQ extends StatefulWidget {
  const Login_TPQ({super.key});

  @override
  State<Login_TPQ> createState() => _Login_TPQState();
}

class _Login_TPQState extends State<Login_TPQ> {

  final _formKey = GlobalKey<FormState>();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool isObscure = true;
  bool isLoading = false;

  void handleLogin() async {

    if (!_formKey.currentState!.validate()) return;

    setState(() {
      isLoading = true;
    });

    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      isLoading = false;
    });

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const BottomNavigation()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),

            child: Form(
              key: _formKey,

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  const SizedBox(height: 40),

                  Image.asset("assets/images/LogoTPQ.jpeg"),

                  const SizedBox(height: 20),

                  const Text(
                    "Login Tes!",
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

                  /// EMAIL
                  TextFormField(
                    controller: emailController,
                    decoration: InputDecoration(
                      labelText: "Email",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Email wajib diisi";
                      }
                      if (!value.endsWith("@gmail.com")) {
                        return "Gunakan @gmail.com";
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 18),

                  /// PASSWORD
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
                                fontWeight: FontWeight.w600),
                            ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  Center(
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const Register_TPQ()),
                        );
                      },
                      child: const Text(
                        "Belum punya akun? Daftar",
                        style: TextStyle(fontFamily: "Poppins"),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}