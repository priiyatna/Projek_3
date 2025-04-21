import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return WillPopScope(
      onWillPop: () async => false, // Disable tombol back
      child: Scaffold(
        body: Column(
          children: [
            // Custom Header
            Container(
              padding: const EdgeInsets.only(top: 50, left: 16, right: 16, bottom: 16),
              decoration: BoxDecoration(
                color: Colors.blue[200],
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Stack(
                children: [
                  const Center(
                    child: Text(
                      'AKUN SAYA',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () async {
                        final confirm = await showDialog<bool>(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Konfirmasi Logout'),
                            content: const Text('Yakin ingin logout?'),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context, false),
                                child: const Text('Batal'),
                              ),
                              TextButton(
                                onPressed: () => Navigator.pop(context, true),
                                child: const Text('Logout'),
                              ),
                            ],
                          ),
                        );

                        if (confirm == true) {
                          await FirebaseAuth.instance.signOut();
                          Navigator.pushReplacementNamed(context, '/login');
                        }
                      },
                      child: const Text(
                        'Logout',
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Profile Info
            Container(
              width: double.infinity,
              color: Colors.blue[100],
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: const Column(
                children: [
                  CircleAvatar(
                    radius: 35,
                    backgroundColor: Colors.white,
                    child: Icon(Icons.person, size: 40, color: Colors.blue),
                  ),
                ],
              ),
            ),

            // Data user
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  buildInfoTile('Nama', 'Deryko'),
                  buildInfoTile('Alamat', 'Jl. Mawar No. 10, Bandung'),
                  buildInfoTile('No Handphone', '0812-3456-7890'),
                  buildInfoTile('Email', user?.email ?? '-'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildInfoTile(String label, String value) {
    return Column(
      children: [
        ListTile(
          title: Text(label),
          subtitle: Text(value),
        ),
        const Divider(height: 1),
      ],
    );
  }
}
