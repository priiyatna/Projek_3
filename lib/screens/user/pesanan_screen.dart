import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'home_screen.dart';

class PesananScreen extends StatelessWidget {
  const PesananScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final String uid = FirebaseAuth.instance.currentUser!.uid;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "PESANAN SAYA",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFFBBDEFB),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const HomeScreen()),
            );
          },
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(uid)
            .collection('orders')
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(child: Text('Terjadi kesalahan'));
          }

          final orders = snapshot.data?.docs ?? [];

          if (orders.isEmpty) {
            return const Center(child: Text('Belum ada pesanan.'));
          }

          final dikemasOrders =
              orders.where((order) => order['status'] == 'Dikemas').toList();
          final dalamPerjalananOrders =
              orders.where((order) => order['status'] == 'Dalam Perjalanan').toList();
          final selesaiOrders =
              orders.where((order) => order['status'] == 'Selesai').toList();

          return DefaultTabController(
            length: 3,
            child: Column(
              children: [
                const TabBar(
                  tabs: [
                    Tab(text: 'Dikemas'),
                    Tab(text: 'Dalam Perjalanan'),
                    Tab(text: 'Selesai'),
                  ],
                ),
                Expanded(
                  child: TabBarView(
                    children: [
                      _buildOrderList(dikemasOrders, 'Dikemas', uid),
                      _buildOrderList(dalamPerjalananOrders, 'Dalam Perjalanan', uid),
                      _buildOrderList(selesaiOrders, 'Selesai', uid),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildOrderList(List<QueryDocumentSnapshot> orders, String status, String uid) {
    if (orders.isEmpty) {
      return Center(child: Text('Belum ada produk di status $status.'));
    }

    return ListView.builder(
      itemCount: orders.length,
      itemBuilder: (context, index) {
        final order = orders[index];
        final List<dynamic> items = order['items'] ?? [];
        final total = order['total'] ?? 0;
        final timestamp = order['timestamp'] as Timestamp?;
        final formattedDate = timestamp != null
            ? DateFormat('dd MMM yyyy, HH:mm').format(timestamp.toDate())
            : 'Waktu tidak tersedia';

        final String? resi = order['resi'];

        Color? statusBgColor;
        Color? statusTextColor;

        if (status == 'Selesai') {
          statusBgColor = Colors.green[100];
          statusTextColor = Colors.green[800];
        } else if (status == 'Dibatalkan') {
          statusBgColor = Colors.red[100];
          statusTextColor = Colors.red[800];
        } else if (status == 'Dalam Perjalanan') {
          statusBgColor = Colors.blue[100];
          statusTextColor = Colors.blue[800];
        } else {
          statusBgColor = Colors.orange[100];
          statusTextColor = Colors.orange[800];
        }

        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          elevation: 3,
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text("Pesanan #${orders.length - index}",
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: statusBgColor,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        status,
                        style: TextStyle(
                          color: statusTextColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 4),
                Text(formattedDate, style: const TextStyle(color: Colors.black54)),

                if (resi != null && resi.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 6.0),
                    child: Row(
                      children: [
                        const Icon(Icons.local_shipping, size: 16, color: Colors.blueGrey),
                        const SizedBox(width: 6),
                        Text(
                          "No. Resi: $resi",
                          style: const TextStyle(fontSize: 14, color: Colors.black87),
                        ),
                      ],
                    ),
                  ),

                const Divider(height: 20),

                if (items.isEmpty)
                  const Text("Tidak ada produk dalam pesanan.")
                else
                  Column(
                    children: items.map((item) {
                      final String itemName = item['nama'] ?? 'Produk Tanpa Nama';
                      final String itemPrice = item['harga'] ?? 'Rp -';
                      final String itemImage = item['gambar'] ?? '';
                      final int itemQuantity = item['quantity'] ?? 0;

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: itemImage.isNotEmpty
                                  ? Image.network(
                                      itemImage,
                                      width: 70,
                                      height: 70,
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error, stackTrace) =>
                                          const Icon(Icons.image, size: 70),
                                    )
                                  : const Icon(Icons.image, size: 70),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    itemName,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold, fontSize: 14),
                                  ),
                                  const SizedBox(height: 4),
                                  Text('Jumlah: $itemQuantity'),
                                  Text('Harga: $itemPrice'),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),

                const Divider(height: 20),

                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    'Total: Rp $total',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),

                if (status == 'Dikemas')
                  Padding(
                    padding: const EdgeInsets.only(top: 12.0),
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red[400],
                          foregroundColor: Colors.white,
                        ),
                        onPressed: () async {
                          final bool confirm = await showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text("Batalkan Pesanan"),
                              content: const Text("Yakin ingin membatalkan pesanan ini?"),
                              actions: [
                                TextButton(
                                  child: const Text("Tidak"),
                                  onPressed: () => Navigator.pop(context, false),
                                ),
                                TextButton(
                                  child: const Text("Ya"),
                                  onPressed: () => Navigator.pop(context, true),
                                ),
                              ],
                            ),
                          );

                          if (confirm) {
                            try {
                              await FirebaseFirestore.instance
                                  .collection('users')
                                  .doc(uid)
                                  .collection('orders')
                                  .doc(order.id)
                                  .update({
                                'status': 'Dibatalkan',
                                'keteranganPembatalan': 'Pesanan dibatalkan oleh pengguna',
                              });

                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Pesanan berhasil dibatalkan')),
                              );
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Gagal membatalkan pesanan: $e')),
                              );
                            }
                          }
                        },
                        icon: const Icon(Icons.cancel),
                        label: const Text("Batalkan Pesanan"),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
