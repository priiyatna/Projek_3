import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background dengan warna biru yang lebih lembut
          Container(
            color: Colors.lightBlue[100],
          ),

          // Konten Utama
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
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

                  // Judul Masuk
                  const Text(
                    "Masuk",
                    style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 8),

                  // Deskripsi
                  const Text(
                    "Masukkan email dan password untuk masuk ke aplikasi Toko Deryko",
                    style: TextStyle(fontSize: 16, color: Colors.black87),
                  ),

                  const SizedBox(height: 30),

                  // Card Form Login
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
                        // Label Email
                        const Text(
                          "Email",
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(height: 5),

                        // Input Email
                        TextField(
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.grey[200],
                            hintText: "Masukkan email",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide.none,
                            ),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          ),
                        ),

                        const SizedBox(height: 15),

                        // Label Password
                        const Text(
                          "Password",
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(height: 5),

                        // Input Password
                        TextField(
                          obscureText: true,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.grey[200],
                            hintText: "Masukkan password",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide.none,
                            ),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          ),
                        ),

                        const SizedBox(height: 10),

                        // Remember Me & Forgot Password
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Checkbox(value: false, onChanged: (value) {}),
                                const Text("Remember Me"),
                              ],
                            ),
                            TextButton(
                              onPressed: () {},
                              child: const Text(
                                "Lupa Kata sandi?",
                                style: TextStyle(color: Colors.blue),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 10),

                        // Tombol Login
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: const Text(
                              "Login",
                              style: TextStyle(fontSize: 16, color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Link ke Daftar
                  Center(
                    child: TextButton(
                      onPressed: () {},
                      child: const Text.rich(
                        TextSpan(
                          text: "Belum punya akun? ",
                          style: TextStyle(color: Colors.black),
                          children: [
                            TextSpan(
                              text: "Daftar Sekarang",
                              style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
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
        ],
      ),
    );
  }
}
