import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/firestore_service.dart';

class UserProvider with ChangeNotifier {
  final FirestoreService _firestoreService = FirestoreService();

  AppUser? _currentUser;

  AppUser? get currentUser => _currentUser;

  Future<void> loadUser(String uid) async {
    _currentUser = await _firestoreService.getUserById(uid);
    notifyListeners();
  }

  Future<void> clearUser() async {
    _currentUser = null;
    notifyListeners();
  }

  Future<void> changeUserRole(String uid, String newRole) async {
    await _firestoreService.updateUserRole(uid, newRole);
    if (_currentUser?.uid == uid) {
      _currentUser = await _firestoreService.getUserById(uid);
      notifyListeners();
    }
  }
}
