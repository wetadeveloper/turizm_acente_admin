import 'package:flutter/material.dart';
import 'package:ozel_sirket_admin/Core/constants/app_colors.dart';
import 'package:ozel_sirket_admin/Core/constants/app_strings.dart';
import 'package:ozel_sirket_admin/Features/Auth/model/user_model.dart';
import 'package:ozel_sirket_admin/Features/Auth/view/auth_login_view.dart';
import 'package:ozel_sirket_admin/Features/Auth/viewmodel/auth_register_view_model.dart';
import 'package:provider/provider.dart';

class AuthRegisterView extends StatefulWidget {
  const AuthRegisterView({super.key});

  @override
  State<AuthRegisterView> createState() => _AuthRegisterViewState();
}

class _AuthRegisterViewState extends State<AuthRegisterView> {
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    context.read<AuthRegisterViewModel>().disposeControllers();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<AuthRegisterViewModel>();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: const Text(
          AppStrings.kayitolTitle,
          style: TextStyle(
            color: AppColors.title,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: const IconThemeData(color: AppColors.icon),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: vm.nameController,
                decoration: const InputDecoration(labelText: "Ad Soyad"),
                validator: (v) =>
                    (v == null || v.isEmpty) ? "Ad soyad boş olamaz" : null,
              ),
              const SizedBox(height: 12),
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
              const SizedBox(height: 12),
              DropdownButtonFormField<UserRole>(
                initialValue: vm.role,
                decoration: const InputDecoration(labelText: "Rol Seçiniz"),
                items: const [
                  DropdownMenuItem(value: UserRole.admin, child: Text("Admin")),
                  DropdownMenuItem(
                      value: UserRole.personel, child: Text("Personel")),
                ],
                onChanged: (val) {
                  if (val != null) {
                    setState(() => vm.role = val);
                  }
                },
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
                          final success = await vm.register(context);
                          if (success && mounted && context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("Kayıt başarılı ✅")),
                            );
                            Navigator.push(context, MaterialPageRoute(
                              builder: (context) {
                                return const AuthLoginView();
                              },
                            ));
                          }
                        }
                      },
                child: vm.isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text("Kayıt Ol"),
              ),
              const SizedBox(height: 20),
              TextButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context) {
                      return const AuthLoginView();
                    },
                  ));
                },
                child: const Text("Zaten hesabın var mı? Giriş yap"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
