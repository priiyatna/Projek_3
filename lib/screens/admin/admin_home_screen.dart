import 'package:flutter/material.dart';
import 'manage_users_screen.dart';
import 'manage_orders_screen.dart';
import 'manage_products_screen.dart';
import 'laporan_penjualan_screen.dart';
import 'akun_admin_screen.dart';

class AdminHomeScreen extends StatefulWidget {
  const AdminHomeScreen({super.key});

  @override
  State<AdminHomeScreen> createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends State<AdminHomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = const [
    ManageProductsScreen(),
    LaporanPenjualanScreen(),
    ManageOrdersScreen(),
    ManageUsersScreen(),
    AkunAdminScreen(),
  ];

  final List<String> _titles = [
    'Kelola Produk',
    'Laporan Penjualan',
    'Kelola Pesanan',
    'Kelola Pengguna',
    'Akun Admin',
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: Text(
          'ADMIN DERYKO',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 144, 205, 255),
        centerTitle: true,
        leading: Container(),  // Menghilangkan anak panah di pojok kiri atas
      ),
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.inventory),
            label: 'Kelola Produk',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: 'Laporan',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt),
            label: 'Kelola Pesanan',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'Kelola Pengguna',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Akun Admin',
          ),
        ],
      ),
    );
  }
}
