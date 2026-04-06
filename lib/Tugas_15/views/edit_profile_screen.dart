// tugas_15/views/edit_profile_screen.dart
import 'package:flutter/material.dart';
import 'package:belajar_flutter_rezy/Tugas_15/models/user_model.dart';
import 'package:belajar_flutter_rezy/Tugas_15/services/api_service.dart';
import 'package:belajar_flutter_rezy/Tugas_15/widgets/custom_textfield.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  // TextEditingController untuk tiap field
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // GlobalKey untuk validasi form
  final _formKey = GlobalKey<FormState>();

  // State loading untuk fetch awal dan saat submit
  bool _isLoading = true;    // true saat pertama kali fetch data
  bool _isSaving = false;    // true saat sedang menyimpan

  @override
  void initState() {
    super.initState();
    // Ambil data profil saat layar pertama dibuka
    _fetchAndFillProfile();
  }

  @override
  void dispose() {
    // Dispose semua controller
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  /// Ambil data profil dan isi ke dalam controller
  Future<void> _fetchAndFillProfile() async {
    try {
      final user = await ApiService.getProfile();

      if (mounted) {
        // Isi controller dengan data yang sudah ada menggunakan setState
        setState(() {
          _nameController.text = user.name ?? '';
          _emailController.text = user.email ?? '';
          _phoneController.text = user.phone ?? '';
          _addressController.text = user.address ?? '';
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal memuat data: $e'),
            backgroundColor: Colors.red.shade600,
          ),
        );
      }
    }
  }

  /// Simpan perubahan profil ke API
  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    // Tampilkan loading saat menyimpan menggunakan setState
    setState(() => _isSaving = true);

    // Panggil API update profil (PUT)
    final result = await ApiService.updateProfile(
      name: _nameController.text.trim(),
      email: _emailController.text.trim(),
      phone: _phoneController.text.trim(),
      address: _addressController.text.trim(),
      // Kirim password hanya jika diisi (tidak kosong)
      password: _passwordController.text.isNotEmpty ? _passwordController.text : null,
    );

    // Sembunyikan loading
    if (mounted) setState(() => _isSaving = false);

    if (!mounted) return;

    if (result['success'] == true) {
      // Berhasil → tampilkan snackbar sukses
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Profil berhasil diperbarui!'),
          backgroundColor: Colors.green.shade600,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
    final oldUser = await ApiService.getProfile(); // ✅ TAMBAHIN INI

    final updatedUser = UserModel(
          id: oldUser.id,
          name: _nameController.text,
          email: _emailController.text,
          phone: _phoneController.text,
          address: _addressController.text,
    );

      // Kembali ke ProfileScreen dengan membawa nilai true
      // Nilai true ini akan ditangkap oleh ProfileScreen untuk refresh data
      Navigator.pop(context, updatedUser);
    } else {
      // Gagal → tampilkan pesan error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result['message'] ?? 'Gagal memperbarui profil'),
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
        title: const Text('Edit Profil'),
        centerTitle: true,
        backgroundColor: colorScheme.primary,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.pop(context, null), // Kembali tanpa update
        ),
      ),

      body: _isLoading
          // ── Tampilkan loading saat fetch awal ──
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Memuat data...', style: TextStyle(color: Colors.grey)),
                ],
              ),
            )
          // ── Tampilkan form setelah data berhasil dimuat ──
          : SingleChildScrollView(
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
                          Icons.edit_rounded,
                          size: 38,
                          color: colorScheme.primary,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Perbarui Informasi Anda',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: colorScheme.primary,
                      ),
                    ),
                    const SizedBox(height: 28),

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
                      label: 'Nomor HP',
                      hint: '08xxxxxxxxxx',
                      prefixIcon: Icons.phone_outlined,
                      keyboardType: TextInputType.phone,
                    ),
                    const SizedBox(height: 14),

                    // ── Field Alamat ──
                    CustomTextField(
                      controller: _addressController,
                      label: 'Alamat',
                      hint: 'Masukkan alamat lengkap',
                      prefixIcon: Icons.location_on_outlined,
                      maxLines: 2,
                    ),
                    const SizedBox(height: 14),

                    // ── Field Password (opsional) ──
                    CustomTextField(
                      controller: _passwordController,
                      label: 'Password Baru (opsional)',
                      hint: 'Kosongkan jika tidak ingin ubah password',
                      prefixIcon: Icons.lock_reset_outlined,
                      isPassword: true,
                      validator: (value) {
                        // Hanya validasi jika diisi
                        if (value != null && value.isNotEmpty && value.length < 6) {
                          return 'Password minimal 6 karakter';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),

                    // Keterangan password opsional
                    Padding(
                      padding: const EdgeInsets.only(left: 4),
                      child: Text(
                        '* Kosongkan field password jika tidak ingin mengubahnya',
                        style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                      ),
                    ),
                    const SizedBox(height: 28),

                    // ── Tombol Simpan ──
                    SizedBox(
                      height: 52,
                      child: ElevatedButton.icon(
                        onPressed: _isSaving ? null : _saveProfile,
                        icon: _isSaving
                            ? const SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : const Icon(Icons.save_rounded),
                        label: Text(
                          _isSaving ? 'Menyimpan...' : 'Simpan Perubahan',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: colorScheme.primary,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 2,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // ── Tombol Batal ──
                    SizedBox(
                      height: 52,
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context, false),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: colorScheme.primary,
                          side: BorderSide(color: colorScheme.primary),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'Batal',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
    );
  }
}