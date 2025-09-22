import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ozel_sirket_admin/Features/Auth/model/user_model.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Kullanıcı kaydı (Admin veya Personel)
  Future<UserModel?> registerUser({
    required String email,
    required String password,
    required String adSoyad,
    UserRole role = UserRole.personel,
  }) async {
    try {
      // Firebase Auth ile kayıt
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);

      final uid = result.user!.uid;

      // Firestore'a kaydet
      UserModel user = UserModel(
        uid: uid,
        email: email,
        adSoyad: adSoyad,
        role: role,
        olusturmaTarihi: DateTime.now(),
      );

      await _firestore.collection("users").doc(uid).set(user.toMap());

      return user;
    } on FirebaseAuthException catch (e) {
      throw Exception("Kayıt Hatası: ${e.message}");
    }
  }

  /// Kullanıcı girişi
  Future<UserModel?> loginUser({
    required String email,
    required String password,
  }) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);

      final uid = result.user!.uid;
      return await getUserData(uid);
    } on FirebaseAuthException catch (e) {
      throw Exception("Giriş Hatası: ${e.message}");
    }
  }

  /// Kullanıcı verilerini Firestore'dan çek
  Future<UserModel?> getUserData(String uid) async {
    try {
      final doc = await _firestore.collection("users").doc(uid).get();
      if (doc.exists) {
        return UserModel.fromMap(doc.data()!);
      }
      return null;
    } catch (e) {
      throw Exception("Kullanıcı verisi alınamadı: $e");
    }
  }

  /// Şu an oturum açmış kullanıcı
  User? get currentUser => _auth.currentUser;

  /// Çıkış
  Future<void> signOut() async {
    await _auth.signOut();
  }
}
