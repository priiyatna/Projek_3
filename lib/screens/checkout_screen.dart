import 'package:flutter/material.dart';

class CheckoutScreen extends StatelessWidget {
  final List<Map<String, dynamic>> produkDipesan;

  const CheckoutScreen({super.key, required this.produkDipesan});

  int getTotalHarga() {
    return produkDipesan.fold<int>(0, (total, item) => total + (item['harga'] as int));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CHECKOUT', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.blue[200],
        centerTitle: true,
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.grey.shade300)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Alamat Pengiriman',
                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
                ),
                const Text('Wahyudin | (+62) 859-5240-4092'),
                const Text('Gang Kampung KB, RT.010/RW.003 Gegesik, Cirebon, Jawa Barat'),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: produkDipesan.length,
              itemBuilder: (context, index) {
                final item = produkDipesan[index];
                return ListTile(
                   leading: Image.asset(
                    item['gambar'] ?? 'assets/default.jpg',
                    width: 50,
                    errorBuilder: (context, error, stackTrace) {
                      return Icon(Icons.image_not_supported, size: 50, color: Colors.grey);
                    },
                  ),
                  title: Text(
                    item['nama'], // Nama produk
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    'Rp ${item['harga'].toString()}', // Harga produk
                    style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
                  ),
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border(top: BorderSide(color: Colors.grey.shade300)),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Total Pembayaran', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    Text(
                      'Rp${getTotalHarga()}',
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blue),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end, // Posisi tombol di pojok kanan
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      onPressed: () {
                        // Implementasi proses pemesanan
                      },
                      child: const Text('Buat Pesanan', style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
