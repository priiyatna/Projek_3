import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AkunAdminScreen extends StatefulWidget {
  const AkunAdminScreen({Key? key}) : super(key: key);

  @override
  State<AkunAdminScreen> createState() => _AkunAdminScreenState();
}

class _AkunAdminScreenState extends State<AkunAdminScreen> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Map<String, dynamic>? userData;

  @override
  void initState() {
    super.initState();
    loadUserData();
  }

  Future<void> loadUserData() async {
    final user = auth.currentUser;
    if (user != null) {
      final doc = await firestore.collection('users').doc(user.uid).get();
      setState(() {
        userData = doc.data();
      });
    }
  }

  // Show logout confirmation dialog
  void _confirmLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Konfirmasi Logout'),
        content: const Text('Apakah Anda yakin ingin logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _logout(context);
            },
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }

  // Handle logout action
  void _logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacementNamed(context, '/login'); // Sesuaikan dengan rute login Anda
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Container(
              color: Colors.blue[100],
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Stack(
                  children: [
                    const Center(
                      child: Text(
                        'AKUN ADMIN',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Positioned(
                      right: 0,
                      child: GestureDetector(
                        onTap: () => _confirmLogout(context),
                        child: const Text('Logout', style: TextStyle(color: Colors.black)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              width: double.infinity,
              color: Colors.blue[100],
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.blue[300],
                    child: const Icon(Icons.admin_panel_settings, size: 40, color: Colors.white),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: userData == null
                  ? const Center(child: CircularProgressIndicator())
                  : ListView(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      children: [
                        buildUserInfo('Nama', userData!['name'] ?? ''),
                        buildUserInfo('Email', userData!['email'] ?? ''),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildUserInfo(String title, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: const BoxDecoration(
            border: Border(bottom: BorderSide(color: Colors.grey)),
          ),
          width: double.infinity,
          child: Text(value),
        ),
      ],
    );
  }
}
