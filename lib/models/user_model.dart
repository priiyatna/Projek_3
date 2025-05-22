class AppUser {
  final String uid;
  final String name;
  final String email;
  final String phone;
  final String address;
  final String role;

  AppUser({
    required this.uid,
    required this.name,
    required this.email,
    required this.phone,
    required this.address,
    required this.role,
  });

  factory AppUser.fromMap(Map<String, dynamic> map, String uid) {
    return AppUser(
      uid: uid,
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      phone: map['phone'] ?? '',
      address: map['address'] ?? '',
      role: map['role'] ?? 'user',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'phone': phone,
      'address': address,
      'role': role,
    };
  }
}
