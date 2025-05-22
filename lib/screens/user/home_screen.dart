import 'package:flutter/material.dart';
import 'cart_provider.dart';
import 'kategori_screen.dart';
import 'akun_screen.dart';
import 'kontak_kami_screen.dart';
import 'keranjang_screen.dart';
import 'pesanan_screen.dart'; 

class Category {
  final String name;
  final String image;

  Category({required this.name, required this.image});
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<Category> categories = [
    Category(name: "SEMBAKO", image: "assets/sembako.png"),
    Category(name: "ROKOK", image: "assets/rokok.png"),
    Category(name: "SNACK", image: "assets/snack.jpg"),
    Category(name: "MINUMAN", image: "assets/minuman.jpg"),
    Category(name: "PERALATAN MANDI & RUMAH", image: "assets/peralatan.jpg"),
    Category(name: "LAIN-LAIN", image: "assets/lain-lain.jpg"),
  ];

  void _onTabTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget _getSelectedPage() {
    switch (_selectedIndex) {
      case 0:
        return buildCategoryPage();
      case 1:
        return const PesananScreen();
      case 2:
        return const CartScreen();
      case 3:
        return const KontakKamiScreen();
      case 4:
        return const AccountScreen();
      default:
        return buildCategoryPage();
    }
  }

  Widget buildCategoryPage() {
    return Column(
      children: [
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'search...',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () {},
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: GridView.builder(
              itemCount: categories.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 3 / 3.5,
              ),
              itemBuilder: (context, index) {
                final category = categories[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => KategoriScreen(
                          kategori: category.name,
                          onItemAddedToCart: () {
                            setState(() {
                              _selectedIndex = 2; // Pindah ke keranjang
                            });
                          },
                        ),
                      ),
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 4,
                          offset: Offset(2, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(category.image,
                            width: 80, height: 80, fit: BoxFit.cover),
                        const SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Text(
                            category.name,
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'TOKO DERYKO',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          backgroundColor: Colors.blue[200],
          centerTitle: true,
          automaticallyImplyLeading: false,  // Menghilangkan tombol anak panah
        ),
        body: _getSelectedPage(),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _onTabTapped,
          selectedItemColor: Colors.black,
          unselectedItemColor: Colors.black54,
          showUnselectedLabels: true,
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Beranda'),
            BottomNavigationBarItem(icon: Icon(Icons.receipt_long), label: 'Pesanan saya'),
            BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: 'Keranjang'),
            BottomNavigationBarItem(icon: Icon(Icons.support_agent), label: 'Kontak Kami'),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Akun'),
          ],
        ),
      ),
    );
  }
}
