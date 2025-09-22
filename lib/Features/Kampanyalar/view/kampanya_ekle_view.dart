import 'package:flutter/material.dart';
import 'package:ozel_sirket_admin/Core/constants/app_colors.dart';
import 'package:ozel_sirket_admin/Core/constants/app_strings.dart';
import 'package:ozel_sirket_admin/Features/Kampanyalar/viewModel/kampanya_ekle_view_model.dart';
import 'package:ozel_sirket_admin/Features/Kampanyalar/widgets/kampanya_common_form.dart';
import 'package:provider/provider.dart';

class KampanyaEkleView extends StatefulWidget {
  const KampanyaEkleView({super.key});

  @override
  State<KampanyaEkleView> createState() => _KampanyaEkleViewState();
}

class _KampanyaEkleViewState extends State<KampanyaEkleView> {
  final _formKey = GlobalKey<FormState>();
  @override
  void dispose() {
    context.read<KampanyaEkleViewModel>().disposeControllers();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<KampanyaEkleViewModel>();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: const Text(
          AppStrings.kampanyaEkleTitle,
          style: TextStyle(
            color: AppColors.title,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: const IconThemeData(color: AppColors.icon),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                final success = await vm.kampanyaOlustur(context);
                if (!success) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: Text(vm.hataMesaji ?? 'Bilinmeyen hata')),
                    );
                  }
                }
              }
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              KampanyaForm(
                viewModel: vm,
                onSubmit: () async {
                  if (_formKey.currentState!.validate()) {
                    final basarili = await vm.kampanyaOlustur(context);
                    if (basarili && context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text("Kampanya başarıyla eklendi")),
                      );
                      Navigator.of(context).pop();
                    } else if (vm.hataMesaji != null && context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(vm.hataMesaji!)),
                      );
                    }
                  }
                },
                formKey: _formKey,
              ),
            ],
          )),
    );
  }
}
