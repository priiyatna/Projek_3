import 'package:flutter/material.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFD9ECFF), // Warna background biru muda
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 50),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Tombol Back
            IconButton(
              icon: const Icon(Icons.arrow_back, size: 28),
              onPressed: () {
                Navigator.pop(context); // Kembali ke halaman sebelumnya
              },
            ),

            const SizedBox(height: 20),

            // Judul Register
            const Text(
              "Daftar",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),

            // Deskripsi
            const Text(
              "Masukkan Nama, Email, Password, dan Confirm Password untuk mendaftar di Toko Deryko.",
              style: TextStyle(fontSize: 16),
            ),

            const SizedBox(height: 30),

            // Form Register
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 5,
                    spreadRadius: 2,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Nama"),
                  const SizedBox(height: 5),
                  TextField(
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.blue[50],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),

                  const SizedBox(height: 15),

                  const Text("Email Address"),
                  const SizedBox(height: 5),
                  TextField(
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.blue[50],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),

                  const SizedBox(height: 15),

                  const Text("Password"),
                  const SizedBox(height: 5),
                  TextField(
                    obscureText: true,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.blue[50],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),

                  const SizedBox(height: 15),

                  const Text("Confirm Password"),
                  const SizedBox(height: 5),
                  TextField(
                    obscureText: true,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.blue[50],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Tombol Register
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {}, // Tambahkan fungsi register
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        "Register",
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
