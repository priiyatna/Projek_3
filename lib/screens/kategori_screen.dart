import 'package:flutter/material.dart';

class KategoriScreen extends StatelessWidget {
  final String kategori;

  const KategoriScreen({super.key, required this.kategori});

  // List produk per kategori (sementara hardcoded untuk kategori SEMBAKO)
  List<Map<String, String>> getProdukByKategori(String kategori) {
    if (kategori == 'SEMBAKO') {
      return [
        {'nama': 'MINYAK GORENG CURAH 1 kg', 'gambar': 'assets/minyak.png', 'harga': 'Rp 20.000'},
        {'nama': 'GULA PASIR CURAH 1 kg', 'gambar': 'assets/gula.png', 'harga': 'Rp 18.500'},
        {'nama': 'TEPUNG SEGITIGA BIRU 1 KG', 'gambar': 'assets/segitiga.png', 'harga': 'Rp 12.000'},
        {'nama': 'TEPUNG MAIZENAKU 100 gr', 'gambar': 'assets/maizena.png', 'harga': 'Rp 5.000'},
        {'nama': 'GULA MERAH 1 kg', 'gambar': 'assets/gulamerah.png', 'harga': 'Rp 15.000'},
      ];
    } else {
      return [
        {'nama': 'Produk Kosong', 'gambar': 'assets/placeholder.png', 'harga': 'Rp -'},
      ];
    }
  }

  @override
  Widget build(BuildContext context) {
    final produkList = getProdukByKategori(kategori);

    return Scaffold(
      appBar: AppBar(
        title: Text(kategori),
        backgroundColor: Colors.blue[200],
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Search Bar
            Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'search...',
                      fillColor: Colors.white,
                      filled: true,
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            // Grid Produk
            Expanded(
              child: GridView.builder(
                itemCount: produkList.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 3 / 5,
                ),
                itemBuilder: (context, index) {
                  final produk = produkList[index];
                  return Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    elevation: 2,
                    child: Column(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Image.asset(
                              produk['gambar']!,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 6.0),
                          child: Text(
                            produk['nama']!,
                            style: const TextStyle(fontSize: 12),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: const BorderRadius.only(
                                bottomLeft: Radius.circular(8),
                                bottomRight: Radius.circular(8)),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.shopping_cart, color: Colors.white, size: 16),
                              const SizedBox(width: 4),
                              Text(
                                produk['harga']!,
                                style: const TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
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
