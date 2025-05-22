import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CartItem {
  final String nama;
  final String gambar;
  final String harga;
  int quantity;
  bool isSelected;

  CartItem({
    required this.nama,
    required this.gambar,
    required this.harga,
    this.quantity = 1,
    this.isSelected = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'nama': nama,
      'gambar': gambar,
      'harga': harga,
      'quantity': quantity,
      'isSelected': isSelected,
    };
  }

  static CartItem fromMap(Map<String, dynamic> map) {
    return CartItem(
      nama: map['nama'],
      gambar: map['gambar'],
      harga: map['harga'],
      quantity: map['quantity'],
      isSelected: map['isSelected'],
    );
  }
}

class CartProvider with ChangeNotifier {
  final List<CartItem> _cartItems = [];

  List<CartItem> get cartItems => _cartItems;

  /// Tambah produk ke keranjang, jika sudah ada tambahkan quantity
  void addToCart(CartItem newItem) {
    final existingIndex = _cartItems.indexWhere(
      (item) => item.nama == newItem.nama,
    );

    if (existingIndex >= 0) {
      _cartItems[existingIndex].quantity += newItem.quantity;
    } else {
      _cartItems.add(newItem);
    }
    notifyListeners();
    saveCartToFirebase();
  }

  /// Hapus produk dari keranjang
  void removeFromCart(CartItem item) {
    _cartItems.remove(item);
    notifyListeners();
    saveCartToFirebase();
  }

  /// Toggle ceklis pada produk
  void toggleSelection(CartItem item) {
    item.isSelected = !item.isSelected;
    notifyListeners();
    saveCartToFirebase();
  }

  /// Total harga dalam format string (contoh: Rp 15000)
  String getSelectedTotalHarga() {
    int total = getSelectedTotalHargaRaw();
    return 'Rp ${_formatCurrency(total)}';
  }

  /// Total harga mentah (int)
  int getSelectedTotalHargaRaw() {
    int total = 0;
    for (var item in _cartItems) {
      if (item.isSelected) {
        final numericHarga = int.tryParse(
              item.harga.replaceAll(RegExp(r'[^0-9]'), ''),
            ) ??
            0;
        total += numericHarga * item.quantity;
      }
    }
    return total;
  }

  /// Bersihkan item yang dicentang dari keranjang
  void clearSelectedItems() {
    _cartItems.removeWhere((item) => item.isSelected);
    notifyListeners();
    saveCartToFirebase();
  }

  /// Hapus semua isi keranjang
  void clearCart() {
    _cartItems.clear();
    notifyListeners();
    saveCartToFirebase();
  }

  /// Jumlah item (quantity total)
  int get itemCount {
    return _cartItems.fold(0, (sum, item) => sum + item.quantity);
  }

  /// Format angka ke format '12.000'
  String _formatCurrency(int number) {
    final str = number.toString();
    final buffer = StringBuffer();
    for (int i = 0; i < str.length; i++) {
      final reversedIndex = str.length - i - 1;
      buffer.write(str[i]);
      if (reversedIndex % 3 == 0 && i != str.length - 1) {
        buffer.write('.');
      }
    }
    return buffer.toString();
  }

  /// Simpan keranjang ke Firebase
  Future<void> saveCartToFirebase() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final cartData = _cartItems.map((item) => item.toMap()).toList();
    await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('cart')
        .doc('items')
        .set({'items': cartData});
  }

  /// Muat keranjang dari Firebase saat login
  Future<void> loadCartFromFirebase() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('cart')
        .doc('items')
        .get();

    if (doc.exists && doc.data() != null && doc.data()!['items'] != null) {
      final List<dynamic> cartList = doc.data()!['items'];
      _cartItems.clear();
      _cartItems.addAll(cartList.map((item) => CartItem.fromMap(Map<String, dynamic>.from(item))));
      notifyListeners();
    }
  }
}