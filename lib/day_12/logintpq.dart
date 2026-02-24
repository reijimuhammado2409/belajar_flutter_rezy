import 'package:belajar_flutter_rezy/day_12/dashboardTPQ.dart';
import 'package:belajar_flutter_rezy/day_12/main_navigation.dart';
import 'package:flutter/material.dart';
import 'dashboardTPQ.dart';
import 'main_navigation.dart';

class LoginTPQ extends StatefulWidget {
  const LoginTPQ({super.key});

  @override
  State<LoginTPQ> createState() => _LoginTPQState();
}

class _LoginTPQState extends State<LoginTPQ> {

  bool isObscure = true;
  bool isLoading = false;

  void handleLogin() async {

    setState(() {
      isLoading = true;
    });

    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      isLoading = false;
    });

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const MainNavigation()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Image.asset("assets/images/LogoTPQ.jpeg",),

            const Text(
              "Login Tes",
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

            TextField(
              decoration: InputDecoration(
                labelText: "Username",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),

            const SizedBox(height: 18),

            TextField(
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
            )
          ],
        ),
      ),
    );
  }
}