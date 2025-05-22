import 'dart:math';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'cart_provider.dart';
import 'payment_dana_screen.dart';  // Pastikan import ini mengarah ke file yang benar

class CheckoutScreen extends StatefulWidget {
  final List<CartItem>? selectedItems;
  final int? totalHarga;

  const CheckoutScreen({
    super.key,
    this.selectedItems,
    this.totalHarga,
  });

  @override
  _CheckoutScreenState createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  String _paymentMethod = 'COD';
  String? nama;
  String? alamat;
  String? phone;
  bool _isLoading = true;

  late List<CartItem> _items;
  late int _total;
  String? _userId;

  @override
  void initState() {
    super.initState();
    _prepareItems();
    _loadUserData();
  }

  void _prepareItems() {
    _items = widget.selectedItems ?? [];
    _total = widget.totalHarga ?? _calculateTotal();
  }

  int _calculateTotal() {
    return _items.fold(0, (sum, item) {
      final hargaStr = item.harga.replaceAll(RegExp(r'[^\d]'), '');
      return sum + (int.tryParse(hargaStr) ?? 0) * item.quantity;
    });
  }

  Future<void> _loadUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      setState(() {
        _isLoading = false;
      });
      return;
    }

    final userDoc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
    final data = userDoc.data();
    if (data != null) {
      setState(() {
        _userId = user.uid;
        // Sesuaikan dengan field Firestore kamu
        nama = data['name'] ?? '';
        alamat = data['address'] ?? '';
        phone = data['phone'] ?? '';
        _isLoading = false;
      });
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _updateQuantity(int index, int delta) {
    setState(() {
      _items[index].quantity += delta;
      if (_items[index].quantity < 1) {
        _items[index].quantity = 1;
      }
      _total = _calculateTotal();
    });
  }

  String generateResi() {
    final random = Random();
    final number = List.generate(8, (_) => random.nextInt(10)).join();
    return 'DERYKO$number';
  }

  void submitOrder() async {
    if (nama == null || alamat == null || phone == null || nama!.isEmpty || alamat!.isEmpty || phone!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Data pengguna tidak lengkap')),
      );
      return;
    }

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final firestore = FirebaseFirestore.instance;
    final orderId = firestore.collection('orders').doc().id;

    final resi = generateResi();

    final orderData = {
      'items': _items.map((item) => {
        'nama': item.nama,
        'harga': item.harga,
        'gambar': item.gambar,
        'quantity': item.quantity,
      }).toList(),
      'status': 'Dikemas',
      'total': _total,
      'timestamp': FieldValue.serverTimestamp(),
      'paymentMethod': _paymentMethod,
      'userId': user.uid,
      'user': {
        'name': nama,
        'address': alamat,
        'phone': phone,
      },
      'resi': resi,
      'keteranganPembatalan': '',
    };

    try {
      // Simpan ke subcollection user
      await firestore.collection('users').doc(user.uid).collection('orders').doc(orderId).set(orderData);
      // Simpan ke koleksi utama
      await firestore.collection('orders').doc(orderId).set(orderData);

      // Kurangi stok produk
      for (final item in _items) {
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
        const SnackBar(content: Text('Pesanan berhasil dibuat')),
      );

      Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
    } catch (e) {
      debugPrint('Error menyimpan pesanan: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gagal membuat pesanan')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat('#,###', 'id_ID');

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Checkout',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blue,
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                const Text('Data Pengguna', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text('Nama: $nama'),
                Text('Alamat: $alamat'),
                Text('No. HP: $phone'),
                const Divider(height: 30),

                const Text('Produk Dibeli', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                ..._items.asMap().entries.map((entry) {
                  final index = entry.key;
                  final item = entry.value;
                  return ListTile(
                    leading: Image.network(item.gambar, width: 40, height: 40, fit: BoxFit.cover),
                    title: Text(item.nama),
                    subtitle: Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.remove_circle_outline),
                          onPressed: () => _updateQuantity(index, -1),
                        ),
                        Text('${item.quantity}'),
                        IconButton(
                          icon: const Icon(Icons.add_circle_outline),
                          onPressed: () => _updateQuantity(index, 1),
                        ),
                      ],
                    ),
                    trailing: Text(item.harga),
                  );
                }),
                const Divider(),

                Text(
                  'Total: Rp ${formatter.format(_total)}',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.end,
                ),

                const SizedBox(height: 20),

                const Text('Metode Pembayaran', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                DropdownButton<String>(
                  value: _paymentMethod,
                  onChanged: (String? newValue) {
                    setState(() {
                      _paymentMethod = newValue!;
                    });
                  },
                  items: const [
                    DropdownMenuItem(value: 'COD', child: Text('Cash on Delivery (COD)')),
                    DropdownMenuItem(value: 'DANA', child: Text('DANA')),
                  ],
                ),

                const SizedBox(height: 20),

                ElevatedButton(
                  onPressed: () {
                    if (_paymentMethod == 'COD') {
                      submitOrder();
                    } else {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => LakukanPembayaranScreen(
                            items: _items,
                            total: _total,
                            name: nama ?? '',
                            address: alamat ?? '',
                            phone: phone ?? '',
                            paymentMethod: _paymentMethod,
                            userId: _userId ?? '',
                          ),
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                  ),
                  child: Text(_paymentMethod == 'COD' ? 'Buat Pesanan' : 'Lanjutkan Pembayaran'),
                ),
              ],
            ),
    );
  }
}