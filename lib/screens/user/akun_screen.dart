import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'home_screen.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({Key? key}) : super(key: key);

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
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

  void _logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacementNamed(context, '/login');
  }

  Future<void> _editField(String fieldKey, String currentValue) async {
    final controller = TextEditingController(text: currentValue);

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Edit $fieldKey'),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: InputDecoration(hintText: 'Masukkan $fieldKey baru'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () async {
              final user = auth.currentUser;
              if (user != null) {
                await firestore.collection('users').doc(user.uid).update({
                  fieldKey: controller.text,
                });
                Navigator.pop(context);
                await loadUserData();
              }
            },
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
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
          'AKUN SAYA',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
        ),
        backgroundColor: const Color(0xFFBBDEFB),
        centerTitle: true,
        elevation: 2,
        actions: [
          TextButton(
            onPressed: () => _confirmLogout(context),
            child: const Text('Logout', style: TextStyle(color: Color.fromARGB(255, 255, 0, 0))),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              color: Colors.blue[100],
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.blue[300],
                    child: const Icon(Icons.person, size: 40, color: Colors.white),
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
                        buildUserInfo('Nama', userData!['name'] ?? '', fieldKey: 'name'),
                        buildUserInfo('Alamat', userData!['address'] ?? '', fieldKey: 'address'),
                        buildUserInfo('No Handphone', userData!['phone'] ?? '', fieldKey: 'phone'),
                        buildUserInfo('Email', userData!['email'] ?? ''),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildUserInfo(String title, String value, {String? fieldKey}) {
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
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  value,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (fieldKey != null)
                GestureDetector(
                  onTap: () => _editField(fieldKey, value),
                  child: const Icon(Icons.edit, size: 16),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
