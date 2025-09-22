import 'package:cloud_firestore/cloud_firestore.dart';

enum UserRole { admin, personel }

class UserModel {
  final String uid;
  final String email;
  final String? adSoyad;
  final UserRole role;
  final DateTime olusturmaTarihi;

  UserModel({
    required this.uid,
    required this.email,
    this.adSoyad,
    required this.role,
    required this.olusturmaTarihi,
  });

  /// Firestore'a kaydetmek için Map dönüşümü
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'adSoyad': adSoyad,
      'role': role.name,
      'olusturmaTarihi': olusturmaTarihi.toIso8601String(),
    };
  }

  /// Firestore'dan çekmek için
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] ?? '',
      email: map['email'] ?? '',
      adSoyad: map['adSoyad'],
      role: (map['role'] ?? 'personel') == 'admin'
          ? UserRole.admin
          : UserRole.personel,
      olusturmaTarihi: map['olusturmaTarihi'] != null
          ? DateTime.parse(map['olusturmaTarihi'])
          : DateTime.now(),
    );
  }

  /// Firestore snapshot'tan
  factory UserModel.fromSnapshot(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return UserModel.fromMap(data);
  }
}
