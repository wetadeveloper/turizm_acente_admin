import 'package:flutter/material.dart';
import 'package:ozel_sirket_admin/Core/constants/app_colors.dart';
import 'package:ozel_sirket_admin/Core/constants/app_strings.dart';
import 'package:ozel_sirket_admin/Features/Musteriler/widgets/musteri_common_form.dart';
import 'package:provider/provider.dart';
import 'package:ozel_sirket_admin/Features/Musteriler/model/musteriler_model.dart';
import 'package:ozel_sirket_admin/Features/Musteriler/viewmodel/musteri_guncelle_view_model.dart';

class MusteriGuncelleView extends StatelessWidget {
  final MusteriModel musteri;

  const MusteriGuncelleView({super.key, required this.musteri});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => MusteriGuncelleViewModel(musteri: musteri),
      child: Consumer<MusteriGuncelleViewModel>(
        builder: (context, vm, _) {
          return Scaffold(
              appBar: AppBar(
                backgroundColor: AppColors.primary,
                title: const Text(
                  AppStrings.musteriGuncelleTitle,
                  style: TextStyle(
                    color: AppColors.title,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                iconTheme: const IconThemeData(color: AppColors.icon),
              ),
              body: SingleChildScrollView(
                child: Column(
                  children: [
                    MusteriForm(
                      isUpdate: true,
                      viewModel: vm,
                      onSubmit: () async {
                        final basarili = await vm.musteriGuncelle(context);
                        if (basarili && context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text("Müşteri başarıyla güncellendi")),
                          );
                          Navigator.of(context).pop();
                        } else if (vm.hataMesaji != null && context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(vm.hataMesaji!)),
                          );
                        }
                      },
                    ),
                  ],
                ),
              ));
        },
      ),
    );
  }
}
