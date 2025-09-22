import 'package:flutter/material.dart';
import 'package:ozel_sirket_admin/Features/Auth/model/user_model.dart';
import 'package:ozel_sirket_admin/Features/Auth/services/auth_services.dart';
import 'package:ozel_sirket_admin/Features/Auth/viewmodel/base_auth_view_model.dart';

class AuthRegisterViewModel extends BaseAuthViewModel {
  final AuthService _authService = AuthService();

  final TextEditingController nameController = TextEditingController();
  UserRole role = UserRole.personel; // varsayılan rol

  Future<bool> register(BuildContext context) async {
    try {
      setLoading(true);
      final email = emailController.text.trim();
      final password = passwordController.text.trim();
      final name = nameController.text.trim();

      if (email.isEmpty || password.isEmpty || name.isEmpty) {
        setHataMesaji("Tüm alanlar doldurulmalıdır");
        setLoading(false);
        return false;
      }

      final user = await _authService.registerUser(
          email: email, password: password, role: role, adSoyad: name);

      if (user != null) {
        setLoading(false);
        return true;
      } else {
        setHataMesaji("Kayıt başarısız");
        setLoading(false);
        return false;
      }
    } catch (e) {
      setHataMesaji("Kayıt hatası: $e");
      setLoading(false);
      return false;
    }
  }

  @override
  void disposeControllers() {
    super.disposeControllers();
    nameController.dispose();
  }
}
