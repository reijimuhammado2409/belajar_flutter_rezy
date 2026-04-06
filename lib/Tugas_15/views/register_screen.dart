// tugas_15/views/register_screen.dart
import 'package:flutter/material.dart';
import 'package:belajar_flutter_rezy/Tugas_15/services/api_service.dart';
import 'package:belajar_flutter_rezy/Tugas_15/widgets/custom_textfield.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  // TextEditingController untuk tiap field input
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  // GlobalKey untuk validasi form
  final _formKey = GlobalKey<FormState>();

  // State loading
  bool _isLoading = false;

  @override
  void dispose() {
    // Dispose semua controller untuk mencegah memory leak
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  /// Fungsi register — dipanggil saat tombol Daftar ditekan
  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;

    // Tampilkan loading
    setState(() => _isLoading = true);

    // Panggil API register
    final result = await ApiService.register(
      name: _nameController.text.trim(),
      email: _emailController.text.trim(),
      password: _passwordController.text,
      phone: _phoneController.text.trim(),
      address: _addressController.text.trim(),
    );

    // Sembunyikan loading
    if (mounted) setState(() => _isLoading = false);

    if (!mounted) return;

    if (result['success'] == true) {
      // Register berhasil → tampilkan pesan sukses lalu kembali ke login
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Registrasi berhasil! Silakan login.'),
          backgroundColor: Colors.green.shade600,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );

      // Tunggu sebentar lalu kembali ke halaman login
      await Future.delayed(const Duration(seconds: 1));
      if (mounted) Navigator.pop(context);
    } else {
      // Tampilkan pesan error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result['message'] ?? 'Registrasi gagal'),
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
      appBar: AppBar(
        title: const Text('Buat Akun Baru'),
        centerTitle: true,
        backgroundColor: colorScheme.primary,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // ── Header ──
                Center(
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: colorScheme.primary.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.person_add_rounded,
                      size: 40,
                      color: colorScheme.primary,
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                Text(
                  'Lengkapi Data Diri',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 24),

                // ── Field Nama ──
                CustomTextField(
                  controller: _nameController,
                  label: 'Nama Lengkap',
                  hint: 'Masukkan nama lengkap',
                  prefixIcon: Icons.person_outline,
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'Nama wajib diisi';
                    if (value.length < 3) return 'Nama minimal 3 karakter';
                    return null;
                  },
                ),
                const SizedBox(height: 14),

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
                const SizedBox(height: 14),

                // ── Field Nomor HP ──
                CustomTextField(
                  controller: _phoneController,
                  label: 'Nomor HP (opsional)',
                  hint: '08xxxxxxxxxx',
                  prefixIcon: Icons.phone_outlined,
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: 14),

                // ── Field Alamat ──
                CustomTextField(
                  controller: _addressController,
                  label: 'Alamat (opsional)',
                  hint: 'Masukkan alamat lengkap',
                  prefixIcon: Icons.location_on_outlined,
                  maxLines: 2,
                ),
                const SizedBox(height: 14),

                // ── Field Password ──
                CustomTextField(
                  controller: _passwordController,
                  label: 'Password',
                  hint: 'Minimal 6 karakter',
                  prefixIcon: Icons.lock_outline,
                  isPassword: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'Password wajib diisi';
                    if (value.length < 6) return 'Password minimal 6 karakter';
                    return null;
                  },
                ),
                const SizedBox(height: 14),

                // ── Field Konfirmasi Password ──
                CustomTextField(
                  controller: _confirmPasswordController,
                  label: 'Konfirmasi Password',
                  hint: 'Ulangi password',
                  prefixIcon: Icons.lock_reset_outlined,
                  isPassword: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'Konfirmasi password wajib diisi';
                    // Validasi password harus cocok
                    if (value != _passwordController.text) return 'Password tidak cocok';
                    return null;
                  },
                ),
                const SizedBox(height: 28),

                // ── Tombol Daftar ──
                SizedBox(
                  height: 52,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _register,
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
                            'Daftar',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                  ),
                ),
                const SizedBox(height: 16),

                // ── Link kembali ke Login ──
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Sudah punya akun? ',
                      style: TextStyle(color: Colors.grey.shade600),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.pop(context), // Kembali ke LoginScreen
                      child: Text(
                        'Login',
                        style: TextStyle(
                          color: colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}