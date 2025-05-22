import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ManageUsersScreen extends StatelessWidget {
  const ManageUsersScreen({super.key});

  void _confirmDelete(BuildContext context, String userId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Konfirmasi Hapus'),
        content: const Text('Apakah Anda yakin ingin menghapus pengguna ini?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await FirebaseFirestore.instance.collection('users').doc(userId).delete();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Pengguna berhasil dihapus')),
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
      appBar: AppBar(title: const Text('Kelola Pengguna')),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('users').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());

          final users = snapshot.data!.docs;

          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              final doc = users[index];
              final data = doc.data() as Map<String, dynamic>;

              return ListTile(
                leading: const Icon(Icons.person),
                title: Text(data['name'] ?? 'Tanpa Nama'),
                subtitle: Text(data['email'] ?? 'Tanpa Email'),
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => _confirmDelete(context, doc.id),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
