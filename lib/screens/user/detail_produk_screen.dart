import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'cart_provider.dart';
import 'checkout_screen.dart';

class DetailProdukScreen extends StatelessWidget {
  final String namaProduk;
  final String gambarProduk;
  final String hargaProduk;
  final String deskripsiProduk;
  final int stock;
  final String stockUnit; // <- Ubah dari unit ke stockUnit

  const DetailProdukScreen({
    super.key,
    required this.namaProduk,
    required this.gambarProduk,
    required this.hargaProduk,
    required this.deskripsiProduk,
    required this.stock,
    required this.stockUnit, // <- Ubah dari unit ke stockUnit
  });

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Produk'),
        backgroundColor: Colors.blue[200],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Image.network(
                gambarProduk,
                height: 200,
                errorBuilder: (context, error, stackTrace) =>
                    const Icon(Icons.broken_image, size: 100),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              namaProduk,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              hargaProduk,
              style: const TextStyle(fontSize: 20, color: Colors.green),
            ),
            const SizedBox(height: 10),
            Text(
              'Stok tersedia: $stock $stockUnit', // <- gunakan stockUnit
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Deskripsi Produk:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              deskripsiProduk,
              style: const TextStyle(fontSize: 16),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.add_shopping_cart),
                label: const Text('Tambahkan ke Keranjang'),
                onPressed: () {
                  cartProvider.addToCart(
                    CartItem(
                      nama: namaProduk,
                      gambar: gambarProduk,
                      harga: hargaProduk,
                    ),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Produk ditambahkan ke keranjang')),
                  );
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.shopping_bag),
                label: const Text('Beli Sekarang'),
                onPressed: () {
                  final cartItem = CartItem(
                    nama: namaProduk,
                    gambar: gambarProduk,
                    harga: hargaProduk,
                    quantity: 1,
                    isSelected: true,
                  );

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CheckoutScreen(
                        selectedItems: [cartItem],
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}