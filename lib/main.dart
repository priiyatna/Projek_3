import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/pesanan_screen.dart';
import 'screens/keranjang_screen.dart';
import 'screens/kontak_kami_screen.dart';
import 'screens/akun_screen.dart';
// import 'screens/welcome_screen.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const HomeScreen(),
    const PesananScreen(),
    const KeranjangScreen(),
    const KontakKamiScreen(),
    const AkunScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.black54,
        type: BottomNavigationBarType.fixed,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Beranda'),
          BottomNavigationBarItem(icon: Icon(Icons.receipt), label: 'Pesanan Saya'),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: 'Keranjang'),
          BottomNavigationBarItem(icon: Icon(Icons.contact_mail), label: 'Kontak Kami'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Akun'),
        ],
      ),
    );
  }
}
