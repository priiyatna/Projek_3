import 'package:flutter/material.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 216, 231, 255), // biru muda background
      body: Column(
        children: [
          // Area atas (gambar + logo)
          Container(
            height: 350, // tinggi background gambar
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
              image: const DecorationImage(
                image: AssetImage('assets/background_top.png'), // Gambar background kamu
                fit: BoxFit.cover,
              ),
            ),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Positioned(
                  bottom: -40, // supaya bulatannya "menggantung"
                  left: 10,
                  right: 10,
                  child: Center(
                    child: CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.white,
                      child: ClipOval(
                        child: Image.asset(
                          'assets/logo1.png', // Logo di tengah
                          width: 125,
                          height: 125,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 60), // jarak dari logo

          // Text Selamat Datang
          const Text(
            'Selamat Datang Di Toko Deryko',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Poppins', // FONT lebih keren, pastikan Poppins sudah di pubspec.yaml
              fontSize: 21,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 32.0),
            child: Text(
              'Toko Deryko menghadirkan aplikasi untuk memudahkan para konsumen dalam memenuhi kebutuhan sehari-hari.',
              textAlign: TextAlign.center, // <-- TENGAH
              style: TextStyle(
                fontSize: 16,
                color: Colors.black54,
                height: 1.5, // supaya spasi antar baris nyaman dibaca
              ),
            ),
          ),

          const SizedBox(height: 40),

          // Tombol Masuk & Daftar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Tombol Masuk
                OutlinedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/login');
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFF1976D2), // teks biru
                    backgroundColor: Colors.white, // background putih
                    side: const BorderSide(color: Color(0xFF1976D2)), // border biru
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Masuk',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                // Tombol Daftar
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/register');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1976D2), // background biru
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 4,
                  ),
                  child: const Text(
                    'Daftar',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white, // teks putih
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
