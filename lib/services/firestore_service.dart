import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<AppUser?> getUserById(String uid) async {
    final doc = await _firestore.collection('users').doc(uid).get();
    if (doc.exists) {
      return AppUser.fromMap(doc.data()!, doc.id);
    }
    return null;
  }

  Future<List<AppUser>> getAllUsers() async {
    final snapshot = await _firestore.collection('users').get();
    return snapshot.docs.map((doc) => AppUser.fromMap(doc.data(), doc.id)).toList();
  }

  Future<void> updateUserRole(String uid, String role) async {
    await _firestore.collection('users').doc(uid).update({'role': role});
  }

  Future<void> deleteUser(String uid) async {
    await _firestore.collection('users').doc(uid).delete();
  }
}
