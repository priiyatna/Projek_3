import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ManageOrdersScreen extends StatelessWidget {
  const ManageOrdersScreen({super.key});

  String generateResi() {
    final random = Random();
    final number = List.generate(8, (_) => random.nextInt(10)).join();
    return 'DERYKO$number';
  }

  void _updateStatus(String orderId, String userId, String newStatus) async {
    try {
      final firestore = FirebaseFirestore.instance;
      await firestore.collection('orders').doc(orderId).update({'status': newStatus});
      await firestore.collection('users').doc(userId).collection('orders').doc(orderId).update({'status': newStatus});
      debugPrint("✅ Status pesanan $orderId diperbarui ke '$newStatus'");
    } catch (e) {
      debugPrint("❌ Gagal update status: $e");
    }
  }

  void _deleteOrder(String orderId, String userId) async {
    try {
      final firestore = FirebaseFirestore.instance;
      await firestore.collection('orders').doc(orderId).delete();
      await firestore.collection('users').doc(userId).collection('orders').doc(orderId).delete();
      debugPrint("✅ Pesanan $orderId dihapus dari admin dan user.");
    } catch (e) {
      debugPrint("❌ Gagal hapus pesanan: $e");
    }
  }

  Future<void> _ensureResiExists(DocumentSnapshot doc, String userId) async {
    final firestore = FirebaseFirestore.instance;
    final data = doc.data() as Map<String, dynamic>;
    final resi = data['resi'];

    if (resi == null || resi == '') {
      final newResi = generateResi();
      await firestore.collection('orders').doc(doc.id).update({'resi': newResi});
      await firestore.collection('users').doc(userId).collection('orders').doc(doc.id).update({'resi': newResi});
      debugPrint("✅ Nomor resi ditambahkan: $newResi");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Kelola Pesanan')),
      body: SingleChildScrollView(
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('orders')
              .orderBy('timestamp', descending: true)
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());

            final orders = snapshot.data!.docs;

            return ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: orders.length,
              itemBuilder: (context, index) {
                final doc = orders[index];
                final data = doc.data() as Map<String, dynamic>;
                final items = List<Map<String, dynamic>>.from(data['items'] ?? []);
                final currentStatus = data['status'] ?? 'Dikemas';
                final userId = data['userId'] ?? '';
                final paymentMethod = data['paymentMethod'] ?? '';
                final resi = data['resi'] ?? '';
                final timestamp = data['timestamp'] != null
                    ? (data['timestamp'] as Timestamp).toDate()
                    : null;

                final String waktuCheckout = timestamp != null
                    ? DateFormat('dd MMM yyyy, HH:mm', 'id_ID').format(timestamp)
                    : '-';

                final keteranganPembatalan = data['keteranganPembatalan'] ?? '';

                // Pastikan resi ada, jika belum buat baru
                _ensureResiExists(doc, userId);

                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Nama: ${data['user']?['name'] ?? '-'}'),
                        Text('Alamat: ${data['user']?['address'] ?? '-'}'),
                        Text('No. HP: ${data['user']?['phone'] ?? '-'}'),
                        Text('Waktu Checkout: $waktuCheckout'),
                        const Divider(),

                        Text('No. Resi: ${resi.isNotEmpty ? resi : "Sedang diproses"}',
                            style: const TextStyle(fontWeight: FontWeight.bold)),
                        const Divider(),

                        const Text('Produk yang Dipesan:', style: TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 4),
                        ...items.map((item) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Image.network(
                                  item['gambar'] ?? '',
                                  width: 70,
                                  height: 70,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) =>
                                      const Icon(Icons.image, size: 70),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(item['nama'] ?? 'Produk Tanpa Nama',
                                          style: const TextStyle(fontWeight: FontWeight.bold)),
                                      Text('Jumlah: ${item['quantity']}'),
                                      Text('Harga: ${item['harga']}'),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),

                        const Divider(),

                        Align(
                          alignment: Alignment.centerRight,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text('Metode Pembayaran: $paymentMethod'),
                              Text(
                                'Total: Rp ${data['total']}',
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 12),

                        if (paymentMethod == 'DANA' && data['buktiPembayaran'] != null)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Bukti Pembayaran:',
                                  style: TextStyle(fontWeight: FontWeight.bold)),
                              const SizedBox(height: 6),
                              Image.network(
                                data['buktiPembayaran'],
                                height: 150,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) =>
                                    const Icon(Icons.broken_image, size: 100),
                              ),
                            ],
                          ),

                        const SizedBox(height: 12),

                        if (keteranganPembatalan.isNotEmpty)
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.red.shade100,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              'Keterangan Pembatalan: $keteranganPembatalan',
                              style: const TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),

                        const SizedBox(height: 12),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Status Pesanan:', style: TextStyle(fontWeight: FontWeight.bold)),
                            DropdownButton<String>(
                              value: currentStatus,
                              onChanged: (String? newValue) {
                                if (newValue != null && newValue != currentStatus) {
                                  _updateStatus(doc.id, userId, newValue);
                                }
                              },
                              items: const [
                                DropdownMenuItem(value: 'Dikemas', child: Text('Dikemas')),
                                DropdownMenuItem(value: 'Dalam Perjalanan', child: Text('Dalam Perjalanan')),
                                DropdownMenuItem(value: 'Selesai', child: Text('Selesai')),
                              ],
                            ),
                          ],
                        ),

                        const SizedBox(height: 12),

                        Align(
                          alignment: Alignment.centerRight,
                          child: ElevatedButton(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: const Text('Konfirmasi Penghapusan'),
                                  content: const Text('Yakin ingin menghapus pesanan ini?'),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: const Text('Batal'),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        _deleteOrder(doc.id, userId);
                                        Navigator.pop(context);
                                      },
                                      child: const Text('Hapus'),
                                    ),
                                  ],
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white,),
                            child: const Text('Hapus Pesanan'),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
