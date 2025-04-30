import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'cart_provider.dart';
import 'detail_produk_screen.dart';
import 'keranjang_screen.dart';

class KategoriScreen extends StatelessWidget {
  final String kategori;

  const KategoriScreen({super.key, required this.kategori});

  List<Map<String, String>> getProdukByKategori(String kategori) {
    if (kategori == 'SEMBAKO') {
      return [
        {
          'nama': 'MINYAK GORENG CURAH 1 kg',
          'gambar': 'assets/minyak.png',
          'harga': 'Rp 20.000'
        },
        {
          'nama': 'GULA PASIR CURAH 1 kg',
          'gambar': 'assets/gula.png',
          'harga': 'Rp 18.500'
        },
        // Tambahkan produk lainnya...
      ];
    } else {
      return [
        {
          'nama': 'Produk Kosong',
          'gambar': 'assets/placeholder.png',
          'harga': 'Rp -'
        },
      ];
    }
  }

  @override
  Widget build(BuildContext context) {
    final produkList = getProdukByKategori(kategori);
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
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CartScreen()),
              );
            },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Search Bar
            const TextField(
              decoration: InputDecoration(
                hintText: 'Search...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            // Grid Produk
            Expanded(
              child: GridView.builder(
                itemCount: produkList.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 3 / 4,
                ),
                itemBuilder: (context, index) {
                  final produk = produkList[index];
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
                                    namaProduk: produk['nama']!,
                                    gambarProduk: produk['gambar']!,
                                    hargaProduk: produk['harga']!,
                                  ),
                                ),
                              );
                            },
                            child: Image.asset(produk['gambar']!),
                          ),
                        ),
                        Text(produk['nama']!),
                        Text(
                          produk['harga']!,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.add_shopping_cart),
                          onPressed: () {
                            cartProvider.addToCart(
                              CartItem(
                                nama: produk['nama']!,
                                gambar: produk['gambar']!,
                                harga: produk['harga']!,
                              ),
                            );
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Produk ditambahkan ke keranjang'),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
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