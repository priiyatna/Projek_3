import 'package:flutter/material.dart';

class CartItem {
  final String nama;
  final String gambar;
  final String harga;
  int quantity;

  CartItem({
    required this.nama,
    required this.gambar,
    required this.harga,
    this.quantity = 1,
  });
}

class CartProvider with ChangeNotifier {
  List<CartItem> _cartItems = [];

  List<CartItem> get cartItems => _cartItems;

  void addToCart(CartItem newItem) {
    // Check if item already exists in cart
    final existingIndex = _cartItems.indexWhere(
      (item) => item.nama == newItem.nama,
    );

    if (existingIndex >= 0) {
      // Update quantity if item exists
      _cartItems[existingIndex].quantity += newItem.quantity;
    } else {
      // Add new item to cart
      _cartItems.add(newItem);
    }
    notifyListeners();
  }

  void removeFromCart(CartItem item) {
    _cartItems.remove(item);
    notifyListeners();
  }

  void clearCart() {
    _cartItems.clear();
    notifyListeners();
  }

  String getTotalHarga() {
    int total = 0;
    for (var item in _cartItems) {
      String numericHarga = item.harga.replaceAll('Rp ', '').replaceAll('.', '');
      total += (int.tryParse(numericHarga) ?? 0) * item.quantity;
    }
    return 'Rp ${total.toStringAsFixed(0)}';
  }

  int get itemCount {
    return _cartItems.fold(0, (sum, item) => sum + item.quantity);
  }
}