import 'package:flutter/material.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFDFEFFF),
      body: Column(
        children: [
          // Header biru dengan border lengkung
          Stack(
            children: [
              Container(
                width: double.infinity,
                height: 220,
                decoration: const BoxDecoration(
                  color: Color(0xFF226DFF), // Warna biru atas
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(40),
                    bottomRight: Radius.circular(40),
                  ),
                ),
              ),
              Positioned(
                bottom: -40,
                left: MediaQuery.of(context).size.width / 2 - 70,
                child: const CircleAvatar(
                  radius: 70,
                  backgroundColor: Color(0xFFB2DBFF), // bulatan biru muda
                ),
              ),
            ],
          ),

          const SizedBox(height: 60), // Jarak setelah lingkaran

          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                Text(
                  'Selamat Datang di Toko Deryko',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 12),
                Text(
                  'Toko Deryko  menghadirkan  aplikasi untuk memudahkan para konsumen dalam memenuhi kebutuhan sehari hari.',
                  style: TextStyle(fontSize: 14, color: Colors.black),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),

          const Spacer(),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/login');
                    },
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.blue),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: const Text(
                      'Masuk',
                      style: TextStyle(color: Colors.blue),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/register');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue[700],
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: const Text('Daftar',
                     style: TextStyle(
                      color: Colors.white,
                     ),
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
