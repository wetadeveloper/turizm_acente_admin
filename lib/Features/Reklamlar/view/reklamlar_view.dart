import 'package:flutter/material.dart';
import 'package:ozel_sirket_admin/Core/constants/app_colors.dart';
import 'package:ozel_sirket_admin/Core/constants/app_strings.dart';
import 'package:ozel_sirket_admin/Navbars/bottom_navbar_widget.dart';
import 'package:ozel_sirket_admin/Features/Reklamlar/view/reklam_ekle_view.dart';
import 'package:ozel_sirket_admin/Features/Reklamlar/view/reklam_kategori_detay_view.dart';
import 'package:provider/provider.dart';
import '../../../Features/Reklamlar/viewModel/reklamlar_view_model.dart';
import '../model/reklam_model.dart';

class ReklamlarView extends StatelessWidget {
  const ReklamlarView({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamProvider<Map<String, List<ReklamModel>>>.value(
      value: ReklamlarViewModel.reklamKategorileriniDinle(),
      initialData: const {},
      catchError: (_, error) {
        debugPrint("Stream hata: $error");
        return {};
      },
      child: const _ReklamlarViewContent(),
    );
  }
}

class _ReklamlarViewContent extends StatelessWidget {
  const _ReklamlarViewContent();

  @override
  Widget build(BuildContext context) {
    final tumReklamlar = Provider.of<Map<String, List<ReklamModel>>>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.reklamlarTitle,
            style:
                TextStyle(color: AppColors.title, fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: AppColors.primary,
        iconTheme: const IconThemeData(color: AppColors.icon),
      ),
      bottomNavigationBar: const BottomNavBarWidget(index: 2),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const ReklamEkleView()),
          );
        },
        tooltip: 'Yeni Reklam Ekle',
        child: const Icon(Icons.add),
      ),
      body: tumReklamlar.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: tumReklamlar.length,
              itemBuilder: (context, index) {
                final kategori = tumReklamlar.entries.elementAt(index);
                final dokumanAdi = kategori.key;
                final reklamListesi = kategori.value;

                return ListTile(
                  title: Text(dokumanAdi,
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text('${reklamListesi.length} reklam'),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => KategoriDetayView(
                          dokumanAdi: dokumanAdi,
                        ),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}
