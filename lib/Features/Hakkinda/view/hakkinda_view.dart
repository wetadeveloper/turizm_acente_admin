import 'package:flutter/material.dart';
import 'package:ozel_sirket_admin/Core/constants/app_colors.dart';
import 'package:ozel_sirket_admin/Core/constants/app_strings.dart';
import 'package:ozel_sirket_admin/Features/Hakkinda/widgets/hakkinda_bankacard.dart';
import 'package:ozel_sirket_admin/Features/Hakkinda/widgets/hakkinda_dokumancard.dart';
import 'package:ozel_sirket_admin/Features/Hakkinda/widgets/hakkinda_sirketcard.dart';
import 'package:provider/provider.dart';

import '../viewmodel/hakkinda_view_model.dart';

class HakkindaView extends StatelessWidget {
  const HakkindaView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<HakkindaViewModel>(
      create: (_) => HakkindaViewModel()..getirHakkindaBilgileri(),
      child: Consumer<HakkindaViewModel>(
        builder: (context, viewModel, child) {
          if (viewModel.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (viewModel.hataMesaji != null) {
            return Center(child: Text(viewModel.hataMesaji!));
          }
          if (viewModel.hakkindaListesi.isEmpty) {
            return const Center(child: Text("Hakkında bilgisi bulunamadı."));
          }

          return Scaffold(
            appBar: AppBar(
              backgroundColor: AppColors.primary,
              title: const Text(
                AppStrings.hakkindaTitle,
                style: TextStyle(
                  color: AppColors.title,
                  fontWeight: FontWeight.bold,
                ),
              ),
              iconTheme: const IconThemeData(color: AppColors.icon),
            ),
            body: Builder(
              builder: (_) {
                if (viewModel.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (viewModel.hataMesaji != null) {
                  return Center(child: Text(viewModel.hataMesaji!));
                }
                if (viewModel.hakkindaListesi.isEmpty) {
                  return const Center(
                      child: Text("Hakkında bilgisi bulunamadı."));
                }

                final data = viewModel.hakkindaListesi.first;
                return ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    Center(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.asset(
                          "assets/images/logo.png",
                          width: 420,
                          height: 280,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    HakkindaSirketCard(data: data),
                    const SizedBox(height: 16),
                    if (data.bankaBilgileri.isNotEmpty)
                      HakkindaBankaCard(bankalar: data.bankaBilgileri),
                    const SizedBox(height: 16),
                    if (viewModel.dokumanlarListesi.isNotEmpty)
                      HakkindaDokumanCard(
                          dokumanlar: viewModel.dokumanlarListesi),
                  ],
                );
              },
            ),
          );
        },
      ),
    );
  }
}
