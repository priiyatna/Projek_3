import 'package:flutter/material.dart';
import 'checkout_screen.dart';

class KeranjangScreen extends StatefulWidget {
  const KeranjangScreen({super.key});

  @override
  State<KeranjangScreen> createState() => _KeranjangScreenState();
}

class _KeranjangScreenState extends State<KeranjangScreen> {
  List<Map<String, dynamic>> keranjang = [
  {'nama': 'MINYAK GORENG CURAH', 'berat': '1 kg', 'harga': 20000, 'selected': false, 'gambar': 'assets/minyak.jpg'},
  {'nama': 'GULA PASIR CURAH', 'berat': '1 kg', 'harga': 18000, 'selected': false, 'gambar': 'assets/gula.jpg'},
  {'nama': 'TEPUNG SEGITIGA BIRU', 'berat': '1 kg', 'harga': 12000, 'selected': false, 'gambar': 'assets/terigu.jpg'},
  {'nama': 'TEPUNG MAIZENAKU', 'berat': '100 gr', 'harga': 5000, 'selected': false, 'gambar': 'assets/maizena.jpg'},
  {'nama': 'GULA MERAH', 'berat': '1 kg', 'harga': 15000, 'selected': false, 'gambar': 'assets/gulamerah.jpg'},
  ];


  int getTotalHarga() {
    return keranjang
        .where((item) => item['selected'] == true)
        .fold<int>(0, (total, item) => total + (item['harga'] as int));
  }

  int getSelectedCount() {
    return keranjang.where((item) => item['selected'] == true).length;
  }

  void updateSelection(int index, bool? value) {
    setState(() {
      keranjang[index]['selected'] = value ?? false;
    });
  }

  void navigateToCheckout() {
    List<Map<String, dynamic>> selectedItems = keranjang
        .where((item) => item['selected'] == true)
        .toList();

    if (selectedItems.isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CheckoutScreen(produkDipesan: selectedItems),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('KERANJANG', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.blue[200],
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: keranjang.length,
              itemBuilder: (context, index) {
                final item = keranjang[index];
                return Column(
                  children: [
                    ListTile(
                      leading: Checkbox(
                        value: item['selected'],
                        onChanged: (bool? value) {
                          updateSelection(index, value);
                        },
                        activeColor: Colors.blue,
                      ),
                      title: Text(
                        item['nama'],
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(item['berat']),
                          Text(
                            'Rp ${item['harga'].toString()}',
                            style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
                          ),
                        ],
                      ),
                      trailing: const Text(
                        'Ubah',
                        style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const Divider(),
                  ],
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border(top: BorderSide(color: Colors.grey.shade300)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total Rp${getTotalHarga()}',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blue),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  onPressed: getSelectedCount() > 0 ? navigateToCheckout : null,
                  child: Text(
                    'Checkout (${getSelectedCount()})',
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
