import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final addressController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  final auth = FirebaseAuth.instance;

  void register() async {
    String name = nameController.text.trim();
    String email = emailController.text.trim();
    String address = addressController.text.trim();
    String phone = phoneController.text.trim();
    String password = passwordController.text;
    String confirmPassword = confirmPasswordController.text;

    if (name.isEmpty || email.isEmpty || address.isEmpty || phone.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
      showErrorDialog('Semua field wajib diisi.');
      return;
    }

    final nameRegex = RegExp(r'^[a-zA-Z\s]{3,}$');
    if (!nameRegex.hasMatch(name)) {
      showErrorDialog('Nama harus minimal 3 karakter dan hanya boleh huruf.');
      return;
    }

    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(email)) {
      showErrorDialog('Format email tidak valid.');
      return;
    }

    final phoneRegex = RegExp(r'^[0-9]{10,}$');
    if (!phoneRegex.hasMatch(phone)) {
      showErrorDialog('No HP harus berupa angka dan minimal 10 digit.');
      return;
    }

    if (password.length < 6) {
      showErrorDialog('Password minimal 6 karakter.');
      return;
    }

    if (password != confirmPassword) {
      showErrorDialog('Password dan Konfirmasi tidak cocok.');
      return;
    }

    try {
      // Daftar akun ke Firebase Authentication
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Simpan data user tambahan ke Cloud Firestore
      await FirebaseFirestore.instance.collection('users').doc(userCredential.user!.uid).set({
        'name': name,
        'email': email,
        'address': address,
        'phone': phone,
        'createdAt': FieldValue.serverTimestamp(), // Optional: Tanggal pendaftaran
      });

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Registrasi Berhasil'),
          content: const Text('Akun berhasil dibuat. Silakan login.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // tutup dialog
                Navigator.pop(context); // kembali ke login screen
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
    } catch (e) {
      showErrorDialog('Terjadi kesalahan: $e');
    }
  }

  void showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Registrasi Gagal'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const BackButton(color: Colors.black),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/register.png'), // Ganti sesuai asset kamu
            fit: BoxFit.cover,
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(top: 100, bottom: 40),
          child: Column(
            children: [
              Text(
                'Daftar',
                style: GoogleFonts.poppins(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Masukkan Nama, Email, Alamat, No HP, Password dan Konfirmasi untuk membuat akun.',
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(fontSize: 14, color: Colors.black87),
              ),
              const SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Card(
                  elevation: 6,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                    child: Column(
                      children: [
                        buildField('Nama', nameController),
                        const SizedBox(height: 12),
                        buildField('Email', emailController),
                        const SizedBox(height: 12),
                        buildField('Alamat', addressController),
                        const SizedBox(height: 12),
                        buildField('No Hp', phoneController, keyboardType: TextInputType.phone),
                        const SizedBox(height: 12),
                        buildField('Password', passwordController, obscure: true),
                        const SizedBox(height: 12),
                        buildField('Konfirmasi Password', confirmPasswordController, obscure: true),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: register,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue[600],
                            foregroundColor: Colors.white,
                            elevation: 8,
                            shadowColor: Colors.blueAccent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                            textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ).copyWith(
                            elevation: MaterialStateProperty.resolveWith<double>((states) {
                              if (states.contains(MaterialState.pressed)) {
                                return 2;
                              }
                              return 8;
                            }),
                          ),
                          child: const Text('Daftar'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildField(String label, TextEditingController controller,
      {bool obscure = false, TextInputType keyboardType = TextInputType.text}) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.blue[50],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      style: GoogleFonts.poppins(),
    );
  }
}
