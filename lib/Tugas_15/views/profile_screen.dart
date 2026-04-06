// tugas_15/views/profile_screen.dart
import 'package:flutter/material.dart';
import 'package:belajar_flutter_rezy/Tugas_15/models/user_model.dart';
import 'package:belajar_flutter_rezy/Tugas_15/services/api_service.dart';
import 'package:belajar_flutter_rezy/Tugas_15/views/edit_profile_screen.dart';
import 'package:belajar_flutter_rezy/Tugas_15/views/login_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // Future untuk FutureBuilder — menyimpan hasil pemanggilan API getProfile
  late Future<UserModel> _profileFuture;

  @override
  void initState() {
    super.initState();
    // Panggil getProfile saat pertama kali screen dibuka
    _loadProfile();
  }

  /// Inisialisasi atau refresh future untuk FutureBuilder
  void _loadProfile() {
    setState(() {
      _profileFuture = ApiService.getProfile();
    });
  }

  /// Fungsi logout — hapus token dan kembali ke LoginScreen
  Future<void> _logout() async {
    // Tampilkan dialog konfirmasi
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Konfirmasi Logout'),
        content: const Text('Apakah Anda yakin ingin logout?'),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Logout', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      // Hapus token dari SharedPreferences
      await ApiService.clearToken();

      if (!mounted) return;

      // Navigasi ke LoginScreen, hapus semua stack
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text('Profil Saya'),
        centerTitle: true,
        backgroundColor: colorScheme.primary,
        foregroundColor: Colors.white,
        automaticallyImplyLeading: false, // Tidak ada tombol back
        actions: [
          // Tombol Logout
          IconButton(
            icon: const Icon(Icons.logout_rounded),
            tooltip: 'Logout',
            onPressed: _logout,
          ),
        ],
      ),

      // Tombol Edit Profile di pojok kanan bawah
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          // Tunggu hasil dari EditProfileScreen
          // Jika kembali dengan true → reload profil
          final updatedUser = await Navigator.push<UserModel?>(
            context,
            MaterialPageRoute(builder: (_) => const EditProfileScreen()),
          );

          // Jika data berhasil diupdate, refresh profil menggunakan setState
          if (updatedUser != null) {
            setState(() {
              _profileFuture = Future.value(updatedUser);
            });
                    }
        },
        icon: const Icon(Icons.edit_rounded),
        label: const Text('Edit Profil'),
        backgroundColor: colorScheme.primary,
        foregroundColor: Colors.white,
      ),

      body: FutureBuilder<UserModel>(
        // future: hasil dari ApiService.getProfile()
        future: _profileFuture,
        builder: (context, snapshot) {
          // ── State: Loading ──
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Memuat profil...', style: TextStyle(color: Colors.grey)),
                ],
              ),
            );
          }

          // ── State: Error ──
          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 60, color: Colors.red.shade300),
                  const SizedBox(height: 16),
                  Text(
                    snapshot.error.toString(),
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey.shade700),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                    onPressed: _loadProfile, // Coba lagi
                    icon: const Icon(Icons.refresh),
                    label: const Text('Coba Lagi'),
                  ),
                ],
              ),
            );
          }

          // ── State: Data tersedia ──
          if (!snapshot.hasData) {
            return const Center(child: Text('Tidak ada data'));
          }

          final user = snapshot.data!;

          return RefreshIndicator(
            onRefresh: () async => _loadProfile(), // Pull to refresh
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  const SizedBox(height: 20),

                  // ── Avatar ──
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          colorScheme.primary,
                          colorScheme.secondary,
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: colorScheme.primary.withOpacity(0.3),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        // Tampilkan inisial nama
                        user.name != null && user.name!.isNotEmpty
                            ? user.name![0].toUpperCase()
                            : '?',
                        style: const TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // ── Nama User ──
                  Text(
                    user.name ?? 'Tidak ada nama',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: colorScheme.primary,
                    ),
                  ),
                  Text(
                    user.email ?? '',
                    style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                  ),
                  const SizedBox(height: 28),

                  // ── Card Info Profil ──
                  Card(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                      side: BorderSide(color: Colors.grey.shade200),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Informasi Akun',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: colorScheme.primary,
                            ),
                          ),
                          const Divider(height: 24),

                          // Baris info: ID
                          _buildInfoRow(
                            icon: Icons.tag_rounded,
                            label: 'ID Pengguna',
                            value: user.id?.toString() ?? '-',
                          ),
                          const SizedBox(height: 16),

                          // Baris info: Nama
                          _buildInfoRow(
                            icon: Icons.person_outline,
                            label: 'Nama Lengkap',
                            value: user.name ?? '-',
                          ),
                          const SizedBox(height: 16),

                          // Baris info: Email
                          _buildInfoRow(
                            icon: Icons.email_outlined,
                            label: 'Email',
                            value: user.email ?? '-',
                          ),
                          const SizedBox(height: 16),

                          // Baris info: Nomor HP
                          _buildInfoRow(
                            icon: Icons.phone_outlined,
                            label: 'Nomor HP',
                            value: user.phone ?? '-',
                          ),
                          const SizedBox(height: 16),

                          // Baris info: Alamat
                          _buildInfoRow(
                            icon: Icons.location_on_outlined,
                            label: 'Alamat',
                            value: user.address ?? '-',
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 80), // Space untuk FAB
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  /// Widget helper untuk baris info profil
  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: Colors.grey.shade500),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade500,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}