import 'package:flutter/material.dart';

class PesananScreen extends StatelessWidget {
  const PesananScreen({super.key});

  @override
  Widget build(BuildContext context) {
    List<Map<String, String>> pesananList = [
      {'nama': 'MINYAK GORENG CURAH', 'berat': '1 kg', 'harga': 'Rp 20.000', 'status': 'Dikemas'},
      {'nama': 'GULA PASIR CURAH', 'berat': '1 kg', 'harga': 'Rp 18.000', 'status': 'Selesai'},
      {'nama': 'TEPUNG SEGITIGA BIRU', 'berat': '1 kg', 'harga': 'Rp 12.000', 'status': 'Selesai'},
      {'nama': 'TEPUNG MAIZENAKU', 'berat': '100 gr', 'harga': 'Rp 5.000', 'status': 'Selesai'},
      {'nama': 'GULA MERAH', 'berat': '1 kg', 'harga': 'Rp 15.000', 'status': 'Selesai'},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('PESANAN SAYA', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.blue[200],
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: pesananList.length,
        itemBuilder: (context, index) {
          final pesanan = pesananList[index];
          return Column(
            children: [
              ListTile(
                title: Text(
                  pesanan['nama']!,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(pesanan['berat']!),
                    Text(
                      pesanan['harga']!,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text('Total 1 Produk: ${pesanan['harga']}'),
                  ],
                ),
                trailing: Text(
                  pesanan['status']!,
                  style: TextStyle(
                    color: pesanan['status'] == 'Dikemas' ? Colors.blue : Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const Divider(),
            ],
          );
        },
      ),
    );
  }
}
