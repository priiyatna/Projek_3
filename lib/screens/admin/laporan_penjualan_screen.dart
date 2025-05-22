import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class LaporanPenjualanScreen extends StatefulWidget {
  const LaporanPenjualanScreen({super.key});

  @override
  State<LaporanPenjualanScreen> createState() => _LaporanPenjualanScreenState();
}

class _LaporanPenjualanScreenState extends State<LaporanPenjualanScreen> {
  final NumberFormat currencyFormat = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ');
  Map<String, Map<String, dynamic>> laporan = {};
  int totalPendapatan = 0;
  int totalTransaksi = 0;

  @override
  void initState() {
    super.initState();
    _ambilDataPenjualan();
  }

  Future<void> _ambilDataPenjualan() async {
    final snapshot = await FirebaseFirestore.instance.collection('orders').get();

    Map<String, Map<String, dynamic>> dataLaporan = {};
    int pendapatan = 0;
    int transaksi = 0;

    for (var doc in snapshot.docs) {
      transaksi++;
      final data = doc.data();
      final tanggal = (data['tanggalPesan'] as Timestamp?)?.toDate();
      final produkList = List<Map<String, dynamic>>.from(data['produk'] ?? []);

      for (var produk in produkList) {
        final nama = produk['nama'] ?? 'Tidak Diketahui';
        final harga = produk['harga'] ?? 0;
        final qty = produk['quantity'] ?? 0;
        final total = harga * qty;

        if (dataLaporan.containsKey(nama)) {
          dataLaporan[nama]!['jumlah'] += qty;
          dataLaporan[nama]!['total'] += total;
        } else {
          dataLaporan[nama] = {
            'harga': harga,
            'jumlah': qty,
            'total': total,
            'tanggal': tanggal,
          };
        }


      }
    }

    setState(() {
      laporan = dataLaporan;
      totalPendapatan = pendapatan;
      totalTransaksi = transaksi;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: laporan.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Text(
                    'Laporan Penjualan',
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Text('Total Pendapatan: ${currencyFormat.format(totalPendapatan)}'),
                  Text('Jumlah Transaksi: $totalTransaksi'),
                  const SizedBox(height: 16),
                  Expanded(
                    child: ListView.builder(
                      itemCount: laporan.length,
                      itemBuilder: (context, index) {
                        final namaProduk = laporan.keys.elementAt(index);
                        final data = laporan[namaProduk]!;
                        return Card(
                          elevation: 2,
                          child: ListTile(
                            title: Text(namaProduk),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Harga Satuan: ${currencyFormat.format(data['harga'])}'),
                                Text('Jumlah Terjual: ${data['jumlah']}'),
                                Text('Total: ${currencyFormat.format(data['total'])}'),
                                if (data['tanggal'] != null)
                                  Text(
                                    'Tanggal: ${DateFormat.yMd().format(data['tanggal'])}',
                                    style: const TextStyle(fontSize: 12),
                                  ),
                              ],
                            ),
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
