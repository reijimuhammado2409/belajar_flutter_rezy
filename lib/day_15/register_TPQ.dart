import 'package:flutter/material.dart';
import 'login_TPQ.dart'; // sesuaikan kalau nama file login beda

class Register_TPQ extends StatefulWidget {
  const Register_TPQ({super.key});

  @override
  State<Register_TPQ> createState() => _Register_TPQState();
}

class _Register_TPQState extends State<Register_TPQ> {

  final _formKey = GlobalKey<FormState>();

  final namaController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final hpController = TextEditingController();

  bool isObscure = true;

  // REGEX PASSWORD
  final passwordRegex =
      RegExp(r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{6,}$');

  void handleRegister() {

    if (_formKey.currentState!.validate()) {

      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text("Data Pendaftaran"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Nama: ${namaController.text}"),
              Text("Email: ${emailController.text}"),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);

                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const Login_TPQ(),
                  ),
                );
              },
              child: const Text("Lanjut"),
            )
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
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

                /// NAMA
                TextFormField(
                  controller: namaController,
                  decoration: InputDecoration(
                    labelText: "Username",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Nama wajib diisi";
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 18),

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
                    if (!value.contains("@gmail.com")) {
                      return "Gunakan email @gmail.com";
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
                    if (!passwordRegex.hasMatch(value)) {
                      return "Minimal 6 karakter & kombinasi huruf + angka";
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
                    onPressed: handleRegister,
                    child: const Text(
                      "Daftar",
                      style: TextStyle(
                        fontFamily: "Poppins",
                        fontSize: 15,
                        fontWeight: FontWeight.w600),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                Center(
                  child: TextButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                          MaterialPageRoute(
                          builder: (_) => const Login_TPQ(),
                        ),
                      );
                    },
                    child: const Text(
                      "Sudah punya akun? Login",
                          style: TextStyle(
                          fontFamily: "Poppins"
                        ),
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