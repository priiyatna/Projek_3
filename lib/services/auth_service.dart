import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<User?> register({
    required String name,
    required String email,
    required String password,
    required String phone,
    required String address,
  }) async {
    final userCredential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    final uid = userCredential.user!.uid;

    final newUser = AppUser(
      uid: uid,
      name: name,
      email: email,
      phone: phone,
      address: address,
      role: 'user',
    );

    await _firestore.collection('users').doc(uid).set(newUser.toMap());

    return userCredential.user;
  }

  Future<User?> login(String email, String password) async {
    final userCredential = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return userCredential.user;
  }

  Future<void> logout() async {
    await _auth.signOut();
  }

  Stream<User?> get userChanges => _auth.authStateChanges();

  User? get currentUser => _auth.currentUser;
}
