import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'home_screen.dart';

class KontakKamiScreen extends StatelessWidget {
  const KontakKamiScreen({super.key});

  final String _mapsUrl =
      'https://www.google.com/maps?q=H7CQ+GJ9,+Bojongslawi,+Kec.+Lohbener,+Kabupaten+Indramayu,+Jawa+Barat+45252';

  final String _whatsappNumber = '6285722270200'; 

  Future<void> _openMap() async {
    final Uri url = Uri.parse(_mapsUrl);
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      throw 'Tidak dapat membuka Google Maps';
    }
  }

  Future<void> _openWhatsApp() async {
    final Uri url = Uri.parse('https://wa.me/$_whatsappNumber');
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      throw 'Tidak dapat membuka WhatsApp';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const HomeScreen()),
            );
          },
        ),
        title: const Text(
          'KONTAK KAMI',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xFFBBDEFB),
        centerTitle: true,
        elevation: 2,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            padding: const EdgeInsets.all(20.0),
            decoration: BoxDecoration(
              color: Colors.blue[100],
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                InkWell(
                  onTap: _openMap,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Icon(Icons.location_pin, size: 24),
                      SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'Blok Sasak dayi Desa Bojongslawi, Kecamatan Lohbener, Kabupaten Indramayu',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 16,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                InkWell(
                  onTap: _openWhatsApp,
                  child: Row(
                    children: const [
                      Icon(Icons.phone, size: 24),
                      SizedBox(width: 10),
                      Text(
                        '62857-2227-0200',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 16,
                          color: Color.fromARGB(255, 0, 0, 0),
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
