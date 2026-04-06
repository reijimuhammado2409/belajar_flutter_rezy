// tugas_15/views/login_screen.dart
import 'package:flutter/material.dart';
import 'package:belajar_flutter_rezy/Tugas_15/services/api_service.dart';
import 'package:belajar_flutter_rezy/Tugas_15/widgets/custom_textfield.dart';
import 'package:belajar_flutter_rezy/Tugas_15/views/register_screen.dart';
import 'package:belajar_flutter_rezy/Tugas_15/views/profile_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // TextEditingController untuk mengambil input dari user
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // GlobalKey untuk validasi form
  final _formKey = GlobalKey<FormState>();

  // State loading untuk menampilkan indikator saat proses login
  bool _isLoading = false;

  @override
  void dispose() {
    // Dispose controller saat widget dihancurkan untuk mencegah memory leak
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  /// Fungsi login — dipanggil saat tombol Login ditekan
  Future<void> _login() async {
    // Validasi form terlebih dahulu
    if (!_formKey.currentState!.validate()) return;

    // Tampilkan loading menggunakan setState
    setState(() => _isLoading = true);

    // Panggil API login
    final result = await ApiService.login(
      email: _emailController.text.trim(),
      password: _passwordController.text,
    );

    // Sembunyikan loading
    if (mounted) setState(() => _isLoading = false);

    if (!mounted) return;

    if (result['success'] == true) {
      // Login berhasil → navigasi ke ProfileScreen
      // Gunakan pushReplacement agar tidak bisa kembali ke login
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const ProfileScreen()),
      );
    } else {
      // Tampilkan pesan error menggunakan SnackBar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result['message'] ?? 'Login gagal'),
          backgroundColor: Colors.red.shade600,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 40),

                // ── Header / Ilustrasi ──
                Center(
                  child: Container(
                    width: 90,
                    height: 90,
                    decoration: BoxDecoration(
                      color: colorScheme.primary.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.lock_rounded,
                      size: 44,
                      color: colorScheme.primary,
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                Text(
                  'Selamat Datang!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Login untuk melanjutkan',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                ),
                const SizedBox(height: 40),

                // ── Field Email ──
                CustomTextField(
                  controller: _emailController,
                  label: 'Email',
                  hint: 'contoh@email.com',
                  prefixIcon: Icons.email_outlined,
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'Email wajib diisi';
                    if (!value.contains('@')) return 'Format email tidak valid';
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // ── Field Password ──
                CustomTextField(
                  controller: _passwordController,
                  label: 'Password',
                  hint: 'Masukkan password',
                  prefixIcon: Icons.lock_outline,
                  isPassword: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'Password wajib diisi';
                    if (value.length < 6) return 'Password minimal 6 karakter';
                    return null;
                  },
                ),
                const SizedBox(height: 28),

                // ── Tombol Login ──
                SizedBox(
                  height: 52,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _login,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colorScheme.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 2,
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2.5,
                            ),
                          )
                        : const Text(
                            'Login',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                  ),
                ),
                const SizedBox(height: 20),

                // ── Link ke Register ──
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Belum punya akun? ',
                      style: TextStyle(color: Colors.grey.shade600),
                    ),
                    GestureDetector(
                      onTap: () {
                        // Navigasi ke RegisterScreen
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const RegisterScreen()),
                        );
                      },
                      child: Text(
                        'Daftar Sekarang',
                        style: TextStyle(
                          color: colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}