import 'package:flutter/material.dart';
import 'package:ozel_sirket_admin/Core/constants/app_colors.dart';
import 'package:ozel_sirket_admin/Core/constants/app_strings.dart';
import 'package:ozel_sirket_admin/Features/Rezervasyonlar/model/rezervasyon_model.dart';
import 'package:ozel_sirket_admin/Features/Rezervasyonlar/viewmodel/rezervasyonlar_view_model.dart';
import 'package:provider/provider.dart';

class BorcluMusterilerView extends StatelessWidget {
  const BorcluMusterilerView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => RezervasyonlarViewModel(),
      child: Consumer<RezervasyonlarViewModel>(builder: (context, vm, _) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: AppColors.primary,
            title: const Text(
              AppStrings.rezervasyonBorcluTitle,
              style: TextStyle(
                color: AppColors.title,
                fontWeight: FontWeight.bold,
              ),
            ),
            iconTheme: const IconThemeData(color: AppColors.icon),
          ),
          body: StreamBuilder<List<RezervasyonModel>>(
            stream: vm.sadeceBorclulariGetir(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) return const CircularProgressIndicator();

              final borclular = snapshot.data!;

              if (borclular.isEmpty) {
                return const Center(child: Text("Borcu olan müşteri yok."));
              }

              return ListView.builder(
                itemCount: borclular.length,
                itemBuilder: (context, index) {
                  final rez = borclular[index];
                  return ListTile(
                    title: Text(rez.musteriAdi),
                    subtitle: Text("Tur: ${rez.turAdi}"),
                    trailing: Text(
                      "${rez.kalanUcret?.toStringAsFixed(2)} ₺",
                      style: const TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                  );
                },
              );
            },
          ),
        );
      }),
    );
  }
}
