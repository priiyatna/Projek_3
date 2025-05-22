import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ManageProductsScreen extends StatelessWidget {
  const ManageProductsScreen({super.key});

  final List<String> categories = const [
    "SEMBAKO",
    "ROKOK",
    "SNACK",
    "MINUMAN",
    "PERALATAN MANDI & RUMAH",
    "LAIN-LAIN"
  ];

  void _showAddProductDialog(BuildContext context) {
    _showProductDialog(context, isEdit: false);
  }

  void _showEditProductDialog(BuildContext context, DocumentSnapshot doc) {
    _showProductDialog(context, isEdit: true, doc: doc);
  }

  void _showProductDialog(BuildContext context,
      {required bool isEdit, DocumentSnapshot? doc}) {
    final data = doc?.data() as Map<String, dynamic>? ?? {};

    final TextEditingController nameController =
        TextEditingController(text: data['name'] ?? '');
    final TextEditingController stockController =
        TextEditingController(text: (data['stock'] != null) ? data['stock'].toString() : '');
    final TextEditingController priceController =
        TextEditingController(text: data['price']?.toString() ?? '');
    final TextEditingController imageUrlController =
        TextEditingController(text: data['imageUrl'] ?? '');
    final TextEditingController userIdController = TextEditingController();
    final TextEditingController descriptionController =
        TextEditingController(text: data['description'] ?? '');
    String selectedCategory = data['category'] ?? categories[0];

    final List<String> stockUnits = [
      'kg',
      'Gr',
      'L',
      'ML',
      'Pcs',
      'Pack',
      'Dus',
      'Butir',
      'Sachet',
      'Bungkus',
      'Renceng',
      'Karung',
    ];

    String selectedStockUnit = data['stockUnit'] ?? stockUnits[0];

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(isEdit ? 'Edit Produk' : 'Tambah Produk'),
        content: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Nama Produk'),
              ),
              TextField(
                controller: stockController,
                decoration: const InputDecoration(labelText: 'Stok (angka)'),
                keyboardType: TextInputType.number,
              ),
              DropdownButtonFormField<String>(
                value: selectedStockUnit,
                decoration: const InputDecoration(labelText: 'Satuan Stok'),
                items: stockUnits
                    .map((unit) => DropdownMenuItem(
                          value: unit,
                          child: Text(unit),
                        ))
                    .toList(),
                onChanged: (value) {
                  if (value != null) selectedStockUnit = value;
                },
              ),
              TextField(
                controller: priceController,
                decoration: const InputDecoration(labelText: 'Harga'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: imageUrlController,
                decoration: const InputDecoration(labelText: 'Image URL'),
              ),
              TextField(
                controller: descriptionController,
                decoration: const InputDecoration(labelText: 'Deskripsi Produk'),
                maxLines: 3,
              ),
              DropdownButtonFormField<String>(
                value: selectedCategory,
                items: categories
                    .map((cat) =>
                        DropdownMenuItem(value: cat, child: Text(cat)))
                    .toList(),
                onChanged: (value) {
                  if (value != null) selectedCategory = value;
                },
                decoration:
                    const InputDecoration(labelText: 'Pilih Kategori Produk'),
              ),
              if (!isEdit)
                TextField(
                  controller: userIdController,
                  decoration: const InputDecoration(labelText: 'User ID'),
                ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () async {
              final name = nameController.text.trim();
              final stockText = stockController.text.trim();
              final stock = int.tryParse(stockText) ?? 0;
              final priceText = priceController.text.trim().replaceAll('.', '');
              final price = int.tryParse(priceText) ?? 0;
              final imageUrl = imageUrlController.text.trim();
              final description = descriptionController.text.trim();
              final userId = userIdController.text.trim();

              if (isEdit && doc != null) {
                final productData = {
                  'name': name,
                  'stock': stock,
                  'stockUnit': selectedStockUnit,
                  'price': price,
                  'imageUrl': imageUrl,
                  'description': description,
                  'category': selectedCategory,
                  'timestamp': FieldValue.serverTimestamp(),
                };

                await FirebaseFirestore.instance
                    .collection('products')
                    .doc(doc.id)
                    .update(productData);
              } else {
                // Buat dokumen baru dulu agar kita dapat ID-nya
                final newDocRef = FirebaseFirestore.instance.collection('products').doc();
                final newProductId = newDocRef.id;

                final productData = {
                  'id': newProductId,
                  'name': name,
                  'stock': stock,
                  'stockUnit': selectedStockUnit,
                  'price': price,
                  'imageUrl': imageUrl,
                  'description': description,
                  'category': selectedCategory,
                  'timestamp': FieldValue.serverTimestamp(),
                };

                await newDocRef.set(productData);

                if (userId.isNotEmpty) {
                  await FirebaseFirestore.instance
                      .collection('users')
                      .doc(userId)
                      .collection('products')
                      .doc(newProductId)
                      .set(productData);
                }
              }

              Navigator.pop(context);
            },
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
  }

  void _confirmDelete(BuildContext context, String productId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Konfirmasi Hapus'),
        content: const Text('Apakah Anda yakin ingin menghapus produk ini?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await FirebaseFirestore.instance
                  .collection('products')
                  .doc(productId)
                  .delete();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Produk berhasil dihapus')),
              );
            },
            child: const Text('Hapus', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kelola Produk'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showAddProductDialog(context),
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('products')
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final products = snapshot.data!.docs;

          return ListView.builder(
            itemCount: products.length,
            itemBuilder: (context, index) {
              final doc = products[index];
              final data = doc.data() as Map<String, dynamic>;

              return ListTile(
                leading: Image.network(
                  data['imageUrl'],
                  width: 50,
                  height: 50,
                  errorBuilder: (context, error, stackTrace) =>
                      const Icon(Icons.image_not_supported),
                ),
                title: Text(data['name']),
                subtitle: Text(
                    'Stok: ${data['stock']} ${data['stockUnit'] ?? ''}\nKategori: ${data['category']}'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Rp${data['price']}'),
                    IconButton(
                      icon: const Icon(Icons.edit, color: Colors.blue),
                      onPressed: () => _showEditProductDialog(context, doc),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _confirmDelete(context, doc.id),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
