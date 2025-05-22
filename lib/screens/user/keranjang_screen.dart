import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'cart_provider.dart';
import 'home_screen.dart';
import 'checkout_screen.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCart();
  }

  Future<void> _loadCart() async {
    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    await cartProvider.loadCartFromFirebase();
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    final cartItems = cartProvider.cartItems;

    void handleCheckout() async {
      final selectedItems = cartItems.where((item) => item.isSelected).toList();

      if (selectedItems.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Pilih produk terlebih dahulu')),
        );
        return;
      }

      final user = FirebaseAuth.instance.currentUser;

      if (user == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Pengguna belum login')),
        );
        return;
      }

      final total = cartProvider.getSelectedTotalHargaRaw();

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CheckoutScreen(
            selectedItems: selectedItems,
            totalHarga: total,
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const HomeScreen()),
            );
          },
        ),
        title: const Text(
          'KERANJANG',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFFBBDEFB),
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : cartItems.isEmpty
              ? const Center(
                  child: Text(
                    'Keranjang kosong',
                    style: TextStyle(fontSize: 18),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: cartItems.length,
                  itemBuilder: (context, index) {
                    final item = cartItems[index];
                    return Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      elevation: 2,
                      child: ListTile(
                        leading: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Checkbox(
                              value: item.isSelected,
                              onChanged: (_) {
                                cartProvider.toggleSelection(item);
                              },
                            ),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                item.gambar,
                                width: 40,
                                height: 40,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return const Icon(Icons.image_not_supported);
                                },
                              ),
                            ),
                          ],
                        ),
                        title: Text(item.nama, style: const TextStyle(fontSize: 14)),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.harga,
                              style: const TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text('Jumlah: ${item.quantity}'),
                          ],
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            cartProvider.removeFromCart(item);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Produk dihapus dari keranjang')),
                            );
                          },
                        ),
                      ),
                    );
                  },
                ),
      bottomNavigationBar: cartItems.isEmpty
          ? null
          : Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.shade300,
                    blurRadius: 8,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Total terpilih:',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        cartProvider.getSelectedTotalHarga(),
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: handleCheckout,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'BELI SEKARANG',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
