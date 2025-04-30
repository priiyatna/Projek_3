class CartItem {
  final String nama;
  final String gambar;
  final String harga;
  bool isSelected;

  CartItem({
    required this.nama,
    required this.gambar,
    required this.harga,
    this.isSelected = false,
  });
}
