import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final emailController = TextEditingController();
  final auth = FirebaseAuth.instance;

  void resetPassword() async {
    try {
      await auth.sendPasswordResetEmail(email: emailController.text.trim());
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Berhasil'),
          content: const Text('Link reset telah dikirim ke email kamu.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Tutup dialog
                Navigator.pop(context); // Kembali ke login
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
    } on FirebaseAuthException catch (e) {
      String message = 'Terjadi kesalahan.';
      if (e.code == 'user-not-found') {
        message = 'Email tidak ditemukan.';
      } else if (e.code == 'invalid-email') {
        message = 'Format email tidak valid.';
      }

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Gagal'),
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Lupa Kata Sandi')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Masukkan email untuk mereset kata sandi.'),
            const SizedBox(height: 20),
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: resetPassword,
              child: const Text('Kirim Link Reset'),
            ),
          ],
        ),
      ),
    );
  }
}
