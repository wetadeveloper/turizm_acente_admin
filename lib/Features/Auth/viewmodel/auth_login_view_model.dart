import 'package:flutter/material.dart';
import 'package:ozel_sirket_admin/Features/Auth/services/auth_services.dart';
import 'package:ozel_sirket_admin/Features/Auth/viewmodel/base_auth_view_model.dart';

class AuthLoginViewModel extends BaseAuthViewModel {
  final AuthService _authService = AuthService();

  Future<bool> login(BuildContext context) async {
    try {
      setLoading(true);
      final email = emailController.text.trim();
      final password = passwordController.text.trim();

      if (email.isEmpty || password.isEmpty) {
        setHataMesaji("Email ve şifre boş olamaz");
        setLoading(false);
        return false;
      }

      final user =
          await _authService.loginUser(email: email, password: password);

      if (user != null) {
        setLoading(false);
        return true;
      } else {
        setHataMesaji("Giriş başarısız");
        setLoading(false);
        return false;
      }
    } catch (e) {
      setHataMesaji("Giriş hatası: $e");
      setLoading(false);
      return false;
    }
  }
}
