import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'register_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFD9ECFF), // Warna background biru muda
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Bagian Atas (Background Biru dengan Profil di Tengah)
          Stack(
            clipBehavior: Clip.none,
            children: [
              // Background Biru
              Container(
                height: MediaQuery.of(context).size.height * 0.35,
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Color(0xFF004AAD), // Warna biru tua
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                ),
              ),

              // Foto Profil dalam Lingkaran Putih
              Positioned(
                left: MediaQuery.of(context).size.width * 0.5 - 55, // Tengah layar
                bottom: -50, // Posisi di tengah antara biru & putih
                child: Container(
                  width: 110,
                  height: 110,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white, // Background putih
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 5,
                        spreadRadius: 2,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(5),
                    child: ClipOval(
                      child: Image.asset(
                        'assets/logo.png', // Ganti dengan path gambar profil
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 60), // Spacer agar konten turun

          // Judul Selamat Datang
          const Text(
            "Selamat Datang di Toko Deryko",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 10),

          // Deskripsi
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 30),
            child: Text(
              "Toko Deryko menghadirkan aplikasi untuk memudahkan para konsumen dalam memenuhi kebutuhan sehari-hari.",
              style: TextStyle(fontSize: 16, color: Colors.black),
              textAlign: TextAlign.center,
            ),
          ),

          const Spacer(),

          // Tombol Masuk & Daftar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Tombol Masuk
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginScreen(),
                        ),
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.blue),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      "Masuk",
                      style: TextStyle(fontSize: 16, color: Colors.blue),
                    ),
                  ),
                ),

                const SizedBox(width: 20),

                // Tombol Daftar
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const RegisterScreen(), // Navigasi ke halaman Register
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      "Daftar",
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
