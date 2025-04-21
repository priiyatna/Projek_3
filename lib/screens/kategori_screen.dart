import 'package:flutter/material.dart';

class KategoriScreen extends StatelessWidget {
  final String kategori;

  const KategoriScreen({super.key, required this.kategori});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(kategori),
        backgroundColor: Colors.blue[200],
      ),
      body: Center(
        child: Text('Daftar produk untuk kategori $kategori akan ditampilkan di sini'),
      ),
    );
  }
}
