import 'package:flutter/material.dart';
import 'package:ozel_sirket_admin/Core/constants/app_colors.dart';
import 'package:ozel_sirket_admin/Core/constants/app_strings.dart';
import 'package:ozel_sirket_admin/Navbars/bottom_navbar_widget.dart';
import 'package:ozel_sirket_admin/Features/Kampanyalar/model/kampanya_model.dart';
import 'package:ozel_sirket_admin/Features/Kampanyalar/view/kampanya_ekle_view.dart';
import 'package:ozel_sirket_admin/Features/Kampanyalar/view/kampanya_guncelle_view.dart';
import 'package:ozel_sirket_admin/Features/Kampanyalar/viewModel/base_kampanya_view_model.dart';

class KampanyalarView extends StatelessWidget {
  const KampanyalarView({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text(AppStrings.kampanyaTitle,
              style: TextStyle(
                  color: AppColors.title, fontWeight: FontWeight.bold)),
          centerTitle: true,
          backgroundColor: AppColors.primary,
          iconTheme: const IconThemeData(color: AppColors.icon),
        ),
        bottomNavigationBar: const BottomNavBarWidget(index: 1),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const KampanyaEkleView()),
            );
          },
          child: const Icon(Icons.add),
        ),
        body: StreamBuilder<List<KampanyaModel>>(
          stream: BaseKampanyaViewModel.kampanyalarStream(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(child: Text('Hata: ${snapshot.error}'));
            }

            final kampanyalar = snapshot.data ?? [];

            if (kampanyalar.isEmpty) {
              return const Center(child: Text('Hiç kampanya yok.'));
            }

            return ListView.builder(
              itemCount: kampanyalar.length,
              itemBuilder: (context, index) {
                final kampanya = kampanyalar[index];
                return ListTile(
                  title: Text(kampanya.baslik),
                  subtitle: Text(kampanya.aciklama),
                  trailing: IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => KampanyaGuncelleView(
                            kampanyaId: kampanya.kampanyaId,
                            kampanya: kampanya,
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
