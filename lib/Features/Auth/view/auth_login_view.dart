import 'package:flutter/material.dart';
import 'package:ozel_sirket_admin/Core/constants/app_colors.dart';
import 'package:ozel_sirket_admin/Core/constants/app_strings.dart';
import 'package:ozel_sirket_admin/Navbars/home_page.dart';
import 'package:ozel_sirket_admin/Features/Auth/viewmodel/auth_login_view_model.dart';
import 'package:provider/provider.dart';

class AuthLoginView extends StatefulWidget {
  const AuthLoginView({super.key});

  @override
  State<AuthLoginView> createState() => _AuthLoginViewState();
}

class _AuthLoginViewState extends State<AuthLoginView> {
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    context.read<AuthLoginViewModel>().disposeControllers();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<AuthLoginViewModel>();

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.primary,
        title: const Text(
          AppStrings.girisyapTitle,
          style: TextStyle(
            color: AppColors.title,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: const IconThemeData(color: AppColors.icon),
        centerTitle: true,
      ),
      body: PopScope(
        canPop: false,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.asset(
                      "assets/images/logo.png",
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: vm.emailController,
                  decoration: const InputDecoration(labelText: "Email"),
                  validator: (v) =>
                      (v == null || v.isEmpty) ? "Email boş olamaz" : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: vm.passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(labelText: "Şifre"),
                  validator: (v) =>
                      (v == null || v.isEmpty) ? "Şifre boş olamaz" : null,
                ),
                const SizedBox(height: 20),
                if (vm.hataMesaji != null)
                  Text(
                    vm.hataMesaji!,
                    style: const TextStyle(color: Colors.red),
                  ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: vm.isLoading
                      ? null
                      : () async {
                          if (_formKey.currentState!.validate()) {
                            final success = await vm.login(context);
                            if (success && mounted && context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text("Giriş başarılı ✅")),
                              );
                              Navigator.push(context, MaterialPageRoute(
                                builder: (context) {
                                  return const HomePage();
                                },
                              ));
                            }
                          }
                        },
                  child: vm.isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text("Giriş Yap"),
                ),
                const SizedBox(height: 20),
                /*
                TextButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) {
                        return const AuthRegisterView();
                      },
                    ));
                  },
                  child: const Text("Hesabın yok mu? Kayıt ol"),
                )
                */
              ],
            ),
          ),
        ),
      ),
    );
  }
}
