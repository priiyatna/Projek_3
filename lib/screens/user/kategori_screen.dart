import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'cart_provider.dart';
import 'detail_produk_screen.dart';

class KategoriScreen extends StatelessWidget {
  final String kategori;
  final VoidCallback? onItemAddedToCart;

  const KategoriScreen({
    super.key,
    required this.kategori,
    this.onItemAddedToCart,
  });

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(kategori),
        backgroundColor: Colors.blue[200],
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {
              if (onItemAddedToCart != null) {
                onItemAddedToCart!();
                Navigator.pop(context);
              }
            },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const TextField(
              decoration: InputDecoration(
                hintText: 'Search...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('products')
                    .where('category', isEqualTo: kategori.toUpperCase())
                    .orderBy('timestamp', descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return Center(child: Text('Terjadi kesalahan: ${snapshot.error}'));
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(child: Text('Tidak ada produk di kategori ini.'));
                  }

                  final produkList = snapshot.data!.docs;

                  return GridView.builder(
                    itemCount: produkList.length,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 12,
                      childAspectRatio: 3 / 4,
                    ),
                    itemBuilder: (context, index) {
                      final data = produkList[index].data() as Map<String, dynamic>;

                      final stock = data['stock'] ?? 0;
                      final stockUnit = data['stockUnit'] ?? '';

                      print('Produk: ${data['name']}, Stock: $stock, Unit: $stockUnit');

                      return Card(
                        elevation: 2,
                        child: Column(
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => DetailProdukScreen(
                                        namaProduk: data['name'],
                                        gambarProduk: data['imageUrl'],
                                        hargaProduk: 'Rp${data['price']}',
                                        deskripsiProduk: data['description'] ?? 'Deskripsi belum tersedia',
                                        stock: stock,
                                        stockUnit: stockUnit,
                                      ),
                                    ),
                                  );
                                },
                                child: Image.network(
                                  data['imageUrl'],
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) =>
                                      const Icon(Icons.broken_image, size: 80),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(4),
                              child: Column(
                                children: [
                                  Text(
                                    data['name'],
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(fontWeight: FontWeight.w600),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Rp${data['price']}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.blue,
                                    ),
                                  ),
                                  Text(
                                    'Stok: $stock $stockUnit',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.normal,
                                      color: Colors.black54,
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.add_shopping_cart),
                                        onPressed: () {
                                          cartProvider.addToCart(
                                            CartItem(
                                              nama: data['name'],
                                              gambar: data['imageUrl'],
                                              harga: 'Rp${data['price']}',
                                            ),
                                          );
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            const SnackBar(
                                              content: Text('Produk ditambahkan ke keranjang'),
                                            ),
                                          );
                                        },
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          cartProvider.clearCart();
                                          cartProvider.addToCart(
                                            CartItem(
                                              nama: data['name'],
                                              gambar: data['imageUrl'],
                                              harga: 'Rp${data['price']}',
                                            ),
                                          );
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => DetailProdukScreen(
                                                namaProduk: data['name'],
                                                gambarProduk: data['imageUrl'],
                                                hargaProduk: 'Rp${data['price']}',
                                                deskripsiProduk: data['description'] ?? 'Deskripsi belum tersedia',
                                                stock: stock,
                                                stockUnit: stockUnit,
                                              ),
                                            ),
                                          );
                                        },
                                        child: const Text('Beli'),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}