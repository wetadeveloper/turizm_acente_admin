import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ozel_sirket_admin/Navbars/home_page.dart';
import 'package:ozel_sirket_admin/Features/Auth/view/auth_login_view.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  void initState() {
    super.initState();
    _checkAuth();
  }

  Future<void> _checkAuth() async {
    await Future.delayed(const Duration(seconds: 2)); // loading efekti için
    final user = FirebaseAuth.instance.currentUser;

    if (!mounted) return;

    if (user != null) {
      // Kullanıcı login → role Firestore’dan da çekilebilir
      Navigator.push(context, MaterialPageRoute(
        builder: (context) {
          return const HomePage();
        },
      ));
    } else {
      // Kullanıcı login değil → login sayfasına
      Navigator.push(context, MaterialPageRoute(
        builder: (context) {
          return const AuthLoginView();
        },
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
