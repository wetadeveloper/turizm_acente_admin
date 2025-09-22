import 'package:flutter/material.dart';
import 'package:ozel_sirket_admin/Core/constants/app_colors.dart';
import 'package:ozel_sirket_admin/Core/constants/app_strings.dart';
import 'package:ozel_sirket_admin/Features/Musteriler/model/musteriler_model.dart';
import 'package:ozel_sirket_admin/Features/Musteriler/view/musteri_ekle_view.dart';
import 'package:ozel_sirket_admin/Features/Musteriler/view/musteri_guncelle_view.dart';
import 'package:ozel_sirket_admin/Features/Musteriler/viewmodel/musteriler_view_model.dart';
import 'package:ozel_sirket_admin/Features/Musteriler/widgets/musteri_card.dart';
import 'package:provider/provider.dart';

class MusterilerView extends StatelessWidget {
  const MusterilerView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => MusterilerViewModel(),
      child: Consumer<MusterilerViewModel>(
        builder: (context, vm, _) {
          return Scaffold(
            appBar: AppBar(
              title: const Text(AppStrings.musterilerTitle,
                  style: TextStyle(
                      color: AppColors.title, fontWeight: FontWeight.bold)),
              centerTitle: true,
              backgroundColor: AppColors.primary,
              iconTheme: const IconThemeData(color: AppColors.icon),
            ),
            body: StreamBuilder<List<MusteriModel>>(
              stream: MusterilerViewModel.musterileriDinle(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text("Hiç müşteri yok."));
                }

                final musteriler = snapshot.data!;
                return ListView.builder(
                  itemCount: musteriler.length,
                  itemBuilder: (context, index) {
                    final musteri = musteriler[index];
                    return MusteriCard(
                      musteri: musteri,
                      index: index,
                      onDelete: () => vm.musteriSil(musteri.musteriId),
                      onUpdate: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                MusteriGuncelleView(musteri: musteri),
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const MusteriEkleView()),
                );
              },
              child: const Icon(Icons.add),
            ),
          );
        },
      ),
    );
  }
}
