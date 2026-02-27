import 'package:flutter/material.dart';
import '../database/preference.dart';
import 'login_screen.dart';

/// =================================
/// SPLASH SCREEN FINAL VERSION
/// =================================
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  /// status login disimpan sementara
  bool isLogin = false;

  @override
  void initState() {
    super.initState();
    startSplash();
  }

  /// =================================
  /// FUNCTION UTAMA SPLASH
  /// =================================
  void startSplash() async {

    /// 1️⃣ ambil status login dulu
    isLogin = await Preferences.getLogin();

    /// 2️⃣ paksa splash tampil 5 detik
    await Future.delayed(const Duration(seconds: 3));

    /// cegah error jika widget sudah dispose
    if (!mounted) return;

    /// 3️⃣ navigasi setelah delay selesai
    if (isLogin) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const LoginScreen(
            
          ),
        ),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const LoginScreen(),
        ),
      );
    }
  }

  /// =================================
  /// UI SPLASH
  /// =================================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            /// LOGO APP
            Image.asset(
              'assets/images/LogoTPQ.jpeg',
              width: 150,
            ),

            const SizedBox(height: 20),

            /// NAMA APLIKASI
            const Text(
              "AL-HAFIZH",
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),

            const SizedBox(height: 25),

            /// LOADING
            const CircularProgressIndicator(
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}