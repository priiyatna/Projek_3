import 'package:flutter/material.dart';
import 'welcome_screen.dart'; // Import WelcomeScreen

class AkunScreen extends StatelessWidget {
  const AkunScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'AKUN SAYA',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blue[200],
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: () {
              _logout(context);
            },
            child: const Text(
              'Logout',
              style: TextStyle(color: Colors.black),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            color: Colors.blue[100],
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Center(
              child: CircleAvatar(
                radius: 40,
                backgroundColor: Colors.white,
                child: Icon(
                  Icons.person,
                  size: 40,
                  color: Colors.grey[400],
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16.0),
              children: [
                buildListTile('Nama'),
                buildListTile('Alamat'),
                buildListTile('No Handphone'),
                buildListTile('Email'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _logout(BuildContext context) {
    // Aksi logout (hapus session, token, dll jika ada)
    
    // Arahkan ke WelcomeScreen dan hapus history agar tidak bisa kembali dengan tombol back
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const WelcomeScreen()),
      (Route<dynamic> route) => false, // Hapus semua history navigasi
    );
  }

  Widget buildListTile(String title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(color: Colors.grey.shade300),
            ),
          ),
          child: Text(
            title,
            style: const TextStyle(fontSize: 16),
          ),
        ),
      ],
    );
  }
}
