import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ozel_sirket_admin/Features/Auth/view/auth_login_view.dart';

class AuthCikisView extends StatelessWidget {
  const AuthCikisView({super.key});

  Future<void> _signOut(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      if (context.mounted) {
        // Çıkış başarılı → login sayfasına yönlendir
        Navigator.push(context, MaterialPageRoute(
          builder: (context) {
            return const AuthLoginView(); // Buraya giriş sayfasını ekleyin
          },
        ));
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Çıkış hatası: $e")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Çıkış Yap"),
      content: const Text("Çıkış yapmak istediğinize emin misiniz?"),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("İptal"),
        ),
        ElevatedButton(
          onPressed: () => _signOut(context),
          style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
          child: const Text("Çıkış Yap"),
        ),
      ],
    );
  }
}
