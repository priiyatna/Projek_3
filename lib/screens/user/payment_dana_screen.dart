import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'cart_provider.dart';

class LakukanPembayaranScreen extends StatelessWidget {
  final List<CartItem> items;
  final int total;
  final String name;
  final String address;
  final String phone;
  final String paymentMethod;
  final String userId;

  const LakukanPembayaranScreen({
    super.key,
    required this.items,
    required this.total,
    required this.name,
    required this.address,
    required this.phone,
    required this.paymentMethod,
    required this.userId,
  });

  String generateResi() {
    final random = Random();
    final number = List.generate(8, (_) => random.nextInt(10)).join();
    return 'DERYKO$number';
  }

  Future<void> _kirimPesanWhatsapp(BuildContext context) async {
    final String noAdmin = '62895710363200';

    final itemList = items.map((item) {
      return "- ${item.nama} x${item.quantity} (${item.harga})";
    }).join("\n");

    final message = '''
Halo admin, saya telah melakukan pembayaran dengan detail berikut:

Nama: $name
Alamat: $address
No HP: $phone
Total Pembayaran: Rp $total
Metode Pembayaran: $paymentMethod

Produk:
$itemList

Tolong kirim bukti pembayaran berupa screenshot bukti transfer.

Terima kasih.
''';

    final url = 'https://wa.me/$noAdmin?text=${Uri.encodeComponent(message)}';

    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gagal membuka WhatsApp')),
      );
    }
  }

  Future<void> _simpanPesanan(BuildContext context) async {
    try {
      final firestore = FirebaseFirestore.instance;
      final docRef = firestore.collection('orders').doc();

      final resi = generateResi();

      final orderData = {
        'orderId': docRef.id,
        'userId': userId,
        'user': {
          'name': name,
          'address': address,
          'phone': phone,
        },
        'items': items.map((item) => {
              'nama': item.nama,
              'harga': item.harga,
              'quantity': item.quantity,
              'gambar': item.gambar,
            }).toList(),
        'total': total,
        'paymentMethod': paymentMethod,
        'status': 'Dikemas',
        'resi': resi,
        'keteranganPembatalan': '',
        'timestamp': FieldValue.serverTimestamp(),
      };

      await docRef.set(orderData);
      await firestore
          .collection('users')
          .doc(userId)
          .collection('orders')
          .doc(docRef.id)
          .set(orderData);

      for (final item in items) {
        final query = await firestore
            .collection('products')
            .where('nama', isEqualTo: item.nama)
            .limit(1)
            .get();

        if (query.docs.isNotEmpty) {
          final doc = query.docs.first;
          final currentStock = doc['stock'] ?? 0;
          final newStock = currentStock - item.quantity;

          if (newStock >= 0) {
            await firestore.collection('products').doc(doc.id).update({'stock': newStock});
          }
        }
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('✅ Pesanan berhasil dibuat')),
      );

      Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
    } catch (e) {
      debugPrint('❌ Gagal menyimpan pesanan: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('❌ Gagal menyimpan pesanan')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lakukan Pembayaran'),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text(
              'Silakan scan QR DANA berikut dan lakukan pembayaran.',
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Image.asset('assets/barcode_dana1.jpg', width: 200, height: 200),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () => _kirimPesanWhatsapp(context),
              icon: const Icon(Icons.chat, color: Colors.white),
              label: const Text(
                'Kirim Bukti Lewat WhatsApp',
                style: TextStyle(color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _simpanPesanan(context),
              child: const Text(
                'Sudah Melakukan Pembayaran',
                style: TextStyle(color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
            ),
          ],
        ),
      ),
    );
  }
}
